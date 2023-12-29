# Opika Devops Test

## Test 1: Multi-Language Microservice Deployment

- I created a 3-tier application that includes Nodejs, Python, and Postgres. In this microservices deployment, the node application(user-facing) will get the list of numbers and send it to the Python application deployed in its backend. The Python app will get the numbers, sort them, and send them back to the node app as a response and store the sorted numbers in the Postgres database. I don’t have much knowledge of Go that’s why I’ve implemented Postgres in this case. But I just tried to containerize a sample hello-world go application.
    


- These applications are containerized and have a docker-compose file to deploy in a microservice format.

### Steps to run this task:

```bash
git clone https://github.com/rp-arun/devops-test.git
```

```bash
cd apps-source-code/
```

```bash
docker-compose up
```

**Create a table in the psql:**
```bash
psql postgres://postgres:postgres@localhost:5432/postgres
```
```sql
CREATE TABLE numbers (
id SERIAL PRIMARY KEY,
sorted_numbers integer[]
);
```

**To test:**

```bash
curl -X POST -H \
'Content-Type: application/json' -d '{"numbers":[3,2,1]}' \
http://localhost:3000/numbers
```

## Test 2: Infrastructure as Code for CI/CD Pipeline

- Created **GitHub Actions** CICD for all these applications that will build and push the docker images in **Dockerhub**.
    
    > code available in **.github/workflows/cicd.yml**
    > 
- The entire micro-services are deployed in **Aws-managed Kubernetes services (EKS)** and their node groups are deployed in **private subnets** to ensure the security. For user access a **loadbalancer is created with internet facing**. And automated the infra creation using **Terraform**.
- Implemented **Gitops** strategy using **ArgoCD** to automate the **Continuous Delivery** process.
- **ArgoCD** is a Continuous Delivery tools that continuously watch the GitHub repository, if it deducts any file change it will sync the deployments inside the Kubernetes cluster.


### Steps to run this task:

- To make the infra up do the following steps

```bash
git clone https://github.com/rp-arun/devops-test.git
```

```bash
cd infra/environments/opika/
```

```bash
terraform init
terraform plan
terraform apply
```

Add the necessary variables like aws role, secret key, and access keys.

- Installed the ArgoCD with helm chart and mapped to the same repository and path where our Kubernetes manifests are stored that will automatically sync the applications.

## Access:

### Application:

The user-facing NodeJs application is exposed as a load-balancer service and has an IP address for the user to access.

**To access the app:**

```bash
curl -X POST -H 'Content-Type: application/json' \
-d '{"numbers":[3,2,1]}' \
a4e07024cdfb9418da425c1098eaad71-884038150.us-west-2.elb.amazonaws.com/numbers
```

**To access ArgoCD:**

Link: [ArgoCd](https://aa73a2c9a73b943db8cf7973233c000f-1477094297.us-west-2.elb.amazonaws.com/applications)

*SSL is not enabled so, please click on advanced and proceed with the link.*

Username: admin

Password: cPzkzzOdOJ3ne1x8
