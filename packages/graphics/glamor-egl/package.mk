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

PKG_NAME="glamor-egl"
PKG_VERSION="0.5.1"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://cgit.freedesktop.org/xorg/driver/glamor/"
PKG_URL="http://cgit.freedesktop.org/xorg/driver/glamor/snapshot/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS="Mesa libdrm"
PKG_BUILD_DEPENDS_TARGET="toolchain Mesa xorg-server libdrm"
PKG_PRIORITY="optional"
PKG_SECTION="graphics"
PKG_SHORTDESC="glamor-egl: OpenGL based 2D rendering acceleration library"
PKG_LONGDESC="glamor-egl is a OpenGL based 2D rendering acceleration library"

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--enable-glx-tls"

pre_configure_target() {
  # glamor-egl fails to build with GOLD if we build with --enable-glx-tls
  strip_gold
}

