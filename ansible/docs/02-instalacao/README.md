# Instalação do Ansible

Nesta seção, você aprenderá como instalar o Ansible em diferentes sistemas operacionais.

## Conteúdo desta seção

- Ubuntu 24.04 - Instalação detalhada no Ubuntu (recomendado)
- Outras Distribuições - CentOS, Debian, Fedora, macOS

## Métodos de Instalação
Existem várias formas de instalar o Ansible:

### 1. Via Gerenciador de Pacotes (Recomendado)

- Ubuntu/Debian: APT com PPA oficial
- CentOS/RHEL: YUM/DNF com EPEL
- Fedora: DNF
- macOS: Homebrew

### 2. Via pip (Python)

```bash
pip3 install ansible
```

### 3. Via código-fonte

```bash
git clone https://github.com/ansible/ansible.git

cd ansible
pip3 install -e 
```

## Qual método escolher?

| Método | Vantagens | Desvantagens |

| Método                    | Vantagens                         | Desvantagens           |   
|---------------------------|-----------------------------------|------------------------|
| Gerenciador de Pacotes    | Fácil, atualizações automáticas   | Versão pode ser antiga
| PPA Oficial               | Versão mais recente, estável      | Apenas Ubuntu/Debian
| pip                       | Versão mais recente, flexível     | Requer gerenciar dependências
| Código-fonte              | Versão de desenvolvimento         | Instável, complexo
