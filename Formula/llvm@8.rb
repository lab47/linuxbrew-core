require "os/linux/glibc"

class LlvmAT8 < Formula
  desc "Next-gen compiler infrastructure"
  homepage "https://llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-8.0.1/llvm-8.0.1.src.tar.xz"
  sha256 "44787a6d02f7140f145e2250d56c9f849334e11f9ae379827510ed72f12b75e7"
  license "NCSA"
  revision OS.mac? ? 3 : 7

  bottle do
    sha256 cellar: :any,                 catalina:     "ab099d84e5f0a58ea37172fd85753336d855fc25e9459ceff12ddc2dbb56ef71"
    sha256 cellar: :any,                 mojave:       "ee795cbebce64f79bbcf7c42526093df7bd2e5e986a721197bca5cf6c822e87a"
    sha256 cellar: :any,                 high_sierra:  "3f80b7119307b128b1e3ae8a2fea97a9878afb5a7436a7d35615b1e743bc7622"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "45da03e8b833c66c310e25c997567728b9a906f8fa81a178c7c268532c48e779"
  end

  # Clang cannot find system headers if Xcode CLT is not installed
  pour_bottle? only_if: :clt_installed

  keg_only :versioned_formula

  # https://llvm.org/docs/GettingStarted.html#requirement
  depends_on "cmake" => :build
  depends_on xcode: :build
  depends_on arch: :x86_64
  depends_on "libffi"
  depends_on "swig"

  unless OS.mac?
    if Formula["glibc"].any_version_installed? || OS::Linux::Glibc.system_version < Formula["glibc"].version
      depends_on "glibc"
    end
    depends_on "binutils" # needed for gold and strip
    depends_on "libedit" # llvm requires <histedit.h>
    depends_on "libelf" # openmp requires <gelf.h>
    depends_on "ncurses"
    depends_on "libxml2"
    depends_on "zlib"
    depends_on "python@3.8"
  end

  resource "clang" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-8.0.1/cfe-8.0.1.src.tar.xz"
    sha256 "70effd69f7a8ab249f66b0a68aba8b08af52aa2ab710dfb8a0fba102685b1646"
  end

  unless OS.mac?
    patch :p2 do
      # Fixes MicrosoftDemangleNodes.h:14:17: error: found ':' in nested-name-specifier, expected '::'
      url "https://github.com/llvm/llvm-project/commit/b288d90b39f4b905c02092a9bfcfd6d78f99b191.patch?full_index=1"
      sha256 "2028d52e1a39326bb48fb7463132bbfe7fb4fa18f1adfeea9c3ed0320ed49564"
    end
  end

  resource "clang-extra-tools" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-8.0.1/clang-tools-extra-8.0.1.src.tar.xz"
    sha256 "187179b617e4f07bb605cc215da0527e64990b4a7dd5cbcc452a16b64e02c3e1"
  end

  resource "compiler-rt" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-8.0.1/compiler-rt-8.0.1.src.tar.xz"
    sha256 "11828fb4823387d820c6715b25f6b2405e60837d12a7469e7a8882911c721837"
  end

  resource "libcxx" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-8.0.1/libcxx-8.0.1.src.tar.xz"
    sha256 "7f0652c86a0307a250b5741ab6e82bb10766fb6f2b5a5602a63f30337e629b78"
  end

  resource "libcxxabi" do
    on_macos do
      url "https://llvm.org/releases/6.0.1/libcxxabi-6.0.1.src.tar.xz"
      sha256 "209f2ec244a8945c891f722e9eda7c54a5a7048401abd62c62199f3064db385f"
    end

    on_linux do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-8.0.1/libcxxabi-8.0.1.src.tar.xz"
      sha256 "b75bf3c8dc506e7d950d877eefc8b6120a4651aaa110f5805308861f2cfaf6ef"
    end
  end

  resource "libunwind" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-8.0.1/libunwind-8.0.1.src.tar.xz"
    sha256 "1870161dda3172c63e632c1f60624564e1eb0f9233cfa8f040748ca5ff630f6e"
  end

  resource "lld" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-8.0.1/lld-8.0.1.src.tar.xz"
    sha256 "9fba1e94249bd7913e8a6c3aadcb308b76c8c3d83c5ce36c99c3f34d73873d88"
  end

  resource "lldb" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-8.0.1/lldb-8.0.1.src.tar.xz"
    sha256 "e8a79baa6d11dd0650ab4a1b479f699dfad82af627cbbcd49fa6f2dc14e131d7"
  end

  resource "openmp" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-8.0.1/openmp-8.0.1.src.tar.xz"
    sha256 "3e85dd3cad41117b7c89a41de72f2e6aa756ea7b4ef63bb10dcddf8561a7722c"
  end

  resource "polly" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-8.0.1/polly-8.0.1.src.tar.xz"
    sha256 "e8a1f7e8af238b32ce39ab5de1f3317a2e3f7d71a8b1b8bbacbd481ac76fd2d1"
  end

  def install
    # Apple's libstdc++ is too old to build LLVM
    ENV.libcxx if ENV.compiler == :clang

    (buildpath/"tools/clang").install resource("clang")
    (buildpath/"tools/clang/tools/extra").install resource("clang-extra-tools")
    (buildpath/"projects/openmp").install resource("openmp")
    (buildpath/"projects/libcxx").install resource("libcxx")
    (buildpath/"projects/libcxxabi").install resource("libcxxabi") unless OS.mac?
    (buildpath/"projects/libunwind").install resource("libunwind")
    (buildpath/"tools/lld").install resource("lld")
    (buildpath/"tools/lldb").install resource("lldb")
    (buildpath/"tools/polly").install resource("polly")
    (buildpath/"projects/compiler-rt").install resource("compiler-rt")

    # compiler-rt has some iOS simulator features that require i386 symbols
    # I'm assuming the rest of clang needs support too for 32-bit compilation
    # to work correctly, but if not, perhaps universal binaries could be
    # limited to compiler-rt. llvm makes this somewhat easier because compiler-rt
    # can almost be treated as an entirely different build from llvm.
    ENV.permit_arch_flags

    args = %W[
      -DLIBOMP_ARCH=x86_64
      -DLINK_POLLY_INTO_TOOLS=ON
      -DLLVM_BUILD_EXTERNAL_COMPILER_RT=ON
      -DLLVM_BUILD_LLVM_DYLIB=ON
      -DLLVM_ENABLE_EH=ON
      -DLLVM_ENABLE_FFI=ON
      -DLLVM_ENABLE_RTTI=ON
      -DCLANG_ANALYZER_ENABLE_Z3_SOLVER=OFF
      -DLLVM_INCLUDE_DOCS=OFF
      -DLLVM_INSTALL_UTILS=ON
      -DLLVM_OPTIMIZED_TABLEGEN=ON
      -DLLVM_TARGETS_TO_BUILD=all
      -DWITH_POLLY=ON
      -DFFI_INCLUDE_DIR=#{Formula["libffi"].opt_lib}/libffi-#{Formula["libffi"].version}/include
      -DFFI_LIBRARY_DIR=#{Formula["libffi"].opt_lib}
      -DLLDB_USE_SYSTEM_DEBUGSERVER=ON
      -DLLDB_DISABLE_PYTHON=1
      -DLIBOMP_INSTALL_ALIASES=OFF
    ]
    if OS.mac?
      args << "-DLLVM_CREATE_XCODE_TOOLCHAIN=ON"
      args << "-DLLVM_ENABLE_LIBCXX=ON"
    else
      args << "-DLLVM_CREATE_XCODE_TOOLCHAIN=OFF"
      args << "-DLLVM_ENABLE_LIBCXX=OFF"
      args << "-DCLANG_DEFAULT_CXX_STDLIB=libstdc++"

      # Enable llvm gold plugin for LTO
      args << "-DLLVM_BINUTILS_INCDIR=#{Formula["binutils"].opt_include}"

      # Add flags to build shared and static libc++ which are independent of GCC
      args += %w[
        -DLLVM_ENABLE_PER_TARGET_RUNTIME_DIR=OFF
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON

        -DLIBCXX_ENABLE_STATIC_ABI_LIBRARY=ON
        -DLIBCXX_STATICALLY_LINK_ABI_IN_SHARED_LIBRARY=OFF
        -DLIBCXX_STATICALLY_LINK_ABI_IN_STATIC_LIBRARY=ON
        -DLIBCXX_USE_COMPILER_RT=ON

        -DLIBCXXABI_ENABLE_STATIC_UNWINDER=ON
        -DLIBCXXABI_STATICALLY_LINK_UNWINDER_IN_SHARED_LIBRARY=OFF
        -DLIBCXXABI_STATICALLY_LINK_UNWINDER_IN_STATIC_LIBRARY=ON
        -DLIBCXXABI_USE_COMPILER_RT=ON
        -DLIBCXXABI_USE_LLVM_UNWINDER=ON

        -DLIBUNWIND_USE_COMPILER_RT=ON
      ]

      # Don't pass -rtlib as an argument to GCC because it doesn't understand it.
      inreplace (buildpath/"projects/libcxx/CMakeLists.txt"),
        "list(APPEND LIBCXX_LINK_FLAGS \"-rtlib=compiler-rt\")", ""
      inreplace (buildpath/"projects/libcxxabi/CMakeLists.txt"),
        "list(APPEND LIBCXXABI_LINK_FLAGS \"-rtlib=compiler-rt\")", ""
      inreplace (buildpath/"projects/libunwind/CMakeLists.txt"),
        "list(APPEND LIBUNWIND_LINK_FLAGS \"-rtlib=compiler-rt\")", ""
    end

    if MacOS.version >= :mojave
      sdk_path = MacOS::CLT.installed? ? "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk" : MacOS.sdk_path
      args << "-DDEFAULT_SYSROOT=#{sdk_path}"
    end

    mkdir "build" do
      system "cmake", "-G", "Unix Makefiles", "..", *(std_cmake_args + args)
      system "make"
      system "make", "install"
      system "make", "install-xcode-toolchain" if MacOS::Xcode.installed?
    end

    (share/"clang/tools").install Dir["tools/clang/tools/scan-{build,view}"]
    (share/"cmake").install "cmake/modules"
    inreplace "#{share}/clang/tools/scan-build/bin/scan-build", "$RealBin/bin/clang", "#{bin}/clang"
    bin.install_symlink share/"clang/tools/scan-build/bin/scan-build", share/"clang/tools/scan-view/bin/scan-view"
    man1.install_symlink share/"clang/tools/scan-build/man/scan-build.1"

    # install llvm python bindings
    xz = "2.7"
    xz = "3.8" unless OS.mac?
    (lib/"python#{xz}/site-packages").install buildpath/"bindings/python/llvm"
    (lib/"python#{xz}/site-packages").install buildpath/"tools/clang/bindings/python/clang"

    unless OS.mac?
      # Strip executables/libraries/object files to reduce their size
      system("strip", "--strip-unneeded", "--preserve-dates", *(Dir[bin/"**/*", lib/"**/*"]).select do |f|
        f = Pathname.new(f)
        f.file? && (f.elf? || f.extname == ".a")
      end)
    end
  end

  def caveats
    <<~EOS
      To use the bundled libc++ please add the following LDFLAGS:
        LDFLAGS="-L#{opt_lib} -Wl,-rpath,#{opt_lib}"
    EOS
  end

  test do
    assert_equal prefix.to_s, shell_output("#{bin}/llvm-config --prefix").chomp

    (testpath/"omptest.c").write <<~EOS
      #include <stdlib.h>
      #include <stdio.h>
      #include <omp.h>
      int main() {
          #pragma omp parallel num_threads(4)
          {
            printf("Hello from thread %d, nthreads %d\\n", omp_get_thread_num(), omp_get_num_threads());
          }
          return EXIT_SUCCESS;
      }
    EOS

    clean_version = version.to_s[/(\d+\.?)+/]

    args = [
      "-L#{lib}",
      "-fopenmp",
      "-nobuiltininc",
      "-I#{lib}/clang/#{clean_version}/include",
    ]
    args << "-Wl,-rpath=#{lib}" unless OS.mac?

    system "#{bin}/clang", *args, "omptest.c", "-o", "omptest", *ENV["LDFLAGS"].split
    testresult = shell_output("./omptest")

    sorted_testresult = testresult.split("\n").sort.join("\n")
    expected_result = <<~EOS
      Hello from thread 0, nthreads 4
      Hello from thread 1, nthreads 4
      Hello from thread 2, nthreads 4
      Hello from thread 3, nthreads 4
    EOS
    assert_equal expected_result.strip, sorted_testresult.strip

    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main()
      {
        printf("Hello World!\\n");
        return 0;
      }
    EOS

    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      int main()
      {
        std::cout << "Hello World!" << std::endl;
        return 0;
      }
    EOS

    # Testing default toolchain and SDK location.
    system "#{bin}/clang++", "-v",
           "-std=c++11", "test.cpp", "-o", "test++"
    assert_includes MachO::Tools.dylibs("test++"), "/usr/lib/libc++.1.dylib" if OS.mac?
    assert_equal "Hello World!", shell_output("./test++").chomp
    system "#{bin}/clang", "-v", "test.c", "-o", "test"
    assert_equal "Hello World!", shell_output("./test").chomp

    # Testing Command Line Tools
    if MacOS::CLT.installed?
      toolchain_path = "/Library/Developer/CommandLineTools"
      sdk_path = "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk"
      system "#{bin}/clang++", "-v",
             "-isysroot", sdk_path,
             "-isystem", "#{toolchain_path}/usr/include/c++/v1",
             "-isystem", "#{toolchain_path}/usr/include",
             "-isystem", "#{sdk_path}/usr/include",
             "-std=c++11", "test.cpp", "-o", "testCLT++"
      assert_includes MachO::Tools.dylibs("testCLT++"), "/usr/lib/libc++.1.dylib"
      assert_equal "Hello World!", shell_output("./testCLT++").chomp
      system "#{bin}/clang", "-v", "test.c", "-o", "testCLT"
      assert_equal "Hello World!", shell_output("./testCLT").chomp
    end

    # Testing Xcode
    if MacOS::Xcode.installed?
      system "#{bin}/clang++", "-v",
             "-isysroot", MacOS.sdk_path,
             "-isystem", "#{MacOS::Xcode.toolchain_path}/usr/include/c++/v1",
             "-isystem", "#{MacOS::Xcode.toolchain_path}/usr/include",
             "-isystem", "#{MacOS.sdk_path}/usr/include",
             "-std=c++11", "test.cpp", "-o", "testXC++"
      assert_includes MachO::Tools.dylibs("testXC++"), "/usr/lib/libc++.1.dylib"
      assert_equal "Hello World!", shell_output("./testXC++").chomp
      system "#{bin}/clang", "-v",
             "-isysroot", MacOS.sdk_path,
             "test.c", "-o", "testXC"
      assert_equal "Hello World!", shell_output("./testXC").chomp
    end

    # link against installed libc++
    # related to https://github.com/Homebrew/legacy-homebrew/issues/47149
    system "#{bin}/clang++", "-v",
           "-isystem", "#{opt_include}/c++/v1",
           "-std=c++11", "-stdlib=libc++", "test.cpp", "-o", "testlibc++",
           "-rtlib=compiler-rt", "-L#{opt_lib}", "-Wl,-rpath,#{opt_lib}"
    assert_includes (testpath/"testlibc++").dynamically_linked_libraries,
      (opt_lib/shared_library("libc++", "1")).to_path
    (testpath/"testlibc++").dynamically_linked_libraries.each do |lib|
      refute_match(/libstdc\+\+/, lib)
      refute_match(/libgcc/, lib)
      refute_match(/libatomic/, lib)
    end
    assert_equal "Hello World!", shell_output("./testlibc++").chomp

    on_linux do
      # Link installed libc++, libc++abi, and libunwind archives both into
      # a position independent executable (PIE), as well as into a fully
      # position independent (PIC) DSO for things like plugins that export
      # a C-only API but internally use C++.
      #
      # FIXME: It'd be nice to be able to use flags like `-static-libstdc++`
      # together with `-stdlib=libc++` (the latter one we need anyways for
      # headers) to achieve this but those flags don't set up the correct
      # search paths or handle all of the libraries needed by `libc++` when
      # linking statically.

      system "#{bin}/clang++", "-v", "-o", "test_pie_runtimes",
             "-pie", "-fPIC", "test.cpp", "-L#{opt_lib}",
             "-stdlib=libc++", "-rtlib=compiler-rt",
             "-static-libstdc++", "-lpthread", "-ldl"
      assert_equal "Hello World!", shell_output("./test_pie_runtimes").chomp
      (testpath/"test_pie_runtimes").dynamically_linked_libraries.each do |lib|
        refute_match(/lib(std)?c\+\+/, lib)
        refute_match(/libgcc/, lib)
        refute_match(/libatomic/, lib)
        refute_match(/libunwind/, lib)
      end

      (testpath/"test_plugin.cpp").write <<~EOS
        #include <iostream>
        __attribute__((visibility("default")))
        extern "C" void run_plugin() {
          std::cout << "Hello Plugin World!" << std::endl;
        }
      EOS
      (testpath/"test_plugin_main.c").write <<~EOS
        extern void run_plugin();
        int main() {
          run_plugin();
        }
      EOS

      system "#{bin}/clang++", "-v", "-o", "test_plugin.so",
             "-shared", "-fPIC", "test_plugin.cpp", "-L#{opt_lib}",
             "-stdlib=libc++", "-rtlib=compiler-rt",
             "-static-libstdc++", "-lpthread", "-ldl"
      system "#{bin}/clang", "-v",
             "test_plugin_main.c", "-o", "test_plugin_libc++",
             "test_plugin.so", "-Wl,-rpath=#{testpath}", "-rtlib=compiler-rt"
      assert_equal "Hello Plugin World!", shell_output("./test_plugin_libc++").chomp
      (testpath/"test_plugin.so").dynamically_linked_libraries.each do |lib|
        refute_match(/lib(std)?c\+\+/, lib)
        refute_match(/libgcc/, lib)
        refute_match(/libatomic/, lib)
        refute_match(/libunwind/, lib)
      end
    end

    (testpath/"scanbuildtest.cpp").write <<~EOS
      #include <iostream>
      int main() {
        int *i = new int;
        *i = 1;
        delete i;
        std::cout << *i << std::endl;
        return 0;
      }
    EOS
    assert_includes shell_output("#{bin}/scan-build --use-analyzer #{bin}/clang++ " \
                                 "#{bin}/clang++ scanbuildtest.cpp 2>&1"),
      "warning: Use of memory after it is freed"

    (testpath/"clangformattest.c").write <<~EOS
      int    main() {
          printf("Hello world!"); }
    EOS
    assert_equal "int main() { printf(\"Hello world!\"); }\n",
      shell_output("#{bin}/clang-format -style=google clangformattest.c")
  end
end
