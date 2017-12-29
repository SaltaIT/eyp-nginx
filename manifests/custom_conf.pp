# puppet2sitepp @nginxcustomconfs
define nginx::custom_conf(
                            $source,
                            $filename = $name,
                            $replace  = true,
                          ) {

  include ::nginx

  file { "${nginx::params::sites_enabled_dir}/conf.d/${filename}.conf":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Class['nginx'],
    notify  => Class['::nginx::service'],
    source  => $source,
    replace => $replace,
  }
}
