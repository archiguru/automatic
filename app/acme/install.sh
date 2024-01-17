acme.sh --issue --dns dns_dp -d rsshub.in

acme.sh --install-cert -d example.com \
    --key-file ssl/rsshub.in.crt \
    --fullchain-file ssl/rsshub.in.key \
    --reloadcmd "service nginx force-reload"

acme.sh
ID 466689
Token c09c3ea3ba21ad1d27cd495b1c652909

acme.sh --issue --dns dns_dp -d 'rsshub.in' -d '*.rsshub.in'

~/.acme.sh/acme.sh --force --install-cert -d ${domain} --fullchain-file ${PATH_SSL}/${domain}.crt --key-file ${PATH_SSL}/${domain}.key --reloadcmd "${Command}" >/dev/null

~/.acme.sh/acme.sh --force --issue --test -k 4096 --dns dns_dp -d 'rsshub.in' -d 'www.rsshub.in' --debug 2

acme.sh --install-cert -d rsshub.in --debug 2 \
    --key-file /usr/local/openresty/nginx/conf/ssl/rsshub.in.key \
    --fullchain-file /usr/local/openresty/nginx/conf/ssl/rsshub.in.pem \
    --reloadcmd "systemctl restart nginx.service"

acme.sh --install-cert -d rsshub.in --debug 2 \
    --key-file /usr/local/openresty/nginx/conf/ssl/rsshub.in.key \
    --fullchain-file /usr/local/openresty/nginx/conf/ssl/rsshub.in_fullchain.cer \
    --reloadcmd "service nginx force-reload"

rm -rf ai.eoysky.com
rm -rf api.pandatalk.cn
rm -rf dl.jonnyhub.com
rm -rf file.eoysky.com
rm -rf filehub.eoysky.com
rm -rf myclient.pandatalk.cn
rm -rf nas.eoysky.com
rm -rf pandatalk.cn
rm -rf panel.rsshub.in
rm -rf pvm.eoysky.com
rm -rf rsshub.in
rm -rf rsshub.in
rm -rf static.pandatalk.cn
rm -rf surge.lmsite.cn

file.eoysky.com
filehub.eoysky.com myclient.pandatalk.cn nas.eoysky.com pandatalk.cn panel.rsshub.in pvm.eoysky.com rsshub.in rsshub.in static.pandatalk.cn sub.eoysky.com surge.lmsite.cn
