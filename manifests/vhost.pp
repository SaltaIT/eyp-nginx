#
# concat vhost
# 00 - base vhost
# 01 - try_files
# 02 - location
# 03 - ssl
# 09 - stub status
# 10 - proxypass
# 99 - end vhost
#
# puppet2sitepp @nginxvhosts
#
define nginx::vhost (
                      $port             = '80',
                      $documentroot     = "/var/www/${name}",
                      $servername       = $name,
                      $directoryindex   = [ 'index.php', 'index.html', 'index.htm' ],
                      $enable           = true,
                      $default          = false,
                      $error_log        = "${nginx::logdir}/error_${name}.log",
                      $access_log       = "${nginx::logdir}/access_${name}.log",
                      $charset          = undef,
                      $listen_address   = undef,
                      $certname         = undef,
                      $certname_version = '',
                    ) {

  include ::nginx

  Exec {
    path => '/usr/sbin:/usr/bin:/sbin:/bin',
  }

  if($enable)
  {
    file { "${nginx::params::sites_enabled_dir}/${port}_${servername}":
      ensure  => 'link',
      target  => "${nginx::params::sites_dir}/${port}_${servername}",
      require => [ File[$nginx::params::sites_enabled_dir], Concat["${nginx::params::sites_dir}/${port}_${servername}"] ],
      notify  => Class['::nginx::service'],
    }
  }
  else
  {
    file { "${nginx::params::sites_enabled_dir}/${port}_${servername}":
      ensure  => 'absent',
      require => [ File[$nginx::params::sites_enabled_dir], Concat["${nginx::params::sites_dir}/${port}_${servername}"] ],
      notify  => Class['::nginx::service'],
    }
  }

  exec { "mkdir p ${documentroot} ${servername} ${port}":
    command => "mkdir -p ${documentroot}",
    creates => $documentroot,
    require => Package[$nginx::params::package],
  }

  concat { "${nginx::params::sites_dir}/${port}_${servername}":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Class['::nginx::service'],
    require => [ File[$nginx::params::sites_dir], Exec["mkdir p ${documentroot} ${servername} ${port}"] ],
  }

  concat::fragment{ "${nginx::params::sites_dir}/${servername} ini vhost":
    target  => "${nginx::params::sites_dir}/${port}_${servername}",
    order   => '00',
    content => template("${module_name}/vhost/template_vhost.erb"),
  }

  if($certname!=undef)
  concat::fragment{ "${nginx::params::sites_dir}/${servername} ssl ${certname}":
    target  => "${nginx::params::sites_dir}/${port}_${servername}",
    order   => '03',
    content => template("${module_name}/vhost/ssl.erb"),
  }

  concat::fragment{ "${nginx::params::sites_dir}/${servername} fi vhost":
    target  => "${nginx::params::sites_dir}/${port}_${servername}",
    order   => '99',
    content => "}\n",
  }

}
