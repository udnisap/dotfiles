# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="agnoster"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
java
ack
adb
# bower
brew
colored-man-pages
# colorize
# command-not-found
cp
docker
git
# git-flow
gradle
# kubectl
# heroku
# jira
# mvn
node
npm
# nvm
# tmux
z
)

# User configuration

DEFAULT_USER=`whoami`
export NPM_TOKEN=''
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh
# source `brew --prefix`/etc/profile.d/z.sh
# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
# 
#
# Docker init
# eval "$(docker-machine env default)"

# export NVM_DIR="/Users/pasinduperera/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
# export ANDROID_HOME="/usr/local/opt/android-sdk"
export ANDROID_HOME="/usr/local/Cellar/android-sdk/24.4.1/"
export ANDROID_HOME="/Users/udnisap/Library/Android/sdk"
export ANDROID_SDK_ROOT="/Users/udnisap/Library/Android/sdk"

# The next line updates PATH for the Google Cloud SDK.
# source '/Users/pasinduperera/google-cloud-sdk/path.zsh.inc'

# The next line enables shell command completion for gcloud.
# source '/Users/pasinduperera/google-cloud-sdk/completion.zsh.inc'


# tabtab source for yo package
# uninstall by removing these lines or running `tabtab uninstall yo`
# [[ -f /Users/pasinduperera/.nvm/versions/node/v5.0.0/lib/node_modules/yo/node_modules/tabtab/.completions/yo.zsh ]] && . /Users/pasinduperera/.nvm/versions/node/v5.0.0/lib/node_modules/yo/node_modules/tabtab/.completions/yo.zsh
#

# Put it back to support nvm
# export NVM_DIR="$HOME/.nvm"
#   . "/usr/local/opt/nvm/nvm.sh"

# added by Anaconda3 4.4.0 installer
export PATH="/Users/pasinduperera/anaconda3/bin:$PATH"
export ANDROID_SDK_ROOT="/usr/local/share/android-sdk"
alias drun="docker run --rm"


export SDC_JAVA_OPTS="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=1044 -Dsdc.static-web.dir=/Users/udnisap/streamsets/datacollector/datacollector-ui/target/dist"
export DPM_JAVA_OPTS="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=1055 -Ddpm.static-web.dir=/Users/udnisap/streamsets/domainserver/server-ui/dist"

# Setup DPM_DIST AND SDC_DIST
# pushd /Users/udnisap/streamsets/datacollector/dist/target/streamsets-datacollector-3*/streamsets-datacollector-3*/ > /dev/null && export SDC_DIST=$(pwd) && popd > /dev/null
# pushd /Users/udnisap/streamsets/domainserver/build/install/streamsets-dpm*/ > /dev/null && export DPM_DIST=$(pwd) && popd > /dev/null

alias sdc="sh $SDC_DIST/bin/streamsets dc -verbose"
alias dpm="sh $DPM_DIST/bin/streamsets dpm -verbose"

alias mvnpackage="mvn clean package -Pdist -DskipTests -Ddist.filter=dev-mysql"
alias mvnpackageoffline="mvn clean package -Pui,dist,edge,offline -DskipTests -Ddist.filter=dev-mysql"
alias mvnrelease="mvn clean package -Pui,dist -DskipTests -Drelease -Ddist.filter=dev-mysql"
alias mvndev="mvn install -Pdist -DskipTests -Ddist.filter=dev-mysql"
alias colorlog="gsed -e 's/\(.*FATAL.*\)/\o033[1;31m\1\o033[0;39m/' -e 's/\(.*ERROR.*\)/\o033[31m\1\o033[39m/' -e 's/\(.*WARN.*\)/\o033[33m\1\o033[39m/' -e 's/\(.*INFO.*\)/\o033[32m\1\o033[39m/' -e 's/\(.*DEBUG.*\)/\o033[34m\1\o033[39m/' -e 's/\(.*TRACE.*\)/\o033[30m\1\o033[39m/' -e 's/\(.*[Ee]xception.*\)/\o033[1;39m\1\o033[0;39m/'"

ulimit -n 100000

export PATH="$PATH:/Users/udnisap/Projects/flutter/bin"
export EDITOR="nvim"



# The next line updates PATH for the Google Cloud SDK.
# if [ -f '/Users/udnisap/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/udnisap/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
# if [ -f '/Users/udnisap/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/udnisap/google-cloud-sdk/completion.zsh.inc'; fi
# if [ /usr/local/bin/kubectl ]; then source <(kubectl completion zsh); fi

java6() {
	export JAVA_HOME=$(/usr/libexec/java_home -v 1.6)
	java -version
}
java7() {
    export JAVA_HOME=$(/usr/libexec/java_home -v 1.7)
	java -version
}
java8() {
    export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
    java -version
}
java11() {
    export JAVA_HOME=$(/usr/libexec/java_home -v 11)
    java -version
}

# Fix for stupid Java bug that was causing all java processes to make a dock icon and steal focus
# (the second answer)
# http://stackoverflow.com/questions/10627405/how-to-set-java-system-properties-globally-on-os-x
export _JAVA_OPTIONS=-Djava.awt.headless=true

# ignore git folders for search
export FZF_DEFAULT_COMMAND='rg --files --follow --hidden'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
export PATH="/usr/local/opt/mysql-client/bin:$PATH"

# ntfy integration with pushbullet
# eval "$(ntfy shell-integration)"
# export AUTO_NTFY_DONE_IGNORE="nvim tmux node"

export PATH="/usr/local/opt/node@12/bin:$PATH"
