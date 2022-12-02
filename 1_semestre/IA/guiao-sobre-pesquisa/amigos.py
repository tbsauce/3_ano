from constraintsearch import *

amigos = ["Andre", "Bernardo", "Claudio"]

def amigo_constraint(a1,t1,a2,t2):

    b1, c1 = t1
    b2, c2 = t2

    if b1==b2 or c1==c2:
        return False

    if a1 == b1 or a2 == b2 or a1 == c1 or a2 == c2:
        return False

    if(b1 == c1 or b2 == c2):
        return False
    if(c1 == "claudio" and b1 != "bernardo" or c2 == "claudio" and b2 != "bernardo"):
        return False
        
    return True

def make_constraint_graph(mapa):
    return { (X,Y): amigo_constraint for X in mapa for Y in mapa[X] if X!=Y }
    
def make_domains(amigos):
    return {amigo: [(chapeu,bicicleta) for chapeu in amigos for bicicleta in amigos] for amigo in amigos }

cs = ConstraintSearch(None, None)

print(cs.search())
