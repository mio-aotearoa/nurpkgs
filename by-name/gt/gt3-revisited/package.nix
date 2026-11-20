{
  lib,
  makeWrapper,
  symlinkJoin,
  gt3-revisited-unwrapped,
  # The disc image `gt3r` opens. Set one at build time and `gt3r` launches it
  # without an argument:
  #   gt3-revisited.override { image = /nix/store/…-Gran_Turismo_3_A-Spec__Japan_.iso; }
  # That makes the image an input of the package, so it is kept from garbage
  # collection; it has to be in the store already, because Nix refuses to add a
  # file whose name contains spaces or parentheses.
  image ? null,
}:

symlinkJoin {
  name = "gt3-revisited-${gt3-revisited-unwrapped.version}";

  paths = [ gt3-revisited-unwrapped ];

  nativeBuildInputs = [ makeWrapper ];

  # gt3r takes the disc from a positional argument and the last one wins, so
  # the image given here comes first: it is what the game opens unless another
  # image is named on the command line.
  postBuild = ''
    wrapProgram $out/bin/gt3r ${
      lib.optionalString (image != null) "--add-flags ${lib.escapeShellArg (toString image)}"
    }
  '';

  passthru = {
    inherit image;
    unwrapped = gt3-revisited-unwrapped;
  };

  meta = gt3-revisited-unwrapped.meta // {
    longDescription = ''
      GT3 Revisited reimplements the Gran Turismo 3 A-Spec engine for modern
      platforms. It contains no game data: the disc image you made from your
      copy is opened by `gt3r`, either at run time with the image on its
      command line (`gt3r /path/to/image.iso`) or, when it was set with
      `gt3-revisited.override { image = …; }`, without an argument.
      `gt3-revisited-unwrapped` is the same build without the wrapper.
    '';
  };
}
