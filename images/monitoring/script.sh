
function download_nagios {
  echo "---Updating Repo---"
  sudo apt-get install wget build-essential apache2 php apache2-mod-php7.0 php-gd libgd-dev unzip
  echo "----Downloading Nagios---"
  wget http://prdownloads.sourceforge.net/sourceforge/nagios/nagios-4.3.4.tar.gz
  wget http://nagios-plugins.org/download/nagios-plugins-2.2.1.tar.gz

}
function create_user_group {
  useradd nagios
  groupadd nagcmd
  usermod -a -G nagcmd nagios
  usermod -a -G nagios,nagcmd www-data
}
function extract_install_nagios {
  echo "---Extracting nagios---"

  tar zxvf nagios-4.3.4.tar.gz
  cd nagios-4.3.4
  ./configure --with-command-group=nagcmd -–with-mail=/usr/bin/sendmail --with-httpd-conf=/etc/apache2/

  echo "---Installing nagios---"
  make all
  make install
  make install-init
  make install-config
  make install-commandmode
  make install-webconf
  echo "---Copying config files---"

  cp -R contrib/eventhandlers/ /usr/local/nagios/libexec/
  chown -R nagios:nagios /usr/local/nagios/libexec/eventhandlers /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
  sudo a2ensite nagios
  sudo a2enmod rewrite cgi
  sudo cp /etc/init.d/skeleton /etc/init.d/nagios
  echo 'DESC="Nagios"' | sudo tee --append /etc/init.d/nagios
  echo 'NAME=nagios' | sudo tee --append /etc/init.d/nagios
  echo 'DAEMON=/usr/local/nagios/bin/$NAME' | sudo tee --append /etc/init.d/nagios
  echo 'DAEMON_ARGS="-d /usr/local/nagios/etc/nagios.cfg"' | sudo tee --append /etc/init.d/nagios
  echo 'PIDFILE=/usr/local/nagios/var/$NAME.lock' | sudo tee --append /etc/init.d/nagios
  echo "---Restarting apache---"
  systemctl restart apache2
  echo "---Restarting nagios---"
  systemctl start nagios
  cd ..
}
function create_default_user {
  echo "---Creating default User---"

  sudo htpasswd –c -i /usr/local/nagios/etc/htpasswd.users nagiosadmin <<< $1
}
function extract_install_nagios_plugins {
  echo "---Extracting nagios plugins---"

  tar zxvf nagios-plugins-2.2.1.tar.gz
  echo "---Installing nagios plugins---"

  cd nagios-plugins-2.2.1
  ./configure --with-nagios-user=nagios --with-nagios-group=nagios
  make
  make install

}
function config_service {
  echo "---Configuing services---"

  chkconfig --add nagios
  chkconfig --level 35 nagios on
  chkconfig --add httpd
  chkconfig --level 35 httpd on
  sudo update-rc.d nagios defaults
}
