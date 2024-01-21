import os
import openai
import requests
import json


OPENAI_API_KEY = "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"

model_id = "gpt-3.5-turbo"#看你的需求，有些代码能力特化的模型可以选

# 统一prompt
prompt = "your-prompt-here"

#文件夹路径,里面保存了一系列txt文件
folder_path = "your-folder-path-here"

def interact_with_chatgpt(prompt, text):
    response = openai.Completion.create(
        engine=model_id,
        prompt=prompt + text,#每个文件内容都有相同prompt头
        max_tokens=1024,
        n=1,
        stop=None,
        temperature=0.5,
    )
    return response["choices"][0]["text"]

#依次读取并输出到文件里
for filename in os.listdir(folder_path):
    if filename.endswith(".txt"):
        with open(os.path.join(folder_path, filename), "r") as f:
            text = f.read()
        response = interact_with_chatgpt(prompt, text)
        with open(os.path.join(folder_path, f"response_{filename}"), "w") as f:
            f.write(response)
