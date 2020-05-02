# Aliases

# youtube-dl commands simplified
alias ytdl='youtube-dl'
alias ytdl-fix='youtube-dl --rm-cache-dir'
alias ytdl-list='youtube-dl -F'
alias ytdl-use-specific-quality='youtube-dl -f'


# This overrides cp command with rsync and a timer
alias cp='rsync -ah --info=progress2'
alias wget='wget -c'
alias rm="rm -rf"
alias cls='clear'
alias less="less -S +G"
alias ls="ls -F -h -s --group-directories-first --color=always"
alias lt='ls --human-readable --size -1 -S --classify'
alias mnt="mount | awk -F' ' '{ printf \"%s\t%s\n\",\$1,\$3; }' | column -t | egrep ^/dev/ | sort"
alias gh='history|grep'
alias count='find . -type f | wc -l'
alias trash='mv --force -t ~/.local/share/Trash'
alias refresh-bash='. ~/.bashrc'


# reboot / halt / poweroff / etc
alias reboot='sudo /sbin/reboot'
alias poweroff='sudo /sbin/poweroff'
alias halt='sudo /sbin/halt'
alias shutdown='sudo /sbin/shutdown'

#gdb no copyright start and use better gui look
alias gdb='gdb -tui -q'

#Git
alias gitA="git add -A ."
alias gitC="git commit -m"
alias gitP="git push"

#Firefox
alias ff="firefox"
alias ffnrm="firefox --no-remote"

# Python
alias pySimpleServer='python -m SimpleHTTPServer'
alias pyCgiServer='python -m CGIHTTPServer'
alias py-venv='python3 -m venv ./'
alias py-src-activate='source ./bin/activate'
alias py-freeze='pip freeze --local > requirements.txt'


# MPV/MPLAYER Commands #
alias generate-mp4-playlist="\ls -1v *.mp4 > ./000_playlist.m3u"
alias generate-mkv-playlist="\ls -1v *.mkv > ./000_playlist.m3u"
alias generate-webm-playlist="\ls -1v *.webm > ./000_playlist.m3u"
alias mpv-playlist-loop="mpv --loop-playlist"

# mplayer frameebuffer
alias mplayerfb="mplayer -vo fbdev2 -zoom -x 800 -y 600"

# play all music files from the current directory #
alias playwaves='for i in *.wav; do mplayer "$i"; done'
alias playoggs='for i in *.ogg; do mplayer "$i"; done'
alias playmp3s='for i in *.mp3; do mplayer "$i"; done'



# Servers
alias start-wfm='cd ~/LazyShare/ && phpServer 8080'
