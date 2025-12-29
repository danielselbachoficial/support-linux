# Ansible - Guia Completo de Instalação e Configuração



Olá! Este é o guia completo de instalação e configuração do Ansible para automação de infraestrutura. Se você quer aprender sobre Ansible, pode ler este guia. Se você quer praticar com comandos reais, pode seguir os exemplos. Este guia foi criado para acompanhar o vídeo tutorial no YouTube.



Sobre o Ansible



O Ansible é uma ferramenta de automação de TI open-source que permite gerenciar configurações, provisionar infraestrutura e orquestrar aplicações de forma simples e eficiente.



Características principais



O Ansible possui características que o tornam único no mercado de automação:



- Agentless: Não requer instalação de agentes nos nós gerenciados

- Idempotente: Execuções múltiplas produzem o mesmo resultado

- Declarativo: Você define o estado desejado, não os passos

- SSH-based: Utiliza SSH para comunicação segura



Pré-requisitos



Antes de começar, você precisa ter os seguintes requisitos no nó de controle (onde o Ansible será instalado):



- Ubuntu 24.04 LTS (ou outra distro Linux)

- Python 3.8+

- Acesso root ou sudo

- Conexão de rede com os nós gerenciados



E nos nós gerenciados (servidores que serão automatizados):



- SSH habilitado

- Python 3.x instalado

- Usuário com privilégios sudo ou root



Instalação



A instalação do Ansible no Ubuntu 24.04 é simples e direta. Siga os passos abaixo para ter o Ansible funcionando em minutos.



Atualizar o sistema



Primeiro, atualize o sistema operacional:



`bash

sudo apt update && sudo apt upgrade -y

`



Instalar dependências



O pacote software-properties-common é necessário para gerenciar PPAs:



`bash

sudo apt install software-properties-common -y

`



> Nota: Este pacote fornece o comando apt-add-repository, essencial para adicionar repositórios externos.



Adicionar o PPA oficial



Adicione o repositório oficial do Ansible:



`bash

sudo apt-add-repository --yes --update ppa:ansible/ansible

`



Instalar o Ansible



Agora instale o Ansible:



`bash

sudo apt install ansible -y

`



Verificar a instalação



Verifique se a instalação foi bem-sucedida:



`bash

ansible --version

`



Você deve ver uma saída similar a esta:



`

ansible [core 2.19.5]

  config file = None

  configured module search path = ['/home/user/.ansible/plugins/modules']

  ansible python module location = /usr/lib/python3/dist-packages/ansible

  ansible collection location = /home/user/.ansible/collections

  executable location = /usr/bin/ansible

  python version = 3.12.3

`



Configuração do Inventário



O inventário é onde você define quais servidores o Ansible irá gerenciar. É o coração da sua infraestrutura como código.



Criar o diretório de trabalho



Crie um diretório para organizar seus arquivos do Ansible:



`bash

mkdir -p ~/ansible

nano ~/ansible/hosts

`



Formato INI básico



O formato mais simples de inventário usa a sintaxe INI:



`ini

[proxmox]

192.168.1.100 ansible_user=root ansible_python_interpreter=/usr/bin/python3



[proxmox:vars]

ansible_connection=ssh

ansible_port=22

`



Entendendo os parâmetros



Cada parâmetro no inventário tem um propósito específico:



| Parâmetro | Descrição |

|-----------|-----------|

| [proxmox] | Nome do grupo de hosts |

| 192.168.1.100 | IP ou hostname do servidor |

| ansible_user=root | Usuário para conexão SSH |

| ansible_python_interpreter | Caminho do Python no host remoto |

| ansible_connection=ssh | Método de conexão (padrão) |

| ansible_port=22 | Porta SSH (padrão) |



Inventário com múltiplos hosts



Para ambientes maiores, você pode organizar múltiplos hosts em grupos:



`ini

[proxmox]

pve01 ansible_host=192.168.1.100

pve02 ansible_host=192.168.1.101

pve03 ansible_host=192.168.1.102



[proxmox:vars]

ansible_user=root

ansible_python_interpreter=/usr/bin/python3



[webservers]

web01 ansible_host=192.168.1.200

web02 ansible_host=192.168.1.201



[webservers:vars]

ansible_user=ubuntu

ansible_become=yes

ansible_become_method=sudo



[databases]

db01 ansible_host=192.168.1.210

db02 ansible_host=192.168.1.211



[production:children]

webservers

databases

`



Formato YAML



Alternativamente, você pode usar o formato YAML, que é mais moderno e legível:



