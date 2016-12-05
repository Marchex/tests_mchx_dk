### See if we're running under test kitchen
#KITCHEN_CHECK = command('ls /tmp/kitchen').exit_status
#describe KITCHEN_CHECK # this executes the command via ssh on the remote host being tested


# Only run this on non-TK nodes
control 'mchx_dk-01' do
  impact 1.0
  title 'Verify packages installed'

  if os[:family] == 'debian'
    describe package('vagrant') do
      it { should be_installed }
    end

    if os[:release] == '12.04'
      describe package('virtualbox-4.3') do
        it { should be_installed }
      end
    elsif os[:release] == '16.04'
      describe package('virtualbox-5.0') do
        it { should be_installed }
      end
    else
      describe package('virtualbox') do
        it { should be_installed }
      end
    end

  end

  #only_if { KITCHEN_CHECK != 0 }
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
    octokit
    marchex_helpers
  ).each do |chef_gem|
    describe command("/opt/chef/embedded/bin/gem query -ln #{chef_gem}") do
      its('exit_status') { should eq 0 }
    end
  end
end
