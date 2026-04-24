#!/bin/bash
/usr/local/bin/openbor-pad-config
pushd "/opt/retropie/ports/openbor" || exit 1
./OpenBOR "$@"
popd || exit 1
