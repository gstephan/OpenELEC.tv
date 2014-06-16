################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
#      Copyright (C) 2014 ultraman
#      Copyright (C) 2014 streppuiu
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
PKG_DEPENDS_TARGET="toolchain apr-util httpd:host php"
PKG_PRIORITY="optional"
PKG_SECTION="web"
PKG_SHORTDESC="The Apache web server."
PKG_LONGDESC="The Apache web server."
PKG_MAINTAINER="ultraman"
PKG_IS_ADDON="no"
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
                           --enable-mpms-shared=all \
                           --with-mpm=prefork \
                           --enable-deflate \
													 --enable-proxy \
													 --enable-proxy-http \
													 --enable-proxy-balancer \
													 --enable-rewrite \
                           cross_compiling=yes \
                           apr_cv_process_shared_works=no \
                           ap_cv_void_ptr_lt_long=no \
                           ac_cv_sizeof_struct_iovec=1 \
                           apr_cv_tcp_nodelay_with_cork=no
                           ac_cv_func_setpgrp_void=no \
                           ac_cv_file__dev_zero=no"

# bitnami
#--prefix=/storage/.xbmc/addons/service.web.lamp \
#--enable-authnz-ldap \
#--enable-ldap \
#--with-ldap \
aPKG_CONFIGURE_OPTS_COMMON=" \
--enable-so \
--enable-mods-shared=most \
--disable-auth_dbm \
--without-berkeley-db \
--enable-deflate \
--enable-ssl \
--with-ssl \
--enable-proxy \
--enable-proxy-http \
--enable-proxy-balancer \
--enable-rewrite \
--with-pcre \
--enable-mpms-shared=all \
--with-mpm=prefork \
\
ap_cv_void_ptr_lt_long=no \
"

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

post_makeinstall_target() {
	#sed -i "s|HTTPD='.*|HTTPD='/storage/.xbmc/addons/service.web.lamp/bin/httpd'|" ../.install_pkg/usr/sbin/apachectl
	sed -i "s|HTTPD='.*|HTTPD='/storage/.xbmc/addons/service.web.lamp/bin/httpd -f /storage/.xbmc/userdata/addon_data/service.web.lamp/srvroot/conf/httpd.conf'|" ../.install_pkg/usr/sbin/apachectl
}
