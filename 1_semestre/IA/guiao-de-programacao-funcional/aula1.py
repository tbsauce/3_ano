
#Exercicio 1.1
def comprimento(lista):
	if(lista==[]):
		return 0
	return 1 + comprimento(lista[1:])

#Exercicio 1.2
def soma(lista):
	if(lista==[]):
		return 0
	return lista[0] + soma(lista[1:])

#Exercicio 1.3
def existe(lista, elem):
	if(lista == []):
		return False
	return (lista[0] == elem) or existe(lista[1:], elem)

#Exercicio 1.4
def concat(l1, l2):
	if (l2 == []):	
		return l1
	return concat(l1 + [l2[0]], l2[1:])
	

#Exercicio 1.5
def inverte(lista):
	if(lista ==[]):
		return []
	return [lista[-1]] + inverte(lista[:-1])

#Exercicio 1.6
def capicua(lista):
	if(lista == []):
		return True
	return (lista[0] == lista[-1]) and capicua(lista[1:-1])

#Exercicio 1.7
def concat_listas(lista):
	if(lista== []):
		return []
	return lista[0] + concat_listas(lista[1:])


#Exercicio 1.8
def substitui(lista, original, novo):
	if(lista == []):
		return  []
	if(lista[0] == original):
		lista[0] = novo
	return [lista[0]] + substitui(lista[1:], original , novo) 


#Exercicio 1.9 	
def fusao_ordenada(lista1, lista2):
	if(lista1 == []):
		return lista2
	if(lista2 == []):
		return lista1
	if(lista1[0] < lista2[0]):
		return [lista1[0]] + fusao_ordenada(lista1[1:],lista2)
	return [lista2[0]] + fusao_ordenada(lista1,lista2[1:]) 

#Exercicio 1.10
def lista_subconjuntos(lista):
	pass


#Exercicio 2.1
def separar(lista):
	if(lista == []):
		return [],[]

	x, y =lista[0]
	
	s1, s2 = separar(lista[1:])
	return [x]+s1, [y]+s2

#Exercicio 2.2
def remove_e_conta(lista, elem):
	if(lista == []):
		return [],0
	
	s1, s2 = remove_e_conta(lista[1:], elem)
	
	if(lista[0] == elem):
		return s1, s2+1
	return [lista[0]] + s1, s2

#Exercicio 3.1
def cabeca(lista):
	if(lista == []):
		return None
	return lista[0]
	
#Exercicio 3.2
def cauda(lista):
	if(lista == []):
		return None
	return lista[1:]

#Exercicio 3.3
def juntar(l1, l2):
	if(len(l1) != len(l2)):
		return None
	if(l1 == [] or l2 == []):
		return []

	return [(l1[0], l2[0])] + juntar(l1[1:], l2[1:])

#Exercicio 3.4
def menor(lista):
	if(lista == []):
		return None

	m = menor(lista[1:])

	if(len(lista) == 1):
		return lista[0]

	return m if m < lista[0] else lista[0]


#Exercicio 3.6
def max_min(lista):
	pass
