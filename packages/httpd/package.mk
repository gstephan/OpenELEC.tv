################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
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

PKG_NAME="httpd"
PKG_VERSION="2.4.9"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="OpenSource"
PKG_SITE="http://www.linuxfromscratch.org/blfs/view/svn/server/apache.html"
PKG_URL="http://archive.apache.org/dist/httpd/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain apr-util httpd:host php:target mysql-server phpMyAdmin"
PKG_PRIORITY="optional"
PKG_SECTION="service/web"
PKG_SHORTDESC="The Apache web server."
PKG_LONGDESC="The Apache web server."
PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.service"
PKG_AUTORECONF="no"

# If you still desire to serve pages as root
APACHE_RUN_AS_ROOT=no

PKG_CONFIGURE_OPTS_COMMON="--with-pcre \
                           --enable-ssl \
                           --with-ssl \
                           --with-z=$SYSROOT_PREFIX/usr/lib \
                           --with-libxml2=$SYSROOT_PREFIX/usr/lib \
                           --enable-so \
                           --enable-mods-shared=all \
                           --with-mpm=prefork \
                           cross_compiling=yes \
                           apr_cv_process_shared_works=no \
                           ap_cv_void_ptr_lt_long=no \
                           ac_cv_sizeof_struct_iovec=1 \
                           apr_cv_tcp_nodelay_with_cork=no
                           ac_cv_func_setpgrp_void=no \
                           ac_cv_file__dev_zero=no"

# host is build before target
pre_configure_host() {
  APR_DIR_HOST=$(ls -d $ROOT/$BUILD/apr-[0-9]*/.$HOST_NAME)
  APR_UTIL_DIR_HOST=$(ls -d $ROOT/$BUILD/apr-util-[0-9]*/.$HOST_NAME)

  PKG_CONFIGURE_OPTS_HOST="$PKG_CONFIGURE_OPTS_COMMON \
                           --with-apr=$APR_DIR_HOST \
                           --with-apr-util=$APR_UTIL_DIR_HOST"
}

pre_configure_target() {
  if [ "$APACHE_RUN_AS_ROOT" == "yes" ]; then
  	export CFLAGS="$CFLAGS -DBIG_SECURITY_HOLE"
  fi

  export LDFLAGS="$LDFLAGS -L$SYSROOT_PREFIX/usr/lib -lpthread"

  APR_DIR_TARGET=$(ls -d $ROOT/$BUILD/apr-[0-9]*/.$TARGET_NAME)
  APR_UTIL_DIR_TARGET=$(ls -d $ROOT/$BUILD/apr-util-[0-9]*/.$TARGET_NAME)

  PKG_CONFIGURE_OPTS_TARGET="$PKG_CONFIGURE_OPTS_COMMON \
                             --with-apr=$APR_DIR_TARGET \
                             --with-apr-util=$APR_UTIL_DIR_TARGET"
}

post_configure_target() {
  $HOST_CC -I$APR_DIR_TARGET/include -I$APR_DIR_TARGET/../include ../server/gen_test_char.c -o gen_test_char
  ./gen_test_char > server/test_char.h
  # don't call it again
  sed -i 's|./gen_test_char >|#|' server/Makefile
}

post_configure_host() {
  $HOST_CC -I$APR_DIR_HOST/include -I$APR_DIR_HOST/../include ../server/gen_test_char.c -o gen_test_char
  ./gen_test_char > server/test_char.h
  # don't call it again
  sed -i 's|./gen_test_char >|#|' server/Makefile
}

addon() {
  APR_BUILD_DIR=$(ls -d $ROOT/$BUILD/apr-[0-9]*/.install_pkg)
  APR_UTIL_BUILD_DIR=$(ls -d $ROOT/$BUILD/apr-util-[0-9]*/.install_pkg)

    # create bin folder and add httpd, apr, apr-util binaries
    mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
    cp -PR $PKG_BUILD/.install_pkg/usr/bin/* $ADDON_BUILD/$PKG_ADDON_ID/bin
    cp -PR $PKG_BUILD/.install_pkg/usr/sbin/* $ADDON_BUILD/$PKG_ADDON_ID/bin
    cp -PR $APR_BUILD_DIR/usr/bin/* $ADDON_BUILD/$PKG_ADDON_ID/bin
    cp -PR $APR_UTIL_BUILD_DIR/usr/bin/* $ADDON_BUILD/$PKG_ADDON_ID/bin

    # create lib folder and copy httpd, apr, apr-util libraries
    mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/lib
    cp -PR $PKG_BUILD/.install_pkg/usr/lib/* $ADDON_BUILD/$PKG_ADDON_ID/lib
    cp -PR $APR_BUILD_DIR/usr/lib/* $ADDON_BUILD/$PKG_ADDON_ID/lib
    cp -PR $APR_UTIL_BUILD_DIR/usr/lib/* $ADDON_BUILD/$PKG_ADDON_ID/lib
    
    cp $SYSROOT_PREFIX/usr/lib/libmcrypt.so.4 $ADDON_BUILD/$PKG_ADDON_ID/lib

  # add php module to libs folder
  if [ -d $ROOT/$BUILD/php-[0-9]*/.$TARGET_NAME ]; then
    cp $ROOT/$BUILD/php-[0-9]*/.$TARGET_NAME/.libs/libphp5.so $ADDON_BUILD/$PKG_ADDON_ID/lib
  fi

    # add httpd www folder
    mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/www

    cp -PR $PKG_BUILD/.install_pkg/usr/htdocs $ADDON_BUILD/$PKG_ADDON_ID/www
    cp -PR $PKG_BUILD/.install_pkg/usr/cgi-bin $ADDON_BUILD/$PKG_ADDON_ID/www
    cp -PR $PKG_BUILD/.install_pkg/usr/manual $ADDON_BUILD/$PKG_ADDON_ID/www
    cp -PR $PKG_BUILD/.install_pkg/usr/icons $ADDON_BUILD/$PKG_ADDON_ID/www

