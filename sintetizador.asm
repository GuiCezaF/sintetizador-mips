# Maquina de Musica - Sintetizador MIDI (MIPS / MARS 4.5)

.data
.align 2
instrumento_override:   .word -1        # -1 = timbre da partitura; 0..127 = override global
log_detalhado:          .word 0         # 0 = OFF (Zero-Latency Audio); 1 = ON (Debug console)

.align 2
tabela_presets_inst:    .word 0, 11, 19, 21, 24, 40, 73, 80

str_banner:
    .asciiz "\n============================================================\n  MAQUINA DE MUSICA - SINTETIZADOR MIDI (MIPS / MARS 4.5)\n============================================================\n"
str_status_auto:
    .asciiz "Timbre Ativo: [Automatico da Partitura]"
str_status_override:
    .asciiz "Timbre Ativo: [Override Global -> MIDI ID "
str_fecha_colchete:
    .asciiz "]"
str_log_status_off:
    .asciiz " | Log: [OFF - Alta Qualidade]\n"
str_log_status_on:
    .asciiz " | Log: [ON - Debug Console]\n"
str_menu:
    .asciiz "------------------------------------------------------------\n  [1]  Tocar: Ode to Joy - Beethoven (ode_to_joy.txt)\n  [2]  Tocar: Chiptune 8-Bit - Arcade (chiptune.txt)\n  [3]  Tocar: Asa Branca - Luiz Gonzaga (asa_branca.txt)\n  [4]  Tocar: DOOM (E1M1) - At Doom's Gate (doom.txt)\n  [5]  Tocar: Minecraft - C418 (minecraft.txt)\n  [6]  Tocar: JoJo - Il Vento D'oro 3:46-4:00 (jojo.txt)\n  [7]  Modo Jukebox (Tocar todas as 6 faixas dos arquivos .txt)\n  [8]  Carregar e Tocar Arquivo .txt Customizado\n  [9]  Sintetizador: Escolher Timbre / Instrumento Global\n  [10] Alternar Log Detalhado de Notas (OFF/ON)\n  [11] Demonstracao de Polifonia (Syscall 31 + Syscall 32)\n  [0]  Sair\n------------------------------------------------------------\nEscolha uma opcao: "

str_op_invalida:
    .asciiz "\n[ERRO] Opcao invalida! Digite um numero entre 0 e 11.\n"
str_saindo:
    .asciiz "\nEncerrando a Maquina de Musica. Ate logo!\n"

str_play_hdr1:  .asciiz "\n>>> Reproduzindo: "
str_play_hdr2:  .asciiz "\n    Instrumento Inicial: "
str_play_hdr3:  .asciiz " | Volume Inicial: "
str_play_hdr4:  .asciiz "\n------------------------------------------------------------\n"
str_play_fim:   .asciiz "--- Fim da reproducao ---\n"

str_log_sync:   .asciiz "[NOTA/SYNC]    "
str_log_async:  .asciiz "[ACORDE/ASYNC] "
str_log_pitch:  .asciiz "Pitch="
str_log_dur:    .asciiz " | Dur="
str_log_ms:     .asciiz "ms"
str_log_inst:   .asciiz " | Inst="
str_log_vol:    .asciiz " | Vol="
str_log_pausa:  .asciiz "[PAUSA]        "
str_log_timbre: .asciiz "[TIMBRE]       Instrumento -> "
str_log_timb_ig:.asciiz "[TIMBRE]       Mudanca ignorada (Override Global ativo)\n"
str_log_volume: .asciiz "[VOLUME]       Volume -> "
str_nl:         .asciiz "\n"

str_arq_err1:   .asciiz "\n[ERRO] Nao foi possivel abrir o arquivo: "
str_arq_err2:   .asciiz "\n       Verifique se o MARS foi iniciado na pasta do projeto.\n"
str_arq_vazio:  .asciiz "\n[ERRO] Arquivo vazio ou sem eventos validos.\n"
str_arq_ok1:    .asciiz "\n[ARQUIVO] Carregado: "
str_arq_ok2:    .asciiz " ("
str_arq_ok3:    .asciiz " eventos convertidos)\n"
str_arq_prompt: .asciiz "\nDigite o nome do arquivo .txt (ex: musicas/jojo.txt): "

str_toggle_off: .asciiz "\n[LOG] Modo Zero-Latency Audio ATIVADO (Log de notas: OFF).\n"
str_toggle_on:  .asciiz "\n[LOG] Log detalhado de notas ATIVADO (Debug Console: ON).\n"

str_jukebox_ini: .asciiz "\n=== INICIANDO MODO JUKEBOX (6 FAIXAS) ===\n"
str_jukebox_sep: .asciiz "\n... Preparando proxima faixa (1000ms) ...\n"
str_jukebox_fim: .asciiz "\n=== JUKEBOX CONCLUIDO ===\n"

str_inst_menu:
    .asciiz "\n--- Seletor de Timbre General MIDI ---\n  [1]   0 - Acoustic Grand Piano\n  [2]  11 - Vibraphone\n  [3]  19 - Church Organ\n  [4]  21 - Accordion (Sanfona)\n  [5]  24 - Acoustic Guitar (Nylon)\n  [6]  40 - Violin\n  [7]  73 - Flute\n  [8]  80 - Lead 1 (Square / 8-Bit)\n  [9]  Digitar ID MIDI customizado (0..127)\n  [-1] Restaurar modo automatico (timbre da partitura)\nEscolha: "
