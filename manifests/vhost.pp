#
# concat vhost
# 00 - base vhost
# 01 - try_files
# 09 - stub status
# 10 - proxypass
# 99 - end vhost
#
define nginx::vhost (
                      $port           = '80',
                      $documentroot   = '/var/www/void',
                      $servername     = $name,
                      $directoryindex = [ 'index.php', 'index.html', 'index.htm' ],
                      $enable         = true,
                      $default        = false,
                    ) {

  if ! defined(Class['nginx'])
  {
    fail('You must include the nginx base class before using any nginx defined resources')
  }

  Exec {
    path => '/usr/sbin:/usr/bin:/sbin:/bin',
  }

  if($enable)
  {
    file { "${nginx::params::sites_enabled_dir}/${port}_${servername}":
      ensure  => "${nginx::params::sites_dir}/${servername}",
      require => Concat["${nginx::params::sites_dir}/${port}_${servername}"],
      notify  => Service['nginx'],
    }
  }
  else
  {
    file { "${nginx::params::sites_enabled_dir}/${port}_${servername}":
      ensure  => 'absent',
      require => Concat["${nginx::params::sites_dir}/${port}_${servername}"],
      notify  => Service['nginx'],
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
    notify  => Service['nginx'],
    require => Exec["mkdir p ${documentroot} ${servername} ${port}"],
  }

  concat::fragment{ "${nginx::params::sites_dir}/${servername} ini vhost":
    target  => "${nginx::params::sites_dir}/${port}_${servername}",
    order   => '00',
    content => template("${module_name}/vhost/template_vhost.erb"),
  }

  concat::fragment{ "${nginx::params::sites_dir}/${servername} fi vhost":
    target  => "${nginx::params::sites_dir}/${port}_${servername}",
    order   => '99',
    content => "}\n",
  }

}
