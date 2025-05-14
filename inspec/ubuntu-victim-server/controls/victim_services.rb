# Controla que los servicios requeridos estén instalados, habilitados y corriendo

control 'victim-server-01' do
  impact 1.0
  title 'Servicios del servidor víctima instalados y corriendo'
  desc 'Verifica que SSH, Samba, Apache2 y XRDP están instalados, habilitados y corriendo'

  %w(openssh-server samba apache2 xrdp).each do |pkg|
    describe package(pkg) do
      it { should be_installed }
    end
  end

  describe service('ssh') do
    it { should be_enabled }
    it { should be_running }
  end

  describe service('smbd') do
    it { should be_enabled }
    it { should be_running }
  end

  describe service('apache2') do
    it { should be_enabled }
    it { should be_running }
  end

  describe service('xrdp') do
    it { should be_enabled }
    it { should be_running }
  end

  describe file('/srv/samba/public') do
    it { should exist }
    it { should be_directory }
    its('mode') { should cmp '0777' }
  end

  describe file('/etc/samba/smb.conf') do
    it { should exist }
    its('content') { should match /\[public\]/ }
    its('content') { should match %r{path = /srv/samba/public} }
    its('content') { should match /guest ok = yes/ }
  end
end

