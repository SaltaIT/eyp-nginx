define nginx::proxyignoreheader(
                                  $proxypass_url,
                                  $ignore_headers = [],
                                  $location       = '/',
                                  $servername     = $name,
                                  $port           = '80',
                                  $order_base     = '10',
                                ) {
  #fragment name
  $location_clean = regsubst($location, '[^a-zA-Z]+', '_')

  concat::fragment{ "${nginx::params::sites_dir}/${port}_${servername} proxypass ignore headers ${ignore_headers}":
    target  => "${nginx::params::sites_dir}/${port}_${servername}",
    order   => "${order_base}-proxypass-${location_clean}-91",
    content => template("${module_name}/vhost/proxy/proxyignoreheader.erb"),
  }
}
