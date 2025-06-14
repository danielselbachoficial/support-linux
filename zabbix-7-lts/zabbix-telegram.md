


Script telegram_alert.sh
```bash
cat telegram_alert_final_working.sh
#!/bin/bash
# Telegram Alert Script - Final Working Version
# TOPIC_IDs Validados: 2, 4, 6, 76, 78

# ==================== CONFIGURAÇÕES ====================
BOT_TOKEN="7979503305:AAH4QgiRF8ijtEYZS4KYAMgrHib9Syd09u0"
CHAT_ID="-1002708657522"
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
