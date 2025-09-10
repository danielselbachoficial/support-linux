# Configuração de Rede Proxmox VE: Bridge VLAN-Aware com VLAN de Gerenciamento Dedicada

Este modelo de configuração para o arquivo `/etc/network/interfaces` no Proxmox VE demonstra como implementar uma bridge de rede \"VLAN-aware\". Esta abordagem permite segmentar o tráfego de rede para VMs e containers LXC em diferentes VLANs, usando apenas uma interface de rede física no servidor Proxmox. Além disso, configura uma VLAN dedicada para o gerenciamento do próprio host Proxmox, aumentando a segurança e a organização.

## Conteúdo do Arquivo `/etc/network/interfaces`

```bash
# /etc/network/interfaces
# Interface de loopback
auto lo
iface lo inet loopback

# Interface física (Ex: eno1) configurada apenas como \"manual\"
# Não atribua um endereço IP diretamente a esta interface.
# Ela servirá como porta de tronco (trunk) para a bridge vmbr0.
auto eno1
iface eno1 inet manual
  mtu 1500

# Bridge principal (vmbr0) configurada como VLAN-aware
# Esta bridge gerenciará o tráfego de todas as VLANs especificadas.
# O tráfego para as VLANs (e suas sub-interfaces, como vmbr0.20)
# será automaticamente taggeado/destaggeado pela bridge.
auto vmbr0
iface vmbr0 inet manual
  bridge-ports eno1          # Conecta a interface física eno1 à bridge
  bridge-stp off              # Desabilita Spanning Tree Protocol (geralmente gerenciado no switch físico)
  bridge-fd 0                 # Forward Delay em zero (sem atraso na transição de estados)
  bridge-vlan-aware yes       # Habilita a funcionalidade VLAN-aware na bridge
  # bridge-vids: Especifique as IDs de VLAN que esta bridge e as VMs/LXC usarão.
  # A VLAN de gerenciamento (20) e as VLANs de serviço (300-306) são exemplos.
  bridge-vids 20 300-306
  mtu 1500                    # Maximum Transmission Unit

# VLAN 20 para gerenciamento do host Proxmox VE
# Esta sub-interface 'vmbr0.20' herda a capacidade VLAN-aware da vmbr0.
# O host Proxmox terá seu endereço IP de gerenciamento dentro desta VLAN isolada.
auto vmbr0.20
iface vmbr0.20 inet static
  address 192.168.20.2/29       # ENDEREÇO IP DO PROXMOX NESSA VLAN
  gateway 192.168.20.1          # GATEWAY DA VLAN 20 (geralmente o firewall/roteador)
  nameservers 192.168.20.1      # SERVIDORES DNS PARA O PROXMOX
  mtu 1500
```

---

## Explicação Detalhada

*   **Interface de Loopback (`lo`)**: Configuração padrão para a interface de loopback.
*   **Interface Física (`eno1`)**: A interface de rede física do seu servidor Proxmox. Ela é configurada como `manual` (sem IP), pois todo o tráfego será passado para a bridge `vmbr0`. **Certifique-se de substituir `eno1` pelo nome real da sua interface de rede física (ex: `enp1s0`, `eth0`, etc.).**
*   **Bridge Principal VLAN-aware (`vmbr0`)**: Esta é a peça central.
    *   `bridge-ports eno1`: Conecta sua interface física à bridge.
    *   `bridge-vlan-aware yes`: Habilita a capacidade da bridge de entender e manipular tags de VLAN.
    *   `bridge-vids 20 300-306`: Lista as IDs de VLAN que a bridge permitirá que o tráfego passe. **Ajuste estas IDs de acordo com as VLANs que você configurou em seu switch e firewall.**
*   **VLAN de Gerenciamento (`vmbr0.20`)**: Uma sub-interface da `vmbr0` dedicada ao tráfego de gerenciamento do host Proxmox.
    *   `address`, `gateway`, `nameservers`: **PREENCHA COM OS VALORES DA SUA REDE DE GERENCIAMENTO.**

## Pré-requisitos

1.  **Hardware:** Um servidor com Proxmox VE instalado e pelo menos uma interface de rede física.
2.  **Rede:** Um switch de rede gerenciável que suporte VLANs.
3.  **Configuração de Switch/Firewall:** A porta do switch à qual o servidor Proxmox está conectado deve ser configurada como uma porta `trunk` (ou taggeada) para as VLANs especificadas em `bridge-vids` (ex: 20, 300-306). Seu firewall/roteador (ex: MikroTik) deve estar configurado para lidar com essas VLANs e atuar como gateway para elas.

## Como Usar

1.  **Faça Backup:** Antes de qualquer alteração, faça um backup do seu arquivo `/etc/network/interfaces` atual:
    ```bash
    cp /etc/network/interfaces /etc/network/interfaces.bak
    ```
2.  **Edite:** Use um editor de texto como `nano` para editar o arquivo:
    ```bash
    nano /etc/network/interfaces
    ```
3.  **Cole e Ajuste:** Cole o conteúdo acima e **ajuste os seguintes valores** para o seu ambiente:
    *   Nome da interface física (ex: `eno1`).
    *   As IDs de VLAN em `bridge-vids`.
    *   O endereço IP, gateway e nameservers para a VLAN de gerenciamento (`vmbr0.20`).
4.  **Aplique as Alterações:**
    *   Para aplicar as mudanças **sem reiniciar o servidor** (se não houver erros na configuração):
        ```bash
        ifreload -a
        ```
    *   Se `ifreload -a` não funcionar ou se você preferir, **reinicie o servidor**:
        ```bash
        reboot
        ```
        **Atenção:** Uma configuração incorreta pode resultar na perda de conectividade com o servidor. Tenha acesso físico ou acesso via KVM/iLO/IPMI para recuperação em caso de problemas.
5.  **Teste a Conectividade:** Após a aplicação das alterações (ou reboot), verifique se o host Proxmox está acessível pelo novo endereço IP de gerenciamento na VLAN 20.

## Configuração de VMs e LXC

Com esta configuração, ao criar ou editar uma VM/LXC no Proxmox, você poderá especificar a VLAN para a interface de rede virtual dessa VM/LXC diretamente na interface web do Proxmox, no campo \"VLAN Tag\" (ou \"VLAN ID\"). Por exemplo:

*   Para uma VM na VLAN de Serviços (VLAN 301), você definiria \"VLAN Tag: 301\".
*   Para um contêiner de lab (VLAN 305), você definiria \"VLAN Tag: 305\".

Isso permite que o tráfego da VM/LXC seja corretamente taggeado pela `vmbr0` e enviado para a VLAN correta na sua rede física.
