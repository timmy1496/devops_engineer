## Мета

Встановити й налаштувати вебсервер **Nginx** через офіційний репозиторій, протестувати його роботу, змінити конфігурацію без перезапуску, а також виконати додаткове завдання: змонтувати новий розділ для статики сайту (WordPress).

---

## Встановлення Nginx

### Кроки

```bash
sudo apt update
sudo apt install nginx
```

### Результат

Перехід на `http://localhost` відкриває **домашню сторінку Nginx**.

---

## Додавання та видалення PPA

### Додано PPA:

```bash
sudo add-apt-repository ppa:nginx/stable
sudo apt update
sudo apt install nginx
```

### Повернення до офіційного пакету:

```bash
sudo apt install ppa-purge
sudo ppa-purge ppa:nginx/stable
```

---

## Перевірка сервісу Nginx

### Запуск / зупинка / статус

```bash
sudo systemctl start nginx
sudo systemctl stop nginx
sudo systemctl restart nginx
sudo systemctl status nginx
```

### Автозапуск

```bash
sudo systemctl enable nginx
```

Nginx керується через `systemd` як сервіс `nginx.service`.

---

## Файлові дескриптори

```bash
sudo lsof -p $(pidof nginx)
```

Вивід показує:

- сокети `TCP *:80` — обробка HTTP-запитів
- конфіг-файли `/etc/nginx/nginx.conf`, `mime.types`
- логи `/var/log/nginx/access.log`, `error.log`
- модулі та PID-файли

---

## Логи Nginx

```bash
sudo tail -f /var/log/nginx/error.log
sudo tail -f /var/log/nginx/access.log
```

---

## Зміна конфігурації без перезапуску

```bash
sudo nginx -t
sudo nginx -s reload
```

Можна змінювати конфігурацію і **перезавантажити без даунтайму**, використовуючи `nginx -s reload` — старі воркери завершують обробку, нові стартують з оновленим конфігом.

---

## Додаткове завдання: монтування розділу

### Створено новий диск у VirtualBox (наприклад `/dev/sdb`)

```bash
sudo fdisk /dev/sdb
sudo mkfs.ext4 /dev/sdb1
sudo mkdir /mnt/wpdata
sudo mount /dev/sdb1 /mnt/wpdata
```

### Автомонтування через `/etc/fstab`

```bash
echo '/dev/sdb1 /mnt/wpdata ext4 defaults 0 2' | sudo tee -a /etc/fstab
```

---

## Розміщення статичних файлів

### Встановлено WordPress у `/mnt/wpdata`

```bash
cd /mnt/wpdata
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
mv wordpress/* .
rm -rf wordpress latest.tar.gz
```

---

## Налаштування Nginx для WordPress

### Файл конфігурації: `/etc/nginx/sites-available/wpdata`

```nginx
server {
    listen 80;
    server_name localhost;
    root /mnt/wpdata;
    index index.php index.html;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_pass unix:/run/php/php8.3-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
```

### Активація:

```bash
sudo ln -s /etc/nginx/sites-available/wpdata /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default
sudo nginx -t && sudo systemctl reload nginx
```

---

## Результат

- Nginx працює і обробляє запити з нового змонтованого розділу
- Статичний сайт WordPress відкривається на `http://localhost`
- Виконано перемикання між версіями nginx (ppa ↔ офіційна)
- Перевірено права, логи, файлові дескриптори, конфіг без рестарту
