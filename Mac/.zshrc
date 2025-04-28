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

precmd() {
  if is_k8s_directory; then
      # k8s ディレクトリの場合は kube_ps1 の出力と改行を設定
      KUBE_PS1_LINE="%F{blue}$(kube_ps1)%f"$'\n'
  else
      # そうでない場合は空文字にする
      KUBE_PS1_LINE=""
  fi

	if git rev-parse --is-inside-work-tree &>/dev/null; then
    local branch
    branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    GIT_PS1_LINE="%F{cyan}%F{yellow}branch:%f %F{magenta}${branch}%f"$'\n'
  else
    GIT_PS1_LINE=""
  fi
}

PROMPT='${KUBE_PS1_LINE}${GIT_PS1_LINE}%F{#00cf00}%n@%m%f %F{#00a0ff}$(get_project_path)%f%(!.#.$) '

##############
# MySQL
##############
export PATH="/opt/homebrew/opt/mysql-client@8.0/bin:$PATH"

##############
# PostgreSQL
##############
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

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
alias gc='gcloud config configurations list --format="value(name)" | peco | xargs -I {} sh -c "gcloud config configurations activate {} && gcloud auth application-default login --configuration={}"'

##############
# aliases
##############
alias k='kubectl'

##############
# functions
##############
function checkExternalIp() {
	curl -s http://checkip.amazonaws.com/ | tr -d '\n'
}
