class Sys161 < Formula
  homepage "http://os161.eecs.harvard.edu/#sys161"
  url "http://os161.eecs.harvard.edu/download/sys161-2.0.5.tar.gz"
  sha256 "6c8b98805af900564c4f3ebb4a9dff826db1c82bf3df6faa977ff68f64008936"

  bottle do
    root_url "http://dl.bintray.com/benesch/homebrew-os161"
    cellar :any_skip_relocation
    sha256 "62bf9c6e683c9cacdb2d4c12f7f5929f5cb9048b686d4dedfa933d080767a346" => :el_capitan
  end

  patch :DATA

  def install
    system "./configure", "--prefix=#{prefix}", "mipseb"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/sys161"
  end
end
__END__
--- a/main/util.c 2016-01-17 18:07:30.000000000 -0500
+++ b/main/util.c 2016-01-17 18:07:33.000000000 -0500
@@ -1,3 +1,4 @@
+#include <sys/types.h>
 #include <stdlib.h>
 #include <string.h>
 #include <ctype.h>
