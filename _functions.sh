function make_gam_sheet_update_json {
    # read list from stdin and generate GAM Sheet update json for named range
    range="$1"; shift
    jq -n --slurpfile data <(jq -R '[.]') '[{"range":"'"$range"'","majorDimension":"ROWS"}] | .[0].values=$data'

}

function info {
    # print info headergit 
    echo -e "*\n*\n*\n***  $*  ***\n*"
}
