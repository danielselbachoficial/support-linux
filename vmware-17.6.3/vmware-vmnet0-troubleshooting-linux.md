# VMware Workstation Pro - Diagnóstico e Correção do vmnet0 em Diversas Distribuições Linux

Este manual documenta as etapas para corrigir o problema em que o adaptador `vmnet0` (modo Bridge) não aparece no VMware Workstation Pro em sistemas baseados em Linux.

Compatível com:

* Ubuntu, Zorin OS, Linux Mint, Pop!\_OS
* Debian
* Fedora, CentOS, RHEL
* Arch Linux, Manjaro

---

## ✅ Diagnóstico e Solução

### 1. Executar o VMware como superusuário

```bash
sudo vmware
```

Isso pode permitir que o `vmnet0` seja criado corretamente.

---

### 2. Verificar a instalação dos módulos do VMware

Verifique se os módulos estão carregados:

```bash
lsmod | grep vmw
```

Se ausentes, recompile:

```bash
sudo vmware-modconfig --console --install-all
```

---

### 3. Instalar dependências necessárias

#### Ubuntu/Debian/Zorin/Mint:

```bash
sudo apt update
sudo apt install build-essential linux-headers-$(uname -r) samba-common-bin
```

#### Fedora/RHEL/CentOS:

```bash
sudo dnf install gcc kernel-devel kernel-headers make
```

#### Arch/Manjaro:

```bash
sudo pacman -S base-devel linux-headers
```

---

### 4. Reiniciar os serviços de rede do VMware

#### Ubuntu/Debian-based:

```bash
sudo systemctl restart vmware.service
sudo /usr/bin/vmware-networks --start
```

#### Fedora/CentOS:

```bash
sudo systemctl restart vmware.service
```

#### Arch:

```bash
sudo systemctl restart vmware-networks.service
```

---

### 5. Editor de Redes Virtuais do VMware

Abra com privilégios de superusuário:

```bash
sudo vmware-netcfg
```

Verifique:

* `vmnet0` está como "Bridged"
* Associado à interface física (ex: `eth0`, `wlan0`)

---

### 6. Verificar o dispositivo `/dev/vmnet0`

```bash
ls -l /dev/vmnet0
```

Se ausente, os módulos não foram carregados corretamente. Volte à etapa 2.

---

### 7. Testar a interface criada

```bash
ip link show | grep vmnet
```

Se `vmnet0` aparecer com `UP`, o modo bridge está ativo.

---

Este guia é adaptável a diversas distribuições Linux. Ajustes finos podem ser necessários conforme a arquitetura do sistema e versão do kernel.
