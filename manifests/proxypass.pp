# puppet2sitepp @nginxproxypass
define nginx::proxypass (
                          $proxypass_url,
                          $location             = '/',
                          $servername           = $name,
                          $proxy_http_version   = undef,
                          $port                 = '80',
                          $order_base           = '10',
                          $auth_basic           = false,
                          $auth_basic_user_file = undef,
                          $auth_basic_banner    = 'Restricted Area',
                          $satisfy              = undef,
                        ) {

  #fragment name
  $proxypass_url_clean = regsubst($proxypass_url, '[^a-zA-Z]+', '_')
  $location_clean = regsubst($location, '[^a-zA-Z]+', '_')

  if($auth_basic_user_file==undef)
  {
    $auth_basic_target="/etc/nginx/${servername}.htpasswd"
  }
  else
  {
    $auth_basic_target=$auth_basic_user_file
  }

  concat::fragment{ "${nginx::params::sites_dir}/${port}_${servername} proxypass ${proxypass_url_clean} ${location_clean}":
    target  => "${nginx::params::sites_dir}/${port}_${servername}",
    order   => "${order_base}-proxypass-${location_clean}-00",
    content => template("${module_name}/vhost/proxy/proxypass.erb"),
  }

  concat::fragment{ "${nginx::params::sites_dir}/${port}_${servername} proxypass ${proxypass_url_clean} ${location_clean} end":
    target  => "${nginx::params::sites_dir}/${port}_${servername}",
    order   => "${order_base}-proxypass-${location_clean}-99",
    content => "  }\n",
  }

}
