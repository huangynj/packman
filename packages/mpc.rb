class Mpc < PACKMAN::Package
  url 'http://ftpmirror.gnu.org/mpc/mpc-1.0.2.tar.gz'
  sha1 '5072d82ab50ec36cc8c0e320b5c377adb48abe70'
  version '1.0.2'

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --with-gmp=#{Gmp.prefix}
      --with-mpfr=#{Mpfr.prefix}
    ]
    PACKMAN.run './configure', *args
    PACKMAN.run 'make'
    PACKMAN.run 'make check' if not skip_test?
    PACKMAN.run 'make install'
  end
end
