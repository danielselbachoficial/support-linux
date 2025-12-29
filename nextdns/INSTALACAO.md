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
