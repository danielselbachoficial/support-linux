# 🛠 Guia de Instalação e Configuração - NextDNS

Este guia detalha os diferentes métodos de instalação do NextDNS, desde o cliente oficial até configurações manuais em resolvedores de terceiros.

> **Importante:** Substitua `554499` (ou `SEU_ID`) pelo seu ID de configuração pessoal encontrado no painel do NextDNS.

---

## 1. Cliente CLI (Recomendado)
O cliente de linha de comando é a forma mais robusta de usar o NextDNS no Linux, pois oferece cache local e identificação automática de dispositivos.

### Instalação
Execute o comando oficial:
```bash
sh -c "$(curl -sL [https://nextdns.io/install](https://nextdns.io/install))"
`

> **Importante:** Siga as instruções no terminal para inserir seu ID e ativar o serviço.

---
### Otimização de Performance
Após a instalação, aplique estas configurações para garantir uma navegação mais rápida e logs detalhados:

```bash
# Ativa o cache local (respostas mais rápidas)
sudo nextdns config set -cache-size 10MB
sudo nextdns config set -cache-max-age 10m

# Envia o nome do seu PC (LAP-DANIEL) para os logs web
sudo nextdns config set -report-client-info true

# Reinicia o serviço para aplicar
sudo nextdns restart
`

⚠️ Resolvendo Erro de Hostname (Sudo)
Se após a instalação você visualizar o erro:

sudo: não foi possível resolver máquina [NOME-DO-PC]: Nome ou serviço desconhecido

A solução é adicionar o nome da máquina ao arquivo de hosts local:

1. Verificar o nome do PC: hostname
2. Edite o arquivo: sudo nano /etc/hosts ou sudo vim /etc/hosts
3. Adicione seu hostname à linha do IP local:

# Informação para adicionar no arquivo "hosts"
127.0.0.1   localhost [NOME-DO-PC]
::1         localhost [NOME-DO-PC]

4. Salve o arquivo que foi editado:
Com nano: Salve (Ctrl+O, Enter) e saia (Ctrl+X)
Com vim: :wq (Salvar e sair)

---
## 2. Configurações Manuais e Resolvedores

### Systemd-Resolved (Nativo do Ubuntu)
Edite o arquivo /etc/systemd/resolved.conf:
```bash
[Resolve]
DNS=45.90.28.0#554499.dns.nextdns.io
DNS=2a07:a8c0::#554499.dns.nextdns.io
DNS=45.90.30.0#554499.dns.nextdns.io
DNS=2a07:a8c1::#554499.dns.nextdns.io
DNSOverTLS=yes
`

### DNSMasq
Adicione ao seu dnsmasq.conf:
```bash
no-resolv
bogus-priv
strict-order
server=45.90.28.0
server=45.90.30.0
add-cpe-id=554499
`

### DNSCrypt-Proxy
No arquivo dnscrypt-proxy.toml:
```bash
server_names = ['NextDNS-554499']

[static]
  [static.'NextDNS-554499']
  stamp = 'sdns://AgEAAAAAAAAAAAAOZG5zLm5leHRkbnMuaW8HLzg2ODE0Ng'
`

### Unbound
No arquivo unbound.conf:
```bash
forward-zone:
  name: "."
  forward-tls-upstream: yes
  forward-addr: 45.90.28.0#554499.dns.nextdns.io
  forward-addr: 45.90.30.0#554499.dns.nextdns.io
`

---
## 3. Endereços de IP Diretos

|Tipo de Conexão |Servidor Primário              |Servidor Secundário          |
|----------------|-------------------------------|-----------------------------|
|IPv4            |45.90.28.64                    |45.90.30.64                  |
|IPv6            |2a07:a8c0::86:8146             |2a07:a8c1::86:8146           |

Tipo de Conexão,Servidor Primário,Servidor Secundário
IPv4 (com IP vinculado),45.90.28.64,45.90.30.64
IPv6,2a07:a8c0::86:8146,2a07:a8c1::86:8146
