# encoding: UTF-8
# # -*- mode: ruby -*-
# # vi: set ft=ruby :
#
# Cookbook Name:: polignu
# Recipe:: default
#
# Reference for creating a recepie: https://docs.chef.io/resources.html

user = node['linux_user']

####################################
# Setting up directories variables #
####################################
polignu = "/home/#{user}/polignu"
www_folder = "#{polignu}/www"
polignu_www = "#{www_folder}/multidrupal"
configs = "#{polignu}/confs"
confs_nginx = "#{configs}/nginx"
confs_nginx_settings = "#{confs_nginx}/polignu_settings"
confs_nginx_available = "#{confs_nginx}/sites-available"
main_nginx = "/etc/nginx"
main_nginx_drupal = "#{main_nginx}/apps/drupal"
main_nginx_available = "#{main_nginx}/sites-available"
main_nginx_enabled = "#{main_nginx}/sites-enabled"
confs_hhvm = "#{configs}/hhvm"
confs_varnish = "#{configs}/varnish"
ssl_folder = "/etc/nginx/ssl"  # To be removed

#######################
# Add new apt sources #
#######################
package 'software-properties-common'

apt_repository 'hhvm' do
  uri           'http://dl.hhvm.com/ubuntu'
  components    ['main']
  distribution  'xenial'
  key           '0x5a16e7281be7a449'
end

execute 'apt-get update'

#############################
# Install packages with APT #
#############################

# Install openssl
package 'openssl'

# Install HHVM
package 'hhvm'

# Install MariaDB
package 'mariadb-server'

# Install Varnish
package 'varnish'

# Install letsencrypt client
package "letsencrypt"

# Install nginx
package 'nginx'

# Install drush (drupal command line utility)
package "drush"

###########################################
# Create directories to hold config files #
###########################################
directory polignu do
  owner user
  group user
  mode '755'
  recursive true
  action :create
end

directory www_folder do
  owner user
  group user
  mode '755'
  recursive true
  action :create
end

directory ssl_folder do
  mode '755'
  recursive true
  action :create
end

directory configs do
  owner user
  group user
  mode '755'
  recursive true
  action :create
end

directory confs_nginx do
  owner user
  group user
  mode '755'
  recursive true
  action :create
end

directory confs_nginx_settings do
  owner user
  group user
  mode '755'
  recursive true
  action :create
end

directory main_nginx_drupal do
  owner user
  group user
  mode '755'
  recursive true
  action :create
end

directory confs_nginx_available do
  owner user
  group user
  mode '755'
  recursive true
  action :create
end

directory confs_hhvm do
  owner user
  group user
  mode '755'
  recursive true
  action :create
end

directory confs_varnish do
  owner user
  group user
  mode '755'
  recursive true
  action :create
end

directory '/var/cache/nginx/microcache' do
  owner user
  group user
  mode '755'
  recursive true
  action :create
end

#############################
# Setup configuration files #
#############################

# HHVM SETUP
template "etc/default/hhvm" do
  mode '644'
  owner "root"
  group "root"
  source 'hhvm/default.hhvm.erb'
  variables(
    user: user
  )
end

template "#{confs_hhvm}/php.ini" do
  mode '644'
  owner "root"
  group "root"
  source 'hhvm/php.ini.erb'
  variables(
    memory_limit: node['hhvm']['php']['memory_limit'],
    post_max_size: node['hhvm']['php']['post_max_size'],
    upload_max_filesize: node['hhvm']['php']['upload_max_filesize'],
    debug_mode: node['hhvm']['php']['debug_node']
  )
end

link '/etc/hhvm/php.ini' do
  to "#{confs_hhvm}/php.ini"
end

template "#{confs_hhvm}/server.ini" do
  mode '644'
  owner "root"
  group "root"
  source 'hhvm/server.ini.erb'
  variables(
    hhvm_socket_file: node['hhvm']['server']['socket_file']
  )
end

link '/etc/hhvm/server.ini' do
  to "#{confs_hhvm}/server.ini"
end

# VARNISH SETUP
template "#{confs_varnish}/etc.default.varnish" do
  mode '644'
  owner "root"
  group "root"
  source 'varnish/etc.default.varnish.erb'
end

link "/etc/default/varnish" do
  to "#{confs_varnish}/etc.default.varnish"
end

template "/etc/varnish/default.vcl" do
  mode '644'
  owner "root"
  group "root"
  source 'varnish/etc.varnish.default.vcl.erb'
end

template "/etc/systemd/system/varnish.service" do
  mode '644'
  owner "root"
  group "root"
  source 'varnish/varnish.service.erb'
