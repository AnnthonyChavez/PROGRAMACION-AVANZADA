from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
import time

driver = webdriver.Chrome()
driver.get("http://127.0.0.1:5500/index.html")  # Cambia la ruta al frontend

# Ejemplo: llenar formulario de paciente
driver.find_element(By.ID, "nombre").send_keys("Juan")
driver.find_element(By.ID, "apellido").send_keys("Pérez")
driver.find_element(By.ID, "fecha_nacimiento").send_keys("1985-05-10")
driver.find_element(By.ID, "email").send_keys("juan.perez@mail.com")
driver.find_element(By.ID, "submit").click()

time.sleep(2)
driver.quit()