`yaml

all:

  children:

    proxmox:

      hosts:

        pve01:

          ansible_host: 192.168.1.100

        pve02:

          ansible_host: 192.168.1.101

      vars:

        ansible_user: root

        ansible_python_interpreter: /usr/bin/python3

    

    webservers:

      hosts:

        web01:

          ansible_host: 192.168.1.200

        web02:

          ansible_host: 192.168.1.201

      vars:

        ansible_user: ubuntu

        ansible_become: yes

`



Autenticação SSH



A autenticação SSH é fundamental para o funcionamento do Ansible. Existem duas formas principais de autenticar.



Autenticação por senha



Para testes iniciais, você pode usar senha (não recomendado para produção):



`bash

ansible proxmox -i ~/ansible/hosts -m ping -k

`



> Atenção: A flag -k solicita a senha SSH interativamente. Não use em produção!



Autenticação por chave SSH



A forma recomendada é usar chaves SSH. Primeiro, gere um par de chaves:



`bash

ssh-keygen -t ed25519 -C "ansible-automation" -f ~/.ssh/ansible_key

`



Por que Ed25519?



O algoritmo Ed25519 oferece vantagens sobre o RSA tradicional:



- Mais seguro que RSA

- Chaves menores (256 bits)

- Performance superior

- Resistente a ataques de timing



Copiar a chave pública



Copie a chave pública para o servidor remoto:



`bash

ssh-copy-id -i ~/.ssh/ansible_key.pub root@192.168.1.100

`



Testar a conexão



Teste se a autenticação está funcionando:



`bash

ssh -i ~/.ssh/ansible_key root@192.168.1.100

`



Atualizar o inventário



Atualize o inventário para usar a chave privada:



`ini

[proxmox]

192.168.1.100 ansible_user=root ansible_ssh_private_key_file=~/.ssh/ansible_key ansible_python_interpreter=/usr/bin/python3

`



Resolver verificação de host key



Se você encontrar o erro de verificação de host key, há duas soluções:



Solução 1: Aceitar manualmente



`bash

ssh-keyscan -H 192.168.1.100 >> ~/.ssh/known_hosts

`



Solução 2: Desabilitar verificação



Para ambientes de laboratório, você pode desabilitar a verificação:



`bash

export ANSIBLE_HOST_KEY_CHECKING=False

`



Ou adicione ao arquivo ansible.cfg:



`ini

[defaults]

host_key_checking = False

`



Testando a Conectividade



Agora que tudo está configurado, vamos testar se o Ansible consegue se conectar aos hosts.



Teste básico com ping



Execute o módulo ping do Ansible:



`bash

ansible proxmox -i ~/ansible/hosts -m ping

`



Saída esperada



Você deve ver uma resposta JSON como esta:



`json

192.168.1.100 | SUCCESS => {

    "ansible_facts": {

        "discovered_interpreter_python": "/usr/bin/python3"

    },

    "changed": false,

    "ping": "pong"

}

`



Testar todos os hosts



Para testar todos os hosts do inventário:



`bash

ansible all -i ~/ansible/hosts -m ping

`



Comandos Ad-hoc



Comandos ad-hoc permitem executar tarefas rápidas sem criar playbooks. São perfeitos para operações pontuais.



Sintaxe básica



A sintaxe de um comando ad-hoc é:



`bash

ansible <grupo> -i <inventário> -m <módulo> -a "<argumentos>"

`



Verificar uptime



Veja há quanto tempo o servidor está ligado:



`bash

ansible proxmox -i ~/ansible/hosts -m command -a "uptime"

`



Saída esperada:



`

192.168.1.100 | CHANGED | rc=0 >>

 14:23:45 up 3 days,  2:15,  1 user,  load average: 0.15, 0.10, 0.08

`



Verificar memória



Verifique o uso de memória do servidor:



`bash

ansible proxmox -i ~/ansible/hosts -m command -a "free -m"

`



Saída esperada:



`

192.168.1.100 | CHANGED | rc=0 >>

              total        used        free      shared  buff/cache   available

Mem:         128000        8500      115000         200        4500      118000

Swap:          8192           0        8192

`



Verificar espaço em disco



Veja o espaço disponível nos discos:



`bash

ansible proxmox -i ~/ansible/hosts -m command -a "df -h"

`



Listar processos



Liste os processos em execução:



`bash

ansible proxmox -i ~/ansible/hosts -m shell -a "ps aux | head -10"

`



Diferença entre command e shell



É importante entender a diferença entre os módulos command e shell:



- command: Mais seguro, não processa pipes/redirects

- shell: Permite pipes, redirects e variáveis de ambiente



Instalar pacotes



Instale um pacote usando o módulo apt:



`bash

ansible proxmox -i ~/ansible/hosts -m apt -a "name=htop state=present" --become

`



