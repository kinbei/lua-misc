# call from .travis/setup_lua.sh

$1 -v
find ./ -wholename "${TRAVIS_BUILD_DIR}/*.lua" | xargs ${TRAVIS_BUILD_DIR}/$1
