#!/usr/bin/env bash
# Copyright The Phorepoc Authors
# SPDX-License-Identifier: BSD-2-Clause
#
# prebuild.sh -- the pdk's package.yml runs it in the toolchain container before the components: core's Qt 4.8.7 recipe
# (os/tools/phorepoc-qt48/build_qt_sis.sh: the source fetched and SHA-256 checked, the host tools, qmake's generated
# project files, the moc/rcc/uic outputs, the patches), then the same for Qt Mobility (checked against its pinned commit).
# The images are built afterwards by `phe component build` (package.conf; core's registry has the Qt components when
# PHOREPOC_QT48=1).
set -eu
QT="${PHOREPOC_OS_ROOT:?}/tools/phorepoc-qt48"
export PHOREPOC_QT48=1 JOBS=${JOBS:-$(nproc)}
bash "$QT/build_qt_sis.sh" fetch host configure configure_full mocables stage
bash "$QT/build_qtmobility_sis.sh" fetch configure
