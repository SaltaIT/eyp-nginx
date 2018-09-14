class { 'nginx':
}

nginx::vhost { 'example.com':
}

nginx::location { 'example.com':
  auth_basic => true,
}

nginx::htuser { 'example.com':
  user  => 'jordi',
  crypt => '$apr1$EBTJmPS3$xnh2s07TXkilXpQJKPYE7.'
}
