
_osfamily               = fact('osfamily')
_operatingsystem        = fact('operatingsystem')
_operatingsystemrelease = fact('operatingsystemrelease').to_f

case _osfamily
when 'RedHat'
  $packagename = 'nginx'
  $servicename = 'nginx'

when 'Debian'
  $packagename = 'nginx-light'
  $servicename = 'nginx'

else
  $packagename = '-_-'
  $servicename = 'nginx'
end
