require 'serverspec'
set :backend, :exec

describe file('/etc/apt/sources.list.d/nginx-official.list') do
  it { should be_file }
end

describe package('nginx') do
  it { should be_installed }
end
