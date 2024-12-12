from selenium import webdriver
from selenium.webdriver.common.keys import Keys 
import time
import datetime
import os
from selenium.webdriver.chrome.service import Service
service=Service('C:\\Users\\anshu\\Downloads\\chromedriver-win64\\chromedriver-win64\\chromedriver.exe')
#Create a driver and return the driver
def get_driver():
    options=webdriver.ChromeOptions()
    options.add_argument("disable-infobars")
    options.add_argument("start-maximised")
    options.add_argument("disable-dev-shm-usage")
    options.add_argument("no-sandbox") #Browsers for security called sandboxing, if our script needs to have higher privileges we need to diable sandboxing
    options.add_experimental_option("excludeSwitches",["enable-automation"]) #Avoid detection from browser, some browsers dont allow scripts, now scripts enabled to access browsers
    options.add_argument("disable-blink-features=AutomationControlled")
    driver=webdriver.Chrome(service=service,options=options)
    driver.get("https://automated.pythonanywhere.com/login/")
    return driver

def savefile(text):
    ts=datetime.datetime.today().strftime('%Y-%m-%d')
    filename=os.getcwd()+"/"+str(ts)+".txt"
    outfile=open(filename,'w')
    outfile.write(text)
    outfile.close()
    print(filename)


def main():
    driver=get_driver()
    driver.find_element(by="id",value="id_username").send_keys("automated") #Automating the login process
    time.sleep(2)
    driver.find_element(by="id",value="id_password").send_keys("automatedautomated"+Keys.RETURN) #Presses the enter key
    time.sleep(3)
    driver.find_element(by="xpath",value="/html/body/nav/div/a").click() #Clicks the home page
    time.sleep(3)
    values=driver.find_element(by="xpath",value="/html/body/div[1]/div/h1[2]").text #Scrape the temperature at home page
    savefile(values)


main()
