template <typename Valor>
typename cataleg<Valor>::node* cataleg<Valor>::copia_nodes(node* n) {
    node* aux = NULL;
    if (n != NULL) {
        aux = new node;
        try {
            aux -> _k = n -> _k;
            aux -> _v = n -> _v;
            aux -> _esq = copia_nodes(n -> _esq);
            aux -> _dret = copia_nodes(n -> _dret);
        }
        catch (...) {
            delete n;
            throw;
        }
    }
    return aux;
}

template <typename Valor>
void cataleg<Valor>::esborra_nodes(node* n) {
  if (n != NULL) {
    esborra_nodes(n->f_esq);
    esborra_nodes(n->f_dret);
    delete n;
  }
}

template <typename Valor>
typename cataleg<Valor>::node* cataleg<Valor>::assig_avl(string k, string v, node* n) {
  if (n == NULL) {
      n = new node;
      n->_v = v;
      n->_k = k;
      n->_esq = NULL;
      n->_dret = NULL;
      _nElements++;
      return n;
  } else if (k < n->_k) {
    n->_esq = assig_avl(k, v, n->_esq);
    n = balancejar(n);
  } else if (k > n->_k) {
    n->_dret = assig_avl(k, v, r->_dret);
    n = balancejar(n);
  } return n;
}

/* Constructora. Crea un catàleg buit on numelems és el nombre
   aproximat d'elements que com a màxim s'inseriran al catàleg. */
template <typename Valor>
cataleg<Valor>::cataleg(nat numelems) throw(error) {
  _arrel = NULL;
  _maxElements = numelems;
  _nElements = 0;
}

/* Constructora per còpia, assignació i destructora. */
template <typename Valor>
cataleg<Valor>::cataleg(const cataleg& c) throw(error) {
  _arrel = copia_nodes(c);
  _nElements = c._nElements;
  _maxElements = c._maxElements;
}

template <typename Valor>
cataleg<Valor>& cataleg<Valor>::operator=(const cataleg& c) throw(error) {
    if (this != &c) {
      node* aux;
      aux = copia_nodes(c._arrel);
      esborra_nodes(_arrel);
      _arrel = aux;
      _nElements = c._nElements;
      _maxElements = c._maxElements;
    }
    return (*this);
}

template <typename Valor>
cataleg<Valor>::~cataleg() throw() {
  esborra_nodes(_arrel);
}

/* Mètode modificador. Insereix el parell <clau, valor> indicat.
   En cas que la clau k ja existeixi en el catàleg actualitza el valor
   associat. Genera un error en cas que la clau sigui l'string buit. */
template <typename Valor>
void cataleg<Valor>::assig(const string &k, const Valor &v) throw(error) {
    _arrel = assig_avl(k,v_arrel);
}

/* Elimina del catàleg el parell que té com a clau k.
    En cas que la clau k no existeixi en el catàleg genera un error. */
template <typename Valor>
void cataleg<Valor>::elimina(const string &k) throw(error) {

}

/* Retorna true si i només si la clau k existeix dins del catàleg; false
   en cas contrari. */
template <typename Valor>
bool cataleg<Valor>::existeix(const string &k) const throw() {
    return true;
}

/* Retorna el valor associat a la clau k; si no existeix cap parell amb
   clau k llavors genera un error. Exemple:
     cataleg<int> ct;
     ...
     int n = ct["dia"]; */
template <typename Valor>
Valor cataleg<Valor>::operator[](const string &k) const throw(error) {
    return null;
}

/* Retorna el nombre d'elements que s'han inserit en el catàleg
   fins aquest moment. */
template <typename Valor>
nat cataleg<Valor>::quants() const throw() {
    return _nElements;
}
