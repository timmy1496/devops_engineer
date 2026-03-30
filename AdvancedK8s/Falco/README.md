# Налаштування та перевірка Falco в Kubernetes (Minikube)

## Мета роботи
Розгорнути Falco у Kubernetes за допомогою **DaemonSet** для моніторингу подій безпеки на кожному вузлі та перевірити його коректну роботу.

---

## Короткий опис виконаних кроків

- Запущено локальний Kubernetes-кластер за допомогою **Minikube**
- Встановлено та налаштовано `kubectl`
- Створено DaemonSet для Falco у namespace `kube-system`
- Falco запущено з привілейованим доступом (`privileged`, `hostPID`, `hostNetwork`)
- Змонтовано системні директорії хоста:
    - `/proc`
    - `/boot`
    - `/lib/modules`
    - `/usr`
    - `/var/run/docker.sock`
- Встановлено обмеження ресурсів:
    - Requests: `100m CPU`, `128Mi memory`
    - Limits: `100m CPU`, `256Mi memory`
- Falco розгорнуто командою:
  ```bash
  kubectl apply -f falco-daemonset.yaml
