OPCIONS = -O0 -Wall -Wextra -Werror -Wno-sign-compare -Wno-deprecated -std=c++11 -ansi -g

program.exe: driver_gestterm.o ubicacio.o contenidor.o terminal.o
	g++ -o program.exe driver_gestterm.o ubicacio.o contenidor.o terminal.o -lesin
	rm *.o

driver_gestterm.o: driver_gestterm.cpp terminal.hpp terminal.rep cataleg.hpp cataleg.t ubicacio.hpp ubicacio.rep contenidor.hpp contenidor.rep
	g++ -c driver_gestterm.cpp $(OPCIONS)

terminal.o: terminal.cpp terminal.hpp terminal.rep cataleg.hpp cataleg.t ubicacio.hpp ubicacio.rep contenidor.hpp contenidor.rep
	g++ -c terminal.cpp $(OPCIONS)

ubicacio.o: ubicacio.cpp ubicacio.hpp ubicacio.rep
	g++ -c ubicacio.cpp $(OPCIONS)

contenidor.o: contenidor.cpp contenidor.hpp contenidor.rep
	g++ -c contenidor.cpp $(OPCIONS)

clean:
	rm *.o
	rm *.exe
	rm *.gch
