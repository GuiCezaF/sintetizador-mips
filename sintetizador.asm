.data
.align 2
instrumento_override:   .word -1        # -1 = timbre da partitura; 0..127 = override global

.align 2
tabela_presets_inst:    .word 0, 11, 19, 21, 24, 40, 73, 80

str_banner:
    .asciiz "\n============================================================\n  MAQUINA DE MUSICA - SINTETIZADOR MIDI \n============================================================\n"
str_status_auto:
    .asciiz "Timbre Ativo: [Automatico da Partitura]\n"
str_status_override:
    .asciiz "Timbre Ativo: [Override Global -> MIDI ID "
str_fecha_colchete:
    .asciiz "]\n"
str_menu:
    .asciiz "------------------------------------------------------------\n  [1] Tocar: Ode to Joy - Beethoven (Piano + Acordes)\n  [2] Tocar: Chiptune 8-Bit - Tema Arcade (Staccato + Sleep)\n  [3] Tocar: Asa Branca - Luiz Gonzaga (Sanfona <-> Flauta)\n  [4] Modo Jukebox (Tocar todas em sequencia)\n  [5] Sintetizador: Escolher Timbre / Instrumento Global\n  [6] Demonstracao de Polifonia (Syscall 31 + Syscall 32)\n  [0] Sair\n------------------------------------------------------------\nEscolha uma opcao: "

str_op_invalida:
    .asciiz "\n[ERRO] Opcao invalida! Digite um numero entre 0 e 6.\n"
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

str_jukebox_ini: .asciiz "\n=== INICIANDO MODO JUKEBOX (3 FAIXAS) ===\n"
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

titulo_ode:      .asciiz "Ode to Joy - Beethoven (Sinfonia No. 9)"
titulo_chiptune: .asciiz "Chiptune 8-Bit - Tema Classico Arcade"
titulo_asa:      .asciiz "Asa Branca - Luiz Gonzaga"

# Catalogo (16 bytes/entrada): titulo_ptr, inst_padrao, vol_padrao, partitura_ptr
.align 2
catalogo_musicas:
    .word titulo_ode,      0,  105, partitura_ode_to_joy
    .word titulo_chiptune, 80, 110, partitura_chiptune
    .word titulo_asa,      21, 100, partitura_asa_branca

# Eventos (.word CODIGO, VALOR): 0..127 sync | 1000..1127 async | -2 pausa | -3 inst | -4 vol | -1 fim
.align 2
partitura_ode_to_joy:
    .word 1048, 700
    .word 1060, 700
    .word 1064, 700
    .word 67, 700
    .word -2, 150
    .word 64, 400
    .word 64, 400
    .word 65, 400
    .word 67, 400
    .word 67, 400
    .word 65, 400
    .word 64, 400
    .word 62, 400
    .word 60, 400
    .word 60, 400
    .word 62, 400
    .word 64, 400
    .word 64, 600
    .word 62, 200
    .word 62, 800
    .word -2, 150
    .word -4, 85
    .word 64, 400
    .word 64, 400
    .word 65, 400
    .word 67, 400
    .word 67, 400
    .word 65, 400
    .word 64, 400
    .word 62, 400
    .word 60, 400
    .word 60, 400
    .word 62, 400
    .word 64, 400
    .word 62, 600
    .word 60, 200
    .word 60, 800
    .word -2, 150
    .word -4, 115
    .word 62, 400
    .word 62, 400
    .word 64, 400
    .word 60, 400
    .word 62, 400
    .word 64, 200
    .word 65, 200
    .word 64, 400
    .word 60, 400
    .word 62, 400
    .word 64, 200
    .word 65, 200
    .word 64, 400
    .word 62, 400
    .word 60, 400
    .word 62, 400
    .word 55, 800
    .word -2, 120
    .word -4, 122
    .word 64, 400
    .word 64, 400
    .word 65, 400
    .word 67, 400
    .word 67, 400
    .word 65, 400
    .word 64, 400
    .word 62, 400
    .word 60, 400
    .word 60, 400
    .word 62, 400
    .word 64, 400
    .word 62, 600
    .word 60, 200
    .word 1048, 1200
    .word 1060, 1200
    .word 1064, 1200
    .word 1067, 1200
    .word 72, 1200
    .word -1, 0

.align 2
partitura_chiptune:
    .word 76, 130
    .word -2, 50
    .word 76, 130
    .word -2, 140
    .word 76, 130
    .word -2, 140
    .word 72, 130
    .word -2, 40
    .word 76, 140
    .word -2, 140
    .word 79, 240
    .word -2, 260
    .word 67, 240
    .word -2, 260
    .word 72, 180
    .word -2, 160
    .word 67, 180
    .word -2, 160
    .word 64, 180
    .word -2, 160
    .word 69, 160
    .word -2, 60
    .word 71, 160
    .word -2, 60
    .word 70, 130
    .word 69, 180
    .word -2, 60
    .word 67, 140
    .word 76, 140
    .word 79, 140
    .word 81, 180
    .word -2, 50
    .word 77, 130
    .word 79, 140
    .word -2, 60
    .word 76, 150
    .word -2, 70
    .word 72, 130
    .word 74, 130
    .word 71, 200
    .word -2, 160
    .word -4, 118
    .word 1048, 380
    .word 1060, 380
    .word 64, 120
    .word 67, 120
    .word 72, 160
    .word -2, 60
    .word 1053, 380
    .word 1065, 380
    .word 69, 120
    .word 72, 120
    .word 77, 160
    .word -2, 60
    .word 1055, 380
    .word 1067, 380
    .word 71, 120
    .word 74, 120
    .word 79, 180
    .word -2, 80
    .word 60, 75
    .word 64, 75
    .word 67, 75
    .word 72, 75
    .word 76, 75
    .word 79, 75
    .word 1060, 750
    .word 1064, 750
    .word 1067, 750
    .word 84, 750
    .word -1, 0

