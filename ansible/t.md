Usuário:
 Quero criar uma documentação markdown para o meu github sobre o Ansible e como instalar, pois farei um vídeo em breve para meu canal do YouTube:



Aqui está um resumo do progresso que fizemos para configurar o seu ambiente de automação:



1. Preparação do Sistema (Ubuntu 24.04)

Correção do Erro de Repositório: Identificamos que o comando apt-add-repository estava faltando. Instalamos o pacote software-properties-common para habilitar a gestão de PPAs.



Instalação do Ansible: Adicionamos o PPA oficial (ppa:ansible/ansible) e instalamos a versão mais recente do Ansible Core (2.19.5).



2. Configuração do Inventário

Criação do arquivo hosts: Configuramos um arquivo de inventário no formato INI para definir o seu nó do Proxmox.



Otimização do Python: Adicionamos a variável ansible_python_interpreter=/usr/bin/python3 no inventário para silenciar avisos de compatibilidade e garantir que o Ansible use o interpretador correto no Proxmox.



3. Resolução de Problemas de Conexão

Host Key Verification: Resolvemos o erro de segurança do SSH onde a chave do Proxmox não era reconhecida, permitindo que o "handshake" entre as máquinas ocorresse.



Autenticação: Validamos o acesso utilizando o parâmetro -k para fornecer a senha de root do Proxmox manualmente durante os testes.



4. Validação e Execução de Comandos

Teste de Conectividade: Executamos com sucesso o módulo ping, recebendo a resposta pong.



Comandos Ad-hoc: Testamos a execução de comandos reais no servidor remoto sem sair do terminal do Ansible:



uptime: Verificamos que o servidor está ligado há 3 dias.



free -m: Verificamos que o servidor possui 128GB de RAM, com a grande maioria disponível.



Estado Atual

Você tem um Nó de Controle (Ubuntu) pronto para gerenciar seu Nó Proxmox via linha de comando.



O que você gostaria de fazer agora? Posso te ajudar a configurar as chaves SSH para eliminar a necessidade de senha, ou criar seu primeiro Playbook para automatizar uma tarefa repetitiva.

IA:
 Olá! Que ótimo que você está preparando uma documentação e um vídeo sobre Ansible. Eu vou organizar as informações que você forneceu para criar uma documentação markdown clara e completa para o seu GitHub. Ela cobrirá desde a preparação do sistema até a validação dos comandos, servindo como um excelente recurso para o seu projeto.





IA:
 # Ansible - Guia Completo de Instalação e Configuração



📋 Índice

- Sobre o Ansible

- Pré-requisitos

- Instalação no Ubuntu 24.04

- Configuração do Inventário

- Configuração de Autenticação SSH

- Testando a Conectividade

- Comandos Ad-hoc Úteis

- Troubleshooting

- Próximos Passos



---



🎯 Sobre o Ansible



O Ansible é uma ferramenta de automação de TI open-source que permite:

- Gerenciamento de configuração

- Provisionamento de infraestrutura

- Orquestração de aplicações

- Automação de tarefas repetitivas



Características principais:

- Agentless: Não requer instalação de agentes nos nós gerenciados

- Idempotente: Execuções múltiplas produzem o mesmo resultado

- Declarativo: Você define o estado desejado, não os passos

- SSH-based: Utiliza SSH para comunicação segura



---



🔧 Pré-requisitos



Nó de Controle (onde o Ansible será instalado)

- Ubuntu 24.04 LTS (ou outra distro Linux)

- Python 3.8+

- Acesso root ou sudo

- Conexão de rede com os nós gerenciados



Nós Gerenciados (servidores que serão automatizados)

- SSH habilitado

- Python 3.x instalado

- Usuário com privilégios sudo ou root



---



📦 Instalação no Ubuntu 24.04



Passo 1: Atualizar o Sistema



`bash

sudo apt update && sudo apt upgrade -y

`



Passo 2: Instalar Dependências



O pacote software-properties-common é necessário para gerenciar PPAs:



`bash

sudo apt install software-properties-common -y

`



