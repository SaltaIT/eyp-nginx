define nginx::proxysetheader(
                              $header,
                              $header_value,
                              $location   = '/',
                              $servername = $name,
                              $port       = '80',
                              $order_base = '10',
                            ) {
  #fragment name
  $location_clean = regsubst($location, '[^a-zA-Z]+', '_')

  concat::fragment{ "${nginx::params::sites_dir}/${port}_${servername} proxypass header ${header}":
    target  => "${nginx::params::sites_dir}/${port}_${servername}",
    order   => "${order_base}-proxypass-${location_clean}-01",
    content => template("${module_name}/vhost/proxy/proxysetheader.erb"),
  }
}
