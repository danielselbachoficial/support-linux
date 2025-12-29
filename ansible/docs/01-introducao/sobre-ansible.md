Sobre o Ansible



O Ansible é uma ferramenta de automação de TI open-source que revolucionou a forma como gerenciamos infraestrutura.



O que é o Ansible?



Ansible é uma plataforma de automação que permite:



- Gerenciamento de Configuração: Manter servidores no estado desejado

- Provisionamento de Infraestrutura: Criar e configurar recursos automaticamente

- Orquestração de Aplicações: Coordenar deploys complexos

- Automação de Tarefas: Eliminar trabalho manual repetitivo



Características Principais



1. Agentless (Sem Agentes)



Diferente de outras ferramentas, o Ansible não requer instalação de agentes nos servidores gerenciados.



`

┌─────────────────┐         SSH         ┌─────────────────┐

│  Nó de Controle │ ─────────────────> │  Servidor 1     │

│  (Ansible)      │                     │  (Sem agente)   │

└─────────────────┘                     └─────────────────┘

`



Vantagens:

- Menos overhead nos servidores

- Sem necessidade de manutenção de agentes

- Mais seguro (usa SSH nativo)



2. Idempotente



Executar a mesma tarefa múltiplas vezes produz o mesmo resultado.



`yaml

Este código pode ser executado 100 vezes

O resultado será sempre o mesmo

- name: Garantir que Nginx está instalado

  apt:

    name: nginx

    state: present

`



3. Declarativo



Você define o que quer, não como fazer.



`yaml

Você declara o estado desejado

- name: Nginx deve estar rodando

  service:

    name: nginx

    state: started

    enabled: yes

`



4. Baseado em SSH



Usa SSH para comunicação, aproveitando a infraestrutura existente.



`bash

Ansible usa SSH padrão

ansible all -m ping

Equivalente a: ssh user@host "comando"

`



Por que usar Ansible?



Simplicidade



- Sintaxe YAML fácil de ler

- Curva de aprendizado suave

- Não requer conhecimento de programação



Poderoso



- Gerencia milhares de servidores

- Integra com cloud providers

- Extensível via plugins e modules



Eficiente



- Execução paralela

- Conexões persistentes

- Otimizado para performance



Casos de Uso



1. Configuração de Servidores



`yaml

- name: Configurar servidor web

  hosts: webservers

  tasks:

    - name: Instalar Nginx

      apt:

        name: nginx

        state: present

    

    - name: Copiar configuração

      template:

        src: nginx.conf.j2

        dest: /etc/nginx/nginx.conf

`



2. Deploy de Aplicações



`yaml

- name: Deploy da aplicação

  hosts: production

  tasks:

    - name: Baixar código

      git:

        repo: https://github.com/user/app.git

        dest: /var/www/app

    

    - name: Instalar dependências

      pip:

        requirements: /var/www/app/requirements.txt

`



3. Provisionamento de Cloud



`yaml

- name: Criar instância EC2

  hosts: localhost

  tasks:

    - name: Provisionar servidor

      ec2:

        key_name: mykey

        instance_type: t2.micro

        image: ami-12345678

        region: us-east-1

`



Arquitetura do Ansible



`

┌─────────────────────────────────────────────────────────┐

│                    Nó de Controle                       │

│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐ │

│  │  Inventário  │  │  Playbooks   │  │  Modules     │ │

│  └──────────────┘  └──────────────┘  └──────────────┘ │

└─────────────────────────────────────────────────────────┘

                            │

                            │ SSH

                            ▼

┌─────────────────────────────────────────────────────────┐

│                    Nós Gerenciados                      │

│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐ │

│  │  Servidor 1  │  │  Servidor 2  │  │  Servidor 3  │ │

│  └──────────────┘  └──────────────┘  └──────────────┘ │

└─────────────────────────────────────────────────────────┘

`



Componentes



1. Nó de Controle: Máquina onde o Ansible está instalado

2. Inventário: Lista de servidores gerenciados

3. Playbooks: Arquivos YAML com as tarefas

4. Modules: Unidades de código que executam tarefas

5. Nós Gerenciados: Servidores que serão automatizados



Comparação com Outras Ferramentas



| Característica | Ansible | Puppet | Chef | SaltStack |

|----------------|---------|--------|------|-----------|

| Agentless | ✅ Sim | ❌ Não | ❌ Não | ⚠️ Opcional |

| Linguagem | YAML | Ruby DSL | Ruby | YAML/Python |

| Curva de Aprendizado | Baixa | Alta | Alta | Média |

| Comunicação | SSH | SSL | SSL | ZeroMQ |

| Idempotência | ✅ Sim | ✅ Sim | ✅ Sim | ✅ Sim |



Quando usar Ansible?



✅ Use Ansible quando:



- Precisa de automação rápida e simples

- Quer evitar instalação de agentes

- Tem infraestrutura baseada em SSH

- Precisa de sintaxe legível (YAML)

- Quer integração fácil com CI/CD



⚠️ Considere alternativas quando:



- Precisa de execução em tempo real

- Tem requisitos muito específicos de performance

- Já tem infraestrutura estabelecida com outra ferramenta



Próximos Passos



Agora que você entende o que é o Ansible, vamos verificar os pré-requisitos:



➡️ Pré-requisitos



---



← Voltar | Índice | Próximo: Pré-requisitos →

`
