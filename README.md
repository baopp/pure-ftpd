# pureftpd安装 
## pureftpd介绍 
PureFTPd [1]  是一款专注于程序健壮和软件安全的免费FTP服务器软件（基于BSD License）。其可以在多种类Unix操作系统中编译运行，包括Linux、OpenBSD、NetBSD、FreeBSD、DragonFly BSD、Solaris、Tru64、Darwin、Irix and HP-UX。PureFTPd还有Android移植版本
## 文件说明
|    文件              |     作用             |
|:-:|:-:|:-:|
| README.md           |  安装说明             | 
|    httpd.conf       | apache配置实例        |
|    pureadmin.tar    | 管理前端              |
|    pureftp.sql      | 数据库初始化文件       |
| pureftpd-mysql.conf | pureftpd连接mysql文件 |
## pureftpd安装  
1. 安装yum源 （可以使用国内其他源） 
- centos 6
```bash
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo 
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo
```
- centos7
```bash
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
```
2. 安装pureftpd
- 编译安装  
```bash
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
```
- yum安装
```bash
yum install pure-ftpd -y
```
3. 安装并插入数据库  
```bash
yum install mysql -y
cat << pureftpd.sql >> EOF
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
EOF
mysql -u root -p < pureadmin.sql
```

4. 复制前端管理页面php
```bash
tar xvf pureadmin.tar
cd pureadmin
vim config.php
```
修改config.php,将dbhost、dbname、dbuser、dbpasswd	修改为mysql信息
5. 权限设置
- 创建ftp读写用户  
```bash
useradd virtualftp1 -d /data/ftproot/ -s /sbin/nologin -M
```
- 创建ftp只读用户
```bash
useradd virtualftp2 -d /data/ftproot/ -s /sbin/nologin -M
```
- 设置file acl(只对目录读写权限，这个用户对目录下只有读权限)
```bash
setfacl -m u:virtualftp2:rw- FTPname-path
setfacl -m g:virtualftp2:rw- ftpname-path
```