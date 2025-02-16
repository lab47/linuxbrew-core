class Elfutils < Formula
  desc "Libraries and utilities for handling ELF objects"
  homepage "https://fedorahosted.org/elfutils/"
  url "https://sourceware.org/elfutils/ftp/0.185/elfutils-0.185.tar.bz2"
  sha256 "dc8d3e74ab209465e7f568e1b3bb9a5a142f8656e2b57d10049a73da2ae6b5a6"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later", "LGPL-2.0-only"]

  bottle do
    sha256 x86_64_linux: "ce01b01cd668db7abb2afd19e97911e2a52dd8009cf2ac538dabc9591fb181bb"
  end

  depends_on "m4" => :build
  depends_on "bzip2"
  depends_on :linux
  depends_on "xz"
  depends_on "zlib"

  conflicts_with "libelf", because: "both install `libelf.a` library"

  def install
    system "./configure",
           "--disable-debug",
           "--disable-dependency-tracking",
           "--disable-silent-rules",
           "--disable-libdebuginfod",
           "--disable-debuginfod",
           "--program-prefix=elfutils-",
           "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "elf_kind", shell_output("#{bin}/elfutils-nm #{bin}/elfutils-nm")
  end
end
