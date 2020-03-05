# upstream php-fpm {
#         server 127.0.0.1:9000;
#         #server unix:/run/php-fpm/www.sock;
# }
#
# upstream apachebackend
# {
#   server 127.0.0.1:81;
#
#   keepalive 2;
# }
define nginx::upstream(
                        $server        = [],
                        $upstream_name = $name,
                        $keepalive     = undef,
                        $description   = undef,
                      ) {

  file { "${nginx::params::conf_d_dir}/upstream_${upstream_name}.conf":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Class['::nginx::service'],
    content => template("${module_name}/upstream.erb"),
  }

}
