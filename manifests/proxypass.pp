# puppet2sitepp @nginxproxypass
define nginx::proxypass (
                          $proxypass_url,
                          $location           = '/',
                          $servername         = $name,
                          $proxy_http_version = undef,
                          $port               = '80',
                          $order_base         = '10',
                        ) {

  #fragment name
  $proxypass_url_clean = regsubst($proxypass_url, '[^a-zA-Z]+', '_')
  $location_clean = regsubst($location, '[^a-zA-Z]+', '_')

  concat::fragment{ "${nginx::params::sites_dir}/${port}_${servername} proxypass":
    target  => "${nginx::params::sites_dir}/${port}_${servername}",
    order   => "${order_base} - ${proxypass_url_clean}_${location_clean}-00",
    content => template("${module_name}/vhost/proxy/proxypass.erb"),
  }

  concat::fragment{ "${nginx::params::sites_dir}/${port}_${servername} proxypass end":
    target  => "${nginx::params::sites_dir}/${port}_${servername}",
    order   => "${order_base} - ${proxypass_url_clean}_${location_clean}-99",
    content => "  }\n",
  }

}
