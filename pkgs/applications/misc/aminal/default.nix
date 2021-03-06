{ buildGoPackage
, Carbon
, Cocoa
, Kernel
, cf-private
, fetchFromGitHub
, lib
, mesa_glu
, stdenv
, xorg
}:

buildGoPackage rec {
  name = "aminal-${version}";
  version = "0.7.4";

  goPackagePath = "github.com/liamg/aminal";

  buildInputs =
    lib.optionals stdenv.isLinux [
      mesa_glu
      xorg.libX11
      xorg.libXcursor
      xorg.libXi
      xorg.libXinerama
      xorg.libXrandr
      xorg.libXxf86vm
    ] ++ lib.optionals stdenv.isDarwin [
      Carbon
      Cocoa
      Kernel
      cf-private  /* Needed for NSDefaultRunLoopMode */
    ];

  src = fetchFromGitHub {
    owner = "liamg";
    repo = "aminal";
    rev = "v${version}";
    sha256 = "0wnzxjlv98pi3gy4hp3d19pwpa4kf1h5rqy03s9bcqdbpb1v1b7v";
  };

  preBuild = ''
    buildFlagsArray=("-ldflags=-X ${goPackagePath}/version.Version=${version}")
  '';

  meta = with lib; {
    description = "Golang terminal emulator from scratch";
    longDescription = ''
      Aminal is a modern terminal emulator for Mac/Linux implemented in Golang
      and utilising OpenGL.

      The project is experimental at the moment, so you probably won't want to
      rely on Aminal as your main terminal for a while.

      Features:
      - Unicode support
      - OpenGL rendering
      - Customisation options
      - True colour support
      - Support for common ANSI escape sequences a la xterm
      - Scrollback buffer
      - Clipboard access
      - Clickable URLs
      - Multi platform support (Windows coming soon...)
      - Sixel support
      - Hints/overlays
      - Built-in patched fonts for powerline
      - Retina display support
    '';
    homepage = https://github.com/liamg/aminal;
    license = licenses.gpl3;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
