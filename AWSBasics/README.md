# AWS Infrastructure Deployment using Terraform

---

# 🛠 Використані інструменти

- Terraform
- AWS CLI
- IAM User (Access Keys)
- Amazon Linux 2
- t2.micro instance

---

# 1️⃣ Створення та налаштування VPC (Terraform)

Було створено модуль VPC, який включає:

- VPC з CIDR `10.10.0.0/16`
- Public Subnet `10.10.1.0/24`
- Private Subnet `10.10.2.0/24`
- Internet Gateway
- Route Table з маршрутом:
- Прив’язку Route Table до public subnet

### Використані ресурси Terraform:
- `aws_vpc`
- `aws_subnet`
- `aws_internet_gateway`
- `aws_route_table`
- `aws_route_table_association`

---

# 2️⃣ Налаштування Security Group та ACL

## 🔹 Security Group

Створено Security Group з правилами:

### Inbound:
- HTTP (80) → 0.0.0.0/0
- SSH (22) → 0.0.0.0/0

### Outbound:
- Allow all traffic

Terraform ресурс:
- `aws_security_group`

---

## 🔹 Network ACL

Для публічної підмережі створено ACL з дозволами:

### Inbound:
- 80 (HTTP)
- 22 (SSH)
- Ephemeral ports (1024–65535)

### Outbound:
- Allow all

Terraform ресурси:
- `aws_network_acl`
- `aws_network_acl_rule`

---

# 3️⃣ Запуск інстансу EC2

Було створено модуль EC2 з параметрами:

- AMI: Amazon Linux 2 (динамічний вибір через `data "aws_ami"`)
- Instance type: `t2.micro`
- Підмережа: public subnet
- Security Group: створена раніше
- SSH Key: створений через `aws_key_pair`
- Призначення Elastic IP

Terraform ресурси:
- `aws_instance`
- `aws_key_pair`
- `aws_eip`
- `aws_eip_association`

---

# 4️⃣ Запуск Terraform

## Ініціалізація

```bash
terraform init
terraform plan
terraform apply
terraform destroy

ssh -i ~/.ssh/id_rsa ec2-user@<EIP_PUBLIC_IP>
```