Por quê? Este pacote fornece o comando apt-add-repository, essencial para adicionar repositórios externos.



Passo 3: Adicionar o PPA Oficial do Ansible



`bash

sudo apt-add-repository --yes --update ppa:ansible/ansible

`



Vantagens do PPA oficial:

- Versões mais recentes que os repositórios padrão do Ubuntu

- Atualizações de segurança mais rápidas

- Suporte oficial da comunidade Ansible



Passo 4: Instalar o Ansible



`bash

sudo apt install ansible -y

`



Passo 5: Verificar a Instalação



`bash

ansible --version

`



Saída esperada:

`

ansible [core 2.19.5]

  config file = None

  configured module search path = ['/home/user/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']

  ansible python module location = /usr/lib/python3/dist-packages/ansible

  ansible collection location = /home/user/.ansible/collections:/usr/share/ansible/collections

  executable location = /usr/bin/ansible

  python version = 3.12.3

`



---



📝 Configuração do Inventário



O inventário define quais servidores o Ansible irá gerenciar.



Criar o Arquivo de Inventário



`bash

mkdir -p ~/ansible

nano ~/ansible/hosts

`



Estrutura do Inventário (Formato INI)



`ini

[proxmox]

192.168.1.100 ansible_user=root ansible_python_interpreter=/usr/bin/python3



[proxmox:vars]

ansible_connection=ssh

ansible_port=22

`



Explicação dos Parâmetros:



| Parâmetro | Descrição |

|-----------|-----------|

| [proxmox] | Nome do grupo de hosts |

| 192.168.1.100 | IP ou hostname do servidor |

| ansible_user=root | Usuário para conexão SSH |

| ansible_python_interpreter | Caminho do Python no host remoto (evita warnings) |

| ansible_connection=ssh | Método de conexão (padrão) |

| ansible_port=22 | Porta SSH (padrão) |



Inventário com Múltiplos Hosts



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

`



---



🔐 Configuração de Autenticação SSH



Opção 1: Autenticação por Senha (Temporária)



Para testes iniciais, você pode usar senha:



`bash

ansible proxmox -i ~/ansible/hosts -m ping -k

`



Flag -k: Solicita a senha SSH interativamente.



⚠️ Não recomendado para produção!



Opção 2: Autenticação por Chave SSH (Recomendado)



Gerar Par de Chaves SSH



`bash

ssh-keygen -t ed25519 -C "ansible-automation" -f ~/.ssh/ansible_key

`



Por que Ed25519?

- Mais seguro que RSA

- Chaves menores (256 bits)

- Performance superior



Copiar Chave Pública para o Nó Gerenciado



`bash

ssh-copy-id -i ~/.ssh/ansible_key.pub root@192.168.1.100

`



Testar Conexão SSH



`bash

ssh -i ~/.ssh/ansible_key root@192.168.1.100

`



Atualizar o Inventário



`ini

[proxmox]

192.168.1.100 ansible_user=root ansible_ssh_private_key_file=~/.ssh/ansible_key ansible_python_interpreter=/usr/bin/python3

`



Resolver Problema de Host Key Verification



Se você encontrar o erro:

`

The authenticity of host '192.168.1.100' can't be established.

`



Solução 1: Aceitar manualmente

`bash

ssh-keyscan -H 192.168.1.100 >> ~/.ssh/known_hosts

`



Solução 2: Desabilitar verificação (apenas para labs)

`bash

export ANSIBLE_HOST_KEY_CHECKING=False

`



Ou adicione ao ansible.cfg:

`ini

[defaults]

host_key_checking = False

`



---



✅ Testando a Conectividade



Teste Básico com Módulo Ping



`bash

ansible proxmox -i ~/ansible/hosts -m ping

`



Saída esperada:

`json

192.168.1.100 | SUCCESS => {

    "ansible_facts": {

        "discovered_interpreter_python": "/usr/bin/python3"

    },

    "changed": false,

    "ping": "pong"

}

`



Verificar Conectividade de Todos os Hosts



`bash

