
_osfamily               = fact('osfamily')
_operatingsystem        = fact('operatingsystem')
_operatingsystemrelease = fact('operatingsystemrelease').to_f

case _osfamily
when 'RedHat'
  $package        = 'nginx'

when 'Debian'
  $package        = 'nginx-light'

else
  $package = '-_-'
end
