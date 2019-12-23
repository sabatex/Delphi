del lib\*.* /F /Q >out.txt
del Debug_lib\*.* /F /Q >>out.txt
del Source\*.~* /F /Q >>out.txt
make -fMAKEFILE -DDEBUG >>out.txt
make -fMAKEFILE >>out.txt