Pergunta: ```markdown
# Manual de Configuração: Alertas Zabbix via Telegram

📋 Índice
1. Introdução
2. Pré-requisitos
3. Visão Geral do Script de Alerta Telegram
4. Configuração no Zabbix Frontend
5. Validação do Topic_ID com o script \"validate_telegram_system.sh\"
6. Criando o script \"telegra_alert.sh\"
7. Considerações finais

## 1. Introdução
Este manual fornece um guia completo e detalhado para configurar a integração entre o Zabbix e o Telegram, permitindo o envio automático de alertas de monitoramento diretamente para grupos específicos no Telegram, garantindo um monitoramento de infraestrutura 24/7 eficiente e confiável.

### 🎯 Objetivo da Integração
A integração Zabbix-Telegram oferece:

*   ✅ Monitoramento contínuo 24/7 da infraestrutura
*   ✅ Notificações em tempo real de problemas e recuperações
*   ✅ Organização por tópicos usando TOPIC_IDs específicos
*   ✅ Formatação rica com emojis e estrutura clara
*   ✅ Sistema de fallback robusto garantindo entrega das mensagens
*   ✅ Alertas instantâneos para equipes de TI e DevOps

### 📖 Escopo do Manual
Este manual foca exclusivamente na configuração do envio de mensagens do Zabbix para o Telegram para monitoramento 24/7, incluindo:

*   Configuração do Media Type no Zabbix
*   Criação de Actions personalizadas para diferentes cenários
*   Sistema de roteamento por TOPIC_IDs para organização
*   Teste e validação completa do sistema
*   Monitoramento contínuo e troubleshooting

*Nota: Este manual não aborda a configuração do Zabbix Agent ou problemas de conectividade entre Zabbix Server e Agents, focando exclusivamente no sistema de alertas via Telegram.*

## 2. Pré-requisitos
Antes de iniciar a configuração, certifique-se de que os seguintes requisitos estão atendidos:

### 🔧 Requisitos Técnicos
*   Zabbix Server operacional (versão 6.0 ou superior recomendada)
*   Acesso SSH ao servidor Zabbix com privilégios sudo
*   Conectividade de rede do servidor Zabbix para a internet (acesso à API do Telegram)
*   Acesso administrativo ao Zabbix Frontend
*   Script de alerta Telegram (telegram_alert.sh) instalado e configurado

### 🤖 Requisitos do Telegram
*   Bot do Telegram criado via [telegram.org](https://telegram.org)
*   Bot Token válido (exemplo fictício: 6891234567:AAFzBqC8D9E0F1G2H3I4J5K6L7M8N9O0P1Q)
*   Grupo/Canal do Telegram configurado para receber alertas
*   Chat ID do grupo (exemplo fictício: -1001987654321)
*   TOPIC_IDs configurados para organização de mensagens

### 📁 Estrutura de Arquivos
```bash
/usr/lib/zabbix/alertscripts/telegram_alert.sh      # Script principal
/var/log/zabbix/alertscripts/telegram.log           # Arquivo de logs
/var/log/zabbix/alertscripts/                       # Diretório de logs
```

### ⚠️ Importante
*Os valores de Bot Token (6891234567:AAFzBqC8D9E0F1G2H3I4J5K6L7M8N9O0P1Q) e Chat ID (-1001987654321) utilizados neste manual são totalmente fictícios e servem apenas como exemplo. Substitua pelos valores reais do seu ambiente.*

## 3. Visão Geral do Script de Alerta Telegram

### 📄 Finalidade do Script
O script `telegram_alert.sh` é responsável por:

*   Processar alertas enviados pelo Zabbix em tempo real
*   Extrair TOPIC_IDs dos assuntos dos alertas para roteamento
*   Formatar mensagens com emojis e estrutura clara para melhor visualização
*   Rotear alertas para tópicos específicos no Telegram
*   Implementar sistema de fallback para garantir entrega 24/7
*   Registrar logs detalhados para monitoramento e troubleshooting

### 📍 Localização do Script
```bash
/usr/lib/zabbix/alertscripts/telegram_alert.sh
```

### 🎯 Exemplos de TOPIC_IDs
O script utiliza TOPIC_IDs para organizar diferentes tipos de alertas em tópicos específicos, permitindo uma gestão eficiente do monitoramento 24/7:

| TOPIC_ID | Categoria                                                                        | Uso Recomendado                          |
|----------|----------------------------------------------------------------------------------|------------------------------------------|
| 2        | Recuperação - Brute Force                                                        | Ataques de segurança controlados         | 
| 4        | Recuperação - Incidentes Zabbix                                                  | Problemas do sistema de monitoramento    |
| 6        | Recuperação - Borda Clientes (Padrão)                                            | Conectividade e serviços gerais          |
| 76       | Operações                                                                        | Backups, manutenções, serviços           |
| 78       | Atualizações                                                                     | Configurações, software, patches         |

*Nota: Estes TOPIC_IDs são exemplos e podem ser variados ou estendidos para atender a diferentes necessidades de supergrupos ou categorias específicas de monitoramento. Você pode criar novos TOPIC_IDs conforme a estrutura organizacional da sua infraestrutura.*

### 🔧 Características Técnicas
*   ✅ Sistema de fallback triplo (formatação básica → texto simples → mensagem de emergência)
*   ✅ Logs detalhados para debug e monitoramento contínuo
*   ✅ Validação de TOPIC_IDs com categoria padrão
*   ✅ Escape de caracteres para evitar problemas de formatação
*   ✅ Timeout e retry automáticos para requisições
*   ✅ Monitoramento 24/7 sem interrupções

### 🔑 Configurações do Bot (Exemplo Fictício)
```bash
BOT_TOKEN=\"6891234567:AAFzBqC8D9E0F1G2H3I4J5K6L7M8N9O0P1Q\"  # Fictício
CHAT_ID=\"-1001987654321\"                                    # Fictício
DEFAULT_THREAD_ID=6                                           # Fictício
```

## 4. Configuração no Zabbix Frontend

### 4.1. Configuração do Media Type

#### 🖼️ Configuração Passo a Passo
1. Acesse o menu: Administration → Media types
2. Clique em: Create media type
3. Preencha os campos conforme a tabela acima
4. dicione os parâmetros:
- Clique em Add na seção "Script parameters"
- Parâmetro 1: Digite {ALERT.SUBJECT}
- Clique em Add novamente
- Parâmetro 2: Digite {ALERT.MESSAGE}
5. Marque: Enabled
6. Clique em: Add para salvar

#### ⚙️ Configurações Detalhadas
Campo	Valor
Nome	Telegram Alert System
Tipo	Script
Nome do script	telegram_alert.sh
Timeout do script	60s
Processamento simultâneo	1
Status	Habilitado ✅

#### 📝 Parâmetros do Script
Adicione exatamente 2 parâmetros na seguinte ordem:
- Parâmetro 1: {ALERT.SUBJECT}
- Parâmetro 2: {ALERT.MESSAGE}

### 4.2. Configuração do User Media

#### 🖼️ Configuração Passo a Passo
1. Acesse: Administration → Users
2. Clique no seu usuário
3. Vá para a aba: Media
4. Clique em: Add
5. Selecione o tipo: Telegram Alert System
6. Preencha "Send to": telegram
7. Configure período: 1-7,00:00-24:00 (24/7)
8. Marque todas as severidades
9. Marque: Enabled
10. Clique em: Add
11. Salve o usuário: Update

#### ⚙️ Configurações Detalhadas
Campo	Valor
Tipo	Telegram Alert System
Enviar para	telegram
Período ativo	1-7,00:00-24:00
Status	Habilitado ✅

#### 🎚️ Usar se gravidade
Marque todas as opções para monitoramento 24/7 completo:

☑️ Não classificado
☑️ Informação
☑️ Aviso
☑️ Média
☑️ Alta
☑️ Desastre

### 4.3. Criação das Actions (Ações)

#### 🖼️ Configuração Passo a Passo para Actions
1. Acesse: Configuration → Actions → Trigger actions
2. Clique em: Create action
3. Aba Action:
- Nome: Conforme especificado
- Condições: Adicione as condições necessárias
4. Aba Operations:
- Clique em Add em "Operations"
- Operation type: Send message
- Send to users: Selecione seu usuário
- Send only to: Telegram Alert System
- Subject: Cole o assunto personalizado
- Message: Cole a mensagem personalizada
5. Salve: Clique em Add


A. Ação para Problemas Gerais
🧭 Navegação
Configuration → Actions → Trigger actions → Create action
⚙️ Configurações Básicas
Nome: Telegram - Problemas Gerais
Tipo de evento: Problema
Status: Habilitado
🎯 Condições
Condição A: Gravidade >= Aviso
📤 Operações
Operação: Enviar mensagem
Enviar para usuários: [Seu usuário]
Enviar apenas para: Telegram Alert System
📧 Assunto Personalizado
[TOPIC_ID:6] 🚨 PROBLEMA: {TRIGGER.NAME} em {HOST.NAME}
💬 Mensagem Personalizada
🚨 Problema Detectado - Monitoramento 24/7

⚠️ Detalhes do Incidente
• Host: {HOST.NAME} ({HOST.IP})
• Problema: {TRIGGER.NAME}
• Gravidade: {TRIGGER.SEVERITY}
• Detectado em: {EVENT.DATE} {EVENT.TIME}
• Status: {TRIGGER.STATUS}

📊 Informações Técnicas
• Item: {ITEM.NAME}
• Valor atual: {ITEM.LASTVALUE}
• Valor limite: {TRIGGER.EXPRESSION}
• Evento ID: {EVENT.ID}

🔍 Ação Requerida
• Verificar imediatamente o host
• Investigar causa raiz do problema
• Aplicar correções necessárias

⏰ Monitoramento contínuo ativo
B. Ação para Recuperações
⚙️ Configurações Básicas
Nome: Telegram - Recuperações
Tipo de evento: Recuperação de problema
Status: Habilitado
🎯 Condições
Condição A: Gravidade >= Aviso
📤 Operações
Operação: Enviar mensagem
Enviar para usuários: [Seu usuário]
Enviar apenas para: Telegram Alert System
📧 Assunto Personalizado
[TOPIC_ID:6] ✅ RECUPERADO: {TRIGGER.NAME} em {HOST.NAME}
💬 Mensagem Personalizada
✅ Problema Resolvido - Sistema Restaurado

🔄 Recuperação Confirmada
• Host: {HOST.NAME} ({HOST.IP})
• Problema: {TRIGGER.NAME}
• Resolvido em: {EVENT.RECOVERY.DATE} {EVENT.RECOVERY.TIME}
• Duração total: {EVENT.DURATION}
• Gravidade: {TRIGGER.SEVERITY}

📈 Status Atual
• Item: {ITEM.NAME}
• Valor atual: {ITEM.LASTVALUE}
• Evento ID: {EVENT.ID}

🎯 Sistema Operacional
• Monitoramento normalizado
• Serviços funcionando corretamente
• Infraestrutura estável

⏰ Monitoramento 24/7 continuado
C. Ação Especializada - Brute Force
⚙️ Configurações Básicas
Nome: Telegram - Recuperação Brute Force
Tipo de evento: Recuperação de problema
Status: Habilitado
🎯 Condições
Condição A: Nome do trigger contém "brute force"
Condição B: OU Nome do trigger contém "login"
Condição C: OU Nome do trigger contém "ssh"
Condição D: OU Nome do trigger contém "attack"
📧 Assunto Personalizado
[TOPIC_ID:2] 🛡️ Brute Force Controlado: {TRIGGER.NAME} em {HOST.NAME}
💬 Mensagem Personalizada
🛡️ Ataque Brute Force Controlado - Segurança 24/7

🔐 Segurança Restaurada
• Host: {HOST.NAME} ({HOST.IP})
• Trigger: {TRIGGER.NAME}
• Controlado em: {EVENT.RECOVERY.DATE} {EVENT.RECOVERY.TIME}
• Duração do ataque: {EVENT.DURATION}
• Gravidade: {TRIGGER.SEVERITY}

🔍 Detalhes do Incidente
• Item monitorado: {ITEM.NAME}
• Valor detectado: {ITEM.LASTVALUE}
• Evento ID: {EVENT.ID}

🔒 Medidas de Segurança
• Sistema protegido e monitorado
• Logs de segurança atualizados
• Firewall e IDS ativos

⚠️ Recomendações
• Revisar logs de acesso
• Verificar contas de usuário
• Atualizar políticas de segurança

🛡️ Monitoramento de segurança 24/7 ativo

## 5. Validação do Topic_ID com o script "validate_telegram_system.sh"


validate_telegram_system.sh
```bash
#!/bin/bash