ansible all -i ~/ansible/hosts -m ping

`



---



🚀 Comandos Ad-hoc Úteis



Comandos ad-hoc permitem executar tarefas rápidas sem criar playbooks.



Sintaxe Básica



`bash

ansible <grupo> -i <inventário> -m <módulo> -a "<argumentos>"

`



Exemplos Práticos



1. Verificar Uptime



`bash

ansible proxmox -i ~/ansible/hosts -m command -a "uptime"

`



Saída:

`

192.168.1.100 | CHANGED | rc=0 >>

 14:23:45 up 3 days,  2:15,  1 user,  load average: 0.15, 0.10, 0.08

`



2. Verificar Memória Disponível



`bash

ansible proxmox -i ~/ansible/hosts -m command -a "free -m"

`



Saída:

`

192.168.1.100 | CHANGED | rc=0 >>

              total        used        free      shared  buff/cache   available

Mem:         128000        8500      115000         200        4500      118000

Swap:          8192           0        8192

`



3. Verificar Espaço em Disco



`bash

ansible proxmox -i ~/ansible/hosts -m command -a "df -h"

`



4. Listar Processos



`bash

ansible proxmox -i ~/ansible/hosts -m shell -a "ps aux | head -10"

`



Diferença entre command e shell:

- command: Mais seguro, não processa pipes/redirects

- shell: Permite pipes, redirects e variáveis de ambiente



5. Instalar Pacote



`bash

ansible proxmox -i ~/ansible/hosts -m apt -a "name=htop state=present" --become

`



6. Reiniciar Serviço



`bash

ansible proxmox -i ~/ansible/hosts -m systemd -a "name=ssh state=restarted" --become

`



7. Copiar Arquivo



`bash

ansible proxmox -i ~/ansible/hosts -m copy -a "src=/local/file.txt dest=/remote/file.txt mode=0644"

`



8. Coletar Informações do Sistema (Facts)



`bash

ansible proxmox -i ~/ansible/hosts -m setup

`



Filtrar facts específicos:

`bash

ansible proxmox -i ~/ansible/hosts -m setup -a "filter=ansible_distribution"

`



---



🛠️ Troubleshooting



Problema 1: apt-add-repository: command not found



Causa: Pacote software-properties-common não instalado.



Solução:

`bash

sudo apt install software-properties-common -y

`



---



Problema 2: Host key verification failed



Causa: Chave SSH do host remoto não está no known_hosts.



Solução:

`bash

ssh-keyscan -H 192.168.1.100 >> ~/.ssh/known_hosts

`



---



Problema 3: Permission denied (publickey,password)



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



---



Problema 4: Python interpreter not found



Causa: Python não está instalado no nó gerenciado ou caminho incorreto.



Solução:

`bash

No nó gerenciado

apt install python3 -y



No inventário, especificar o caminho

ansible_python_interpreter=/usr/bin/python3

`



---



Problema 5: Timeout waiting for privilege escalation prompt



Causa: Usuário não tem permissões sudo ou senha sudo necessária.



Solução:

`bash

Adicionar flag -K para solicitar senha sudo

ansible proxmox -i ~/ansible/hosts -m command -a "whoami" --become -K

`



---



📚 Próximos Passos



1. Criar Arquivo de Configuração Ansible



`bash

nano ~/ansible/ansible.cfg

`



`ini

[defaults]

inventory = ~/ansible/hosts

host_key_checking = False

retry_files_enabled = False

gathering = smart

fact_caching = jsonfile

fact_caching_connection = /tmp/ansible_facts

fact_caching_timeout = 3600



[privilege_escalation]

become = True

become_method = sudo

become_user = root

become_ask_pass = False



[ssh_connection]

pipelining = True

ssh_args = -o ControlMaster=auto -o ControlPersist=60s

`



2. Criar Seu Primeiro Playbook



`bash

nano ~/ansible/primeiro-playbook.yml

`



`yaml

---

