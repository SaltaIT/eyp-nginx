define nginx::htuser(
                      $user,
                      $crypt,
                      $target = "/etc/nginx/${name}.htpassword",
                      $order  = '42',
                    ) {
  include ::nginx

  if(!defined(Concat[$target]))
  {
    concat { $target:
      ensure => 'present',
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      require => Class['::nginx'],
    }
  }

  concat::fragment { "globalconf header ${apache::params::baseconf}":
    target  => $target,
    order   => $order,
    content => "${user}:${crypt}\n",
  }
}
