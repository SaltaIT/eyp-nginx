class nginx::service() inherits nginx {

  #
  $is_docker_container_var=getvar('::eyp_docker_iscontainer')
  $is_docker_container=str2bool($is_docker_container_var)

  if( $is_docker_container==false or
      $nginx::manage_docker_service)
  {
    if($nginx::manage_service)
    {
      service { $nginx::params::servicename:
        ensure  => $nginx::service_ensure,
        name    => $nginx::params::servicename,
        enable  => $nginx::service_enable,
        require => Class['::nginx'],
      }
    }
  }
}
