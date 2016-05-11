# call from .travis/setup_lua.sh

$1 -v
find ./ -wholename "${TRAVIS_BUILD_DIR}/*.lua" | xargs $1