end

# Generationg dhparam file (see nginx.ssl_setup.conf.erb for more info)
execute 'generate dhparam' do
  command "openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048"
  only_if { not File.exist? '/etc/ssl/certs/dhparam.pem' }
end

# nginx setup
# This index is for test purposes
cookbook_file "#{www_folder}/index.html" do
  mode '644'
  source 'test.html'
end

cookbook_file "#{ssl_folder}/nginx.crt" do
  mode '644'
  source 'nginx.crt'
end

cookbook_file "#{ssl_folder}/nginx.key" do
  mode '644'
  source 'nginx.key'
end

cookbook_file "#{main_nginx}/mime.types" do
  mode '644'
  source 'nginx/mime.types'
end

cookbook_file "#{main_nginx}/fastcgi.conf" do
  mode '644'
  source 'nginx/fastcgi.conf'
end

cookbook_file "#{main_nginx}/fastcgi_params" do
  mode '644'
  source 'nginx/fastcgi_params'
end

cookbook_file "#{main_nginx}/map_block_http_methods.conf" do
  mode '644'
  source 'nginx/map_block_http_methods.conf'
end

cookbook_file "#{main_nginx}/reverse_proxy.conf" do
  mode '644'
  source 'nginx/reverse_proxy.conf'
end

cookbook_file "#{main_nginx}/nginx_status_allowed_hosts.conf" do
  mode '644'
  source 'nginx/nginx_status_allowed_hosts.conf'
end

cookbook_file "#{main_nginx}/blacklist.conf" do
  mode '644'
  source 'nginx/blacklist.conf'
end

cookbook_file "#{main_nginx}/fastcgi_microcache_zone.conf" do
  mode '644'
  source 'nginx/fastcgi_microcache_zone.conf'
end

cookbook_file "#{main_nginx_drupal}/admin_basic_auth.conf" do
  mode '644'
  source 'nginx/apps/drupal/admin_basic_auth.conf'
end

cookbook_file "#{main_nginx_drupal}/cron_allowed_hosts.conf" do
  mode '644'
  source 'nginx/apps/drupal/cron_allowed_hosts.conf'
end

cookbook_file "#{main_nginx_drupal}/drupal_boost.conf" do
  mode '644'
  source 'nginx/apps/drupal/drupal_boost.conf'
end

cookbook_file "#{main_nginx_drupal}/drupal_boost_escaped.conf" do
  mode '644'
  source 'nginx/apps/drupal/drupal_boost_escaped.conf'
end

cookbook_file "#{main_nginx_drupal}/drupal.conf" do
  mode '644'
  source 'nginx/apps/drupal/drupal.conf'
end

cookbook_file "#{main_nginx_drupal}/drupal_cron_update.conf" do
  mode '644'
  source 'nginx/apps/drupal/drupal_cron_update.conf'
end

cookbook_file "#{main_nginx_drupal}/drupal_escaped.conf" do
  mode '644'
  source 'nginx/apps/drupal/drupal_escaped.conf'
end

cookbook_file "#{main_nginx_drupal}/drupal_install.conf" do
  mode '644'
  source 'nginx/apps/drupal/drupal_install.conf'
end

cookbook_file "#{main_nginx_drupal}/drupal_upload_progress.conf" do
  mode '644'
  source 'nginx/apps/drupal/drupal_upload_progress.conf'
end

cookbook_file "#{main_nginx_drupal}/fastcgi_drupal.conf" do
  mode '644'
  source 'nginx/apps/drupal/fastcgi_drupal.conf'
end

cookbook_file "#{main_nginx_drupal}/fastcgi_no_args_drupal.conf" do
  mode '644'
  source 'nginx/apps/drupal/fastcgi_no_args_drupal.conf'
end

cookbook_file "#{main_nginx_drupal}/hotlinking_protection.conf" do
  mode '644'
  source 'nginx/apps/drupal/hotlinking_protection.conf'
end

cookbook_file "#{main_nginx_drupal}/map_cache.conf" do
  mode '644'
  source 'nginx/apps/drupal/map_cache.conf'
end

cookbook_file "#{main_nginx_drupal}/microcache_fcgi_auth.conf" do
  mode '644'
  source 'nginx/apps/drupal/microcache_fcgi_auth.conf'
end

cookbook_file "#{main_nginx_drupal}/microcache_fcgi.conf" do
  mode '644'
  source 'nginx/apps/drupal/microcache_fcgi.conf'
end

cookbook_file "#{main_nginx_drupal}/microcache_proxy_auth.conf" do
  mode '644'
  source 'nginx/apps/drupal/microcache_proxy_auth.conf'
