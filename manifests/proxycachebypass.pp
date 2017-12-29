define nginx::proxycachebypass(
                              $proxypass_url,
                              $bypass,
                              $location   = '/',
                              $servername = $name,
                              $port       = '80',
                            ) {
  #fragment name
  $proxypass_url_clean = regsubst($proxypass_url, '[^a-zA-Z]+', '_')
  $location_clean = regsubst($location, '[^a-zA-Z]+', '_')

  concat::fragment{ "${nginx::params::sites_dir}/${port}_${servername} proxypass header ${bypass}":
    target  => "${nginx::params::sites_dir}/${port}_${servername}",
    order   => "10 - ${proxypass_url_clean}_${location_clean}-98",
    content => template("${module_name}/vhost/proxy/proxycachebypass.erb"),
  }
}
