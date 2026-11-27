{
  callPackage,
  claudeDesktopSrc,
  claude-desktop,
}:

let
  fhs = callPackage (claudeDesktopSrc + "/nix/fhs.nix") {
    inherit claude-desktop;
  };
in
fhs.overrideAttrs (prevAttrs: {
  passthru = (prevAttrs.passthru or { }) // {
    inherit (claude-desktop.passthru) updateScript;
  };
})
