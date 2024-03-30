BASE_COMMAND = nvim --cmd 'cd lua/ | source tmuxcolors.lua | source ../plugin/tmuxcolors.vim'

.PHONY: tmux
tmux:
	${BASE_COMMAND}
