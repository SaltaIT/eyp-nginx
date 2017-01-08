define nginx::proxypass (
                          $proxypass_url,
                          $servername         = $name,
                          $proxy_http_version = undef,
                          $port               = '80',
                        ) {

  concat::fragment{ "${nginx::params::sites_dir}/${servername} proxypass":
    target  => "${nginx::params::sites_dir}/${port}_${servername}",
    order   => '10',
    content => template("${module_name}/vhost/proxy/proxypass.erb"),
  }

}
