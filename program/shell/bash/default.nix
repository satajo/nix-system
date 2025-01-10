{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nano
  ];

  programs.bash = {
    interactiveShellInit = ''
      # Set default editors
      export EDITOR="nano"
      export VISUAL="nano"

      # Increase history size from the defaults.
      HISTSIZE=10000
      HISTFILESIZE=20000

      # Ignore commands with leading space, and keep only one duplicate around.
      HISTCONTROL=ignorespace:ignoredups:erasedups

      # Append to the history file, don't overwrite it.
      shopt -s histappend

      # Save multi-line commands as one entry.
      shopt -s cmdhist

      # Append to history immediately after each command
      PROMPT_COMMAND="history -a"

      # Set window title to the working directory.
      PROMPT_COMMAND="$PROMPT_COMMAND; echo -ne \"\033]0;Terminal - \$PWD\007\""
    '';
  };
}
