from constraintsearch import *

region = ['A', 'B', 'C', 'D', 'E']
colors = ['red', 'blue', 'green', 'yellow', 'white']

mapaA = {
        "A": "BDE",
        "B": "ACE",
        "C": "BDE",
        "D": "ACE",
        "E": "ABCD"
        }
    
def mapa_constraint(r1,c1,r2,c2):
    return c1 != c2

def make_constraint_graph(mapa):
    return { (X,Y): mapa_constraint for X in mapa for Y in mapa[X] if X!=Y }

def make_domains(region, colors):
    return { r:colors for r in region }

cs = ConstraintSearch(make_domains(mapaA, colors), make_constraint_graph(mapaA))


print(cs.search())
