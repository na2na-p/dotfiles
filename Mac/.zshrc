JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-19.jdk/Contents/Home
PATH=/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/Apple/usr/bin:"/Users/na2na/Library/Application Support/JetBrains/Toolbox/scripts":/Library/Java/JavaVirtualMachines/jdk-19.jdk/Contents/Home/bin

export PATH="/opt/homebrew/bin:$PATH"

export JAVA_HOME=`/usr/libexec/java_home -v "11"`
PATH=$JAVA_HOME/bin:$PATH
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

alias E='emacsclient'
alias killemacs="emacsclient -e '(kill-emacs)'"
