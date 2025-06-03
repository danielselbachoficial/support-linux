# Correção do vmnet0 no VMware Workstation Pro em Linux

Este repositório contém um guia técnico detalhado para solucionar o problema de ausência do adaptador `vmnet0` (modo Bridge) no VMware Workstation Pro em distribuições Linux.

## Compatibilidade

Aplicável a distribuições baseadas em:

* Ubuntu/Debian
* Fedora/RHEL/CentOS
* Arch/Manjaro

Pode requerer ajustes conforme a distribuição ou versão do kernel.

## Conteúdo

* Diagnóstico do problema
* Verificação e recompilação dos módulos `vmmon` e `vmnet`
* Instalação de dependências específicas por distribuição
* Reinício seguro dos serviços do VMware
* Configuração do modo bridge com `vmware-netcfg`
* Verificação do dispositivo `/dev/vmnet0`
* Testes de conectividade com `ip link`

## Objetivo

Este manual serve como referência rápida e abrangente para profissionais que utilizam o VMware Workstation em ambientes Linux e precisam garantir a funcionalidade de redes em modo bridge para laboratórios como PNETLab, GNS3 e outras soluções de virtualização.

## Licença

Distribuído livremente para fins educacionais e técnicos.
