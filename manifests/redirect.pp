# puppet2sitepp @nginxredirects
define nginx::redirect (
                          $url,
                          $match       = '^/(.*)$',
                          $location    = '/',
                          $vhost_order = '00',
                          $port        = '80',
                          $servername  = $name,
                          $permanent   = true,
                          $description = undef,
                          $order       = '04',
                        ) {
  include ::nginx

  concat::fragment{ "${nginx::params::sites_dir}/${port}_${servername} redirect ${match} ${url}":
    target  => "${nginx::params::sites_dir}/${port}_${servername}",
    content => template("${module_name}/vhost/redirects.erb"),
    order   => $order,
  }

}
