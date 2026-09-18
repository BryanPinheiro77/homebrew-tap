class Xswap < Formula
  desc "Account switcher and quota monitor for Codex CLI"
  homepage "https://github.com/BryanPinheiro77/xswap"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.4.1/xswap_v0.4.1_darwin_arm64.tar.gz"
      sha256 "488e14a4042cc52493008a7ca7342d880c4c4f143d3e6d9fac5804b52188a51d"
    else
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.4.1/xswap_v0.4.1_darwin_amd64.tar.gz"
      sha256 "b6085352b1b5dc72fcb0c8a0e14af35fbb7c91c129e4df6734649a0cf34d88a5"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.4.1/xswap_v0.4.1_linux_arm64.tar.gz"
      sha256 "51379ace406a8a37db01b01cedb07fb2eba9150d3e8871bb6fb550e5b50d1afa"
    else
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.4.1/xswap_v0.4.1_linux_amd64.tar.gz"
      sha256 "1ba8050ab78ecf0dd8f698cf7ad2649a59212911d03b3acbea9d4d599246ccd8"
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
