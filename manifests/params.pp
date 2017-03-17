class nginx::params {

  $sites_dir='/etc/nginx/sites-available'
  $sites_enabled_dir='/etc/nginx/sites-enabled'
  $conf_d_dir='/etc/nginx/conf.d'
  $fastcgi_params='/etc/nginx/fastcgi_params'
  $servertokens_default='off'
  $gziptypes_default = [
    'text/plain',
    'text/css',
    'application/json',
    'application/x-javascript',
    'text/xml',
    'application/xml',
    'application/xml+rss',
    'text/javascript'
  ]

  case $::osfamily
  {
    'redhat':
    {
      $package='nginx'
      case $::operatingsystemrelease
      {
        /^[5-7].*$/:
        {
          $purge_default_vhost='/etc/nginx/conf.d/default.conf'
          $include_epel=true
          $require_epel=Class[ 'epel' ]
          $username='nginx'
          $workerprocesses_default=$::processorcount
        }
        default: { fail('Unsupported RHEL/CentOS version!')  }
      }
    }
    'Debian':
    {
      case $::operatingsystem
      {
        'Ubuntu':
        {
          case $::operatingsystemrelease
          {
            /^1[46].*$/:
            {
              $purge_default_vhost=undef
              $package='nginx-light'
              $include_epel=false
              $require_epel=undef
              $username='www-data'
              $workerprocesses_default='auto'
            }
            default: { fail("Unsupported Ubuntu version! - ${::operatingsystemrelease}")  }
          }
        }
        'Debian': { fail('Unsupported')  }
        default: { fail('Unsupported Debian flavour!')  }
      }
    }
    default: { fail('Unsupported OS!')  }
  }

}
