#include "ubicacio.hpp"

/* Constructora. Crea la ubicació <i, j, k>. Genera un error si
  <i, j, k> no pertany a {<u, v, w> | u >= 0 ^ v >= 0 ^ w >= 0}
   o a {<-1, 0, 0>,  <-1,-1,-1>}. */
ubicacio::ubicacio(int i, int j, int k) throw(error) {
    if (
        (i >= 0 and j >= 0 and k >= 0) or
        (i == -1 and j == 0 and k == 0) or
        (i == -1 and j == -1 and k == -1)
    ) {
        _filera = i;
        _placa = j;
        _pis = k;
    } else {
        throw error(UbicacioIncorrecta);
    }
}

/* Constructora per còpia, assignació i destructora. */
ubicacio::ubicacio(const ubicacio& u) throw(error) {
    _filera = u._filera;
    _placa = u._placa;
    _pis = u._pis;
}

ubicacio& ubicacio::operator=(const ubicacio& u) throw(error) {
    _filera = u._filera;
    _placa = u._placa;
    _pis = u._pis;
    return *this;
}

ubicacio::~ubicacio() throw() { }

/* Consultors. Retornen respectivament el primer, segon i tercer
   component de la ubicació. */
int ubicacio::filera() const throw() {
    return _filera;
}

int ubicacio::placa() const throw() {
    return _placa;
}

int ubicacio::pis() const throw() {
    return _pis;
}

/* Operadors de comparació.
   L'operador d'igualtat retorna cert si i només si les dues ubicacions
   tenen la mateixa filera, plaça i pis. L'operador menor retorna cert si
   i només si la filera del paràmetre implícit és més petit que la
   d'u, o si les dues fileres són iguals i la plaça del paràmetre
   implícit és més petita que la d'u, o si les fileres i les places
   coincideixen i el pis del paràmetre implícit és més petit que el d'u.
   La resta d'operadors es defineixen consistentment respecte <. */
bool ubicacio::operator==(const ubicacio &u) const throw() {
    return (_filera == u._filera) and (_placa == u._placa) and (_pis == u._pis);
}

bool ubicacio::operator!=(const ubicacio &u) const throw() {
    return !(*this==u);
}

bool ubicacio::operator<(const ubicacio &u) const throw() {
    return (_filera < u._filera) or (_filera == u._filera and _placa < u._placa) or (_filera == u._filera and _placa == u._placa and _pis < u._pis);
}

bool ubicacio::operator<=(const ubicacio &u) const throw() {
    return !(*this>u);
}

bool ubicacio::operator>(const ubicacio &u) const throw() {
    return (!(*this<u) && (*this!=u));
}

bool ubicacio::operator>=(const ubicacio &u) const throw() {
    return !(*this<u);
}
