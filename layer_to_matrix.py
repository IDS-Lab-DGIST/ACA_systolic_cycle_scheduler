from transformers import AutoModel, AutoConfig
import torch
import torch.nn as nn
import pandas as df
import numpy as np
from pathlib import Path
import pprint
import timm
import torch.nn.functional as F
from pathlib import Path
import argparse
import os
from transformers.models.bert.modeling_bert import BertSelfAttention

parser = argparse.ArgumentParser("Extract call's GEMM from a model")
parser.add_argument('--model_name', type=str, default='bert-base-uncased', help="model name using in timm or huggingface")
parser.add_argument('--batch_size', type=int, default=1, help="batch size")
parser.add_argument('--input_shape', type=int, default=128, help="input shape (nlp : sentence length, vision : width & height")
parser.add_argument('--output_dir', type=str, default='./ACA2/resource', help="output directory")

def get_parameters(module):
    new_dict = {}
    param_list = ['kernel_size', 'dilation', 'padding', 'stride']
    for param in param_list:
        new_dict[param] = module.__dict__[param]
    return new_dict, module.weight.cpu().detach()

class Hook_fwd():
    def __init__(self, module):
        self.module = module
        self.hook = module.register_forward_hook(self.hook_fn)
    def hook_fn(self, module, input, output):
        self.input =input
        self.output = output
    def close(self):
        self.hook.remove()


