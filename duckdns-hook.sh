#!/usr/bin/env sh
# inspired by https://www.splitbrain.org/blog/2017-08/10-homeassistant_duckdns_letsencrypt
set -e
set -u
set -o pipefail

domain="${CERTBOT_DOMAIN}"
token="$2"
txt="${CERTBOT_VALIDATION}"

which curl || :
if [[ $? -eq 0 ]]; then
  http_method=curl
fi

which wget || : 
if [[ $? -eq 0 ]]; then
  http_method=wget
else
  echo "Neither CURL nor WGET installed"
  exit
fi

curl_options="-q"
wget_options="-q"

case "$1" in
    "deploy_challenge")
        url="https://www.duckdns.org/update?domains=$domain&token=$token&txt=${txt}&verbose=true"
        if [[ ${http_method} == "curl" ]]; then
          curl "${url}" ${curl_options}
        elif [[ ${http_method} == "wget" ]]; then
          wget "${url}" ${wget_options}
        fi
        echo
        ;;
    "clean_challenge")
        url="https://www.duckdns.org/update?domains=$domain&token=$token&txt=removed&clear=true"
        if [[ ${http_method} == "curl" ]]; then
          curl "${url}" ${curl_options}
        elif [[ ${http_method} == "wget" ]]; then
          wget "${url}" ${wget_options}
        fi
        echo
        ;;
    "deploy_cert")
#        sudo systemctl restart home-assistant@homeassistant.service
        ;;
    "unchanged_cert")
        ;;
    "startup_hook")
        ;;
    "exit_hook")
        ;;
    *)
        echo Unknown hook "${1}"
        exit 0
        ;;
esac
