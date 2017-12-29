# SSL certificate chains
#
# Some browsers may complain about a certificate signed by a well-known certificate authority, while other browsers may accept the certificate without issues. This occurs because the issuing authority has signed the server certificate using an intermediate certificate that is not present in the certificate base of well-known trusted certificate authorities which is distributed with a particular browser. In this case the authority provides a bundle of chained certificates which should be concatenated to the signed server certificate. The server certificate must appear before the chained certificates in the combined file:
#
# $ cat www.example.com.crt bundle.crt > www.example.com.chained.crt
# puppet2sitepp @nginxcerts
define nginx::cert (
                      $pk_source           = undef,
                      $pk_file             = undef,
                      $cert_source         = undef,
                      $cert_file           = undef,
                      $certname            = $name,
                      $version             = '',
                    ) {


  include ::nginx

  if($pk_source==undef and $pk_file==undef)
  {
    fail('both pk_source and pk_file are undefined')
  }

  if($cert_source==undef and $cert_file==undef)
  {
    fail('both cert_source and cert_file are undefined')
  }

  if($pk_source!=undef)
  {
    file { "${nginx::params::ssl_dir}/${certname}_pk${version}.pk":
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => Class['nginx'],
      source  => $pk_source,
      notify  => Class['::nginx::service'],
    }
  }
  else
  {
    file { "${nginx::params::ssl_dir}/${certname}_pk${version}.pk":
      ensure => 'link',
      target => $pk_file,
      notify => Class['::nginx::service'],
    }
  }


  if($cert_source!=undef)
  {
    file { "${nginx::params::ssl_dir}/${certname}_cert${version}.cert":
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => [ Package[$nginx::params::package], File[$nginx::params::ssl_dir] ],
      source  => $cert_source,
      notify  => Class['::nginx::service'],
    }
  }
  else
  {
    file { "${nginx::params::ssl_dir}/${certname}_cert${version}.cert":
      ensure => 'link',
      target => $cert_file,
      notify => Class['::nginx::service'],
    }
  }

}
