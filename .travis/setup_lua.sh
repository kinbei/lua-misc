LUA_HOME_DIR=${TRAVIS_BUILD_DIR}/lua
mkdir -p ${LUA_HOME_DIR}

# lua 5.1
cd ${LUA_HOME_DIR}
LUA_5_1_DIR=${LUA_HOME_DIR}/lua-5.1
curl --location http://www.lua.org/ftp/lua-5.1.tar.gz | tar xz;
cd ${LUA_5_1_DIR}
sudo make linux && sudo make local
ls