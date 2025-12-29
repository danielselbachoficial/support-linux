# Guia de Instalação e Configuração Técnica

Utilize o **ID de Perfil** gerado no seu painel do NextDNS para as configurações abaixo.

## 🛠 Métodos de Instalação

### Opção A: Cliente CLI (Recomendado)
Oferece cache local e identificação de nomes de dispositivos na rede.

1. **Instalar:**
   ```bash
   sh -c "$(curl -sL https://nextdns.io/install)"
   `
   
2. **Otimizar Performance:**
```bash
sudo nextdns config set -cache-size 10MB
sudo nextdns config set -cache-max-age 10m
sudo nextdns config set -report-client-info true
sudo nextdns restart
`
