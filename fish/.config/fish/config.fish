if status is-interactive
    # Commands to run in interactive sessions can go here
    fish_vi_key_bindings
end

# set up awscli tab completion
complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'

fish_add_path ~/bin
fish_add_path ~/.local/bin
fish_add_path ~/.cargo/bin

# Load local environment variables if the file exists
if test -f ~/.config/fish/local.env
    source ~/.config/fish/local.env
end

alias g git
alias vi nvim
alias vim nvim
alias k kubectl
alias h helm
alias p pnpm
alias ls eza
alias ll "eza -lah"

set EDITOR nvim
set -gx NVIM_APPNAME lazyvim

function xc --description "Pipe to xc to copy to the system clipboard (uses wl-copy)"
    wl-copy $argv
end
function xpj --description "Pipe clipboard to jq (using xclip)"
    wl-copy -o | jq .
end

if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
    fenv "source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
end

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# opencode
fish_add_path /home/michael/.opencode/bin
source ~/.safe-chain/scripts/init-fish.fish # Safe-chain Fish initialization script

if status is-interactive
    fzf --fish | source
    zoxide init fish | source
    direnv hook fish | source
    fnm env --use-on-cd --shell fish | source

    # should be last
    starship init fish | source
end
