
# Sobre o Ansible

O Ansible é uma ferramenta de automação de TI open-source que revolucionou a forma como gerenciamos infraestrutura.

## O que é o Ansible?

Ansible é uma plataforma de automação que permite:

- **Gerenciamento de Configuração:** Manter servidores no estado desejado
- **Provisionamento de Infraestrutura:** Criar e configurar recursos automaticamente
- **Orquestração de Aplicações:** Coordenar deploys complexos
- **Automação de Tarefas:** Eliminar trabalho manual repetitivo

---

## Características Principais

### 1. Agentless (Sem Agentes)

Diferente de outras ferramentas, o Ansible não requer instalação de agentes nos servidores gerenciados.
```text
┌─────────────────┐         SSH          ┌─────────────────┐
│  Nó de Controle │  ─────────────────>  │   Servidor 1    │
│  (Ansible)      │                      │  (Sem agente)   │
└─────────────────┘                      └─────────────────┘
```

