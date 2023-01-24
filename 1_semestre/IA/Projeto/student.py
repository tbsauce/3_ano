"""Example client."""
import asyncio
import getpass
import json
import os
from common import *

# Next 4 lines are not needed for AI agents, please remove them from your code!
import pygame
import websockets

pygame.init()
program_icon = pygame.image.load("data/icon2.png")
pygame.display.set_icon(program_icon)


class Grid(Map):
    def __init__(self, txt: str): 
        super().__init__(txt)
        self.txt = txt.split(" ")[1]

    #copys class
    @property
    def copy(self):
        return Grid(str(self))

    @property
    def existingCars(self):
        cars = []
        for char in self.txt:
            if(char not in cars and char != self.empty_tile):
                cars.append(char)
        return cars
    
    #Carros que bloqueam o carro A
    @property
    def blockingCarA(self):
        car = self.getCar("A")
        blocking = []
        i = car.y
        while( i < self.grid_size):
            block = self.get(Coordinates(i, car.y))
            if(block != self.empty_tile):
                blocking += block
            i+=1

        return blocking
    
    #Carros que bloqueam o carro
    def blockingCars(self, letter):
        car = self.getCar(letter)
        i = 0
        blocking=[]
        while( i < self.grid_size):
            if(car.direction == "H"):
                block = self.get(Coordinates(i, car.y))
            elif(car.direction == "V"):
                block = self.get(Coordinates(car.x, i))
            elif(car.direction == "F"):
                return []
            if(block != self.empty_tile and block != car.letter and (block not in blocking or block == "x")):
                blocking += block

            i+=1

        return blocking

    #get car in formar Car(class)
    def getCar(self, letter):
        piece = self.piece_coordinates(letter)
        if(piece != []):
            x = piece[-1].x
            y = piece[-1].y
            if(letter == "x"):
                direction = "F"
            elif(y == piece[0].y):
                direction = "H"
            elif(x == piece[0].x):
                direction = "V"
            return Car(letter, direction, x, y, len(piece))
        else:
            print("Not Existing Piece")

    #get Car moves
    def getMoves(self, letter):
        if(self.piece_coordinates(letter) != []):
            car = self.getCar(letter)
            moves = []
            if(car.direction == "H"):
                if( car.x != self.grid_size-1 and self.grid[car.y][car.x + 1] == self.empty_tile):
                    moves.append("Right")
                if( car.x != car.size-1 and self.grid[car.y][car.x - car.size] == self.empty_tile):
                    moves.append("Left")
            elif(car.direction == "V"):
                if( car.y != self.grid_size-1 and self.grid[car.y + 1][car.x] == self.empty_tile):
                    moves.append("Down")
                if(car.y != car.size -1 and self.grid[car.y - car.size][car.x] == self.empty_tile):
                    moves.append("Up")
            return moves
        
class Car:
    def __init__(self,letter,direction,x,y,size):
        self.letter = letter
        self.direction = direction
        self.x=x
        self.y=y
        self.size=size

    def __repr__(self):
        return "Car(letra: "+str(self.letter)+" Direction: "+self.direction+" X:"+str(self.x)+" Y:"+str(self.y)+" Size:"+str(self.size) + ")"

    def __eq__(self, other):
        return self.x == other.x and self.y == other.y and self.letter == other.letter
    
    #copys class
    @property
    def copy(self):
        return Car(self.letter, self.direction, self.x, self.y, self.size)

