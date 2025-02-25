## Этап второй - Создание Kubernetes кластера

На данном этапе необходимо развернуть `Kubernetes` кластер, для данной задачи будем использовать набор конфигураций _Ansible_ [`Kubespray`](https://github.com/kubernetes-sigs/kubespray)

1. Клонирем `kubespray` командой `git clone https://github.com/kubernetes-sigs/kubespray`
2. Создаем конфигурацию своего кластера:

```shell
cd kubespray
cp inventory/sample inventory/netology
```

3. Выясняем айпи машин кластера на которые будет производится установка:

![instances](img/img_1.png)

4. Для установки необходимо указать конфигурацию кластера.

```shell
nano inventory/netology/hosts.yaml

all:
  hosts:
    node1:
      ansible_host: 158.160.44.213
      ip: 10.1.0.29
      ansible_user: ubuntu
      kubeconfig_localhost: true
    node2:
      ansible_host: 84.201.175.72
      ip: 10.1.0.3
      ansible_user: ubuntu
    node3:
      ansible_host: 158.160.53.255
      ip: 10.1.0.25
      ansible_user: ubuntu
    node3:
      ansible_host: 158.160.49.140
      ip: 10.1.0.12
      ansible_user: ubuntu
  children:
    kube_control_plane:
      hosts:
        node1:
    kube_node:
      hosts:
        node2:
        node3:
        node3:
    etcd:
      hosts:
        node1:
    k8s_cluster:
      children:
        kube_control_plane:
        kube_node:
    calico_rr:
      hosts: {}
```

5. Также необходимо предусмотреть генерацию сертификата для работы `kubectl`, укажем адрес управляющей ноды:

```shell
nano inventory/netology/group_vars/k8s_cluster/k8s-cluster.yml

supplementary_addresses_in_ssl_keys: [158.160.44.213]
```

6. После развертывания кластера скопируем локально в `.kube/config` файл конфигурации кластера Кубернетес `.kube/config` с управляющей ноды

7. Проверим подключение к кластеру `Kubernetes`

![kubectl](img/img_2.png)



## Итог: кластер `Kubernetes` запущен и работает на инстансах YandexCloud подготовленных при помощи `Terraform`

## Следующий этап - [подготовка тестового приложения](../app/README.md)

---