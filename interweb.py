from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

# 创建WebDriver实例（使用Chrome示例）
driver = webdriver.Chrome()

# 打开登录页面
driver.get("登录页面URL")

# 找到并点击登录按钮
login_button = driver.find_element_by_id("login_button_id")
login_button.click()

# 等待页面跳转完成
# 在此等待期间，你可以添加条件，确保跳转完成后再继续执行后续操作
try:
    # 等待目标元素加载（例如，可以等待输入框的出现）
    element_present = EC.presence_of_element_located((By.ID, 'prompt-textarea'))
    WebDriverWait(driver, timeout=10).until(element_present)

    # 在页面跳转完成后，继续执行输入操作
    input_box = driver.find_element_by_id("prompt-textarea")

    # 从文件中读取内容并输入到输入框
    with open("your_file.txt", "r") as file:
        file_content = file.read()

    input_box.send_keys(file_content)

    # 执行其他操作，如果有的话

except Exception as e:
    print(f"An error occurred: {e}")

# 关闭浏览器窗口
driver.quit()