Reiniciar serviços



Reinicie um serviço usando o módulo systemd:



`bash

ansible proxmox -i ~/ansible/hosts -m systemd -a "name=ssh state=restarted" --become

`



Copiar arquivos



Copie arquivos do nó de controle para os hosts gerenciados:



`bash

ansible proxmox -i ~/ansible/hosts -m copy -a "src=/local/file.txt dest=/remote/file.txt mode=0644"

`



Coletar informações do sistema



O Ansible pode coletar informações detalhadas sobre os hosts (facts):



`bash

ansible proxmox -i ~/ansible/hosts -m setup

`



Filtrar facts específicos



Você pode filtrar apenas as informações que precisa:



`bash

ansible proxmox -i ~/ansible/hosts -m setup -a "filter=ansible_distribution"

`



Ansible Collections



As Collections são a forma moderna de distribuir conteúdo do Ansible. Elas substituem o modelo antigo de módulos individuais.



O que são Collections?



Ansible Collections são pacotes de distribuição que podem conter:



- Playbooks

- Roles

- Modules

- Plugins

- Documentação



Estrutura de uma Collection



Uma collection típica tem a seguinte estrutura:



`

namespace.collection_name/

├── docs/

├── galaxy.yml

├── plugins/

│   ├── modules/

│   ├── inventory/

│   ├── lookup/

│   └── filter/

├── roles/

├── playbooks/

└── README.md

`



Collections essenciais



Existem algumas collections que você deve conhecer desde o início.



ansible.builtin



Esta collection vem incluída por padrão e contém os módulos core do Ansible:



`yaml

---

- name: Exemplo usando módulos builtin

  hosts: proxmox

  tasks:

    - name: Copiar arquivo

      ansible.builtin.copy:

        src: /local/file.txt

        dest: /remote/file.txt

`



community.general



Módulos mantidos pela comunidade para tarefas gerais:



`bash

ansible-galaxy collection install community.general

`



Exemplo de uso:



`yaml

---

- name: Gerenciar pacotes Snap

  hosts: webservers

  tasks:

    - name: Instalar Docker via Snap

      community.general.snap:

        name: docker

        state: present

`



ansible.posix



Utilitários para sistemas POSIX (Linux/Unix):



`bash

ansible-galaxy collection install ansible.posix

`



Exemplo:



`yaml

---

- name: Configurar firewall

  hosts: proxmox

  tasks:

    - name: Permitir SSH no firewall

      ansible.posix.firewalld:

        service: ssh

        permanent: yes

        state: enabled

`



community.docker



Gerenciamento completo de Docker:



`bash

ansible-galaxy collection install community.docker

`



Exemplo:



`yaml

---

- name: Deploy de container

  hosts: webservers

  tasks:

    - name: Executar container Nginx

      community.docker.docker_container:

        name: nginx

        image: nginx:latest

        state: started

        ports:

          - "80:80"

`



Gerenciando Collections



Você pode gerenciar collections usando o comando ansible-galaxy.



Listar collections instaladas



`bash

ansible-galaxy collection list

`



Instalar uma collection



`bash

ansible-galaxy collection install namespace.collection_name

`



Instalar versão específica



`bash

ansible-galaxy collection install namespace.collection_name:1.2.3

`



Usar arquivo requirements.yml



Crie um arquivo requirements.yml:



`yaml

---

collections:

  - name: community.general

    version: ">=5.0.0"

  

  - name: community.docker

    version: "3.4.0"

  

  - name: ansible.posix

  

  - name: community.postgresql

    source: https://galaxy.ansible.com

`



Instale todas as collections:



`bash

ansible-galaxy collection install -r requirements.yml

`



Atualizar collections



`bash

ansible-galaxy collection install namespace.collection_name --upgrade

`



Remover uma collection



`bash

ansible-galaxy collection remove namespace.collection_name

`



Usando Collections em Playbooks



Existem duas formas principais de usar collections em playbooks.



Método 1: FQCN



Use o nome completo da collection (Fully Qualified Collection Name):



`yaml

---

- name: Exemplo com FQCN

  hosts: proxmox

  tasks:

    - name: Instalar pacote

      ansible.builtin.apt:

        name: vim

        state: present

    

    - name: Gerenciar container

      community.docker.docker_container:

        name: app

        image: myapp:latest

`



Método 2: Declarar collections



Declare as collections no início do playbook:



`yaml

---

- name: Exemplo com collections declaradas

  hosts: proxmox

  collections:

    - community.general

    - community.docker

  

  tasks:

    - name: Instalar pacote via Snap

      snap:

        name: kubectl

        classic: yes

    

    - name: Executar container

      docker_container:

        name: redis

        image: redis:alpine

`



