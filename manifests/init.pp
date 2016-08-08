# == Class: nginx
#
class nginx   (
      $workerprocesses         = $nginx::params::workerprocesses_default,
      $servertokens            = $nginx::params::servertokens_default,
      $gziptypes               = $nginx::params::gziptypes_default,
      $defaultdocroot          = '/var/www/default',
      $serverstatus_url        = '/server-status',
      $serverstatus_allowedips = [ '127.0.0.1' ],
      $username                = $nginx::params::username,
      $pidfile                 = '/var/run/nginx.pid',
      $add_default_vhost       = true,
      $default_vhost_port      = 80,
    ) inherits nginx::params{

  validate_absolute_path($defaultdocroot)

  validate_array($serverstatus_allowedips)

  Exec {
    path => '/usr/sbin:/usr/bin:/sbin:/bin'
  }

  if($nginx::params::include_epel)
  {
    include epel
  }

  package { $nginx::params::package:
    ensure  => 'installed',
    require => $nginx::params::require_epel,
  }

  file { '/etc/nginx/nginx.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package[$nginx::params::package],
    notify  => Service['nginx'],
    content => template("${module_name}/nginx.erb")
  }

  exec { "mkdir_p_${defaultdocroot}":
    command => "mkdir -p ${defaultdocroot}",
    require => File['/etc/nginx/nginx.conf'],
    creates => $defaultdocroot,
  }

  exec { "mkdir_p_${nginx::params::sites_dir}":
    command => "mkdir -p ${nginx::params::sites_dir}",
    require => File['/etc/nginx/nginx.conf'],
    creates => $nginx::params::sites_dir,
  }

  exec { "mkdir_p_${nginx::params::sites_enabled_dir}":
    command => "mkdir -p ${nginx::params::sites_enabled_dir}",
    require => File['/etc/nginx/nginx.conf'],
    creates => $nginx::params::sites_enabled_dir,
  }

  if($add_default_vhost)
  {
    file { "${nginx::params::sites_dir}/default":
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template("${module_name}/default_vhost_template.erb"),
      notify  => Service['nginx'],
      before  => Service['nginx'],
      require => Exec[
        "mkdir_p_${defaultdocroot}",
        "mkdir_p_${nginx::params::sites_dir}",
        "mkdir_p_${nginx::params::sites_enabled_dir}"
      ],
    }

    file { "${nginx::params::sites_enabled_dir}/default":
      ensure  => "${nginx::params::sites_dir}/default",
      require => File["${nginx::params::sites_dir}/default"],
      notify  => Service['nginx'],
    }
  }

  if($nginx::params::purge_default_vhost!=undef)
  {
    file { $nginx::params::purge_default_vhost:
      ensure  => 'absent',
      require => Package[$nginx::params::package],
      notify  => Service['nginx'],
    }
  }

  service { 'nginx':
    ensure => 'running',
    enable => true,
  }

}