str_inst_custom:    .asciiz "Digite o ID do instrumento MIDI (0 a 127): "
str_inst_invalido:  .asciiz "[ERRO] Instrumento fora da faixa valida (0..127).\n"
str_inst_restaurado:.asciiz "[OK] Modo automatico restaurado.\n"
str_inst_definido:  .asciiz "[OK] Override global definido para Instrumento "
str_inst_preview:   .asciiz " (tocando acorde de preview...)\n"

str_demo_ini:
    .asciiz "\n=== DEMO DE POLIFONIA (SYSCALL 31 ASYNC + SYSCALL 32 SLEEP) ===\nDisparando acordes de 4 vozes simultaneas com instrumento "
str_demo_c:     .asciiz "\n  -> Acorde Do Maior (C3 + C4 + E4 + G4) - 900ms"
str_demo_f:     .asciiz "\n  -> Acorde Fa Maior (F3 + C4 + F4 + A4) - 900ms"
str_demo_g7:    .asciiz "\n  -> Acorde Sol com Setima (G3 + B3 + D4 + F4) - 900ms"
str_demo_c_end: .asciiz "\n  -> Resolucao Do Maior (C3 + E4 + G4 + C5) - 1300ms\n"
str_demo_fim:   .asciiz "=== FIM DA DEMO DE POLIFONIA ===\n"

titulo_ode:       .asciiz "Ode to Joy - Beethoven (Sinfonia No. 9)"
titulo_chiptune:  .asciiz "Chiptune 8-Bit - Tema Classico Arcade"
titulo_asa:       .asciiz "Asa Branca - Luiz Gonzaga"
titulo_doom:      .asciiz "DOOM (E1M1) - At Doom's Gate"
titulo_minecraft: .asciiz "Minecraft - C418 (Sweden / Calm)"
titulo_jojo:      .asciiz "JoJo Parte 5 - Il Vento D'oro (3:46 - 4:00 Piano)"

arq_ode:          .asciiz "musicas/ode_to_joy.txt"
arq_chiptune:     .asciiz "musicas/chiptune.txt"
arq_asa:          .asciiz "musicas/asa_branca.txt"
arq_doom:         .asciiz "musicas/doom.txt"
arq_minecraft:    .asciiz "musicas/minecraft.txt"
arq_jojo:         .asciiz "musicas/jojo.txt"

# Catalogo (16 bytes/entrada): titulo_ptr, inst_padrao, vol_padrao, arquivo_ptr
.align 2
catalogo_musicas:
    .word titulo_ode,       0,  105, arq_ode
    .word titulo_chiptune,  80, 110, arq_chiptune
    .word titulo_asa,       21, 100, arq_asa
    .word titulo_doom,      29, 122, arq_doom
    .word titulo_minecraft, 0,  100, arq_minecraft
    .word titulo_jojo,      0,  120, arq_jojo

# Buffers dinamicos para leitura e compilacao de partituras (.word CODIGO, VALOR)
.align 2
buffer_partitura:       .space 4096
buffer_arquivo:         .space 16384
buffer_nome_arq:        .space 128


.text
.globl main

# Loop principal do menu interativo
main:
main_loop:
    jal  exibir_menu

    li   $v0, 5
    syscall

    beq  $v0, $zero, main_sair

    li   $t0, 1
    beq  $v0, $t0, main_op1
    li   $t0, 2
    beq  $v0, $t0, main_op2
    li   $t0, 3
    beq  $v0, $t0, main_op3
    li   $t0, 4
    beq  $v0, $t0, main_op4
    li   $t0, 5
    beq  $v0, $t0, main_op5
    li   $t0, 6
    beq  $v0, $t0, main_op6
    li   $t0, 7
    beq  $v0, $t0, main_op7
    li   $t0, 8
    beq  $v0, $t0, main_op8
    li   $t0, 9
    beq  $v0, $t0, main_op9
    li   $t0, 10
    beq  $v0, $t0, main_op10
    li   $t0, 11
    beq  $v0, $t0, main_op11

    li   $v0, 4
    la   $a0, str_op_invalida
    syscall
    j    main_loop

main_op1:
    li   $a0, 0
    jal  tocar_musica_catalogo
    j    main_loop

main_op2:
    li   $a0, 1
    jal  tocar_musica_catalogo
    j    main_loop

main_op3:
    li   $a0, 2
    jal  tocar_musica_catalogo
    j    main_loop

main_op4:
    li   $a0, 3
    jal  tocar_musica_catalogo
    j    main_loop

main_op5:
    li   $a0, 4
    jal  tocar_musica_catalogo
    j    main_loop

main_op6:
    li   $a0, 5
    jal  tocar_musica_catalogo
    j    main_loop

main_op7:
    jal  modo_jukebox
    j    main_loop

main_op8:
    jal  tocar_arquivo_customizado
    j    main_loop