Criar sua própria Collection



Você pode criar suas próprias collections personalizadas:



`bash

ansible-galaxy collection init mynamespace.mycollection

`



Isso cria a estrutura básica:



`

mynamespace/mycollection/

├── docs/

├── galaxy.yml

├── plugins/

│   └── README.md

├── README.md

└── roles/

`



Edite o arquivo galaxy.yml:



`yaml

namespace: mynamespace

name: mycollection

version: 1.0.0

readme: README.md

authors:

  - Daniel Selbach <email@example.com>

description: Minha collection personalizada

license:

  - MIT

tags:

  - infrastructure

  - automation

dependencies: {}

repository: https://github.com/user/mycollection

`



Estrutura de Projeto Profissional



Para projetos maiores, é importante seguir uma estrutura organizada e profissional.



Layout recomendado



Esta é a estrutura recomendada pela comunidade e pela DigitalOcean:



`

ansible-project/

├── ansible.cfg

├── inventory/

│   ├── production/

│   │   ├── hosts.yml

│   │   └── group_vars/

│   │       ├── all.yml

│   │       ├── webservers.yml

│   │       └── databases.yml

│   └── staging/

│       ├── hosts.yml

│       └── group_vars/

├── roles/

│   ├── common/

│   │   ├── tasks/

│   │   │   └── main.yml

│   │   ├── handlers/

│   │   │   └── main.yml

│   │   ├── templates/

│   │   ├── files/

│   │   ├── vars/

│   │   │   └── main.yml

│   │   ├── defaults/

│   │   │   └── main.yml

│   │   └── meta/

│   │       └── main.yml

│   ├── webserver/

│   └── database/

├── playbooks/

│   ├── site.yml

│   ├── webservers.yml

│   └── databases.yml

├── group_vars/

│   └── all.yml

├── host_vars/

├── library/

├── filter_plugins/

├── requirements.yml

└── README.md

`



Arquivo ansible.cfg



O arquivo de configuração principal do projeto:



`ini

[defaults]

inventory = ./inventory/production/hosts.yml

remote_user = ansible

host_key_checking = False

retry_files_enabled = False

gathering = smart

fact_caching = jsonfile

fact_caching_connection = /tmp/ansible_facts

fact_caching_timeout = 3600

roles_path = ./roles

collections_paths = ./collections

interpreter_python = auto_silent



Logging

log_path = ./ansible.log



Performance

forks = 20

pipelining = True



[privilege_escalation]

become = True

become_method = sudo

become_user = root

become_ask_pass = False



[ssh_connection]

ssh_args = -o ControlMaster=auto -o ControlPersist=60s -o StrictHostKeyChecking=no

pipelining = True

control_path = /tmp/ansible-ssh-%%h-%%p-%%r

`



Inventário de produção



Arquivo inventory/production/hosts.yml:



`yaml

all:

  children:

    proxmox:

      hosts:

        pve01:

          ansible_host: 192.168.1.100

        pve02:

          ansible_host: 192.168.1.101

      vars:

        ansible_user: root

        ansible_python_interpreter: /usr/bin/python3

    

    webservers:

      hosts:

        web01:

          ansible_host: 192.168.1.200

          nginx_port: 80

        web02:

          ansible_host: 192.168.1.201

          nginx_port: 8080

      vars:

        ansible_user: ubuntu

        http_port: 80

        max_clients: 200

    

    databases:

      hosts:

        db01:

          ansible_host: 192.168.1.210

          mysql_port: 3306

      vars:

        ansible_user: ubuntu

        db_engine: mysql

`



Variáveis globais



Arquivo group_vars/all.yml:



`yaml

---

Variáveis globais para todos os hosts

ntp_servers:

  - 0.pool.ntp.org

  - 1.pool.ntp.org



dns_servers:

  - 8.8.8.8

  - 8.8.4.4



timezone: America/Sao_Paulo



common_packages:

  - vim

  - htop

  - curl

  - wget

  - net-tools

  - git

`



Variáveis de grupo



Arquivo group_vars/webservers.yml:



`yaml

---

Variáveis específicas para webservers

nginx_version: latest

ssl_enabled: true

ssl_cert_path: /etc/ssl/certs/server.crt

ssl_key_path: /etc/ssl/private/server.key



firewall_allowed_ports:

  - 22

  - 80

  - 443

`



Role comum



Arquivo roles/common/tasks/main.yml:



