module PACKMAN
  class CompilerSet
    attr_reader :command_hash, :info

    def initialize command_hash
      @command_hash = command_hash
      # Expand compiler commands for the compiler installed by packman.
      if command_hash.has_key? 'installed_by_packman'
        compiler_name = command_hash['installed_by_packman'].capitalize
        if not Package.defined? compiler_name
          CLI.report_error "Unknown PACKMAN installed compiler #{CLI.red compiler_name}!"
        end
        compiler_package = Package.instance compiler_name
        prefix = PACKMAN.prefix compiler_package
        compiler_package.provided_stuffs.each do |language, compiler|
          if ['c', 'c++', 'fortran'].include? language
            # User can overwrite the compiler.
            if not command_hash.has_key? language
               command_hash[language] = "#{prefix}/bin/#{compiler}"
            end
          end
        end
      end
      # Set the specification for the compilers of each language (they may come
      # from different vendors).
      @info = {}
      command_hash.each do |language, compiler_command|
        if language == 'installed_by_packman'
          @info[:installed_by_packman] = Package.instance compiler_command.capitalize.to_sym
          next
        end
        if language =~ /^mpi_(c|c\+\+|fortran)/
          # Let users choose the MPI wrapper.
          actual_language = language.gsub 'mpi_', ''
          @info[actual_language] ||= {}
          if not PACKMAN.does_command_exist? compiler_command
            CLI.report_error "MPI wrapper #{CLI.red compiler_command} does not exist!"
          end
          @info[actual_language][:mpi_wrapper] = `which #{compiler_command}`.chomp
        else
          @info[language] ||= {}
          @info[language][:command] = `which #{compiler_command}`.chomp
          @info[language][:spec] = CompilerManager.compiler_spec language, compiler_command
        end
      end
    end
  end
end
