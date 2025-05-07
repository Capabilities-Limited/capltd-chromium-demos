#!/bin/sh

if ! [ $(id -u) = 0 ]; then
   echo "The script need to be run as root." >&2
   exit 1
fi

if [ $SUDO_USER ]; then
    real_user=$SUDO_USER
else
    real_user=$(whoami)
fi

echo "Chromium Demo setup"

###############################################################################
# Dependencies for Chromium (is_component = false).
# 
# Dependencies to check:
# borringssl probably isn't necessary as it is embedded in nss.
#
# Recently completed (but not needed by the demo):
#     dav1d
#     jsoncpp
#
# Missing (but not needed in the demo):
#     expat2 - no patches for this
#     harfbuzz-icu - no patches for this
#     libsecret - no patches for this
#     speech-dispatch - no patches ready for this
#     speex - no patches ready for this
#     snappy - no patches ready for this
###############################################################################
CHROMIUM_RUNTIME_DEPS="at-spi2-core cairo cups dbus dbus-glib flac fontconfig freetype2 glib gtk3 harfbuzz icu libdrm libepoll-shim libevent libexif libffi libgcrypt libpci libxkbcommon libxshmfence libxml2 libxslt mesa-libs noto-basic nspr nss openh264 opus png pango re2 wayland webp"

if $(pkg64c check -d $CHROMIUM_RUNTIME_DEPS); then
    echo "All Chromiumn runtime dependencies found"
else
    echo "Installing Chromium runtime dependencies"
    pkg64c install -y $CHROMIUM_RUNTIME_DEPS
fi

if [ ! -f /home/demo/.local/share/applications/chromium-browser.desktop ]; then
    sudo -u $real_user mkdir -p /home/demo/.local/share/applications
    sudo -u $real_user cp cheriabi-chromium-browser.desktop /home/demo/.local/share/applications
fi
