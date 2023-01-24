from student import SearchTree, actions, result, cost, heuristic, satisfies

import time
import sys

def timeTestsAverage(iteration, name):
    results_file = open("testes/results" + str(name) + ".txt", "w")

    lines = []

    levels_file = open("levels.txt", "r")
    levels = levels_file.readlines()

    Numlevel = 0
    Total = 0
    for level in levels:
        Numlevel +=1
        domain =(   lambda txt : actions(txt),
                            lambda car, action, txt : result(car, action, txt),
                            lambda oldtxt,newtxt : cost(oldtxt, newtxt),
                            lambda txt : heuristic(txt),
                            lambda txt : satisfies(txt)
                        )

        p = (domain, level)

        t1 = 0
        for i in range(0, int(iteration)):
            t0 = time.process_time()
            t = SearchTree(p)
            search = t.search()
            t1 += time.process_time()-t0

        tTotal = t1/int(iteration)
        Total +=tTotal
        t1 = "\nTempo de Procura ->  " + str(tTotal)
        solucao = "\nTamanho da solução -> " + str(len(search))
        print("\33[31mAcabou ->" + str(Numlevel), "\33[0m")

        lines = ["\n\n\nleve-> " +str(Numlevel), solucao, t1]
        results_file.writelines(lines)
    lines = ["\n\n\n\nTotal da pesquisa -> " + str(Total)]
    results_file.writelines(lines)

    levels_file.close()
    results_file.close()

    return "Total -> " + str(Total)


print(timeTestsAverage(sys.argv[1], sys.argv[2]))
    


# python3 funcao.py x
# python3 funcao.py average 10 x


    # newstate = self.problem[0][1](node[0],a)
    #                 estadoExiste = False
    #                 if newstate not in self.get_path2(node):
    #                     newnode = (newstate,nodeID,node[2] + self.problem[0][2](node[0],a),self.problem[0][3](newstate,self.problem[2]),node[4] + 1)
    #                     for idx in range(0,len(self.all_nodes)):
    #                     #for n in self.all_nodes:
    #                         if self.all_nodes[idx][0] == newstate:
    #                             estadoExiste = True
    #                             if self.all_nodes[idx][2] > newnode[2]:
    #                                 self.all_nodes[idx] = newnode
    #                                 # self.add_to_open(lnewnodes)
    #                     if not estadoExiste:
    #                         lnewnodes.append(len(self.all_nodes))
    #                         self.all_nodes.append(newnode)
