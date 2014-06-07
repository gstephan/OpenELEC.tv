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
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE=""
PKG_SITE=""
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain httpd mysqld php phpMyAdmin eglibc-localedef:host"
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
  APR_DIR=$(ls -d $ROOT/$BUILD/apr-[0-9]*/.install_pkg)
  APR_UTIL_DIR=$(ls -d $ROOT/$BUILD/apr-util-[0-9]*/.install_pkg)
  MYSQL_DIR=$(ls -d $ROOT/$BUILD/mysqld-[0-9]*/.install_pkg)
  EGLIBC_LOCALEDEF=$(ls -d $ROOT/$BUILD/eglibc-localedef-[0-9]*/lib) 

  PHPMYADMIN_BASE_DIR=$(ls -d $ROOT/$BUILD/phpMyAdmin-[0-9]*)
  PHPMYADMIN_BASE_DIR=$(basename $PHPMYADMIN_BASE_DIR)
  PHPMYADMIN_ZIP_DIR=$(readlink -f $SOURCES/phpMyAdmin)

  # create bin folder and add httpd, apr, apr-util binaries
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -PR $HTTPD_DIR/usr/bin/* $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -PR $HTTPD_DIR/usr/sbin/* $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -PR $APR_DIR/usr/bin/* $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -PR $APR_UTIL_DIR/usr/bin/* $ADDON_BUILD/$PKG_ADDON_ID/bin

  # create lib folder and copy httpd, apr, apr-util libraries
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PR $HTTPD_DIR/usr/lib/* $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp $APR_DIR/usr/lib/libapr-1.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp $APR_UTIL_DIR/usr/lib/libaprutil-1.so.0 $ADDON_BUILD/$PKG_ADDON_ID/lib
  
  #cp $SYSROOT_PREFIX/usr/lib/libmcrypt.so.4 $ADDON_BUILD/$PKG_ADDON_ID/lib

  cp $ROOT/$BUILD/php-[0-9]*/.$TARGET_NAME/.libs/libphp5.so $ADDON_BUILD/$PKG_ADDON_ID/lib

	# locale stuff (en_US.UTF8)
	cp -a $EGLIBC_LOCALEDEF/locale $ADDON_BUILD/$PKG_ADDON_ID/lib
	
  # add httpd www folder
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/www

  cp -PR $HTTPD_DIR/usr/htdocs $ADDON_BUILD/$PKG_ADDON_ID/www
  #cp -PR $HTTPD_DIR/usr/cgi-bin $ADDON_BUILD/$PKG_ADDON_ID/www
  #cp -PR $HTTPD_DIR/usr/manual $ADDON_BUILD/$PKG_ADDON_ID/www
  #cp -PR $HTTPD_DIR/usr/icons $ADDON_BUILD/$PKG_ADDON_ID/www

	cp $PKG_DIR/config/*.php $ADDON_BUILD/$PKG_ADDON_ID/www/htdocs/
	cp $PKG_DIR/config/*.sql $ADDON_BUILD/$PKG_ADDON_ID/

  # create httpd server root
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/srvroot

  # add httpd configuration files to server root
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/srvroot/conf
  cp -PR $HTTPD_DIR/etc/original $ADDON_BUILD/$PKG_ADDON_ID/srvroot/conf
  cp -PR $HTTPD_DIR/etc/magic $ADDON_BUILD/$PKG_ADDON_ID/srvroot/conf
  cp -PR $HTTPD_DIR/etc/mime.types $ADDON_BUILD/$PKG_ADDON_ID/srvroot/conf
  cp -PR $PKG_DIR/config/httpd.conf $ADDON_BUILD/$PKG_ADDON_ID/srvroot/conf
  cp -PR $PKG_DIR/config/extra $ADDON_BUILD/$PKG_ADDON_ID/srvroot/conf
  cp -PR $PKG_DIR/config/php.ini $ADDON_BUILD/$PKG_ADDON_ID/srvroot/conf
  cp -PR $PKG_DIR/config/mysqld.cnf $ADDON_BUILD/$PKG_ADDON_ID

  # add other httpd files to server root
  cp -PR $HTTPD_DIR/usr/error $ADDON_BUILD/$PKG_ADDON_ID/srvroot

  # create httpd server root log dir
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/srvroot/logs

	# create bin folder and add binaries
	mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -PR $MYSQL_DIR/usr/bin/* $ADDON_BUILD/$PKG_ADDON_ID/bin
	cp -PR $MYSQL_DIR/usr/lib/mysqld $ADDON_BUILD/$PKG_ADDON_ID/bin
	cp -PR $MYSQL_DIR/usr/lib/mysqlmanager $ADDON_BUILD/$PKG_ADDON_ID/bin

	# copy share and config files
  cp -PR $MYSQL_DIR/usr/share $ADDON_BUILD/$PKG_ADDON_ID

  # phpMyAdmin stuff
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/www/htdocs
(
	cd $ADDON_BUILD/$PKG_ADDON_ID/www/htdocs
  unzip -qq "$PHPMYADMIN_ZIP_DIR/$PHPMYADMIN_BASE_DIR-*.zip"
  mv phpMyAdmin-* phpMyAdmin
)

	cp $PKG_DIR/config/config.inc.php $ADDON_BUILD/$PKG_ADDON_ID
}
