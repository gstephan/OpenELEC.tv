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

#PKG_VERSION="5.5.8"
PKG_VERSION="5.3.3"

PKG_REV="0"
PKG_ARCH="any"
PKG_LICENSE="OpenSource"
PKG_SITE="http://www.php.net"

if [ $PKG_VERSION != "5.5.8" ]; then
  PKG_URL="http://museum.php.net/php5/php-$PKG_VERSION.tar.bz2"
else
  PKG_URL="http://www.php.net/distributions/$PKG_NAME-$PKG_VERSION.tar.bz2"
fi

# add some other libraries which are need by php extensions
PKG_DEPENDS_TARGET="toolchain zlib pcre curl openssl libxml2 httpd:host"
PKG_PRIORITY="optional"
PKG_SECTION="web"
PKG_SHORTDESC="php: Scripting language especially suited for Web development"
PKG_LONGDESC="PHP is a widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML."
PKG_IS_ADDON="no"
PKG_MAINTAINER="none"
PKG_AUTORECONF="no"

#export MAKEFLAGS=-j1

pre_configure_target() {
  APXS_FILE=$(ls -d $ROOT/$BUILD/httpd-*)/.$HOST_NAME/support/apxs
  chmod +x $APXS_FILE

  PKG_CONFIGURE_OPTS_TARGET="--disable-all \
                             --with-config-file-path=/storage/.xbmc/userdata/addon_data/service.web.httpd/srvroot/conf \
                             --localstatedir=/var \
                             --oldincludedir=/dummy \
                             --without-pear \
                             --without-gettext \
                             --without-gmp \
                             --disable-sockets \
                             --disable-pcntl \
                             --disable-sysvmsg \
                             --disable-sysvsem \
                             --disable-sysvshm \
                             --disable-filter \
                             --disable-calendar \
                             --disable-spl \
                             --disable-cgi \
                             --disable-cli \
                             --enable-posix \
                             --enable-json \
                             --with-curl=shared,$SYSROOT_PREFIX/usr \
                             --with-openssl=shared \
                             --with-libxml=shared \
                             --with-xml=shared \
                             --with-xmlreader=shared \
                             --with-xmlwriter=shared \
                             --with-simplexml=shared \
                             --with-simplexml=shared \
                             --with-libxml-dir=$SYSROOT_PREFIX/usr \
                             --with-zlib=shared \
                             --with-pcre-regex \
                             --without-sqlite3 \
                             --enable-pdo \
                             --without-pdo-sqlite \
                             --with-mysql=shared,$SYSROOT_PREFIX/usr \
                             --with-mysql-sock=/var/tmp/mysql.socket \
                             --with-pdo-mysql=shared,$SYSROOT_PREFIX/usr \
                             --with-apxs2=$APXS_FILE \
                             \
                             --with-gd=shared \
                             --with-jpeg-dir=$SYSROOT_PREFIX/usr \
                             --enable-gd-native-ttf \
                             --with-freetype-dir=$SYSROOT_PREFIX/usr \
                             --with-png-dir=$SYSROOT_PREFIX/usr \
                             --enable-zip=shared \
                             --with-bz2=shared,$SYSROOT_PREFIX/usr \
                             --with-zlib=shared,$SYSROOT_PREFIX/usr"

  # quick hack - freetype is in different folder
  sed -i "s|freetype2/freetype/freetype.h|freetype2/freetype.h|g" ../configure
}

makeinstall_target() {
  : # nothing to install
}
