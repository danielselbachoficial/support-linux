# Solucionando Problema de Alteração de Porta SSH em Sistemas com Systemd

Este documento descreve a solução para um problema comum em distribuições Linux recentes que utilizam `systemd`, onde a alteração da porta no arquivo de configuração do SSH (`/etc/ssh/sshd_config`) não surte efeito após reiniciar o serviço.

## Problema

Ao alterar a diretiva `Port` no arquivo `/etc/ssh/sshd_config` para uma nova porta (por exemplo, `Port 25000`) e reiniciar o serviço SSH com `sudo systemctl restart ssh`, a nova porta não é utilizada. Ao verificar as portas em escuta com comandos como `netstat -putanl` ou `ss -tuln`, o sistema continua escutando apenas na porta padrão 22, impedindo o acesso remoto através da nova porta configurada.

## Causa Raiz: Reinicialização do Systemd Socket

Em muitas distribuições Linux modernas, o `systemd` gerencia os serviços de forma mais complexa. Em vez de o serviço `sshd` abrir a porta diretamente, o `systemd` pode estar escutando na porta 22 por meio de uma unidade de socket (`ssh.socket`). Quando uma conexão chega a essa porta, o `systemd` ativa o serviço principal (`ssh.service`), que herda o socket já aberto. Nesse cenário, a configuração de porta no `/etc/ssh/sshd_config` é completamente ignorada.

## Solução Passo a Passo

Para resolver isso, você precisa desabilitar o socket do `systemd` e garantir que o serviço SSH (`sshd`) seja iniciado de forma independente, forçando-o a ler seu próprio arquivo de configuração.

### Passo 1: Desabilitar o Socket
Desabilite e pare imediatamente a unidade de socket que está escutando na porta 22. Isso impede que o `systemd` continue a gerenciar a porta para o SSH.
```bash
sudo systemctl disable --now ssh.socket
```

### Passo 2: Reiniciar o Serviço SSH
Agora, reinicie o serviço ssh. Sem o ssh.socket para interferir, ele será forçado a ler o arquivo /etc/ssh/sshd_config para determinar em qual porta deve operar.
```bash
sudo systemctl restart ssh
```

### Passo 3: Verificar a Nova Porta
Verifique se o serviço agora está escutando na nova porta que você configurou (ex: 25000). Utilize o comando ss para confirmar.
```bash
sudo ss -tuln | grep <Porta nova>
```
A saída deste comando deve agora mostrar o processo sshd escutando na porta <Porta nova> (ex: 25000)

Passo Adicional (Se o problema persistir)
Se, por algum motivo improvável, a porta correta ainda não aparecer, você pode forçar o systemd a reler todas as suas configurações de unidade antes de reiniciar o serviço SSH novamente.
```bash
sudo systemctl daemon-reload
sudo systemctl restart ssh
```
Seguindo estes passos, o conflito com o ssh.socket do systemd é eliminado e o serviço SSH passará a respeitar a configuração de porta definida no arquivo sshd_config.
