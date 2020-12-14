// #include <algorithm>    // std::max

template <typename Valor>
typename cataleg<Valor>::node* cataleg<Valor>::copia_nodes(hash_node* n) { // Cost lineal respecte al numero de nodes encadenats
    hash_node* aux = NULL;
    if(n) {
      aux = new hash_node(n->_k,n->_v,copia_nodes(n->_seg));
      // aux->_v = n->_v;
      // aux->_k = n->_k;
      // aux->_seg = copia_nodes(n->_seg);
    }
    return aux;
}

template <typename Valor>
void cataleg<Valor>::esborra_nodes(node* n) {
  if (n != NULL) {
    esborra_nodes(n->_esq);
    esborra_nodes(n->_dret);
    delete n;
  }
}


//
//
//      METODES PUBLICS
//
//

/* Constructora. Crea un catàleg buit on numelems és el nombre
   aproximat d'elements que com a màxim s'inseriran al catàleg. */
template <typename Valor>
cataleg<Valor>::cataleg(nat numelems) throw(error) {
  // _arrel = NULL;
  // _maxElements = numelems;
  // _nElements = 0;

  _M = 67; // Hem escollit un numero prim, ja que funcionen millor a l'hora de dispersar.
 _taula = new node*[_M];
 for(nat i = 0; i<_M; ++i)
   _taula[i] = NULL;
 _quants = 0;
}

/* Constructora per còpia, assignació i destructora. */
template <typename Valor>
cataleg<Valor>::cataleg(const cataleg& c) throw(error) {
  // _arrel = copia_nodes(c._arrel);
  // _nElements = c._nElements;
  // _maxElements = c._maxElements;
}

template <typename Valor>
cataleg<Valor>& cataleg<Valor>::operator=(const cataleg& c) throw(error) {
    // if (this != &c) {
    //   node* aux;
    //   aux = copia_nodes(c._arrel);
    //   esborra_nodes(_arrel);
    //   _arrel = aux;
    //   _nElements = c._nElements;
    //   _maxElements = c._maxElements;
    // }
    // return (*this);
}

template <typename Valor>
cataleg<Valor>::~cataleg() throw() {
  // esborra_nodes(_arrel);
}

/* Mètode modificador. Insereix el parell <clau, valor> indicat.
   En cas que la clau k ja existeixi en el catàleg actualitza el valor
   associat. Genera un error en cas que la clau sigui l'string buit. */
template <typename Valor>
void cataleg<Valor>::assig(const string &k, const Valor &v) throw(error) {
    // _arrel = assig_avl(k, v, _arrel);
}

/* Elimina del catàleg el parell que té com a clau k.
    En cas que la clau k no existeixi en el catàleg genera un error. */
template <typename Valor>
void cataleg<Valor>::elimina(const string &k) throw(error) {
  // _arrel = elimina_avl(k, _arrel);
}

/* Retorna true si i només si la clau k existeix dins del catàleg; false
   en cas contrari. */
template <typename Valor>
bool cataleg<Valor>::existeix(const string &k) const throw() {
  // bool trobat;
  // node *n = existeix_avl(_arrel, k);
  // if(n == NULL) {
  //   trobat = false;
  // }
  // else {
  //   trobat = true;
  // }
  // return trobat;
}

/* Retorna el valor associat a la clau k; si no existeix cap parell amb
   clau k llavors genera un error. Exemple:
     cataleg<int> ct;
     ...
     int n = ct["dia"]; */
 template <typename Valor>
 Valor cataleg<Valor>::operator[](const string &k) const throw(error) {
   // node *n = _arrel;
   // while(n != NULL and n->_k != k) {
   //   if(n->_k < k) {
   //     n = n->_dret;
   //   }
   //   else if(n->_k > k) {
   //     n = n->_esq;
   //   }
   // }
   // if(n == NULL) throw error(ClauInexistent);
   // return n->_v;
  }

/* Retorna el nombre d'elements que s'han inserit en el catàleg
   fins aquest moment. */
template <typename Valor>
nat cataleg<Valor>::quants() const throw() {
    return _nElements;
}
