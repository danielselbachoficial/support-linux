## Como Resetar a Senha de uma VM Linux no Proxmox (Via GRUB)

**Problema:** Perdeu a senha `root` de uma Máquina Virtual (VM) Linux rodando no Proxmox? `pct enter` não funciona para VMs, e você precisa de acesso.

**Solução:** Manipular o boot da VM via GRUB. É um processo direto, sem firulas.

---

### Passo a Passo:

1.  **Acesse o Console da VM no Proxmox.**
    *   No painel do Proxmox, selecione a VM em questão e abra a aba \"Console\". Você precisa ver a inicialização da VM.

2.  **Reinicie a VM.**
    *   Clique em \"Stop\" e depois \"Start\", ou \"Reboot\" no console, e prepare-se para agir rápido.

3.  **Edite a Entrada do GRUB.**
    *   Assim que o menu do GRUB (o carregador de boot) aparecer na tela, **aperte a tecla `e`** (de \"edit\") para editar a entrada de boot selecionada. Você tem poucos segundos para isso.

4.  **Adicione o Parâmetro de Boot.**
    *   Procure a linha que começa com `linux` ou `linux16`. Use as setas do teclado para navegar até o **final desta linha**.
    *   Adicione o seguinte parâmetro (com um espaço antes):
        ```
        init=/bin/bash
        ```
    *   *(Para algumas distros mais antigas, `single` pode funcionar, mas `init=/bin/bash` é mais confiável e te dá um shell completo.)*

5.  **Boot com a Alteração.**
    *   Pressione **`F10`** ou **`Ctrl+X`** para iniciar a VM com a configuração modificada.

6.  **Acesse o Shell de Root.**
    *   A VM vai bootar e você cairá diretamente em um shell de root (`#`).

7.  **Remonte o Sistema de Arquivos (Se Necessário).**
    *   O sistema de arquivos pode estar montado como somente leitura. Para permitir escrita, execute:
        ```bash
        mount -o remount,rw /
        ```

8.  **Altere a Senha do Root.**
    *   Agora, use o comando `passwd` para definir uma nova senha para o usuário `root`:
        ```bash
        passwd root
        ```
    *   Digite a nova senha, confirme-a e preste atenção para não errar.

9.  **Reinicie a VM.**
    *   Após a senha ser alterada, reinicie a VM para que as mudanças persistam e o sistema volte ao normal.
        ```bash
        exec /sbin/init
        ```
    *   *(Se o comando acima falhar, tente uma reinicialização forçada)*:
        ```bash
        reboot -f
        ```

---

**Conclusão:** A senha foi resetada. Se isso não resolver, o problema não era a senha. Agora, use o que aprendeu.
