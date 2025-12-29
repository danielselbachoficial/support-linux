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

### Privilégios
| Parâmetro                      | Descrição                 | 
|--------------------------------|---------------------------|
| ansible_become                 | Usar sudo/su              |
| ansible_become_method          | Método (sudo, su, doas)   |
| ansible_become_user            | Usuário para escalação    |
| ansible_become_password        | Senha para escalação      |

### Python
| Parâmetro                      | Descrição                 | 
|--------------------------------|---------------------------|
| ansible_python_interpreter     | Caminho do Python         |
| ansible_shell_type             | Tipo de shell             |


## Exemplos

### Exemplo de inventário completo em INI
```ini
# Grupo de servidores Proxmox
[proxmox]
pve01 ansible_host=192.168.1.100 ansible_user=root
pve02 ansible_host=192.168.1.101 ansible_user=root
pve03 ansible_host=192.168.1.102 ansible_user=root

[proxmox:vars]
ansible_python_interpreter=/usr/bin/python3
ansible_connection=ssh
ansible_port=22

# Grupo de servidores web
[webservers]
web01 ansible_host=192.168.1.200 nginx_port=80
web02 ansible_host=192.168.1.201 nginx_port=8080
web03 ansible_host=192.168.1.202 nginx_port=80

[webservers:vars]
ansible_user=ubuntu
ansible_become=yes
ansible_become_method=sudo
http_port=80
max_clients=200

# Grupo de bancos de dados
[databases]
db01 ansible_host=192.168.1.210 db_role=primary
db02 ansible_host=192.168.1.211 db_role=replica

[databases:vars]
ansible_user=ubuntu
ansible_become=yes
db_engine=mysql
db_port=3306

# Grupo de produção (combina outros grupos)
[production:children]
webservers
databases

# Grupo de staging
[staging]
staging01 ansible_host=192.168.1.50

# Todos os hosts
[all:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
```

### Exemplo de inventário completo em YAML
```yaml
all:
  children:
    proxmox:
      hosts:
        pve01:
          ansible_host: 192.168.1.100
          ansible_user: root
        pve02:
          ansible_host: 192.168.1.101
          ansible_user: root
        pve03:
          ansible_host: 192.168.1.102
          ansible_user: root
      vars:
        ansible_python_interpreter: /usr/bin/python3
        ansible_connection: ssh
        ansible_port: 22
    
    webservers:
      hosts:
        web01:
          ansible_host: 192.168.1.200
          nginx_port: 80
        web02:
          ansible_host: 192.168.1.201
          nginx_port: 8080
        web03:
          ansible_host: 192.168.1.202
          nginx_port: 80
      vars:
        ansible_user: ubuntu
        ansible_become: yes
        ansible_become_method: sudo
        http_port: 80
        max_clients: 200
    
    databases:
      hosts:
        db01:
          ansible_host: 192.168.1.210
          db_role: primary
        db02:
          ansible_host: 192.168.1.211
          db_role: replica
      vars:
        ansible_user: ubuntu
        ansible_become: yes
        db_engine: mysql
        db_port: 3306
    
    production:
      children:
        - webservers
        - databases
    
    staging:
      hosts:
        staging01:
          ansible_host: 192.168.1.50
  
  vars:
    ansible_ssh_common_args: '-o StrictHostKeyChecking=no'
```

---
## Organizando Inventários de projetos com boas práticas

Para projetos maiores, organize em diretórios:
```ini
inventory/
├── production/
│   ├── hosts.yml
│   ├── group_vars/
│   │   ├── all.yml
│   │   ├── webservers.yml
│   │   └── databases.yml
│   └── host_vars/
│       ├── web01.yml
│       └── db01.yml
├── staging/
│   ├── hosts.yml
│   └── group_vars/
│       └── all.yml
└── development/
    ├── hosts.yml
    └── group_vars/
        └── all.yml
```

#### Arquivo: inventory/production/hosts.yml
```yaml
all:
  children:
    webservers:
      hosts:
        web01:
          ansible_host: 192.168.1.200
        web02:
          ansible_host: 192.168.1.201
    databases:
      hosts:
        db01:
          ansible_host: 192.168.1.210
```

#### Arquivo: inventory/production/group_vars/webservers.yml
```yaml
---
ansible_user: ubuntu
ansible_become: yes
ansible_become_method: sudo
nginx_version: latest
ssl_enabled: true
ssl_enabled: true
```

#### Arquivo: inventory/production/host_vars/web01.yml
```yaml
---
nginx_port: 80
server_role: primary
```

### Testando o Inventário

#### Listar todos os hosts
```bash
ansible-inventory -i hosts --list
```

#### Listar hosts de um grupo
```bash
ansible-inventory -i hosts --graph webservers
```

#### Verificar variáveis de um host
```bash
ansible-inventory -i hosts --host web01
```

### Padrões de Seleção

Ao executar comandos, você pode selecionar hosts de várias formas:

#### Todos os hosts
```bash
ansible all -i hosts -m ping
```

#### Um grupo específico
```bash
ansible webservers -i hosts -m ping
```

#### Múltiplos grupos
```bash
ansible webservers,databases -i hosts -m ping
```

#### Padrão de nome
```bash
ansible "web*" -i hosts -m ping
```

#### Exclusão
```bash
ansible all -i hosts -m ping --limit "!databases"
```

#### Intervalo
```bash
ansible webservers[0:2] -i hosts -m ping
```

### Boas Práticas

#### ✅ Faça
- Use nomes descritivos para hosts e grupos
- Organize em ambientes (production, staging, development)
- Use variáveis para dados reutilizáveis
- Documente o propósito de cada grupo
- Mantenha inventários em controle de versão

#### ❌ Evite
- Misturar ambientes no mesmo inventário
- Usar IPs em vez de nomes descritivos
- Colocar senhas no inventário (use Vault)
- Inventários muito grandes sem organização
* Variáveis hardcoded em playbooks
