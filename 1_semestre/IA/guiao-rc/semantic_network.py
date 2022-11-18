

# Guiao de representacao do conhecimento
# -- Redes semanticas
# 
# Inteligencia Artificial & Introducao a Inteligencia Artificial
# DETI / UA
#
# (c) Luis Seabra Lopes, 2012-2020
# v1.9 - 2019/10/20
#


# Classe Relation, com as seguintes classes derivadas:
#     - Association - uma associacao generica entre duas entidades
#     - Subtype     - uma relacao de subtipo entre dois tipos
#     - Member      - uma relacao de pertenca de uma instancia a um tipo
#

from curses.ascii import isalpha
from threading import local
from pkg_resources import declare_namespace
from collections import Counter

class Relation:
    def __init__(self,e1,rel,e2):
        self.entity1 = e1
#       self.relation = rel  # obsoleto
        self.name = rel
        self.entity2 = e2
    def __str__(self):
        return self.name + "(" + str(self.entity1) + "," + \
               str(self.entity2) + ")"
    def __repr__(self):
        return str(self)


# Subclasse Association
class Association(Relation):
    def __init__(self,e1,assoc,e2):
        Relation.__init__(self,e1,assoc,e2)

#   Exemplo:
#   a = Association('socrates','professor','filosofia')

# Subclasse Subtype
class Subtype(Relation):
    def __init__(self,sub,super):
        Relation.__init__(self,sub,"subtype",super)


#   Exemplo:
#   s = Subtype('homem','mamifero')

# Subclasse Member
class Member(Relation):
    def __init__(self,obj,type):
        Relation.__init__(self,obj,"member",type)

#   Exemplo:
#   m = Member('socrates','homem')

# classe Declaration
# -- associa um utilizador a uma relacao por si inserida
#    na rede semantica
#
class Declaration:
    def __init__(self,user,rel):
        self.user = user
        self.relation = rel
    def __str__(self):
        return "decl("+str(self.user)+","+str(self.relation)+")"
    def __repr__(self):
        return str(self)

#   Exemplos:
#   da = Declaration('descartes',a)
#   ds = Declaration('darwin',s)
#   dm = Declaration('descartes',m)

# classe SemanticNetwork
# -- composta por um conjunto de declaracoes
#    armazenado na forma de uma lista
#
class SemanticNetwork:
    def __init__(self,ldecl=None):
        self.declarations = [] if ldecl==None else ldecl
    def __str__(self):
        return str(self.declarations)
    def insert(self,decl):
        self.declarations.append(decl)
    def query_local(self,user=None,e1=None,rel=None,e2=None):
        self.query_result = \
            [ d for d in self.declarations
                if  (user == None or d.user==user)
                and (e1 == None or d.relation.entity1 == e1)
                and (rel == None or d.relation.name == rel)
                and (e2 == None or d.relation.entity2 == e2) ]
        return self.query_result
    def show_query_result(self):
        for d in self.query_result:
            print(str(d))
    
    def list_associations(self):
        return list(set([a.relation.name for a in self.declarations if(isinstance(a.relation, Association))]))

    def list_objects(self):
        return list(set([a.relation.entity1 for a in self.declarations if(isinstance(a.relation, Member))]))

    def list_users(self):
        return list(set([a.user for a in self.declarations]))

    def list_types(self):
        return list(set([a.relation.entity2 for a in self.declarations if(not isinstance(a.relation, Association))]))

    def list_local_associations(self, ass):
        return list(set([a.relation.name for a in self.declarations if(isinstance(a.relation, Association) and a.relation.entity1 == ass)]))

    def list_relations_by_user(self, user):
        return list(set([a.relation.name for a in self.declarations if(a.user == user)]))

    def associations_by_user(self, user):
        return len(set([a.relation.name for a in self.declarations if(a.user==user and isinstance(a.relation , Association))]))

    def list_local_associations_by_entity(self, ent):
        return list(set([(d.relation.name, d.user) for d in self.declarations if (d.relation.entity1 == ent or d.relation.entity2 == ent) and isinstance(d.relation, Association) ]))
        
    def predecessor(self, A, B):
        list =[ d.relation.entity2 for d in self.declarations if (isinstance(d.relation, Member) or isinstance(d.relation, Subtype)) and (d.relation.entity1 == B) ]

        if A in list:
            return True
        
        return any([self.predecessor(A, p) for p in list])

    def predecessor_path(self, A, B):
        list =[ d.relation.entity2 for d in self.declarations if (isinstance(d.relation, Member) or isinstance(d.relation, Subtype)) and (d.relation.entity1 == B) and (self.predecessor(A, d.relation.entity2))  ]

        if list == []:
            return [A]+[B] 
        
        return self.predecessor_path(A, str(list[0])) + [B]

    def query (self, entity, assoc = None):
        lst = [decl for decl in self.declarations if(decl.relation.entity1 == entity and (assoc == None or decl.relation.name == assoc) and not isinstance(decl.relation, Member) and not isinstance(decl.relation, Subtype))]

        lstent = [decl.relation.entity2 for decl in self.declarations if(decl.relation.entity1 == entity and (isinstance(decl.relation, Member) or isinstance(decl.relation, Subtype)))]

        if lstent == []:
            return []
        else:
            cumul = []
            for l in lstent:
                cumul = cumul + self.query(l , assoc)
            return lst + cumul

    def query2(self, entity, rel = None):    
        local_lst = [d for d in self.declarations if(d.relation.entity1 == entity and (isinstance(d.relation, Member) or isinstance(d.relation, Subtype)))]
        inhert_list = self.query(entity,rel)
        return inhert_list + local_lst

    def query_cancel():
        pass
    def query_down(self, e, assoc):
        lst_kids = [decl.relation for decl in self.declarations if(decl.relation.entity2 == e and isinstance(decl.relation,(Member, Subtype)))]

        if(lst_kids == []):
            return []

        res_list= []
        for l in lst_kids:
            lst_assoc = self.query_down(l, assoc)
    #acabar

    def query_induce(self, tp, assoc):
        desc_lst = self.query_down(tp, assoc)

        lst_values = [d.relation.entity2 for d in desc_lst]

        accurances = Counter(lst_values)

        # common_assoc_value, num_occur =

        #acabar
            
            