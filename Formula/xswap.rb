class Xswap < Formula
  desc "Account switcher and quota monitor for Codex CLI"
  homepage "https://github.com/BryanPinheiro77/xswap"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.5.3/xswap_v0.5.3_darwin_arm64.tar.gz"
      sha256 "a3f9fd721ec1f39177ca1ef55186c69355368396fc313dfae6eecbe7847b5eff"
    else
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.5.3/xswap_v0.5.3_darwin_amd64.tar.gz"
      sha256 "eb9664d427b2840331bf6a5673aa9412f5c96bea2f1631de241f840cfdd84774"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.5.3/xswap_v0.5.3_linux_arm64.tar.gz"
      sha256 "bdd1eea538af5f0e8dbc1bc843f87822075bb2e6000be6758d716ae497cc1ece"
    else
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.5.3/xswap_v0.5.3_linux_amd64.tar.gz"
      sha256 "ed0d9caea834412f2409b9b7c52bde8b8f58abcb059d1a98040e294acd853f8b"
    end
  end

  def install
    libexec.install "xswap" => "xswap-bin"
    (bin/"xswap").write <<~SH
      #!/bin/sh
      case "$(basename "$0")" in
        codex) set -- __codex "$@" ;;
      esac
      export XSWAP_PACKAGE_MANAGER=homebrew
      export XSWAP_EXECUTABLE="#{HOMEBREW_PREFIX}/opt/xswap/bin/xswap"
      exec "#{libexec}/xswap-bin" "$@"
    SH
    (bin/"xswap").chmod 0755
    bin.install_symlink "xswap" => "codex-swap"
  end

  def caveats
    <<~EOS
      The official Codex CLI must be installed before configuring XSwap.
      Run `xswap install` once to connect XSwap to the official Codex CLI.
      Open a new terminal after installation so the durable wrapper takes precedence.
      XSwap installed by Homebrew is updated with `brew upgrade xswap`.
      Before removing the formula, run `xswap uninstall` to remove the wrapper.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xswap version")
    assert_match "Managed by: Homebrew", shell_output("#{bin}/xswap version")
  end
end