- name: Configuração Básica de Servidores

  hosts: proxmox

  become: yes

  

  tasks:

    - name: Atualizar cache do apt

      apt:

        update_cache: yes

        cache_valid_time: 3600

    

    - name: Instalar pacotes essenciais

      apt:

        name:

          - vim

          - htop

          - curl

          - wget

          - net-tools

        state: present

    

    - name: Garantir que o SSH está rodando

      systemd:

        name: ssh

        state: started

        enabled: yes

    

    - name: Criar usuário de automação

      user:

        name: ansible

        shell: /bin/bash

        groups: sudo

        append: yes

        create_home: yes

`



Executar o playbook:

`bash

ansible-playbook ~/ansible/primeiro-playbook.yml

`



3. Explorar Ansible Galaxy



Ansible Galaxy é um repositório de roles prontas:



`bash

Instalar role de exemplo

ansible-galaxy install geerlingguy.docker



Usar em um playbook

---

- hosts: proxmox

  roles:

    - geerlingguy.docker

`



4. Implementar Ansible Vault



Para proteger senhas e dados sensíveis:



`bash

Criar arquivo criptografado

ansible-vault create secrets.yml



Editar arquivo criptografado

ansible-vault edit secrets.yml



Executar playbook com vault

ansible-playbook playbook.yml --ask-vault-pass

`



---



🎓 Recursos Adicionais



- Documentação Oficial: https://docs.ansible.com/

- Ansible Galaxy: https://galaxy.ansible.com/

- Comunidade: https://www.reddit.com/r/ansible/

- Exemplos de Playbooks: https://github.com/ansible/ansible-examples



---



📺 Vídeo Tutorial



🎥 Assista ao tutorial completo no YouTube: [Link do seu canal]



---



📄 Licença



Este guia é distribuído sob licença MIT. Sinta-se livre para usar, modificar e compartilhar.



---



🤝 Contribuições



Encontrou algum erro ou tem sugestões? Abra uma issue ou envie um pull request!



---



Desenvolvido por: Daniel Selbach - CSO @ AFSIM TECH  

Data: Dezembro 2025



---



⭐ Se este guia foi útil, deixe uma estrela no repositório!

Usuário:
 algumas docs



https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-ansible-on-ubuntu-22-04



https://docs.ansible.com/collections.html

IA:
 Olá! Entendi que você gostaria de um resumo sobre a instalação e configuração do Ansible no Ubuntu 22.04, além de informações sobre coleções do Ansible. Prepararei um material completo para você.





IA:
 Excelente! Vou enriquecer a documentação com informações dessas fontes oficiais, adicionando seções sobre Ansible Collections, melhores práticas da DigitalOcean e estrutura de projetos profissionais.



---



Ansible - Guia Completo de Instalação e Configuração



📋 Índice

- Sobre o Ansible

- Pré-requisitos

- Instalação no Ubuntu 24.04

- Configuração do Inventário

- Configuração de Autenticação SSH

- Testando a Conectividade

- Comandos Ad-hoc Úteis

- Ansible Collections

- Estrutura de Projeto Profissional

- Ansible Configuration File

- Troubleshooting

- Melhores Práticas

- Próximos Passos



---



🎯 Sobre o Ansible



O Ansible é uma ferramenta de automação de TI open-source que permite:

- Gerenciamento de configuração

- Provisionamento de infraestrutura

- Orquestração de aplicações

- Automação de tarefas repetitivas



Características principais:

- Agentless: Não requer instalação de agentes nos nós gerenciados

- Idempotente: Execuções múltiplas produzem o mesmo resultado

- Declarativo: Você define o estado desejado, não os passos

- SSH-based: Utiliza SSH para comunicação segura



---



🔧 Pré-requisitos



Nó de Controle (onde o Ansible será instalado)

- Ubuntu 24.04 LTS (ou outra distro Linux)

- Python 3.8+

- Acesso root ou sudo

- Conexão de rede com os nós gerenciados



Nós Gerenciados (servidores que serão automatizados)

- SSH habilitado

- Python 3.x instalado

- Usuário com privilégios sudo ou root



---



📦 Instalação no Ubuntu 24.04



Passo 1: Atualizar o Sistema



`bash

