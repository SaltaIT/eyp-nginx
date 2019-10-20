# CHANGELOG

## 0.2.27

* added support for **proxy_ignore_headers** using **nginx::proxyignoreheader**

## 0.2.26

* added cleanup cron for proxy_cache

## 0.2.25

* removed useless variables from **nginx::proxysetheader**

## 0.2.24

* added fake **serveralias** for better vhost name management

## 0.2.23

* renamed options for **nginx::proxycachepath**

## 0.2.22

* added **nginx::proxycachebypass** and **nginx::proxycachepath**

## 0.2.21

* Added **alias_path** to **nginx::location**
* Added Ubuntu 18.04 support

## 0.2.20

* Added **auth_basic** support to **nginx::proxypass**

## 0.2.19

* Added **auth_basic** support to **nginx::location**

## 0.2.18

* added global **client_max_body_size**

## 0.2.17

* bugfix ssl_dhparams generation

## 0.2.16

* added option to randomly generate **ssl_dhparams**

## 0.2.15

* changed rewrite directive to return on **nginx::redirect**

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
