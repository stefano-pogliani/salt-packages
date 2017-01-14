require 'serverspec'
set :backend, :exec

describe command('redis-server --version') do
  its(:stdout) { should match /Redis server v=3.2.6/ }
end

describe port(6379) do
  it { should be_listening.with('tcp') }
end
