# location / {
#     #try_files $uri $uri/ =404;
#     try_files $uri $uri/ /index.php$is_args$args;
# }
#
# location /.well-known/acme-challenge {
#     root /var/lib/letsencrypt;
#     default_type "text/plain";
#     try_files $uri =404;
# }
#
define nginx::try_files (
                          $try          = [ '$uri', '$uri/', ' =404' ],
                          $location     = '/',
                          $port         = '80',
                          $servername   = $name,
                          $default_type = undef,
                          $root         = undef,
                        ) {

  concat::fragment{ "${nginx::params::sites_dir}/${port}_${servername} ${location} try_files":
    target  => "${nginx::params::sites_dir}/${port}_${servername}",
    order   => '01',
    content => template("${module_name}/vhost/try_files.erb"),
  }
}
