class { 'nginx':
  default_vhost_port => '81'
}

nginx::upstream { 'demo':
  server => [ '1.1.1.1', '2.2.2.2' ],
}

nginx::vhost { 'domain.com':
}

nginx::proxypass { 'domain.com':
  proxypass_url => 'http://demo',
  health_check  => true,
}

nginx::vhost { 'domain2.com':
}

nginx::proxypass { 'domain2.com':
  proxypass_url    => 'http://demo',
  health_check     => true,
  health_check_uri => '/',
}

nginx::vhost { 'domain3.com':
}

nginx::proxypass { 'domain3.com':
  proxypass_url     => 'http://demo',
  health_check      => true,
  health_check_uri  => '/',
  health_check_port => '8080',
}
