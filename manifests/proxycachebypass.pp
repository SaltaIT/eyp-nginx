define nginx::proxycachebypass(
                              $proxypass_url,
                              $bypass,
                              $servername         = $name,
                              $port               = '80',
                            ) {
  #fragment name
  $proxypass_url_clean = regsubst($proxypass_url, '[^a-zA-Z]+', '_')

  concat::fragment{ "${nginx::params::sites_dir}/${port}_${servername} proxypass header ${bypass}":
    target  => "${nginx::params::sites_dir}/${port}_${servername}",
    order   => "10 - ${proxypass_url_clean}-01",
    content => template("${module_name}/vhost/proxy/proxycachebypass.erb"),
  }
}
