# Instalação no Ubuntu 24.04

Guia completo de instalação do Ansible no Ubuntu 24.04 LTS usando o PPA oficial.



## Por que usar o PPA oficial?

O PPA (Personal Package Archive) oficial do Ansible oferece:



- ✅ Versões mais recentes que os repositórios padrão
- ✅ Atualizações de segurança rápidas
- ✅ Suporte oficial da comunidade Ansible
- ✅ Instalação e atualização simplificadas

## Passo a Passo

### Passo 1: Atualizar o Sistema

Sempre comece atualizando o sistema:

```bash
sudo apt update && sudo apt upgrade -y
```

#### O que este comando faz:
- apt update: Atualiza a lista de pacotes disponíveis
- apt upgrade: Atualiza os pacotes instalados
- -y: Confirma automaticamente as atualizações

### Passo 2: Instalar Dependências

O pacote software-properties-common é necessário para gerenciar PPAs:

```bash
sudo apt install software-properties-common -y
```

#### Por quê este pacote?

Este pacote fornece:
- apt-add-repository: Comando para adicionar repositórios
- add-apt-repository: Alias do comando acima
- Ferramentas para gerenciar chaves GPG de repositórios

### Passo 3: Adicionar o PPA Oficial

Adicione o repositório oficial do Ansible:

```bash
sudo apt-add-repository --yes --update ppa:ansible/ansible
```

#### Explicação dos parâmetros:
- --yes: Aceita automaticamente a adição do PPA
- --update: Atualiza a lista de pacotes após adicionar

### Passo 4: Instalar o Ansible

Agora instale o Ansible:

```bash
sudo apt install ansible -y
```



#### O que será instalado:

- ansible: Pacote principal
- ansible-core: Core do Ansible
- Dependências Python necessárias
- Collections básicas

### Passo 5: Verificar a Instalação

Verifique se a instalação foi bem-sucedida:

```bash
ansible --version
```

#### Informações importantes:

- ansible [core 2.19.5]: Versão do Ansible instalada
- python version = 3.12.3: Versão do Python usada
- config file = None: Nenhum arquivo de configuração encontrado (ainda)

### Passo 6: Verificar Comandos Disponíveis

O Ansible instala vários comandos úteis:

Listar todos os comandos do Ansible:
```bash
ls -la /usr/bin/ansible
```

#### Comandos principais:

- ansible: Executa comandos ad-hoc
- ansible-playbook: Executa playbooks
- ansible-galaxy: Gerencia roles e collections
- ansible-vault: Criptografa dados sensíveis
- ansible-doc: Documentação de módulos
- ansible-inventory: Gerencia inventários
- ansible-config: Gerencia configurações

### Passo 7: Testar Instalação Básica

Teste se o Ansible está funcionando:

Testar módulo ping localmente:
```bash
ansible localhost -m ping
```


### Solução de Problemas

#### Problema: Erro ao adicionar PPA

##### Erro:
```bash
sudo: apt-add-repository: command not found
```

##### Solução:
```bash
sudo apt install software-properties-common -y
```

#### Problema: Chave GPG inválida

##### Erro:
```bash
GPG error: https://ppa.launchpadcontent.net/ansible/ansible/ubuntu noble InRelease
```

##### Solução:
```bash
# Remover PPA
sudo add-apt-repository --remove ppa:ansible/ansible

# Adicionar novamente
sudo apt-add-repository --yes --update ppa:ansible/ansible
```



#### Problema: Versão antiga instalada

##### Verificar:
```bash
ansible --version
```

##### Solução:
```bash
# Remover versão antiga
sudo apt remove ansible -y

# Limpar cache
sudo apt clean
sudo apt autoclean

# Reinstalar
sudo apt update
sudo apt install ansible -y
```

### Atualizando o Ansible

#### Para atualizar o Ansible no futuro:

```bash
# Atualizar lista de pacotes
sudo apt update


# Atualizar apenas o Ansible
```bash
sudo apt install --only-upgrade ansible -y


# Atualizar todo o sistema
```bash
sudo apt upgrade -y
```

### Desinstalando o Ansible

Se precisar remover o Ansible:

```bash
# Remover Ansible
sudo apt remove ansible -y

# Remover dependências não utilizadas
sudo apt autoremove -y

# Remover PPA
sudo add-apt-repository --remove ppa:ansible/ansible
```

### Instalação Alternativa via pip

Se preferir instalar via pip:

```bash
# Instalar pip
sudo apt install python3-pip -y

# Instalar Ansible
pip3 install ansible --user

# Adicionar ao PATH
echo 'export PATH=$PATH:$HOME/.local/bin' >> ~/.bashrc
source ~/.bashrc

# Verificar
ansible --version
```

### Comparação de Métodos
| Método                    | Vantagens                         | Desvantagens           |   
|---------------------------|-----------------------------------|------------------------|
| PPA                       | Fácil, integrado ao sistema       | Apenas Ubuntu
| pip                       | Versão mais recente, estável      | Apenas Ubuntu/Debian
| apt                       | Versão mais recente               | Requer gerenciar PATH

### Próximos Passos

Agora que o Ansible está instalado, vamos configurá-lo:

➡️ Configuração do Inventário

---
[← Voltar ao Índice](./README.md) | [Próximo: Configuração →](../03-configuracao)
---

- ➡️ [Outras Distribuições](./outras-distros.md)

---

[← Voltar ao Índice](./README.md) | [Próxima Seção: Configuração →](../03-configuracao)
