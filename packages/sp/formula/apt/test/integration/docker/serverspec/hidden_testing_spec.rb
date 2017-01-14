require 'serverspec'
set :backend, :exec

describe command('apt-cache policy | grep testing') do
  its(:stdout) { should match /\ 50\ / }
end
