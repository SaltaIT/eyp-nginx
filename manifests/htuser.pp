define nginx::htuser(
                      $user,
                      $crypt,
                      $servername = $name,
                      $target     = undef,
                      $order      = '42',
                    ) {
  include ::nginx

  if($target==undef)
  {
    $real_target="/etc/nginx/${servername}.htpassword"
  }
  else
  {
    $real_target=$target
  }

  if(!defined(Concat[$real_target]))
  {
    concat { $real_target:
      ensure => 'present',
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      require => Class['::nginx'],
    }
  }

  concat::fragment { "${real_target} ${user} ${crypt} ${order}":
    target  => $real_target,
    order   => $order,
    content => "${user}:${crypt}\n",
  }
}
