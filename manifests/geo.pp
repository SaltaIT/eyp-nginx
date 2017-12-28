# geo $rucs {
#   default 0;
#   194.116.240.25/32 1;
# }
define nginx::geo (
                    $geo_name    = $name,
                    $default     = undef,
                    $variables   = undef,
                    $description = undef,
                  ) {

  validate_hash($variables)

  file { "${nginx::params::conf_d_dir}/geo_${geo_name}.conf":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Class['::nginx::service'],
    content => template("${module_name}/geo.erb"),
  }
}
