#This is a Vagrant configuration for Magento

# Features

## Guest configuration
* Ubuntu 12.04 LTS 64bits
* Synced folders use NFS (not working on Windows)
* SSH password access is enabled in order for tools like Sequel Pro to be able to connect
* Host-only private IP is 192.168.76.67
* /vagrant dir is the web base dir

## Magento preparation
* LAMP stack with MySQL 5.5
* APC as a PHP extension
* phpMyAdmin
* A more than simple virtual host creation script - [https://github.com/herveguetin/virtualhost](https://github.com/herveguetin/virtualhost)
* Redis - [http://redis.io/](http://redis.io/)
* Varnish - [https://www.varnish-cache.org](https://www.varnish-cache.org)
* Solr 4.8.1 - [http://lucene.apache.org/solr/](http://lucene.apache.org/solr/)
* Compass - [http://compass-style.org/](http://compass-style.org/)
* Magerun - [https://github.com/netz98/n98-magerun](https://github.com/netz98/n98-magerun)
* Modman - [https://github.com/colinmollenhour/modman](https://github.com/colinmollenhour/modman)


# Quick Wiki

## Creating a virtual host

* ssh into the vagrant guest with `vagrant ssh`
* Once on the guest type: `sudo a2mkhost`
* When prompted for directory name, type the name of the virtual host (ex: `magento-ce-1.9`)
* Your new site is available at http://[virtual_host_name].local.com (ex: `http://magento-ce-1.9.local.com`)
* Make sure to create the /vagrant/[virtual_host_name] dir (ex: `/vagrant/magento-ce-1.9/`) in which you will then put your Magento installation
* Update your guest machine's hosts file in order for [virtual_host_name].local.com to point to 192.168.76.67 (ex: `192.168.76.67 magento-ce-1.9.local.com`)

## About MySQL

Use the following MySQL credentials

* host: 127.0.0.1
* username: root
* password: vagrant
* port: 3306

With the following SSH credentials

* host: 127.0.0.1
* username: root
* password: vagrant
* port: 2222

## About Redis

__Redis MAY NOT be started on `vagrant up`.__

### Starting Redis

* ssh into the vagrant guest with `vagrant ssh`
* Once on the guest type: `sudo redis-server`

### Accessing Redis CLI

* ssh into the vagrant guest with `vagrant ssh`
* Once on the guest type: `redis-cli`

## About Varnish

__Varnish IS NOT be started on `vagrant up`.__

### Starting Varnish

* ssh into the vagrant guest with `vagrant ssh`
* Once on the guest type: `sudo service varnish start`

### Stopping Varnish

* ssh into the vagrant guest with `vagrant ssh`
* Once on the guest type: `sudo service varnish stop`

### Restarting Varnish

* ssh into the vagrant guest with `vagrant ssh`
* Once on the guest type: `sudo service varnish restart`


## About Solr

__Solr MAY NOT be started on `vagrant up`.__

### Starting Solr

* ssh into the vagrant guest with `vagrant ssh`
* Once on the guest type:

`cd /home/vagrant/magento/_utils/solr/solr-4.8.1/magento`

`sudo nohup java -jar start.jar &`

### Stopping Solr

* ssh into the vagrant guest with `vagrant ssh`
* Once on the guest type: `lsof -i :8983`
* And kill the returned PID

### Accessing Solr Dashboard

* Just browse to [http://192.168.76.67:8983/solr](http://192.168.76.67:8983/solr)



