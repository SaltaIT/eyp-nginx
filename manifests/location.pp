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
