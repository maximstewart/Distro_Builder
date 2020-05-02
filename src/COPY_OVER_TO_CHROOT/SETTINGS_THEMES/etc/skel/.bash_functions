# Functions
w3mimg () {
    w3m -o imgdisplay=/usr/lib/w3m/w3mimgdisplay $1
}

phpServer () {
    authbind php -S 0.0.0.0:"$1"
}

function cl() {
    DIR="$*";
        # if no DIR given, go home
        if [ $# -lt 1 ]; then
                DIR=$HOME;
    fi;
    builtin cd "${DIR}" && \
    # use your preferred ls command
        ls -F --color=auto
}

# Gui select files wih Ctrl+G and python
select_files() {
  local files="$(python -c 'import Tkinter, tkFileDialog; Tkinter.Tk().withdraw(); print(" ".join(map(lambda x: "'"'"'"+x+"'"'"'", tkFileDialog.askopenfilename(multiple=1))))')"
  READLINE_LINE="${READLINE_LINE:0:READLINE_POINT}$files${READLINE_LINE:READLINE_POINT}"
  READLINE_POINT=$((READLINE_POINT + ${#files}))
}
bind -x '"\C-g":select_files'
