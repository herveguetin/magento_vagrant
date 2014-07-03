#!/usr/bin/env bash



##########################################################
# System #################################################
##########################################################

# Update
# --------------------
apt-get update

# System utilities
# --------------------
apt-get install -y make
apt-get install -y git-core
apt-get install -y curl

# Apache & PHP
# --------------------
apt-get install -y apache2
apt-get install -y php5
apt-get install -y libapache2-mod-php5
apt-get install -y php5-mysql php5-curl php5-gd php5-intl php-pear php5-imap php5-mcrypt php5-ming php5-ps php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc php5-xsl php-apc

echo "extension=apc.so" | tee -a /etc/php5/apache2/php.ini

a2enmod rewrite
service apache2 restart

# Setup web dir
# --------------------
rm -rf /var/www
ln -fs /vagrant /var/www

# Mysql
# --------------------
# Ignore the post install questions
export DEBIAN_FRONTEND=noninteractive
# Install MySQL
apt-get -y install mysql-server-5.5
apt-get -y install phpmyadmin
echo "Include /etc/phpmyadmin/apache.conf" | tee -a /etc/apache2/apache2.conf
mysqladmin -u root password 'vagrant'
service apache2 restart

# VHosts creator
# Just use "sudo a2mkhost", and enter domain name when prompted. This will create a Vhost that points to /var/www/{domain}.local.com
# And make sure that /var/www/{domain} directory exists with correct permissions...
# --------------------
cd /home/vagrant
git clone https://github.com/herveguetin/virtualhost.git
cd virtualhost
chmod +x virtualhost.sh
cp virtualhost.sh /usr/local/bin/a2mkhost

##########################################################
# Magento ################################################
##########################################################

# Create a Magento dir to store utilities
# --------------------
mkdir /home/vagrant/magento

# Redis
# --------------------
mkdir /home/vagrant/magento/redis
cd /home/vagrant/magento/redis
wget http://download.redis.io/redis-stable.tar.gz
tar xvzf redis-stable.tar.gz
cd redis-stable
make
cp /home/vagrant/magento/redis/redis-stable/src/redis-server /usr/local/bin
cp /home/vagrant/magento/redis/redis-stable/src/redis-cli /usr/local/bin
pecl install redis
echo "extension=redis.so" | tee -a /etc/php5/apache2/php.ini
service apache2 restart
nohup redis-server &


# Varnish
# --------------------
curl https://repo.varnish-cache.org/ubuntu/GPG-key.txt | apt-key add -
echo "deb https://repo.varnish-cache.org/ubuntu/ precise varnish-4.0" | tee -a /etc/apt/sources.list.d/varnish-cache.list
apt-get update
apt-get -y install varnish

# But do not start Varnish
service varnish stop

# SolR
# --------------------
apt-get install -y openjdk-6-jre
mkdir /home/vagrant/magento/_utils/solr
cd /home/vagrant/magento/_utils/solr
wget http://mir2.ovh.net/ftp.apache.org/dist/lucene/solr/4.8.1/solr-4.8.1.tgz
tar -zxf solr-4.8.1.tgz
git clone git@bitbucket.org:agencesoon/soon_solr.git
cd soon_solr
git checkout -b solr remotes/origin/solr_magento_core
cp -r . /home/vagrant/magento/_utils/solr/solr-4.8.1/
cd /home/vagrant/magento/_utils/solr/solr-4.8.1/magento
nohup java -jar start.jar &

# Compass
# --------------------
apt-get -y install ruby
gem update --system
gem install compass

# Magerun
# --------------------
mkdir /home/vagrant/magento/magerun
cd /home/vagrant/magento/magerun
curl -o n98-magerun.phar https://raw.githubusercontent.com/netz98/n98-magerun/master/n98-magerun.phar
chmod +x ./n98-magerun.phar
cp ./n98-magerun.phar /usr/local/bin/magerun

## Line below is to avoid "Comments starting with '#' are deprecated" message
find /etc/php5/cli/conf.d/ -name "*.ini" -exec sed -i -re 's/^(\s*)#(.*)/\1;\2/g' {} \;

# Modman
# --------------------
cd /home/vagrant/magento
git clone https://github.com/colinmollenhour/modman.git
cd modman
chmod +x modman
cp ./modman /usr/local/bin/




##########################################################
# Post-install operations ################################
##########################################################

# Set permissions on /home/vagrant
# --------------------
chown -R vagrant:vagrant /home/vagrant/magento
