# 1 Этап

1. Для дипломного проекта создаю репозиторий на [GitHub](https://github.com/rowhe/devops-diplom-yandexcloud.git) для хранения конфигурационных файлов `Terraform` и для удобства использования помещаю их в отдельную директорию `diploma/terraform` 


2. Создаю бэкэнд "diploma-yc" для хранения состояния инфраструктуры при помощи [Terraform Cloud](https://app.terraform.io/):

![diploma-yc](img/img.png)

3. Далее добавляю воркспейс "stage":

![ws_stage](img/img_1.png)

4. Также добавляю необходимые переменные для подключения к YandexCloud:

![variables](img/img_2.png)

5. Запускаем создание инфраструктуры

![run](img/img_3.png)

6. Убеждаемся, что все сработало и инфраструктура создалась.

![done](img/img_4.png)

## Вывод:

Инфраструктура успешно создается при помощи `Terraform`

Перейдем к следующему этапу [развертывания](../ansible/README.md) `Kubernetes` на подготовленной инфраструктуре