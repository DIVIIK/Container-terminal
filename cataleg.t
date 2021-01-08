template <typename Valor>
typename cataleg<Valor>::node* cataleg<Valor>::copia_nodes(node* n) { // Cost lineal respecte al numero de nodes encadenats
    node* aux = NULL;
    if(n) {
      aux = new node(n->_k,n->_v,copia_nodes(n->_seg));
      // aux->_v = n->_v;
      // aux->_k = n->_k;
      // aux->_seg = copia_nodes(n->_seg);
    }
    return aux;
}

template <typename Valor>
void cataleg<Valor>::esborra_nodes(node** n) {
    node *m;
    node *aux;
    for (nat i = 0; i < _M; ++i) {
        m = n[i];
        while (m != NULL) {
            aux = m->_seg;
            delete m;
            m = aux;
        }
    }
}

template <typename Valor>
cataleg<Valor>::node::node(const string &k, const Valor &v, node* seg) : _k(k), _v(v), _seg(seg) { }

template <typename Valor>
bool cataleg<Valor>::esPrim(int n) {
    if (n <= 1)  return false;
    if (n <= 3)  return true;

    if (n%2 == 0 || n%3 == 0) return false;

    for (int i=5; i*i<=n; i=i+6)
        if (n%i == 0 || n%(i+2) == 0)
           return false;

    return true;
}

// Retorna el seguent numero prim
template <typename Valor>
int cataleg<Valor>::segPrim(int N) {
    int prim = N;
    bool trobat = false;
    while (!trobat) {
        prim++;
        if (esPrim(prim))
            trobat = true;
    }
    return prim;
}

// // Funcio que redispersiona la taula.
// void cataleg<Valor>::redispersio() { // Cost lineal respecte a _M
//     // Calcular factor de carrega
//     double factorCarrega = (double) _quants/ (double) _M;
//
//     // Mirem si cal redispersionar i si es de quina forma. Factor ideal: 0.75
//     double factor = 0;
//
//     if (_quants > 31) { // Valor minim de taula es 31
//     if (factorCarrega > 0.95)
//         factor = 2;
//     else if (factorCarrega < 0.4)
//         factor = 0.5;
//     }
//
//     if (factor) {  //factor != 0
//         nat nova_size = factor*_M; // seria primo
//         node *n;
//         node* p;
//         node ** nova_taula = new node*[nova_size];
//         for(nat j = 0; j<nova_size; ++j) nova_taula[j] = NULL;
//
//         // Reinsertem els valors de la antiga a la nova taula
//         for(nat i = 0; i<_M; ++i) {
//             p = _taula[i];
//             while(p!=NULL) {
//                 nat k = hash(p->_v.numero()) % nova_size; //Calculem les noves posicions
//                 n = nova_taula[k];
//                 nova_taula[k] = new node(p->_v.numero(),p->_v,n);
//                 p = p->_seg;
//             }
//         }
//         esborra_nodes(_taula, _M);
//         delete[] _taula;
//         _taula = nova_taula;
//         _M = nova_size;
//     }
// }


//
//
//      METODES PUBLICS
//
//

/* Constructora. Crea un catàleg buit on numelems és el nombre
   aproximat d'elements que com a màxim s'inseriran al catàleg. */
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

/* Constructora per còpia, assignació i destructora. */
template <typename Valor>
cataleg<Valor>::cataleg(const cataleg& c) throw(error) {
    _taula = new node*[c._M];

    for (nat i = 0; i < c._M; ++i)
        _taula[i] = copia_nodes(c._taula[i]);

    _M = c._M;
    _quants = c._quants;
 }

template <typename Valor>
cataleg<Valor>& cataleg<Valor>::operator=(const cataleg& c) throw(error) {
    if (this != &c) {
        cataleg aux(c);
        esborra_nodes(_taula);
        _taula = aux._taula;
        _quants = aux._quants;
        _M = aux._M;
    }
    return *this;
}

template <typename Valor>
cataleg<Valor>::~cataleg() throw() {
    esborra_nodes(_taula);
    delete[] _taula;
}

/* Mètode modificador. Insereix el parell <clau, valor> indicat.
   En cas que la clau k ja existeixi en el catàleg actualitza el valor
   associat. Genera un error en cas que la clau sigui l'string buit. */
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
}

/* Elimina del catàleg el parell que té com a clau k.
    En cas que la clau k no existeixi en el catàleg genera un error. */
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
    }
}

/* Retorna true si i només si la clau k existeix dins del catàleg; false
   en cas contrari. */
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
template <typename Valor>
nat cataleg<Valor>::quants() const throw() {
    return _quants;
}
