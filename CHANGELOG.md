# CHANGELOG

## 0.2.14

* added configurable ordering for proxypass and redirects

## 0.2.13

* added **nginx::redirect**

## 0.2.12

* bugfix **nginx::proxyredirect**

## 0.2.9

* added **nginx::proxyredirect**
* SSL support

## 0.2.8

* added **listen_address** to **nginx::vhost**

## 0.2.7

* added charset option to **nginx::vhost**
* added **nginx::location**
* added **nginx::custom_conf**

## 0.2.6

* **INCOMPATIBLE CHANGE**: removed default options for proxypass
* added resolver option for http (**nginx**)

## 0.2.5

* limit puppetlabs-concat to < 3.0.0

## 0.2.4

* added postrotate to logrotate config
* Ubuntu 16.04 support

## 0.2.3

* added customizable log directory

## 0.2.2

* bugfix vhost enabled: true

## 0.2.1

* stubstatus uses global variable **eypapache::monitips** for allowed_ips

## 0.2.0

* **INCOMPATIBLE CHANGE**: changed vhost's file schema
* added dependencies for sites_dir and sites_enabled_dir
* **INCOMPATIBLE CHANGE**: default **document root** changed from **/var/www/void** to **"/var/www/${name}"**
