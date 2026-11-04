# qt-symbian

This is Qt 4.8.7 for Phorepoc OS, plus Qt Mobility 1.2: the libraries that Qt and Qt Quick apps for Symbian^3 link against. It
exists so those apps keep running. Nothing in the system needs it.

Qt is only ever a SIS you install through the Catalogue. No system image carries it. The release has one SIS, built for
ARM: `qt-symbian-arm.sis` is the "Qt" package (4.8.7, the identity an app's SIS depends on). It installs the LGPL text, Qt's
LGPL exception and the source offer in `\resource\Qt\`.

Qt Mobility 1.2 ("QtMobility", which needs Qt) is not released yet: some of its components link platform libraries that are
not built yet (lbt, hwrmhapticsclient, the landmarks search libraries, ecamadvsettings, the character-set converters), and
they would ship with those imports stubbed. It joins the release once they are built.

This repository is the release: its workflow builds the packages and publishes them, and the Catalogue lists them. The build
itself is core's (`os/tools/phorepoc-qt48/`: the fetch and configure recipes, our patches to Qt, and `registry/components_qt48.py`
for every Qt DLL and plug-in); `recipes/` here runs it. No copy of Qt is kept anywhere: the recipes download the Qt 4.8.7 tarball
and check its SHA-256, and clone Qt Mobility and check its commit.

## Building

A full build takes hours (host tools, qmake's configuration for two Qt trees, then every module and plug-in).

Check out core, the [pdk](https://github.com/Phorepoc/pdk) and this repository side by side and run `phe source export -a` once.
Then, in the toolchain's web image, with `PHOREPOC_QT48=1` set:

```sh
bash recipes/prebuild.sh                       # fetch, patch and configure Qt
phe component build -arch arm $(sed -n 's/^COMPONENTS_arm="\(.*\)"/\1/p' package.conf)
bash recipes/sis.sh                            # the SIS files in $PHOREPOC_BUILD/sis/
```

## License

Our files are BSD-2-Clause. Qt and Qt Mobility are LGPL-2.1 with the Qt LGPL Exception 1.1, which is why they are kept in their
own libraries you can replace. `NOTICE` has the details.

Contributions are welcome under the same terms. Add your name to `AUTHORS` in your first pull request.
