from locust import HttpUser, task, between

class StressTest(HttpUser):
    wait_time = between(1, 3)

    @task
    def listar_pacientes(self):
        self.client.get("/api/pacientes")

    @task
    def listar_medicos(self):
        self.client.get("/api/medicos")

    @task
    def crear_paciente(self):
        self.client.post("/api/pacientes", json={
            "nombre": "Test",
            "apellido": "User",
            "fecha_nacimiento": "1990-01-01",
            "email": f"test_{self.environment.runner.user_count}@mail.com"
        })
