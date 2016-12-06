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

    virtualbox_found = command('dpkg -l virtualbox* | perl -ne \'print if s/^ii  (virtualbox(-[0-9]+\.[0-9]+)?) .*$/$1/\'').stdout.chomp
    virtualbox_found = 'virtualbox' if virtualbox_found.length == 0
    describe package(virtualbox_found) do
      it { should be_installed }
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
