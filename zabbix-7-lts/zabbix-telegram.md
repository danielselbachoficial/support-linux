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
1.  Acesse o menu: Administration → Media types
2.  Clique em: Create media type
3.  Preencha os campos conforme a tabela abaixo
4.  Adicione os parâmetros:
    *   Clique em Add na seção \"Script parameters\"
    *   Parâmetro 1: Digite `{ALERT.SUBJECT}`
    *   Clique em Add novamente
    *   Parâmetro 2: Digite `{ALERT.MESSAGE}`
5.  Marque: Enabled
6.  Clique em: Add para salvar

#### ⚙️ Configurações Detalhadas
| Campo             | Valor                |
| :---------------- | :------------------- |
| Nome              | Telegram Alert System |
| Tipo              | Script               |
| Nome do script    | `telegram_alert.sh`  |
| Timeout do script | 60s                  |
| Processamento simultâneo | 1                    |
| Status            | Habilitado ✅         |

#### 📝 Parâmetros do Script
Adicione exatamente 2 parâmetros na seguinte ordem:

*   Parâmetro 1: `{ALERT.SUBJECT}`
*   Parâmetro 2: `{ALERT.MESSAGE}`

### 4.2. Configuração do User Media

#### 🖼️ Configuração Passo a Passo
1.  Acesse: Administration → Users
2.  Clique no seu usuário
3.  Vá para a aba: Media
4.  Clique em: Add
5.  Selecione o tipo: Telegram Alert System
6.  Preencha \"Send to\": `telegram`
7.  Configure período: `1-7,00:00-24:00` (24/7)
8.  Marque todas as severidades
9.  Marque: Enabled
10. Clique em: Add
11. Salve o usuário: Update

#### ⚙️ Configurações Detalhadas
| Campo         | Valor                  |
| :------------ | :--------------------- |
| Tipo          | Telegram Alert System |
| Enviar para   | telegram               |
| Período ativo | `1-7,00:00-24:00`      |
| Status        | Habilitado ✅           |

#### 🎚️ Usar se gravidade
Marque todas as opções para monitoramento 24/7 completo:

*   ☑️ Não classificado
*   ☑️ Informação
*   ☑️ Aviso
*   ☑️ Média
*   ☑️ Alta
*   ☑️ Desastre

### 4.3. Criação das Actions (Ações)

#### 🖼️ Configuração Passo a Passo para Actions
1.  Acesse: Configuration → Actions → Trigger actions
2.  Clique em: Create action
3.  Aba Action:
    *   Nome: Conforme especificado
    *   Condições: Adicione as condições necessárias
4.  Aba Operations:
    *   Clique em Add em \"Operations\"
    *   Operation type: Send message
    *   Send to users: Selecione seu usuário
    *   Send only to: Telegram Alert System
    *   Subject: Cole o assunto personalizado
    *   Message: Cole a mensagem personalizada
5.  Salve: Clique em Add

#### A. Ação para Problemas Gerais
##### 🧭 Navegação
`Configuration` → `Actions` → `Trigger actions` → `Create action`
##### ⚙️ Configurações Básicas
Nome: `Telegram - Problemas Gerais`
Tipo de evento: `Problema`
Status: `Habilitado`
##### 🎯 Condições
Condição A: Gravidade `>=` Aviso
##### 📤 Operações
Operação: `Enviar mensagem`
Enviar para usuários: `[Seu usuário]`
Enviar apenas para: `Telegram Alert System`
##### 📧 Assunto Personalizado
`[TOPIC_ID:6] 🚨 PROBLEMA: {TRIGGER.NAME} em {HOST.NAME}`
##### 💬 Mensagem Personalizada
```
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
```

#### B. Ação para Recuperações
##### ⚙️ Configurações Básicas
Nome: `Telegram - Recuperações`
Tipo de evento: `Recuperação de problema`
Status: `Habilitado`
##### 🎯 Condições
Condição A: Gravidade `>=` Aviso
##### 📤 Operações
Operação: `Enviar mensagem`
Enviar para usuários: `[Seu usuário]`
Enviar apenas para: `Telegram Alert System`
##### 📧 Assunto Personalizado
`[TOPIC_ID:6] ✅ RECUPERADO: {TRIGGER.NAME} em {HOST.NAME}`
##### 💬 Mensagem Personalizada
```
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
```

#### C. Ação Especializada - Brute Force
##### ⚙️ Configurações Básicas
Nome: `Telegram - Recuperação Brute Force`
Tipo de evento: `Recuperação de problema`
Status: `Habilitado`
##### 🎯 Condições
Condição A: Nome do trigger contém \"brute force\"
Condição B: OU Nome do trigger contém \"login\"
Condição C: OU Nome do trigger contém \"ssh\"
Condição D: OU Nome do trigger contém \"attack\"
##### 📧 Assunto Personalizado
`[TOPIC_ID:2] 🛡️ Brute Force Controlado: {TRIGGER.NAME} em {HOST.NAME}`
##### 💬 Mensagem Personalizada
```
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
```
