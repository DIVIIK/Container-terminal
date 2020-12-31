template <typename Valor>
typename cataleg<Valor>::node* cataleg<Valor>::copia_nodes(	node* n) {
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
    esborra_nodes(n->_esq);
    esborra_nodes(n->_dret);
    delete n;
  }
}

template <typename Valor>
typename cataleg<Valor>::node* cataleg<Valor>::rota_ee(node* n) {
    node* aux;
    aux = n->_esq;
    n->_esq = aux->_dret;
    aux->_dret = n;
    return aux;
}

template <typename Valor>
typename cataleg<Valor>::node* cataleg<Valor>::rota_dd(node* n) {
    node* aux;
    aux = n->_dret;
    n->_dret = aux->_esq;
    aux->_esq = n;
    return aux;
}

template <typename Valor>
typename cataleg<Valor>::node* cataleg<Valor>::rota_ed(node* n) {
    node* aux;
    aux = n->_esq;
    n->_esq = rota_dd(aux);
    return rota_ee(n);
}

template <typename Valor>
typename cataleg<Valor>::node* cataleg<Valor>::rota_de(node* n) {
    node* aux;
    aux = n->_dret;
    n->_dret = rota_ee(aux);
    return rota_dd(n);
}

template <typename Valor>
typename cataleg<Valor>::node* cataleg<Valor>::assig_avl(string k, Valor v, node* n) {
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
    n->_dret = assig_avl(k, v, n->_dret);
    n = balancejar(n);
  } return n;
}

template <typename Valor>
typename cataleg<Valor>::node* cataleg<Valor>::balancejar(node *n) {
    int fact = factor(n);
    if (fact > 1) {
      if (factor(n->_esq) > 0)
        n = rota_ee(n);
      else
         n = rota_ed(n);
    } else if (fact < -1) {
      if (factor(n->_dret) > 0)
         n = rota_de(n);
      else
         n = rota_dd(n);
    }
    return n;
}

template <typename Valor>
int cataleg<Valor>::factor(node* n) {
    return altura(n->_esq) - altura(n->_dret);
}

template <typename Valor>
int cataleg<Valor>::altura(node* n) {
    nat valorAltura = 0;

    if (n)
        valorAltura = std::max(altura(n->_esq), altura(n->_dret)) + 1;

    return valorAltura;
}

template <typename Valor>
typename cataleg<Valor>::node* cataleg<Valor>::existeix_avl(node *n, const string &k) {
	if(n == NULL or n->_k == k) {
		return n;
	}
	else {
		if(k < n->_k) {
			return existeix_avl(n->_esq, k);
		}
		else {
			return existeix_avl(n->_dret, k);
		}
	}
}

template <typename Valor>
typename cataleg<Valor>::node* cataleg<Valor>::elimina_maxim(node *n) {
	node *n_orig = n, *pare = NULL;
	while(n->_dret != NULL) {
		pare = n;
		n = n->_dret;
	}
	if(pare != NULL) {
		pare->_dret = n->_esq;
		n->_esq = n_orig;
	}
	return n;
}

template <typename Valor>
typename cataleg<Valor>::node* cataleg<Valor>::ajunta(node *n1, node *n2) {
	if(n1 == NULL) return n2;
	if(n2 == NULL) return n1;
	node *p = elimina_maxim(n1);
	p->_dret = n2;
	return p;
}

template <typename Valor>
typename cataleg<Valor>::node* cataleg<Valor>::elimina_avl(const string &k, node *n) {
	node *p = n;
	if(n == NULL) throw error(ClauInexistent);
	else if(k < n->_k) {
		n->_esq = elimina_avl(k, n->_esq);
        if (n)
		      n = balancejar(n);
	}
	else if(k > n->_k) {
		n->_dret = elimina_avl(k, n->_dret);
        if (n)
		      n = balancejar(n);
	}
	else {
		n = ajunta(n->_esq, n->_dret);
        if (n)
		      n = balancejar(n);
        --_nElements;
		delete(p);
	}
	return n;
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
  _arrel = NULL;
  _maxElements = numelems;
  _nElements = 0;
}
/* Constructora per còpia, assignació i destructora. */
template <typename Valor>
cataleg<Valor>::cataleg(const cataleg<Valor>& c) throw(error) {
  _arrel = copia_nodes(c._arrel);
  _nElements = c._nElements;
  _maxElements = c._maxElements;
}
template <typename Valor>
cataleg<Valor>& cataleg<Valor>::operator=(const cataleg<Valor>& c) throw(error) {
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
    _arrel = assig_avl(k, v, _arrel);
}
/* Elimina del catàleg el parell que té com a clau k.
    En cas que la clau k no existeixi en el catàleg genera un error. */
template <typename Valor>
void cataleg<Valor>::elimina(const string &k) throw(error) {
  _arrel = elimina_avl(k, _arrel);
}

/* Retorna true si i només si la clau k existeix dins del catàleg; false
   en cas contrari. */
template <typename Valor>
bool cataleg<Valor>::existeix(const string &k) const throw() {
  bool trobat;
  node *n = existeix_avl(_arrel, k);
  if(n == NULL) {
    trobat = false;
  }
  else {
    trobat = true;
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
   node *n = _arrel;
   while(n != NULL and n->_k != k) {
     if(n->_k < k) {
       n = n->_dret;
     }
     else if(n->_k > k) {
       n = n->_esq;
     }
   }
   if(n == NULL) throw error(ClauInexistent);
   return n->_v;
  }

/* Retorna el nombre d'elements que s'han inserit en el catàleg
   fins aquest moment. */
template <typename Valor>
nat cataleg<Valor>::quants() const throw() {
    return _nElements;
}
