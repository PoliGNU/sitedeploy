#
# Cookbook Name:: polignu
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
#

# Install nginx
package "nginx" do
  action :install
end

# Install HHVM
package 'software-properties-common' do
  action :install
end

apt_repository "hhvm" do
  uri           "http://dl.hhvm.com/ubuntu"
  components    ['main']
  distribution  'xenial'
  key           '0x5a16e7281be7a449'
end

execute "apt-get-update" do
    command "apt-get update"
end

package 'hhvm' do
  action :install
end

# Install MariaDB
package "mariadb-server" do
  action :install
end

# Install Varnish

# Install letsencrypt (certbot)

# Setup nginx

# Setup hhvm

# Setup varnish

# Setup letsencrypt

# Setup Drupal (polignu/poligen)
