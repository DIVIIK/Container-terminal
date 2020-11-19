OPCIONS = -D_JUDGE_ -D_GLIBCXX_DEBUG -g -O0 -Wall -Wextra -Wno-sign-compare -std=c++11

# solution.exe: main.o ubicacio.o contenidor.o cataleg.o
# 	g++ -o solution.exe main.o llista.o solution.o
# 	rm *.o

# solution.o: solution.cpp llista.hpp
# 	g++ -c solution.cpp $(OPCIONS)

# main.o: main.cpp llista.hpp
# 	g++ -c main.cpp $(OPCIONS)

# cataleg.o: cataleg.rep cataleg.cpp cataleg.hpp
# 	g++ -c cataleg.cpp $(OPCIONS)

contenidor.o: contenidor.rep contenidor.cpp contenidor.hpp
g++ -c contenidor.cpp $(OPCIONS)

# ubicacio.o: ubicacio.cpp ubicacio.rep ubicacio.hpp
# 	g++ -c ubicacio.cpp $(OPCIONS)

clean:
	rm *.o
	rm *.exe
	rm *.gch
