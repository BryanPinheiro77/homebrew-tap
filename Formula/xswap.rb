class Xswap < Formula
  desc "Account switcher and quota monitor for Codex CLI"
  homepage "https://github.com/BryanPinheiro77/xswap"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.5.4/xswap_v0.5.4_darwin_arm64.tar.gz"
      sha256 "a25af0959204c85dd5e09fb22f2cb38f487e43509ffef8483c6adcfa5aae704b"
    else
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.5.4/xswap_v0.5.4_darwin_amd64.tar.gz"
      sha256 "ed26e68886615183f705f3111d9ce05e5487f2ea68b3e8c8e0d326094a93166d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.5.4/xswap_v0.5.4_linux_arm64.tar.gz"
      sha256 "b84566adccb67330619e7f419b676d7b9a5ad38df404b433f0eaf07d2854e16e"
    else
      url "https://github.com/BryanPinheiro77/xswap/releases/download/v0.5.4/xswap_v0.5.4_linux_amd64.tar.gz"
      sha256 "d8291d4cb216f524643bbc4a95615c2988ceda7c9e7fe334f25a42f14120676e"
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
