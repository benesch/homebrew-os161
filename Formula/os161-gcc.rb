class Os161Gcc < Formula
  homepage "http://os161.eecs.harvard.edu/"
  url "http://os161.eecs.harvard.edu/download/gcc-4.8.3+os161-2.1.tar.gz"
  version "4.8.3-os161-2.1"
  sha256 "070659d14ab6f905e9df89891b78f9e052c114e0c4d011c630b2f07788d0359e"
  revision 3

  depends_on "os161-binutils"
  depends_on "gmp"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "cloog"

  resource "isl" do
    url "https://gcc.gnu.org/pub/gcc/infrastructure/isl-0.12.2.tar.bz2"
    mirror "http://isl.gforge.inria.fr/isl-0.12.2.tar.bz2"
    sha256 "f4b3dbee9712850006e44f0db2103441ab3d13b406f77996d1df19ee89d11fb4"
  end

  def install
    args = [
      "--prefix=#{prefix}",
      "--libdir=#{lib}/gcc/#{version}",
      "--enable-languages=c",
      "--with-gmp=#{Formula["gmp"].opt_prefix}",
      "--with-mpfr=#{Formula["mpfr"].opt_prefix}",
      "--with-mpc=#{Formula["libmpc"].opt_prefix}",
      "--with-cloog=#{Formula["cloog"].opt_prefix}",
      "--with-system-zlib",
      "--enable-checking=release",
      "--enable-lto",
      "--disable-werror",
      "--disable-shared",
      "--disable-threads",
      "--disable-libmudflap",
      "--disable-libssp",
      "--disable-nls",
      "--target=mips-harvard-os161",
      "--with-as=#{Formula["os161-binutils"].bin}/mips-harvard-os161-as",
      "--with-ld=#{Formula["os161-binutils"].bin}/mips-harvard-os161-ld",
      "--with-pkgversion=Homebrew OS161 #{name} #{pkg_version} #{build.used_options*" "}".strip,
      "--with-bugurl=https://github.com/benesch/homebrew-os161/issues",
    ]

    mkdir "build" do
      unless MacOS::CLT.installed?
        # For Xcode-only systems, we need to tell the sysroot path.
        # "native-system-header's will be appended
        args << "--with-native-system-header-dir=/usr/include"
        args << "--with-sysroot=#{MacOS.sdk_path}"
      end

      resources.each { |r| r.stage(buildpath/r.name) }

      system "../configure", *args
      system "make"
      system "make", "install"
    end

    # Even when suffixes are appended, the info pages conflict when
    # install-info is run. TODO fix this.
    info.rmtree
  end
end