# =============================================================================
# Script de Descoberta e Validação de Tópicos do Telegram
# =============================================================================
# Este script descobre automaticamente todos os message_thread_id válidos
# para um determinado CHAT_ID do Telegram
# =============================================================================

# Configurações do Bot (substitua pelos valores reais)
BOT_TOKEN="6891234567:AAFzBqC8D9E0F1G2H3I4J5K6L7M8N9O0P1Q"
CHAT_ID="-1001987654321"

# Configurações de descoberta
MIN_THREAD_ID=1
MAX_THREAD_ID=200
SLEEP_INTERVAL=0.5  # Intervalo entre chamadas da API (em segundos)

# Arrays para armazenar resultados
VALID_THREAD_IDS=()
INVALID_THREAD_IDS=()
ERROR_THREAD_IDS=()

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# =============================================================================
# Funções Auxiliares
# =============================================================================

print_header() {
    echo -e "${CYAN}=================================="
    echo -e "  DESCOBERTA DE TÓPICOS TELEGRAM"
    echo -e "==================================${NC}"
    echo -e "${BLUE}Bot Token:${NC} ${BOT_TOKEN:0:20}..."
    echo -e "${BLUE}Chat ID:${NC} ${CHAT_ID}"
    echo -e "${BLUE}Range de busca:${NC} ${MIN_THREAD_ID} - ${MAX_THREAD_ID}"
    echo -e "${BLUE}Intervalo entre chamadas:${NC} ${SLEEP_INTERVAL}s"
    echo ""
}

