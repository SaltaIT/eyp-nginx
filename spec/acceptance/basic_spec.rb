require 'spec_helper_acceptance'
require_relative './version.rb'

describe 'nginx class' do

  context 'basic setup' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOF

      class { 'nginx':
        default_vhost_port => '81'
    	}

    	nginx::vhost { 'caca':
    	}

    	nginx::proxypass { 'caca':
    		proxypass_url => 'http://127.0.0.1:5601'
    	}

    	nginx::stubstatus { 'caca':
    		allowed_ips => [ '1.1.1.1' ],
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

    describe service('nginx') do
      it { should be_enabled }
      it { is_expected.to be_running }
    end

    # nginx.conf
    describe file("/etc/nginx/nginx.conf") do
      it { should be_file }
      its(:content) { should match '# puppet managed file' }
    end

    #default vhost
    describe file("/etc/nginx/sites-available/80_caca") do
      it { should be_file }
      its(:content) { should match 'location /server-status' }
      its(:content) { should match 'proxy_pass http://127.0.0.1:5601' }
      its(:content) { should match 'allow 1.1.1.1;' }
      its(:content) { should match 'server_name caca;' }
    end

  end

end