cat >$ADDON_BUILD/$PKG_ADDON_ID/www/htdocs/phpinfo.php << EOF
<?php
  // Show all information, defaults to INFO_ALL
  phpinfo();
  // Show just the module information.
  // phpinfo(8) yields identical results.
  phpinfo(INFO_MODULES);
?>
EOF

    # create httpd server root
    mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/srvroot

    # add httpd configuration files to server root
    mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/srvroot/conf
    cp -PR $PKG_BUILD/.install_pkg/etc/original $ADDON_BUILD/$PKG_ADDON_ID/srvroot/conf
    cp -PR $PKG_BUILD/.install_pkg/etc/magic $ADDON_BUILD/$PKG_ADDON_ID/srvroot/conf
    cp -PR $PKG_BUILD/.install_pkg/etc/mime.types $ADDON_BUILD/$PKG_ADDON_ID/srvroot/conf
    cp -PR $PKG_DIR/config/httpd.conf $ADDON_BUILD/$PKG_ADDON_ID/srvroot/conf
    cp -PR $PKG_DIR/config/extra $ADDON_BUILD/$PKG_ADDON_ID/srvroot/conf
    cp -PR $PKG_DIR/config/php.ini $ADDON_BUILD/$PKG_ADDON_ID/srvroot/conf

    # add other httpd files to server root
    cp -PR $PKG_BUILD/.install_pkg/usr/error $ADDON_BUILD/$PKG_ADDON_ID/srvroot

    # create httpd server root log dir
    mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/srvroot/logs

  # mysql server stuff
  MYSQL_BUILD_DIR=$(ls -d $ROOT/$BUILD/mysql-server-[0-9]*)

	# create bin folder and add binaries
	mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/bin
  cp -PR $MYSQL_BUILD_DIR/.install_pkg/usr/bin/* $ADDON_BUILD/$PKG_ADDON_ID/bin
	cp -PR $MYSQL_BUILD_DIR/.install_pkg/usr/lib/mysqld $ADDON_BUILD/$PKG_ADDON_ID/bin
	cp -PR $MYSQL_BUILD_DIR/.install_pkg/usr/lib/mysqlmanager $ADDON_BUILD/$PKG_ADDON_ID/bin

	# create lib folder and copy libraries
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/lib
  cp -PR $MYSQL_BUILD_DIR/.install_pkg/usr/lib/mysql/* $ADDON_BUILD/$PKG_ADDON_ID/lib

	# copy share and config files
  cp -PR $MYSQL_BUILD_DIR/.install_pkg/usr/share $ADDON_BUILD/$PKG_ADDON_ID
  #already copied
  #cp -PR $PKG_DIR/config/my.cnf $ADDON_BUILD/$PKG_ADDON_ID/share/mysql

  # phpMyAdmin stuff
  mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/www/htdocs
(
  PHPMYADMIN_DIR=$(ls -d $ROOT/$BUILD/phpMyAdmin-[0-9]*)
  #echo "PHPMYADMIN_DIR: $PHPMYADMIN_DIR"
  PHPMYADMIN_DIR=$(basename $PHPMYADMIN_DIR)
  #echo "PHPMYADMIN_DIR: $PHPMYADMIN_DIR"

  ZIP_SRC_DIR=$(readlink -f $SOURCES/phpMyAdmin)

	cd $ADDON_BUILD/$PKG_ADDON_ID/www/htdocs
  unzip -qq "$ZIP_SRC_DIR/$PHPMYADMIN_DIR-*.zip"
  mv phpMyAdmin-* phpMyAdmin
)
}
