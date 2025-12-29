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
