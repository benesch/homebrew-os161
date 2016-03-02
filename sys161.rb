class Sys161 < Formula
  homepage "http://os161.eecs.harvard.edu/#sys161"
  url "http://os161.eecs.harvard.edu/download/sys161-2.0.8.tar.gz"
  sha256 "5a642090c51da2f0d192bc4520d69aae262223abdcbf9d1d704f21ae6fd91b26"

  bottle do
    root_url "http://dl.bintray.com/benesch/homebrew-os161"
    cellar :any_skip_relocation
    sha256 "741bd053af862b8bc81f1457f74f41ea465b10f4b9caf5321b36c3a9b587eb1c" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}", "mipseb"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/sys161"
  end
end
