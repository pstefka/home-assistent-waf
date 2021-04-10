#!/bin/bash
# inspired by https://medium.com/@pentacent/nginx-and-lets-encrypt-with-docker-in-less-than-5-minutes-b4b8a60d3a71

if ! [ -x "$(command -v docker-compose)" ]; then
  echo 'Error: docker-compose is not installed.' >&2
  exit 1
fi

# comma separated domains
domains=$1
rsa_key_size=4096
data_path="./data/certbot"
email="$2" # Adding a valid address is strongly recommended
staging=${4:-1} # Set to 1 if you're testing your setup to avoid hitting request limits
token=$3

if [[ -z ${domains} ]]; then
  echo "Domains (param 1) must be specified (comma separated)"
  exit
fi

IFS=','
read -rasplitIFS<<< "$domains"

if [[ -z ${email} ]]; then
  echo "Email (param 2) must be specified"
  exit
fi

if [[ -z ${token} ]]; then
  echo "Duckdns token (param 3) must be specified"
  exit
fi

if [ -d "$data_path" ]; then
  read -p "Existing data found for $domains. Continue and replace existing certificate? (y/N) " decision
  if [ "$decision" != "Y" ] && [ "$decision" != "y" ]; then
    exit
  fi
fi

if [ ! -e "$data_path/conf/options-ssl-nginx.conf" ] || [ ! -e "$data_path/conf/ssl-dhparams.pem" ]; then
  echo "### Downloading recommended TLS parameters ..."
  mkdir -p "$data_path/conf"
  curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf > "$data_path/conf/options-ssl-nginx.conf"
  curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot/certbot/ssl-dhparams.pem > "$data_path/conf/ssl-dhparams.pem"
  echo
fi

echo "### Requesting Let's Encrypt certificate for $domains ..."
#Join $domains to -d args
domain_args=""
#for domain in "${domains[@]}"; do
for domain in "${splitIFS[@]}"; do
  domain_args="$domain_args -d $domain"
done

# Select appropriate email arg
case "$email" in
  "") email_arg="--register-unsafely-without-email" ;;
  *) email_arg="--email $email" ;;
esac

# Enable staging mode if needed
if [ $staging != "0" ]; then staging_arg="--staging"; fi

docker-compose run --rm --entrypoint "\
  certbot certonly --manual \
    --preferred-challenges dns \
    $staging_arg \
    $email_arg \
    $domain_args \
    --rsa-key-size $rsa_key_size \
    --agree-tos \
    --manual-auth-hook \"/duckdns-hook.sh deploy_challenge ${token}\" \
    --manual-cleanup-hook \"/duckdns-hook.sh clean_challenge ${token}\" \
    --force-renewal" certbot
echo

echo "### Reloading nginx ..."
docker-compose up --force-recreate -d nginx

