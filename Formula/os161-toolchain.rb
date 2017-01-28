class Os161Toolchain < Formula
  homepage "http://os161.eecs.harvard.edu/"
  url "http://dl.bintray.com/benesch/bottles-os161/empty.tar"
  version "1.0.0"
  sha256 "5f70bf18a086007016e948b04aed3b82103a36bea41755b6cddfaf10ace3c6ef"
  revision 1

  depends_on "bmake"
  depends_on "os161-gcc"
  depends_on "os161-gdb"
  depends_on "sys161"

  def install
    # Homebrew forbids empty installs, so we create a dummy file to fool it.
    touch prefix/"stamp"
  end

  test do
    mkdir "src" do
      system "curl http://os161.eecs.harvard.edu/download/os161-base-2.0.2.tar.gz | tar x --strip=1"
      system "./configure", "--ostree=#{testpath}/root"
      system "bmake"
      system "bmake", "install"
      Dir.chdir "kern/conf" do
        system "./config", "DUMBVM"
      end
      Dir.chdir "kern/compile/DUMBVM" do
        system "bmake", "depend"
        system "bmake"
        system "bmake", "install"
      end
    end
    Dir.chdir "root" do
      cp "#{Formula["sys161"].share}/examples/sys161/sys161.conf.sample", "sys161.conf"
      system "disk161", "create", "LHD0.img", "5M"
      system "disk161", "create", "LHD1.img", "5M"
      system "sys161", "-X", "kernel", "km1; q"
    end
  end
end
