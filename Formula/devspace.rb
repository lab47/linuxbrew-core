class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
      tag:      "v5.14.1",
      revision: "8ccdb3b7acfe0ae950c9d5ef986998bcac7a7b2b"
  license "Apache-2.0"
  head "https://github.com/devspace-cloud/devspace.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "caf97331e746bfe331e1b99af3e44395d405c4b520ac4e4da3ca0638831067d5"
    sha256 cellar: :any_skip_relocation, big_sur:       "5f9a52fa6a960a63d950336c9b8a6b354df7107f76cafb5d18bc470f914e204a"
    sha256 cellar: :any_skip_relocation, catalina:      "265fc8ca5688dea69c22872211cb179e941bd5cc563bfda9edf08b68ced0c00b"
    sha256 cellar: :any_skip_relocation, mojave:        "33a77bde44ddf78c9b6a75d5c282fa5d3f211f46fc5fcbf645735a5dfb6216f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14d7c84841b32d69bb2b98a013914fd157d6a8aff1d67dbcf45cd4e348e36dec"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = %W[
      -s -w
      -X main.commitHash=#{Utils.git_head}
      -X main.version=#{version}
    ]
    system "go", "build", "-ldflags", ldflags.join(" "), *std_go_args
  end

  test do
    help_output = "DevSpace accelerates developing, deploying and debugging applications with Docker and Kubernetes."
    assert_match help_output, shell_output("#{bin}/devspace help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}/devspace init --help")
  end
end