main_op9:
    jal  selecionar_instrumento
    j    main_loop

main_op10:
    jal  alternar_log_detalhado
    j    main_loop

main_op11:
    jal  demo_polifonia
    j    main_loop

main_sair:
    li   $v0, 4
    la   $a0, str_saindo
    syscall
    li   $v0, 10
    syscall

# Exibe cabecalho, status de timbre/log e opcoes do menu
exibir_menu:
    li   $v0, 4
    la   $a0, str_banner
    syscall

    la   $t0, instrumento_override
    lw   $t0, 0($t0)
    bltz $t0, menu_status_auto

    li   $v0, 4
    la   $a0, str_status_override
    syscall
    li   $v0, 1
    move $a0, $t0
    syscall
    li   $v0, 4
    la   $a0, str_fecha_colchete
    syscall
    j    menu_status_log

menu_status_auto:
    li   $v0, 4
    la   $a0, str_status_auto
    syscall

menu_status_log:
    la   $t0, log_detalhado
    lw   $t0, 0($t0)
    bnez $t0, menu_log_on
    li   $v0, 4
    la   $a0, str_log_status_off
    syscall
    j    menu_imprime_opcoes

menu_log_on:
    li   $v0, 4
    la   $a0, str_log_status_on
    syscall

menu_imprime_opcoes:
    li   $v0, 4
    la   $a0, str_menu
    syscall
    jr   $ra

# Carrega entrada do catalogo ($a0 = indice 0..5), le arquivo e reproduz
tocar_musica_catalogo:
    addiu $sp, $sp, -20
    sw   $ra, 16($sp)
    sw   $s0, 12($sp)
    sw   $s1, 8($sp)
    sw   $s2, 4($sp)
    sw   $s3, 0($sp)

    bltz $a0, cat_ret
    li   $t0, 6
    bge  $a0, $t0, cat_ret

    sll  $t0, $a0, 4        # indice * 16 bytes por entrada
    la   $t1, catalogo_musicas
    addu $t0, $t1, $t0

    lw   $s0, 0($t0)        # titulo
    lw   $s1, 4($t0)        # instrumento padrao
    lw   $s2, 8($t0)        # volume padrao
    lw   $s3, 12($t0)       # ponteiro nome do arquivo

    la   $t2, instrumento_override
    lw   $t3, 0($t2)
    bltz $t3, cat_carregar
    move $s1, $t3

cat_carregar:
    move $a0, $s3
    jal  carregar_partitura_arquivo
    blez $v0, cat_ret

    li   $v0, 4
    la   $a0, str_play_hdr1
    syscall
    li   $v0, 4
    move $a0, $s0
    syscall
    li   $v0, 4
    la   $a0, str_play_hdr2
    syscall
    li   $v0, 1
    move $a0, $s1
    syscall
    li   $v0, 4
    la   $a0, str_play_hdr3
    syscall
    li   $v0, 1
    move $a0, $s2
    syscall
    li   $v0, 4
    la   $a0, str_play_hdr4
    syscall

    la   $a0, buffer_partitura
    move $a1, $s1
    move $a2, $s2
    jal  interpretar_partitura

cat_ret:
    lw   $s3, 0($sp)
    lw   $s2, 4($sp)
    lw   $s1, 8($sp)
    lw   $s0, 12($sp)
    lw   $ra, 16($sp)
    addiu $sp, $sp, 20
    jr   $ra

# Solicita nome de arquivo .txt via console, carrega e reproduz
tocar_arquivo_customizado:
    addiu $sp, $sp, -8
    sw   $ra, 4($sp)
    sw   $s0, 0($sp)

    li   $v0, 4
    la   $a0, str_arq_prompt
    syscall

    li   $v0, 8
    la   $a0, buffer_nome_arq
    li   $a1, 128
    syscall

    # Remove '\n' ou '\r' do final da string lida
    la   $t0, buffer_nome_arq
custom_trim:
    lbu  $t1, 0($t0)
    beqz $t1, custom_trim_fim
    li   $t2, 10
    beq  $t1, $t2, custom_zera
    li   $t2, 13
    beq  $t1, $t2, custom_zera
    addiu $t0, $t0, 1
    j    custom_trim

custom_zera:
    sb   $zero, 0($t0)

custom_trim_fim:
    la   $a0, buffer_nome_arq
    lbu  $t1, 0($a0)
    beqz $t1, custom_ret

    jal  carregar_partitura_arquivo
    blez $v0, custom_ret

    la   $t0, instrumento_override
    lw   $s0, 0($t0)
    bgez $s0, custom_inst_ok
    li   $s0, 0

custom_inst_ok:
    li   $v0, 4
    la   $a0, str_play_hdr1
    syscall
    li   $v0, 4
    la   $a0, buffer_nome_arq
    syscall
    li   $v0, 4
    la   $a0, str_play_hdr2
    syscall
    li   $v0, 1
    move $a0, $s0
    syscall
    li   $v0, 4
    la   $a0, str_play_hdr3
    syscall
    li   $v0, 1
    li   $a0, 105
    syscall
    li   $v0, 4
    la   $a0, str_play_hdr4
    syscall

    la   $a0, buffer_partitura
    move $a1, $s0
    li   $a2, 105
    jal  interpretar_partitura

