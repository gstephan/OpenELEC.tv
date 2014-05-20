################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
#
#  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2, or (at your option)
#  any later version.
#
#  This Program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.tv; see the file COPYING.  If not, write to
#  the Free Software Foundation, 51 Franklin Street, Suite 500, Boston, MA 02110, USA.
#  http://www.gnu.org/copyleft/gpl.html
################################################################################

PKG_NAME="php"
PKG_VERSION="5.5.8"
PKG_REV="0"
PKG_ARCH="any"
PKG_LICENSE="OpenSource"
PKG_SITE="http://www.php.net"
PKG_URL="http://www.php.net/distributions/$PKG_NAME-$PKG_VERSION.tar.bz2"
PKG_DEPENDS_TARGET="toolchain zlib pcre curl openssl httpd:host"
PKG_PRIORITY="optional"
PKG_SECTION="web"
PKG_SHORTDESC="php: Scripting language especially suited for Web development"
PKG_LONGDESC="PHP is a widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML."
PKG_IS_ADDON="no"
PKG_MAINTAINER="none"
PKG_AUTORECONF="no"

pre_configure_target() {
	# we need httpd host folder so build it first (could be done better probably)
	(
	  cd $ROOT
	  $SCRIPTS/build httpd:host
	)
	
	APXS_FILE=$(ls -d $ROOT/$BUILD/httpd-*)/.$HOST_NAME/support/apxs
	chmod +x $APXS_FILE

	CFLAGS="$CFLAGS -I$SYSROOT_PREFIX/usr/include/libxml2"
    LDLAGS="$LDFLAGS -I$SYSROOT_PREFIX/usr/lib"

	PKG_CONFIGURE_OPTS_TARGET="--disable-all \
                               --without-pear \
                               --with-config-file-path=/storage/.xbmc/userdata/addon_data/service.web.httpd/srvroot/conf \
                               --localstatedir=/var \
                               --enable-sockets \
                               --enable-session \
                               --enable-posix \
                               --enable-mbstring \
                               --enable-libxml \
                               --enable-xml \
                               --enable-xmlreader \
                               --enable-xmlwriter \
                               --enable-simplexml \
                               --with-libxml-dir=$SYSROOT_PREFIX/usr \
                               --with-curl=$SYSROOT_PREFIX/usr \
                               --with-openssl=$SYSROOT_PREFIX/usr \
                               --with-zlib=$SYSROOT_PREFIX/usr \
						       --disable-cgi \
                               --without-gettext \
                               --without-gmp \
                               --enable-json \
                               --disable-pcntl \
                               --disable-sysvmsg \
                               --disable-sysvsem \
                               --disable-sysvshm \
                               --disable-filter \
                               --disable-calendar \
                               --with-pcre-regex \
                               --without-sqlite3 \
                               --enable-pdo \
                               --without-pdo-sqlite \
						       --with-mysql=$SYSROOT_PREFIX/usr \
						       --with-mysql-sock=/var/tmp/mysql.socket \
						       --with-pdo-mysql=$SYSROOT_PREFIX/usr \
                               --with-apxs2=$APXS_FILE"	
}

post_configure_target() {
    sed -i "s|-I/usr/include|-I/XXXXX/usr/include|g" Makefile
    sed -i "s|-L/usr/lib|-L/XXXXX/usr/lib|g" Makefile
}

makeinstall_target() {
    : # nothing to install
}

