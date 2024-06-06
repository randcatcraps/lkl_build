#!/bin/sh

# verbose
set -x

# fail fast
set -e

cd lkl

# configure
echo -e '\n### configuring LKL ###\n'
fragments="../lkl-extra-fs.config"
if [ ! -f .config ]; then
	make -C tools/lkl "$(pwd)/tools/lkl/../../.config"
	for fragment in ${fragments}; do
		ARCH=lkl scripts/kconfig/merge_config.sh .config "$fragment"
	done
fi

# build
echo -e '\n### building LKL ###\n'
export KCFLAGS="${KCFLAGS} -Wno-error=int-conversion"
make -C tools/lkl -j $(( $(nproc) + 1 )) "$@"
