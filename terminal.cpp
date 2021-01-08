#include "terminal.hpp"

//-----------------------------------------------------
//
//  Métodes Privats
//
//-----------------------------------------------------



//A partir d'una filera, busca la seguent posició on es pot inserir un contenidor de 10 peus
void terminal::actualitza_pos(int fil) {
    bool trobat10 = false, trobat20 = false, trobat30 = false;
    int placa = 0, pis = 0, x;
    //Comprovem si es necesari actualitzar les posicions.
    if(_u10.filera() < fil) trobat10 = true;
    if(_u20.filera() < fil) trobat20 = true;
    if(_u30.filera() < fil) trobat30 = true;

    while(not trobat30) {
        if(_p[fil][placa] < _h) {
            if(not trobat10) {
                _u10 = ubicacio(fil, placa, pis);
                trobat10 = true;
            }
            if(not trobat20 and _p[fil][placa] == _p[fil][placa+1]) {
                _u20 = ubicacio(fil, placa, pis);
                trobat20 = true;
            }
            if(_p[fil][placa] == _p[fil][placa+1] and _p[fil][placa] == _p[fil][placa+2]) {
                _u30 = ubicacio(fil, placa, pis);
                trobat30 = true;
            }
        }
        else {
            ++placa;
            if(not trobat10) x = 0;
            else if(not trobat20) x = 1;
            else if(not trobat30) x = 2;
            if(placa == _m - x) {
                ++fil;
                placa = 0;
                if(fil == _n) {
                    if(not trobat10) _u10 = ubicacio(-1,0,0);
                    if(not trobat20) _u20 = ubicacio(-1,0,0);
                    if(not trobat30) _u30 = ubicacio(-1,0,0);
                    trobat30 = true;
                }
            }
        }
    }
}

void terminal::retira_contenidor_superior(const string &m) {
    ubicacio u = on(m);

    if (_c.existeix(m)) {
        nat l = 1;

        // Mateixa filera <i, j, k>
        nat i = u.filera();
        nat j = u.placa();
        nat k = u.pis() + 1;
        if (k < _h) {
            for (nat x = 0; x < l; x++) {
                string mat = _t[i][j+x][k];

                if (mat != "") {
                    retira_contenidor_superior(mat);

                    // Retirar aquest contenidor
                    for (nat z = 0; z < l; z++) {
                        // 1. Eliminar de l'area de emmagatzematge
                        _t[i][j+z][k] = "";

                        // 2. Actualitzar estructura auxiliar _p
                        --_p[u.filera()][u.placa() + z];
                    }

                    // 3. Indicar nova ubicacio al cataleg de contenidors
                    _c[m].second = ubicacio(-1,0,0);

                    // 4. Afegir a l'area d'espera
                    _areaEspera.push_back(_c[m].first);

                    // 5. Indicar nova operacio grua
                    _opsGrua++;
                }
            }
        }
    }
}

//-----------------------------------------------------
//
//  Métodes de Classe
//
//-----------------------------------------------------

terminal::terminal(nat n, nat m, nat h, estrategia st) throw(error) : _c(n*m*h), _u10(1,1,1), _u20(1,1,1), _u30(1,1,1) {
    if(n == 0) throw error(NumFileresIncorr);
    else _n = n;
    if(m == 0) throw error(NumPlacesIncorr);
    else _m = m;
    if(h == 0 or h > HMAX) throw error(AlcadaMaxIncorr);
    else _h = h;
    if(st != FIRST_FIT and st != LLIURE) throw error(EstrategiaIncorr);
    else _st = st;

    _t = new string**[_n];
    for(int i = 0; i < _n; ++i) {
        _t[i] = new string*[_m];
        for (int j = 0; j < _m; ++j) {
            _t[i][j] = new string[_h];
            _p[i][j] = 0;
        }
    }
    _opsGrua = 0;
}

/* Constructora per còpia, assignació i destructora. */
terminal::terminal(const terminal& b) throw(error) : _c(1), _u10(1,1,1), _u20(1,1,1), _u30(1,1,1) {
  _n = b._n;
  _m = b._m;
  _h = b._h;
  _st = b._st;
  _t = b._t;
  _p = b._p;
  _areaEspera = b._areaEspera;
  _opsGrua = b._opsGrua;
}

terminal& terminal::operator=(const terminal& b) throw(error) {
  _n = b._n;
  _m = b._m;
  _h = b._h;
  _st = b._st;
  _areaEspera = b._areaEspera;
  _u10 = b._u10;
  _u20 = b._u20;
  _u30 = b._u30;
  _opsGrua = b._opsGrua;
  return *this;
}

terminal::~terminal() throw() {
    // Revisar
    for(int i = 0; i < _n; ++i) {
        for (int j = 0; j < _m; ++j)
            delete _t[i][j];
        delete _t[i];
    }
    delete _t;
}

