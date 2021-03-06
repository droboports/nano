### NCURSES ###
_build_ncurses() {
local VERSION="5.9"
local FOLDER="ncurses-${VERSION}"
local FILE="${FOLDER}.tar.gz"
local URL="http://ftp.gnu.org/gnu/ncurses/${FILE}"

_download_tgz "${FILE}" "${URL}" "${FOLDER}"
pushd target/"${FOLDER}"
./configure --host="${HOST}" --prefix="${DEPS}" \
  --libdir="${DEST}/lib" --datadir="${DEST}/share" \
  --with-shared --enable-rpath --enable-widec
make
make install
rm -v "${DEST}/lib"/*.a
popd
}

### NANO ###
_build_nano() {
local VERSION="2.4.2"
local FOLDER="nano-${VERSION}"
local FILE="${FOLDER}.tar.gz"
local URL="http://www.nano-editor.org/dist/v2.4/${FILE}"

_download_tgz "${FILE}" "${URL}" "${FOLDER}"
pushd "target/${FOLDER}"
PKG_CONFIG_PATH="${DEST}/lib/pkgconfig" \
  ./configure --host="${HOST}" --prefix="${DEST}" --mandir="${DEST}/man" \
  --enable-utf8 ac_cv_prog_ac_ct_NCURSESW_CONFIG="${DEPS}/bin/ncursesw5-config"
make
make install
mkdir -p "${DEST}/etc"
cp -vf doc/nanorc.sample "${DEST}/etc/nanorc.default"
for f in ${DEST}/share/nano/*.nanorc; do
  sed -e "s/\\\\>/\\\\b/g" -e "s/\\\\</\\\\b/g" -i "${f}"
  echo "include \"${f}\"" >> "${DEST}/etc/nanorc.default"
done
popd
}

### BUILD ###
_build() {
  _build_ncurses
  _build_nano
  _package
}
