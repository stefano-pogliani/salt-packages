require 'serverspec'
set :backend, :exec

describe file('/data/www/spm/repo') do
  it { should be_directory }
  it { should be_owned_by 'nginx' }
  it { should be_grouped_into 'nginx' }
end
