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
PKG_DEPENDS_TARGET="toolchain apr-util httpd:host php:target"
PKG_PRIORITY="optional"
PKG_SECTION="service/web"
PKG_SHORTDESC="The Apache web server."
PKG_LONGDESC="The Apache web server."
PKG_IS_ADDON="yes"
PKG_ADDON_TYPE="xbmc.service"
PKG_AUTORECONF="no"

PKG_CONFIGURE_OPTS_COMMON="--with-pcre \
                           --enable-ssl \
                           --with-ssl \
                           --with-z \
                           --with-libxml2 \
                           --enable-so \
                           --enable-mods-shared=all \
                           --with-mpm=prefork \
                           cross_compiling=no \
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
  # If you still desire to serve pages as root
  export CFLAGS="$CFLAGS -DBIG_SECURITY_HOLE"
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

    # create httpd server root
    mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/srvroot

    # add httpd configuration files to server root
    mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/srvroot/conf
    cp -PR $PKG_BUILD/.install_pkg/etc/original $ADDON_BUILD/$PKG_ADDON_ID/srvroot/conf
    cp -PR $PKG_BUILD/.install_pkg/etc/magic $ADDON_BUILD/$PKG_ADDON_ID/srvroot/conf
    cp -PR $PKG_BUILD/.install_pkg/etc/mime.types $ADDON_BUILD/$PKG_ADDON_ID/srvroot/conf
    cp -PR $PKG_DIR/config/httpd.conf $ADDON_BUILD/$PKG_ADDON_ID/srvroot/conf
    cp -PR $PKG_DIR/config/extra $ADDON_BUILD/$PKG_ADDON_ID/srvroot/conf

  # add php.ini file to conf folder
  if [ -f $ROOT/$BUILD/php-[0-9]*/php.ini-production ]; then
    cp $ROOT/$BUILD/php-[0-9]*/php.ini-production $ADDON_BUILD/$PKG_ADDON_ID/srvroot/conf/php.ini
  fi

    # add other httpd files to server root
    cp -PR $PKG_BUILD/.install_pkg/usr/error $ADDON_BUILD/$PKG_ADDON_ID/srvroot

    # add httpd logs folder to server root
    mkdir -p $ADDON_BUILD/$PKG_ADDON_ID/srvroot/logs
}
