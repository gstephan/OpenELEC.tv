################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv) & ultraman
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

import sys
import xbmcaddon

if len(sys.argv) >= 1:
  if sys.argv[1] == 'True':
    xbmc.audioResume()
    xbmc.enableNavSounds(True)
  else:
    xbmc.executebuiltin("PlayerControl(Stop)")
    xbmc.audioSuspend()
    xbmc.enableNavSounds(False)
else:
  xbmc.enableNavSounds(False)

# http://passion-xbmc.org/gros_fichiers/XBMC%20Python%20Doc/xbmc_svn/xbmc.html

# enable navigation sound
# xbmc-send -a "RunScript(/storage/.xbmc/addons/web.browser.opera/bin/navsounds-toggle.py, True)"
# disable navigation sound
# xbmc-send -a "RunScript(/storage/.xbmc/addons/web.browser.opera/bin/navsounds-toggle.py, False)"
