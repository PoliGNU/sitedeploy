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

directory polignu_folder do
  owner user
  group user
  mode '755'
  action :create
end

execute 'apt-get update'

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

DEFAULT_SSL_PUBLIC_PORT = 443
ssl_public_port = node['ssl_public_port']

ssl_public_port = DEFAULT_SSL_PUBLIC_PORT if ssl_public_port.nil?

template "#{polignu_folder}/nginx_polignu.conf" do
  mode '644'
  owner user
  group user
  source 'nginx_site.conf.erb'
  variables(
    server_name: node['server_name'],
    ssl_public_port: ssl_public_port,
    root_folder: root_folder
  )
end

link '/etc/nginx/sites-enabled/polignu.conf' do
  to "#{polignu_folder}/nginx_polignu.conf"
end

file '/etc/nginx/sites-enabled/default' do
  action :delete
end

service 'nginx' do
  action :restart
end

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

#################
# Install MariaDB

package 'mariadb-server'

#################
# Install Varnish

package 'varnish'

###############################
# Install letsencrypt (certbot)

###############################
# Setup Drupal (polignu/poligen)

