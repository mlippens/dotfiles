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
alias p pnpm
alias ls eza
alias ll "eza -lah"

set EDITOR nvim
set -gx NVIM_APPNAME lazyvim

function xc --description "Pipe to xc to copy to the system clipboard (uses xclip)"
    xclip -selection clipboard $argv
end
function xpj --description "Pipe clipboard to jq (using xclip)"
    xclip -selection clipboard -o | jq .
end

if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
    fenv "source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
end

#eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /home/michael/miniconda3/bin/conda
    eval /home/michael/miniconda3/bin/conda "shell.fish" hook $argv | source
else
    if test -f "/home/michael/miniconda3/etc/fish/conf.d/conda.fish"
        . "/home/michael/miniconda3/etc/fish/conf.d/conda.fish"
    else
        set -x PATH /home/michael/miniconda3/bin $PATH
    end
end
# <<< conda initialize <<<


if status is-interactive
    fzf --fish | source
    zoxide init fish | source
    direnv hook fish | source
    fnm env --use-on-cd --shell fish | source

    # should be last
    starship init fish | source
end
