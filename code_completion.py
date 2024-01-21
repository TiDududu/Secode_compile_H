def remove_function_body(file_path, contract_name, function_name):
    with open(file_path, 'r') as file:
        lines = file.readlines()

    contract_found = False
    function_found = False

    for i in range(len(lines)):
        line = lines[i].strip()

        # 查找目标合约
        if line.startswith("contract " + contract_name):
            contract_found = True
            continue

        # 查找目标函数
        if contract_found and line.startswith("function " + function_name):
            function_found = True
            continue

        # 删除函数体
        if contract_found and function_found and "{" in line:
            lines[i] = lines[i].split("{")[0] + " {}\n"
            break

    # 写回文件
    with open(file_path, 'w') as file:
        file.writelines(lines)

# 示例用法
solidity_file_path = 'YourSolidityFile.sol'
contract_to_modify = 'YourContract'
function_to_empty = 'yourFunction'

remove_function_body(solidity_file_path, contract_to_modify, function_to_empty)