`yaml

---

- name: Atualizar cache do apt

  ansible.builtin.apt:

    update_cache: yes

    cache_valid_time: 3600

  when: ansible_os_family == "Debian"



- name: Instalar pacotes comuns

  ansible.builtin.apt:

    name: "{{ common_packages }}"

    state: present

  when: ansible_os_family == "Debian"



- name: Configurar timezone

  community.general.timezone:

    name: "{{ timezone }}"



- name: Configurar NTP

  ansible.builtin.template:

    src: ntp.conf.j2

    dest: /etc/ntp.conf

    owner: root

    group: root

    mode: '0644'

  notify: restart ntp



- name: Garantir que o NTP está rodando

  ansible.builtin.systemd:

    name: ntp

    state: started

    enabled: yes



- name: Criar usuário de automação

  ansible.builtin.user:

    name: ansible

    shell: /bin/bash

    groups: sudo

    append: yes

    create_home: yes



- name: Configurar sudoers para usuário ansible

  ansible.builtin.lineinfile:

    path: /etc/sudoers.d/ansible

    line: 'ansible ALL=(ALL) NOPASSWD: ALL'

    create: yes

    mode: '0440'

    validate: 'visudo -cf %s'

`



Handlers



Arquivo roles/common/handlers/main.yml:



`yaml

---

- name: restart ntp

  ansible.builtin.systemd:

    name: ntp

    state: restarted



- name: restart ssh

  ansible.builtin.systemd:

    name: ssh

    state: restarted

`



Playbook principal



Arquivo playbooks/site.yml:



`yaml

---

- name: Configuração completa da infraestrutura

  hosts: all

  become: yes

  

  roles:

    - common



- name: Configurar servidores web

  hosts: webservers

  become: yes

  

  roles:

    - webserver



- name: Configurar servidores de banco de dados

  hosts: databases

  become: yes

  

  roles:

    - database

`



Arquivo de requisitos



Arquivo requirements.yml:



`yaml

---

collections:

  - name: community.general

    version: ">=5.0.0"

  

  - name: ansible.posix

  

  - name: community.docker

    version: "3.4.0"



roles:

  - name: geerlingguy.docker

    version: 6.1.0

  

  - name: geerlingguy.nginx

    version: 3.1.4

`



Executando o projeto



Aqui estão os comandos mais comuns para executar o projeto:



`bash

Instalar dependências

ansible-galaxy install -r requirements.yml



Executar playbook completo

ansible-playbook playbooks/site.yml



Executar apenas para webservers

ansible-playbook playbooks/site.yml --limit webservers



Dry-run (check mode)

ansible-playbook playbooks/site.yml --check



Modo verbose

ansible-playbook playbooks/site.yml -vvv



Executar tags específicas

ansible-playbook playbooks/site.yml --tags "configuration"



Pular tags específicas

ansible-playbook playbooks/site.yml --skip-tags "packages"

`



Arquivo de Configuração



O arquivo ansible.cfg controla o comportamento do Ansible. Entender sua estrutura é fundamental.



Ordem de precedência



O Ansible procura o arquivo de configuração na seguinte ordem:



1. ANSIBLE_CONFIG (variável de ambiente)

2. ansible.cfg (no diretório atual)

3. ~/.ansible.cfg (no home do usuário)

4. /etc/ansible/ansible.cfg (global)



Configuração completa recomendada



`ini

[defaults]

Inventário

inventory = ./inventory/production/hosts.yml



Usuário remoto padrão

remote_user = ansible



Desabilitar verificação de host key (apenas para labs)

host_key_checking = False



Desabilitar criação de arquivos .retry

retry_files_enabled = False



Estratégia de coleta de facts

gathering = smart

fact_caching = jsonfile

fact_caching_connection = /tmp/ansible_facts

fact_caching_timeout = 3600



Caminhos

roles_path = ./roles:~/.ansible/roles:/usr/share/ansible/roles

collections_paths = ./collections:~/.ansible/collections:/usr/share/ansible/collections

library = ./library



Interpretador Python

interpreter_python = auto_silent



Logging

log_path = ./ansible.log



Performance

forks = 20

pipelining = True



Timeout

timeout = 30



Callbacks

stdout_callback = yaml

bin_ansible_callbacks = True



Cores (output colorido)

force_color = True



[inventory]

Habilitar plugins de inventário

enable_plugins = host_list, script, auto, yaml, ini, toml



[privilege_escalation]

become = True

become_method = sudo

become_user = root

become_ask_pass = False



[ssh_connection]

Otimizações SSH

ssh_args = -o ControlMaster=auto -o ControlPersist=60s -o StrictHostKeyChecking=no

pipelining = True

control_path = /tmp/ansible-ssh-%%h-%%p-%%r



Timeout SSH

timeout = 30



[persistent_connection]

Timeout para conexões persistentes

connect_timeout = 30

command_timeout = 30



[colors]

Personalizar cores do output

highlight = white

verbose = blue

warn = bright purple

error = red

debug = dark gray

deprecate = purple

skip = cyan

unreachable = red

ok = green

changed = yellow

diff_add = green

diff_remove = red

diff_lines = cyan

`



