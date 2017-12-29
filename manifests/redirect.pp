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

  concat::fragment{ "${nginx::params::sites_dir}/${port}_${servername} redirect ${match} ${url}":
    target  => "${nginx::params::sites_dir}/${port}_${servername}",
    content => template("${module_name}/vhost/redirects.erb"),
    order   => '04',
  }

}
