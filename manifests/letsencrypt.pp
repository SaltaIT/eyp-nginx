#
# location /.well-known/acme-challenge {
#     root /var/lib/letsencrypt;
#     default_type "text/plain";
#     try_files $uri =404;
# }
#
define nginx::letsencrypt (
                            $port             = '80',
                            $servername       = $name,
                            $location         = '/.well-known/acme-challenge',
                            $letsencrypt_root = '/var/lib/letsencrypt',
                          ) {
  #
  nginx::try_files { "try files nginx letsencrypt ${servername} ${port}":
    try          => [ '=404' ],
    location     => $location,
    port         => $port,
    servername   => $servername,
    default_type => 'text/plain',
    root         => $letsencrypt_root,
  }

  # ssl_certificate     <%= scope.lookupvar('nginx::params::ssl_dir') %>/<%= @certname %>_cert<%= @certname_version %>.cert;
  # ssl_certificate_key <%= scope.lookupvar('nginx::params::ssl_dir') %>/<%= @certname %>_pk<%= @certname_version %>.pk;
}
