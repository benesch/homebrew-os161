class Os161Gcc < Formula
  homepage "http://os161.eecs.harvard.edu/"
  url "http://os161.eecs.harvard.edu/download/gcc-4.8.3+os161-2.1.tar.gz"
  version "4.8.3+os161-2.1"
  sha256 "070659d14ab6f905e9df89891b78f9e052c114e0c4d011c630b2f07788d0359e"

  bottle do
    root_url "http://dl.bintray.com/benesch/homebrew-os161"
    sha256 "e9e5913ffe217c410dc20a57e4835cbb1c004b0adf411146a1fac23b6bb3e8ad" => :el_capitan
  end

  depends_on "os161-binutils"
  depends_on "gmp@4"
  depends_on "libmpc@0.8"
  depends_on "mpfr@2"
  depends_on "isl@0.12"
  depends_on "cloog"

  def install
    args = [
      "--prefix=#{prefix}",
      "--libdir=#{lib}/gcc/#{version}",
      "--enable-languages=c",
      "--with-mpc=#{Formula["libmpc@0.8"].opt_prefix}",
      "--with-gmp=#{Formula["gmp@4"].opt_prefix}",
      "--with-mpfr=#{Formula["mpfr@2"].opt_prefix}",
      "--with-mpc=#{Formula["libmpc@0.8"].opt_prefix}",
      "--with-isl=#{Formula["isl@0.12"].opt_prefix}",
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

      system "../configure", *args
      system "make"
      system "make", "install"
    end

    # Even when suffixes are appended, the info pages conflict when
    # install-info is run. TODO fix this.
    info.rmtree
  end
end
