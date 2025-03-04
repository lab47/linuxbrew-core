class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "https://pocoproject.org/"
  url "https://pocoproject.org/releases/poco-1.10.1/poco-1.10.1-all.tar.gz"
  sha256 "7f5931e0bb06bc2880a0f3867053a2fddf6c0d3e5dd96342a665460301fc34ca"
  license "BSL-1.0"
  head "https://github.com/pocoproject/poco.git", branch: "develop"

  livecheck do
    url "https://pocoproject.org/releases/"
    regex(%r{href=.*?poco[._-]v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "d62b52377c0bfb785ad2e05ef8007a63e8518542891180c564d257fa07500307"
    sha256 cellar: :any, big_sur:       "a2483cf9eaff5857285e2ec3cc4086f74a7edfb240815e75bca7ba153861f1c5"
    sha256 cellar: :any, catalina:      "0755dff1346ea80aa6202ce3e8269c608960abd4bf0a4566e56075cc99364b57"
    sha256 cellar: :any, mojave:        "7abccb2c17823c6dda9dee9e5918fa28ef846d8095252681c83c47bbb674f5c8"
    sha256 cellar: :any, high_sierra:   "70cea3a570e187c3e70a8dbbe1ad2e43be1c159d0d9118c1bfc1a8cc6441e2a4"
    sha256 cellar: :any, x86_64_linux:  "b37b8c0ada07503592acc52c57c24c3ed52df26908b520e4e5284c30453d1101"
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DENABLE_DATA_MYSQL=OFF",
                            "-DENABLE_DATA_ODBC=OFF",
                            "-DCMAKE_INSTALL_RPATH=#{rpath}"
      system "make", "install"
    end
  end

  test do
    system bin/"cpspc", "-h"
  end
end
