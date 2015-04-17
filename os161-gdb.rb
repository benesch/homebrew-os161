class Os161Gdb < Formula
  homepage "http://www.eecs.harvard.edu/~dholland/os161/"
  url "http://www.eecs.harvard.edu/~dholland/os161/download/gdb-7.8+os161-2.1.tar.gz"
  version "7.8+os161-2.1"
  sha256 "1c16e2d83b3bfe52e8133e3c3a7d1f083b2d010fe1c107a78ede6439b1b1fe61"

  bottle do
    root_url "http://dl.bintray.com/benesch/homebrew-os161"
    sha256 "aaa3a37d2a99da2ebf171f108f4af964bf3d7c5fb95b2e57b96e5e9ad6443ba5" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "readline"

  patch :DATA

  def install
    args = [
      "--prefix=#{prefix}",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--with-python=/usr",
      "--target=mips-harvard-os161",
    ]

    system "./configure", *args
    system "make"
    system "make", "install"

    # Remove conflicting items with binutils and stock GDB.
    rm_rf include
    rm_rf lib
    rm_rf share/"info"
    rm_rf share/"locale"
    rm_rf share/"man"
  end

  def caveats; <<-EOS.undent
    gdb was installed as mips-harvard-os161-gdb; you may wish to set a
    shorter shell alias:

      echo alias os161-gdb=mips-harvard-os161-gdb >> ~/.bash_profile
    EOS
  end
end
__END__
diff --git a/sim/common/sim-arange.h b/sim/common/sim-arange.h
index 73117f3..de842c9 100644
--- a/sim/common/sim-arange.h
+++ b/sim/common/sim-arange.h
@@ -60,22 +60,26 @@ extern void sim_addr_range_delete (ADDR_RANGE * /*ar*/,
           address_word /*start*/,
           address_word /*end*/);
 
+/* TODO: This should get moved into sim-inline.h.  */
+#ifdef HAVE_INLINE
+#ifdef SIM_ARANGE_C
+#define SIM_ARANGE_INLINE INLINE
+#else
+#define SIM_ARANGE_INLINE EXTERN_INLINE
+#endif
+#else
+#define SIM_ARANGE_INLINE EXTERN
+#endif
+
 /* Return non-zero if ADDR is in range AR, traversing the entire tree.
    If no range is specified, that is defined to mean "everything".  */
-extern INLINE int
+SIM_ARANGE_INLINE int
 sim_addr_range_hit_p (ADDR_RANGE * /*ar*/, address_word /*addr*/);
 #define ADDR_RANGE_HIT_P(ar, addr) \
   ((ar)->range_tree == NULL || sim_addr_range_hit_p ((ar), (addr)))
 
 #ifdef HAVE_INLINE
-#ifdef SIM_ARANGE_C
-#define SIM_ARANGE_INLINE INLINE
-#else
-#define SIM_ARANGE_INLINE EXTERN_INLINE
-#endif
 #include "sim-arange.c"
-#else
-#define SIM_ARANGE_INLINE
 #endif
 #define SIM_ARANGE_C_INCLUDED
 
diff --git a/sim/common/sim-inline.h b/sim/common/sim-inline.h
index af75562..8a9c286 100644
--- a/sim/common/sim-inline.h
+++ b/sim/common/sim-inline.h
@@ -303,7 +303,9 @@
 /* ??? Temporary, pending decision to always use extern inline and do a vast
    cleanup of inline support.  */
 #ifndef INLINE2
-#if defined (__GNUC__)
+#if defined (__GNUC_GNU_INLINE__) || defined (__GNUC_STDC_INLINE__)
+#define INLINE2 __inline__ __attribute__ ((__gnu_inline__))
+#elif defined (__GNUC__)
 #define INLINE2 __inline__
 #else
 #define INLINE2 /*inline*/