Variáveis de ambiente úteis



Você também pode controlar o Ansible através de variáveis de ambiente:



`bash

Arquivo de configuração customizado

export ANSIBLE_CONFIG=~/projetos/ansible/ansible.cfg



Desabilitar host key checking

export ANSIBLE_HOST_KEY_CHECKING=False



Aumentar verbosidade

export ANSIBLE_VERBOSITY=3



Definir inventário

export ANSIBLE_INVENTORY=~/ansible/inventory/production/hosts.yml



Definir roles path

export ANSIBLE_ROLES_PATH=~/ansible/roles



Habilitar pipelining

export ANSIBLE_PIPELINING=True



Número de processos paralelos

export ANSIBLE_FORKS=50

`



Troubleshooting



Problemas comuns e suas soluções. Esta seção vai te salvar muito tempo de debugging.



Problema 1: apt-add-repository não encontrado



Se você receber o erro apt-add-repository: command not found:



Causa: Pacote software-properties-common não instalado.



Solução:

`bash

sudo apt install software-properties-common -y

`



Problema 2: Verificação de host key falhou



Se você receber Host key verification failed:



Causa: Chave SSH do host remoto não está no known_hosts.



Solução:

`bash

ssh-keyscan -H 192.168.1.100 >> ~/.ssh/known_hosts

`



Problema 3: Permissão negada



Se você receber Permission denied (publickey,password):



Causa: Autenticação SSH falhou.



Soluções:



1. Verificar se a chave pública foi copiada corretamente

2. Verificar permissões da chave privada:



`bash

chmod 600 ~/.ssh/ansible_key

`



3. Testar conexão SSH manualmente:



`bash

ssh -i ~/.ssh/ansible_key -v root@192.168.1.100

`



Problema 4: Interpretador Python não encontrado



Se você receber Python interpreter not found:



Causa: Python não está instalado no nó gerenciado ou caminho incorreto.



Solução:



No nó gerenciado:

`bash

apt install python3 -y

`



No inventário, especificar o caminho:

`ini

ansible_python_interpreter=/usr/bin/python3

`



Problema 5: Timeout de escalação de privilégios



Se você receber Timeout waiting for privilege escalation prompt:



Causa: Usuário não tem permissões sudo ou senha sudo necessária.



Solução:

`bash

Adicionar flag -K para solicitar senha sudo

ansible proxmox -i ~/ansible/hosts -m command -a "whoami" --become -K

`



Problema 6: Módulo não encontrado



Se você receber Module not found:



Causa: Collection necessária não está instalada.



Solução:

`bash

Verificar qual collection contém o módulo

ansible-doc -l | grep nome_do_modulo



Instalar a collection

ansible-galaxy collection install namespace.collection_name

`



Problema 7: Falha ao conectar via SSH



Se você receber Failed to connect to the host via ssh:



Causa: Problemas de conectividade de rede ou firewall.



Diagnóstico:



`bash

Testar conectividade

ping 192.168.1.100



Testar porta SSH

telnet 192.168.1.100 22



Verificar com nmap

nmap -p 22 192.168.1.100



Testar SSH com verbose

ssh -vvv root@192.168.1.100

`



Melhores Práticas



Seguir as melhores práticas garante que seu código Ansible seja seguro, eficiente e manutenível.



Segurança



A segurança deve ser sempre a prioridade número um.



Usar Ansible Vault



Ansible Vault permite criptografar dados sensíveis:



`bash

Criar arquivo criptografado

ansible-vault create secrets.yml



Editar arquivo existente

ansible-vault edit secrets.yml



Criptografar arquivo existente

ansible-vault encrypt vars.yml



Descriptografar arquivo

ansible-vault decrypt vars.yml



Visualizar arquivo criptografado

ansible-vault view secrets.yml



Executar playbook com vault

ansible-playbook site.yml --ask-vault-pass



Usar arquivo de senha

echo "minha_senha_forte" > .vault_pass

chmod 600 .vault_pass

ansible-playbook site.yml --vault-password-file .vault_pass

`



Exemplo de secrets.yml:



`yaml

---

db_password: "senha_super_secreta"

api_key: "chave_api_privada"

ssl_private_key: |

  -----BEGIN PRIVATE KEY-----

  MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC...

  -----END PRIVATE KEY-----

`



