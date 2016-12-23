#
# Cookbook Name:: polignu
# Recipe:: default
#

# Referência para criação da receita: https://docs.chef.io/resources.html

user = 'vagrant' # TODO get from node properties
home = "/home/#{user}"
polignu_folder = "#{home}/polignu"

directory "#{polignu_folder}" do
  owner user
  group user
  mode '755'
  action :create
end

# Install nginx

package "nginx"

root_folder = "#{polignu_folder}/www"

directory "#{root_folder}" do
  mode '755'
  action :create
end

cookbook_file "#{root_folder}/index.html" do
  mode '644'
  source 'index.html'
end

ssl_folder = "/etc/nginx/ssl" 

directory "#{ssl_folder}" do
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

template "#{polignu_folder}/radar_nginx.conf" do
  mode '644'
  owner user
  group user
  source "polignu_nginx.conf.erb"
  variables({
    :server_name => 'localhost', # TODO get from node properties
    :ssl_port_from_internet => '8443', # TODO get from node properties
    :root_folder => root_folder
  })
end

link "/etc/nginx/sites-enabled/polignu_nginx.conf" do
  to "#{polignu_folder}/radar_nginx.conf"
end

file "/etc/nginx/sites-enabled/default" do
  action :delete
end

service "nginx" do
  action :restart
end


# Install HHVM
package 'software-properties-common'

apt_repository "hhvm" do
  uri           "http://dl.hhvm.com/ubuntu"
  components    ['main']
  distribution  'xenial'
  key           '0x5a16e7281be7a449'
end

execute "apt-get update"

package 'hhvm'
service "hhvm" do
    action :start
end

# Install MariaDB
package "mariadb-server"

# Install Varnish

# Install letsencrypt (certbot)

# Setup nginx

# Setup hhvm

# Setup varnish

# Setup letsencrypt

# Setup Drupal (polignu/poligen)

