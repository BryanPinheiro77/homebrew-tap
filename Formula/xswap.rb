class Xswap < Formula
  desc "Account switcher and quota monitor for Codex CLI"
  homepage "https://github.com/BryanPinheiro77/xswap"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.3.4/xswap_v0.3.4_darwin_arm64.tar.gz"
      sha256 "a6d8e40b7b13ad09b19df01377aa9cc24f581ae9927d59b4bb08322aafa6799a"
    else
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.3.4/xswap_v0.3.4_darwin_amd64.tar.gz"
      sha256 "200499e1a485ac3fcfb1ccc3d30fd8fae54760c5b887722e4b1a5bc5fba63ec7"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.3.4/xswap_v0.3.4_linux_arm64.tar.gz"
      sha256 "75f96e4dfd9bc4159f73265d1f5e53549cfa6e4bd675de56cde57b9d1e41067e"
    else
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.3.4/xswap_v0.3.4_linux_amd64.tar.gz"
      sha256 "80d1b38e3f030359feb2aa8e9c808ac2bcc63ae36602922b3bddf519097bbc03"
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
