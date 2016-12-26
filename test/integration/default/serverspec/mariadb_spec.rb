# Based on:
# https://github.com/rightscale-cookbooks/rs-mysql/blob/master/test/integration/default/serverspec/server_spec.rb

require 'spec_helper'
require 'socket'

# Ref for test creation: http://serverspec.org/

mysql_name = 'mysql'
mysql_config_file = '/etc/mysql/my.cnf'
mysql_server_packages = %w{mariadb-server}
# collectd_plugin_dir = '/etc/collectd/plugins'

describe 'MySQL server packages are installed' do
  mysql_server_packages.each do |pkg|
    describe package(pkg) do
      it { should be_installed }
    end
  end
end

describe service(mysql_name) do
  it { should be_enabled }
  it { should be_running }
end

describe port(3306) do
  it { should be_listening }
end

describe file(mysql_config_file) do
  it { should be_file }
end

# More checks and verifications can be found at:
# https://github.com/rightscale-cookbooks/rs-mysql/blob/master/test/integration/default/serverspec/server_spec.rb
