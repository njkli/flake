;; -*- mode: emacs-lisp; -*-
((nix-mode . ((eval . (let* ((current-dir (substitute-in-file-name "$PRJ_ROOT"))
                             (repl-init (substitute-in-file-name  "$PRJ_ROOT/shell/bud/scripts/utils-repl/repl.nix"))
                             (default-args '("repl" "--argstr" "host" "NixOS" "--argstr" "flakePath"))
                             (all-args (append default-args (list current-dir repl-init))))
                        (setq nix-repl-executable-args all-args))))))
