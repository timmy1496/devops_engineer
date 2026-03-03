# AWS Infrastructure Deployment using CloudFormation

---

## VPC

Було створено:

- VPC з CIDR **10.0.0.0/16**
- Публічну підмережу **10.0.1.0/24**
- Internet Gateway
- Route Table з маршрутом `0.0.0.0/0 → IGW`

EC2 у публічній підмережі має доступ до інтернету.

---

## EC2 інстанс

- AMI: **Amazon Linux 2**
- Тип: **t3.micro**
- Розгорнутий у публічній підмережі
- Призначено IAM Role
- Отримано Public IP

---

## IAM Role

- Створено роль для EC2
- Додано політику **AmazonS3ReadOnlyAccess**
- Роль прив’язано до інстансу

EC2 має доступ на читання з S3.

---

## S3 Bucket

- Створено приватний bucket з унікальним ім’ям
- Увімкнено **Versioning**
- Увімкнено **Block Public Access**
- Налаштовано Bucket Policy для обмеження доступу

---

## Outputs

CloudFormation виводить:

- Public IP EC2 інстанса
- Назву S3 bucket

---