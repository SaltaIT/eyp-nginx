# nginx

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

nginx configuration

## Module Description

This module installs and configures nginx. It can configure vhosts with and without SSL

## Setup

### What nginx affects

* Manages nginx package and installs EPEL repo via **eyp-epel** if appropriate
* Manages nginx general configuration file and mime.types file
* Manages sites, ssl and conf.d directories (deleting any non-managed files)

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

### vhost with SSL

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

#### nginx::vhost

## Limitations

Mostly used as a proxy so as a result it does not have currently many options implemented

## Development

We are pushing to have acceptance testing in place, so any new feature should
have some test to check both presence and absence of any feature
