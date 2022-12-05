from pathlib import Path
import os
import numpy as np
from easydict import EasyDict as edict
from pprint import pprint
import argparse

parser = argparse.ArgumentParser("Compute ")
parser.add_argument('--input_path', type=str, default='./result', help="Path to store Cycle list calculated by ACA")
parser.add_argument('--output_dir', type=str, default='./output', help="output directory")

def parsing_sys_result(input_path):
    if not isinstance(input_path, Path):
        # input_path's string
        input_path = Path(input_path)
        result_cycle_path = input_path
    else:
        result_cycle_path = input_path
        
    entire_parsing_dict = edict()
    network_name = []
    for test_file in result_cycle_path.glob('*'):
        with open(test_file, 'r') as f:
            result_lines = f.readlines()
        temp_parsing_dict = edict()

        for i, line in enumerate(result_lines):
            line_list = line.split(' ')
            if "Systolic" in line:
                row = int(line_list[line_list.index('row')+2]) # get row
                col = int(line_list[line_list.index('col')+2]) # get row
                temp_parsing_dict[f'{row}_{col}'] = edict()

            if 'DNN' in line and 'cycle' not in result_lines[i+1]:
                model_name = line_list[-1].split(".txt")[0]
                temp_parsing_dict[f'{row}_{col}'][model_name] = edict()
                cycle_list = result_lines[i+1].rstrip('\n').split(' ')
                if '' in cycle_list:
                    print(cycle_list)
                    cycle_list = cycle_list[:-1]
                temp_parsing_dict[f'{row}_{col}'][model_name]['layer_cycle'] = list(map(int, cycle_list))

                #parsing_dict[f'{row}_{col}'][line_list[-1].split(".txt")[0]]['layer_cycle'] = list(map(int, result_lines[i+1].split(' ')[:-1]))

            if 'DNN' in line and 'cycle' in result_lines[i+1]:
                temp_parsing_dict[f'{row}_{col}'][model_name]['total_cycle'] = result_lines[i+1].split()[-1].split('\n')[0]
                network_name.append(model_name)

        for row_col_val in temp_parsing_dict.keys():
            if not hasattr(entire_parsing_dict, row_col_val):
                entire_parsing_dict[row_col_val]  = edict()

            if not hasattr(entire_parsing_dict[row_col_val], model_name):
                entire_parsing_dict[row_col_val][model_name] = edict()
            entire_parsing_dict[row_col_val][model_name]['layer_cycle'] = temp_parsing_dict[row_col_val][model_name]['layer_cycle']
    network_name = set(network_name)
    
    return entire_parsing_dict, network_name


class Systolic():
    def __init__(self, sys_name, sys_idx):
        self.sys_name = sys_name
        self.sys_idx = sys_idx
        self.run_systolic_cycle = 0
    
    def __str__(self):
        return f"{self.sys_name}, index {self.sys_idx}"
    
    def __repr__(self):
        return f"array type (sys_name): {self.sys_name}, index (sys_idx): {self.sys_idx}"

    def finish_layer_print(self, network_name, idx):
        print(f"sys name : {self.sys_name}_{self.sys_idx}, network_name's_idx : {network_name}_{idx-1} finish")
        
    def update_run_systolic_cycle(self, cycle):
        self.run_systolic_cycle += cycle

class Network():
    def __init__(self, parsing_dict, network_name, verbose=True):
        self.name = network_name
        self.network_cycle = edict()
        self.remain_total_cycle = edict()
        
        for sys_index in parsing_dict.keys():
            self.network_cycle[sys_index] = parsing_dict[sys_index][self.name]['layer_cycle']
            self.remain_total_cycle[sys_index] = sum(self.network_cycle[sys_index])
        print(self.remain_total_cycle)
        self.current_running_idx = 0
        self.current_cycle = 0
        self.systolic = None
        self.verbose = verbose
    def get_remain_total_cycle(self):
        return [(sys_name, self.remain_total_cycle[sys_name] + self.current_cycle) for sys_name in self.remain_total_cycle.keys()]
    
    def finish_layer(self, close_cycle):
        """
        finish i idx layer result and re-calculating remain_total_cycle
        """
        if self.verbose:
            print("finish layer")
        for sys_index in self.remain_total_cycle.keys():
            self.remain_total_cycle[sys_index] = sum(self.network_cycle[sys_index][self.current_running_idx:])
        self.current_cycle = 0
        self.systolic.finish_layer_print(self.name, self.current_running_idx)
        self.systolic.update_run_systolic_cycle(self.network_cycle[sys_index][self.current_running_idx-1])
        self.del_systolic()

    def get_current_remain_cycle(self, pre_compute_cycle=0):
        if self.verbose:
            print(f"{self.name}'s idx {self.current_running_idx-1} get current remain cycle")
            if pre_compute_cycle > 0:
                print(f"layer cycle {self.current_cycle} - {pre_compute_cycle} = {self.current_cycle - pre_compute_cycle}")
            else:
                print(f"layer cycle {self.current_cycle}")
            curr_sys_name = self.systolic.sys_name
            self.current_cycle = self.current_cycle - pre_compute_cycle
        else:
            curr_sys_name = self.systolic.sys_name
            self.current_cycle = self.current_cycle - pre_compute_cycle
        
        return self.current_cycle
    
    def set_layer_and_current_cycle(self):
        curr_sys_name = self.systolic.sys_name
        self.current_cycle = self.network_cycle[curr_sys_name][self.current_running_idx-1]
        if self.verbose:
            print("current systolic name :", curr_sys_name)
            print(f"current layer's  idx and cycle : {self.current_running_idx-1}, {self.current_cycle}")
        return self.current_cycle
        
    
    def set_systolic(self, systolic):
        self.systolic = systolic
        self.current_running_idx +=1
        for sys_index in self.remain_total_cycle.keys():
            self.remain_total_cycle[sys_index] = sum(self.network_cycle[sys_index][self.current_running_idx:])
    
    def del_systolic(self):
        self.systolic = None

