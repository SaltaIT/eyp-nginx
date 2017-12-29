# puppet2sitepp @nginxredirects
define nginx::redirect (
                          $url,
                          $match       = '^/(.*)$',
                          $order       = '00',
                          $port        = '80',
                          $servername  = $name,
                          $permanent   = true,
                          $description = undef,
                        ) {
  include ::nginx

  concat::fragment{ "${apache::params::baseconf}/conf.d/sites/${order}-${servername}-${port}.conf.run redirect ${match} ${path} ${url}":
    target  => "${apache::params::baseconf}/conf.d/sites/${order}-${servername}-${port}.conf.run",
    content => template("${module_name}/vhost/redirects.erb"),
    order   => '04',
  }

}
