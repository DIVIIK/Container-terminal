/****************************************************/
/*                                                  */
/*                  METODES PRIVATS                 */
/*                                                  */
/****************************************************/

// Funcio de dispersió
// Cost: Lineal respecte a la longitud de k
template <typename Valor>
int cataleg<Valor>::hash(const string &k) const {
	int x = 0;
    for (nat i = 0 ; i < k.length() ; i++)  {
        x = x + k[i] * i;
    }
    return x % _M;
}

// Funcio que rep un node de la taula i retorna una copia amb tots els seus encadenaments.
// Cost lineal respecte al numero de nodes encadenats
template <typename Valor>
typename cataleg<Valor>::node* cataleg<Valor>::copia_nodes(const node* n) {
    node* aux = NULL;
    if (n) {
        aux = new node(n->_k, n->_v, copia_nodes(n->_seg));
    }
    return aux;
}

// Esborra tots els nodes encadenats de la taula n
// Cost mig: lineal en funcio del tamany si no hi han col·lisions.
template <typename Valor>
void cataleg<Valor>::esborra_nodes(node** n, const nat tamany) {
    node *m;
    node *aux;
    for (nat i = 0 ; i < tamany ; ++i) {
        m = n[i];
        while (m != NULL) {
            aux = m->_seg;
            delete m;
            m = aux;
        }
    }
}

// Funcio que comproba si cal redispersionar la taula
// En cas de que sigui necesari, la fa creixer o decreixer
// I recoloca els elements a la nova taula
// Cost mig: Θ(1)
// Cost pitjor: Cost lineal respecte a _M (Si es fa la redispersio)
template <typename Valor>
void cataleg<Valor>::redispersio() {

    // Mirem si cal redispersionar. Factor ideal: 0.75
    double factor = 0;

    // Per sota de 11 elements no volem fer redispersions
    // Aquest valor es decisio propia, pot ser cualsevol
    if (_quants > 11) {
        double factorCarrega = (double) _quants / (double) _M;
        if (factorCarrega > 0.95)
            factor = 2;
        else if (factorCarrega < 0.4)
            factor = 0.5;
    }

    if (factor != 0) {
        nat nova_size = segPrim(factor * _M);
        node* n;
        node* p;
        node** nova_taula = new node*[nova_size];

        for (nat j = 0 ; j < nova_size; ++j) {
            nova_taula[j] = NULL;
        }

        // Reinsertem els valors de la antiga a la nova taula
        nat tamanyAnt = _M;
        _M = nova_size;
        for (nat i = 0 ; i < tamanyAnt ; ++i) {
            p = _taula[i];
            while (p != NULL) {
                int k = hash(p->_k);
                n = nova_taula[k];
                nova_taula[k] = new node(p->_k, p->_v, n);
                p = p->_seg;
            }
        }
        esborra_nodes(_taula, tamanyAnt);
        delete[] _taula;
        _taula = nova_taula;
    }
}

// Indica si n es un numero prim o no
// Cost mig: lineal en funcio de n
template <typename Valor>
bool cataleg<Valor>::esPrim(const int n) const {
    if (n <= 1)  return false;
    if (n <= 3)  return true;

    if (n%2 == 0 || n%3 == 0) return false;

    for (int i=5 ; i * i <= n ; i=i+6)
        if (n%i == 0 || n%(i+2) == 0)
           return false;

    return true;
}

// Retorna el seguent numero prim
// Cost mig: lineal en funcio de n
template <typename Valor>
int cataleg<Valor>::segPrim(const int N) const {
    int prim = N;
    bool trobat = false;
    while (!trobat) {
        prim++;
        if (esPrim(prim))
            trobat = true;
    }
    return prim;
}

/****************************************************/
/*                                                  */
/*            METODES PUBLICS DE CLASSE             */
/*                                                  */
/****************************************************/

/* Constructora. Crea un catàleg buit on numelems és el nombre
   aproximat d'elements que com a màxim s'inseriran al catàleg. */
// Cost: lineal respecte a _M
template <typename Valor>
cataleg<Valor>::cataleg(nat numelems) throw(error) : _quants(0) {
    if (!numelems%2) numelems++;

    if(!esPrim(numelems))
        _M = segPrim(numelems);
    else
        _M = numelems;
    _taula = new node*[_M];

    for(nat i = 0; i<_M; ++i)
        _taula[i] = NULL;
}

