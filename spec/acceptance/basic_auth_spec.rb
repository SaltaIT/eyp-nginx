require 'spec_helper_acceptance'
require_relative './version.rb'

describe 'nginx class' do

  context 'auth setup' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOF

      class { 'nginx':
        add_default_vhost => false,
      }

      nginx::vhost { 'example.com':
        port => 81,
      }

      ->

      file { '/var/www/example.com/demo':
        ensure  => 'present',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => 'demo\n',
      }

      nginx::location { 'example.com':
        auth_basic => true,
        port       => 81,
      }

      nginx::htuser { 'example.com':
        user       => 'jordi',
        crypt      => '$apr1$EBTJmPS3$xnh2s07TXkilXpQJKPYE7.'
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


    describe file("/etc/nginx/sites-enabled/81_example.com") do
      it { should be_file }
      its(:content) { should match 'auth_basic_user_file' }
    end

    describe file("/etc/nginx/example.com.htpasswd") do
      it { should be_file }
      its(:content) { should match 'jordi' }
    end

  end

end
