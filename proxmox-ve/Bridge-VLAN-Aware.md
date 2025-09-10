# Configuração de Rede Proxmox VE: Bridge VLAN-Aware com VLAN de Gerenciamento Dedicada

Pré-requisitos
- Hardware: Um servidor com Proxmox VE instalado e pelo menos uma interface de rede física.
- Rede: Um switch de rede gerenciável que suporte VLANs.
- Configuração de Switch/Firewall: A porta do switch à qual o servidor Proxmox está conectado deve ser configurada como uma porta trunk (ou taggeada) para as VLANs especificadas em bridge-vids (ex: 20, 300-306). Seu firewall/roteador (ex: MikroTik) deve estar configurado para lidar com essas VLANs e atuar como gateway para elas.


### Conteúdo do Arquivo /etc/network/interfaces
''
# /etc/network/interfaces
# Interface de loopback
auto lo
iface lo inet loopback

# Interface física (Ex: eno1) configurada apenas como "manual"
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
  # A VLAN de gerenciamento (11) e as VLANs de serviço (300-306) são exemplos.
  bridge-vids 20 300-306
  mtu 1500                    # Maximum Transmission Unit

# VLAN 20 para gerenciamento do host Proxmox VE
# Esta sub-interface 'vmbr0.20' herda a capacidade VLAN-aware da vmbr0.
# O host Proxmox terá seu endereço IP de gerenciamento dentro desta VLAN isolada.
auto vmbr0.20
iface vmbr0.20 inet static
  address 172.20.0.2/29       # ENDEREÇO IP DO PROXMOX NESSA VLAN
  gateway 172.20.0.1          # GATEWAY DA VLAN 20 (geralmente o firewall/roteador)
  nameservers 172.20.0.1      # SERVIDORES DNS PARA O PROXMOX
  mtu 1500
  ''

### Explicação Detalhada
- Interface de Loopback (lo): Configuração padrão para a interface de loopback.
- Interface Física (eno1): A interface de rede física do seu servidor Proxmox. Ela é configurada como manual (sem IP), pois todo o tráfego será passado para a bridge vmbr0. Certifique-se de substituir eno1 pelo nome real da sua interface de rede física (ex: enp1s0, eth0, etc.).
- Bridge Principal VLAN-aware (vmbr0): Esta é a peça central.
- bridge-ports eno1: Conecta sua interface física à bridge.
- bridge-vlan-aware yes: Habilita a capacidade da bridge de entender e manipular tags de VLAN.
- bridge-vids 11 300-306: Lista as IDs de VLAN que a bridge permitirá que o tráfego passe. Ajuste estas IDs de acordo com as VLANs que você configurou em seu switch e firewall.
- VLAN de Gerenciamento (vmbr0.20): Uma sub-interface da vmbr0 dedicada ao tráfego de gerenciamento do host Proxmox.
- address, gateway, nameservers: PREENCHA COM OS VALORES DA SUA REDE DE GERENCIAMENTO.
