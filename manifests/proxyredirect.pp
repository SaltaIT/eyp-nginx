define nginx::proxyredirect (
                              $proxypass_url,
                              $location      = '/',
                              $redirect      = true,
                              $redirect_from = undef,
                              $redirect_to   = undef,
                              $servername    = $name,
                              $port          = '80',
                              $order_base    = '10',
                            ) {
  $redirect_from_clean = regsubst($redirect_from, '[^a-zA-Z]+', '_')
  $redirect_to_clean = regsubst($redirect_to, '[^a-zA-Z]+', '_')
  $proxypass_url_clean = regsubst($proxypass_url, '[^a-zA-Z]+', '_')
  $location_clean = regsubst($location, '[^a-zA-Z]+', '_')

  concat::fragment{ "${nginx::params::sites_dir}/${port}_${servername} proxyredirect ${redirect} ${redirect_from_clean} ${redirect_to_clean}":
    target  => "${nginx::params::sites_dir}/${port}_${servername}",
    order   => "${order_base} - ${proxypass_url_clean}_${location_clean}-01",
    content => template("${module_name}/vhost/proxy/proxyredirect.erb"),
  }
}
