define nginx::proxyredirect (
                              $redirect      = true,
                              $redirect_from = undef,
                              $redirect_to   = undef,
                              $servername    = $name,
                              $port          = '80',
                            ) {

  concat::fragment{ "${nginx::params::sites_dir}/${port}_${servername} proxypass header ${bypass}":
    target  => "${nginx::params::sites_dir}/${port}_${servername}",
    order   => "10 - redirect ${redirect_from} ${redirect_to} -02",
    content => template("${module_name}/vhost/proxy/proxyredirect.erb"),
  }
}
