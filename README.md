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
# 3) run initial Lets Encrypt certs using DNS-01 challenge
- run init-letsencrypt-dns.sh
`init-letsencrypt-dns.sh <comma-sepparated-list-of-3rdlevel.duckdns.org> <email> <duckdns-token>`
# 4) docker-compose up ?
# TODO:
- no root nginx 

# tribute to 
LE https://medium.com/@pentacent/nginx-and-lets-encrypt-with-docker-in-less-than-5-minutes-b4b8a60d3a71
WAF https://www.adventurousway.com/blog/home-assistant-web-application-firewall?utm_source=redit&utm_medium=homeassistant&utm_campaign=waf