print_progress() {
    local current=$1
    local total=$2
    local percent=$((current * 100 / total))
    local progress_bar=""
    local filled=$((percent / 2))
    
    for ((i=0; i<50; i++)); do
        if [ $i -lt $filled ]; then
            progress_bar+="█"
        else
            progress_bar+="░"
        fi
    done
    
    printf "\r${YELLOW}Progresso: [%s] %d%% (%d/%d)${NC}" "$progress_bar" "$percent" "$current" "$total"
}

# =============================================================================
# Função Principal de Descoberta
# =============================================================================

discover_thread_id() {
    local thread_id=$1
    local test_message="🔍 Teste de descoberta - Thread ID: ${thread_id} - $(date '+%H:%M:%S')"
    
    # Monta a URL da API
    local api_url="https://api.telegram.org/bot${BOT_TOKEN}/sendMessage"
    
    # Parâmetros da requisição
    local params="chat_id=${CHAT_ID}&message_thread_id=${thread_id}&text=${test_message}&parse_mode=HTML"
    
    # Faz a requisição
    local response=$(curl -s -X POST "${api_url}" -d "${params}")
    
    # Verifica se a resposta contém "ok":true
    if echo "$response" | grep -q '"ok":true'; then
        VALID_THREAD_IDS+=($thread_id)
        return 0
    else
        # Verifica o tipo de erro
        if echo "$response" | grep -q "message thread not found"; then
            INVALID_THREAD_IDS+=($thread_id)
            return 1
        elif echo "$response" | grep -q "Bad Request"; then
            INVALID_THREAD_IDS+=($thread_id)
            return 1
        else
            ERROR_THREAD_IDS+=($thread_id)
            return 2
        fi
    fi
}

