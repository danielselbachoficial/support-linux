# Arquivo ansible.cfg

O arquivo `ansible.cfg` controla o comportamento do Ansible. Entender sua configuração é essencial.

## O que é ansible.cfg?

É um arquivo de configuração INI que define:

- Comportamento padrão do Ansible
- Caminhos de busca para roles e plugins
- Opções de performance
- Configurações de segurança
- Logging e output

## Ordem de Precedência

O Ansible procura o arquivo de configuração nesta ordem:

1. **ANSIBLE_CONFIG** (variável de ambiente)
2. **./ansible.cfg** (diretório atual)
3. **~/.ansible.cfg** (home do usuário)
4. **/etc/ansible/ansible.cfg** (global)

**Exemplo:**
```bash
# Usar arquivo específico
export ANSIBLE_CONFIG=/path/to/ansible.cfg
ansible all -m ping

# Ou especificar na linha de comando
ansible-playbook -c /path/to/ansible.cfg playbook.yml
```

## Criando seu ansible.cfg

### Passo 1: Criar Arquivo
```bash
cd ~/ansible
nano ansible.cfg
```

### Passo 2: Adicionar Configurações Básicas
```ini
[defaults]
inventory = ./hosts
remote_user = ansible
host_key_checking = False
```

### Passo 3: Testar
```bash
# Verificar qual arquivo está sendo usado
ansible --version

# Deve mostrar:
# config file = /home/user/ansible/ansible.cfg
```

## Configurações Essenciais

### Seção [defaults]

#### Inventário

```ini
[defaults]
# Arquivo de inventário padrão
inventory = ./hosts

# Ou múltiplos inventários
inventory = ./inventory/production/hosts.yml,./inventory/staging/hosts.yml
```

#### Usuário Remoto

```ini
[defaults]
# Usuário padrão para conexão SSH
remote_user = ansible

# Ou especificar por host no inventário
# ansible_user = ubuntu
```

#### Host Key Checking

```ini
[defaults]
# Desabilitar verificação de host key (apenas para labs)
host_key_checking = False

# Ou aceitar automaticamente
# host_key_checking = True
```

#### Retry Files

```ini
[defaults]
# Desabilitar criação de arquivos .retry
retry_files_enabled = False

# Ou especificar diretório
# retry_files_save_path = ./retry_files
```

#### Gathering Facts

```ini
[defaults]
# Estratégia de coleta de facts
gathering = smart

# Opções:
# - implicit: Coleta sempre (padrão)
# - explicit: Coleta apenas se solicitado
# - smart: Coleta e cacheia
# - gather_subset: Coleta subset específico
```

#### Fact Caching

```ini
[defaults]
# Cachear facts para performance
fact_caching = jsonfile
fact_caching_connection = /tmp/ansible_facts
fact_caching_timeout = 3600  # 1 hora
```

#### Caminhos

```ini
[defaults]
# Caminho para roles
roles_path = ./roles:~/.ansible/roles:/usr/share/ansible/roles

# Caminho para collections
collections_paths = ./collections:~/.ansible/collections

# Caminho para módulos customizados
library = ./library

# Caminho para plugins de filtro
filter_plugins = ./filter_plugins

# Caminho para plugins de lookup
lookup_plugins = ./lookup_plugins
```

#### Interpretador Python

```ini
[defaults]
# Detectar automaticamente Python
interpreter_python = auto_silent

# Ou especificar versão
# interpreter_python = /usr/bin/python3

# Ou usar python3 se disponível
# interpreter_python = auto
```

#### Logging

```ini
[defaults]
# Arquivo de log
log_path = ./ansible.log

# Verbosidade padrão
# verbosity = 0  # 0-4, ou use -v, -vv, -vvv, -vvvv
```

#### Performance

```ini
[defaults]
# Número de processos paralelos
forks = 20

# Habilitar pipelining (reduz conexões SSH)
pipelining = True

# Timeout padrão
timeout = 30

# Timeout para conexões persistentes
persistent_command_timeout = 30
```

#### Output

```ini
[defaults]
# Callback plugin para output
stdout_callback = yaml

# Habilitar callbacks customizados
bin_ansible_callbacks = True

# Forçar cores no output
force_color = True

# Mostrar diferenças
diff_always = False
```

#### Seção [inventory]

