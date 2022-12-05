import numpy as np
from collections import deque
import copy
import argparse
from pathlib import Path
import os
global graph

graph=dict()

parser = argparse.ArgumentParser("Schedule Estimator Using Blockwise-Dijkstra")
parser.add_argument('--input_path', type=str, default='./result', help="summary path insert (default : ./result)")
parser.add_argument('--mode', type=str, default='avg', help="compute Dijkstra mode |avg|std|min| (default : avg)")


def get_summary(input_path):
    if not isinstance(input_path, Path):
        temp_path = Path(input_path)
    else:
        temp_path = input_path
    name=[]
    block = []
    
    for network_summary_path in temp_path.glob('*'):
        f= open(network_summary_path,'r')
        data = f.readlines()
        systolic_count = 0
        for T in data:
            T = T.replace("\n", "")
            L = T.split(' ')
            if L[0] == 'Systolic':
                systolic_count+=1
            if L[0] == 'DNN':
                if L[-1][:-12] not in name:
                    name.append(L[-1][:-12])
            if len(T.split(' ')) > 9:
                block.append(makeblock(T.split(' '), 6))
    
    return name, block, systolic_count


def makeblock(argparse, n): 
    tmp = np.array(argparse[:-1],dtype=np.int64)
    tmp1 = np.array(np.array_split(tmp,n),dtype=object)
    ret = np.array([],dtype=np.int64)
    for i in tmp1:
        ret = np.append(ret,np.sum(i,dtype=np.int64))
    return ret

def makegraph(block, name, m):
    connect=[]
    #print(np.array(block).shape)
    mod = len(block)
    quo = mod//m
    #print(mod)
    for h in range(0,quo):
        #print(h)
        #print(connect)
        connect.append([f"{name[h]}-0+0",block[h][0]])
    graph['root'] = connect
    #for i in range(0,mod):
    #    time[i]=0
    for a in range(0, 6):
        for b in range(0, m): 
            for c in range(0, quo):
                graph[f"{name[c%m]}-{a}+{b}"]=[]
                if b<m-1:
                    for d in range(0,quo):
                        graph[f"{name[c%m]}-{a}+{b}"].append([f"{name[d%m]}-{a}+{(b+1)}", block[b*m+d][a]])
                elif a<5:
                    for d in range(0,quo):
                        graph[f"{name[c%m]}-{a}+{b}"].append([f"{name[d%m]}-{(a+1)}+0", block[d][a+1]])
                else:
                    graph[f"{name[c%m]}-{a}+{b}"].append(['leaf'])
    
    return 0

import heapq


class Node:
    
    def __init__(self, name, iter):       
        self.name = name
        self.iter = iter
        self.block = name[:-2]
        self.model = self.block[:-2]
        self.stage = self.block[-1:]
        self.sarr = name[-1:]
        self.children = np.array(graph[name], dtype = object)
        self.usemodel = np.empty((0,iter),dtype=np.int64)
        self.usearr = np.empty((0,iter),dtype=np.int64)
        self.routes = []
    def __lt__(self, other):
        if self.stage < other.stage:
            return True
        elif self.stage == other.stage:
            if self.sarr < other.sarr:
                return True
            elif self.sarr == other.sarr:
                if self.model == 'resnet18':
                    return False
                elif self.model == 'bert':
                    if other.model == 'resnet18':
                        return True
                    else:
                        return False
                elif self.model == 'resnet50':
                    return True
            else: 
                return False
        else:
            return False
        
    def IsLeaf(self):
        for child in self.children:
            if ['leaf'] in child:
                return True
        return False

