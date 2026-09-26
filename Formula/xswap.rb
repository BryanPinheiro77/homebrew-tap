class Xswap < Formula
  desc "Account switcher and quota monitor for Codex CLI"
  homepage "https://github.com/BryanPinheiro77/xswap"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.6.0/xswap_v0.6.0_darwin_arm64.tar.gz"
      sha256 "0d5a73b3d106cc60245cdcf4178c151b241ac71f699eaf148d1a816d35aed70a"
    else
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.6.0/xswap_v0.6.0_darwin_amd64.tar.gz"
      sha256 "1726c09e31255a1019bda74690cb7f4a1cb188f0580e5262f8b00b3e9ba5f69c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.6.0/xswap_v0.6.0_linux_arm64.tar.gz"
      sha256 "fb7236ab3062f8ceb35dcf92ce1ab764ab0bf2ea459476a797b565b3b95edd6e"
    else
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.6.0/xswap_v0.6.0_linux_amd64.tar.gz"
      sha256 "a0bf7311709909cb8836f14e7d3db8e6e5f9ff0dd5f7fbde64fbdc058eecfcf4"
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
