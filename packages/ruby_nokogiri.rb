class Ruby_nokogiri < PACKMAN::Package
  url PACKMAN.gem_source+'nokogiri-1.6.6.2.gem'
  sha1 'd05f23c90be242d7e1bff447874e75207c36a207'
  version '1.6.6.2'

  label 'use_system_first'
  label 'no_bashrc'

  # TODO: Should check if Ruby is above 2.0.0.
  depends_on 'libxml2'
  depends_on 'libxslt'

  def install
    PACKMAN.gem "install nokogiri-#{version}.gem -- --use-system-libraries "+
      "--with-xml2-include=#{Libxml2.include}/libxml2 --with-xml2-lib=#{Libxml2.lib} "+
      "--with-xslt-include=#{Libxslt.include} --with-xslt-lib=#{Libxslt.lib}"
  end

  def remove
    PACKMAN.gem 'uninstall -x nokogiri'
  end

  def installed?
    PACKMAN.is_gem_installed? 'nokogiri', version
  end
end