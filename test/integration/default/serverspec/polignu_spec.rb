require 'serverspec'

# Ref for test creation: http://serverspec.org/

set :backend, :exec

describe service('mysql') do
  it { should be_enabled }
  it { should be_running }
end

describe service('nginx') do
  it { should be_enabled }
  it { should be_running }
end

describe service('hhvm') do
  #it { should be_enabled }
  it { should be_running }
end

# describe service('varnish') do
#   it { should be_enabled }
#   it { should be_running }
# end

# Nginx http
describe port(80) do
    it { should be_listening  }
end

# Nginx https
# describe port(443) do
#     it { should be_listening  }
# end
#
# Varnish
# describe port(8180) do
#     it { should be_listening  }
# end

