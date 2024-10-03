source ~/.zsh_profile
PATH=/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/Apple/usr/bin:"/Users/na2na/Library/Application Support/JetBrains/Toolbox/scripts"

export PATH="/opt/homebrew/bin:$PATH"

. "$HOME/.asdf/asdf.sh"

# pnpm
export PNPM_HOME="/Users/na2na/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

autoload bashcompinit && bashcompinit
autoload -Uz compinit && compinit

complete -C '~/.asdf/shims/aws_completer' aws
complete -C '~/.asdf/shims/aws_completer' awslocal
source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"

function estart() {
  if ! emacsclient -e 0 > /dev/null 2>&1; then
    cd > /dev/null 2>&1
    emacs --daemon
    cd - > /dev/null 2>&1
  fi
}

alias E='emacsclient'
alias killemacs="emacsclient -e '(kill-emacs)'"

estart
export USE_GKE_GCLOUD_AUTH_PLUGIN=True


. /opt/homebrew/opt/asdf/libexec/asdf.sh
alias kc='kubectx | peco | xargs kubectx'
alias kn='kubens | peco | xargs kubens'
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export PATH="/opt/homebrew/opt/mysql-client@8.3.0/bin:$PATH"
