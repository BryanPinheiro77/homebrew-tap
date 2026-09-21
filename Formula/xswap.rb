class Xswap < Formula
  desc "Account switcher and quota monitor for Codex CLI"
  homepage "https://github.com/BryanPinheiro77/xswap"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.5.2/xswap_v0.5.2_darwin_arm64.tar.gz"
      sha256 "37b5fdaa9bd7684f2c8174dbf09ad9b20c6fa26f9d127ef0f0475cba4f898301"
    else
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.5.2/xswap_v0.5.2_darwin_amd64.tar.gz"
      sha256 "7468a4124af7aa2121e7682ad9ff64d3c40821cbdffe1b84b0608c194970fab6"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.5.2/xswap_v0.5.2_linux_arm64.tar.gz"
      sha256 "e0d412e84cf6140dfbec91b434cc6388fe71beff5d96b9e3878ac0fa9d4349d6"
    else
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.5.2/xswap_v0.5.2_linux_amd64.tar.gz"
      sha256 "67ae7bf8b2f9494ca35278e36068f2ac063c37706f33b249b5e4dbc15643c36f"
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