sudo apt update && sudo apt upgrade -y

`



Passo 2: Instalar Dependências



O pacote software-properties-common é necessário para gerenciar PPAs:



`bash

sudo apt install software-properties-common -y

`



Por quê? Este pacote fornece o comando apt-add-repository, essencial para adicionar repositórios externos.



Passo 3: Adicionar o PPA Oficial do Ansible



`bash

sudo apt-add-repository --yes --update ppa:ansible/ansible

`



Vantagens do PPA oficial:

- Versões mais recentes que os repositórios padrão do Ubuntu

- Atualizações de segurança mais rápidas

- Suporte oficial da comunidade Ansible



Passo 4: Instalar o Ansible



`bash

sudo apt install ansible -y

`



Passo 5: Verificar a Instalação



`bash

ansible --version

`



Saída esperada:

`

ansible [core 2.19.5]

  config file = None

  configured module search path = ['/home/user/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']

  ansible python module location = /usr/lib/python3/dist-packages/ansible

  ansible collection location = /home/user/.ansible/collections:/usr/share/ansible/collections

  executable location = /usr/bin/ansible

  python version = 3.12.3

`



---



📝 Configuração do Inventário



O inventário define quais servidores o Ansible irá gerenciar.



Criar o Arquivo de Inventário



`bash

mkdir -p ~/ansible

nano ~/ansible/hosts

`



Estrutura do Inventário (Formato INI)



`ini

[proxmox]

192.168.1.100 ansible_user=root ansible_python_interpreter=/usr/bin/python3



[proxmox:vars]

ansible_connection=ssh

ansible_port=22

`



Explicação dos Parâmetros:



| Parâmetro | Descrição |

|-----------|-----------|

| [proxmox] | Nome do grupo de hosts |

| 192.168.1.100 | IP ou hostname do servidor |

| ansible_user=root | Usuário para conexão SSH |

| ansible_python_interpreter | Caminho do Python no host remoto (evita warnings) |

| ansible_connection=ssh | Método de conexão (padrão) |

| ansible_port=22 | Porta SSH (padrão) |



Inventário com Múltiplos Hosts



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



Inventário em Formato YAML (Alternativa Moderna)



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



---



🔐 Configuração de Autenticação SSH



Opção 1: Autenticação por Senha (Temporária)



Para testes iniciais, você pode usar senha:



`bash

ansible proxmox -i ~/ansible/hosts -m ping -k

`



Flag -k: Solicita a senha SSH interativamente.



⚠️ Não recomendado para produção!



Opção 2: Autenticação por Chave SSH (Recomendado)



Gerar Par de Chaves SSH



`bash

ssh-keygen -t ed25519 -C "ansible-automation" -f ~/.ssh/ansible_key

`



Por que Ed25519?

- Mais seguro que RSA

- Chaves menores (256 bits)

- Performance superior



Copiar Chave Pública para o Nó Gerenciado



`bash

ssh-copy-id -i ~/.ssh/ansible_key.pub root@192.168.1.100

`



Testar Conexão SSH



`bash

ssh -i ~/.ssh/ansible_key root@192.168.1.100

`



Atualizar o Inventário



`ini

[proxmox]

192.168.1.100 ansible_user=root ansible_ssh_private_key_file=~/.ssh/ansible_key ansible_python_interpreter=/usr/bin/python3

`



Resolver Problema de Host Key Verification



Se você encontrar o erro:

`

The authenticity of host '192.168.1.100' can't be established.

`



Solução 1: Aceitar manualmente

`bash

ssh-keyscan -H 192.168.1.100 >> ~/.ssh/known_hosts

`



Solução 2: Desabilitar verificação (apenas para labs)

`bash

export ANSIBLE_HOST_KEY_CHECKING=False

`



Ou adicione ao ansible.cfg:

`ini

[defaults]

host_key_checking = False

`



---



✅ Testando a Conectividade



Teste Básico com Módulo Ping



`bash

ansible proxmox -i ~/ansible/hosts -m ping

