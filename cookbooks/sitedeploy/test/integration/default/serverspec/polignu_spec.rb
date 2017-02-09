require 'serverspec'

# Ref for test creation: http://serverspec.org/

set :backend, :exec

# Nginx

describe service('nginx') do
  it { should be_enabled }
  it { should be_running }
end

describe port(80) do
  it { should be_listening  }
end

describe port(443) do
  it { should be_listening  }
end

describe port(8080) do
  it { should be_listening  }
end

# HHVM

describe service('hhvm') do
  # it { should be_enabled }
  it { should be_running }
end

# Varnish

describe service('varnish') do
  it { should be_enabled }
  it { should be_running }
end

describe port(6081) do
  it { should be_listening  }
end

# describe port(8180) do
#     it { should be_listening  }
# end
