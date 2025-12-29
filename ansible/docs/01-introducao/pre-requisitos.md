# Pré-requisitos

Antes de começar com o Ansible, certifique-se de ter os requisitos necessários.

## Requisitos do Nó de Controle

O nó de controle é a máquina onde o Ansible será instalado e de onde você executará os comandos.

### Sistema Operacional

O Ansible pode ser instalado em:

- ✅ Ubuntu 20.04, 22.04, 24.04
- ✅ Debian 10, 11, 12
- ✅ CentOS 7, 8, 9
- ✅ Red Hat Enterprise Linux 7, 8, 9
- ✅ Fedora (últimas versões)
- ✅ macOS (via Homebrew)
- ❌ **Windows** (não suportado como nó de controle)

> **Nota:** Windows pode ser usado como nó gerenciado, mas não como nó de controle.

### Python

O Ansible requer Python instalado:

- **Python 3.8 ou superior** (recomendado)
- Python 2.7 (obsoleto, não recomendado)

**Verificar versão do Python:**
```bash
python3 --version
```

**Saída esperada:**
```text
Python 3.12.3
```

### Recursos de Hardware

**Requisitos mínimos:**
| Recurso        | Mínimo   | Recomendado  |   
|---------------------------|--------------|----------
| CPU            | ✅ Sim   | 1 core       | 2+ cores  
| RAM            | YAML     | 512 MB       | 2 GB+    
| Disco          | Baixa    | 1 GB         | 5 GB+    
| Rede           | SSH      | 1 Mbps       | 10 Mbps+

*> Dica: Para gerenciar muitos hosts, considere mais recursos.*

### Acesso de Rede

O nó de controle precisa de:
-   ✅ Acesso SSH aos nós gerenciados (porta 22)
-   ✅ Resolução de DNS ou arquivo /etc/hosts configurado
-   ✅ Conectividade de rede estável

### Permissões

Você precisa de:
-   ✅ Acesso sudo ou root no nó de controle (para instalação)
-   ✅ Usuário com permissões adequadas nos nós gerenciados

## Requisitos dos Nós Gerenciados

Os nós gerenciados são os servidores que o Ansible irá automatizar.

### Sistema Operacional

Praticamente qualquer sistema Unix-like:
-   ✅ Ubuntu, Debian
-   ✅ CentOS, RHEL, Rocky Linux
-   ✅ Fedora, openSUSE
-   ✅ macOS
-   ✅ Windows (com WinRM configurado)
-   ✅ BSD (FreeBSD, OpenBSD)

### SSH

Requisitos de SSH:
-   ✅ Servidor SSH rodando (geralmente porta 22)
-   ✅ Acesso SSH configurado
-   ✅ Chaves SSH ou autenticação por senha

Verificar se SSH está rodando:

## bash

```
sudo systemctl status ssh
```

### Python

Os nós gerenciados precisam de Python:
-   Python 3.5 ou superior (recomendado)
-   Python 2.6 ou 2.7 (funciona, mas obsoleto)

Verificar Python no servidor remoto:

## bash

```
ssh user@servidor "python3 --version"
```

### Permissões

O usuário usado pelo Ansible precisa de:
-   ✅ Acesso SSH ao servidor
-   ✅ Permissões sudo (se precisar executar tarefas privilegiadas)
-   ✅ Shell válido (bash, sh, etc.)

## Conhecimentos Prévios Recomendados

### Essenciais

Para aproveitar melhor este guia, você deve ter conhecimento básico de:

1.  Linux/Unix
    -   Navegação no terminal
    -   Comandos básicos (ls, cd, mkdir, etc.)
    -   Gerenciamento de arquivos e permissões

2.  SSH
    -   Como conectar via SSH
    -   Conceito de chaves públicas/privadas
    -   Configuração básica de SSH

3.  Linha de Comando
    -   Executar comandos
    -   Entender saídas de comandos
    -   Usar editores de texto (nano, vim)

### Desejáveis

Conhecimentos que ajudam, mas não são obrigatórios:

