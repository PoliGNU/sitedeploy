# encoding: UTF-8
# # -*- mode: ruby -*-
# # vi: set ft=ruby :
#
# Cookbook Name:: polignu
# Recipe:: default
#
# Reference for creating a recepie: https://docs.chef.io/resources.html

user = node['linux_user']
polignu_folder = "/home/#{user}/polignu"
confs_base_folder = "#{polignu_folder}/confs"
nginx_folder = "/etc/nginx"
nginx_snippets = "#{nginx_folder}/snippets"

directory polignu_folder do
  owner user
  group user
  mode '755'
  action :create
end

directory confs_base_folder do
  owner user
  group user
  mode '755'
  action :create
end

directory nginx_folder do
  owner user
  group user
  mode '755'
  action :create
end

directory nginx_snippets do
  owner user
  group user
  mode '755'
  action :create
end

execute 'apt-get update'

##################
# Install openssl

package 'openssl'

##############
# Install HHVM

package 'software-properties-common'

apt_repository 'hhvm' do
  uri           'http://dl.hhvm.com/ubuntu'
  components    ['main']
  distribution  'xenial'
  key           '0x5a16e7281be7a449'
end

# Updating apt after adding a new apt repository
execute 'apt-get update'

package 'hhvm'
service 'hhvm' do
  action :start
end

template "#{confs_base_folder}/hhvm.php.ini" do
  mode '644'
  owner user
  group user
  source 'hhvm.php.ini.erb'
  variables(
    memory_limit: node['hhvm']['php']['memory_limit'],
    post_max_size: node['hhvm']['php']['post_max_size'],
    upload_max_filesize: node['hhvm']['php']['upload_max_filesize'],
    debug_mode: node['hhvm']['php']['debug_node']
  )
end

link '/etc/hhvm/php.ini' do
  to "#{confs_base_folder}/hhvm.php.ini"
end

template "#{confs_base_folder}/hhvm.server.ini" do
  mode '644'
  owner user
  group user
  source 'hhvm.server.ini.erb'
  variables(
    hhvm_socket_file: node['hhvm']['server']['socket_file']
  )
end

link '/etc/hhvm/server.ini' do
  to "#{confs_base_folder}/hhvm.server.ini"
end

service 'hhvm' do
  action :restart
end

#################
# Install MariaDB

package 'mariadb-server'

#################
# Install Varnish

package 'varnish'

###############################
# Install letsencrypt (certbot)

package "letsencrypt"

template "#{confs_base_folder}/nginx.snippets.letsencrypt-challange.conf" do
  mode '644'
  owner user
  group user
  source 'nginx.snippets.letsencrypt-challange.conf.erb'
end

link "#{nginx_snippets}/letsencrypt-challange.conf" do
  to "#{confs_base_folder}/nginx.snippets.letsencrypt-challange.conf"
end

###############
# Install nginx

package 'nginx'

root_folder = "#{polignu_folder}/www"

directory root_folder do
  mode '755'
  action :create
end

cookbook_file "#{root_folder}/index.html" do
  mode '644'
  source 'test.html'
end

ssl_folder = '/etc/nginx/ssl'

directory ssl_folder do
  mode '755'
  action :create
end

cookbook_file "#{ssl_folder}/nginx.crt" do
  mode '644'
  source 'nginx.crt'
end

cookbook_file "#{ssl_folder}/nginx.key" do
  mode '644'
  source 'nginx.key'
end

template "#{confs_base_folder}/nginx.conf" do
  mode '644'
  owner user
  group user
  source 'nginx.conf.erb'
end

link '/etc/nginx/nginx.conf' do
  to "#{confs_base_folder}/nginx.conf"
end

file '/etc/nginx/nginx.conf' do
    verify 'nginx -t -c %{file}'
end

template "#{confs_base_folder}/nginx.snippets.security.conf" do
  mode '644'
  owner user
  group user
  source 'nginx.snippets.security.conf.erb'
end

link '/etc/nginx/snippets/security.conf' do
  to "#{confs_base_folder}/nginx.snippets.security.conf"
end

template "#{confs_base_folder}/nginx.snippets.ssl-setup.conf" do
  mode '644'
  owner user
  group user
  source 'nginx.snippets.ssl-setup.conf.erb'
end

link '/etc/nginx/snippets/ssl-setup.conf' do
  to "#{confs_base_folder}/nginx.snippets.ssl-setup.conf"
end

template "#{confs_base_folder}/nginx.fastcgi_cache.conf" do
  mode '644'
  owner user
  group user
  source 'nginx.fastcgi_cache.conf.erb'
end

link '/etc/nginx/fastcgi_cache.conf' do
  to "#{confs_base_folder}/nginx.fastcgi_cache.conf"
end

template "#{confs_base_folder}/nginx.snippets.hhvm.conf" do
  mode '644'
  owner user
  group user
    source 'nginx.snippets.hhvm.conf.erb'
end

link '/etc/nginx/snippets/hhvm.conf' do
  to "#{confs_base_folder}/nginx.snippets.hhvm.conf"
end

template "#{confs_base_folder}/nginx_polignu.conf" do
  mode '644'
  owner user
  group user
  source 'nginx_site.conf.erb'
  variables(
    server_name: node['server_name'],
    ssl_public_port: node['ssl_public_port'],
    root_folder: root_folder
  )
end

link '/etc/nginx/sites-enabled/polignu.conf' do
  to "#{confs_base_folder}/nginx_polignu.conf"
end

file '/etc/nginx/sites-enabled/default' do
  action :delete
end

file '/etc/nginx/nginx.conf' do
    verify 'nginx -t'
end

file '/etc/ssl/certs/dhparam.pem' do
    verify { 1 == 1 }
    only_if {  }
end

# Generationg dhparam file (see nginx.ssl_setup.conf.erb for more info)
execute 'generate dhparam' do
  command "openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048"
  only_if { not File.exist? '/etc/ssl/certs/dhparam.pem' }
end

service 'nginx' do
  action :restart
end

###############################
# Setup Drupal (polignu/poligen)