def dijkstra(graph,root,name,limit):
    v=[]
    ret=[]
    #print(root)
    #print(limit)
    for node in graph:
        a = Node(node,len(name))
        #print(a.children)
        v.append(a)

    for blk in v:
        if blk.name == root:
            blk.dist = np.zeros(shape = (blk.iter,),dtype=np.int64)
            queue = []
            tmp= np.zeros(shape=(len(name),),dtype=np.int64)
            blk.usemodel=np.append(blk.usemodel,np.array([tmp]),axis=0)
            blk.usearr = np.append(blk.usearr,np.array([tmp]),axis=0)
            blk.sarr = 0
            blk.stage = 0
            blk.routes.append(['root'])
            #print(blk.usemodel)
            #print(blk.usearr)
            heapq.heappush(queue, blk)
            break
    #distributor = []
    while queue:  # queue에 남아 있는 노드가 없으면 끝
        # for i in range(len(queue)):
        #     print(queue[i].name)
        # print('---------')
        
        blocknode = heapq.heappop(queue)  # 탐색 할 노드, 거리를 가져옴.
        #print(blocknode.name)
        if blocknode.IsLeaf():  # leaf node 예외처리
            print('leafnode')
            #print((blocknode.usemodel))
            ret.append(blocknode)
            #print(blocknode.routes)
        
            continue
        
        
        # if blocknode.name != 'root':
        #     for i in range(len(name)):

        #         if blocknode.model == name[i]:
        #             if blocknode.stage != blocknode.children[0][0][-3:-2]:
        #                 #print(f"{blocknode.name}, {blocknode.stage}, {blocknode.children[0][0][-3:-2]}")
        #                 distributor = [[] for i in range(len(name))]
        #                 break
                        
        else:
            # for next_block, next_dist in blocknode.children:
            #     print(blocknode.name)
            #     print(f"_{next_block}_")
            # print('---------')
            for next_block, next_dist in blocknode.children:
                tmp2 = 0
                distance= np.empty((0,len(name)),dtype=np.int64)
                #if blocknode.stage != next_block[-3:-2]:
                    #print(next_block[-3:-2])
                    #print(next_block)
                    #print(blocknode.stage)
                #print(blocknode.routes)
                
                distance = np.append(distance, blocknode.usemodel,axis=0)
                for blk2 in v:
                    for i in range(0,len(name)):
                        if blk2.model == name[i]:
                            tmp2 = i
                            break
                    #print(tmp2)
                    
                    if blk2.name == next_block:
                        
                        

                        print(f"searching with {blk2.name}...")
                        path = copy.deepcopy(blocknode.routes)
                        tmpmodel= copy.deepcopy(blocknode.usemodel)
                        tmparr= copy.deepcopy(blocknode.usearr)
                        
                        
                        for i in range(0,len(tmpmodel)):
                            
                            distance[i][tmp2] = max(tmpmodel[i][tmp2],tmparr[i][int(blk2.sarr)]) + next_dist
                            
                            path[i].append(blk2.name)
                            #print(f"dist: {distance[i]}")
                            if distance[i][tmp2] > limit:
                                
                                distance[i] = np.empty(shape=(len(name),),dtype=np.int64)
                                tmparr[i] = np.empty(shape=(len(name),),dtype=np.int64)
                                path[i] = []
                                #print(distance[i])
                                #print(path[i])
                            
                            else:
                                for each_path in path[i][:-1]:
                                    if blk2.block == each_path[:-2]:
                                        distance[i] = np.empty(shape=(len(name),),dtype=np.int64)
                                        distance[i].fill(-1)
                                        tmpmodel[i]=distance[i]
                                        tmparr[i] = np.empty(shape=(len(name),),dtype=np.int64)
                                        tmparr[i].fill(-1)
                                        path[i] = []
                                        
                                if len(path[i])!=0:
                                    #print
                                    tmpmodel[i][tmp2] = distance[i][tmp2]
                                    tmparr[i][int(blk2.sarr)] = distance[i][tmp2]
                        if np.average(tmpmodel.reshape(-1))==-1:
                            continue
                        else:
                            blk2.usemodel = np.append(blk2.usemodel, np.array([dist for dist in tmpmodel if -1 not in dist]), axis=0)
                            blk2.usearr = np.append(blk2.usearr, np.array([arr for arr in tmparr if -1 not in arr]), axis=0)
                        path = [r for r in path if len(r) != 0 ]
                        blk2.routes = blk2.routes+path
                        #print(blk2.usemodel)
                        # if len(blk2.routes)<4:
                        #     print(f"name:{blk2.name}")
                        #     print(blk2.routes)
                        # else:
                        #     break
                        
                        heapq.heappush(queue, blk2)
                        #print('pushed')
                        # for i in range(len(queue)):
                        #     print(queue[i].name)
                        print(f"search complete.")
                        break
                        
                queue = list(set(queue))
                heapq.heapify(queue)
            

    return ret



