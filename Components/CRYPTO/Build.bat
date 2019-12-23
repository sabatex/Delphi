del lib\*.* /F /Q >out.txt
del Debug_lib\*.* /F /Q >>out.txt
P:\BIN\D6U2RTL1\BIN\make -fMAKEFILE -DDEBUG >>out.txt  
P:\BIN\D6U2RTL1\BIN\make -fMAKEFILE >>out.txt