.align 2
partitura_asa_branca:
    .word 1048, 600
    .word 1060, 600
    .word 1064, 600
    .word 67, 600
    .word -2, 150
    .word 60, 260
    .word 62, 260
    .word 64, 480
    .word 67, 480
    .word 67, 480
    .word 64, 480
    .word 65, 480
    .word 65, 750
    .word -2, 180
    .word 60, 260
    .word 62, 260
    .word 64, 480
    .word 67, 480
    .word 67, 480
    .word 65, 480
    .word 64, 850
    .word -2, 220
    .word -3, 73
    .word -4, 108
    .word 60, 260
    .word 60, 260
    .word 62, 260
    .word 64, 480
    .word 67, 480
    .word 67, 260
    .word 65, 260
    .word 64, 480
    .word 60, 260
    .word 65, 700
    .word -2, 180
    .word 65, 260
    .word 64, 260
    .word 62, 260
    .word 62, 480
    .word 64, 260
    .word 62, 260
    .word 62, 480
    .word 60, 260
    .word 60, 850
    .word -2, 200
    .word -3, 21
    .word -4, 112
    .word 67, 240
    .word 64, 240
    .word 65, 240
    .word 62, 240
    .word 64, 240
    .word 60, 240
    .word 62, 240
    .word 59, 240
    .word 1048, 1050
    .word 1060, 1050
    .word 1064, 1050
    .word 67, 1050
    .word -1, 0


.text
.globl main

# Loop principal do menu interativo
main:
main_loop:
    jal  exibir_menu

    li   $v0, 5             # read_int -> $v0
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
    jal  modo_jukebox
    j    main_loop

main_op5:
    jal  selecionar_instrumento
    j    main_loop

main_op6:
    jal  demo_polifonia
    j    main_loop

main_sair:
    li   $v0, 4
    la   $a0, str_saindo
    syscall
    li   $v0, 10
    syscall

# Exibe cabecalho, status de timbre e opcoes do menu
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
    j    menu_imprime_opcoes

menu_status_auto:
    li   $v0, 4
    la   $a0, str_status_auto
    syscall

menu_imprime_opcoes:
    li   $v0, 4
    la   $a0, str_menu
    syscall
    jr   $ra

# Carrega entrada do catalogo ($a0 = indice 0..2) e inicia interpretacao
tocar_musica_catalogo:
    addiu $sp, $sp, -20
    sw   $ra, 16($sp)
    sw   $s0, 12($sp)
    sw   $s1, 8($sp)
    sw   $s2, 4($sp)
    sw   $s3, 0($sp)

    bltz $a0, cat_ret
    li   $t0, 3
    bge  $a0, $t0, cat_ret

    sll  $t0, $a0, 4        # indice * 16 bytes por entrada
    la   $t1, catalogo_musicas
    addu $t0, $t1, $t0

    lw   $s0, 0($t0)        # titulo
    lw   $s1, 4($t0)        # instrumento padrao
    lw   $s2, 8($t0)        # volume padrao
    lw   $s3, 12($t0)       # partitura

    la   $t2, instrumento_override
    lw   $t3, 0($t2)
    bltz $t3, cat_sem_override
    move $s1, $t3

cat_sem_override:
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

    move $a0, $s3
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
    li   $t0, 3
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

    li   $v0, 4
    la   $a0, str_log_sync
    syscall
    move $a0, $s3
    move $a1, $s4
    move $a2, $s1
    move $a3, $s2
    jal  imprimir_detalhes_nota

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

    li   $v0, 4
    la   $a0, str_log_async
    syscall
    move $a0, $t1
    move $a1, $s4
    move $a2, $s1
    move $a3, $s2
    jal  imprimir_detalhes_nota

    subu $a0, $s3, 1000
    move $a1, $s4
    move $a2, $s1
    move $a3, $s2
    jal  tocar_nota_async
    j    interp_proximo

interp_pausa:
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
    li   $v0, 4
    la   $a0, str_log_timb_ig
    syscall
    j    interp_proximo

interp_volume:
    bltz $s4, interp_proximo
    li   $t0, 127
    bgt  $s4, $t0, interp_proximo

    move $s2, $s4
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

# Syscall 33: MIDI out sincrono ($a0=pitch, $a1=dur_ms, $a2=inst, $a3=vol)
tocar_nota_sync:
    li   $v0, 33
    syscall
    jr   $ra

# Syscall 31: MIDI out assincrono ($a0=pitch, $a1=dur_ms, $a2=inst, $a3=vol)
tocar_nota_async:
    li   $v0, 31
    syscall
    jr   $ra

# Syscall 32: Sleep em milissegundos ($a0=dur_ms)
executar_pausa:
    blez $a0, pausa_ret
    li   $v0, 32
    syscall
pausa_ret:
    jr   $ra
