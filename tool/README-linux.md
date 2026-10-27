# Native Linux builds

Run from the repository root on a native Linux x86_64 or aarch64 host.
Install a C/C++ compiler, libclang development libraries, CMake, pkg-config,
Git and curl. Flutter desktop builds also require Ninja and GTK 3 development
libraries. Install Rust through rustup with the pinned toolchain:

```sh
rustup toolchain install 1.88.0 --profile minimal
bash tool/build_linux.sh
```

The script detects the host architecture (or accepts `x64`, `arm64`, or
`aarch64`). It is intended for native builds, not cross-compilation. It writes
`libisar_linux_arm64.so` or `libisar_linux_x64.so` at the repository root and
preserves the Cargo output under `target/<target>/release/libisar.so` for tests.

For an ARM64 Flutter app, bundle the locally built library before building:

```sh
cp libisar_linux_arm64.so packages/isar_community_flutter_libs/linux/libisar.aarch64.so
cd packages/isar_test
flutter pub get
flutter build linux --release
```

For x64, copy `libisar_linux_x64.so` to
`packages/isar_community_flutter_libs/linux/libisar.x64.so` instead.
Native libraries and build outputs are ignored by Git and must be rebuilt
on a fresh checkout. The default core version is `debug`; release packaging
can set `ISAR_VERSION=3.4.1` when invoking the build script.

To generate and run the Dart database tests against the local native library:

```sh
sh tool/prepare_tests.sh
cd packages/isar_test
# Run database tests with Dart; the widget test requires Flutter.
find test -name '*_test.dart' ! -name widget_test.dart -print0 | xargs -0 dart test
flutter test test/widget_test.dart
```