# =============================================================================
# Função de Validação Detalhada
# =============================================================================

validate_discovered_thread() {
    local thread_id=$1
    echo -e "\n${PURPLE}=== Validação Detalhada do Tópico ${thread_id} ===${NC}"
    
    # Teste 1: Mensagem simples
    echo -e "${BLUE}Teste 1: Mensagem simples${NC}"
    local simple_message="✅ Validação - Tópico ${thread_id} confirmado"
    local api_url="https://api.telegram.org/bot${BOT_TOKEN}/sendMessage"
    local params="chat_id=${CHAT_ID}&message_thread_id=${thread_id}&text=${simple_message}"
    
    local response=$(curl -s -X POST "${api_url}" -d "${params}")
    
    if echo "$response" | grep -q '"ok":true'; then
        echo -e "${GREEN}✓ Mensagem simples enviada com sucesso${NC}"
        local message_id=$(echo "$response" | grep -o '"message_id":[0-9]*' | cut -d':' -f2)
        echo -e "${BLUE}  Message ID: ${message_id}${NC}"
    else
        echo -e "${RED}✗ Falha ao enviar mensagem simples${NC}"
        echo -e "${RED}  Resposta: ${response}${NC}"
    fi
    
    sleep $SLEEP_INTERVAL
    
    # Teste 2: Mensagem com formatação HTML
    echo -e "${BLUE}Teste 2: Mensagem com formatação HTML${NC}"
    local html_message="<b>🎯 Tópico ${thread_id}</b>%0A<i>Formatação HTML funcionando</i>%0A<code>Status: Ativo</code>"
    local params_html="chat_id=${CHAT_ID}&message_thread_id=${thread_id}&text=${html_message}&parse_mode=HTML"
    
    local response_html=$(curl -s -X POST "${api_url}" -d "${params_html}")
    
    if echo "$response_html" | grep -q '"ok":true'; then
        echo -e "${GREEN}✓ Mensagem HTML enviada com sucesso${NC}"
    else
        echo -e "${YELLOW}⚠ Falha na formatação HTML (tópico ainda válido)${NC}"
    fi
    
    sleep $SLEEP_INTERVAL
}

