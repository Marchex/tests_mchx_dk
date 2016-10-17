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
    describe command("/opt/chef/embedded/bin/gem query -ln #{chef_gem}") do
      its('exit_status') { should eq 0 }
    end
  end
end
