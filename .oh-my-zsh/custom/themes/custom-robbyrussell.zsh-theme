# Git status indicators
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%} ✅%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%} 🔴%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg_bold[green]%} 🟢%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg_bold[blue]%} 📝%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg_bold[red]%} 🗑️%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg_bold[magenta]%} 📎%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg_bold[yellow]%} ⚡%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg_bold[cyan]%} 🆕%{$reset_color%}"
# Git branch/status display function
git_custom_status() {
  local branch=$(git_current_branch)
  if [ -n "$branch" ]; then
    echo -n "%{$fg_bold[yellow]%}‹${branch}›%{$reset_color%}"
    
    if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
      # Repository is dirty
      if [ -n "$(git status --porcelain 2>/dev/null | grep '^??')" ]; then
        # Has untracked files
        echo -n "${ZSH_THEME_GIT_PROMPT_UNTRACKED}"
      fi
      if [ -n "$(git status --porcelain 2>/dev/null | grep '^[MADRC]')" ]; then
        # Has staged changes
        echo -n "${ZSH_THEME_GIT_PROMPT_ADDED}"
      fi
      if [ -n "$(git status --porcelain 2>/dev/null | grep '^[ MADRC][MD]')" ]; then
        # Has modifications
        echo -n "${ZSH_THEME_GIT_PROMPT_MODIFIED}"
      fi
    else
      # Repository is clean
      echo -n "${ZSH_THEME_GIT_PROMPT_CLEAN}"
    fi
  fi
}

# Main prompt
PROMPT='%{$fg_bold[cyan]%}%c%{$reset_color%} $(git_custom_status) %{$fg_bold[red]%}➜ %{$reset_color%}'
