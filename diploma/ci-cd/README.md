## Этап пятый (последный) -Установка и настройка системы CI/CD


В качестве ситемы CI/CD будем использовать [`TeamCity`](https://www.jetbrains.com/teamcity/)

Произведем установку сервера `TeamCity`.

1. Созданим чарт [`helm`](https://helm.sh/)
![img.png](img/img.png)

```shell
[dpopov.dpopov] ➤ helm create te-si
Creating te-si

```

2. 


```shell
[dpopov.dpopov] ➤ helm install teamcity-server teamcity-server
NAME: teamcity-server
LAST DEPLOYED: Mon Apr  3 15:45:38 2023
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
```

3. Проверим работу `teamcity`

![teamcity_ready](img/img.png)

4. Получаем докен и полный доступ к серверу

```shell
[dpopov.dpopov] ➤ kubectl logs teamcity-server-54bb79f8d9-942r9 |grep token
[TeamCity] Super user authentication token: 1313************178 (use empty username with the token as the password to access the server)

```
