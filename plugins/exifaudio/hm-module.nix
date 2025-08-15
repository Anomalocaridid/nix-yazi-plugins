{
  options =
    _:
    { lib, ... }:
    {
      mediainfo = lib.mkEnableOption "When enabled, mediainfo will be used alongside exiftool to provide more accurate metadata";
    };
  config =
    { cfg, ... }:
    { lib, pkgs, ... }:
    {
      programs.yazi = {
        settings.plugin.prepend_previewers = [
          {
            mime = "audio/*";
            run = "exifaudio";
          }
        ];
        # NOTE: even when mediainfo is used, exiftool is still needed to show covers
        yaziPlugins.runtimeDeps = [ pkgs.exiftool ] ++ lib.optional (cfg.mediainfo) pkgs.mediainfo;
      };
    };
}
