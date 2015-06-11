local t = {3, 17, 19, 27}

math.randomseed(os.time())

print( string.format("%s", table.concat(t, ",") ) )
print( string.format("随机结果为:%d", t[math.random(1, #t)]) )
