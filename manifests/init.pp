# == Class: nginx
#
class nginx (
              $workerprocesses            = $nginx::params::workerprocesses_default,
              $servertokens               = $nginx::params::servertokens_default,
              $gziptypes                  = $nginx::params::gziptypes_default,
              $defaultdocroot             = '/var/www/default',
              $serverstatus_url           = '/server-status',
              $serverstatus_allowedips    = [ '127.0.0.1' ],
              $username                   = $nginx::params::username,
              $pidfile                    = '/var/run/nginx.pid',
              $add_default_vhost          = true,
              $default_vhost_port         = '80',
              $keepalive_timeout          = '1',
              $general_accesslog_filename = 'access.log',
              $general_errorlog_filename  = 'error.log',
              $logrotation_ensure         = 'present',
              $logrotation_frequency      = 'daily',
              $logrotation_rotate         = '30',
              $logrotation_size           = '100M',
              $logdir                     = '/var/log/nginx',
              $purge_logrotate_default    = true,
              $resolver                   = undef,
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

  exec { "mkdir_p_${nginx::params::conf_d_dir}":
    command => "mkdir -p ${nginx::params::conf_d_dir}",
    require => File['/etc/nginx/nginx.conf'],
    creates => $nginx::params::conf_d_dir,
  }

  file { $nginx::params::sites_enabled_dir:
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    recurse => true,
    purge   => true,
    require => Exec["mkdir_p_${nginx::params::sites_enabled_dir}"],
  }

  file { $nginx::params::sites_dir:
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    recurse => true,
    purge   => true,
    require => Exec["mkdir_p_${nginx::params::sites_dir}"],
  }

  file { $nginx::params::conf_d_dir:
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    recurse => true,
    purge   => true,
    require => Exec["mkdir_p_${nginx::params::conf_d_dir}"],
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
      notify  => Service['nginx'],
      require => File[ [ $nginx::params::sites_dir, $nginx::params::sites_enabled_dir, "${nginx::params::sites_dir}/default" ] ],
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

  file { $nginx::params::fastcgi_params:
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/fcgi/fastcgi_params.erb"),
    notify  => Service['nginx'],
    require => Package[$nginx::params::package],
  }

  service { 'nginx':
    ensure => 'running',
    enable => true,
  }

  #log rotation
  # /var/log/nginx/*log {
  #   create 0644 nginx nginx
  #   daily
  #   rotate 10
  #   missingok
  #   notifempty
  #   compress
  #   sharedscripts
  #   postrotate
  #       /bin/kill -USR1 `cat /run/nginx.pid 2>/dev/null` 2>/dev/null || true
  #   endscript
  # }

  #<%= @logdir %>/<%= @repo_id %>.log
  logrotate::logs { 'nginx':
    ensure        => $logrotation_ensure,
    log           => "${logdir}/*.log",
    create_mode   => '0644',
    create_owner  => $username,
    create_group  => $username,
    frequency     => $logrotation_frequency,
    rotate        => $logrotation_rotate,
    missingok     => true,
    notifempty    => true,
    compress      => true,
    size          => $logrotation_size,
    sharedscripts => true,
    postrotate    => "/bin/kill -USR1 `cat ${pidfile} 2>/dev/null` 2>/dev/null || true",
  }

  if($purge_logrotate_default)
  {
    file { '/etc/logrotate.d/nginx':
      ensure => 'absent',
    }
  }

}
