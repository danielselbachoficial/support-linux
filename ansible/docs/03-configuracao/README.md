# Configuração do Ansible

Nesta seção, você aprenderá como configurar o Ansible para gerenciar seus servidores.

## Conteúdo desta seção

- [Inventário](inventario.md) - Definir quais servidores gerenciar
- [Autenticação SSH](autenticacao-ssh.md) - Configurar acesso seguro
- [Arquivo ansible.cfg](ansible-cfg.md) - Personalizar comportamento do Ansible

## O que você vai aprender

Nesta seção, você entenderá:

1. Como criar e organizar inventários
2. Como configurar autenticação SSH
3. Como personalizar o comportamento do Ansible
4. Como estruturar projetos profissionais

## Conceitos Fundamentais

### Inventário

O inventário é onde você define:
- Quais servidores o Ansible gerenciará
- Como agrupar servidores
- Variáveis específicas de cada servidor

### Autenticação

O Ansible precisa de acesso aos servidores via:
- SSH com chaves (recomendado)
- SSH com senha (não recomendado)
- Outros métodos (WinRM para Windows, etc.)

### Configuração

O arquivo `ansible.cfg` controla:
- Comportamento padrão do Ansible
- Caminhos de busca
- Opções de performance
- Configurações de segurança

## Fluxo de Configuração

Criar Inventário
↓
Configurar SSH
↓
Personalizar ansible.cfg
↓
Testar Conectividade

## Próximos Passos

Comece criando seu inventário:

➡️ [Inventário](inventario.md)

---

[← Voltar: Instalação](../02-instalacao/) | [Índice](../../README.md) | [Próximo: Inventário →](inventario.md)
