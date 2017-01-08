define nginx::proxypass (
                          $proxypass_url,
                          $servername         = $name,
                          $proxy_http_version = undef,
                        ) {

  concat::fragment{ "${nginx::params::sites_dir}/${servername} proxypass":
    target  => "${nginx::params::sites_dir}/${servername}",
    order   => '10',
    content => template("${module_name}/vhost/proxy/proxypass.erb"),
  }

}