# =============================================================================
# Função Principal de Execução
# =============================================================================

main() {
    print_header
    
    echo -e "${YELLOW}Iniciando descoberta de tópicos...${NC}"
    echo ""
    
    local total_range=$((MAX_THREAD_ID - MIN_THREAD_ID + 1))
    local current_count=0
    
    # Loop principal de descoberta
    for thread_id in $(seq $MIN_THREAD_ID $MAX_THREAD_ID); do
        current_count=$((current_count + 1))
        print_progress $current_count $total_range
        
        discover_thread_id $thread_id
        sleep $SLEEP_INTERVAL
    done
    
    echo "" # Nova linha após a barra de progresso
    echo ""
    
    # =============================================================================
    # Relatório de Resultados
    # =============================================================================
    
    echo -e "${CYAN}=================================="
    echo -e "       RELATÓRIO DE DESCOBERTA"
    echo -e "==================================${NC}"
    
    # Tópicos válidos encontrados
    if [ ${#VALID_THREAD_IDS[@]} -gt 0 ]; then
        echo -e "${GREEN}✅ TÓPICOS VÁLIDOS ENCONTRADOS (${#VALID_THREAD_IDS[@]}):${NC}"
        for thread_id in "${VALID_THREAD_IDS[@]}"; do
            echo -e "${GREEN}   → Thread ID: ${thread_id}${NC}"
        done
        echo ""
        
        # Validação detalhada dos tópicos encontrados
        echo -e "${PURPLE}Executando validação detalhada dos tópicos encontrados...${NC}"
        for thread_id in "${VALID_THREAD_IDS[@]}"; do
            validate_discovered_thread $thread_id
            echo ""
        done
    else
        echo -e "${RED}❌ Nenhum tópico válido encontrado no range ${MIN_THREAD_ID}-${MAX_THREAD_ID}${NC}"
        echo ""
    fi
    
    # Estatísticas gerais
    echo -e "${BLUE}📊 ESTATÍSTICAS:${NC}"
    echo -e "${BLUE}   • Total testado: ${total_range}${NC}"
    echo -e "${GREEN}   • Tópicos válidos: ${#VALID_THREAD_IDS[@]}${NC}"
    echo -e "${YELLOW}   • Tópicos inválidos: ${#INVALID_THREAD_IDS[@]}${NC}"
    echo -e "${RED}   • Erros: ${#ERROR_THREAD_IDS[@]}${NC}"
    
    # Recomendações
    echo ""
    echo -e "${CYAN}💡 RECOMENDAÇÕES:${NC}"
    
    if [ ${#VALID_THREAD_IDS[@]} -gt 0 ]; then
        echo -e "${GREEN}   • Use os Thread IDs encontrados em suas integrações${NC}"
        echo -e "${BLUE}   • Exemplo de uso:${NC}"
        echo -e "${BLUE}     curl -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \${NC}"
        echo -e "${BLUE}          -d "chat_id=${CHAT_ID}" \${NC}"
        echo -e "${BLUE}          -d "message_thread_id=${VALID_THREAD_IDS[0]}" \${NC}"
        echo -e "${BLUE}          -d "text=Sua mensagem aqui"${NC}"
    else
        echo -e "${YELLOW}   • Verifique se o CHAT_ID está correto${NC}"
        echo -e "${YELLOW}   • Confirme se o bot tem permissões no grupo/canal${NC}"
        echo -e "${YELLOW}   • Tente expandir o range de busca (MIN_THREAD_ID/MAX_THREAD_ID)${NC}"
        echo -e "${YELLOW}   • Verifique se existem tópicos criados no grupo${NC}"
    fi
    
    echo ""
    echo -e "${CYAN}Script executado com sucesso!${NC}"
}

# =============================================================================
# Verificações Iniciais
# =============================================================================

# Verifica se o curl está disponível
if ! command -v curl &> /dev/null; then
    echo -e "${RED}Erro: curl não está instalado. Instale o curl para continuar.${NC}"
    exit 1
fi

# Verifica se as variáveis obrigatórias estão definidas
if [ -z "$BOT_TOKEN" ] || [ -z "$CHAT_ID" ]; then
    echo -e "${RED}Erro: BOT_TOKEN e CHAT_ID devem estar definidos no script.${NC}"
    exit 1
fi

# Executa o script principal
main
```










## 6. Criando o script "telegra_alert.sh"
Script telegram_alert.sh
```bash
cat telegram_alert.sh
#!/bin/bash
# Telegram Alert Script
# TOPIC_IDs Validados: 2, 4, 6, 76, 78

# ==================== CONFIGURAÇÕES ====================
BOT_TOKEN="6891234567:AAFzBqC8D9E0F1G2H3I4J5K6L7M8N9O0P1Q"
CHAT_ID="-1001987654321"
DEFAULT_THREAD_ID=6
LOG_FILE="/var/log/zabbix/alertscripts/telegram.log"

# ==================== FUNÇÕES ====================

# Função de log
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$1] $2" >> "$LOG_FILE"
}

# Função para validar TOPIC_ID
validate_topic_id() {
    case "$1" in
        2|4|6|76|78) return 0 ;;
        *) return 1 ;;
    esac
}

