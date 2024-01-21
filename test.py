from openai import OpenAI
import os
import csv
import time

client = OpenAI(
    # defaults to os.environ.get("OPENAI_API_KEY")
    api_key="sk-inFcgSc24xxZ99Pf8uTXk6ka6ftaeDeu92Y7kVSZEmNKDJig",
    # api_key="sk-FlSHXKP3VW5ydnzVGYEhwWQKUs5N6OsVUkjsoDppVhl0bFDm",
    base_url="https://api.chatanywhere.tech/v1"
)


def gpt_35_api(messages: list):
    """为提供的对话消息创建新的回答

    Args:
        messages (list): 完整的对话消息
    """
    completion = client.chat.completions.create(model="gpt-3.5-turbo-1106", messages=messages)
    print(completion.choices[0].message.content)


prompt_description = '''
Summarize the functionality of the given Solidity contract, providing details on all implemented functions along with their respective functionalities. Clearly state the primary functionality in the format "You need to...".Format the output as follows to ensure it can be effectively used to reconstruct the original code:

Primary functionality: ...
1. Function name, Functionality;
2. Function name, Functionality;
...

Note: Do not include any information regarding vulnerabilities in the output.Exclude any mention of vulnerabilities or comments related to security issues in the output.
'''

prompt_gen = '''
I want you to act as a blockchain developer.I will provide you with a description of the functionality of a Solidity code along with a summary of its code functions. The information format is as below:

Primary functionality(Contract Functionality Overview): ...
1. Function name, Functionality;
2. Function name, Functionality;

Please generate complete and executable Solidity code based on the provided information. Your response should be and only be pure codes, without any comments or annotations.
You need to use pragma solidity ^0.4.26. Your response should restrictly follow the format below:

pragma solidity ^0.4.26;
<code here (every function should be complete and exclude any annotation)>
Note: provide a full code without omitting any details. 
Most important: make sure to include all details in the code.
Ensure that all aspects of the function, including input validation, logic, and return statements, are fully included in the generated code.
'''

# vulner_deduplicate = './vulue.csv'
# contract_folder = './vulue'
# return_folder = './test_return_ue'
# regen_folder = './regen_return_ue'

# vulner_deduplicate = './vulETH.csv'
# contract_folder = './vulLETH'
# return_folder = './test_return_LETH'
# regen_folder = './regen_return_LETH'

# vulner_deduplicate = './vulaf.csv'
# contract_folder = './vulaf'
# return_folder = './test_return_af'
# regen_folder = './regen_return_af'

# vulner_deduplicate = './vullock.csv'
# contract_folder = './vullock'
# return_folder = './test_return_lock'
# regen_folder = './regen_return_lock'

# vulner_deduplicate = './vulundel.csv'
# contract_folder = './vulundel'
# return_folder = './test_return_undel'
# regen_folder = './regen_return_undel'

# vulner_deduplicate = './vulunself.csv'
# contract_folder = './vulunself'
# return_folder = './test_return_unself'
# regen_folder = './regen_return_unself'

vulner_deduplicate = './vulbd.csv'
contract_folder = './vulbd'
return_folder = './test_return_vulbd'
regen_folder = './regen_return_vulbd'


def get_prompt_code(file_path):
    if os.path.exists(file_path):
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as file:
            prompt_code = file.read()

    return prompt_code


def get_gpt_return(file_path, prompt):
    global count_dscrb
    timeout_seconds = 120
    folder, file_name = os.path.split(file_path)
    # save_folder = os.path.join(return_folder, folder.split(os.path.sep, 1)[1])
    os.makedirs(return_folder, exist_ok=True)
    save_file_path = os.path.join(return_folder, os.path.splitext(file_name)[0]) + '.txt'
    if os.path.exists(save_file_path):
        return ''

    messages = [{'role': 'system', 'content': prompt_description}, {'role':'user','content':prompt},]
    completion = client.chat.completions.create(model="gpt-3.5-turbo-1106", messages=messages, timeout=timeout_seconds, temperature=0.2)
    content = completion.choices[0].message.content

    with open(save_file_path, 'w') as file:
        print(save_file_path)
        file.write(content)
        count_dscrb += 1
        print(f"Success:{count_dscrb}")

    return content

def get_sol_return(file_path, prompt):
    global count_gen
    timeout_seconds = 120
    folder, file_name = os.path.split(file_path)
    # save_folder = os.path.join(regen_folder, folder.split(os.path.sep, 1)[1])
    os.makedirs(regen_folder, exist_ok=True)
    save_file_path = os.path.join(regen_folder, os.path.splitext(file_name)[0]) + '.sol'
    if os.path.exists(save_file_path):
        return ''

    messages = [{'role': 'system', 'content': prompt_gen}, {'role':'user','content':prompt},]
    completion = client.chat.completions.create(model="gpt-3.5-turbo-1106", messages=messages, timeout=timeout_seconds, temperature=0.2)
    content = completion.choices[0].message.content

    with open(save_file_path, 'w') as file:
        print(save_file_path)
        file.write(content)
        count_gen += 1
        print(f"Success_gen:{count_gen}")

    return content


if __name__ == '__main__':
    count_dscrb = 0
    count_gen = 0
    flag = 0
    max_length = 4096
    with open(vulner_deduplicate, 'r') as csv_file:
        csv_reader = csv.reader(csv_file)
        for row in csv_reader:
            try:
                if row:
                    file_name = row[0]
                    extracted_file_name = file_name.split()[0]
                    sol_file_path = os.path.join(contract_folder, f"{extracted_file_name}.sol")
                    # 检查文件是否存在
                    if os.path.exists(sol_file_path):
                        print(f"Found file for {extracted_file_name}: {sol_file_path}")
                        prompt_code = get_prompt_code(sol_file_path)
                        truncated_prompt1 = prompt_code[:max_length]
                        prompt_return = get_gpt_return(sol_file_path, truncated_prompt1)
                        # time.sleep(60)
                        if True:
                            print("Gen...")
                            dscrb_file_path = os.path.join(return_folder, f"{extracted_file_name}.txt")
                            prompt_dscrb = get_prompt_code(dscrb_file_path)
                            truncated_prompt2 = prompt_dscrb[:max_length]
                            prompt_return = get_sol_return(dscrb_file_path, truncated_prompt2)
                        else:
                            print(f"Failed Describe {extracted_file_name}")
                        time.sleep(10)
                    else:
                        print(f"File not found for {extracted_file_name}")
            except Exception as e:
                print(f"Error:{e}")
    
        
        
        
