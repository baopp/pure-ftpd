# pureftpd安装 
### pureftpd介绍 
PureFTPd [1]  是一款专注于程序健壮和软件安全的免费FTP服务器软件（基于BSD License）。其可以在多种类Unix操作系统中编译运行，包括Linux、OpenBSD、NetBSD、FreeBSD、DragonFly BSD、Solaris、Tru64、Darwin、Irix and HP-UX。PureFTPd还有Android移植版本
### pureftpd安装  

* entOS 6  
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo. 
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo

* 编译安装  
'''
./configure \
–prefix=/usr/local/pureftpd \
–with-mysql= \
–with-shadow \
–with-pam \
–with-welcomemsg \
–with-uploadscript \
–with-cookie \
–with-virtualchroot \
–with-virtualhosts \
–with-diraliases \
–with-quotas \
–with-puredb \
–with-sysquotas \
–with-ratios \
–with-ftpwho \
–with-throttling
'''

* 插入数据库  
'''
INSERT INTO mysql.user (Host, User,Password, Select_priv, Insert_priv, Update_priv, Delete_priv, Create_priv,Drop_priv, Reload_priv, Shutdown_priv, Process_priv, File_priv, Grant_priv,References_priv, Index_priv, Alter_priv) VALUES('localhost','ftpuser',PASSWORD('ftppass'),'Y','Y','Y','Y','N','N','N','N','N','N','N','N','N','N');
FLUSH PRIVILEGES;


CREATE DATABASE ftpname
USE ftpname;
--
-- Table structure for table 'admin'
--
CREATE TABLE admin (
 Username varchar(35) NOT NULL default '',
 Password char(32) binary NOT NULL default '',
 PRIMARY KEY  (Username)
) TYPE=MyISAM;
--
-- Data for table 'admin'
--
INSERT INTO admin VALUES('admin',MD5('passwd'));
--
-- Table structure for table 'users'
--
CREATE TABLE `users` (
 `User` varchar(16) NOT NULL default '',
 `Password` varchar(32) binary NOT NULL default '',
 `Uid` int(11) NOT NULL default '14',
 `Gid` int(11) NOT NULL default '5',
 `Dir` varchar(128) NOT NULL default '',
 `QuotaFiles` int(10) NOT NULL default '500',
 `QuotaSize` int(10) NOT NULL default '30',
 `ULBandwidth` int(10) NOT NULL default '80',
 `DLBandwidth` int(10) NOT NULL default '80',
 `Ipaddress` varchar(15) NOT NULL default '*',
 `Comment` tinytext,
 `Status` enum('0','1') NOT NULL default '1',
 `ULRatio` smallint(5) NOT NULL default '1',
 `DLRatio` smallint(5) NOT NULL default '1',
 PRIMARY KEY  (`User`),
 UNIQUE KEY `User` (`User`)
) TYPE=INNODB; 
'''
* 创建ftp用户  
'''
useradd virtualftp -d /data/ftproot/ -s /sbin/nologin -M
'''