# Função para obter categoria do tópico
get_topic_category() {
    case "$1" in
        2) echo "Recuperacao-BruteForce" ;;
        4) echo "Recuperacao-IncidentesZabbix" ;;
        6) echo "Recuperacao-BorderClientes" ;;
        76) echo "Operacoes" ;;
        78) echo "Atualizacoes" ;;
        *) echo "Desconhecido" ;;
    esac
}

# Função para escapar MarkdownV2 usando método simples e confiável
escape_markdown_simple() {
    local text="$1"
    
    if [[ -z "$text" ]]; then
        echo ""
        return
    fi
    
    # Método ultra-simples: substituir apenas os caracteres mais problemáticos
    # Usar tr para substituições básicas
    text=$(echo "$text" | tr '*' '✱')  # Substitui * por ✱
    text=$(echo "$text" | tr '_' '‗')  # Substitui _ por ‗
    text=$(echo "$text" | tr '`' '‛')  # Substitui ` por ‛
    
    echo "$text"
}

# Função para enviar mensagem
send_message() {
    local chat_id="$1"
    local text="$2"
    local thread_id="$3"
    local use_markdown="$4"
    
    local payload
    
    # Construir payload
    if [[ "$use_markdown" == "true" ]]; then
        payload=$(jq -n \
            --arg chat_id "$chat_id" \
            --arg text "$text" \
            --arg parse_mode "MarkdownV2" \
            --argjson message_thread_id "$thread_id" \
            '{chat_id:$chat_id,text:$text,parse_mode:$parse_mode,message_thread_id:$message_thread_id}')
        log "INFO" "Tentando envio com MarkdownV2"
    else
        payload=$(jq -n \
            --arg chat_id "$chat_id" \
            --arg text "$text" \
            --argjson message_thread_id "$thread_id" \
            '{chat_id:$chat_id,text:$text,message_thread_id:$message_thread_id}')
        log "INFO" "Tentando envio com texto simples"
    fi
    
    # Enviar mensagem
    local response=$(curl -sS \
        --max-time 30 \
        -X POST "https://api.telegram.org/bot${BOT_TOKEN}/sendMessage" \
        -H "Content-Type: application/json" \
        -d "$payload" \
        -w "\nHTTP_STATUS:%{http_code}" 2>&1)
    
    # Processar resposta
    if echo "$response" | grep -q "HTTP_STATUS:"; then
        local http_code=$(echo "$response" | grep "HTTP_STATUS:" | cut -d':' -f2)
        local response_body=$(echo "$response" | sed '/HTTP_STATUS:/d')
        
        if [[ "$http_code" -eq 200 ]]; then
            if echo "$response_body" | jq -e '.ok == true' > /dev/null 2>&1; then
                local message_id=$(echo "$response_body" | jq -r '.result.message_id // "N/A"')
                log "SUCCESS" "Mensagem enviada com sucesso! Message ID: $message_id"
                return 0
            fi
        fi
        
        # Log do erro
        local error_desc=$(echo "$response_body" | jq -r '.description // "Erro desconhecido"')
        log "ERROR" "Falha no envio HTTP $http_code: $error_desc"
        return 1
    else
        log "ERROR" "Resposta malformada do cURL"
        return 1
    fi
}

