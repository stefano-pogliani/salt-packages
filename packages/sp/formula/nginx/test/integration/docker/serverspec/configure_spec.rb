require 'serverspec'
set :backend, :exec

describe file('/etc/nginx/conf.d/default.conf') do
  it { should_not exist }
end