custom_ret:
    lw   $s0, 0($sp)
    lw   $ra, 4($sp)
    addiu $sp, $sp, 8
    jr   $ra

# Abre, le (Syscalls 13, 14, 16) e converte arquivo ($a0 = nome) para buffer_partitura; retorna $v0 = eventos ou -1
carregar_partitura_arquivo:
    addiu $sp, $sp, -12
    sw   $ra, 8($sp)
    sw   $s0, 4($sp)
    sw   $s1, 0($sp)

    move $s0, $a0

    li   $v0, 13            # open file
    move $a0, $s0
    li   $a1, 0
    li   $a2, 0
    syscall
    bltz $v0, arq_erro_abrir

    move $t0, $v0           # descritor do arquivo
    li   $v0, 14            # read file
    move $a0, $t0
    la   $a1, buffer_arquivo
    li   $a2, 16383
    syscall
    move $s1, $v0

    li   $v0, 16            # close file
    move $a0, $t0
    syscall

    blez $s1, arq_erro_vazio

    la   $t1, buffer_arquivo
    addu $t1, $t1, $s1
    sb   $zero, 0($t1)

    la   $a0, buffer_arquivo
    la   $a1, buffer_partitura
    jal  converter_texto_para_partitura
    move $s1, $v0
    blez $s1, arq_erro_vazio

    li   $v0, 4
    la   $a0, str_arq_ok1
    syscall
    li   $v0, 4
    move $a0, $s0
    syscall
    li   $v0, 4
    la   $a0, str_arq_ok2
    syscall
    li   $v0, 1
    move $a0, $s1
    syscall
    li   $v0, 4
    la   $a0, str_arq_ok3
    syscall

    move $v0, $s1
    j    arq_ret

arq_erro_abrir:
    li   $v0, 4
    la   $a0, str_arq_err1
    syscall
    li   $v0, 4
    move $a0, $s0
    syscall
    li   $v0, 4
    la   $a0, str_arq_err2
    syscall
    li   $v0, -1
    j    arq_ret

arq_erro_vazio:
    li   $v0, 4
    la   $a0, str_arq_vazio
    syscall
    li   $v0, -1

arq_ret:
    lw   $s1, 0($sp)
    lw   $s0, 4($sp)
    lw   $ra, 8($sp)
    addiu $sp, $sp, 12
    jr   $ra

# Converte texto ($a0) em pares (.word CODIGO, VALOR) em $a1; retorna $v0 = eventos
converter_texto_para_partitura:
    addiu $sp, $sp, -24
    sw   $ra, 20($sp)
    sw   $s0, 16($sp)       # cursor texto
    sw   $s1, 12($sp)       # cursor buffer_partitura
    sw   $s2, 8($sp)        # contador eventos
    sw   $s3, 4($sp)        # flag_async (0 ou 1)
    sw   $s4, 0($sp)        # semitom ou codigo de comando

    move $s0, $a0
    move $s1, $a1
    li   $s2, 0

conv_loop:
    li   $t0, 510
    bge  $s2, $t0, conv_fim

    lbu  $t0, 0($s0)
    beqz $t0, conv_fim

    li   $t1, 32
    ble  $t0, $t1, conv_espaco

    li   $t1, 35            # '#'
    beq  $t0, $t1, conv_skip_linha

    li   $s3, 0
    li   $t1, 43            # '+'
    bne  $t0, $t1, conv_upper1
    li   $s3, 1
    addiu $s0, $s0, 1
    lbu  $t0, 0($s0)
    beqz $t0, conv_fim

conv_upper1:
    li   $t1, 97            # 'a'
    blt  $t0, $t1, conv_dispatch
    li   $t1, 122           # 'z'
    bgt  $t0, $t1, conv_dispatch
    andi $t0, $t0, 0xDF

conv_dispatch:
    li   $t1, 80            # 'P' (PAUSA)
    beq  $t0, $t1, conv_cmd_pausa
    li   $t1, 73            # 'I' (INST)
    beq  $t0, $t1, conv_cmd_inst
    li   $t1, 86            # 'V' (VOL)
    beq  $t0, $t1, conv_cmd_vol

    li   $t1, 68            # 'D' (DO)
    beq  $t0, $t1, conv_nota_do
    li   $t1, 82            # 'R' (RE)
    beq  $t0, $t1, conv_nota_re
    li   $t1, 77            # 'M' (MI)
    beq  $t0, $t1, conv_nota_mi
    li   $t1, 70            # 'F' (FA)
    beq  $t0, $t1, conv_nota_fa
    li   $t1, 76            # 'L' (LA)
    beq  $t0, $t1, conv_nota_la
    li   $t1, 83            # 'S' (SOL ou SI)
    beq  $t0, $t1, conv_nota_s

conv_skip_linha:
    lbu  $t0, 0($s0)
    beqz $t0, conv_fim
    addiu $s0, $s0, 1
    li   $t1, 10            # '\n'
    beq  $t0, $t1, conv_loop
    j    conv_skip_linha

conv_espaco:
    addiu $s0, $s0, 1
    j    conv_loop

