control 'mchx_dk-01' do
  impact 1.0
  title 'Verify packages installed'

  if os[:family] == 'debian'
    %w(
      vagrant
      virtualbox
    ).each do |pkg|
      describe package(pkg) do
        it { should be_installed }
      end
    end
  end
end

control 'mchx_dk-02' do
  impact 1.0
  title 'Verify gems installed'

  %w(
    tty-prompt
    chef-vault-testfixtures
    chef-api
    vagrant-omnibus
    vagrant-cachier
    inspec
  ).each do |chef_gem|
    describe command('bash -c \'if [[ -z "$(which chef 2>/dev/null)" ]]; then /opt/chef/embedded/bin/gem list -laq; else chef gem list -laq; fi\'') do
      its('exit_status') { should == 0 }
      its('stdout') { should match (/^#{chef_gem}\b/) }
      its('stderr') { should eq '' }
    end
  end
end
