#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# >>> yerd PATH >>>
case ":$PATH:" in
  *":/home/leal/.local/share/yerd/bin:"*) ;;
  *) export PATH="/home/leal/.local/share/yerd/bin:$PATH" ;;
esac
export PHPRC="/home/leal/.local/share/yerd/php-cli.ini"
# <<< yerd PATH <<<
