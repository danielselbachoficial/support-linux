# Manual de Configuração de Cliente WireGuard para Debian

## Objetivo

Este manual visa guiar você na configuração de um cliente WireGuard em um sistema Debian, permitindo que ele estabeleça uma conexão VPN segura com um servidor WireGuard. O WireGuard é uma VPN moderna, rápida e criptograficamente sólida, ideal para garantir a segurança e a privacidade da comunicação.

## Pré-requisitos

Antes de iniciar a configuração do cliente, certifique-se de que você tem:

1.  **Sistema Operacional:** Uma máquina rodando Debian ou um sistema operacional baseado em Debian (como Ubuntu, Linux Mint).
2.  **Acesso Administrativo:** Permissões de usuário com `sudo` ou acesso `root` no cliente Debian.
3.  **Informações do Servidor WireGuard:**
    *   **Endereço IP Público ou Nome do Host do Servidor:** Ex: `vpn.lab` ou `203.0.113.10`.
    *   **Porta do Servidor WireGuard:** Por padrão, `51820` (UDP).
    *   **Chave Pública do Servidor WireGuard:** Uma sequência alfanumérica longa (ex: `AbCdeFgTiJsXmSoDdRsquVduyZ0123456789+...`).
    *   **Preshared Key (PSK) do Servidor (Opcional, mas altamente recomendado):** Se o servidor a usa, você precisará da mesma PSK.
    *   **Endereço IP Interno para o Cliente:** Um endereço IP que o servidor WireGuard atribuirá ao seu cliente dentro da rede VPN (ex: `10.0.0.2/32`). Este IP será usado para a comunicação dentro do túnel VPN.

## Seção 1: Instalação do WireGuard no Cliente Debian

O primeiro passo é instalar o pacote WireGuard no seu sistema Debian.

1.  **Atualizar a lista de pacotes:**

    ```bash
    sudo apt update
    ```

2.  **Instalar o WireGuard e o `resolvconf`:**
    O `resolvconf` é útil para gerenciar as configurações de DNS.

    ```bash
    sudo apt install wireguard resolvconf
    ```

## Seção 2: Geração das Chaves do Cliente

Cada cliente WireGuard precisa de um par de chaves (privada e pública) para identificação e criptografia. É crucial que a chave privada seja mantida em segredo absoluto e tenha permissões de arquivo restritivas.

1.  **Definir permissões de arquivo restritivas (umask):**
    Execute este comando antes de gerar as chaves para garantir que os arquivos gerados tenham as permissões corretas.

    ```bash
    umask 077
    ```

2.  **Gerar o par de chaves (privada e pública):**
    Este comando irá gerar uma chave privada e salvar em `privatekey`, e a chave pública correspondente será salva em `publickey`.

    ```bash
    wg genkey | tee privatekey | wg pubkey > publickey
    ```
    *   A chave privada será exibida na tela e salva no arquivo `privatekey`.
    *   A chave pública será salva no arquivo `publickey`.

3.  **Anote sua Chave Pública:**
    Você precisará fornecer o conteúdo do arquivo `publickey` ao administrador do seu servidor WireGuard. Ele adicionará sua chave pública à configuração do servidor para permitir sua conexão e atribuirá um endereço IP interno para seu cliente.

    ```bash
    cat publickey
    ```
    *(Copie a saída deste comando e forneça ao administrador do servidor.)*

## Seção 3: Criação e Configuração do Arquivo da Interface WireGuard

Agora, você criará o arquivo de configuração para a sua interface WireGuard. O nome deste arquivo será o nome da sua interface VPN.

1.  **Escolha um Nome para a Interface:**
    Escolha um nome descritivo para sua interface WireGuard. Por exemplo, `wg0` para sua conexão principal, ou `lab_vpn` se for para um ambiente de laboratório. Para este manual, usaremos `lab_vpn` como exemplo.

2.  **Crie e edite o arquivo de configuração:**

    ```bash
    sudo nano /etc/wireguard/lab_vpn.conf
    ```