class Cursor:

    def __init__(self,state):
        self.x = state.get("cursor")[0]
        self.y = state.get("cursor")[1]
        self.selected = state.get("selected")

    def __repr__(self):
        return "\nx -> " + str(self.x) + "\n y -> "+ str(self.y) + "\nSelecting -> " + self.selected

    #Moves Cursor to piece
    def toPiece(self, car):
        for i in range(abs(car.x - self.x)):
            if(car.x < self.x):
                return "a"
            else:
                return "d"
        for i in range(abs(car.y - self.y)):
            if(car.y < self.y):
                return "w"
            else:
                return "s"

    #returns moves cursor to certain position
    def toCord(self, Coordinates : Coordinates):
        for i in range(abs(Coordinates.x - self.x)):
            if(Coordinates.x < self.x):
                return "a"
            else:
                return "d"
        for i in range(abs(Coordinates.y - self.y)):
            if(Coordinates.y < self.y):
                return "w"
            else:
                return "s"
    
    def makeAllMoves(self, actions, txt):
        grid = Grid(txt)
        moves = []
        positions = [str(grid)]
        lastCar = None
        actions.pop(0)
        while actions != []:
            (car , move) = actions.pop(0)
            if(lastCar == None):
                tempmoves = self.toPiece(grid.getCar(car)) + [" "]
                moves += tempmoves
                for i in tempmoves:
                    positions.append(str(grid))

            elif(lastCar != car):
                tempmoves = [" "] + self.toPiece(grid.getCar(car)) + [" "]
                moves += tempmoves
                for i in tempmoves:
                    positions.append(str(grid))

            self.selected = car
            #make a move
            if(move == "Right"):
                self.x += 1
                grid.move(car, Coordinates(1, 0))
                moves.append("d")
            elif(move == "Left"):
                self.x += -1
                grid.move(car, Coordinates(-1, 0))
                moves.append("a")
            elif(move == "Up"):
                self.y += -1
                grid.move(car, Coordinates(0, -1))
                moves.append("w")
            elif(move == "Down"):
                self.y += 1
                grid.move(car, Coordinates(0, 1))
                moves.append("s")
            lastCar = car
            positions.append(str(grid))

        return (positions , moves)
    
    def makeMove(self, actions, txt):
        grid = Grid(txt)

        (car , move) = actions[0]
        car = grid.getCar(car)

        
        if(car.letter == self.selected or self.selected==""):
            if(car.x == self.x and car.y == self.y):
                if(self.selected == car.letter):
                    if(move == "Right"):
                        grid.move(car.letter, Coordinates(1, 0))
                        move = "d"
                    elif(move == "Left"):
                        grid.move(car.letter, Coordinates(-1, 0))
                        move = "a"
                    elif(move == "Up"):
                        grid.move(car.letter, Coordinates(0, -1))
                        move = "w" 
                    elif(move == "Down"):
                        grid.move(car.letter, Coordinates(0, 1))
                        move = "s"
                    actions.pop(0)
                else:
                    move = " "
            else:
                if(self.selected == car.letter):
                    move = " "
                else:
                    move = self.toPiece(car)
        else:
            move = " "

        return (str(grid) , move)
    
    def correctCrazy(self, right, wrong, cant):
        goodGrid = Grid(right)
        badGrid = Grid(wrong)

        while True:
            for car in badGrid.coordinates:
                if(car not in goodGrid.coordinates and car[2] not in cant):
                    (x, y, letter) = car
        
            badCar = badGrid.getCar(letter)
            goodCar = goodGrid.getCar(letter)

            
            if(badCar.letter == self.selected or self.selected==""):
                if(badCar.x == self.x and badCar.y == self.y):
                    if(self.selected == letter):
                        try:
                            if(goodCar.x > badCar.x):
                                badGrid.move(letter, Coordinates(1, 0))
                                return "d", []
                            elif(goodCar.x < badCar.x):
                                badGrid.move(letter, Coordinates(-1, 0))
                                return "a", []
                            elif(goodCar.y < badCar.y):
                                badGrid.move(letter, Coordinates(0, -1))
                                return "w", []
                            elif(goodCar.y > badCar.y):
                                badGrid.move(letter, Coordinates(0, 1))
                                return "s", []
                        except MapException:
                            cant += [letter]
                    else:
                        return " ", cant
                else:
                    if(self.selected == letter):
                        return " ", cant
                    else:
                        return self.toPiece(badCar), cant
            else:
                return " ", cant




#Retorna todas os moves disponiveis de todos os carros
def actions(txt):
    allMoves = []
    temp = Grid(txt)
    for letter in temp.existingCars:
        moves = temp.getMoves(letter)
        for move in moves:
            allMoves.append((letter, move))
    return allMoves
    
            
#retorna a lista de carros apos uma acao
def result(car,action, txt):
    temp = Grid(txt)
    if(action == "Right"):
        temp.move(car, Coordinates(1, 0))
    elif(action == "Left"):
        temp.move(car, Coordinates(-1, 0))
    elif(action == "Up"):
        temp.move(car, Coordinates(0, -1))
    elif(action == "Down"):
        temp.move(car, Coordinates(0, 1))
    return str(temp)
        

def cost(old, new): 
    return 0
    
def heuristic(txt):
    temp = Grid(txt)
    blockers = temp.blockingCarA
    A = temp.getCar("A")
    blockingBlockers = 0
    for blocker in blockers:
        blockingBlockers += len(temp.blockingCars(blocker))
    return (temp.grid_size -1) - A.x + blockingBlockers

def satisfies(txt):
    temp = Grid(txt)
    return temp.test_win()
    
