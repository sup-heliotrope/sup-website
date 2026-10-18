let
  pkgs = import <nixpkgs> { };
in
(pkgs.iosevka.override {
  privateBuildPlan = ''
    [buildPlans.IosevkaAile]
    family = "Iosevka Aile SS09"
    spacing = "quasi-proportional"
    serifs = "sans"
    noLigation = true
    webfontFormats = ["WOFF2"]
    [buildPlans.IosevkaAile.variants]
    inherits = "ss09"
    [buildPlans.IosevkaAile.variants.design]
    f = "narrow-serifless-crossbar-at-x-height"
    i = "serifed-flat-tailed"
    r = "narrow-hook-serifless"
    t = "flat-hook-short-neck"
    [buildPlans.IosevkaAile.weights]
    Light = "default.Light"
    Regular = "default.Regular"
    Bold = "default.Bold"
    [buildPlans.IosevkaAile.widths]
    Normal = "default.Extended"
    [buildPlans.IosevkaAile.slopes]
    Upright = "default.Upright"
    Italic = "default.Italic"
    [buildPlans.IosevkaAile.subset.include]
    ranges = [
      # https://github.com/zachleat/glyphhanger/blob/8b81f57dc214cb2a1d1b5abb209e1d39454d7c51/src/GlyphHangerWhitelist.js#L14
      [0, 255],
      [305, 305],
      [338, 339],
      [699, 700],
      [710, 710],
      [730, 730],
      [732, 732],
      [8192, 8303],
      [8308, 8308],
      [8364, 8364],
      [8482, 8482],
      [8593, 8593],
      [8595, 8595],
      [8722, 8722],
      [8725, 8725],
      [65279, 65279],
      [65533, 65533],
    ]
    [buildPlans.Iosevka]
    family = "Iosevka SS09"
    spacing = "normal"
    serifs = "sans"
    noLigation = true
    webfontFormats = ["WOFF2"]
    [buildPlans.Iosevka.variants]
    inherits = "ss09"
    [buildPlans.Iosevka.weights]
    Light = "default.Light"
    Regular = "default.Regular"
    [buildPlans.Iosevka.widths]
    Normal = "default.Extended"
    [buildPlans.Iosevka.slopes]
    Upright = "default.Upright"
    [buildPlans.Iosevka.subset.include]
    ranges = [
      # https://github.com/zachleat/glyphhanger/blob/8b81f57dc214cb2a1d1b5abb209e1d39454d7c51/src/GlyphHangerWhitelist.js#L14
      [0, 255],
      [305, 305],
      [338, 339],
      [699, 700],
      [710, 710],
      [730, 730],
      [732, 732],
      [8192, 8303],
      [8308, 8308],
      [8364, 8364],
      [8482, 8482],
      [8593, 8593],
      [8595, 8595],
      [8722, 8722],
      [8725, 8725],
      [65279, 65279],
      [65533, 65533],
    ]
  '';
  set = "CustomSupWebsite";
}).overrideAttrs (finalAttrs: previousAttrs: {
  buildPhase = ''
    export HOME=$TMPDIR
    cat private-build-plans.toml
    npm run build --no-update-notifier --targets webfont::IosevkaAile webfont::Iosevka -- --jCmd=$NIX_BUILD_CORES --verbosity=9 | cat
  '';
  installPhase = ''
    install -d $out
    cp dist/*/*.css $out/
    cp -r dist/*/WOFF2 $out/
  '';
})
