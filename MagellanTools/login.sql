CREATE TABLE IF NOT EXISTS `mag_Login` (
  `user_name` char(8) character set ucs2 collate ucs2_bin NOT NULL,
  `password` char(64) character set ucs2 collate ucs2_bin NOT NULL,
  `real_name` varchar(32) character set ucs2 collate ucs2_bin NOT NULL,
  PRIMARY KEY  (`user_name`)
) ENGINE=MyISAM DEFAULT CHARSET=ucs2 collate ucs2_bin