// Constructor de node
// Cost: Θ(1)
template <typename Valor>
cataleg<Valor>::node::node(const string &k, const Valor &v, node* seg) : _k(k), _v(v), _seg(seg) { }

/* Constructora per còpia, assignació i destructora. */
// Cost mig: lineal respecte a _M  si no hi han col·lisions.
template <typename Valor>
cataleg<Valor>::cataleg(const cataleg& c) throw(error) {
    _taula = new node*[c._M];

    for (nat i = 0; i < c._M; ++i)
        _taula[i] = copia_nodes(c._taula[i]);

    _M = c._M;
    _quants = c._quants;
 }

// Cost mig: lineal en funcio del tamany (_M) si no hi han col·lisions.
template <typename Valor>
cataleg<Valor>& cataleg<Valor>::operator=(const cataleg& c) throw(error) {
    if (this != &c) {
        cataleg aux(c);
        esborra_nodes(_taula, _M);
        _taula = aux._taula;
        _quants = aux._quants;
        _M = aux._M;
    }
    return *this;
}

// Cost mig: lineal en funcio del tamany (_M) si no hi han col·lisions.
template <typename Valor>
cataleg<Valor>::~cataleg() throw() {
    esborra_nodes(_taula, _M);
    delete[] _taula;
}

/* Mètode modificador. Insereix el parell <clau, valor> indicat.
   En cas que la clau k ja existeixi en el catàleg actualitza el valor
   associat. Genera un error en cas que la clau sigui l'string buit. */
// Cost mig: Θ(1)
// Cost pitjor: Cost lineal respecte a _M (Si es fa la redispersio)
template <typename Valor>
void cataleg<Valor>::assig(const string &k, const Valor &v) throw(error) {
    int i = hash(k);
    node* p = _taula[i];
    bool trobat = false;
    while (p != NULL and not trobat) {
        if (p->_k == k)
            trobat = true;
        else
            p = p->_seg;
    }
    if (trobat) {
        // Només canviem el valor associat
        p->_v = v;
    } else {
        // Cal crear un nou node i l'afegim al principi
        _taula[i] = new node(k,v,_taula[i]);
        ++_quants;
    }

    // Redispersiona si es que cal
    redispersio();
}

/* Elimina del catàleg el parell que té com a clau k.
    En cas que la clau k no existeixi en el catàleg genera un error. */
// Cost mig: Θ(1)
// Cost pitjor: Cost lineal respecte a _M (Si es fa la redispersio)
template <typename Valor>
void cataleg<Valor>::elimina(const string &k) throw(error) {
    nat i = hash(k);
    node *p = _taula[i];
    node *ant = NULL;
    bool trobat = false;

    while (p != NULL and not trobat) {
        if (p->_k == k) {
            trobat = true;
        }
        else {
            ant = p;
            p = p->_seg;
        }
    }
    if (trobat) {
        if (ant == NULL) {
            _taula[i] = p->_seg; // Era el primer
        }
        else {
            ant->_seg = p->_seg;
        }
        delete(p);
        --_quants;
    } else
        throw error(ClauInexistent);

    // Redispersiona si es que cal
    redispersio();
}

/* Retorna true si i només si la clau k existeix dins del catàleg; false
   en cas contrari. */
// Cost mig: Θ(1)
template <typename Valor>
bool cataleg<Valor>::existeix(const string &k) const throw() {
    int i = hash(k);
    node* p = _taula[i];
    bool trobat = false;

    while (p != NULL and not trobat) {
        if (p->_k == k)
            trobat = true;
        else
            p = p->_seg;
    }

    return trobat;
}

/* Retorna el valor associat a la clau k; si no existeix cap parell amb
   clau k llavors genera un error. Exemple:
     cataleg<int> ct;
     ...
     int n = ct["dia"]; */
// Cost mig: Θ(1)
template <typename Valor>
Valor cataleg<Valor>::operator[](const string &k) const throw(error) {
    int i = hash(k);
    node* p = _taula[i];
    bool trobat = false;

    while (p != NULL and not trobat) {
        if (p->_k == k)
            trobat = true;
        else
            p = p->_seg;
    }

    if (not trobat)
        throw error(ClauInexistent);

    return p->_v;
}

/* Retorna el nombre d'elements que s'han inserit en el catàleg
   fins aquest moment. */
// Cost: Θ(1)
template <typename Valor>
nat cataleg<Valor>::quants() const throw() {
    return _quants;
}
