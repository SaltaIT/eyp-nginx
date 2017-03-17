# CHANGELOG

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
