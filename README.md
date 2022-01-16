# HA WAF
In this repo, you can find a prototype of a HA WAF with Lets Encrypt certbot for HTTPS
# 1) configure data/nginx/nginx.conf GeoIP / IP allowlist
- set allowed countries
- set local LAN
- set allowed ISP ranges
# 2) configure data/nginx/conf.d/default.conf HA forwarding
- set server_name
- set cert paths
- set upstreamServer URL
# 3a) dry-run initial Lets Encrypt certs using DNS-01 challenge
- try a "dry-run" init-letsencrypt-dns.sh
`init-letsencrypt-dns.sh <comma-sepparated-list-of-3rdlevel.duckdns.org> <email> <duckdns-token>`
to avoid hitting request limits, staging LE platform is used to check functionality
# 3b) run initial Lets Encrypt certs using DNS-01 challenge
- if successful, repeat and add 4th parameter = staging with value 0 = uses live API
`init-letsencrypt-dns.sh <comma-sepparated-list-of-3rdlevel.duckdns.org> <email> <duckdns-token> 0`
note: docker-compose up -d is run at the end to launch the reverse proxy & automatic (daily) certbot renewal
# 4) configure HASS
- configure HASS reverse proxy access - see use_x_forwarded_for, and trusted_proxies at https://www.home-assistant.io/integrations/http

# TODO:
- no root nginx 

# tribute to 
LE https://medium.com/@pentacent/nginx-and-lets-encrypt-with-docker-in-less-than-5-minutes-b4b8a60d3a71
WAF https://www.adventurousway.com/blog/home-assistant-web-application-firewall?utm_source=redit&utm_medium=homeassistant&utm_campaign=waf
