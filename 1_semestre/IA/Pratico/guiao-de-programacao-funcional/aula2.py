
#Exercicio 4.1
impar = lambda x: x%2 != 0

#Exercicio 4.2
positivo = lambda x: x > 0

#Exercicio 4.3
comparar_modulo = lambda x, y: abs(x)< abs(y)

#Exercicio 4.4
import math
cart2pol = lambda x, y: (math.sqrt(x*x + y*y), math.atan2(y, x))

#Exercicio 4.5
ex5 = lambda f, g, h: lambda x, y, z: h(f (x, y), g(y, z))

#Exercicio 4.6
def quantificador_universal(lista, f):
    return [e for e in lista if not f(e)] == []

#Exercicio 4.9
def ordem(lista, f):
    if(len(lista) == 1):
        return lista[0]
    
    m = ordem(lista[1:], f)

    return lista[0] if f(lista[0], m) else m
    
#Exercicio 4.10
def filtrar_ordem(lista, f):
    if(lista == []):
        return 0, []
    s1, s2 = filtrar_ordem(lista[1:], f)
    if(f(lista[0], s1)):
        return lista[0], s2
    
    return s1, [lista[0]] + s2

#Exercicio 5.2
def ordenar_seleccao(lista, ordem):
    pass
    
