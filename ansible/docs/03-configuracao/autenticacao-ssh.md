# Autenticação SSH

A autenticação SSH é fundamental para o funcionamento do Ansible. Este guia cobre as melhores práticas.

## Tipos de Autenticação

### 1. Autenticação por Chave SSH (Recomendado)

A forma mais segura e recomendada.

**Vantagens:**
- ✅ Mais seguro que senha
- ✅ Sem necessidade de digitar senha
- ✅ Ideal para automação
- ✅ Suporta passphrases

**Desvantagens:**
- ❌ Requer gerenciamento de chaves

### 2. Autenticação por Senha

Simples, mas menos segura.

**Vantagens:**
- ✅ Fácil de configurar
- ✅ Não requer gerenciamento de chaves

**Desvantagens:**
- ❌ Menos seguro
- ❌ Requer digitar senha
- ❌ Não ideal para automação

## Configurando Chaves SSH

### Passo 1: Gerar Par de Chaves

Gere um novo par de chaves SSH:
```bash
ssh-keygen -t ed25519 -C "ansible-automation" -f ~/.ssh/ansible_key
```

#### Explicação:
-   -t ed25519: Algoritmo moderno e seguro
-   -C "ansible-automation": Comentário identificador
-   -f ~/.ssh/ansible_key: Caminho do arquivo

#### Por que Ed25519?

Comparação de algoritmos:
### Comparação de Métodos
| Algoritmo                      | Tamanho                           | Segurança              | Performance            | Recomendado           
|--------------------------------|-----------------------------------|------------------------|------------------------|------------------------|
| RSA 2048                       | 2048 bits                         | Boa                    | Lenta                  | ❌ Obsoleto            | 
| RSA 4096                       | 4096 bits                         | Excelente              | Muito lenta            | ⚠️ Aceitável           |
| ECDSA                          | 256 bits                          | Boa                    | Rápida                 | ⚠️ Aceitável           |
| Ed25519                        | 256 bits                          | Excelente              | Muito rápida           | ✅ Recomendado         |

#### Ed25519 é melhor porque:
- Mais seguro que RSA
- Chaves menores (256 bits)
- Performance superior
- Resistente a ataques de timing

### Passo 2: Verificar Permissões

As permissões das chaves são críticas:
```bash
# Verificar permissões
ls -la ~/.ssh/ansible_key*

# Saída esperada:
# -rw------- 1 user user  411 Dec 29 10:00 .ssh/ansible_key
# -rw-r--r-- 1 user user  102 Dec 29 10:00 .ssh/ansible_key.pub
```

### Permissões corretas:
- Chave privada: 600 (rw-------)
- Chave pública: 644 (rw-r--r--)
- Diretório ~/.ssh: 700 (rwx------)

Se as permissões estiverem erradas:
```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/ansible_key
chmod 644 ~/.ssh/ansible_key.pub
```

### Passo 3: Copiar Chave Pública para o Servidor

Use ssh-copy-id para copiar a chave:
```bash
ssh-copy-id -i ~/.ssh/ansible_key.pub root@192.168.1.100
```

#### Saída esperada: 
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/user/.ssh/ansible_key.pub"
/usr/bin/ssh-copy-id: INFO: attempting to connect to host "192.168.1.100" with user "root"
root@192.168.1.100's password: [digite a senha]

Number of key(s) added: 1

Now try logging in with:
   "ssh -i ~/.ssh/ansible_key root@192.168.1.100"

and check to add the new hosts key to 'known_hosts'.

#### O que ssh-copy-id faz:
1. Lê a chave pública
2. Conecta ao servidor via SSH
3. Adiciona a chave ao arquivo ~/.ssh/authorized_keys

### Passo 4: Testar Conexão

Teste se a autenticação funciona:
```bash
ssh -i ~/.ssh/ansible_key root@192.168.1.100
```

#### Saída esperada:
Welcome to Ubuntu 24.04 LTS (GNU/Linux 6.8.0-28-generic x86_64)
```bash
root@pve01:~#
```

Se funcionar, você pode sair:
```bash
exit
```

## Configurando no Inventário

### Método 1: Especificar no Inventário
```ini
[proxmox]
pve01 ansible_host=192.168.1.100 ansible_user=root ansible_ssh_private_key_file=~/.ssh/ansible_key
```

### Método 2: Usar Arquivo de Configuração SSH

Crie ~/.ssh/config:
```bash
Host pve01
    HostName 192.168.1.100
    User root
    IdentityFile ~/.ssh/ansible_key
    StrictHostKeyChecking no
```

Então no inventário:
```ini
[proxmox]
pve01
```

### Método 3: Usar ansible.cfg
```ini
[defaults]
private_key_file = ~/.ssh/ansible_key

[ssh_connection]
ssh_args = -i ~/.ssh/ansible_key
```

## Resolvendo Problemas de Conexão

### Problema 1: Host Key Verification Failed

#### Erro:
The authenticity of host '192.168.1.100' can't be established.

#### Causa:
Chave do host não está em ~/.ssh/known_hosts

##### Solução 1: Aceitar manualmente
```bash
ssh-keyscan -H 192.168.1.100 >> ~/.ssh/known_hosts
```

##### Solução 2: Desabilitar verificação (apenas para labs)
```bash
export ANSIBLE_HOST_KEY_CHECKING=False
```

##### Solução 2: Desabilitar verificação (apenas para labs)
```bash
export ANSIBLE_HOST_KEY_CHECKING=False
```

Ou em ansible.cfg:
```ini
[defaults]
host_key_checking = False
```

### Problema 2: Permission Denied

#### Erro:
Permission denied (publickey,password).

#### Causas possíveis:
1. Chave privada com permissões erradas
2. Chave pública não copiada corretamente
3. Usuário errado

##### Solução: 1:
```bash
# Verificar permissões
ls -la ~/.ssh/ansible_key

# Deve ser: -rw------- (600)
chmod 600 ~/.ssh/ansible_key

# Testar com verbose
ssh -vvv -i ~/.ssh/ansible_key root@192.168.1.100
```
