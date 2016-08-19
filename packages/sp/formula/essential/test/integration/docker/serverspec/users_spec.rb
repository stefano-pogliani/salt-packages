require 'serverspec'
set :backend, :exec

describe group('stefano') do
  it { should exist }
  it { should have_gid 2001 }
end

describe user('stefano') do
  it { should exist }
  it { should have_uid 2001 }
  it { should belong_to_group 'stefano' }
end