`



Saída esperada:

`json

192.168.1.100 | SUCCESS => {

    "ansible_facts": {

        "discovered_interpreter_python": "/usr/bin/python3"

    },

    "changed": false,

    "ping": "pong"

}

`



Verificar Conectividade de Todos os Hosts



`bash

ansible all -i ~/ansible/hosts -m ping

`



---



🚀 Comandos Ad-hoc Úteis



Comandos ad-hoc permitem executar tarefas rápidas sem criar playbooks.



Sintaxe Básica



`bash

ansible <grupo> -i <inventário> -m <módulo> -a "<argumentos>"

`



Exemplos Práticos



1. Verificar Uptime



`bash

ansible proxmox -i ~/ansible/hosts -m command -a "uptime"

`



Saída:

`

192.168.1.100 | CHANGED | rc=0 >>

 14:23:45 up 3 days,  2:15,  1 user,  load average: 0.15, 0.10, 0.08

`



2. Verificar Memória Disponível



`bash

ansible proxmox -i ~/ansible/hosts -m command -a "free -m"

`



Saída:

`

192.168.1.100 | CHANGED | rc=0 >>

              total        used        free      shared  buff/cache   available

Mem:         128000        8500      115000         200        4500      118000

Swap:          8192           0        8192

`



3. Verificar Espaço em Disco



`bash

ansible proxmox -i ~/ansible/hosts -m command -a "df -h"

`



4. Listar Processos



`bash

ansible proxmox -i ~/ansible/hosts -m shell -a "ps aux | head -10"

`



Diferença entre command e shell:

- command: Mais seguro, não processa pipes/redirects

- shell: Permite pipes, redirects e variáveis de ambiente



5. Instalar Pacote



`bash

ansible proxmox -i ~/ansible/hosts -m apt -a "name=htop state=present" --become

`



6. Reiniciar Serviço



`bash

ansible proxmox -i ~/ansible/hosts -m systemd -a "name=ssh state=restarted" --become

`



7. Copiar Arquivo



`bash

ansible proxmox -i ~/ansible/hosts -m copy -a "src=/local/file.txt dest=/remote/file.txt mode=0644"

`



8. Coletar Informações do Sistema (Facts)



`bash

ansible proxmox -i ~/ansible/hosts -m setup

`



Filtrar facts específicos:

`bash

ansible proxmox -i ~/ansible/hosts -m setup -a "filter=ansible_distribution"

`



---



📦 Ansible Collections



O que são Collections?



Ansible Collections são pacotes de distribuição que podem conter:

- Playbooks

- Roles

- Modules

- Plugins

- Documentação



Collections substituem o modelo antigo de módulos individuais, oferecendo uma forma mais organizada e versionada de distribuir conteúdo Ansible.



Estrutura de uma Collection



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



Collections Essenciais



1. ansible.builtin (Incluída por padrão)

Contém os módulos core do Ansible.



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



2. community.general

Módulos mantidos pela comunidade para tarefas gerais.



`bash

ansible-galaxy collection install community.general

`



Exemplos de uso:

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



3. ansible.posix

Utilitários para sistemas POSIX (Linux/Unix).



`bash

ansible-galaxy collection install ansible.posix

`



Exemplos:

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



4. community.docker

Gerenciamento completo de Docker.



`bash

ansible-galaxy collection install community.docker

`



Exemplos:

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



5. community.postgresql

Gerenciamento de PostgreSQL.



`bash

ansible-galaxy collection install community.postgresql

`



6. community.mysql

Gerenciamento de MySQL/MariaDB.



`bash

ansible-galaxy collection install community.mysql

`



Gerenciando Collections



Listar Collections Instaladas



`bash

ansible-galaxy collection list

`



Instalar Collection Específica



`bash

ansible-galaxy collection install namespace.collection_name

`



Instalar Versão Específica



`bash

ansible-galaxy collection install namespace.collection_name:1.2.3

`



Instalar de um arquivo requirements.yml



`bash

nano requirements.yml

`



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



Instalar todas as collections:

`bash

