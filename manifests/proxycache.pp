define nginx::proxycache(
                          $location   = '/',
                          $servername = $name,
                          $port       = '80',
                          $order_base = '10',
                          $key        = '$scheme$host$proxy_host$uri$is_args$args',
                          $valid      = { '200' => '10m', '302' => '10m', '304' => '10m', '301' => '1m', '502' => '1s', 'any' => '1m' },
                          $use_stale  = 'updating',
                          $bypass     = [],
                        ) {
  #fragment name
  $proxypass_url_clean = regsubst($proxypass_url, '[^a-zA-Z]+', '_')
  $location_clean = regsubst($location, '[^a-zA-Z]+', '_')

  concat::fragment{ "${nginx::params::sites_dir}/${port}_${servername} proxypass cache ${bypass}":
    target  => "${nginx::params::sites_dir}/${port}_${servername}",
    order   => "${order_base}-proxypass-${location_clean}-98",
    content => template("${module_name}/vhost/proxy/proxycache.erb"),
  }
}
