{
  options =
    { mkKeyOption, ... }:
    _: {
      keys.compress = mkKeyOption {
        on = [ "C" ];
        run = "plugin ouch";
        desc = "Compress with ouch";
      };
    };
  config =
    { cfg, setKeys, ... }:
    { lib, pkgs, ... }:
    lib.mkMerge [
      (setKeys cfg.keys)
      {
        programs.yazi = {
          yaziPlugins.runtimeDeps = [ pkgs.ouch ];
          settings.plugin = {
            prepend_previewers =
              builtins.map
                (format: {
                  mime = "application/${format}";
                  run = "ouch";
                })
                [
                  "*zip"
                  "x-tar"
                  "x-bzip2"
                  "x-7z-compressed"
                  "x-rar"
                  "vnd.rar"
                  "x-xz"
                  "xz"
                  "x-zstd"
                  "zstd"
                  "java-archive"
                ];
            opener.extract = [
              {
                run = ''ouch -d -y "$@"'';
                desc = "Extract here with ouch";
              }
            ];
          };
        };
      }
    ];
}
