# nginx

**NTTCom-MS/eyp-nginx**: [![Build Status](https://travis-ci.org/NTTCom-MS/eyp-nginx.png?branch=master)](https://travis-ci.org/NTTCom-MS/eyp-nginx)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with nginx](#setup)
    * [What nginx affects](#what-nginx-affects)
    * [Beginning with nginx](#beginning-with-nginx)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

nginx management

## Module Description

This module installs and configures nginx. It can configure vhosts with and without SSL

## Setup

### What nginx affects

* Manages nginx package and installs EPEL repo via **eyp-epel** if appropriate
* Manages nginx general configuration file and mime.types file
* Manages sites, ssl and conf.d directories (deleting any non-managed files)
  - A raw configuration file can be still added via **nginx::custom_conf**


### Beginning with nginx

nginx proxypass minimal configuration:

```puppet
class { 'nginx':
}

nginx::vhost { 'example':
}

nginx::proxypass { 'example':
  proxypass_url => 'http://127.0.0.1:5601'
}
```

## Usage

### nginx forward proxy

```puppet
class { 'nginx':
  add_default_vhost => false,
  resolver => [ '8.8.8.8' ],
}

nginx::vhost { 'proxy': }

nginx::proxypass { 'proxy':
  proxypass_url => 'http://$http_host$uri$is_args$args',
}
```

### nginx proxypass minimal configuration using yaml syntax

```yaml
---
classes:
  - nginx
nginx::add_default_vhost: false
nginxvhosts:
  default:
    default: true
nginxproxypass:
  default:
    proxypass_url: http://127.0.0.1:5601
```

### ELK demo

```
classes:
  - nginx
nginx::add_default_vhost: false
nginxvhosts:
  default:
    default: true
nginxproxypass:
  default:
    proxypass_url: http://127.0.0.1:5601
nginxstubstatus:
  default:
    stubstatus_url: '/nginx_status'
```

### Demo vhost with SSL

```puppet
class { 'nginx':
  manage_docker_service => true,
  add_default_vhost => false,
}

nginx::vhost {'default':
  default =>true,
  documentroot => '/var/www/void',
}

nginx::vhost {'et2blog':
  documentroot => '/var/www/et2blog',
}

nginx::vhost {'et2blog_ssl':
  documentroot => '/var/www/et2blog',
  port => 443,
  certname => 'cert_et2blog_ssl',
}

nginx::cert {'cert_et2blog_ssl':
  pk_file => '/etc/pk',
  cert_file => '/etc/cert',
  require => File[ ['/etc/cert','/etc/pk'] ],
}

file { '/var/www/et2blog/check.rspec':
  ensure => 'present',
  content => "\nOK\n",
  require => Nginx::Vhost[['et2blog','et2blog_ssl']],
}

file { '/etc/cert':
  ensure => 'present',
  content => "-----BEGIN CERTIFICATE-----\nMIIDPDCCAiQCCQCKavwUiENvADANBgkqhkiG9w0BAQsFADBgMQswCQYDVQQGEwJD\nQTESMBAGA1UECAwJQmFyY2Vsb25hMRIwEAYDVQQHDAlCYXJjZWxvbmExFzAVBgNV\nBAoMDnN5c3RlbWFkbWluLmVzMRAwDgYDVQQDDAdldDJibG9nMB4XDTE2MDIyMzE0\nNTA0OFoXDTQzMDcxMTE0NTA0OFowYDELMAkGA1UEBhMCQ0ExEjAQBgNVBAgMCUJh\ncmNlbG9uYTESMBAGA1UEBwwJQmFyY2Vsb25hMRcwFQYDVQQKDA5zeXN0ZW1hZG1p\nbi5lczEQMA4GA1UEAwwHZXQyYmxvZzCCASIwDQYJKoZIhvcNAQEBBQADggEPADCC\nAQoCggEBAM80rpsjhS6H/zH7UaX0ByJMIDKC82a5cz+1R+ylVsqagmE5TuJkF9gx\nj8tNBRz+Pj3Ef/GbPNaDAICAm6eT5xOI4q789R6ONnE5IZkKghtQFzllWDDlT6Yz\n8YSFgeFLNZhIbd6/xzmSrigwK6VpX3J2Bdf5Kzu4dV0xgygxvlYaM87lNmKUfXa+\nYzTM/XyvsIV7Y5PSF9E5TgtKiUu4tdBscWXB/SR59WLAGBGK7lh/3Q0bZZ6aiXn3\n9atVIG0pX6+nOiwcfUwZU3iu1jZBT3AzR6a9HtWd4Kas9pbygWA4Rg/CMeebp9o/\n4SzbMQsGFs26KSgkXIO8QI3tvC1qRqkCAwEAATANBgkqhkiG9w0BAQsFAAOCAQEA\nS+97Qm+rr9/hKo+uEDGUwrMOVE4ArOaacD65De5+7sk5Fj0qAz/RCYRnRFPf5j7j\ns1vaaslohxwwHIaP6oMCMLAFU1kpj3Nn12uPpqinLxJCUBSToCtA7vvg+TXYYcIV\n++rZJEaWZY4OIOaBn3q6vUvyaSQM2npN/xGe4StfOPTR72YkiXTGJqlJU/qxyKxz\nAoW4ov3rHBbRq4O0pxuGdlRloInLzV8echzTvefoMU/PI8jEKj6q76Bt5GsAL5ND\nfAuNWh6XaJSYTFzrycusCQ1cYlvYPZCCZIPLYaTbzBdfbj0Qe3EhYzeh3Q36DIYc\nBAZtMTRqjKRr7bBdyR1wHQ==\n-----END CERTIFICATE-----\n",
  before => Nginx::Vhost['et2blog_ssl'],
}

file { '/etc/pk':
  ensure => 'present',
  content => "-----BEGIN RSA PRIVATE KEY-----\nMIIEpQIBAAKCAQEAzzSumyOFLof/MftRpfQHIkwgMoLzZrlzP7VH7KVWypqCYTlO\n4mQX2DGPy00FHP4+PcR/8Zs81oMAgICbp5PnE4jirvz1Ho42cTkhmQqCG1AXOWVY\nMOVPpjPxhIWB4Us1mEht3r/HOZKuKDArpWlfcnYF1/krO7h1XTGDKDG+VhozzuU2\nYpR9dr5jNMz9fK+whXtjk9IX0TlOC0qJS7i10GxxZcH9JHn1YsAYEYruWH/dDRtl\nnpqJeff1q1UgbSlfr6c6LBx9TBlTeK7WNkFPcDNHpr0e1Z3gpqz2lvKBYDhGD8Ix\n55un2j/hLNsxCwYWzbopKCRcg7xAje28LWpGqQIDAQABAoIBAHrhkVMr44XO3Ub0\n9lzmtXxfjRCnnFWlUXXMulTbUPdiXkPuSpv0JDfwXIiCqq+hD6Rt7jqIh7Hnitqq\naqUdD4MEQPrpxSxTxnGrIgOyuaoc+0jskzqcI3o7f9XJn1bO1X/0JERfk3TPSj1H\nI/s63IHzAFAu0rbeE6wq+s9RgMFqQ3Zg0VQn5t57AdtCuw72rQAz5QpXIcOxDnSh\nepyoOdipOhevbFJ1ZNyLG6MMOr7t5lrv8wyRgWYJrJzNjLd7N+DaqVToVDimn1+2\ncccgF6shkaS8Mc0nsoySqbqmAFjfMjLDmCXTRMNauzx/NhV738OIW59NDzJhY/Mk\nOY4sx+kCgYEA5rnpyim1NIQw7wIeyyILLV1a4yyfHxvmEXFin3WCTaA+aUS3aPyi\n9GHux6IYcTSVD0G+/aRVDTOvURWlA7oRLH+GGwnE+698u65+m8Pd90ZRaHoCPDVR\nIhfp87ePS2XTIXxVWbNHjXL2U4+Llm2ahbLjO7LBXX0ciH62IxVqYGcCgYEA5ecz\n1V3KEaSKQ4HPQo84PWW/HXgFPud/Wovqhtm2DfhvkJZGc7yLOLAXQD5+2M6Mg05b\nHYEtYNL0xr2JX0Ih6bt2KxXXqd0Jnctw6dP6XBuKmwof19rEVcYsr9GEhR5ZNr4K\n7u616Yn59IfckcVcxyjUOCri4YVgCUiWI7Btdm8CgYEAoDEobyJyG1pEl01DkAm8\n9OxCNERA3lqCbE3rCYeOxtKhQnlhVlVB1qdAH/8dNUwqygL91iEIpDfkW0nJ3kKL\ntfd8Zr1rtMtssOpAIWnmbM63qvA7KQ5jnGY6GuqxZMn3wuIOaE8fOMg+2llpszG5\n/WXsewBrXLuG2gYP81/lEbUCgYEAgS6FwJl/xqQXENGq/TJunolCdzOOdwcrV1yR\nPo6srnLvdWYLVlMWQ5cmqXG0YuzEpa9soUqJjgNbiSTNQNpvJd+xCYqvcQIDuker\nPahf4EuVeYKZ2/dQJQZC69Qly4r/BDSK/jDhxMVDzzRcKwikFkCJ5rmqXKBOE0lX\nG9yx1T8CgYEApqteiivtjqyzNl68OjJkdz4dQd32qDADphd6nVkvLBal9QlLH7tP\nFuE9sC1C7x4/dDzjy0zKJG1Cs6Ua7nnoZ+T149Q5DRRbCs2Csy8GaIsPc5oTjFx3\n6YoHI2TZzcP7Wk+hF1mKxqntXHZTYOtx0WtoZ6b6qlj+Obvy7UzJD4g=\n-----END RSA PRIVATE KEY-----\n",
  before => Nginx::Vhost['et2blog_ssl'],
}
```

### vhost with SSL using yaml

```
---
classes:
  - nginx
nginx::add_default_vhost: false
nginx::client_max_body_size: 0
nginxvhosts:
  default:
    port: 81
    default: true
  'demo.systemadmin.es':
    port: 443
    certname: 'demo_cert'
nginxproxypass:
  'demo.systemadmin.es':
    port: 443
    proxypass_url: 'http://127.0.0.1:7990'
nginxstubstatus:
  default:
    port: 81
    stubstatus_url: '/nginx_status'
nginxcerts:
  'demo_cert':
    pk_file: '/etc/letsencrypt/live/demo.systemadmin.es/privkey.pem'
    cert_file: '/etc/letsencrypt/live/demo.systemadmin.es/fullchain.pem'
nginxproxyredirects:
  'demo.systemadmin.es':
    port: 443
    redirect_from: 'http://127.0.0.1:7990/'
    redirect_to: 'https://demo.systemadmin.es/'
    proxypass_url: 'http://127.0.0.1:7990'
nginxredirects:
  'default':
    port: 81
    url: 'https://demo.systemadmin.es$request_uri'
```

## Reference

### classes

#### nginx

### resources

#### nginx::cert

#### nginx::custom_conf

#### nginx::geo

#### nginx::location

#### nginx::proxycachebypass

#### nginx::proxypass

#### nginx::proxyredirect

#### nginx::proxysetheader

#### nginx::redirect

#### nginx::stubstatus

* **stubstatus_url**: = '/server-status',
* **servername**:     = $name,
* **allowed_ips**:    = hiera_array('eypapache::monitips', undef),
* **denied_ips**:     = undef,
* **port**:           = '80',

#### nginx::try_files

#### nginx::upstream

#### nginx::vhost

## Limitations

Mostly used as a proxy so as a result it does not have currently many options implemented

## Development

We are pushing to have acceptance testing in place, so any new feature should
have some test to check both presence and absence of any feature
