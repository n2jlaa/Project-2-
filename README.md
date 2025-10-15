# 🚀 DevOps Project 2 — Secure 3-Tier Web App on Azure (Container Apps)

## 🧠 Overview  
This project demonstrates a **production-style 3-tier web application** deployed fully on **Microsoft Azure**, following DevOps best practices — including IaC with Terraform, containerization with Docker, and automation pipelines via GitHub Actions.  

The application is a **Burger Builder** web app built with:
- 🖥️ **Frontend:** React + Vite + TypeScript + Nginx  
- ⚙️ **Backend:** Java + Spring Boot + Maven  
- 💾 **Database:** Azure SQL Database (private endpoint only)  
- ☁️ **Hosting:** Azure Container Apps (private environment, internal load balancer)  
- 🌐 **Ingress:** Application Gateway WAF v2 (HTTPS only)  

---

## 🏗️ Architecture

### 🔹 Components
| Tier | Service | Description |
|------|----------|-------------|
| **Frontend** | Azure Container App (React + Vite + Nginx) | Serves the UI and communicates with backend through `/api` |
| **Backend** | Azure Container App (Spring Boot) | REST API for burger ingredients & orders |
| **Database** | Azure SQL Database | Stores app data; access restricted to VNet only |
| **Networking** | VNet + Subnets + NSGs | Frontend, backend, SQL each in its own subnet |
| **Ingress** | Application Gateway (WAF v2) | Only public entry point; routes `/` → frontend, `/api/*` → backend |
| **Monitoring** | Log Analytics + Application Insights | Centralized logging and metrics |
| **Registry** | Azure Container Registry (ACR) | Stores built Docker images |

---

## 🧩 Architecture Diagram

```mermaid
graph TD
  User[👩‍💻 User] -->|HTTPS| AppGW[Azure Application Gateway WAFv2]
  AppGW -->|/ →| FE[Frontend - React/Vite Container App]
  AppGW -->|/api/* →| BE[Backend - Java Spring Boot Container App]
  FE --> BE
  BE -->|JDBC over Private Endpoint| SQL[(Azure SQL Database)]
  subgraph Azure VNet
    FE
    BE
    SQL
  end
  ACR[Azure Container Registry] --> FE
  ACR --> BE
  LA[Log Analytics Workspace] --> FE
  LA --> BE
```

---

## ⚙️ Infrastructure Automation (Terraform)

### 📁 File Structure

```
infra/
├── main.tf
├── providers.tf
├── variables.tf
├── terraform.tfvars
├── outputs.tf
├── network.tf
├── sql.tf
├── containerapps.tf
├── appgw.tf
└── monitor.tf
```

### ✅ Main Terraform Tasks
- Create Resource Group, VNet, and Subnets (frontend, backend, appgw, sql)
- Deploy Application Gateway (WAF v2)
- Deploy Azure SQL Database (Private Endpoint)
- Deploy Azure Container Apps Environment (internal load balancer)
- Deploy Frontend & Backend Container Apps
- Configure Private DNS zones for ACA and SQL
- Integrate Log Analytics Workspace
- Output FQDNs and AppGW Public IP

---

## 🧱 Containerization (Docker)

### 🐳 Backend — `backend/Dockerfile`
```Dockerfile
FROM maven:3.9.4-eclipse-temurin-17 AS build
WORKDIR /app
COPY backend/pom.xml .
COPY backend/src ./src
RUN mvn clean package -DskipTests

FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]
```

### 🐳 Frontend — `frontend/Dockerfile`
```Dockerfile
FROM node:20-alpine AS build
WORKDIR /app
COPY frontend/package*.json ./
RUN npm ci
COPY frontend/. .
RUN npm run build

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY frontend/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

---

## 🔐 Environment Variables

### 📦 Backend (.env example)
```env
DB_HOST=devopsproj2najla-sqlsrv.database.windows.net
DB_NAME=devopsproj2najla-db
DB_PORT=1433
DB_USERNAME=sqladminuser
DB_PASSWORD=<your_password>
SPRING_PROFILES_ACTIVE=azure
```

### 💻 Frontend (.env)
```env
VITE_API_BASE=/api
```

> ✅ The Application Gateway automatically routes `/api` traffic to the backend Container App.

---

## 🚀 Deployment Workflow

### 🔹 1. Build & Push Images
```bash
# Frontend
docker build -f frontend/Dockerfile -t devopsproj2najlaacr.azurecr.io/frontend:v1 .
docker push devopsproj2najlaacr.azurecr.io/frontend:v1

# Backend
docker build -f backend/Dockerfile -t devopsproj2najlaacr.azurecr.io/backend:v1 .
docker push devopsproj2najlaacr.azurecr.io/backend:v1
```

### 🔹 2. Deploy Infrastructure
```bash
cd infra
terraform init
terraform plan
terraform apply -auto-approve
```

### 🔹 3. Validate Deployment
```bash
# Show outputs
terraform output

# Check Container Apps
az containerapp list -g rg-najla-devopsproj2 -o table

# Verify health
curl -I http://<AppGW_IP>/api/health
curl -I http://<AppGW_IP>/api/ingredients
```

---

## 🧭 Application Gateway Routing
| Path | Target | Description |
|------|---------|-------------|
| `/` | Frontend Container App | Main Burger Builder UI |
| `/api/*` | Backend Container App | REST API endpoints |

---

## 📊 Monitoring & Alerts
- Log Analytics Workspace + Application Insights
- Alerts configured for:
  - App Gateway backend health
  - CPU usage > 70%
  - SQL DTU > 80%

---

## ✅ Validation Checklist
- [x] SQL Private Endpoint (Public access disabled)
- [x] Container Apps in private subnet
- [x] Application Gateway WAFv2 routing correct
- [x] Terraform automated full deployment
- [x] App Insights integrated with Container Apps

---

## 🌟 Result
Application is fully functional at:

**Frontend:**  
👉 `http://48.210.248.193` (via App Gateway)

**Backend:**  
👉 `https://devopsproj2najla-backend.wonderfulpebble-d34e3f53.japaneast.azurecontainerapps.io/api/health`

**Database:**  
Private SQL Endpoint — accessible only from inside VNet.

---

## 👩‍💻 Author
**Najlaa Alahmari**  
DevOps Engineer | Ironhack Azure Bootcamp Graduate  
🔗 [GitHub: n2jlaa](https://github.com/n2jlaa)
