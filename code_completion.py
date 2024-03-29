from openai import OpenAI
import os
import csv
import time
from dotenv import load_dotenv

load_dotenv()
api_key = os.getenv("OPENAI_API_KEY")
client = OpenAI(api_key=api_key, base_url="https://api.chatanywhere.tech/v1")

def gpt_35_api(messages: list):
    """为提供的对话消息创建新的回答

    Args:
        messages (list): 完整的对话消息
    """
    completion = client.chat.completions.create(model="gpt-3.5-turbo-1106", messages=messages)
    print(completion.choices[0].message.content)

prompt_comple_gen = '''
I want you to act as a blockchain developer.I will provide you with a solidity code missing one function detail. 
The missing part is labeled as below:

<!TODO:You need to complete this function> 

Please complete the code based on the context information. Only fill the missing part. Do not change other parts. 
Note: provide a full code without omitting any details. 
Most important!!!: make sure to include full code instead of part of the code.
Ensure that all aspects of the function, including input validation, logic, and return statements, are fully included in the generated code.
'''

prompt_comple_gen_new = '''
I want you to act as a blockchain developer. I will provide you with a piece of Solidity code that has a missing function which needs to be completed.

Let's do it step by step :
1. Your response should include the complete sections from the original code.Please make sure to output the original code again, don't be afraid of the trouble.
2. Your response should fill in the missing part(which is labeled as <// TODO:You need to complete this function>)
3. Then output the completed code and only the completed code in total.

Let's do it!Your response should only be pure codes, without any comments or annotations or text. Please start with "pragma solidity ^0.4.26"

'''


# params:
# vulner_deduplicate = './vul_depu/vulner.csv'
# contract_folder = './vulnerablity'
# return_folder = './data_delete/delete_io'
# comple_folder = './data_completion/comple_io'

vulner_deduplicate = './vul_depu/vulreen.csv'
contract_folder = './vre'
return_folder = './data_delete/delete_re'
comple_folder = './data_completion/comple_re'

# vulner_deduplicate = './vul_depu/vulbd.csv'
# contract_folder = './vulbd'
# return_folder = './data_delete/delete_vulbd'
# comple_folder = './data_completion/comple_vulbd'

# vulner_deduplicate = './vul_depu/vulue.csv'
# contract_folder = './vulue'
# return_folder = './data_delete/delete_ue'
# comple_folder = './data_completion/comple_ue'

# vulner_deduplicate = './vul_depu/vulETH.csv'
# contract_folder = './vulLETH'
# return_folder = './data_delete/delete_LETH'
# comple_folder = './data_completion/comple_LETH'

# vulner_deduplicate = './vul_depu/vulaf.csv'
# contract_folder = './vulaf'
# return_folder = './data_delete/delete_af'
# comple_folder = './data_completion/comple_af'

# vulner_deduplicate = './vul_depu/vullock.csv'
# contract_folder = './vullock'
# return_folder = './data_delete/delete_lock'
# comple_folder = './data_completion/comple_lock'

# vulner_deduplicate = './vul_depu/vulundel.csv'
# contract_folder = './vulundel'
# return_folder = './data_delete/delete_undel'
# comple_folder = './data_completion/comple_undel'

# vulner_deduplicate = './vul_depu/vulunself.csv'
# contract_folder = './vulunself'
# return_folder = './data_delete/delete_unself'
# comple_folder = './data_completion/comple_unself'


def remove_function_body(file_path, contract_name, function_name, save_path):
    with open(file_path, 'r') as file:
        lines = file.readlines()
    print("Delete //")    
    lines = [line.split('//')[0] for line in lines]
    lines = [line.split('#')[0] for line in lines]
    print("Delete function") 
    contract_found = False
    function_found = False
    count = 0
    flag = 0
    for i in range(len(lines)):
        line = lines[i]
        if contract_found:
            line = line.lstrip()

        if line.startswith("contract " + contract_name):
            contract_found = True
            print("Find " + contract_name)
            continue

        if contract_found and line.startswith("function " + function_name):
            print("Find " + function_name)
            function_found = True
            
        if contract_found and function_found:
            if "}" in line:
                count -= 1
            if flag == 1:
                lines[i] = ""
            if "{" in line:
                count += 1
                if count == 1:
                    lines[i] = lines[i].split("{")[0] + " {<// TODO:You need to complete this function>}\n"
                    flag = 1
            if count == 0 and flag == 1:
                flag = 0
                break
    if not function_found: 
        print("Warning: not found function!")               
    
    os.makedirs(return_folder, exist_ok=True)
    with open(save_path, 'w') as file:
        file.writelines(lines)

def get_prompt_code(file_path):
    if os.path.exists(file_path):
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as file:
            prompt_code = file.read()

    return prompt_code
         
def get_sol_return(file_path, prompt):
    global count_gen
    timeout_seconds = 120
    folder, file_name = os.path.split(file_path)
    os.makedirs(comple_folder, exist_ok=True)
    save_file_path = os.path.join(comple_folder, os.path.splitext(file_name)[0]) + '.sol'
    if os.path.exists(save_file_path):
        return ''

    messages = [{'role': 'system', 'content': prompt_comple_gen_new}, {'role':'user','content':prompt},]
    completion = client.chat.completions.create(model="gpt-3.5-turbo-1106", messages=messages, timeout=timeout_seconds, max_tokens=4096*2)
    content = completion.choices[0].message.content

    with open(save_file_path, 'w') as file:
        print(save_file_path)
        file.write(content)
        count_gen += 1
        print(f"Success_gen:{count_gen}")

    return content

count_gen = 0
max_length = 4096*3
with open(vulner_deduplicate, 'r') as csv_file:
        csv_reader = csv.reader(csv_file)
        for row in csv_reader:
            try:
                if row:
                    file_name = row[0]
                    extracted_file_name = file_name.split()[0]
                    contract_to_modify = file_name.split()[1]
                    function_to_empty = file_name.split()[2]
                    sol_file_path = os.path.join(contract_folder, f"{extracted_file_name}.sol")
                    # 检查文件是否存在
                    if os.path.exists(sol_file_path):
                        print(f"Found file for {extracted_file_name}: {sol_file_path}")
                        delete_file_path = os.path.join(return_folder, f"{extracted_file_name}.sol")
                        remove_function_body(sol_file_path, contract_to_modify, function_to_empty, delete_file_path)
                        prompt_code = get_prompt_code(delete_file_path)
                        truncated_prompt1 = prompt_code[:max_length]
                        prompt_return = get_sol_return(delete_file_path, truncated_prompt1)
                        time.sleep(10)
                    else:
                        print(f"File not found for {extracted_file_name}")
            except Exception as e:
                print(f"Error:{e}")