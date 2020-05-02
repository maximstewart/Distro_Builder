# Paths Variable Settings
if [ -e $HOME/.bash_paths ]; then
    source $HOME/.bash_paths
fi

# Functions
if [ -e $HOME/.bash_colors ]; then
    source $HOME/.bash_colors
fi

# Aliases
if [ -e $HOME/.bash_aliases ]; then
    source $HOME/.bash_aliases
fi

# Functions
if [ -e $HOME/.bash_functions ]; then
    source $HOME/.bash_functions
fi

# Terminal look and feel with logo and then custom prompt line
if [ -e $HOME/.bash_ps1 ]; then
    source $HOME/.bash_ps1
fi

# Other non file specifoc settings
if [ -e $HOME/.bash_other ]; then
    source $HOME/.bash_other
fi

# Auto complete -- Note: Must have bash-completion package
if [ -f /etc/bash_completion ]; then
 . /etc/bash_completion
fi
