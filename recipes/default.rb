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
main_nginx_settings = "#{main_nginx}/polignu_settings"
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

link main_nginx_settings do
  to confs_nginx_settings
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

#############################
# Setup configuration files #
#############################

# HHVM SETUP
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

# letsencrypt (certbot) setup
template "#{confs_nginx_settings}/letsencrypt-challange.conf" do
  mode '644'
  owner user
  group user
  source 'nginx/polignu_settings/letsencrypt-challange.conf.erb'
end

# Generationg dhparam file (see nginx.ssl_setup.conf.erb for more info)
execute 'generate dhparam' do
  command "openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048"
  only_if { not File.exist? '/etc/ssl/certs/dhparam.pem' }
end

# nginx setup
# For tests purpose
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

template "#{confs_nginx}/nginx.conf" do
  mode '644'
  owner user
  group user
  source 'nginx/nginx.conf.erb'
  variables(
     user: user,
     real_ip_from: node['nginx']['real_ip_from']
  )
end

link "#{main_nginx}/nginx.conf" do
  to "#{confs_nginx}/nginx.conf"
end

template "#{confs_nginx}/fastcgi_cache.conf" do
  mode '644'
  owner user
  group user
  source 'nginx/fastcgi_cache.conf.erb'
  variables(
    server_name: node['polignu']['server_name']
  )
end

link "#{main_nginx}/fastcgi_cache.conf" do
  to "#{confs_nginx}/fastcgi_cache.conf"
end

# # TODO: Can cache be global? [be inserted in html block]
# template "#{confs_nginx_settings}/cache.conf" do
#   mode '644'
#   owner user
#   group user
#   source 'nginx/polignu_settings/cache.conf.erb'
# end
# 
# # TODO: Can status be global? [be inserted in html block]
# template "#{confs_nginx_settings}/status.conf" do
#   mode '644'
#   owner user
#   group user
#   source 'nginx/polignu_settings/status.conf.erb'
# end

# TODO: Can security be settings? [be inserted in html block]
template "#{confs_nginx_settings}/security.conf" do
  mode '644'
  owner user
  group user
  source 'nginx/polignu_settings/security.conf.erb'
end

template "#{confs_nginx_settings}/ssl-setup.conf" do
  mode '644'
  owner user
  group user
  source 'nginx/polignu_settings/ssl-setup.conf.erb'
end

template "#{confs_nginx_settings}/hhvm.conf" do
  mode '644'
  owner user
  group user
    source 'nginx/polignu_settings/hhvm.conf.erb'
end

# Verify nginx config until this point
file "#{main_nginx}/nginx.conf" do
    verify 'nginx -t -c %{file}'
end

# nginx setting up specific sites
file '/etc/nginx/sites-enabled/default' do
  action :delete
end

if node['polignu']
  template "#{confs_nginx_available}/polignu.conf" do
    mode '644'
    owner user
    group user
    source 'nginx/sites-available/example.conf.erb'
    variables(
      server_name: node['polignu']['server_name'], # TODO
      ssl_public_port: node['polignu']['ssl_public_port'],
      root_folder: polignu_www # TODO
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
      server_name: node['polignu']['server_name'], # TODO
      ssl_public_port: node['polignu']['ssl_public_port'],
      root_folder: polignu_www # TODO
    )
  end

  link "#{main_nginx_available}/poligen.conf" do
    to "#{confs_nginx_available}/poligen.conf"
  end

  link "#{main_nginx_enabled}/poligen.conf" do
    to "#{main_nginx_available}/poligen.conf"
  end
end

file '/etc/nginx/nginx.conf' do
    verify 'nginx -t'
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