conv_cmd_pausa:
    li   $s4, -2
    j    conv_cmd_ler

conv_cmd_inst:
    li   $s4, -3
    j    conv_cmd_ler

conv_cmd_vol:
    li   $s4, -4

conv_cmd_ler:
    lbu  $t0, 0($s0)
    li   $t1, 65
    blt  $t0, $t1, conv_cmd_num
    li   $t1, 122
    bgt  $t0, $t1, conv_cmd_num
    li   $t1, 90
    ble  $t0, $t1, conv_cmd_avanca
    li   $t1, 97
    blt  $t0, $t1, conv_cmd_num
conv_cmd_avanca:
    addiu $s0, $s0, 1
    j    conv_cmd_ler

conv_cmd_num:
    move $a0, $s0
    jal  ler_inteiro_buffer
    move $s0, $v1

    li   $t0, -2
    beq  $s4, $t0, conv_cmd_chk_pausa
    bltz $v0, conv_loop
    li   $t0, 127
    bgt  $v0, $t0, conv_loop
    move $t2, $s4
    j    conv_grava_evento

conv_cmd_chk_pausa:
    blez $v0, conv_loop
    move $t2, $s4
    j    conv_grava_evento

conv_nota_do:
    li   $s4, 0
    j    conv_nota_avanca1
conv_nota_re:
    li   $s4, 2
    j    conv_nota_avanca1
conv_nota_mi:
    li   $s4, 4
    j    conv_nota_avanca1
conv_nota_fa:
    li   $s4, 5
    j    conv_nota_avanca1
conv_nota_la:
    li   $s4, 9
    j    conv_nota_avanca1

conv_nota_s:
    lbu  $t1, 1($s0)
    li   $t2, 97
    blt  $t1, $t2, conv_s_chk
    li   $t2, 122
    bgt  $t1, $t2, conv_s_chk
    andi $t1, $t1, 0xDF
conv_s_chk:
    li   $t2, 79            # 'O' (SOL)
    beq  $t1, $t2, conv_nota_sol
    li   $t2, 73            # 'I' (SI)
    beq  $t1, $t2, conv_nota_si
    j    conv_skip_linha

conv_nota_sol:
    li   $s4, 7
    j    conv_nota_avanca1

conv_nota_si:
    li   $s4, 11

conv_nota_avanca1:
    addiu $s0, $s0, 1

# Avanca bytes de acento (>= 128) e letras internas (A, E, I, L, O) parando em #, b/B ou digito
conv_avanca_nome:
    lbu  $t0, 0($s0)
    beqz $t0, conv_acidente
    li   $t1, 128
    bge  $t0, $t1, conv_avanca_next
    andi $t1, $t0, 0xDF
    li   $t2, 65            # 'A'
    beq  $t1, $t2, conv_avanca_next
    li   $t2, 69            # 'E'
    beq  $t1, $t2, conv_avanca_next
    li   $t2, 73            # 'I'
    beq  $t1, $t2, conv_avanca_next
    li   $t2, 76            # 'L'
    beq  $t1, $t2, conv_avanca_next
    li   $t2, 79            # 'O'
    beq  $t1, $t2, conv_avanca_next
    j    conv_acidente

conv_avanca_next:
    addiu $s0, $s0, 1
    j    conv_avanca_nome

conv_acidente:
    lbu  $t0, 0($s0)
    li   $t1, 35            # '#'
    beq  $t0, $t1, conv_sustenido
    li   $t1, 98            # 'b'
    beq  $t0, $t1, conv_bemol
    li   $t1, 66            # 'B'
    beq  $t0, $t1, conv_bemol
    j    conv_oitava

conv_sustenido:
    addiu $s4, $s4, 1
    addiu $s0, $s0, 1
    j    conv_oitava

conv_bemol:
    addiu $s4, $s4, -1
    addiu $s0, $s0, 1

conv_oitava:
    li   $t2, 4             # oitava padrao
    lbu  $t0, 0($s0)
    li   $t1, 48            # '0'
    blt  $t0, $t1, conv_calc_pitch
    li   $t1, 56            # '8'
    bgt  $t0, $t1, conv_calc_pitch
    addiu $t2, $t0, -48
    addiu $s0, $s0, 1

conv_calc_pitch:
    addiu $t2, $t2, 1       # (oitava + 1) * 12 + semitom
    li   $t3, 12
    mul  $t2, $t2, $t3
    addu $t2, $t2, $s4
    bgez $t2, conv_clamp_hi
    li   $t2, 0
conv_clamp_hi:
    li   $t3, 127
    ble  $t2, $t3, conv_chk_async
    li   $t2, 127
conv_chk_async:
    beqz $s3, conv_ler_dur
    addiu $t2, $t2, 1000

conv_ler_dur:
    move $a0, $s0
    move $s4, $t2
    jal  ler_inteiro_buffer
    move $s0, $v1
    blez $v0, conv_loop
    move $t2, $s4

conv_grava_evento:
    sw   $t2, 0($s1)
    sw   $v0, 4($s1)
    addiu $s1, $s1, 8
    addiu $s2, $s2, 1
    j    conv_loop

