class Xswap < Formula
  desc "Account switcher and quota monitor for Codex CLI"
  homepage "https://github.com/BryanPinheiro77/xswap"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.7.0/xswap_v0.7.0_darwin_arm64.tar.gz"
      sha256 "00875be2d6306454c25730acb27eb21be400cb05c4bae269b50d230deec4102b"
    else
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.7.0/xswap_v0.7.0_darwin_amd64.tar.gz"
      sha256 "8dc956c1cbe118ea21044108b0983d389c552c00117838166d94f953c515f97f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.7.0/xswap_v0.7.0_linux_arm64.tar.gz"
      sha256 "bbeb79d63631ec291427c58625eec251644f9d53bd03c9e18f4013ee63ea8f37"
    else
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.7.0/xswap_v0.7.0_linux_amd64.tar.gz"
      sha256 "45ba22cd852de7ede8010841adc660d96cb2da6a14531007342aae0bf7ff882d"
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