3.  **Insira a Configuração no Arquivo:**
    Cole o conteúdo abaixo, substituindo os `<SEUS_VALORES_AQUI>` pelas informações relevantes que você obteve nos pré-requisitos e na geração de chaves.

    ```ini
    # /etc/wireguard/lab_vpn.conf
    # Configuração para a VPN de Lab
    # Cliente: Lab VPN
    # Propósito: Acesso seguro à rede de produção (ex: 10.0.0.0/24) e ao servidor de arquivos (ex: 10.0.1.0/24)

    [Interface]
    # Sua chave privada (conteúdo do arquivo 'privatekey' gerado na Seção 2)
    PrivateKey = <SUA_CHAVE_PRIVADA_AQUI>
    # O endereço IP que o servidor WireGuard atribuiu a este cliente dentro da rede VPN (ex: 10.0.0.2/32)
    Address = <ENDERECO_IP_CLIENTE_VPN>/32
    # Servidores DNS a serem usados quando o túnel VPN estiver ativo.
    # Se você precisa resolver nomes internos, inclua o IP do DNS interno aqui.
    # Ex: DNS interno da rede de produção (10.0.0.1) e Google DNS (8.8.8.8) para internet.
    DNS = 10.0.0.1, 8.8.8.8

    [Peer]
    # Chave Pública do SERVIDOR WireGuard (fornecida pelo administrador do servidor)
    PublicKey = <CHAVE_PUBLICA_DO_SERVIDOR_AQUI>
    # Endereço IP público ou nome de host do servidor WireGuard e a porta (ex: vpn.lab:51820)
    Endpoint = <IP_OU_HOSTNAME_DO_SERVIDOR_VPN>:<PORTA>
    # Preshared Key (PSK) para uma camada extra de segurança.
    # DEVE ser a mesma configurada no servidor para o seu peer.
    PresharedKey = <SUA_PRESHARED_KEY_AQUI>
    # Redes que serão roteadas ATRAVÉS do túnel VPN.
    #
    # Opção 1: Full Tunnel (Todo o tráfego de internet via VPN)
    # AllowedIPs = 0.0.0.0/0
    # Isso fará com que sua saída para a internet seja pelo servidor VPN.
    #
    # Opção 2: Split Tunnel (Apenas tráfego para redes específicas via VPN, internet via roteador local)
    # Lista de IPs ou sub-redes que você quer acessar via VPN.
    # Ex: Acessar a rede de produção (10.0.0.0/24) e a rede de servidores (10.0.1.0/24)
    AllowedIPs = 10.0.0.0/24, 10.0.1.0/24
    # Com o Split Tunnel, seu IP público na internet permanecerá o do seu roteador local.
    #
    # Manter conexão ativa: Envia um pequeno pacote a cada 25 segundos para manter o túnel ativo,
    # útil em redes com NAT ou firewalls que encerram conexões inativas.
    PersistentKeepalive = 25
    ```

4.  **Salve o arquivo e saia do editor:**
    No `nano`, pressione `Ctrl+O` para salvar, `Enter` para confirmar o nome do arquivo e `Ctrl+X` para sair.

## Seção 4: Gerenciamento da Conexão WireGuard

Após configurar o arquivo, você pode ativar e desativar sua interface WireGuard.

1.  **Ativar a interface WireGuard:**

    ```bash
    sudo wg-quick up lab_vpn
    ```

2.  **Verificar o status da conexão:**
    Isso mostrará detalhes sobre a interface, chaves, peers conectados e tráfego.

    ```bash
    sudo wg show lab_vpn
    ```
    Para ver todas as interfaces WireGuard ativas:
    ```bash
    sudo wg show
    ```

3.  **Desativar a interface WireGuard:**

    ```bash
    sudo wg-quick down lab_vpn
    ```

## Seção 5: Habilitar o Início Automático no Boot (Opcional)

Se você deseja que a conexão WireGuard seja iniciada automaticamente sempre que o sistema for ligado:

1.  **Habilitar o serviço `systemd`:**

    ```bash
    sudo systemctl enable wg-quick@lab_vpn
    ```

2.  **Iniciar o serviço imediatamente (se já não estiver ativo):**

    ```bash
    sudo systemctl start wg-quick@lab_vpn
    ```

Para desabilitar o início automático:

```bash
sudo systemctl disable wg-quick@lab_vpn
```

## Seção 6: Testando a Conexão

Após ativar a VPN, é importante verificar se ela está funcionando como esperado.

1.  **Verificar seu Endereço IP Público (para Full Tunnel):**
    Se você configurou `AllowedIPs = 0.0.0.0/0` (Full Tunnel), seu IP público deve mudar para o do servidor VPN.

    ```bash
    curl ifconfig.me
    ```
    Compare o IP retornado com o IP do seu servidor WireGuard. Se for o mesmo, a VPN está funcionando como Full Tunnel.

2.  **Verificar seu Endereço IP Público (para Split Tunnel):**
    Se você configurou `AllowedIPs` para redes específicas (Split Tunnel), seu IP público **não** deve mudar.

    ```bash
    curl ifconfig.me
    ```
    O IP retornado deve ser o do seu IP Público do seu roteador local.

3.  **Testar Acesso a Recursos Internos (para Split Tunnel ou Full Tunnel):**
    Tente acessar um recurso (ex: um servidor de arquivos, uma página web interna) que esteja localizado em uma das redes que você incluiu nos `AllowedIPs`. Se conseguir acessar, sua VPN está roteando o tráfego corretamente para essas redes.

## Considerações Finais e Solução de Problemas

*   **Configuração do Servidor:** Este manual é focado no cliente. A funcionalidade da VPN depende crucialmente de o servidor WireGuard estar corretamente configurado para aceitar sua chave pública, atribuir o IP interno e rotear o tráfego.
*   **Firewall:** Certifique-se de que nenhum firewall (como `ufw` no cliente ou regras no roteador) esteja bloqueando a porta UDP que o WireGuard utiliza (padrão 51820) para o `Endpoint` do servidor.
*   **Chaves Únicas:** Cada interface WireGuard (seja `wg0`, `lab_vpn`, etc.) deve ter seu próprio par de chaves privada/pública e seu próprio `Address` IP interno.
*   **Permissões de Arquivo:** A chave privada (`privatekey`) deve ter permissões restritivas (`-rw-------` ou `600`). Se não tiver, corrija com `sudo chmod 600 /etc/wireguard/lab_vpn.conf` (e para o arquivo `privatekey` se o tiver separado).
