# location / {
#     #try_files $uri $uri/ =404;
#     try_files $uri $uri/ /index.php$is_args$args;
# }
define nginx::try_files (
                          $try        = [ '$uri', '$uri/', ' =404' ],
                          $location   = '/',
                          $port       = '80',
                          $servername = $name,
                        ) {

  concat::fragment{ "${nginx::params::sites_dir}/${port}_${servername} ${location} try_files":
    target  => "${nginx::params::sites_dir}/${port}_${servername}",
    order   => '01',
    content => template("${module_name}/vhost/try_files.erb"),
  }
}