conv_fim:
    li   $t0, -1
    sw   $t0, 0($s1)
    sw   $zero, 4($s1)

    move $v0, $s2
    lw   $s4, 0($sp)
    lw   $s3, 4($sp)
    lw   $s2, 8($sp)
    lw   $s1, 12($sp)
    lw   $s0, 16($sp)
    lw   $ra, 20($sp)
    addiu $sp, $sp, 24
    jr   $ra

# Le inteiro decimal em $a0 (pula ' ' e '\t'); retorna $v0 = valor (-1 se ausente) e $v1 = novo ptr
ler_inteiro_buffer:
    move $t0, $a0
    li   $v0, 0
    li   $t3, 0

lib_skip:
    lbu  $t1, 0($t0)
    li   $t2, 32            # ' '
    beq  $t1, $t2, lib_skip_next
    li   $t2, 9             # '\t'
    beq  $t1, $t2, lib_skip_next
    j    lib_digito
lib_skip_next:
    addiu $t0, $t0, 1
    j    lib_skip

lib_digito:
    lbu  $t1, 0($t0)
    li   $t2, 48            # '0'
    blt  $t1, $t2, lib_fim
    li   $t2, 57            # '9'
    bgt  $t1, $t2, lib_fim

    li   $t3, 1
    li   $t2, 10
    mul  $v0, $v0, $t2
    addiu $t1, $t1, -48
    addu $v0, $v0, $t1
    addiu $t0, $t0, 1
    j    lib_digito

lib_fim:
    bnez $t3, lib_ok
    li   $v0, -1
lib_ok:
    move $v1, $t0
    jr   $ra

# Alterna entre modo Zero-Latency Audio (0) e Log Detalhado (1)
alternar_log_detalhado:
    la   $t0, log_detalhado
    lw   $t1, 0($t0)
    xori $t1, $t1, 1
    sw   $t1, 0($t0)

    bnez $t1, alt_log_on
    li   $v0, 4
    la   $a0, str_toggle_off
    syscall
    jr   $ra

alt_log_on:
    li   $v0, 4
    la   $a0, str_toggle_on
    syscall
    jr   $ra

# Reproduz todas as faixas do catalogo em sequencia
modo_jukebox:
    addiu $sp, $sp, -8
    sw   $ra, 4($sp)
    sw   $s0, 0($sp)

    li   $v0, 4
    la   $a0, str_jukebox_ini
    syscall

    li   $s0, 0
jukebox_loop:
    move $a0, $s0
    jal  tocar_musica_catalogo

    addiu $s0, $s0, 1
    li   $t0, 6
    bge  $s0, $t0, jukebox_fim

    li   $v0, 4
    la   $a0, str_jukebox_sep
    syscall
    li   $a0, 1000
    jal  executar_pausa
    j    jukebox_loop

jukebox_fim:
    li   $v0, 4
    la   $a0, str_jukebox_fim
    syscall

    lw   $s0, 0($sp)
    lw   $ra, 4($sp)
    addiu $sp, $sp, 8
    jr   $ra

# Interpreta array de partitura ($a0 = base, $a1 = inst inicial, $a2 = vol inicial)
interpretar_partitura:
    addiu $sp, $sp, -24
    sw   $ra, 20($sp)
    sw   $s0, 16($sp)       # ponteiro do evento atual
    sw   $s1, 12($sp)       # instrumento ativo
    sw   $s2, 8($sp)        # volume ativo
    sw   $s3, 4($sp)        # CODIGO
    sw   $s4, 0($sp)        # VALOR

    move $s0, $a0
    move $s1, $a1
    move $s2, $a2

interp_loop:
    lw   $s3, 0($s0)
    lw   $s4, 4($s0)

    li   $t0, -1
    beq  $s3, $t0, interp_fim

    li   $t0, -2
    beq  $s3, $t0, interp_pausa

    li   $t0, -3
    beq  $s3, $t0, interp_timbre

    li   $t0, -4
    beq  $s3, $t0, interp_volume

    li   $t0, 1000
    bge  $s3, $t0, interp_async

    bltz $s3, interp_proximo
    li   $t0, 127
    bgt  $s3, $t0, interp_proximo

    la   $t0, log_detalhado
    lw   $t0, 0($t0)
    beqz $t0, interp_sync_play

    li   $v0, 4
    la   $a0, str_log_sync
    syscall
    move $a0, $s3
    move $a1, $s4
    move $a2, $s1
    move $a3, $s2
    jal  imprimir_detalhes_nota

interp_sync_play:
    move $a0, $s3
    move $a1, $s4
    move $a2, $s1
    move $a3, $s2
    jal  tocar_nota_sync
    j    interp_proximo

interp_async:
    subu $t1, $s3, $t0      # pitch = CODIGO - 1000
    bltz $t1, interp_proximo
    li   $t2, 127
    bgt  $t1, $t2, interp_proximo

    la   $t0, log_detalhado
    lw   $t0, 0($t0)
    beqz $t0, interp_async_play

    li   $v0, 4
    la   $a0, str_log_async
    syscall
    move $a0, $t1
    move $a1, $s4
    move $a2, $s1
    move $a3, $s2
    jal  imprimir_detalhes_nota

