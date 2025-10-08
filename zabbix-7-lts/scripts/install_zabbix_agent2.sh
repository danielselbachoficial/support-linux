#!/bin/bash

# ====================================================================================
# Script para Instalação e Configuração Automatizada do Zabbix Agent 2
# Versão: 1.0
# Compatibilidade: Debian 12 (Bookworm) para Zabbix 7.0 LTS
# ====================================================================================

# Cores para uma saída mais legível
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # Sem Cor

# --- Verificação de Segurança ---
# Garante que o script está sendo executado como root (ou com sudo)
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}ERRO: Este script precisa ser executado como root ou com sudo.${NC}" 
   exit 1
fi

echo -e "${GREEN}--- Início do Script de Instalação do Zabbix Agent 2 ---${NC}"

# --- Coleta de Informações do Usuário ---
echo -e "\n${YELLOW}Por favor, forneça as seguintes informações:${NC}"

read -p "-> Digite o IP ou DDNS do Zabbix Server (para Server=): " ZABBIX_SERVER
read -p "-> Digite o IP ou DDNS do Zabbix Server (para ServerActive=): " ZABBIX_SERVER_ACTIVE
read -p "-> Digite o Hostname para este host (deve ser idêntico ao cadastrado no Zabbix): " ZABBIX_HOSTNAME

# Validação simples das entradas
if [ -z "$ZABBIX_SERVER" ] || [ -z "$ZABBIX_SERVER_ACTIVE" ] || [ -z "$ZABBIX_HOSTNAME" ]; then
    echo -e "\n${RED}ERRO: Todas as informações são obrigatórias. Abortando.${NC}"
    exit 1
fi

echo -e "\n${GREEN}Obrigado! Iniciando a instalação com as seguintes informações:${NC}"
echo "   Server       : $ZABBIX_SERVER"
echo "   ServerActive : $ZABBIX_SERVER_ACTIVE"
echo "   Hostname     : $ZABBIX_HOSTNAME"
echo "----------------------------------------------------"

# --- Início da Instalação ---
# O comando 'set -e' garante que o script pare se algum comando falhar
set -e

echo -e "\n${YELLOW}Passo 1: Atualizando a lista de pacotes...${NC}"
apt update

echo -e "\n${YELLOW}Passo 2: Baixando e instalando o repositório do Zabbix 7.0 LTS...${NC}"
wget [https://repo.zabbix.com/zabbix/7.0/debian/pool/main/z/zabbix-release/zabbix-release_7.0-1%2Bdebian12_all.deb](https://repo.zabbix.com/zabbix/7.0/debian/pool/main/z/zabbix-release/zabbix-release_7.0-1%2Bdebian12_all.deb) -O /tmp/zabbix-release.deb
dpkg -i /tmp/zabbix-release.deb
apt update

echo -e "\n${YELLOW}Passo 3: Instalando o Zabbix Agent 2...${NC}"
apt install zabbix-agent2 -y

# --- Início da Configuração ---
echo -e "\n${YELLOW}Passo 4: Configurando o arquivo zabbix_agent2.conf...${NC}"
CONFIG_FILE="/etc/zabbix/zabbix_agent2.conf"

echo "   -> Criando backup do arquivo de configuração original em ${CONFIG_FILE}.bak"
cp $CONFIG_FILE ${CONFIG_FILE}.bak

echo "   -> Alterando 'Server' para: $ZABBIX_SERVER"
sed -i -E "s/^Server=127.0.0.1/Server=${ZABBIX_SERVER}/" $CONFIG_FILE

echo "   -> Alterando 'ServerActive' para: $ZABBIX_SERVER_ACTIVE"
sed -i -E "s/^ServerActive=127.0.0.1/ServerActive=${ZABBIX_SERVER_ACTIVE}/" $CONFIG_FILE

echo "   -> Alterando 'Hostname' para: $ZABBIX_HOSTNAME"
sed -i -E "s/^Hostname=Zabbix server/Hostname=${ZABBIX_HOSTNAME}/" $CONFIG_FILE

echo -e "${GREEN}Configuração aplicada com sucesso!${NC}"

# --- Finalização e Serviços ---
echo -e "\n${YELLOW}Passo 5: Reiniciando e habilitando o serviço do Zabbix Agent 2...${NC}"
systemctl restart zabbix-agent2
systemctl enable zabbix-agent2

echo -e "\n${GREEN}Serviço do Zabbix Agent 2 está ativo e configurado!${NC}"
systemctl status zabbix-agent2 --no-pager

# --- Informações Adicionais ---
echo -e "\n----------------------------------------------------"
echo -e "${YELLOW}Passo 6: Verificando pacotes que podem ser atualizados...${NC}"
apt list --upgradable

echo -e "\n----------------------------------------------------"
echo -e "${GREEN}--- Instalação Concluída! ---${NC}"
echo -e "\n${YELLOW}AÇÕES NECESSÁRIAS:${NC}"
echo -e "1. Lembre-se de cadastrar este host na interface web do Zabbix com o Hostname: ${GREEN}${ZABBIX_HOSTNAME}${NC}"
echo -e "2. Libere a porta ${GREEN}10050/TCP${NC} no firewall desta máquina, permitindo a entrada a partir do IP do Zabbix Server (${GREEN}${ZABBIX_SERVER}${NC})."
echo -e "   Comando de exemplo para UFW: ${GREEN}sudo ufw allow from ${ZABBIX_SERVER} to any port 10050 proto tcp${NC}"
echo "----------------------------------------------------"

exit 0
```
