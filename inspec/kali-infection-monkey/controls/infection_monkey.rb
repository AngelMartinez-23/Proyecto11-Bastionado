# Controla que Infection Monkey esté correctamente instalado y funcionando en Kali

control 'infection-monkey-01' do
  impact 1.0
  title 'Infection Monkey instalado y corriendo como servicio'
  desc 'Verifica que el AppImage está presente, tiene permisos correctos y el servicio está activo'

  describe package('libfuse2') do
    it { should be_installed }
  end

  describe file('/tmp/InfectionMonkey-v2.3.0.AppImage') do
    it { should exist }
    it { should be_file }
    it { should be_executable }
    its('mode') { should cmp '0755' }
  end

  describe file('/etc/systemd/system/infection-monkey.service') do
    it { should exist }
    it { should be_file }
  end

  describe service('infection-monkey') do
    it { should be_enabled }
    it { should be_running }
  end
end

