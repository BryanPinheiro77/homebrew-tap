class Xswap < Formula
  desc "Account switcher and quota monitor for Codex CLI"
  homepage "https://github.com/BryanPinheiro77/xswap"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.4.0/xswap_v0.4.0_darwin_arm64.tar.gz"
      sha256 "32e29906dc83722148f3b1c7cc7f75aa2f927203c74e55184a431bb9d7932e50"
    else
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.4.0/xswap_v0.4.0_darwin_amd64.tar.gz"
      sha256 "765e53f95f3bff6a8c7b8554d5a649da7884aa1c481c7597aa2125dd0ada88a0"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.4.0/xswap_v0.4.0_linux_arm64.tar.gz"
      sha256 "4958698c2e2288cf8462d4557e0915fd9a5f2107519857e3f3e40c4955756daa"
    else
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.4.0/xswap_v0.4.0_linux_amd64.tar.gz"
      sha256 "e69c7d02a2e9bd7d0a09c6783c241b3f7c3b926ad26f73327a913db4ccad240b"
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
