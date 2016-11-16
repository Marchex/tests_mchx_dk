control 'mchx_dk-00' do
  impact 1.0
  title 'Verify chefdk installed'

  describe command('chef --version') do
    its('exit_status') { should eq 0 }
    its('stdout') { should match (/^Chef Development Kit Version: /) }
    its('stdout') { should match (/^chef-client version: /) }
    its('stdout') { should match (/^delivery version: /) }
    its('stdout') { should match (/^berks version: /) }
    its('stdout') { should match (/^kitchen version: /) }
  end
end
