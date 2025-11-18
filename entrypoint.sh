#!/bin/sh
set -e

echo "==============================="
echo "BUILD_GIT_VERSION: $BUILD_GIT_VERSION"
echo "BUILD_GIT_COMMIT:  $BUILD_GIT_COMMIT"
echo "BUILD_DATE:        $BUILD_DATE"
echo "==============================="

# Execute the original CMD
exec "$@"
