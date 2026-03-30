# EKS Infrastructure Deployment via Terraform

---

# Створення кластера EKS

Кластер було створено за допомогою Terraform (модуль `terraform-aws-modules/eks/aws`).

### Основні параметри:

- Kubernetes version: 1.35
- 2 worker nodes
- Тип інстансів: `t3.medium`
- Node Group розгорнуто у публічних підмережах
- Включено IRSA (IAM Roles for Service Accounts)
- Підключено EBS CSI Driver
