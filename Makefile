OPCIONS = -O0 -Wall -Wextra -Werror -Wno-sign-compare -Wno-deprecated -std=c++11 -ansi -g

# program.exe: driver_gestterm.o ubicacio.o contenidor.o
# 	g++ -o program.exe driver_gestterm.o ubicacio.o contenidor.o -lesin
# 	rm *.o

# driver_gestterm.o: driver_gestterm.cpp terminal.cpp terminal.hpp terminal.rep contenidor.hpp contenidor.rep ubicacio.hpp ubicacio.rep
# 	g++ -c driver_gestterm.cpp $(OPCIONS)

terminal.o: terminal.cpp terminal.hpp terminal.rep 
	g++ -c terminal.cpp $(OPCIONS)

cataleg.o: cataleg.rep cataleg.hpp cataleg.t
	g++ -c cataleg.rep $(OPCIONS)

ubicacio.o: ubicacio.cpp ubicacio.hpp ubicacio.rep
	g++ -c ubicacio.cpp $(OPCIONS)

contenidor.o: contenidor.cpp contenidor.hpp contenidor.rep
	g++ -c contenidor.cpp $(OPCIONS)

clean:
	rm *.o
	rm *.exe
	rm *.gch
