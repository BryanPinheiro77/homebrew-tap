# XSwap Homebrew Tap

This is the official Homebrew tap for [XSwap](https://github.com/BryanPinheiro77/xswap), an account switcher and quota monitor for the Codex CLI.

## Install

Install the official Codex CLI first, then run:

```sh
brew install BryanPinheiro77/tap/xswap
xswap install
xswap
```

`xswap install` connects the Homebrew-managed XSwap binary to the existing Codex CLI. It only needs to be run once.

## Upgrade

```sh
brew update
brew upgrade xswap
```

## Uninstall

Restore the original Codex command before removing XSwap:

```sh
xswap uninstall
brew uninstall xswap
brew untap BryanPinheiro77/tap
```

Report bugs and request features in the [XSwap issue tracker](https://github.com/BryanPinheiro77/xswap/issues).
