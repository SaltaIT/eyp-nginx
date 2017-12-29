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

  if($path==undef and $match==undef)
  {
    fail('path and match are undef, WTF man...')
  }

  if($path!=undef and $match!=undef)
  {
    fail('path and match cannot be defined at the same time, WTF man...')
  }

  concat::fragment{ "${apache::params::baseconf}/conf.d/sites/${order}-${servername}-${port}.conf.run redirect ${match} ${path} ${url}":
    target  => "${apache::params::baseconf}/conf.d/sites/${order}-${servername}-${port}.conf.run",
    content => template("${module_name}/vhost/redirects.erb"),
    order   => '04',
  }

}