/* Col·loca el contenidor c en l'àrea d'emmagatzematge de la terminal o
   en l'àrea d'espera si no troba lloc en l'àrea d'emmagatzematge usant
   l'estratègia prefixada en el moment de crear la terminal. Si el
   contenidor c es col·loca en l'àrea d'emmagatzematge pot succeir que
   un o més contenidors de l'àrea d'espera puguin ser moguts a l'àrea
   d'emmagatzematge.
   En aquest cas es mouran els contenidors de l'àrea d'espera a l'àrea
   d'emmagatzematge seguint l'ordre que indiqui l'estratègia que s'està
   usant. Finalment, genera un error si ja existís a la terminal un
   contenidor amb una matrícula idèntica que la del contenidor c. */
void terminal::insereix_contenidor(const contenidor &c) throw(error) {
	if(this->on(c.matricula()) == ubicacio(-1,-1,-1)) {
        ubicacio u(-1,0,0);
        ++_opsGrua;
        if(_st == FIRST_FIT) {
            if(c.longitud() == 1) {
                if(_u10 != u) {
                    _t[_u10.filera()][_u10.placa()][_u10.pis()] = c.matricula();
                    ++_p[_u10.filera()][_u10.placa()];
                    u = _u10;
                }
                else {
                    _areaEspera.push_back(c);
                }
            }
            else if(c.longitud() == 2) {
                if(_u20 != u) {
                    _t[_u20.filera()][_u20.placa()][_u20.pis()] = c.matricula();
                    ++_p[_u20.filera()][_u20.placa()];
                    ++_p[_u20.filera()][_u20.placa()+1];
                    u = _u20;
                }
                else {
                    _areaEspera.push_back(c);
                }
            }
            else {
                if(_u30 != u) {
                    _t[_u30.filera()][_u30.placa()][_u30.pis()] = c.matricula();
                    ++_p[_u30.filera()][_u30.placa()];
                    ++_p[_u30.filera()][_u30.placa()+1];
                    ++_p[_u30.filera()][_u30.placa()+2];
                    u = _u30;
                }
                else {
                    _areaEspera.push_back(c);
                }
            }
            std::pair<contenidor, ubicacio> p = std::make_pair(c, u);
            _c.assig(c.matricula(), p);
            actualitza_pos(_u10.filera());
        }
        else { //Altra estrategia

        }
    }
    else throw error(MatriculaDuplicada);

    if (c == c) throw error(MatriculaDuplicada);
}

/* Retira de la terminal el contenidor c la matrícula del qual és igual
   a m. Aquest contenidor pot estar a l'àrea d'emmagatzematge o a l'àrea
   d'espera. Si el contenidor estigués a l'àrea d'emmagatzematge llavors
   s'hauran de moure a l'àrea d'espera tots els contenidors que siguin
   necessaris per netejar la part superior de c, s'hauran de retirar
   possiblement diversos contenidors, començant pel contenidor sense cap
   altre a sobre amb el número de plaça més baix (més a l'esquerra) i així
   successivament (veure exemple amb detall a la subsecció Estratègia
   FIRST_FIT). Un cop s'hagi eliminat el contenidor indicat, s'intenta
   moure contenidors de l'àrea d'espera a l'àrea d'emmagatzematge, seguint
   l'ordre que indiqui l'estratègia que s'està usant. Genera un error si a
   la terminal no hi ha cap contenidor la matrícula del qual sigui igual a m. */
void terminal::retira_contenidor(const string &m) throw(error) {
    ubicacio areaEspera(-1,0,0);
    ubicacio u = on(m);

    if (u != areaEspera) {
        if (_c.existeix(m)) {
            retira_contenidor_superior(m);

		 	nat lon = 10;
			nat i = u.filera();
            nat j = u.placa();
            nat k = u.pis() + 1;

            // Retirar aquest contenidor
            for (nat z = 0; z < lon; z++) {
                // 1. Eliminar de l'area de emmagatzematge
                _t[i][j+z][k] = "";

                // 2. Actualitzar estructura auxiliar _p
                --_p[u.filera()][u.placa() + z];
            }

            // 3. Retirar del cataleg de contenidors
            _c.elimina(m);

            // 4. Buscar seguent ubicacio lliure
            actualitza_pos(u.filera());

            // 5. Recolocar contenidors del Area d'espera
            string anterior = "";
            while (not _areaEspera.empty() and anterior != _areaEspera.back().matricula() ) {
                anterior = _areaEspera.back().matricula();
                insereix_contenidor(_areaEspera.back());
                _areaEspera.pop_back();
            }
        }
        else
            throw error(MatriculaInexistent);

    } else
        throw error(UbicacioNoMagatzem);
}