# Arvores de pesquisa
class SearchTree:
    # construtor
    def __init__(self,problem): 
        self.problem = problem
        root = (problem[1], None, None, 0, 0, self.problem[0][3](problem[1]))
        self.all_nodes = {root[0] : root}
        self.open_nodes = [root[0]]
        self.solution = None

    @property
    def depth(self):
        return self.solution[3]
    
    @property
    def cost(self):
        return self.solution[4]
    
    # obter o caminho (sequencia de estados) da raiz ate um no
    def get_moves(self,node):
        if node[1] == None:
            return []
        path = self.get_moves(self.all_nodes[node[1]])
        path += [node[2]]
        return(path)
    
    def get_path(self,node):
        if node[1] == None:
            return [node[0]]
        path = self.get_path(self.all_nodes[node[1]])
        path += [node[0]]
        return(path)

        # procurar a solucao
    def search(self):
        while self.open_nodes != []:
            nodeState = self.open_nodes.pop(0)
            node = self.all_nodes[nodeState]
            if self.problem[0][4](node[0]):
                self.solution = node
                return self.get_moves(node)
            lnewnodes = []
            action = self.problem[0][0](node[0])
            for a in action:
                (car, action) = a
                newstate = self.problem[0][1](car, action ,node[0])
                if newstate not in self.get_path(node):
                    newnode = (newstate, nodeState, a, node[3]+1, node[4] + self.problem[0][2](node[0],newstate), self.problem[0][3](newstate))
                    if(newstate in self.all_nodes):
                        #n faz nada
                        if self.all_nodes[newstate][4] > newnode[4]:
                            self.all_nodes[newstate] = newnode
                    else:
                        lnewnodes.append(newstate)
                        self.all_nodes[newstate] = newnode
            self.add_to_open(lnewnodes)
        return None

    
    # juntar novos nos a lista de nos abertos de acordo com a estrategia
    def add_to_open(self,lnewnodes):
        for node in lnewnodes:
            insort_right(self.open_nodes, node, key = lambda nodeState: self.all_nodes[nodeState][4] + self.all_nodes[nodeState][5])

#This function is from https://github.com/python/cpython/blob/3.11/Lib/bisect.py    
def insort_right(a, x, lo=0, hi=None, *, key=None):
    """Insert item x in list a, and keep it sorted assuming a is sorted.
    If x is already in a, insert it to the right of the rightmost x.
    Optional args lo (default 0) and hi (default len(a)) bound the
    slice of a to be searched.
    """
    if key is None:
        lo = bisect_right(a, x, lo, hi)
    else:
        lo = bisect_right(a, key(x), lo, hi, key=key)
    a.insert(lo, x)

#This function is from https://github.com/python/cpython/blob/3.11/Lib/bisect.py   
def bisect_right(a, x, lo=0, hi=None, *, key=None):
    """Return the index where to insert item x in list a, assuming a is sorted.
    The return value i is such that all e in a[:i] have e <= x, and all e in
    a[i:] have e > x.  So if x already appears in the list, a.insert(i, x) will
    insert just after the rightmost x already there.
    Optional args lo (default 0) and hi (default len(a)) bound the
    slice of a to be searched.
    """

    if lo < 0:
        raise ValueError('lo must be non-negative')
    if hi is None:
        hi = len(a)
    # Note, the comparison uses "<" to match the
    # __lt__() logic in list.sort() and in heapq.
    if key is None:
        while lo < hi:
            mid = (lo + hi) // 2
            if x < a[mid]:
                hi = mid
            else:
                lo = mid + 1
    else:
        while lo < hi:
            mid = (lo + hi) // 2
            if x < key(a[mid]):
                hi = mid
            else:
                lo = mid + 1
    return lo


async def agent_loop(server_address="localhost:8000", agent_name="student"):
    """Example client loop."""
    async with websockets.connect(f"ws://{server_address}/player") as websocket:

        # Receive information about static game properties
        await websocket.send(json.dumps({"cmd": "join", "name": agent_name}))  

        level = 0
        cant = []
        while True:
            try:
                state = json.loads(
                    await websocket.recv()
                )  # receive game update, this must be called timely or your game will get out of sync with the server

                grid = Grid(state.get("grid"))
                curse = Cursor(state)

                domain =(   lambda txt : actions(txt),
                            lambda car, action, txt : result(car, action, txt),
                            lambda oldtxt,newtxt : cost(oldtxt, newtxt),
                            lambda txt : heuristic(txt),
                            lambda txt : satisfies(txt)
                        )

                p = (domain, str(grid))
                t = SearchTree(p)

                if(level != state.get("level")):
                    solucao = t.search()
                    level = state.get("level")
                    posicao = ""

                if(posicao != str(grid) and posicao != ""):
                    (move, cant) = curse.correctCrazy(posicao, str(grid), cant)
                else:    
                    (posicao, move) = curse.makeMove(solucao, str(grid))
                
                key = move
                await websocket.send(
                    json.dumps({"cmd": "key", "key": key})
                )

            except websockets.exceptions.ConnectionClosedOK:
                print("Server has cleanly disconnected us")
                return


# DO NOT CHANGE THE LINES BELLOW
# You can change the default values using the command line, example:
# $ NAME='arrumador' python3 client.py
loop = asyncio.get_event_loop()
SERVER = os.environ.get("SERVER", "localhost")
PORT = os.environ.get("PORT", "8000")
NAME = os.environ.get("NAME", getpass.getuser())
loop.run_until_complete(agent_loop(f"{SERVER}:{PORT}", NAME))
