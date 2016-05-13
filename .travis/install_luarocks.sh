set -o errexit

LUAROCKS_DIR=${TRAVIS_BUILD_DIR}/luarocks
cd ${LUAROCKS_DIR}

wget http://luarocks.org/releases/luarocks-2.3.0.tar.gz
tar zxpf luarocks-2.3.0.tar.gz
cd luarocks-2.3.0
./configure; sudo make bootstrap
