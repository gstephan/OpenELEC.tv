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

PKG_NAME="php"

# taken from environment
#PHP_VERSION=5.3.3

if [ -z "$PHP_VERSION" ]; then
  PKG_VERSION="5.5.8"
else
  PKG_VERSION="$PHP_VERSION"
fi

PKG_REV="0"
PKG_ARCH="any"
PKG_LICENSE="OpenSource"
PKG_SITE="http://www.php.net"

if [ -z "$PHP_VERSION" ]; then
  PKG_URL="http://www.php.net/distributions/$PKG_NAME-$PKG_VERSION.tar.bz2"
else
  PKG_URL="http://museum.php.net/php5/php-$PKG_VERSION.tar.bz2"
fi

# add some other libraries which are need by php extensions
PKG_DEPENDS_TARGET="toolchain zlib pcre curl openssl libxml2 libmcrypt libiconv httpd:host mysqld"
PKG_PRIORITY="optional"
PKG_SECTION="web"
PKG_SHORTDESC="php: Scripting language especially suited for Web development"
PKG_LONGDESC="PHP is a widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML."
PKG_MAINTAINER="ultraman"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  APXS_FILE=$(ls -d $ROOT/$BUILD/httpd-*)/.$HOST_NAME/support/apxs
  chmod +x $APXS_FILE
  
  MYSQL_CONFIG_FILE=$(ls -d $ROOT/$BUILD/mysqld-*)/.install_pkg/usr/bin/mysql_config

	# really needed ?
  CFLAGS="$CFLAGS -I$SYSROOT_PREFIX/usr \
                  -I$SYSROOT_PREFIX/usr/include \
                  -I$SYSROOT_PREFIX/usr/include/libxml2 \
                  -I$SYSROOT_PREFIX/usr/include/freetype2 \
                  -I$SYSROOT_PREFIX/usr/include/mutils"

	# really needed ?
	LDFLAGS="$LDFLAGS -L$SYSROOT_PREFIX/usr/lib"

  PKG_CONFIGURE_OPTS_TARGET="--disable-cli \
                             --enable-opcache=no \
                             --without-pear \
                             --with-config-file-path=/storage/.xbmc/userdata/addon_data/service.web.lamp/srvroot/conf \
                             --localstatedir=/var \
                             --enable-ftp \
                             --enable-sockets \
                             --enable-session \
                             --enable-posix \
                             --enable-mbstring \
                             --enable-dom \
                             --enable-ctype \
                             --enable-zip \
                             --enable-libxml \
                             --enable-xml \
                             --enable-xmlreader \
                             --enable-xmlwriter \
                             --enable-simplexml \
                             --enable-fileinfo \
                             --with-libxml-dir=$SYSROOT_PREFIX/usr \
                             --with-curl=$SYSROOT_PREFIX/usr \
                             --with-openssl=$SYSROOT_PREFIX/usr \
                             --with-zlib=$SYSROOT_PREFIX/usr \
                             --with-bz2=$SYSROOT_PREFIX/usr \
                             --with-zlib=$SYSROOT_PREFIX/usr \
                             --with-iconv=$SYSROOT_PREFIX/usr \
                             --disable-cgi \
                             --without-gettext \
                             --without-gmp \
                             --enable-json \
                             --enable-pcntl \
                             --disable-sysvmsg \
                             --disable-sysvsem \
                             --disable-sysvshm \
                             --enable-filter \
                             --enable-calendar \
                             --with-pcre-regex \
                             --without-sqlite3 \
                             --enable-pdo \
                             --without-pdo-sqlite \
                             --with-mcrypt=$SYSROOT_PREFIX/usr \
                             --with-mysqli=$MYSQL_CONFIG_FILE \
                             --with-mysql=$SYSROOT_PREFIX/usr \
                             --with-mysql-sock=/var/tmp/mysql.socket \
                             --with-pdo-mysql=$SYSROOT_PREFIX/usr \
                             --with-gd \
                             --enable-gd-native-ttf \
                             --enable-gd-jis-conv \
                             --with-jpeg-dir=$SYSROOT_PREFIX/usr \
                             --with-freetype-dir=$SYSROOT_PREFIX/usr \
                             --with-png-dir=$SYSROOT_PREFIX/usr \
                             --with-apxs2=$APXS_FILE"

  # quick hack - freetype is in different folder
  sed -i "s|freetype2/freetype/freetype.h|freetype2/freetype.h|g" ../configure
}

post_configure_target() {
  # quick hack
  sed -i "s|-I/usr/include|-I/host_dummy/usr/include|g" Makefile
  sed -i "s|-L/usr/lib|-L/host_dummy/usr/lib|g" Makefile
}

makeinstall_target() {
  : # nothing to install
}
