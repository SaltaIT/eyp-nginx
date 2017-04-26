define nginx::proxysetheader(
                              $proxypass_url,
                              $header,
                              $header_value,
                              $servername         = $name,
                              $port               = '80',
                            ) {
  #fragment name
  $proxypass_url_clean = regsubst($proxypass_url, '[^a-zA-Z]+', '_')

  concat::fragment{ "${nginx::params::sites_dir}/${port}_${servername} proxypass header ${header}":
    target  => "${nginx::params::sites_dir}/${port}_${servername}",
    order   => "10 - ${proxypass_url}-01",
    content => template("${module_name}/vhost/proxy/proxysetheader.erb"),
  }
}
