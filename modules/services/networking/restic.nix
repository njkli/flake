# https://github.com/restic/restic/blob/master/doc/040_backup.rst
{ inputs, config, lib, pkgs, ... }:
with lib;

# TODO: integrate https://github.com/creativeprojects/resticprofile
let
  unitOption = (import "${inputs.nixpkgs}/nixos/modules/system/boot/systemd-unit-options.nix" { inherit config lib; }).unitOption;
  cfg = config.njk.services.restic.backups;
  cfgEnable = isAttrs cfg && ((length (attrNames cfg)) > 0);
in
{
  options.njk.services.restic.backups = mkOption {
    description = ''
      Periodic backups to create with Restic.
    '';
    type = types.attrsOf (types.submodule ({ name, ... }: {
      options = {
        passwordFile = mkOption {
          type = types.str;
          description = ''
            Read the repository password from a file.
          '';
          example = "/etc/nixos/restic-password";
        };

        s3CredentialsFile = mkOption {
          type = with types; nullOr str;
          default = null;
          description = ''
            file containing the AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
            for an S3-hosted repository, in the format of an EnvironmentFile
            as described by systemd.exec(5)
          '';
        };

        repository = mkOption {
          type = types.str;
          description = ''
            repository to backup to.
          '';
          example = "sftp:backup@192.168.1.100:/backups/${name}";
        };

        paths = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = ''
            Which paths to backup.
          '';
          example = [
            "/var/lib/postgresql"
            "/home/user/backup"
          ];
        };

        timerConfig = mkOption {
          type = types.attrsOf unitOption;
          default = {
            OnCalendar = "daily";
          };
          description = ''
            When to run the backup. See man systemd.timer for details.
          '';
          example = {
            OnCalendar = "00:05";
            RandomizedDelaySec = "5h";
          };
        };

        user = mkOption {
          type = types.str;
          default = "root";
          description = ''
            As which user the backup should run.
          '';
          example = "postgresql";
        };

        extraBackupArgs = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = ''
            Extra arguments passed to restic backup.
          '';
          example = [
            "--exclude-file=/etc/nixos/restic-ignore"
          ];
        };

        extraOptions = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = ''
            Extra extended options to be passed to the restic --option flag.
          '';
          example = [
            "sftp.command='ssh backup@192.168.1.100 -i /home/user/.ssh/id_rsa -s sftp'"
          ];
        };

        initialize = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Create the repository if it doesn't exist.
          '';
        };

        policy = {
          enable = mkOption {
            type = types.bool;
            default = false;
            description = ''
              Enable retention policy
            '';
          };

          args = mkOption {
            type = types.listOf types.str;
            default = [ ];
            description = ''
              options to pass to forget cmd
            '';
            example = [
              "--keep-last 3"
            ];
          };
        };
      };
    }));

    default = { };
    example = {
      localbackup = {
        paths = [ "/home" ];
        repository = "/mnt/backup-hdd";
        passwordFile = "/etc/nixos/secrets/restic-password";
        initialize = true;
      };
      remotebackup = {
        paths = [ "/home" ];
        repository = "sftp:backup@host:/backups/home";
        passwordFile = "/etc/nixos/secrets/restic-password";
        extraOptions = [
          "sftp.command='ssh backup@host -i /etc/nixos/secrets/backup-private-key -s sftp'"
        ];
        timerConfig = {
          OnCalendar = "00:05";
          RandomizedDelaySec = "5h";
        };
      };
    };
  };

  config = mkIf cfgEnable {
    systemd.services =
      mapAttrs'
        (name: backup:
          let
            extraOptions = concatMapStrings (arg: " -o ${arg}") backup.extraOptions;
            resticCmd = "${pkgs.restic}/bin/restic${extraOptions}";
          in
          nameValuePair "restic-backups-${name}" ({
            environment = {
              RESTIC_PASSWORD_FILE = backup.passwordFile;
              RESTIC_REPOSITORY = backup.repository;
            };
            path = with pkgs; [
              openssh
            ];
            restartIfChanged = false;
            serviceConfig = {
              Type = "oneshot";
              ExecStart = "${resticCmd} backup ${concatStringsSep " " backup.extraBackupArgs} ${concatStringsSep " " backup.paths}";
              User = backup.user;
            } // optionalAttrs (backup.s3CredentialsFile != null) {
              EnvironmentFile = backup.s3CredentialsFile;
            };
          } // optionalAttrs backup.initialize {
            preStart = ''
              ${resticCmd} snapshots || ${resticCmd} init
            '';
          } // optionalAttrs backup.policy.enable {
            postStart = ''
              ${resticCmd} forget ${concatStringsSep " " backup.policy.args}
            '';
          })
        )
        cfg;

    systemd.timers =
      mapAttrs'
        (name: backup: nameValuePair "restic-backups-${name}" {
          wantedBy = [ "timers.target" ];
          timerConfig = backup.timerConfig;
        })
        cfg;

    environment.systemPackages =
      attrValues (
        mapAttrs'
          (name: backup:
            let
              extraOptions = concatMapStrings (arg: " -o ${arg}") backup.extraOptions;
              resticCmd = "${pkgs.restic}/bin/restic ${extraOptions}";
            in
            nameValuePair "restic-backups-${name}" (pkgs.writeShellScriptBin "restic-backups-${name}" ''
              set -e
              ${optionalString (backup.s3CredentialsFile != null) "for i in $(cat ${backup.s3CredentialsFile});do export $i;done"}
              export RESTIC_PASSWORD_FILE=${backup.passwordFile}
              export RESTIC_REPOSITORY=${backup.repository}
              ${resticCmd} $@
            ''
            ))
          cfg
      );
  };
}