interp_async_play:
    subu $a0, $s3, 1000
    move $a1, $s4
    move $a2, $s1
    move $a3, $s2
    jal  tocar_nota_async
    j    interp_proximo

interp_pausa:
    la   $t0, log_detalhado
    lw   $t0, 0($t0)
    beqz $t0, interp_pausa_exec

    li   $v0, 4
    la   $a0, str_log_pausa
    syscall
    li   $v0, 1
    move $a0, $s4
    syscall
    li   $v0, 4
    la   $a0, str_log_ms
    syscall
    li   $v0, 4
    la   $a0, str_nl
    syscall

interp_pausa_exec:
    move $a0, $s4
    jal  executar_pausa
    j    interp_proximo

interp_timbre:
    la   $t0, instrumento_override
    lw   $t1, 0($t0)
    bgez $t1, interp_timbre_ignorado

    bltz $s4, interp_proximo
    li   $t0, 127
    bgt  $s4, $t0, interp_proximo

    move $s1, $s4
    la   $t0, log_detalhado
    lw   $t0, 0($t0)
    beqz $t0, interp_proximo

    li   $v0, 4
    la   $a0, str_log_timbre
    syscall
    li   $v0, 1
    move $a0, $s1
    syscall
    li   $v0, 4
    la   $a0, str_nl
    syscall
    j    interp_proximo

interp_timbre_ignorado:
    la   $t0, log_detalhado
    lw   $t0, 0($t0)
    beqz $t0, interp_proximo

    li   $v0, 4
    la   $a0, str_log_timb_ig
    syscall
    j    interp_proximo

interp_volume:
    bltz $s4, interp_proximo
    li   $t0, 127
    bgt  $s4, $t0, interp_proximo

    move $s2, $s4
    la   $t0, log_detalhado
    lw   $t0, 0($t0)
    beqz $t0, interp_proximo

    li   $v0, 4
    la   $a0, str_log_volume
    syscall
    li   $v0, 1
    move $a0, $s2
    syscall
    li   $v0, 4
    la   $a0, str_nl
    syscall

interp_proximo:
    addiu $s0, $s0, 8       # proximo evento (2 words)
    j    interp_loop

interp_fim:
    li   $v0, 4
    la   $a0, str_play_fim
    syscall

    lw   $s4, 0($sp)
    lw   $s3, 4($sp)
    lw   $s2, 8($sp)
    lw   $s1, 12($sp)
    lw   $s0, 16($sp)
    lw   $ra, 20($sp)
    addiu $sp, $sp, 24
    jr   $ra

# Imprime log formatado de nota ($a0=pitch, $a1=dur, $a2=inst, $a3=vol)
imprimir_detalhes_nota:
    move $t0, $a0

    li   $v0, 4
    la   $a0, str_log_pitch
    syscall
    li   $v0, 1
    move $a0, $t0
    syscall

    li   $v0, 4
    la   $a0, str_log_dur
    syscall
    li   $v0, 1
    move $a0, $a1
    syscall
    li   $v0, 4
    la   $a0, str_log_ms
    syscall

    li   $v0, 4
    la   $a0, str_log_inst
    syscall
    li   $v0, 1
    move $a0, $a2
    syscall

    li   $v0, 4
    la   $a0, str_log_vol
    syscall
    li   $v0, 1
    move $a0, $a3
    syscall

    li   $v0, 4
    la   $a0, str_nl
    syscall
    jr   $ra

# Menu de selecao de timbre global com acorde de preview
selecionar_instrumento:
    addiu $sp, $sp, -8
    sw   $ra, 4($sp)
    sw   $s0, 0($sp)

    li   $v0, 4
    la   $a0, str_inst_menu
    syscall

    li   $v0, 5
    syscall
    move $t0, $v0

    li   $t1, -1
    beq  $t0, $t1, sel_restaurar

    li   $t1, 9
    beq  $t0, $t1, sel_custom

    li   $t1, 1
    blt  $t0, $t1, sel_invalido
    li   $t1, 8
    bgt  $t0, $t1, sel_invalido

    addiu $t0, $t0, -1
    sll  $t0, $t0, 2
    la   $t1, tabela_presets_inst
    addu $t1, $t1, $t0
    lw   $s0, 0($t1)
    j    sel_aplicar

sel_custom:
    li   $v0, 4
    la   $a0, str_inst_custom
    syscall
    li   $v0, 5
    syscall
    move $s0, $v0

    bltz $s0, sel_invalido
    li   $t1, 127
    bgt  $s0, $t1, sel_invalido

sel_aplicar:
    la   $t0, instrumento_override
    sw   $s0, 0($t0)

    li   $v0, 4
    la   $a0, str_inst_definido
    syscall
    li   $v0, 1
    move $a0, $s0
    syscall
    li   $v0, 4
    la   $a0, str_inst_preview
    syscall

    li   $a0, 60
    li   $a1, 550
    move $a2, $s0
    li   $a3, 110
    jal  tocar_nota_async

    li   $a0, 64
    li   $a1, 550
    move $a2, $s0
    li   $a3, 110
    jal  tocar_nota_async

    li   $a0, 67
    li   $a1, 550
    move $a2, $s0
    li   $a3, 110
    jal  tocar_nota_sync
    j    sel_ret

