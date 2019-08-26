# proxy_cache_path    /var/www/cache/systemadmin.es  levels=1:2   keys_zone=cache_systemadmin:10m;
define nginx::proxycachepath(
                              $path,
                              $proxycache_name = $name,
                              $description     = undef,
                              $order           = '42',
                            ) {

  if(!defined(File[$path]))
  {
    exec { "mkdir -p proxycachepath ${path}":
      command => "mkdir -p ${path}",
      creates => $path,
    }

    file { $path:
      ensure  => 'directory',
      owner   => $nginx::params::username,
      group   => $nginx::params::username,
      mode    => '0750',
      require => Exec["mkdir -p proxycachepath ${path}"],
    }
  }

  concat::fragment{ "proxycache path ${path} ${proxycache_name}":
    target  => "${nginx::params::conf_d_dir}/proxycachepaths.conf",
    order   => $order,
    content => template("${module_name}/vhost/proxy/proxycachepath.erb"),
  }
}
