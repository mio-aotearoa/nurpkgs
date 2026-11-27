{
  callPackage,
  claudeDesktopFhsUpstream ? null,
  claudeDesktopSrc,
  claude-desktop,
}:

(
  if claudeDesktopFhsUpstream != null then
    claudeDesktopFhsUpstream
  else
    callPackage (claudeDesktopSrc + "/nix/fhs.nix") {
      inherit claude-desktop;
    }
).overrideAttrs
  (prevAttrs: {
    passthru = (prevAttrs.passthru or { }) // {
      inherit (claude-desktop.passthru) updateScript;
    };
  })
