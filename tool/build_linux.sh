#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.."
case "${1:-$(uname -m)}" in
  x64|x86_64) target=x86_64-unknown-linux-gnu; arch=x64 ;;
  arm64|aarch64) target=aarch64-unknown-linux-gnu; arch=arm64 ;;
  *) echo "Usage: $0 [x64|arm64]" >&2; exit 1 ;;
esac

RUST_TOOLCHAIN="1.88.0-$target"
echo "Building for Linux $arch with Rust $RUST_TOOLCHAIN"
rustup target add "$target" --toolchain "$RUST_TOOLCHAIN"
rustup run "$RUST_TOOLCHAIN" cargo build --target "$target" --release
cp "target/$target/release/libisar.so" "libisar_linux_$arch.so"