/* Retorna la ubicació <i, j, k> del contenidor la matrícula del qual és
   igual a m si el contenidor està a l'àrea d'emmagatzematge de la terminal,
   la ubicació <-1, 0, 0> si el contenidor està a l'àrea d'espera, i la
   ubicació <-1, -1, -1> si no existeix cap contenidor que tingui una
   matrícula igual a m.
   Cal recordar que si un contenidor té més de 10 peus, la seva ubicació
   correspon a la plaça que tingui el número de plaça més petit. */
ubicacio terminal::on(const string &m) const throw() {
    try {
        return ubicacio(1,1,1);
    } catch (...) {
        return ubicacio(-1,-1,-1);
    }
    if (m == m) throw error(MatriculaDuplicada);

}

/* Retorna la longitud del contenidor la matrícula del qual és igual
   a m. Genera un error si no existeix un contenidor a la terminal
   la matrícula del qual sigui igual a m. */
nat terminal::longitud(const string &m) const throw(error) {
    try {
        return 1;
    } catch (...) {
        throw error(MatriculaInexistent);
    }
    if (m == m) throw error(MatriculaDuplicada);

}

/* Retorna la matrícula del contenidor que ocupa la ubicació u = <i, j, k>
   o la cadena buida si la ubicació està buida. Genera un error si
   i < 0, i >= n, j < 0, j >= m, k < 0 o k >= h, o sigui si <i, j, k> no
   identifica una ubicació vàlida de l'àrea d'emmagatzematge. Cal observar
   que si m, obtinguda amb t.contenidor_ocupa(u, m), és una matrícula (no
   la cadena buida) pot succeir que u != t.on(m), ja que un contenidor pot
   ocupar diverses places i la seva ubicació es correspon amb la de la
   plaça ocupada amb número de plaça més baix. */
void terminal::contenidor_ocupa(const ubicacio &u, string &m) const throw(error) {
    ubicacio uMinim(0,0,0);
    ubicacio uMaxim(_n,_m,_h);
    nat i = u.filera();
    nat j = u.placa();
    nat k = u.pis();

    if (u >= uMinim and u < uMaxim) {
        m = _t[i][j][k];
    } else {
        throw error(NumFileresIncorr);
    }
}

/* Retorna el nombre de places de la terminal que en aquest instant
   només hi cabrien un contenidor de 10 peus, però no un de més llarg.
   Per exemple, la filera de la figura 1 de l'enunciat contribuirà amb
   7 unitats a la fragmentació total (corresponen a les ubicacions
   <f, 0, 1>, <f, 1, 2>, <f, 2, 1>, <f, 7, 1>, <f, 8, 0>, <f, 9, 1> i
   <f, 10, 0>). */
nat terminal::fragmentacio() const throw() {
  nat f = 0;
  bool desnivell = true;
  for(nat i = 0; i < _n; ++i) {
  	for(nat j = 0; j < _m; ++j) {
  		if(j == _m-1) {
  			if(desnivell) ++f;
  		}
  		else if(desnivell) {
  			if(_p[i][j] == _p[i][j+1]) desnivell = false;
  			else ++f;
    		}
    		else {
    			if(_p[i][j] != _p[i][j+1]) desnivell = true;
    		}
  	}
  	desnivell = true;
  }
  return f;

  return 1;
}

/* Retorna el número d'operacions de grua realitzades des del moment
   de creació de la terminal.
   Es requereix d'una operació de grua per moure un contenidor
   des de l'àrea d'espera a l'àrea d'emmagatzematge o viceversa.
   També es requereix d'una operació de grua per inserir o
   retirar directament un contenidor de l'àrea d'emmagatzematge.
   En canvi no requereix cap operació de grua inserir o
   retirar directament un contenidor de l'àrea d'espera. */
nat terminal::ops_grua() const throw() {
  return _opsGrua;
}

/* Retorna la llista de les matrícules de tots els contenidors
   de l'àrea d'espera de la terminal, en ordre alfabètic creixent. */
void terminal::area_espera(list<string> &l) const throw() {
    list<contenidor>::const_iterator it;
    for (it = _areaEspera.begin(); it != _areaEspera.end(); ++it)
        l.push_back((*it).matricula());

    l.sort();

    if (l == l) throw error(MatriculaDuplicada);
}

/* Retorna el número de fileres de la terminal. */
nat terminal::num_fileres() const throw() {
  return _n;
}

/* Retorna el número de places per filera de la terminal. */
nat terminal::num_places() const throw() {
  return _m;
}

/* Retorna l'alçada màxima d'apilament de la terminal. */
nat terminal::num_pisos() const throw() {
  return _h;
}

/* Retorna l'estratègia d'inserció i retirada de contenidors de la terminal. */
terminal::estrategia terminal::quina_estrategia() const throw() {
  return _st;
}
