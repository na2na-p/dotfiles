if [ -f ~/.zsh_profile ]; then
  source ~/.zsh_profile
fi

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi

if [ -f $(brew --prefix)/etc/brew-wrap ];then
  source $(brew --prefix)/etc/brew-wrap
fi

##############
# MySQL
##############
export PATH="/opt/homebrew/opt/mysql-client@8.0/bin:$PATH"

##############
# Node.js
##############
export PNPM_HOME="~/.pnpm-home"
export PATH="$PNPM_HOME:$PATH"

##############
# pnpm
##############
export PNPM_HOME="/Users/na2na/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

##############
# 1Password
##############
eval "$(op completion zsh)"; compdef _op op

##############
# Google Cloud SDK
##############
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

##############
# AWS CLI
##############
complete -C '~/.asdf/shims/aws_completer' aws
complete -C '~/.asdf/shims/aws_completer' awslocal

##############
# emacs
##############
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

##############
# asdf
##############
. "$(brew --prefix)/opt/asdf/libexec/asdf.sh"
for version in $(ls ~/.asdf/installs/golang); do
    export PATH=$PATH:~/.asdf/installs/golang/$version/go/bin:$GOPATH/bin
done

##############
# peco
##############
alias kc='kubectx | peco | xargs kubectx'
alias kn='kubens | peco | xargs kubens'

