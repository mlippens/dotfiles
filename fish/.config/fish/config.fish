if status is-interactive
    # Commands to run in interactive sessions can go here
end

# set up awscli tab completion
complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'

eval "$(/opt/homebrew/bin/brew shellenv)"

fish_add_path ~/bin
fish_add_path ~/.local/bin

fish_add_path /opt/homebrew/opt/mysql-client/bin
# nix path; due to lack of fish integration in /etc/default
fish_add_path /run/current-system/sw/bin

set EDITOR nvim

alias g git
alias vi nvim
alias vim nvim
alias p pnpm
alias pu pulumi
alias cdk "npx --yes cdk"
alias ls "eza"
alias ll "eza -lah"
alias yal "aws sso login --profile=yuso"

if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
end

fzf --fish | source
zoxide init fish | source
direnv hook fish | source
fnm env --use-on-cd --shell fish | source

# should be last
starship init fish | source