sel_restaurar:
    la   $t0, instrumento_override
    li   $t1, -1
    sw   $t1, 0($t0)
    li   $v0, 4
    la   $a0, str_inst_restaurado
    syscall
    j    sel_ret

sel_invalido:
    li   $v0, 4
    la   $a0, str_inst_invalido
    syscall

sel_ret:
    lw   $s0, 0($sp)
    lw   $ra, 4($sp)
    addiu $sp, $sp, 8
    jr   $ra

# Demonstra polifonia (C -> F -> G7 -> C) usando Syscall 31 + Syscall 32
demo_polifonia:
    addiu $sp, $sp, -8
    sw   $ra, 4($sp)
    sw   $s0, 0($sp)

    la   $t0, instrumento_override
    lw   $s0, 0($t0)
    bgez $s0, demo_inst_ok
    li   $s0, 0

demo_inst_ok:
    li   $v0, 4
    la   $a0, str_demo_ini
    syscall
    li   $v0, 1
    move $a0, $s0
    syscall
    li   $v0, 4
    la   $a0, str_nl
    syscall

    li   $v0, 4
    la   $a0, str_demo_c
    syscall
    li   $a0, 48
    li   $a1, 900
    move $a2, $s0
    li   $a3, 105
    jal  tocar_nota_async
    li   $a0, 60
    li   $a1, 900
    move $a2, $s0
    li   $a3, 105
    jal  tocar_nota_async
    li   $a0, 64
    li   $a1, 900
    move $a2, $s0
    li   $a3, 105
    jal  tocar_nota_async
    li   $a0, 67
    li   $a1, 900
    move $a2, $s0
    li   $a3, 105
    jal  tocar_nota_async
    li   $a0, 900
    jal  executar_pausa

    li   $v0, 4
    la   $a0, str_demo_f
    syscall
    li   $a0, 53
    li   $a1, 900
    move $a2, $s0
    li   $a3, 105
    jal  tocar_nota_async
    li   $a0, 60
    li   $a1, 900
    move $a2, $s0
    li   $a3, 105
    jal  tocar_nota_async
    li   $a0, 65
    li   $a1, 900
    move $a2, $s0
    li   $a3, 105
    jal  tocar_nota_async
    li   $a0, 69
    li   $a1, 900
    move $a2, $s0
    li   $a3, 105
    jal  tocar_nota_async
    li   $a0, 900
    jal  executar_pausa

    li   $v0, 4
    la   $a0, str_demo_g7
    syscall
    li   $a0, 55
    li   $a1, 900
    move $a2, $s0
    li   $a3, 108
    jal  tocar_nota_async
    li   $a0, 59
    li   $a1, 900
    move $a2, $s0
    li   $a3, 108
    jal  tocar_nota_async
    li   $a0, 62
    li   $a1, 900
    move $a2, $s0
    li   $a3, 108
    jal  tocar_nota_async
    li   $a0, 65
    li   $a1, 900
    move $a2, $s0
    li   $a3, 108
    jal  tocar_nota_async
    li   $a0, 900
    jal  executar_pausa

    li   $v0, 4
    la   $a0, str_demo_c_end
    syscall
    li   $a0, 48
    li   $a1, 1300
    move $a2, $s0
    li   $a3, 115
    jal  tocar_nota_async
    li   $a0, 64
    li   $a1, 1300
    move $a2, $s0
    li   $a3, 115
    jal  tocar_nota_async
    li   $a0, 67
    li   $a1, 1300
    move $a2, $s0
    li   $a3, 115
    jal  tocar_nota_async
    li   $a0, 72
    li   $a1, 1300
    move $a2, $s0
    li   $a3, 115
    jal  tocar_nota_async
    li   $a0, 1300
    jal  executar_pausa

    li   $v0, 4
    la   $a0, str_demo_fim
    syscall

    lw   $s0, 0($sp)
    lw   $ra, 4($sp)
    addiu $sp, $sp, 8
    jr   $ra

# Nota sincrona via Syscall 31 + Syscall 32: ajusta tempo (+25%) e adiciona 35ms de legato no MIDI para evitar estalos de corte
tocar_nota_sync:
    blez $a1, sync_ret
    srl  $t1, $a1, 2
    addu $t0, $a1, $t1      # $t0 = duracao do Sleep (dur * 1.25)
    addiu $a1, $t0, 35      # $a1 = duracao MIDI com leve legato para evitar estalo
    li   $v0, 31
    syscall
    move $a0, $t0
    li   $v0, 32
    syscall
sync_ret:
    jr   $ra

# Syscall 31: MIDI out assincrono ($a0=pitch, $a1=dur_ms, $a2=inst, $a3=vol)
tocar_nota_async:
    li   $v0, 31
    syscall
    jr   $ra

# Syscall 32: Sleep em milissegundos ($a0=dur_ms) com ajuste de +25% no tempo
executar_pausa:
    blez $a0, pausa_ret
    srl  $t1, $a0, 2
    addu $a0, $a0, $t1
    li   $v0, 32
    syscall
pausa_ret:
    jr   $ra
