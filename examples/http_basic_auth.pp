class { 'nginx':
}

nginx::vhost { 'example.com':
}

nginx::location { 'example.com':
  user       => 'jordi',
  crypt      => '$apr1$EBTJmPS3$xnh2s07TXkilXpQJKPYE7.'
  auth_basic => true,
}