```ini
[inventory]
# Habilitar plugins de inventário
enable_plugins = host_list, script, auto, yaml, ini, toml

# Ignorar extensões
ignore_extensions = .pyc, .pyo, .swp, .bak, ~, .rpm, .md, .txt, ~, .orig, .ini, .cfg, .retry
```

#### Seção [privilege_escalation]

```ini
[privilege_escalation]
# Usar escalação de privilégios
become = True

# Método de escalação
become_method = sudo

# Usuário para escalação
become_user = root

# Solicitar senha para escalação
become_ask_pass = False
```

#### Seção [ssh_connection]

```ini
[ssh_connection]
# Argumentos SSH padrão
ssh_args = -o ControlMaster=auto -o ControlPersist=60s -o StrictHostKeyChecking=no

# Habilitar pipelining
pipelining = True

# Caminho para controle de conexão
control_path = /tmp/ansible-ssh-%%h-%%p-%%r

# Timeout SSH
timeout = 30

# Usar chave específica
# ssh_keyfile = ~/.ssh/ansible_key
```

#### Seção [persistent_connection]

```ini
[persistent_connection]
# Timeout para conexões persistentes
connect_timeout = 30
command_timeout = 30
```

#### Seção [colors]

```ini
[colors]
# Personalizar cores do output
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
```

## Configuração Recomendada

```ini
[defaults]
# Inventário
inventory = ./inventory/production/hosts.yml

# Usuário remoto
remote_user = ansible

# Host key checking
host_key_checking = False

# Retry files
retry_files_enabled = False

# Gathering facts
gathering = smart
fact_caching = jsonfile
fact_caching_connection = /tmp/ansible_facts
fact_caching_timeout = 3600

# Caminhos
roles_path = ./roles:~/.ansible/roles:/usr/share/ansible/roles
collections_paths = ./collections:~/.ansible/collections
library = ./library
filter_plugins = ./filter_plugins

# Interpretador Python
interpreter_python = auto_silent

# Logging
log_path = ./ansible.log

# Performance
forks = 20
pipelining = True
timeout = 30

# Output
stdout_callback = yaml
bin_ansible_callbacks = True
force_color = True

[inventory]
enable_plugins = host_list, script, auto, yaml, ini, toml

[privilege_escalation]
become = True
become_method = sudo
become_user = root
become_ask_pass = False

[ssh_connection]
ssh_args = -o ControlMaster=auto -o ControlPersist=60s -o StrictHostKeyChecking=no
pipelining = True
control_path = /tmp/ansible-ssh-%%h-%%p-%%r
timeout = 30

[persistent_connection]
connect_timeout = 30
command_timeout = 30

[colors]
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
```

## Variáveis de Ambiente

Você também pode controlar o Ansible via variáveis de ambiente:
```bash
# Arquivo de configuração
export ANSIBLE_CONFIG=~/ansible/ansible.cfg

# Inventário
export ANSIBLE_INVENTORY=~/ansible/hosts

# Usuário remoto
export ANSIBLE_REMOTE_USER=ansible

# Host key checking
export ANSIBLE_HOST_KEY_CHECKING=False

# Verbosidade
export ANSIBLE_VERBOSITY=3

# Número de forks
export ANSIBLE_FORKS=50

# Timeout
export ANSIBLE_TIMEOUT=30

# Pipelining
export ANSIBLE_PIPELINING=True

# Roles path
export ANSIBLE_ROLES_PATH=~/ansible/roles

# Collections path
export ANSIBLE_COLLECTIONS_PATH=~/ansible/collections
```

## Verificando Configuração

### Ver configuração ativa
```bash
ansible-config view
```

#### Saída:
[defaults]
inventory = ./hosts
remote_user = ansible
...

### Ver todas as configurações
```bash
ansible-config dump
```

### Ver configuração de um item específico
```bash
ansible-config get-config-value -c ansible.cfg -k inventory
```

## Boas Práticas

### ✅ Faça
- Mantenha ansible.cfg no repositório do projeto
- Use configurações específicas por projeto
- Documente configurações não óbvias
- Use variáveis de ambiente para valores sensíveis
- Teste configurações antes de usar em produção

### ❌ Evite
- Usar configuração global para tudo
- Deixar host_key_checking = False em produção
- Colocar senhas em ansible.cfg
- Configurações muito permissivas
- Ignorar avisos de segurança

Próximos Passos

Agora que está tudo configurado, vamos testar a conectividade:

➡️ [Testando Conectividade](./04-primeiros-passos/testando-conectividade.md)
