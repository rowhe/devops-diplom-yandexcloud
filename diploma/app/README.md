### Этап третий - подготовка тестового приложения

1. Создаем [`Dockerfile`](docker/Dockerfile) с простой конфигураций сервера `nginx` отдающим статическую страницу

```text
FROM nginx:alpine

COPY default.conf /etc/nginx/conf.d/
COPY index.html /usr/share/nginx/html/

CMD ["nginx", "-g", "daemon off;"]
```

2. Также добавляем в репозиторий файл конфигурации [`default.conf`](docker/default.conf) и файл [`index.html`](docker/index.html)

3. Далее следует собрать образ и отправить его в registry DockerHub

```shell
$ cd docker
$ docker build -t rowhe/nginx_static_index:0.0.2 .

Sending build context to Docker daemon  4.096kB
Step 1/4 : FROM nginx:alpine
alpine: Pulling from library/nginx
63b65145d645: Pull complete
51f129e7c3f1: Pull complete
f32490ce40c5: Pull complete
d18f1b67600c: Pull complete
b793aaf052d0: Pull complete
10b0102e5979: Pull complete
ec50f2776186: Pull complete
Digest: sha256:ff07dba791a114f5d944c8455e8236ca4b184bfd8d21d90b7755a4ba0a119b06
Status: Downloaded newer image for nginx:alpine
 ---> fddf8c2fcb06
Step 2/4 : COPY default.conf /etc/nginx/conf.d/
 ---> 76d6eac0e768
Step 3/4 : COPY index.html /usr/share/nginx/html/
 ---> 9d9f6ac461fe
Step 4/4 : CMD ["nginx", "-g", "daemon off;"]
 ---> Running in 9bea7252bf6f
Removing intermediate container 9bea7252bf6f
 ---> 4f80752a2eb2
Successfully built 4f80752a2eb2
Successfully tagged rowhe/nginx_static_idex:0.0.2
```



```shell
$ docker push rowhe/nginx_static_index

The push refers to repository [docker.io/rowhe/nginx_static_index]
f0756d312c74: Pushed
175495e4dc90: Pushed
a7fcaf3114d5: Mounted from library/nginx
dff076fb6916: Mounted from library/nginx
d280bc8e13e2: Mounted from library/nginx
07a0bc54bc50: Mounted from library/nginx
2b5f63e9fb78: Mounted from library/nginx
3b6b66b66e55: Mounted from library/nginx
7cd52847ad77: Mounted from library/nginx
0.0.2: digest: sha256:91efabe17ece024823f470e9d4e25eb0d53d5c0f0a7fc326e086176d0f6a6671 size: 2195
```

4. Запустим контейнер и проверим его работу

```shell
docker run -d --rm -p 80:80 --name nginx rowhe/nginx_static_index:0.0.2 
```







### Создание тестового приложения

Для перехода к следующему этапу необходимо подготовить тестовое приложение, эмулирующее основное приложение разрабатываемое вашей компанией.

Способ подготовки:

1. Рекомендуемый вариант:  
   а. Создайте отдельный git репозиторий с простым nginx конфигом, который будет отдавать статические данные.  
   б. Подготовьте Dockerfile для создания образа приложения.  
2. Альтернативный вариант:  
   а. Используйте любой другой код, главное, чтобы был самостоятельно создан Dockerfile.

Ожидаемый результат:

1. Git репозиторий с тестовым приложением и Dockerfile.
2. Регистр с собранным docker image. В качестве регистра может быть DockerHub или [Yandex Container Registry](https://cloud.yandex.ru/services/container-registry), созданный также с помощью terraform.
