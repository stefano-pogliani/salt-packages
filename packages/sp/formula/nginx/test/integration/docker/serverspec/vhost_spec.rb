require 'serverspec'
set :backend, :exec

describe file('/etc/nginx/conf.d/vhost-missing.conf') do
  it { should_not exist }
end

describe file('/etc/nginx/conf.d/vhost-demo.conf') do
  it { should exist }
end