Princípio do menor privilégio



Sempre use o mínimo de privilégios necessário:



`yaml

---

- name: Executar tarefa com usuário específico

  hosts: webservers

  become: yes

  become_user: www-data  # Não usar root desnecessariamente

  

  tasks:

    - name: Reiniciar aplicação

      ansible.builtin.systemd:

        name: myapp

        state: restarted

`



Validar antes de aplicar



Sempre valide suas mudanças antes de aplicar em produção:



`bash

Dry-run (não faz alterações)

ansible-playbook site.yml --check



Mostrar diferenças

ansible-playbook site.yml --check --diff



Executar apenas em um host de teste

ansible-playbook site.yml --limit test-server

`



Idempotência



Idempotência significa que executar a mesma operação múltiplas vezes produz o mesmo resultado.



Exemplo ruim (não idempotente)



`yaml

❌ NÃO IDEMPOTENTE

- name: Adicionar linha ao arquivo

  ansible.builtin.shell: echo "nova_linha" >> /etc/config

`



Exemplo bom (idempotente)



`yaml

✅ IDEMPOTENTE

- name: Garantir que linha existe no arquivo

  ansible.builtin.lineinfile:

    path: /etc/config

    line: "nova_linha"

    state: present

`



Organização de variáveis



Organize suas variáveis seguindo a hierarquia de precedência.



Hierarquia de variáveis



1. Variáveis de linha de comando (-e)

2. Variáveis de role (defaults)

3. Variáveis de inventário (host_vars, group_vars)

4. Variáveis de playbook

5. Variáveis de role (vars)



Exemplo de group_vars/webservers.yml:



`yaml

---

nginx_worker_processes: 4

nginx_worker_connections: 1024

`



Exemplo de host_vars/web01.yml:



`yaml

---

nginx_worker_processes: 8  # Override para este host específico

`



Tags para controle granular



Use tags para executar apenas partes específicas dos playbooks:



`yaml

---

- name: Configurar servidor web

  hosts: webservers

  

  tasks:

    - name: Instalar Nginx

      ansible.builtin.apt:

        name: nginx

        state: present

      tags:

        - packages

        - nginx

    

    - name: Configurar Nginx

      ansible.builtin.template:

        src: nginx.conf.j2

        dest: /etc/nginx/nginx.conf

      tags:

        - configuration

        - nginx

      notify: restart nginx

    

    - name: Habilitar firewall

      community.general.ufw:

        rule: allow

        port: '80'

        proto: tcp

      tags:

        - security

        - firewall

`



Executar tags específicas:



`bash

Apenas instalação de pacotes

ansible-playbook site.yml --tags "packages"



Apenas configuração

ansible-playbook site.yml --tags "configuration"



Múltiplas tags

ansible-playbook site.yml --tags "nginx,firewall"



Pular tags

ansible-playbook site.yml --skip-tags "security"

`



Handlers para reiniciar serviços



Use handlers para reiniciar serviços apenas quando necessário:



`yaml

---

- name: Configurar SSH

  hosts: all

  

  tasks:

    - name: Atualizar configuração SSH

      ansible.builtin.template:

        src: sshd_config.j2

        dest: /etc/ssh/sshd_config

        validate: '/usr/sbin/sshd -t -f %s'

      notify: restart ssh

  

  handlers:

    - name: restart ssh

      ansible.builtin.systemd:

        name: ssh

        state: restarted

`



Usar módulos nativos



Sempre prefira módulos nativos ao invés de shell:



Exemplo ruim



`yaml

❌ EVITAR

- name: Criar diretório

  ansible.builtin.shell: mkdir -p /opt/app

`



Exemplo bom



`yaml

✅ PREFERIR

- name: Criar diretório

  ansible.builtin.file:

    path: /opt/app

    state: directory

    mode: '0755'

`



Documentar roles



Sempre documente suas roles usando o arquivo meta/main.yml:



`yaml

roles/webserver/meta/main.yml

---

galaxy_info:

  author: Daniel Selbach

  description: Configuração completa de servidor web Nginx

  company: AFSIM TECH

  license: MIT

  min_ansible_version: 2.9

  

  platforms:

    - name: Ubuntu

      versions:

        - focal

        - jammy

  

  galaxy_tags:

    - web

    - nginx

    - ssl



dependencies:

  - role: common

  - role: firewall

`



Testes com Molecule



Use Molecule para testar suas roles:



`bash

Instalar Molecule

pip3 install molecule molecule-docker



Inicializar role com Molecule

molecule init role mynamespace.myrole --driver-name docker



Executar testes

molecule test

`



Próximos Passos



