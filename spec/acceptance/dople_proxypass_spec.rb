require 'spec_helper_acceptance'
require_relative './version.rb'

describe 'nginx class' do

  context 'basic setup' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOF

      class { 'nginx':
        add_default_vhost => false,
      }

      nginx::vhost { 'systemadmin.es':
        port => 81,
      }

      file { '/var/www/systemadmin.es/demo':
        ensure  => 'present',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => 'demo\n',
      }

      nginx::proxypass { 'systemadmin.es loc 1':
        port          => '81',
        proxypass_url => 'http://1.1.1.1:8080',
        location      => '/location1',
        servername    => 'systemadmin.es',
      }

      nginx::proxycache { 'systemadmin.es cache 1':
        port          => '81',
        location      => '/location1',
        servername    => 'systemadmin.es',
      }

      nginx::proxypass { 'systemadmin.es loc 2':
        port          => '81',
        proxypass_url => 'http://2.2.2.2:8080',
        location      => '/location2',
        servername    => 'systemadmin.es',
      }

      nginx::proxycache { 'systemadmin.es cache 2':
        port          => '81',
        location      => '/location2',
        servername    => 'systemadmin.es',
      }

      EOF

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    it "sleep 10 to make sure nginx is started" do
      expect(shell("sleep 10").exit_code).to be_zero
    end

    it "nginx configtest" do
      expect(shell("nginx -t").exit_code).to be_zero
    end

    describe port(81) do
      it { should be_listening }
    end

    describe package($packagename) do
      it { is_expected.to be_installed }
    end

    describe service($servicename) do
      it { should be_enabled }
      it { is_expected.to be_running }
    end

    # nginx.conf
    describe file("/etc/nginx/nginx.conf") do
      it { should be_file }
      its(:content) { should match '# puppet managed file' }
    end

    # /etc/nginx/sites-available
    describe file("/etc/nginx/sites-available/81_systemadmin.es") do
      it { should be_file }
      its(:content) { should match '# puppet managed file' }
    end

  end

end
