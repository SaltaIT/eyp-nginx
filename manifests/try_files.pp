# location / {
#     #try_files $uri $uri/ =404;
#     try_files $uri $uri/ /index.php$is_args$args;
# }
define nginx::try_files (
                          $try      = [ '$uri', '$uri/', ' =404' ],
                          $location = $name,
                          $port     = '80',
                        ) {
  validate_array($try)

  concat::fragment{ "${nginx::params::sites_dir}/${port}_${servername} ${location} try_files":
    target  => "${nginx::params::sites_dir}/${port}_${servername}",
    order   => '09',
    content => template("${module_name}/vhost/try_files.erb"),
  }
}
