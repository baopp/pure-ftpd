INSERT INTO mysql.user (Host, User, Password, Select_priv, Insert_priv, Update_priv, Delete_priv, Create_priv, Drop_priv, Reload_priv, Shutdown_priv, Process_priv, File_priv, Grant_priv, References_priv, Index_priv, Alter_priv,ssl_cipher,x509_issuer,x509_subject) VALUES('localhost','ftpuser',PASSWORD('ftppasswd'),'Y','Y','Y','Y','N','N','N','N','N','N','N','N','N','N','Y','Y','Y');
FLUSH PRIVILEGES;
CREATE DATABASE ftpusers;
USE ftpusers;
CREATE TABLE admin (
Username varchar(35) NOT NULL default '',
Password char(32) binary NOT NULL default '',
PRIMARY KEY (Username)
) ;
INSERT INTO admin VALUES ('admin',MD5('ftppasswd'));
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
PRIMARY KEY (`User`),
UNIQUE KEY `User` (`User`)
) ;
