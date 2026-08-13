{
  lib,
  stdenv,
  autoreconfHook,
  libdvdread,
  libxml2,
  freetype,
  fribidi,
  libpng,
  zlib,
  pkg-config,
  flex,
  bison,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dvdauthor";
  version = "0.7.2";

  src = ./.;

  # Patches: verify which of the following upstream patches are already integrated into the repository
  # The upstream recipe included patches from:
  # - d5bb0bdd542c33214855a7062fcc485f8977934e: "Use pkg-config to find FreeType"
  # - 84d971def13b7e6317eae44369f49fd709b01030: "fix to build with GraphicsMagick"
  # - 45705ece5ec5d7d6b9ab3e7a68194796a398e855: "Use PKG_CHECK_MODULES to detect the libxml2 library"
  patches = [
    # ./gettext-0.25.patch  # uncomment if this file exists in the repository root
  ];

  buildInputs = [
    libpng
    freetype
    libdvdread
    libxml2
    zlib
    fribidi
    flex
    bison
  ];

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  strictDeps = true;

  meta = {
    description = "Tools for generating DVD files to be played on standalone DVD players";
    homepage = "https://dvdauthor.sourceforge.net/"; # or https://github.com/ldo/dvdauthor
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
