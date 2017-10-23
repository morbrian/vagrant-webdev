# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.network "private_network", ip: "172.16.12.10"

  config.vm.provision "shell", inline: <<-SHELL
    # hostname
    sed -i s/localhost\.localdomain/proxy.172.16.12.10.xip.io/ /etc/sysconfig/network
    sysctl kernel.hostname=proxy.172.16.12.10.xip.io

    # firewall
    iptables -I INPUT -i lo -j ACCEPT
    iptables -I INPUT 1 -p tcp --dport 443 -j ACCEPT
    iptables -I INPUT 1 -p tcp --dport 80 -j ACCEPT
    iptables -I INPUT 1 -p tcp --dport 22 -j ACCEPT
    iptables -I INPUT 1 -p tcp --dport 5432 -j ACCEPT
    iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
    iptables -A INPUT -p all -j REJECT --reject-with icmp-host-prohibited
    iptables -A FORWARD -p all -j REJECT --reject-with icmp-host-prohibited
    iptables-save
    service iptables restart
    # os updates
    yum update -y
    # httpd
    yum install httpd -y
    chkconfig httpd on
    echo 'ProxyPass /openam               ajp://localhost:8009/openam' >> /etc/httpd/conf/httpd.conf
    echo 'ProxyPassReverse /openam        ajp://localhost:8009/openam' >> /etc/httpd/conf/httpd.conf
    echo '#' >> /etc/httpd/conf/httpd.conf
    echo 'ProxyPass /examples             ajp://localhost:8009/examples' >> /etc/httpd/conf/httpd.conf
    echo 'ProxyPassReverse /examples      ajp://localhost:8009/examples' >> /etc/httpd/conf/httpd.conf
    service httpd restart
    # java
    yum -y install java
    # tomcat
    tar xvzf /vagrant/apache-tomcat-8.0.42.tar.gz -C /usr/local
    ln -s /usr/local/apache-tomcat-8.0.42 /usr/local/tomcat
    useradd tomcat
    ln -s /usr/local/tomcat/conf /etc/tomcat
    cp /vagrant/tomcat.conf /etc/tomcat
    cp /vagrant/tomcat-service /etc/init.d/tomcat
    chown -R tomcat:tomcat /usr/local/apache-tomcat-8.0.42
    chmod 755 /etc/init.d/tomcat
    chkconfig tomcat on
    service tomcat start

    # useful for debugging
    yum -y install net-tools

    # install postgresql
    rpm -Uvh https://yum.postgresql.org/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm
    yum -y install postgresql96-server postgresql96-contrib
    sudo -i -upostgres /usr/pgsql-9.6/bin/initdb
    systemctl start postgresql-9.6
    systemctl enable postgresql-9.6

    # create initial database
    psql -Upostgres -f /vagrant/setup.sql

    # Load sample data file
    psql -Upostgres -f /vagrant/sample-data.sql

    # configure to allow connections and listen on known ip
    sed -i "s/#listen_addresses = 'localhost'/listen_addresses = 'localhost,172.16.12.10'/" /var/lib/pgsql/9.6/data/postgresql.conf
    echo "host    sample          dbuser     192.16.12.10/24         trust" >> /var/lib/pgsql/9.6/data/pg_hba.conf
    echo "host    sample          dbadmin     192.16.12.10/24         trust" >> /var/lib/pgsql/9.6/data/pg_hba.conf
    systemctl restart postgresql-9.6
  SHELL
end
