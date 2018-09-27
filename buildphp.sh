#!/bin/sh

# This script builds a docker container, compiles PHP for use with AWS Lambda,
# and copies the final binary to the host and then removes the container.
#
# You can specify the PHP Version by setting the branch corresponding to the
# source from https://github.com/php/php-src

if [ $# -lt 1 ]; then
  echo
  echo "Usage: $0 VERSION"
  echo "Build shared libraries for php and its dependencies via containers"
  echo
  echo "Please specify the php VERSION, e.g. 7.1.5, 7.0.20, 5.6.30"
  echo
  exit 1
fi

PHP_VERSION_GIT_BRANCH="php-$1"

echo "Build PHP Binary from current branch '$PHP_VERSION_GIT_BRANCH' on https://github.com/php/php-src"

docker build --build-arg PHP_VERSION=$PHP_VERSION_GIT_BRANCH -t php-build -f dockerfile.buildphp .

container=$(docker create php-build)

docker -D cp $container:/php-src-$PHP_VERSION_GIT_BRANCH/sapi/cli/php .

docker rm $container
