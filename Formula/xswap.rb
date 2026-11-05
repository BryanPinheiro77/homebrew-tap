class Xswap < Formula
  desc "Account switcher and quota monitor for Codex CLI"
  homepage "https://github.com/BryanPinheiro77/xswap"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.8.0/xswap_v0.8.0_darwin_arm64.tar.gz"
      sha256 "47152f8e2090df51fe06bbd8b5cc650b84dc86dad54da53811dd68e546c8ff1a"
    else
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.8.0/xswap_v0.8.0_darwin_amd64.tar.gz"
      sha256 "277c1e913d2e34184f3f3c03d00ae40749f1444fa035c8d79e2dbaf0086033c1"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.8.0/xswap_v0.8.0_linux_arm64.tar.gz"
      sha256 "87d1ebf2d4cff3e93e2edb5be2dcf149eade1abcd29688e1a7d82d294c662fc8"
    else
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.8.0/xswap_v0.8.0_linux_amd64.tar.gz"
      sha256 "c962a24c92e6442b89fae75477a1b032853188f290a68b047a0866284222ed6c"
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
