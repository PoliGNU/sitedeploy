#
# Cookbook Name:: polignu
# Recipe:: default
#

# Referência para criação da receita: https://docs.chef.io/resources.html

# Install nginx

package "nginx" 

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

# Install MariaDB
package "mariadb-server" 

# Install Varnish

# Install letsencrypt (certbot)

# Setup nginx

# Setup hhvm

# Setup varnish

# Setup letsencrypt

# Setup Drupal (polignu/poligen)

