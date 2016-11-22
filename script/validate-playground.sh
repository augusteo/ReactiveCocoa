#!/bin/bash

# Bash script to lint the content of playgrounds
# Heavily based on RxSwift's 
# https://github.com/ReactiveX/RxSwift/blob/master/scripts/validate-playgrounds.sh

if [ -z "$BUILD_DIRECTORY" ]; then
	echo "\$BUILD_DIRECTORY is not set. Are you trying to run \`validate-playgrounds.sh\` without building RAC first?\n"
	echo "To validate the playground, run \`script/build\`."
	exit 1
fi

if [ -z "$PLAYGROUND" ]; then
	echo "\$PLAYGROUND is not set."
	exit 1
fi

if [ -z "$XCODE_PLAYGROUND_TARGET" ]; then
	echo "\$XCODE_PLAYGROUND_TARGET is not set."
	exit 1
fi

PRODUCT_NAME=

if [ "$XCODE_SDK" -eq "macosx" ]; then
	PRODUCT_NAME=${CONFIGURATION}
else
	PRODUCT_NAME=${CONFIGURATION}-${XCODE_SDK}
fi

PAGES_PATH=${BUILD_DIRECTORY}/Build/Products/${PRODUCT_NAME}/all-playground-pages.swift

cat ${PLAYGROUND}/Sources/*.swift ${PLAYGROUND}/Pages/**/*.swift > ${PAGES_PATH}

swift -v -target ${XCODE_PLAYGROUND_TARGET} -D NOT_IN_PLAYGROUND -F ${BUILD_DIRECTORY}/Build/Products/${PRODUCT_NAME} ${PAGES_PATH} > /dev/null
result=$?

# Cleanup
rm -Rf $BUILD_DIRECTORY

exit $result
