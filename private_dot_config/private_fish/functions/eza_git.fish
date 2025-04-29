function eza_git -d "Use eza and it's git options if in a git repo"
	if git rev-parse --is-inside-work-tree &>/dev/null
		eza $FISH_EZA_STANDARD_OPTIONS --git $argv
	else
		eza $FISH_EZA_STANDARD_OPTIONS $argv
	end
end