def dfs(graph, start_node, limit, name):
    if limit ==0:
        limit = float('inf')
    tot_cycle=0
    tot_cycle = np.int64(tot_cycle)
    usemodel=dict()
    time = np.zeros(shape=(len(name)+1,),dtype=np.int64)
    usearr = np.zeros(shape=(len(name)+1,),dtype=np.int64)
    for i in range(0, len(name)):
        usemodel[name[i]] = 0
    #usemodel[name[0]] = 0
    #usemodel[name[1]] = 0
    #usemodel[name[2]] = 0

    visited = []
    routes = []
    unvisitied = deque()
    unvisitied.append(start_node)
    cnt = 0 

    while unvisitied:
        node = unvisitied.pop()
        if node[0] == 'leaf':
            continue
        elif node != 'root':
            block, arr = node[0].split('+')
            blkname = (block[:-2])
            stgname = int(block[-1:])
            #print(stgname)
            #print(usemodel,usearr)

            if stgname > cnt: 
                tot_cycle = max(time)
                cnt+=1
                #print(tot_cycle)
            delay = max(int(usemodel[blkname]), usearr[int(arr)])
            
            usearr[int(arr)] = delay
            
            if blkname == name[0]:
                usemodel[name[0]] = node[1]
                time[0] += node[1]
            if blkname == name[1]:
                usemodel[name[1]] = node[1] 
                time[1] += node[1]
            if blkname == name[2]:
                usemodel[name[2]] = node[1]
                time[2] += node[1]
            

            if tot_cycle <= limit:
                
                if node not in visited:
                    #print(block)
                    #print(node)
                    visited.append(node)
                    routes.append(node)
                    unvisitied.extend(graph[node[0]])
        else:
            if node not in visited:

                visited.append(node)
                unvisitied.extend(graph[node])

    #print(tot_cycle)
                
    return visited, routes


if __name__ == '__main__':

    args = parser.parse_args()
    mode = args.mode
    graph = dict()
    graph.clear()
    
    name, block, count = get_summary(args.input_path)

    #print(block)
    makegraph(block, name, count)
    #print(graph)
    visited, routes = dfs(graph, 'root',0, name)
    k = dijkstra(graph,'root', name, 10070765488)
    ret=float("inf")
    result=[]
    idx=0
    for node in k:
        iteration = len(node.usemodel)
        # 전체 출력
        # for i in range(0,iteration):
        #     print(f"path: {node.routes[i]}, cycles: {node.usemodel[i]}")
        # 편차 적은거 출력
        if mode == 'std':
            for i in range(0,iteration):
                if np.std(node.usemodel[i],dtype=np.float64) < ret:
                    idx = i
                    ret = np.std(node.usemodel[i],dtype=np.float64)
        # 평균 작은거 출력
        elif mode == 'avg':
            for i in range(0,iteration):
                if np.average(node.usemodel[i]) < ret:
                    idx = i
                    ret = np.average(node.usemodel[i])
        # 가장 좋은거 출력
        elif mode == 'min':
            for i in range(0,iteration):
                if np.max(node.usemodel[i]) < ret:
                    idx = i
                    ret = np.max(node.usemodel[i])
        else:
            print("use 'std', 'avg', 'min'")

    for node in k:
        if ret == np.max(node.usemodel[idx]) and mode == 'min':
            print(f"path: {node.routes[idx]}, cycles: {node.usemodel[idx]}, with smallest total cycles")
            print(f"systolic array usage: {node.usearr[idx]} for smallest total cycles")
        if ret == np.std(node.usemodel[idx]) and mode == 'std':
            print(f"path: {node.routes[idx]}, cycles: {node.usemodel[idx]} with smallest deviation")
            print(f"systolic array usage: {node.usearr[idx]} for smallest deviation")
        if ret == np.average(node.usemodel[idx]) and mode == 'avg':
            print(f"path: {node.routes[idx]}, cycles: {node.usemodel[idx]} with smallest average")
            print(f"systolic array usage: {node.usearr[idx]} for smallest average")







