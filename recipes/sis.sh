#!/usr/bin/env bash
# Copyright The Phorepoc Authors
# SPDX-License-Identifier: BSD-2-Clause
#
# sis.sh -- the pdk's package.yml runs it after the components: the SIS files in $PHOREPOC_BUILD/sis/
#   qt-symbian-arm.sis          package "Qt" 4.8.7 (uid 0x2001E61C), the identity a Qt app's SIS depends on
#   qtmobility-symbian-arm.sis  package "QtMobility" 1.2.1 (uid 0x2002AC89), which depends on Qt
# core's recipes package them with the LGPL text, Qt's LGPL exception and the source offer inside (\resource\<package>\).
# The package versions are the libraries' own (an app declares "Qt >= 4.7.3"), not the release's version.
set -eu
[ "${PHOREPOC_ARCH:-arm}" = arm ] || { echo "qt-symbian is built for ARM only"; exit 1; }
QT="${PHOREPOC_OS_ROOT:?}/tools/phorepoc-qt48"
B="${PHOREPOC_BUILD:?}"
export PHOREPOC_QT48=1
bash "$QT/build_qt_sis.sh" sis
bash "$QT/build_qtmobility_sis.sh" sis
mkdir -p "$B/sis"
cp "$B/qt48/qt-4.8.7.sis" "$B/sis/qt-symbian-arm.sis"
cp "$B/qt48/qtmobility-1.2.1.sis" "$B/sis/qtmobility-symbian-arm.sis"
