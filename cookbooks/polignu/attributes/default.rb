# Cookbook Name:: polignu
# __Attribute::__server__
#
# Copyright (C) 2016 Diego Rabatone Oliveira.
#
# This file is part of PoliGNU SiteDeploy project.
#
# SiteDeploy is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option) any
# later version.

# SiteDeploy is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# PoliGNU SiteDeploy project.  If not, see <http://www.gnu.org/licenses/>.

# mysql/mariaDB
default["db"]["root_password"] = nil
default["db"]["polignu"]["user"] = nil
default["db"]["polignu"]["password"] = nil
default["db"]["polignu"]["database_name"] = nil
default["db"]["poligen"]["user"] = nil
default["db"]["poligen"]["password"] = nil
default["db"]["poligen"]["database_name"] = nil
default["db"]["users_privileges"] = [:select, :update, :insert]
default["db"]["bind_address"] = nil

# System
default["linux_user"] = "vagrant"
default["users"] = ["polignu"]
default["authorization"]["sudo"]["groups"] = ["vagrant", "polignu", "wheel", "sysadmin"]
default["authorization"]["sudo"]["users"] = ["vagrant", "polignu"]
default["authorization"]["sudo"]["passwordless"] = "false"

default["std"]["server_name"] = "localhost"
default["std"]["ssl_public_port"] = 443

# nginx
default["nginx"]["real_ip_from"] = "172.24.0.32"
# We will use the "000-default" vhost template to block ilegal host headers.
default["nginx"]["default_site_enabled"] = true
default["nginx"]["php_backend_port"] = "8080"

#hhvm
default["hhvm"]["php"]["memory_limit"] = "600M"
default["hhvm"]["php"]["post_max_size"] = "22M"
default["hhvm"]["php"]["upload_max_filesize"] = "22M"
default["hhvm"]["php"]["debug_mode"] = false
default["hhvm"]["server"]["socket_file"] = "/var/run/hhvm/hhvm.sock"

# varnish
default["varnish"]["host"] = "127.0.0.1"
default["varnish"]["port"] = "6081"

# PoliGNU configs
default["polignu"]["server_name"]  = "polignu.org"
default["polignu"]["ssl"]["public_port"] = 443
default["polignu"]["ssl"]["certificate"] = nil  # /etc/letsencrypt/live/polignu.org/fullchain.pem
default["polignu"]["ssl"]["certificate_key"] = nil  # /etc/letsencrypt/live/polignu.org/privkey.pem
default["polignu"]["ssl"]["trusted_certificate"] = nil  # /etc/letsencrypt/live/polignu.org/fullchain.pem

# Let's Encrypt
default['acme']['contact'] = 'poli@gnu.org'
if node.default['environment'] == 'staging'
    default['acme']['endpoint'] = 'https://acme-staging.api.letsencrypt.org/directory'
end	