Agora que você domina o básico, aqui estão os próximos passos para se tornar um expert em Ansible.



Explorar Ansible Galaxy



Ansible Galaxy é um repositório de roles e collections prontas:



`bash

Buscar roles

ansible-galaxy search nginx



Instalar role

ansible-galaxy install geerlingguy.docker



Listar roles instaladas

ansible-galaxy list



Remover role

ansible-galaxy remove geerlingguy.docker

`



Usar role em playbook:



`yaml

---

- hosts: webservers

  roles:

    - geerlingguy.nginx

    - geerlingguy.docker

`



Integração com CI/CD



Integre o Ansible com seu pipeline de CI/CD.



GitLab CI



Exemplo de .gitlab-ci.yml:



`yaml

stages:

  - validate

  - deploy



validate:

  stage: validate

  script:

    - ansible-playbook site.yml --syntax-check

    - ansible-playbook site.yml --check

  only:

    - merge_requests



deploy_staging:

  stage: deploy

  script:

    - ansible-playbook -i inventory/staging site.yml

  only:

    - develop



deploy_production:

  stage: deploy

  script:

    - ansible-playbook -i inventory/production site.yml

  only:

    - main

  when: manual

`



Ansible Tower / AWX



AWX é a versão open-source do Ansible Tower, oferecendo:



- Interface web para gerenciar playbooks

- Controle de acesso baseado em roles (RBAC)

- Agendamento de jobs

- Inventário dinâmico

- Integração com sistemas de notificação



Instalar AWX via Docker Compose:



`bash

git clone https://github.com/ansible/awx.git

cd awx

make docker-compose-build

docker-compose up -d

`



Dynamic Inventory



Para ambientes cloud (AWS, Azure, GCP), use inventário dinâmico.



Exemplo para AWS



Instalar plugin AWS:



`bash

ansible-galaxy collection install amazon.aws

`



Criar inventory/aws_ec2.yml:



`yaml

---

plugin: amazon.aws.aws_ec2

regions:

  - us-east-1

  - us-west-2

filters:

  tag:Environment: production

keyed_groups:

  - key: tags.Role

    prefix: role

`



Usar inventário dinâmico:



`bash

Visualizar inventário

ansible-inventory -i inventory/aws_ec2.yml --graph



Executar playbook

ansible-playbook -i inventory/aws_ec2.yml site.yml

`



Ansible Lint



Valide suas boas práticas com Ansible Lint:



`bash

Instalar

pip3 install ansible-lint



Executar

ansible-lint playbooks/site.yml

`



Configurar .ansible-lint:



`yaml

---

skip_list:

  - '106'  # Role name does not match ^[a-z][a-z0-9_]+$ pattern

  - '204'  # Lines should be no longer than 160 chars



exclude_paths:

  - .cache/

  - .github/

  - test/

`



Recursos Adicionais



Aqui estão recursos valiosos para continuar sua jornada com Ansible.



Documentação oficial



- Ansible Docs: https://docs.ansible.com/

- Ansible Collections: https://docs.ansible.com/collections.html

- Ansible Galaxy: https://galaxy.ansible.com/

- Best Practices: https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html



Tutoriais e guias



- DigitalOcean Ansible Tutorials: https://www.digitalocean.com/community/tags/ansible

- Jeff Geerling's Ansible 101: https://www.ansiblefordevops.com/

- Red Hat Ansible Learning: https://www.redhat.com/en/services/training/do007-ansible-essentials-simplicity-automation-technical-overview



Comunidade



- Reddit: https://www.reddit.com/r/ansible/

- Ansible Forum: https://forum.ansible.com/

- Stack Overflow: https://stackoverflow.com/questions/tagged/ansible

- IRC: #ansible on Libera.Chat



Livros recomendados



- Ansible for DevOps - Jeff Geerling

- Ansible: Up and Running - Lorin Hochstein

- Mastering Ansible - James Freeman



Vídeo Tutorial



Assista ao tutorial completo no YouTube para ver tudo isso em ação!



> Link do vídeo: [Seu canal no YouTube]



Licença



Este guia é distribuído sob licença MIT. Sinta-se livre para usar, modificar e compartilhar.



Contribuições



Encontrou algum erro ou tem sugestões? Abra uma issue ou envie um pull request!



---



Desenvolvido por: Daniel Selbach - CSO @ AFSIM TECH  

Data: Dezembro 2025  

Versão: 2.0



---



Se este guia foi útil, deixe uma estrela no repositório! ⭐



---



Referências



- How To Install and Configure Ansible on Ubuntu 22.04 - DigitalOcean

- Ansible Collections Documentation

- Ansible Best Practices
