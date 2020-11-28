OPCIONS = -O0 -Wall -Wextra -Werror -Wno-sign-compare -std=c++11 -ansi -g

program.exe: driver_gesterm.o ubicacio.o contenidor.o terminal.o cataleg.rep
	g++ -o program.exe driver_gesterm.o ubicacio.o contenidor.o cataleg.o terminal.o -lesin
	rm *.o

ubicacio.o: ubicacio.cpp ubicacio.hpp ubicacio.rep
	g++ -c ubicacio.cpp $(OPCIONS)

contenidor.o: contenidor.cpp contenidor.hpp contenidor.rep
	g++ -c contenidor.cpp $(OPCIONS)

driver_gesterm.o: driver_gestterm.cpp terminal.cpp terminal.hpp terminal.rep contenidor.hpp contenidor.rep ubicacio.hpp ubicacio.rep cataleg.t cataleg.hpp
	g++ -c driver_gestterm.cpp $(OPCIONS)

terminal.o: terminal.cpp terminal.hpp terminal.rep contenidor.hpp contenidor.rep ubicacio.hpp ubicacio.rep cataleg.t cataleg.hpp
	g++ -c terminal.cpp $(OPCIONS)

clean:
	rm *.o
	rm *.exe
	rm *.gch
