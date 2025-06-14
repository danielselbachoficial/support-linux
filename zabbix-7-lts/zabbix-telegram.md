


Script telegram_alert.sh
```bash
cat telegram_alert_final_working.sh
#!/bin/bash
# Telegram Alert Script - Final Working Version
# TOPIC_IDs Validados: 2, 4, 6, 76, 78

# ==================== CONFIGURAÇÕES ====================
BOT_TOKEN="fwfwefewf"
CHAT_ID="wfewfwe"
DEFAULT_THREAD_ID=6
LOG_FILE="/var/log/zabbix/alertscripts/telegram.log"
SCRIPT_VERSION="FinalWorking-v1.0"

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






#!/bin/bash

# =============================================================================
# Script de Descoberta e Validação de Tópicos do Telegram
# =============================================================================
# Este script descobre automaticamente todos os message_thread_id válidos
# para um determinado CHAT_ID do Telegram
# =============================================================================

# Configurações do Bot (substitua pelos valores reais)
BOT_TOKEN="wfewfewf"
CHAT_ID="wfwefwef"

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
