setopt PROMPT_SUBST
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
# zsh
##############
is_k8s_directory() {
  for file in *.yaml(N) *.yml(N); do
    if [ -f "$file" ] && grep -q "apiVersion:" "$file"; then
      return 0
    fi
  done
  return 1
}
get_project_path() {
  local project_root=""
  local prefix=""
  
  # まず、プロジェクトルートのマーカー (.idea, .vscode, .golangci.yaml)
  local dir="$PWD"
  while [[ "$dir" != "/" ]]; do
    if [[ -d "$dir/.idea" || -d "$dir/.vscode" || -f "$dir/.golangci.yaml" ]]; then
      project_root="$dir"
      prefix=$(basename "$dir")
      break
    fi
    dir=$(dirname "$dir")
  done

  if [[ -z "$project_root" && $(git rev-parse --is-inside-work-tree 2>/dev/null) == "true" ]]; then
    project_root=$(git rev-parse --show-toplevel)
    prefix=$(basename "$project_root")
  fi

  if [[ -n "$project_root" ]]; then
    local rel_path="${PWD#$project_root}"
    rel_path="${rel_path#/}"
    if [[ -n "$rel_path" ]]; then
      echo "${prefix}/${rel_path}"
    else
      echo "${prefix}"
    fi
  else
    print -P "%~"
  fi
}

autoload -U colors && colors
source "/opt/homebrew/opt/kube-ps1/share/kube-ps1.sh"

PROMPT='$(is_k8s_directory && echo "%F{blue}$(kube_ps1)%f")
%F{#00cf00}%n@%m%f %F{#00a0ff}$(get_project_path)%f%(!.#.$) '

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
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
for version in $(ls ~/.asdf/installs/golang); do
    export PATH=$PATH:~/.asdf/installs/golang/$version/go/bin:$GOPATH/bin
done

##############
# peco
##############
alias kc='kubectx | peco | xargs kubectx'
alias kn='kubens | peco | xargs kubens'
alias tw='terraform workspace list | peco | xargs terraform workspace select'
alias ap='export AWS_PROFILE=$(aws configure list-profiles | peco | xargs)'
