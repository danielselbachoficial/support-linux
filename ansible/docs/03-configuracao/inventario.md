# Configuração do Inventário

O inventário é o coração do Ansible. É onde você define quais servidores serão gerenciados.

## O que é um Inventário?

Um inventário é um arquivo que contém:

- **Hosts**: Servidores que serão gerenciados
- **Grupos**: Agrupamentos lógicos de hosts
- **Variáveis**: Dados específicos de hosts ou grupos

## Estrutura Básica

### Formato INI
```ini
[webservers]
web01.example.com
web02.example.com

[databases]
db01.example.com
db02.example.com
```

### Formato YAML
```yaml
all:
  children:
    webservers:
      hosts:
        web01.example.com:
        web02.example.com:
    databases:
      hosts:
        db01.example.com:
        db02.example.com:
```

## Criando seu Primeiro Inventário

### Passo 1: Criar Diretório
```bash
mkdir -p ~/ansible
cd ~/ansible
```

### Passo 2: Criar Arquivo de Inventário
```bash
nano hosts
```

### Passo 3: Adicionar Hosts
```bash
[proxmox]
192.168.1.100
192.168.1.101

[webservers]
web01 ansible_host=192.168.1.200
web02 ansible_host=192.168.1.201

[databases]
db01 ansible_host=192.168.1.210
db02 ansible_host=192.168.1.211
```

## Variáveis de Inventário

### Variáveis de Host
Defina variáveis específicas para cada host:
```ini
[webservers]
web01 ansible_host=192.168.1.200 ansible_user=ubuntu nginx_port=80
web02 ansible_host=192.168.1.201 ansible_user=ubuntu nginx_port=8080
```

### Variáveis de Grupo
Defina variáveis para todos os hosts de um grupo:
```ini
[webservers]
web01 ansible_host=192.168.1.200
web02 ansible_host=192.168.1.201

[webservers:vars]
ansible_user=ubuntu
ansible_become=yes
ansible_become_method=sudo
http_port=80
max_clients=200
```

## Parâmetros Importantes

### Conexão
| Parâmetro                      | Descrição                 | Padrão                 |   
|--------------------------------|---------------------------|------------------------|
| ansible_host                   | IP ou hostname            | Nome do host           |
| ansible_port                   | Porta SSH                 | 22                     |
| ansible_user                   | Usuário SSH               | root                   |
| ansible_password               | Senha SSH                 | nenhuma                |
| ansible_ssh_private_key_file   | Arquivo de chave privada  | ~/.ssh/id_rsa          |
