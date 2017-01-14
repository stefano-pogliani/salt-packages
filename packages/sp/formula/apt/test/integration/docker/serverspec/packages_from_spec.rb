require 'serverspec'
set :backend, :exec


describe file('/etc/apt/preferences.d/redis') do
  it { should be_file }
  it { should be_mode 640 }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  its(:content) {
    should eq("Package: redis-*\nPin: release a=testing\nPin-Priority: 1000\n")
  }
end

describe command('apt-cache policy | grep redis-') do
  its(:stdout) { should match /redis-server ->/ }
end
