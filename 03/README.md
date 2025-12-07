# 🛠️ Домашня робота: Інтеграція Jenkins для CI/CD Java-проєкту

## 📌 Завдання

Мета завдання:

1. Ознайомитися з основами Jenkins.
2. Налаштувати Freestyle Pipeline для автоматизації.
3. Використати декларативний пайплайн для побудови CI/CD-процесу.
4. Додати нотифікації в Telegram про статус виконання білда.

---

## Стек технологій

- Docker
- Docker Compose
- Jenkins
- Maven
- Telegram Bot API (нотифікації)
- Jenkins Declarative Pipeline

---

# Підготовка до роботи

### Встановити:

- Docker + Docker Compose

### Запустити Jenkins:

1.
```bash
docker-compose up -d
```
2. Відкрити у браузері: `http://localhost:8080`
3. Ввести початковий пароль з контейнера:
```bash
docker exec -it jenkins bash
cat /var/jenkins_home/secrets/initialAdminPassword
```
4. Встановити рекомендовані плагіни
5. Створити адміністративного користувача

### Створення Freestyle job:

1. Натиснути "New Item"
2. Ввести назву job(Simple Freestyle Job), обрати "Freestyle project", натиснути "OK"
3. Source Code Management" обрати "Git"(форкнутий репозиторій), ввести URL (вказати main branch)
4. "Build" додати "Invoke top-level Maven targets", вказати `clean install` та execute shell `cd complete`
5. Post-build Actions вказати Archive the artifacts `complete/target/*.jar`

### Створення Simple Declarative Pipeline job:

1. Натиснути "New Item"
2. Ввести назву job(Simple Declarative Pipeline), обрати "Pipeline"
3. Pipeline вибрати "Pipeline script" та вставити код з `Jenkinsfile`

### Створити Telegram-бота:

1. Написати `@BotFather` у Telegram
2. Команда: `/newbot`
3. Отримати `BOT_TOKEN`
4. Написати щось боту
5. Зробити запит на: https://api.telegram.org/bot<BOT_TOKEN>/getUpdates
6. Скопіювати `chat_id` з респонсу