def compute_gemm_call(model, input_shape, batch_size, model_type, args):
    forward_hook_list = []
    print("compute gemm call module")
    for n, m in model.named_modules():
        if isinstance(m, nn.Conv2d) or isinstance(m, nn.Linear) and 'attention' not in n:
            if ('downsample' not in n) and ('shortcut' not in n):
                print(n)
                hook = Hook_fwd(m)
                forward_hook_list.append([n, hook])
        elif isinstance(m, BertSelfAttention):
            # qkv calculate and compute self-attention 
            for nqkv, mqkv in m.named_modules():
                if isinstance(mqkv, nn.Linear):
                    print(nqkv)
                    hook = Hook_fwd(mqkv)
                    forward_hook_list.append([nqkv, hook])
            print(n)
            hook = Hook_fwd(m)
            forward_hook_list.append([n, hook])            
            
        #elif 추 후 추가할 모델이 있으면 추가
    
    if model_type == 'nlp':
        dummy_input = torch.randint(0, 10000, [batch_size, input_shape]).cuda()
        print("nlp task's dummy input shape : ", dummy_input.shape)
    
    elif model_type == 'vision':
        in_ch = 3
        dummy_input = torch.randn(batch_size, in_ch, input_shape, input_shape).cuda()       
        print("vision task's dummy input shape : ", dummy_input.shape)
    
    model = model.cuda()
    out = model(dummy_input)
    
    out_strs = ''
    if model_type in 'nlp':
        for hook in forward_hook_list:
            temp_module = hook[1].module
            if isinstance(temp_module, BertSelfAttention):
                inp_mat = hook[1].input[0]
                attention_dict = temp_module.__dict__
                num_head = attention_dict['num_attention_heads']
                att_head_size = attention_dict['attention_head_size']
                inp_shape = inp_mat.size()
                assert num_head * att_head_size == inp_shape[2], f"attention head ({num_head}) * head_dim ({att_head_size})  != embedding feature ({inp_shape[2]})"
                inp_reshape = inp_mat.reshape(inp_shape[0], inp_shape[1], num_head, att_head_size).permute(0,2,1,3).shape
                
                print("qk calculate")

                out_str = f'''
=================================
LayerName : attention_{hook[0]}_qk_compute
IterN : {inp_reshape[0]*inp_reshape[1]} / ({inp_reshape[0], inp_reshape[1]})
InputRow : {inp_reshape[2]}
InputCol : {inp_reshape[3]}
WeightRow : {inp_reshape[3]}
WeightCol : {inp_reshape[2]}
OutputRow : {inp_reshape[2]}
OutputCol : {inp_reshape[2]}
==================================
                '''
                
                out_strs += out_str
                
                out_str = f'''
=================================
LayerName : attention_{hook[0]}_v_score_compute
IterN : {inp_reshape[0]*inp_reshape[1]} / ({inp_reshape[0], inp_reshape[1]})
InputRow : {inp_reshape[2]}
InputCol : {inp_reshape[2]}
WeightRow : {inp_reshape[2]}
WeightCol : {inp_reshape[3]}
OutputRow : {inp_reshape[2]}
OutputCol : {inp_reshape[3]}
==================================
                    '''
                out_strs += out_str                
                
            elif isinstance(temp_module, nn.Linear):
                w_mat = temp_module.weight
                inp_mat = hook[1].input[0]
                print(inp_mat.size())
                print(w_mat.size())
                if len(inp_mat.size()) == 3:
                    assert inp_mat.size(2) == w_mat.size(1), f"required matmul input (m, n, k) * weight (k, o) but input {inp_mat.size()} != weight {w_mat.size()}"
                    out_str = f'''
=================================
LayerName : {hook[0]}
IterN : {inp_mat.size()[0]}
InputRow : {inp_mat.size()[1]}
InputCol : {inp_mat.size()[2]}
WeightRow : {w_mat.size()[1]}
WeightCol : {w_mat.size()[0]}
OutputRow : {inp_mat.size()[1]}
OutputCol : {w_mat.size()[0]}
==================================
                    '''
                    out_strs += out_str
                elif len(inp_mat.size()) == 2:
                    assert inp_mat.size(1) == w_mat.size(1), f"required matmul input (n, k) * weight (k, o) but input {inp_mat.size()} != weight {w_mat.size()}"
                    out_str = f'''
=================================
LayerName : {hook[0]}
InputRow : {inp_mat.size()[0]}
InputCol : {inp_mat.size()[1]}
WeightRow : {w_mat.size()[1]}
WeightCol : {w_mat.size()[0]}
OutputRow : {inp_mat.size()[0]}
OutputCol : {w_mat.size()[0]}
==================================
                    '''
                    out_strs += out_str 
    elif model_type == 'vision':
        for hook in forward_hook_list:
            temp_module = hook[1].module
            if isinstance(temp_module, nn.Conv2d):
                param_dict, conv_weight = get_parameters(temp_module)
                input_tensor = hook[1].input[0]
                inp_mat = F.unfold(input_tensor, **param_dict)
                inp_mat = inp_mat.transpose(1,2).reshape(-1, inp_mat.size(1)) # inp_mat size
                w_mat = conv_weight.reshape(conv_weight.size(0), -1).T
                assert inp_mat.size(1) == w_mat.size(0), f"required matmul input (m, k) * weight (k, n), but input {inp_mat.size()} != weight {w_mat.size()}"
                out_str = f'''
=================================
LayerName : {hook[0]}
InputRow : {inp_mat.size()[0]}
InputCol : {inp_mat.size()[1]}
WeightRow : {w_mat.size()[0]}
WeightCol : {w_mat.size()[1]}
OutputRow : {inp_mat.size()[0]}
OutputCol : {w_mat.size()[1]}
==================================
                '''
                out_strs += out_str
            elif isinstance(temp_module, nn.Linear):
                w_mat = temp_module.weight
                inp_mat = hook[1].input[0]
                assert inp_mat.size(1) == w_mat.size(1), f"required matmul input (m, k) * weight (k, m) but input {inp_mat.size()} != weight {w_mat.size()}"
                out_str = f'''
=================================
LayerName : {hook[0]}
InputRow : {inp_mat.size()[0]}
InputCol : {inp_mat.size()[1]}
WeightRow : {w_mat.size()[1]}
WeightCol : {w_mat.size()[0]}
OutputRow : {inp_mat.size()[0]}
OutputCol : {w_mat.size()[0]}
==================================
                '''
                out_strs += out_str
            
            
    print(out_strs)
    
    out_txt_path = f'{args.model_name}_summary.txt'
    if "/" in out_txt_path:
        out_txt_path = out_txt_path.split("/")[-1]

    out_txt_path = os.path.join(args.output_dir, out_txt_path)
    with open(f'{out_txt_path}', "w+") as f:
        f.write(out_strs)
    print("finished")



def main():
    args = parser.parse_args()
    model_name = args.model_name
    model_type = None
    batch_size = args.batch_size
    input_shape = args.input_shape
    output_dir = args.output_dir
    nlp_trigger = False
    try:
        model = timm.create_model(model_name, pretrained=True)
        model_type = "vision"
    except:
        print("Not a timm model, plz try huggingface transformers model")
        nlp_trigger=True
    
    if nlp_trigger:
        try:
            config = AutoConfig.from_pretrained(model_name)
            model = AutoModel.from_config(config)
            model_type = "nlp"
        except:
            print("Not a huggingface model, plz try a valid model name")
    
    if model_type==None:
        print("Not a valid model name, plz try new model name again")
        return
    
    compute_gemm_call(model, input_shape, batch_size, model_type, args)

if __name__ == '__main__':
    main()