# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Show the project name (e.g. "cut-and-dry") instead of the opaque worktree
# hash (e.g. "ogml") when cwd is inside ~/.cursor/worktrees/<project>/<hash>.
_cursor_prompt_dir() {
  local worktree_root="$HOME/.cursor/worktrees"
  if [[ "$PWD" == "$worktree_root"/* ]]; then
    local rel="${PWD#$worktree_root/}"
    echo "${rel%%/*}"
  else
    echo "${PWD##*/}"
  fi
}
PROMPT="%(?:%{$fg_bold[green]%}%1{➜%} :%{$fg_bold[red]%}%1{➜%} ) %{$fg[cyan]%}\$(_cursor_prompt_dir)%{$reset_color%}"
PROMPT+=' $(git_prompt_info)'

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
# Fetch latest remote refs before launching Claude agents, so new worktrees
# (worktree.baseRef = fresh) branch off the up-to-date origin/<main>.
cc() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 && git fetch --quiet origin
  claude agents --cwd ./
}

# Ask Claude for a single shell command, confirm, then run it.
# `cs` uses sonnet (trickier, multi-step lookups), `ch` uses haiku (fast recall).
# The model gets NO tools (--tools ""); it only writes text. Nothing executes
# until you press a key, and it runs in THIS shell so `cd`/`export` stick.
_cc_cmd() {
  local model="$1"; shift
  local prompt="$*"
  if [[ -z "$prompt" ]]; then
    print -u2 "usage: cs|ch <what you want to do>"
    return 2
  fi

  local sys="Translate the request into ONE shell command for macOS zsh.
Output ONLY the command itself: no markdown fences, no backticks, no commentary.
Prefer a single line, using pipes where needed.
Current directory: $PWD"

  local cmd
  cmd=$(claude -p --model "$model" --tools "" --system-prompt "$sys" -- "$prompt") || return $?

  # Defensive: strip stray code fences / blank lines if the model adds them.
  cmd=$(print -r -- "$cmd" | sed -e '/^[[:space:]]*```/d' -e '/^[[:space:]]*$/d')
  [[ -n "$cmd" ]] || { print -u2 "no command returned"; return 1; }

  while true; do
    print -r -- ""
    print -r -- "  $cmd"
    print -rn -- $'\nRun? [Y/e/x/n] '
    local ans; read -r ans
    case "${ans:l}" in
      ""|y|yes)
        print -s -- "$cmd"   # zsh history: Up-arrow recalls it
        eval "$cmd"
        return $?
        ;;
      e)
        vared -p '> ' -c cmd
        ;;
      x)
        claude -p --model haiku --tools "" \
          --system-prompt "Explain this shell command concisely, one short line per stage. No preamble." \
          -- "$cmd"
        ;;
      *)
        print "cancelled"
        return 130
        ;;
    esac
  done
}

# noglob so questions containing ? or * don't trip zsh globbing.
alias cs='noglob _cc_cmd sonnet'
alias ch='noglob _cc_cmd haiku'

export PATH="$HOME/.local/bin:$PATH"
. /opt/homebrew/etc/profile.d/z.sh

# pnpm
export PNPM_HOME="/Users/udnisap/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Added by Windsurf
export PATH="/Users/udnisap/.codeium/windsurf/bin:$PATH"

# bun completions
[ -s "/Users/udnisap/.bun/_bun" ] && source "/Users/udnisap/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

alias br="agent-browser --auto-connect"
#export AGENT_BROWSER_AUTO_CONNECT=1
