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

| Método                    | Vantagens                         | Desvantagens           |   
|---------------------------|-----------------------------------|------------------------|
| Gerenciador de Pacotes    | Fácil, atualizações automáticas   | Versão pode ser antiga
| PPA Oficial               | Versão mais recente, estável      | Apenas Ubuntu/Debian
| pip                       | Versão mais recente, flexível     | Requer gerenciar dependências
| Código-fonte              | Versão de desenvolvimento         | Instável, complexo

### Recomendação


Para a maioria dos usuários, recomendamos:

- Ubuntu/Debian: Use o PPA oficial (mais recente e estável)
- CentOS/RHEL: Use EPEL + DNF/YUM
- macOS: Use Homebrew
- Outros: Use pip



### Versões do Ansible

Ansible Core vs Ansible:
- ansible-core: Pacote mínimo com funcionalidades essenciais
- ansible: Pacote completo com collections incluídas




#### Instalar apenas o core
```bash
pip3 install ansible-core
```


#### Instalar pacote completo
```bash
pip3 install ansible
```



### Verificação Pós-Instalação

Após instalar, sempre verifique:

```bash
### Versão do Ansible
ansible --version
```


#### Localização do executável
```
which ansible
```


#### Módulos disponíveis
```bash
ansible-doc -l | wc -l
```


### Próximos Passos

Escolha seu sistema operacional e siga o guia de instalação:

- ➡️ [Ubuntu 24.04 (Recomendado para iniciantes)](./ubuntu-24-04.md)
- ➡️ [Outras Distribuições](./outras-distros.md)

---

[← Voltar ao Índice](../../README.md) | [Próxima Seção: Configuração →](../03-configuracao)
---
