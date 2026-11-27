{
  callPackage,
  claudeDesktopSrc,
  writeShellApplication,
  coreutils,
  git,
  gnused,
  nix,
}:

let
  updateScript = writeShellApplication {
    name = "update-claude-desktop";
    runtimeInputs = [
      coreutils
      git
      gnused
      nix
    ];
    text = ''
      export UPDATE_NIX_ATTR_PATH="claude-desktop"
      exec ${./update.sh} "$@"
    '';
  };
  pkg = callPackage (claudeDesktopSrc + "/nix/claude-desktop.nix") { };
in
pkg.overrideAttrs (prevAttrs: {
  passthru = (prevAttrs.passthru or { }) // {
    inherit updateScript;
  };
})
