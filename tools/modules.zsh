local zmodule zurl ztype zrev
local -a zmodules
local -A zoptions
zstyle -a ':zim' modules 'zmodules'
for zmodule in ${zmodules}; do
  zstyle -a ':zim:module' ${zmodule} 'zoptions'
  [[ ${zoptions[frozen]} == yes ]] && continue
  zurl=${zoptions[url]:-${zmodule}}
  if [[ ${zurl} != /* && ${zurl} != *@*:* ]]; then
    # Count number of slashes
    case ${#zurl//[^\/]/} in
      0) zurl="https://github.com/zimfw/${zurl}.git" ;;
      1) zurl="https://github.com/${zurl}.git" ;;
    esac
  fi
  if [[ -n ${zoptions[tag]} ]]; then
    ztype=tag
    zrev=${zoptions[tag]}
  else
    ztype=branch
    zrev=${zoptions[branch]:-master}
  fi
  # Cannot have an empty space at the EOL because this is read by xargs -L1
  print "${zurl} ${ZIM_HOME}/modules/${zmodule} ${ztype} ${zrev}${1:+ ${1}}"
done