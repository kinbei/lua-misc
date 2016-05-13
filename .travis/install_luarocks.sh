set -o errexit

LUAROCKS_DIR=${TRAVIS_BUILD_DIR}/luarocks
mkdir -p ${LUAROCKS_DIR}
cd ${LUAROCKS_DIR}

LUA_5_3_DIR=${LUAROCKS_DIR}/lua-5.3.2
curl --location http://www.lua.org/ftp/lua-5.3.2.tar.gz | tar xz;
cd ${LUA_5_3_DIR}
sudo make linux && sudo make install INSTALL_TOP=${LUA_5_3_DIR}
${LUA_5_3_DIR}/bin/lua -v

wget http://luarocks.org/releases/luarocks-2.3.0.tar.gz
tar zxpf luarocks-2.3.0.tar.gz
cd luarocks-2.3.0
./configure --with-lua=${LUA_5_3_DIR}; sudo make bootstrap
