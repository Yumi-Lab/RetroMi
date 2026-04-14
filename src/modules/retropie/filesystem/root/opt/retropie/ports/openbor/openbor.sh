#!/bin/bash
/usr/local/bin/openbor-pad-config
pushd "/opt/retropie/ports/openbor"
./OpenBOR "$@"
popd
