echo `pwd`
echo ${HOME}

LUA_HOME_DIR=${HOME}/lua
mkdir -p ${LUA_HOME_DIR}
echo 'LUA_HOME_DIR=${LUA_HOME_DIR}'

# lua 5.1
LUA_5_1_DIR=${LUA_HOME_DIR}/lua51
mkdir -p ${LUA_5_1_DIR}
cd ./lua51
curl --location http://www.lua.org/ftp/lua-5.1.tar.gz | tar xz;
make && make install PREFIX="${LUA_5_1_DIR}"

