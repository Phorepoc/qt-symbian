#!/usr/bin/env bash
# Copyright The Phorepoc Authors
# SPDX-License-Identifier: BSD-2-Clause
#
# sis.sh -- the pdk's package.yml runs it after the components: the SIS files in $PHOREPOC_BUILD/sis/
#   qt-symbian-arm.sis          package "Qt" 4.8.7 (uid 0x2001E61C), the identity a Qt app's SIS depends on
#   qt-symbian-x32.sis          the same package for the PC image (QtCore, QtGui, QtNetwork, QtSvg, QtXml, QtSql)
#   qtmobility-x32.sis          package "QtMobility" 1.2.1 (uid 0x2002AC89, needs Qt): the x32 subset the Symbian^4 UI imports (QTM_x32 of package.conf)
# For ARM core's recipe packages it with the LGPL text, Qt's LGPL exception and the source offer inside (\resource\Qt\); for x32
# the pdk's make_sis does, with the same files. The package versions are the libraries' own (an app declares "Qt >= 4.7.3"),
# not the release's version.
set -eu
ARCH="${PHOREPOC_ARCH:-arm}"
QT="${PHOREPOC_OS_ROOT:?}/tools/phorepoc-qt48"
B="${PHOREPOC_BUILD:?}"
export PHOREPOC_QT48=1
mkdir -p "$B/sis"
if [ "$ARCH" = x32 ]; then
  REPO=$(cd "$(dirname "$0")/.." && pwd)
  ALL=$(sed -n 's/^COMPONENTS_x32="\(.*\)"/\1/p' "$REPO/package.conf")
  QTMKEYS=$(sed -n 's/^QTM_x32="\(.*\)"/\1/p' "$REPO/package.conf")
  KEYS=""; for k in $ALL; do case " $QTMKEYS " in *" $k "*) ;; *) KEYS="$KEYS $k";; esac; done
  LIC=(--file "$REPO/LICENSES/LGPL-2.1.txt=!:/resource/Qt/LICENSE.LGPL" --file "$REPO/SOURCE-OFFER.txt=!:/resource/Qt/SOURCE-OFFER.txt")
  EXC="$B/qt48/qt-src/LGPL_EXCEPTION.txt"
  [ -f "$EXC" ] && LIC+=(--file "$EXC=!:/resource/Qt/LGPL_EXCEPTION.txt")
  python3 "$PHOREPOC_PDK/tools/make_sis.py" $KEYS --unsigned --uid 0x2001E61C --version 4.8.7 --name "Qt" --vendor Phorepoc \
    "${LIC[@]}" --out "$B/sis/qt-symbian-x32.sis"
  # Qt Mobility 1.2.1 (the x32 subset the Symbian^4 UI imports), its own package: needs Qt, the upstream sources unmodified
  QLIC=(--file "$REPO/LICENSES/LGPL-2.1.txt=!:/resource/QtMobility/LICENSE.LGPL" --file "$REPO/SOURCE-OFFER.txt=!:/resource/QtMobility/SOURCE-OFFER.txt")
  [ -f "$EXC" ] && QLIC+=(--file "$EXC=!:/resource/QtMobility/LGPL_EXCEPTION.txt")
  python3 "$PHOREPOC_PDK/tools/make_sis.py" $QTMKEYS --unsigned --uid 0x2002AC89 --version 1.2.1 --name "QtMobility" --vendor Phorepoc \
    --depends 0x2001E61C,4.8.0,Qt "${QLIC[@]}" --out "$B/sis/qtmobility-x32.sis"
else
  bash "$QT/build_qt_sis.sh" sis
  cp "$B/qt48/qt-4.8.7.sis" "$B/sis/qt-symbian-arm.sis"
fi
