class Cogl < Formula
  desc "Low level OpenGL abstraction library developed for Clutter"
  homepage "https://developer.gnome.org/cogl/"
  url "https://download.gnome.org/sources/cogl/1.22/cogl-1.22.8.tar.xz"
  sha256 "a805b2b019184710ff53d0496f9f0ce6dcca420c141a0f4f6fcc02131581d759"
  license all_of: ["MIT", "SGI-B-2.0", "BSD-3-Clause", :public_domain]

  bottle do
    sha256 arm64_big_sur: "9a487a4bf7fbe5fdec29d902ba668fe20cbbc05e66864cb8d9c5fe564373e586"
    sha256 big_sur:       "ec1ef03d2e1e855ae5277a2f599fb7ed83c221f0ae29d8c8a5f45277be96d869"
    sha256 catalina:      "37fdd46a2845adf0e8f4ce85d5a80384ea235e435ef5f42167622f5224e4e51f"
    sha256 mojave:        "eb37baaa178631afac43c8bb1c93cdf9b78dd7d44862c63dec598d54a51b201e"
    sha256 high_sierra:   "46de52386a1123e828d94598279a99a88e3819d8f1dac1a51f39850a321ff7f2"
    sha256 x86_64_linux:  "a99fbbe280a27912c5e78923d97ce94ed9166497909343a0e697848d9954ee65"
  end

  head do
    url "https://gitlab.gnome.org/GNOME/cogl.git"
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "pango"

  on_linux do
    depends_on "libxcomposite"
    depends_on "mesa"
  end

  def install
    # Don't dump files in $HOME.
    ENV["GI_SCANNER_DISABLE_CACHE"] = "yes"

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-cogl-pango=yes
      --enable-introspection=yes
    ]

    on_macos do
      args << "--disable-glx"
      args << "--without-x"
    end

    on_linux do
      args << "--enable-xlib-egl-platform=yes"
    end

    system "./configure", *args
    system "make", "install"
  end
  test do
    (testpath/"test.c").write <<~EOS
      #include <cogl/cogl.h>

      int main()
      {
          CoglColor *color = cogl_color_new();
          cogl_color_free(color);
          return 0;
      }
    EOS
    system ENV.cc, "-I#{include}/cogl",
           "-I#{Formula["glib"].opt_include}/glib-2.0",
           "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
           testpath/"test.c", "-o", testpath/"test",
           "-L#{lib}", "-lcogl"
    system "./test"
  end
end
