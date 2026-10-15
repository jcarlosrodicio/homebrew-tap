class Norma < Formula
  desc "One task loop, one verification gate, one skill library for every coding agent"
  homepage "https://github.com/jcarlosrodicio/norma"
  url "https://github.com/jcarlosrodicio/norma/archive/refs/tags/0.22.0.tar.gz"
  sha256 "fa52a075442b8efdbf9f49a798c999c5ea640d9410cc28a263f44026be813d6c"
  license "MIT"
  head "https://github.com/jcarlosrodicio/norma.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  def install
    libexec.install Dir["*"]
    # Through opt_libexec, not libexec: `norma start` writes its own home into the
    # AGENTS.md of a new project, and the Cellar path dies with the next upgrade.
    bin.write_exec_script opt_libexec/"bin/norma"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/norma version")
    assert_equal opt_libexec.to_s, shell_output("#{bin}/norma home").strip

    system "git", "init", "-q", "-b", "master"
    (testpath/"package.json").write "{}"
    system bin/"norma", "install", "--profile", "node"
    assert_path_exists testpath/"scripts/harness/verify"
    assert_path_exists testpath/".agents/skills/run-task/SKILL.md"
  end
end
