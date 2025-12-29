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

```
ssh user@servidor "python3 --version"
```

### Permissões

O usuário usado pelo Ansible precisa de:
-   ✅ Acesso SSH ao servidor
-   ✅ Permissões sudo (se precisar executar tarefas privilegiadas)
-   ✅ Shell válido (bash, sh, etc.)