def set_layer_and_calculate(list_network, sys_list, i, output_cycle = [], verbose=True):
    current_pool = []
    current_total_cycle_list = []
    most_powerful_sys = sys_list[0]

    for i in range(len(list_network)):
        if list_network[i].remain_total_cycle[most_powerful_sys.sys_name] ==0:
            print("********"*20)
            print("finished network : ", list_network[i].name)
            print("remove network")
            print("********"*20)
            list_network.pop(i)
    
    if len(list_network) == 0:
        print("########## finish entire layer ################")
        print("total using cycle : ")
        print("########## finish entire layer ################")
        return False
    
    # calculate remain cycle in most powerful systolic array
    for network in list_network:
        current_total_cycle_list.append(network.remain_total_cycle[most_powerful_sys.sys_name])
    print("======"*20)
    print("using most powerful cycle in time ", i)
    print([network.name for network in list_network])
    print(current_total_cycle_list)
    print("======"*20)
    
    sorted_idx = np.argsort(current_total_cycle_list)[::-1] # required cycle descent sorting
    
    if verbose:
        print("======"*20)
        print(f"Set {i} time in network's cycle in using systolic array")
        for i, network in enumerate(list_network):
            print(network.name)
            print(network.get_remain_total_cycle())
            print("======"*20)
    

    for i, systolic in enumerate(sys_list): # descent layer
        if i >= len(sorted_idx):
            break
        if list_network[sorted_idx[i]].systolic is None:
            list_network[sorted_idx[i]].set_systolic(systolic)
            list_network[sorted_idx[i]].set_layer_and_current_cycle()

    for network in list_network:
        print("======"*20)
        current_pool.append(network.get_current_remain_cycle())
        print("======"*20)
    current_pool = np.array(current_pool)
    min_idx_arr = np.argmin(current_pool)
    min_idx_arr = np.where(current_pool == current_pool[min_idx_arr])[0] # min_idx is np.array and same end cycle to compute 
    
    for min_idx in min_idx_arr:
        print(min_idx)
        close_cycle = current_pool[min_idx]
        print("======"*20)
        print("current layer cycle in systolic array")
        print([f"{sys.sys_name}_{sys.sys_idx}"for sys in sys_list]) # Sorted systolic array in order of good performance
        print(current_pool)
        print("======"*20)
        print("closed systolic idx :", min_idx, sys_list[min_idx])
        print("Using cycle: ", close_cycle)

        print("======"*20)

        list_network[min_idx].finish_layer(close_cycle)
        print("======"*20)
    output_cycle.append(close_cycle)
    
    for i, network in enumerate(list_network):
        print(network.name)
        if i in min_idx_arr:
            print("finished layer")
            print("======"*20)
            print(network.get_remain_total_cycle())
            print("======"*20)
    
        else:
            print("======"*20)
            print(network.get_current_remain_cycle(close_cycle))
            print("======"*20)
    return True


def main(args):
    parsing_dict, network_name = parsing_sys_result(args.input_path)
    network_name = set(network_name)
    print(parsing_dict)

    sys_path = Path('./systolic.txt')
    with open(sys_path, "r") as f:
        sys_file_lines = f.readlines()

    sys_name_list = []
    for line in sys_file_lines:
        line_list = line.split(' ')
        row = line_list[0]
        col = line_list[1]
        num = line_list[2]
        sys_name_list.append([f'{row}_{col}', num])
    
    sys_list = []
    for sys_name in sys_name_list:
        for i in range(int(sys_name[1])):
            sys_list.append(Systolic(sys_name[0], i))

    sys_list.reverse() # sorting to systolic array (high to low)
    list_network=[]
    for i, key in enumerate(network_name):
        list_network.append(Network(parsing_dict, key))

    return_trigger = True
    output_cycles = []
    i = 0
    while return_trigger:
        return_trigger = set_layer_and_calculate(list_network, sys_list, i, output_cycle = output_cycles, verbose=True)
        i+=1
    
    print(output_cycles)


if __name__ == '__main__':
    args = parser.parse_args()
    main(args)
    
