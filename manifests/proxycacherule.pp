	  #   if ($http_cookie ~* "wordpress_logged_in_[^=]*=([^%]+)%7C")
	  #   {
    #             set $cookie_wordpress $1;
    #         }
    #
	  #   if ($http_cookie ~* "comment_author_email_([0-9a-z]*)")
	  #   {
		# set $wpcookie_author_email $1;
	  #   }
    #
	  #   if ( $request_uri ~* "/herramientas/traducir-mac-a-fabricante-del-equipo$" )
	  #   #location /herramientas/traducir-mac-a-fabricante-del-equipo
	  #   {
		# set $wp_nocache 1;
	  #   }
    #
	  #   if ( $request_uri ~* "/herramientas/calcular-el-tamano-maximo-de-memoria-de-mysql$" )
	  #   {
		# set $wp_nocache 1;
	  #   }

define nginx::proxycacherule(
                          $location   = '/',
                          $servername = $name,
                          $port       = '80',
                          $order_base = '10',
                          $key        = '$scheme$host$proxy_host$uri$is_args$args',
                          $valid      = { '200' => '10m', '302' => '10m', '304' => '10m', '301' => '1m', '502' => '1s', 'any' => '1m' },
                          $use_stale  = 'updating',
                          $bypass     = [],
                        ) {
  fail('TODO')
  #fragment name
  $location_clean = regsubst($location, '[^a-zA-Z]+', '_')

  concat::fragment{ "${nginx::params::sites_dir}/${port}_${servername} proxypass cache ${bypass}":
    target  => "${nginx::params::sites_dir}/${port}_${servername}",
    order   => "${order_base}-proxypass-${location_clean}-98",
    content => template("${module_name}/vhost/proxy/proxycache.erb"),
  }
}
