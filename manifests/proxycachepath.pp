# proxy_cache_path    /var/www/cache/systemadmin.es  levels=1:2   keys_zone=cache_systemadmin:10m;
define nginx::proxycachepath(
                              $path,
                              $proxycache_name      = $name,
                              $description          = undef,
                              $order                = '42',
                              $cleanup_empty_dirs   = true,
                              $cleanup_job_hour     = '*',
                              $cleanup_job_minute   = '0',
                              $cleanup_job_month    = '*',
                              $cleanup_job_monthday = '*',
                              $cleanup_job_weekday  = '*',
                            ) {

  if(!defined(File[$path]))
  {
    exec { "mkdir -p proxycachepath ${path}":
      command => "mkdir -p ${path}",
      path    => '/usr/sbin:/usr/bin:/sbin:/bin',
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
    order   => "01-${order}",
    content => template("${module_name}/vhost/proxy/proxycachepath.erb"),
  }

  if($cleanup_empty_dirs)
  {
    $cleanup_job_ensure = 'present'
  }
  else
  {
    $cleanup_job_ensure = 'absent'
  }

  cron { "cleanup job ${path}":
    ensure   => $cleanup_job_ensure,
    command  => "find ${path} -type d -empty -delete",
    user     => 'root',
    hour     => $cleanup_job_hour,
    minute   => $cleanup_job_minute,
    month    => $cleanup_job_month,
    monthday => $cleanup_job_monthday,
    weekday  => $cleanup_job_weekday,
  }
}
