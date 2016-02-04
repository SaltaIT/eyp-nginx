define nginx::stubstatus (
                          $stubstatus_url='/server-status',
                          $servername=$name,
                          $allowed_ips=undef,
                          $denied_ips=undef,
                        ) {

  if($allowed_ips!=undef and $denied_ips!=undef)
  {
    fail('Incompatible variables: allowed_ips and denied_ips')
  }

  if($allowed_ips!=undef)
  {
    validate_array($allowed_ips)
  }

  if($denied_ips!=undef)
  {
    validate_array($denied_ips)
  }

  concat::fragment{ "${nginx::params::sites_dir}/${servername} ${stubstatus_url} stubstatus":
    target  => "${nginx::params::sites_dir}/${servername}",
    order   => '09',
    content => template("${module_name}/vhost/stubstatus/stubstatus.erb"),
  }

}