ansible-galaxy collection install -r requirements.yml

`



Atualizar Collections



`bash

ansible-galaxy collection install namespace.collection_name --upgrade

`



Remover Collection



`bash

ansible-galaxy collection remove namespace.collection_name

`



Usando Collections em Playbooks



Método 1: FQCN (Fully Qualified Collection Name)



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



Método 2: Declarar Collections no Playbook



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



Criar Sua Própria Collection



`bash

ansible-galaxy collection init mynamespace.mycollection

`



Estrutura gerada:

`

mynamespace/mycollection/

├── docs/

├── galaxy.yml

├── plugins/

│   └── README.md

├── README.md

└── roles/

`



Editar galaxy.yml:

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



---



🏗️ Estrutura de Projeto Profissional



Layout Recomendado pela DigitalOcean



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



Exemplo de Projeto Completo



1. ansible.cfg



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



2. inventory/production/hosts.yml



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



3. group_vars/all.yml



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



4. group_vars/webservers.yml



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



5. roles/common/tasks/main.yml



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



6. roles/common/handlers/main.yml



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



7. playbooks/site.yml



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



8. requirements.yml



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



Executando o Projeto



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



---



⚙️ Ansible Configuration File



Ordem de Precedência



O Ansible procura o arquivo de configuração na seguinte ordem:



1. ANSIBLE_CONFIG (variável de ambiente)

2. ansible.cfg (no diretório atual)

3. ~/.ansible.cfg (no home do usuário)

4. /etc/ansible/ansible.cfg (global)



Configuração Completa Recomendada



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

host_key_checking = False



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



Variáveis de Ambiente Úteis



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



---



🛠️ Troubleshooting



Problema 1: apt-add-repository: command not found



Causa: Pacote software-properties-common não instalado.



Solução:

`bash

sudo apt install software-properties-common -y

`



---



Problema 2: Host key verification failed



Causa: Chave SSH do host remoto não está no known_hosts.



Solução:

`bash

ssh-keyscan -H 192.168.1.100 >> ~/.ssh/known_hosts

`



---



Problema 3: Permission denied (publickey,password)



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



---



Problema 4: Python interpreter not found



Causa: Python não está instalado no nó gerenciado ou caminho incorreto.



Solução:

`bash

No nó gerenciado

apt install python3 -y



No inventário, especificar o caminho

ansible_python_interpreter=/usr/bin/python3

`



---



Problema 5: Timeout waiting for privilege escalation prompt



Causa: Usuário não tem permissões sudo ou senha sudo necessária.



Solução:

`bash

Adicionar flag -K para solicitar senha sudo

ansible proxmox -i ~/ansible/hosts -m command -a "whoami" --become -K

`



---



Problema 6: Module not found



Causa: Collection necessária não está instalada.



Solução:

`bash

Verificar qual collection contém o módulo

ansible-doc -l | grep nome_do_modulo



Instalar a collection

ansible-galaxy collection install namespace.collection_name

`



---



Problema 7: Failed to connect to the host via ssh



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



---



📚 Melhores Práticas



1. Segurança



Usar Ansible Vault para Dados Sensíveis



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



Princípio do Menor Privilégio



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



Validar Configurações Antes de Aplicar



`bash

Dry-run (não faz alterações)

ansible-playbook site.yml --check



Mostrar diferenças

ansible-playbook site.yml --check --diff



Executar apenas em um host de teste

ansible-playbook site.yml --limit test-server

`



2. Idempotência



Sempre escreva tasks idempotentes:



`yaml

❌ NÃO IDEMPOTENTE

- name: Adicionar linha ao arquivo

  ansible.builtin.shell: echo "nova_linha" >> /etc/config



✅ IDEMPOTENTE

- name: Garantir que linha existe no arquivo

  ansible.builtin.lineinfile:

    path: /etc/config

    line: "nova_linha"

    state: present

`



3. Organização de Variáveis



Hierarquia de Variáveis



1. Variáveis de linha de comando (-e)

2. Variáveis de role (defaults)

3. Variáveis de inventário (host_vars, group_vars)

4. Variáveis de playbook

5. Variáveis de role (vars)



`yaml

