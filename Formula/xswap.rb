class Xswap < Formula
  desc "Account switcher and quota monitor for Codex CLI"
  homepage "https://github.com/BryanPinheiro77/xswap"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.5.1/xswap_v0.5.1_darwin_arm64.tar.gz"
      sha256 "2ed83680e6f5198dbefa72221e9c8874ff32a51866f5ef87d7090a998668be30"
    else
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.5.1/xswap_v0.5.1_darwin_amd64.tar.gz"
      sha256 "aab39b99f649d9a5ce4f2ebf977317a02f580207b39a6c71cba39b0d36b7eced"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.5.1/xswap_v0.5.1_linux_arm64.tar.gz"
      sha256 "d78fd06d3479c6ee11aa593c0f855fb1e04cbcb9c6bd7679277847c2b5af0349"
    else
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.5.1/xswap_v0.5.1_linux_amd64.tar.gz"
      sha256 "39a8a2830eec932a5ff192775e2aa87b7d8a8d8eb75a8b459af94f70a8d34816"
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
      XSwap installed by Homebrew is updated with `brew upgrade xswap`.
      Before removing the formula, run `xswap uninstall` to restore Codex.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xswap version")
    assert_match "Managed by: Homebrew", shell_output("#{bin}/xswap version")
  end
end