end

cookbook_file "#{main_nginx_drupal}/microcache_proxy.conf" do
  mode '644'
  source 'nginx/apps/drupal/microcache_proxy.conf'
end

cookbook_file "#{main_nginx_available}/000-default" do
  mode '644'
  source 'nginx/sites-available/000-default'
end

link "#{main_nginx_enabled}/000-default" do
  to "#{main_nginx_available}/000-default"
end

file '/etc/nginx/sites-enabled/default' do
  action :delete
end

template "#{confs_nginx}/nginx.conf" do
  mode '644'
  owner user
  group user
  source 'nginx/nginx.conf.erb'
  variables(
     user: user,
     nginx_pid_file: node['nginx']['pid_file'],
     worker_rlimit_nofile: node['nginx']['worker_rlimit_nofile'],
     worker_connections: node['nginx']['worker_connections'],
     real_ip_from: node['nginx']['real_ip_from'],
     php_backend: node['nginx']['php_backend'],
     php_backend_type: node['nginx']['php_backend_type']
  )
end

link "#{main_nginx}/nginx.conf" do
  to "#{confs_nginx}/nginx.conf"
end

template "#{confs_nginx}/upstream_hhvm_phpcgi_unix.conf" do
  mode '644'
  owner user
  group user
  source 'nginx/upstream_hhvm_phpcgi_unix.conf.erb'
  variables(
     hhvm_socket_file: node['hhvm']['server']['socket_file']
  )
end

link "#{main_nginx}/upstream_hhvm_phpcgi_unix.conf" do
  to "#{confs_nginx}/upstream_hhvm_phpcgi_unix.conf"
end

template "#{confs_nginx}/hhvm.conf" do
  mode '644'
  owner user
  group user
  source 'nginx/hhvm.conf.erb'
  variables(
     hhvm_socket_file: node['hhvm']['server']['socket_file']
  )
end

link "#{main_nginx}/hhvm.conf" do
  to "#{confs_nginx}/hhvm.conf"
end

# Verify nginx config until this point
file "#{main_nginx}/nginx.conf" do
    verify 'nginx -t -c %{file}'
end

# nginx setting up specific sites
if node['polignu']
  template "#{confs_nginx_available}/polignu.conf" do
    mode '644'
    owner user
    group user
    source 'nginx/sites-available/example.conf.erb'
    variables(
      server_name: node['polignu']['server_name'],
      ssl_public_port: node['polignu']['ssl']['public_port'],
      ssl_certificate: node['polignu']['ssl']['certificate'],
      ssl_certificate_key: node['polignu']['ssl']['certificate_key'],
      ssl_trusted_certificate: node['polignu']['ssl']['trusted_certificate'],
      root_folder: polignu_www,
      varnish_host: node["varnish"]["host"],
      varnish_port: node["varnish"]["port"],
      php_backend_port: node["nginx"]["php_backend_port"]
    )
  end

  link "#{main_nginx_available}/polignu.conf" do
    to "#{confs_nginx_available}/polignu.conf"
  end

  link "#{main_nginx_enabled}/polignu.conf" do
    to "#{main_nginx_available}/polignu.conf"
  end
end

if node['poligen']
  template "#{confs_nginx_available}/poligen.conf" do
    mode '644'
    owner user
    group user
    source 'nginx/sites-available/example.conf.erb'
    variables(
      server_name: node['poligen']['server_name'],
      ssl_public_port: node['poligen']['ssl']['public_port'],
      ssl_certificate: node['poligen']['ssl']['certificate'],
      ssl_certificate_key: node['poligen']['ssl']['certificate_key'],
      ssl_trusted_certificate: node['poligen']['ssl']['trusted_certificate'],
      root_folder: poligen_www,
      varnish_host: node["varnish"]["host"],
      varnish_port: node["varnish"]["port"],
      php_backend_port: node["nginx"]["php_backend_port"]
    )
  end

  link "#{main_nginx_available}/poligen.conf" do
    to "#{confs_nginx_available}/poligen.conf"
  end

  link "#{main_nginx_enabled}/poligen.conf" do
    to "#{main_nginx_available}/poligen.conf"
  end
end

########################
# (Re)Starting services
########################
execute 'systemctl daemon-reload'

# HHVM
service 'hhvm' do
  action :restart
end

# MariaDB
service "mysql" do
  action :restart
end

# Varnish
service "varnish" do
  action :restart
end

# nginx
service "nginx" do
  action :restart
end

###############################
# Setup Drupal (polignu/poligen)
