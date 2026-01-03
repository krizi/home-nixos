ZSH_THEME="robbyrussell"
HYPHEN_INSENSITIVE="true"

zstyle ':omz:update' mode auto

zstyle ':omz:update' frequency 2

ENABLE_CORRECTION="true"

COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"

HIST_STAMPS="dd.mm.yyyy"

plugins=(
	git
	zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh
