### OpenResty installation

#### RPM package manager installation

apt install rpm

#### Packages installation

rpm -ivh https://openresty.org/package/centos/7/aarch64/openresty-zlib-1.2.13-1.el7.aarch64.rpm
rpm -ivh https://openresty.org/package/centos/7/aarch64/openresty-openssl111-1.1.1w-1.el7.aarch64.rpm
rpm -ivh https://openresty.org/package/centos/7/aarch64/openresty-pcre-8.45-1.el7.aarch64.rpm
rpm -ivh https://openresty.org/package/centos/7/aarch64/openresty-1.21.4.3-1.el7.aarch64.rpm --nodeps

#### User/Group setup

groupadd -o -g 65534 nobody

#### Enable in systemd

systemctl daemon-reload
systemctl enable openresty
systemctl start openresty

rpm -ivh https://openresty.org/package/centos/7/aarch64/openresty-zlib-1.2.13-1.el7.aarch64.rpm
rpm -ivh https://openresty.org/package/centos/7/aarch64/openresty-openssl111-1.1.1w-1.el7.aarch64.rpm
rpm -ivh https://openresty.org/package/centos/7/aarch64/openresty-pcre-8.45-1.el7.aarch64.rpm
rpm -ivh https://openresty.org/package/centos/7/aarch64/openresty-1.21.4.3-1.el7.aarch64.rpm --nodeps
