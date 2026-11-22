{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  python3,
}:

let
  pythonEnv = python3.withPackages (ps: [
    ps.annotated-doc
    ps.anyio
    ps.attrs
    ps.certifi
    ps.cffi
    ps.click
    ps.cryptography
    ps.filelock
    ps.fsspec
    ps.hf-xet
    ps.h11
    ps.httpcore
    ps.httpx
    ps.huggingface-hub
    ps.idna
    ps.jinja2
    ps.jsonschema
    ps.jsonschema-specifications
    ps.llguidance
    ps.markdown-it-py
    ps.markupsafe
    ps.mdurl
    ps.numpy
    ps.packaging
    ps.pillow
    ps.pip
    ps.pygments
    ps.pycparser
    ps.pypdfium2
    ps.pyyaml
    ps.referencing
    ps.regex
    ps.rich
    ps.rpds-py
    ps.safetensors
    ps.shellingham
    ps.tokenizers
    ps.tqdm
    ps.transformers
    ps.typer
    ps.typing-extensions
  ]);
in
stdenv.mkDerivation rec {
  pname = "splash";
  version = "1.7.0";

  # The engine's kernels target Metal 4.0, which only Xcode's `metal` compiler
  # emits; there is no free Metal compiler and the build sandbox cannot reach
  # the host toolchain. Install upstream's official arm64/macOS 26 build
  # instead of compiling the engine. Its bundled Python runtime is unused: the
  # launcher is wrapped to run under pythonEnv below.
  src = fetchurl {
    url = "https://github.com/incoai/splash/releases/download/${version}/splash-${version}-arm64-macos26.tar.gz";
    hash = "sha256-XLsaZwhEM4PAgmK8p8PYJhEJyvdCOP2vygY0NQdLWG0=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontConfigure = true;
  dontBuild = true;
  # The engine and metallibs are already built and signed upstream.
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    root=$out/share/splash
    mkdir -p $root/python/bin

    cp -R engine install server LICENSE THIRD_PARTY_NOTICES release.json $root/
    chmod -R u+w $root

    # The launcher and server spawn ROOT/python/bin/python3 for the serving
    # process; the Nix environment supplies the pinned dependency set.
    cat > $root/python/bin/python3 <<EOF
    #!${stdenv.shell}
    exec ${pythonEnv}/bin/python3 "\$@"
    EOF
    chmod 755 $root/python/bin/python3

    makeWrapper ${pythonEnv}/bin/python3 $out/bin/splash \
      --add-flags "$root/install/launcher.py" \
      --set PYTHONDONTWRITEBYTECODE 1

    runHook postInstall
  '';

  doCheck = false;

  meta = {
    description = "Local inference engine for Apple silicon";
    homepage = "https://github.com/incoai/splash";
    license = lib.licenses.asl20;
    mainProgram = "splash";
    platforms = [ "aarch64-darwin" ];
  };
}