1.  YAML
    -   Sintaxe básica
    -   Estrutura de dados (listas, dicionários)

2.  Redes
    -   Conceitos de IP, portas
    -   DNS básico
    -   Firewall

3.  Administração de Sistemas
    -   Gerenciamento de pacotes (apt, yum)
    -   Serviços e systemd
    -   Configuração de servidores

## Checklist de Pré-requisitos

Antes de prosseguir, verifique:

### Nó de Controle

-   Sistema operacional compatível instalado
-   Python 3.8+ instalado
-   Acesso sudo/root disponível
-   Conexão de rede estável
-   Espaço em disco suficiente (mínimo 1 GB)

### Nós Gerenciados

-   SSH habilitado e acessível
-   Python instalado
-   Usuário com permissões adequadas criado
-   Firewall permite conexões SSH
-   Conectividade de rede com o nó de controle

### Conhecimentos

-   Confortável com linha de comando Linux
-   Entende conceitos básicos de SSH
-   Sabe editar arquivos de texto no terminal
-   Conhece comandos básicos de administração

## Preparando o Ambiente

### 1. Atualizar o sistema

No nó de controle (Ubuntu):
```
sudo apt update && sudo apt upgrade -y
```

```
sudo apt update && sudo apt upgrade -y
```

### 2. Instalar Python (se necessário)

```
sudo apt install python3 python3-pip -y
```

```
sudo apt install python3 python3-pip -y
```

### 3. Configurar SSH

Gerar chave SSH (se não tiver):

```
ssh-keygen -t ed25519 -C "seu-email@example.com"
```

```
ssh-keygen -t ed25519 -C "seu-email@example.com"
```

### 4. Testar conectividade

Testar SSH para um servidor:

```
ssh usuario@ip-do-servidor
```

```
ssh usuario@ip-do-servidor
```

## Ambientes de Teste

Se você não tem servidores físicos, pode usar:

### Opção 1: Máquinas Virtuais Locais

-   VirtualBox: Gratuito, fácil de usar
-   VMware Workstation: Mais recursos
-   KVM/QEMU: Para Linux

### Opção 2: Containers Docker

```
# Criar container para testes
docker run -d --name ansible-test \
  -p 2222:22 \
  ubuntu:24.04
```

```
# Criar container para testes
docker run -d --name ansible-test \
  -p 2222:22 \
  ubuntu:24.04
```

### Opção 3: Cloud Providers

-   AWS Free Tier: 12 meses grátis
-   Google Cloud: $300 em créditos
-   DigitalOcean: $200 em créditos (com cupom)
-   Azure: $200 em créditos

### Opção 4: Vagrant

Vagrantfile:

```
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"
  
  config.vm.define "server1" do |server|
    server.vm.hostname = "server1"
    server.vm.network "private_network", ip: "192.168.56.10"
  end
end
```

```
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"
  
  config.vm.define "server1" do |server|
    server.vm.hostname = "server1"
    server.vm.network "private_network", ip: "192.168.56.10"
  end
end
```

Executar:

```
vagrant up
```

## Verificação Final

Execute estes comandos para verificar se está tudo pronto:

```
# Verificar Python
python3 --version

# Verificar SSH
ssh -V

# Verificar conectividade (substitua pelo seu servidor)
ping -c 3 192.168.1.100

# Verificar acesso SSH (substitua pelo seu servidor)
ssh -o ConnectTimeout=5 usuario@192.168.1.100 "echo 'SSH OK'"
```

```
# Verificar Python
python3 --version

# Verificar SSH
ssh -V

# Verificar conectividade (substitua pelo seu servidor)
ping -c 3 192.168.1.100

# Verificar acesso SSH (substitua pelo seu servidor)
ssh -o ConnectTimeout=5 usuario@192.168.1.100 "echo 'SSH OK'"
```

Se todos os comandos funcionarem, você está pronto para instalar o Ansible!

----------

## Próximos Passos

Agora que você verificou todos os pré-requisitos, vamos instalar o Ansible:

➡️ [Instalação no Ubuntu 24.04](/02-instalacao-ubuntu.md)
