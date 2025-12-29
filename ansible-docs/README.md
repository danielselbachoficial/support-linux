# Ansible - Guia Completo de Instalação e Configuração

[![Ansible](https://img.shields.io/badge/Ansible-2.19.5-EE0000?style=for-the-badge&logo=ansible&logoColor=white)](https://www.ansible.com/)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-24.04-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)](https://ubuntu.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](LICENSE)
[![YouTube](https://img.shields.io/badge/YouTube-Tutorial-red?style=for-the-badge&logo=youtube&logoColor=white)](SEU_LINK_AQUI)

> **Documentação completa para instalação, configuração e uso do Ansible em ambientes de produção**

Este repositório contém um guia completo e prático sobre Ansible, desde a instalação básica até configurações avançadas para ambientes de produção. Ideal para iniciantes e profissionais que desejam dominar a automação de infraestrutura.

---

## 📚 Índice da Documentação

### [1. Introdução](docs/01-introducao/)
- [Sobre o Ansible](docs/01-introducao/sobre-ansible.md)
- [Pré-requisitos](docs/01-introducao/pre-requisitos.md)

### [2. Instalação](docs/02-instalacao/)
- [Ubuntu 24.04](docs/02-instalacao/ubuntu-24-04.md)
- [Outras Distribuições](docs/02-instalacao/outras-distros.md)

### [3. Configuração](docs/03-configuracao/)
- [Inventário](docs/03-configuracao/inventario.md)
- [Autenticação SSH](docs/03-configuracao/autenticacao-ssh.md)
- [Arquivo ansible.cfg](docs/03-configuracao/ansible-cfg.md)

### [4. Primeiros Passos](docs/04-primeiros-passos/)
- [Testando Conectividade](docs/04-primeiros-passos/testando-conectividade.md)
- [Comandos Ad-hoc](docs/04-primeiros-passos/comandos-ad-hoc.md)

### [5. Collections](docs/05-collections/)
- [O que são Collections](docs/05-collections/o-que-sao-collections.md)
- [Collections Essenciais](docs/05-collections/collections-essenciais.md)
- [Criando Collections](docs/05-collections/criando-collections.md)

### [6. Playbooks](docs/06-playbooks/)
- [Estrutura Básica](docs/06-playbooks/estrutura-basica.md)
- [Roles](docs/06-playbooks/roles.md)
- [Handlers](docs/06-playbooks/handlers.md)

### [7. Projeto Profissional](docs/07-projeto-profissional/)
- [Estrutura Recomendada](docs/07-projeto-profissional/estrutura-recomendada.md)
- [Exemplos Completos](docs/07-projeto-profissional/exemplos-completos.md)

### [8. Melhores Práticas](docs/08-melhores-praticas/)
- [Segurança](docs/08-melhores-praticas/seguranca.md)
- [Idempotência](docs/08-melhores-praticas/idempotencia.md)
- [Organização](docs/08-melhores-praticas/organizacao.md)

### [9. Troubleshooting](docs/09-troubleshooting/)
- [Problemas Comuns](docs/09-troubleshooting/problemas-comuns.md)

### [10. Recursos](docs/10-recursos/)
- [Próximos Passos](docs/10-recursos/proximos-passos.md)
- [Referências](docs/10-recursos/referencias.md)

---

## 🚀 Início Rápido
```bash
# 1. Instalar dependências
sudo apt install software-properties-common -y

# 2. Adicionar PPA oficial
sudo apt-add-repository --yes --update ppa:ansible/ansible

# 3. Instalar Ansible
sudo apt install ansible -y

# 4. Verificar instalação
ansible --version
