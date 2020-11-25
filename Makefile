OPCIONS = -D_JUDGE_ -D_GLIBCXX_DEBUG -g -O0 -Wall -Wextra -Wno-sign-compare -std=c++11

program.exe: driver_gesterm.o ubicacio.o contenidor.o cataleg.o
	g++ -o program.exe driver_gesterm.o ubicacio.o contenidor.o cataleg.o -lesin
	rm *.o

driver_gesterm.o: driver_gesterm.cpp driver_gesterm.hpp
	g++ -c driver_gesterm.cpp $(OPCIONS)

cataleg.o: cataleg.rep cataleg.t cataleg.hpp
	g++ -c cataleg.t $(OPCIONS)

contenidor.o: contenidor.rep contenidor.cpp contenidor.hpp
g++ -c contenidor.cpp $(OPCIONS)

ubicacio.o: ubicacio.cpp ubicacio.rep ubicacio.hpp
	g++ -c ubicacio.cpp $(OPCIONS)

clean:
	rm *.o
	rm *.exe
	rm *.gch