group_vars/webservers.yml

---

nginx_worker_processes: 4

nginx_worker_connections: 1024



host_vars/web01.yml

---

nginx_worker_processes: 8  # Override para este host específico

`



4. Tags para Controle Granular



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



5. Handlers para Reiniciar Serviços



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



6. Usar Módulos Nativos ao Invés de Shell



`yaml

❌ EVITAR

- name: Criar diretório

  ansible.builtin.shell: mkdir -p /opt/app



✅ PREFERIR

- name: Criar diretório

  ansible.builtin.file:

    path: /opt/app

    state: directory

    mode: '0755'

`



7. Documentar Roles



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



8. Testes com Molecule



`bash

Instalar Molecule

pip3 install molecule molecule-docker



Inicializar role com Molecule

molecule init role mynamespace.myrole --driver-name docker



Executar testes

molecule test

`



---



📚 Próximos Passos



1. Explorar Ansible Galaxy



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



2. Integração com CI/CD



GitLab CI



`yaml

.gitlab-ci.yml

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



3. Ansible Tower / AWX



AWX é a versão open-source do Ansible Tower, oferecendo:

- Interface web para gerenciar playbooks

- Controle de acesso baseado em roles (RBAC)

- Agendamento de jobs

- Inventário dinâmico

- Integração com sistemas de notificação



`bash

Instalar AWX via Docker Compose

git clone https://github.com/ansible/awx.git

cd awx

make docker-compose-build

docker-compose up -d

`



4. Dynamic Inventory



Para ambientes cloud (AWS, Azure, GCP):



`bash

Instalar plugin AWS

ansible-galaxy collection install amazon.aws



Criar inventário dinâmico

nano inventory/aws_ec2.yml

`



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



`bash

Usar inventário dinâmico

ansible-inventory -i inventory/aws_ec2.yml --graph

ansible-playbook -i inventory/aws_ec2.yml site.yml

`



5. Ansible Lint



Ferramenta para validar boas práticas:



`bash

Instalar

pip3 install ansible-lint



Executar

ansible-lint playbooks/site.yml



Configurar

nano .ansible-lint

`



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



---



🎓 Recursos Adicionais



Documentação Oficial

- Ansible Docs: https://docs.ansible.com/

- Ansible Collections: https://docs.ansible.com/collections.html

- Ansible Galaxy: https://galaxy.ansible.com/

- Best Practices: https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html



Tutoriais e Guias

- DigitalOcean Ansible Tutorials: https://www.digitalocean.com/community/tags/ansible

- Jeff Geerling's Ansible 101: https://www.ansiblefordevops.com/

- Red Hat Ansible Learning: https://www.redhat.com/en/services/training/do007-ansible-essentials-simplicity-automation-technical-overview



Comunidade

- Reddit: https://www.reddit.com/r/ansible/

- Ansible Forum: https://forum.ansible.com/

- Stack Overflow: https://stackoverflow.com/questions/tagged/ansible

- IRC: #ansible on Libera.Chat



Livros Recomendados

- Ansible for DevOps - Jeff Geerling

- Ansible: Up and Running - Lorin Hochstein

- Mastering Ansible - James Freeman



---



📺 Vídeo Tutorial



🎥 Assista ao tutorial completo no YouTube: [Link do seu canal]



---



📄 Licença



Este guia é distribuído sob licença MIT. Sinta-se livre para usar, modificar e compartilhar.



---



🤝 Contribuições



Encontrou algum erro ou tem sugestões? Abra uma issue ou envie um pull request!



---



Desenvolvido por: Daniel Selbach - CSO @ AFSIM TECH  

Data: Dezembro 2025  

Versão: 2.0



---



⭐ Se este guia foi útil, deixe uma estrela no repositório!



---



🔖 Referências



- How To Install and Configure Ansible on Ubuntu 22.04 - DigitalOcean

- Ansible Collections Documentation

- Ansible Best Practices
