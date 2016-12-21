require 'serverspec'

# Referência para criação dos testes: http://serverspec.org/

set :backend, :exec

describe service('nginx') do
	  it { should be_enabled }
	  it { should be_running }
end

describe port(80) do
	  it { should be_listening }
end
