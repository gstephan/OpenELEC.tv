################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
#      Copyright (C) 2014 ultraman
#      Copyright (C) 2014 streppuiu
#      Copyright (C) 2014 dominic7il
#
#  OpenELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  OpenELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="lamp"
PKG_VERSION="1.0"
PKG_REV="4"
PKG_ARCH="any"
PKG_LICENSE=""
PKG_SITE=""
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain httpd mysqld php phpMyAdmin eglibc-localedef:host samba-smbclient"
PKG_PRIORITY="optional"
PKG_SECTION="service/web"
PKG_SHORTDESC="LAMP (Linux Apache MySQL PHP) software bundle."
PKG_LONGDESC="LAMP (Linux Apache MySQL PHP) software bundle. Done by ultraman, streppuiu, dominic7il"
PKG_MAINTAINER="ultraman"
PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.service"
PKG_AUTORECONF="no"

make_target() {
	: # nothing
}

makeinstall_target() {
	: # nothing
}

addon() {
  HTTPD_DIR=$(ls -d $ROOT/$BUILD/httpd-[0-9]*/.install_pkg)
  MYSQL_DIR=$(ls -d $ROOT/$BUILD/mysqld-[0-9]*/.install_pkg)
  PHPMYADMIN_BASE_DIR=$(basename $(ls -d $ROOT/$BUILD/phpMyAdmin-[0-9]*))
  PHPMYADMIN_ZIP_DIR=$(readlink -f $SOURCES/phpMyAdmin)

  # create bin folder and copy binaries
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  
  cp -PR $HTTPD_DIR/usr/bin/* $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -PR $HTTPD_DIR/usr/sbin/* $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -PR $MYSQL_DIR/usr/bin/* $ADDON_BUILD/$PKG_ADDON_ID/bin
	cp -PR $MYSQL_DIR/usr/lib/mysqld $ADDON_BUILD/$PKG_ADDON_ID/bin
	cp -PR $MYSQL_DIR/usr/lib/mysqlmanager $ADDON_BUILD/$PKG_ADDON_ID/bin

  # allow mounting SMB share in owncloud
	cp $ROOT/$BUILD/samba-[0-9]*/.$TARGET_NAME/bin/smbclient $ADDON_BUILD/$PKG_ADDON_ID/bin

  # create lib folder and copy libraries
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/lib

  cp -PR $HTTPD_DIR/usr/lib/* $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp $ROOT/$BUILD/apr-[0-9]*/.install_pkg/usr/lib/libapr-1.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp $ROOT/$BUILD/apr-util-[0-9]*/.install_pkg/usr/lib/libaprutil-1.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp $ROOT/$BUILD/php-[0-9]*/.$TARGET_NAME/.libs/libphp5.so $ADDON_BUILD/$PKG_ADDON_ID/lib

	# locale stuff (en_US.UTF8)
	cp -a $ROOT/$BUILD/eglibc-localedef-[0-9]*/lib/locale $ADDON_BUILD/$PKG_ADDON_ID/lib

	# icons for fancy directory listings
  cp -PR $HTTPD_DIR/usr/icons $ADDON_BUILD/$PKG_ADDON_ID

	# copy share and config files
  cp -PR $MYSQL_DIR/usr/share $ADDON_BUILD/$PKG_ADDON_ID

  # add config folder
  cp -PR $PKG_DIR/config $ADDON_BUILD/$PKG_ADDON_ID/config

  # add httpd conf folder
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/srvroot/conf

  # add other httpd files to server root
  cp -PR $HTTPD_DIR/usr/error $ADDON_BUILD/$PKG_ADDON_ID/srvroot
  
  cp -PR $PKG_DIR/httpd-conf/* $ADDON_BUILD/$PKG_ADDON_ID/srvroot/conf  
  # add httpd configuration files to server root
  cp -PR $HTTPD_DIR/etc/original $ADDON_BUILD/$PKG_ADDON_ID/srvroot/conf
  cp -PR $HTTPD_DIR/etc/magic $ADDON_BUILD/$PKG_ADDON_ID/srvroot/conf
  cp -PR $HTTPD_DIR/etc/mime.types $ADDON_BUILD/$PKG_ADDON_ID/srvroot/conf

  # add httpd htdocs folder
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/htdocs
 
	cp $PKG_DIR/htdocs/* $ADDON_BUILD/$PKG_ADDON_ID/htdocs

  # create httpd server root log dir
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/srvroot/logs

  # phpMyAdmin stuff 	
(
	cd $ADDON_BUILD/$PKG_ADDON_ID/htdocs
  unzip -qq "$PHPMYADMIN_ZIP_DIR/$PHPMYADMIN_BASE_DIR-*.zip"
  mv phpMyAdmin-* phpMyAdmin
)
}
