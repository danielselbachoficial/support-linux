# Testando Conectividade

Antes de executar playbooks complexos, vamos verificar se o Ansible consegue se conectar aos seus servidores.

## Teste Básico com Ping

O módulo `ping` do Ansible é a forma mais simples de testar conectividade.

### Executar Ping
```bash
ansible proxmox -i ~/ansible/hosts -m ping
```

#### Saída esperada:
```json
192.168.1.100 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
```

Desenvolvendo...