# ==================== INÍCIO DO SCRIPT ====================

log "INFO" "=== Iniciando Telegram Alert Script v$SCRIPT_VERSION ==="

# Validação de parâmetros
if [[ $# -lt 2 ]]; then
    log "ERROR" "Parametros insuficientes. Uso: $0 "SUBJECT" "MESSAGE""
    exit 1
fi

SUBJECT="$1"
MESSAGE="$2"

log "INFO" "Subject recebido: ${SUBJECT:0:80}..."
log "INFO" "Message recebido: ${MESSAGE:0:80}..."

# Extração do TOPIC_ID
if [[ "$SUBJECT" =~ \[TOPIC_ID:([0-9]+)\] ]]; then
    THREAD_ID="${BASH_REMATCH[1]}"
    CLEAN_SUBJECT="${SUBJECT#*] }"
    
    if validate_topic_id "$THREAD_ID"; then
        log "INFO" "TOPIC_ID valido: $THREAD_ID ($(get_topic_category "$THREAD_ID"))"
    else
        log "WARN" "TOPIC_ID $THREAD_ID invalido, usando padrao: $DEFAULT_THREAD_ID"
        THREAD_ID="$DEFAULT_THREAD_ID"
        CLEAN_SUBJECT="$SUBJECT"
    fi
else
    THREAD_ID="$DEFAULT_THREAD_ID"
    CLEAN_SUBJECT="$SUBJECT"
    log "INFO" "TOPIC_ID nao encontrado, usando padrao: $THREAD_ID"
fi

# ==================== TENTATIVA 1: COM FORMATAÇÃO BÁSICA ====================

log "INFO" "Tentativa 1: Formatacao basica..."

# Escapar caracteres problemáticos
ESCAPED_SUBJECT=$(escape_markdown_simple "$CLEAN_SUBJECT")
ESCAPED_MESSAGE=$(escape_markdown_simple "$MESSAGE")

# Construir mensagem com formatação básica (usando ✱ em vez de *)
FORMATTED_TEXT="✱${ESCAPED_SUBJECT}✱"$'\n\n'"${ESCAPED_MESSAGE}"

# Validar se não está vazio
if [[ -n "$FORMATTED_TEXT" ]] && [[ ${#FORMATTED_TEXT} -gt 10 ]]; then
    log "INFO" "Texto formatado construido (${#FORMATTED_TEXT} chars)"
    
    # Tentar enviar com MarkdownV2
    if send_message "$CHAT_ID" "$FORMATTED_TEXT" "$THREAD_ID" "false"; then
        log "SUCCESS" "=== Script finalizado com sucesso (formatacao basica) ==="
        exit 0
    else
        log "WARN" "Falha com formatacao basica, tentando texto simples..."
    fi
else
    log "WARN" "Texto formatado vazio ou muito pequeno, usando fallback..."
fi

# ==================== TENTATIVA 2: TEXTO SIMPLES ====================

log "INFO" "Tentativa 2: Texto simples..."

# Construir mensagem simples
SIMPLE_TEXT="$CLEAN_SUBJECT"$'\n\n'"$MESSAGE"

# Validar se não está vazio
if [[ -n "$SIMPLE_TEXT" ]] && [[ ${#SIMPLE_TEXT} -gt 5 ]]; then
    log "INFO" "Texto simples construido (${#SIMPLE_TEXT} chars)"
    
    # Tentar enviar sem formatação
    if send_message "$CHAT_ID" "$SIMPLE_TEXT" "$THREAD_ID" "false"; then
        log "SUCCESS" "=== Script finalizado com sucesso (texto simples) ==="
        exit 0
    else
        log "ERROR" "Falha tambem com texto simples"
    fi
else
    log "ERROR" "Texto simples tambem esta vazio"
fi

# ==================== TENTATIVA 3: MENSAGEM DE EMERGÊNCIA ====================

log "INFO" "Tentativa 3: Mensagem de emergencia..."

EMERGENCY_TEXT="ALERTA ZABBIX: $CLEAN_SUBJECT"

if send_message "$CHAT_ID" "$EMERGENCY_TEXT" "$THREAD_ID" "false"; then
    log "SUCCESS" "=== Script finalizado com mensagem de emergencia ==="
    exit 0
fi

# ==================== FALHA TOTAL ====================

log "ERROR" "=== Todas as tentativas falharam ==="
exit 1
```




