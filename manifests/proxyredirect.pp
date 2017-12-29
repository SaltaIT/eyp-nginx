define nginx::proxyredirect (
                              $redirect      = true,
                              $redirect_from = undef,
                              $redirect_to   = undef,
                              $servername    = $name,
                              $port          = '80',
                            ) {
  $redirect_from_clean = regsubst($redirect_from, '[^a-zA-Z]+', '_')
  $redirect_to_clean = regsubst($redirect_to, '[^a-zA-Z]+', '_')

  concat::fragment{ "${nginx::params::sites_dir}/${port}_${servername} proxyredirect ${redirect} ${redirect_from_clean} ${redirect_to_clean}":
    target  => "${nginx::params::sites_dir}/${port}_${servername}",
    order   => "10_redirect__${redirect_from_clean}__${redirect_to_clean}__02",
    content => template("${module_name}/vhost/proxy/proxyredirect.erb"),
  }
}
