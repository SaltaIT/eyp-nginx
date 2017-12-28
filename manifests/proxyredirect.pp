define nginx::proxyredirect (
                              $redirect      = true,
                              $redirect_from = undef,
                              $redirect_to   = undef,
                              $servername    = $name,
                              $port          = '80',
                            ) {
  #fragment name
  $proxypass_url_clean = regsubst($proxypass_url, '[^a-zA-Z]+', '_')

  concat::fragment{ "${nginx::params::sites_dir}/${port}_${servername} proxypass header ${bypass}":
    target  => "${nginx::params::sites_dir}/${port}_${servername}",
    order   => "10 - ${proxypass_url_clean}-02",
    content => template("${module_name}/vhost/proxy/proxyredirect.erb"),
  }
}
