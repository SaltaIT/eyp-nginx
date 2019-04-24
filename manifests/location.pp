# index index.php index.html index.htm;
#
# location ~ \.php$ {
#     try_files $uri =404;
#     fastcgi_intercept_errors on;
#     fastcgi_index  index.php;
#     include        fastcgi_params;
#     fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
#     fastcgi_pass   php-fpm;
# }
# location ~ \.php {
#  include fastcgi.conf;
#  fastcgi_split_path_info ^(.+\.php)(/.+)$;
#  fastcgi_pass unix:/var/run/php-fpm/php7.1-fpm.sock;
# }
# location ~ /\.ht {
#  deny all;
# }
define nginx::location (
                          $location                = '/',
                          $location_match          = '=',
                          $include                 = [],
                          $deny                    = [],
                          $port                    = '80',
                          $servername              = $name,
                          $description             = undef,
                          $fastcgi_split_path_info = undef,
                          $fastcgi_pass            = undef,
                          $auth_basic              = false,
                          $auth_basic_user_file    = undef,
                          $auth_basic_banner       = 'Restricted Area',
                          $satisfy                 = undef,
                          $alias_path              = undef,
                        ) {

  if($auth_basic_user_file==undef)
  {
    $auth_basic_target="/etc/nginx/${servername}.htpasswd"
  }
  else
  {
    $auth_basic_target=$auth_basic_user_file
  }

  concat::fragment{ "${nginx::params::sites_dir}/${port}_${servername} ${location} location":
    target  => "${nginx::params::sites_dir}/${port}_${servername}",
    order   => '02',
    content => template("${module_name}/vhost/location.erb"),
  }
}
