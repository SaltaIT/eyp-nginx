#
# concat vhost
# 00 - base vhost
# 01 - try_files
# 02 - location
# 03 - ssl
# 04 - redirect
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
                      $serveralias      = [],
                      $directoryindex   = [ 'index.php', 'index.html', 'index.htm' ],
                      $enable           = true,
                      $default          = false,
                      $error_log        = "${nginx::logdir}/error_${name}.log",
                      $access_log       = "${nginx::logdir}/access_${name}.log",
                      $charset          = undef,
                      $listen_address   = undef,
                      $certname         = undef,
                      $certname_version = '',
                      $use_letsencrypt  = false,
                      $letsencrypt_root = '/var/lib/letsencrypt',
                      $ssl_protocols    = [ 'TLSv1', 'TLSv1.1', 'TLSv1.2' ],
                      $ssl_ciphers      = [ 'HIGH', '!aNULL', '!MD5' ],
                      $random_dhparams  = true,
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
  {
    if($use_letsencrypt)
    {
      nginx::letsencrypt { "letsencrypt ${servername} ${port}":
        letsencrypt_root => $letsencrypt_root,
      }
    }

    concat::fragment{ "${nginx::params::sites_dir}/${servername} ssl ${certname}":
      target  => "${nginx::params::sites_dir}/${port}_${servername}",
      order   => '03',
      content => template("${module_name}/vhost/ssl.erb"),
    }

    if($random_dhparams)
    {
      # <%= scope.lookupvar('nginx::params::ssl_dir') %>/<%= @certname %>_pk<%= @certname_version %>.pk;
      # openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
      exec { "dhparams ${certname} ${port} ${servername}":
        command => "openssl dhparam -out ${nginx::params::ssl_dir}/dhparam_${port}_${servername}.pem 2048",
        creates => "${nginx::params::ssl_dir}/dhparam_${port}_${servername}.pem",
        timeout => 0,
        notify  => Class['::nginx::service'],
      }

      file { "${nginx::params::ssl_dir}/dhparam_${port}_${servername}.pem":
        ensure  => 'present',
        owner   => 'root',
        group   => $nginx::params::username,
        mode    => '0640',
        require => Exec["dhparams ${certname} ${port} ${servername}"],
      }
    }
  }

  concat::fragment{ "${nginx::params::sites_dir}/${servername} fi vhost":
    target  => "${nginx::params::sites_dir}/${port}_${servername}",
    order   => '99',
    content => "}\n",
  }

}
