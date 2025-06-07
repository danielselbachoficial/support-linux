# Solução para Erro "E: Unable to locate package zabbix-agent2" no Ubuntu 24.04 LTS

Este guia detalhado aborda o erro comum `E: Unable to locate package zabbix-agent2` ao tentar instalar o Zabbix Agent 2 em sistemas Ubuntu 24.04 LTS (Noble Numbat) usando o `apt`. O problema geralmente ocorre porque o sistema não consegue encontrar o pacote, indicando que o repositório oficial do Zabbix não está adicionado ou configurado corretamente.

## 📄 Descrição do Problema

Ao tentar instalar o Zabbix Agent 2 com o comando:
```bash
sudo apt install --install-recommends zabbix-agent2 zabbix-agent2-plugin-*
```

O sistema retorna o seguinte erro:

Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
E: Unable to locate package zabbix-agent2
E: Unable to locate package zabbix-agent2-plugin-*
E: Couldn't find any package by glob 'zabbix-agent2-plugin-*'
Este erro significa que o apt não sabe onde encontrar os pacotes zabbix-agent2 e seus plugins.
