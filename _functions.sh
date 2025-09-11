set -o pipefail -o errexit -o errtrace -o nounset
# from https://gist.github.com/ahendrix/7030300
function errexit() {
  local err=$?
  set +o xtrace
  local code="${1:-1}"
  echo "Error in ${BASH_SOURCE[1]}:${BASH_LINENO[0]} '${BASH_COMMAND}' exited with status $err"
  # Print out the stack trace described by $function_stack  
  if [ ${#FUNCNAME[@]} -gt 2 ]
  then
    echo "Call tree:"
    for ((i=1;i<${#FUNCNAME[@]}-1;i++))
    do
      echo " $i: ${BASH_SOURCE[$i+1]}:${BASH_LINENO[$i]} ${FUNCNAME[$i]}(...)"
    done
  fi
  echo "Exit with status ${code}"
  exit "${code}"
}
trap 'errexit' ERR
set -o errtrace

gam="$HOME/bin/gamadv-xtd3/gam"

function make_gam_sheet_update_json {
    # read list from stdin and generate GAM Sheet update json for named range
    range="$1"; shift
    jq -n --slurpfile data <(jq -R '[.]') '[{"range":"'"$range"'","majorDimension":"ROWS"}] | .[0].values=$data'

}

function info {
    # print info headergit 
    echo -e "*\n*\n*\n***  $*  ***\n*"
}

function die {
    echo -e "*\n*\n*\nERROR\n*\n$*\n"
    exit 2
}

function make_temp_file {
    local suffix="${1:-}"
    local f
    local base
    base=$(basename "$0")
    f=$(mktemp -t "${base%.*}-${suffix}XXXXXXXXXXXXXX")
    echo "$f"
}

if [ ! -x "$gam" ] ; then
    die "Need https://github.com/taers232c/GAMADV-XTD3 in $gam, please install"
fi