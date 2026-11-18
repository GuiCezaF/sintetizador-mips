# Máquina de Música — Sintetizador MIDI em Assembly MIPS (MARS 4.5)

Sintetizador e interpretador de partituras musicais escrito em **Assembly MIPS** para o simulador **MARS 4.5**. O projeto estrutura partituras como sequências de eventos em memória (`.data`), reproduzindo melodias, acordes polifônicos, pausas musicais e mudanças dinâmicas de timbre e volume através das chamadas de sistema de áudio MIDI do MARS.

---

## Como Abrir, Montar e Executar no MARS 4.5

1. Baixe ou abra o simulador **MARS 4.5** (`Mars4_5.jar`).
2. No menu superior, acesse **File → Open...** e selecione `sintetizador.asm`.
3. Pressione **`F3`** (ou **Run → Assemble**) para montar o programa.
   - Certifique-se de que a opção padrão **Settings → Permit extended (pseudo) instructions and formats** esteja habilitada.
4. Pressione **`F5`** (ou **Run → Go**) para executar.
5. Utilize a aba **Run I/O** no console inferior do MARS para navegar pelo menu interativo digitando o número da opção desejada e pressionando `Enter`:
   - `[1]` **Ode to Joy — Beethoven** (Piano acústico com acordes de abertura/encerramento e dinâmica de volume)
   - `[2]` **Chiptune 8-Bit — Tema Clássico Arcade** (Onda quadrada com articulação *staccato* via `syscall 32` e progressão arcade)
   - `[3]` **Asa Branca — Luiz Gonzaga** (Sanfona com acorde introdutório e troca dinâmica para Flauta no 2º verso)
   - `[4]` **DOOM (E1M1) — At Doom's Gate** (Guitarra *Overdriven* com riff ostinato nítido, *power chords* e turnaround em Mi/Lá menor)
   - `[5]` **Minecraft — C418 (Sweden / Calm)** (Piano com melodia imediata em destaque e acompanhamento suave via `syscall 31`)
   - `[6]` **JoJo — Il Vento D'oro (3:46 a 4:00 Piano Break)** (Transcrição fiel dos 14s do riff e melodia aguda de piano em Si menor)
   - `[7]` **Modo Jukebox** (Toca todas as 6 faixas em sequência)
   - `[8]` **Seletor de Timbre / Instrumento Global** (Override de instrumento MIDI com preview sonoro em acorde)
   - `[9]` **Demonstração de Polifonia** (Progressão `C → F → G7 → C` com 4 vozes simultâneas usando `syscall 31` + `syscall 32`)
   - `[0]` **Sair**

> **Dica de áudio:** Verifique se o volume do sistema operacional e o sintetizador MIDI Java (Soundbank padrão do JVM) estão ativos para ouvir as notas durante a execução no MARS.

---

## Syscalls de Áudio e Temporização Utilizadas

O MARS oferece suporte nativo a MIDI e temporização através dos seguintes códigos de syscall em `$v0`:

| Syscall (`$v0`) | Nome | Argumentos | Comportamento |
| :---: | :--- | :--- | :--- |
| **`31`** | `MIDI out` (Assíncrono) | `$a0` = pitch (`0..127`)<br>`$a1` = duração (`ms`)<br>`$a2` = instrumento (`0..127`)<br>`$a3` = volume (`0..127`) | Dispara a nota MIDI e **retorna imediatamente** sem bloquear a CPU. Permite empilhar múltiplas notas ao mesmo tempo para formar **acordes polifônicos**. |
| **`32`** | `Sleep` | `$a0` = duração (`ms`) | Suspende a execução da thread pelo tempo especificado. Usada para **pausas/silêncios musicais**, articulação *staccato* e sustentação de acordes assíncronos. |
| **`33`** | `MIDI out synchronous` | `$a0` = pitch (`0..127`)<br>`$a1` = duração (`ms`)<br>`$a2` = instrumento (`0..127`)<br>`$a3` = volume (`0..127`) | Toca a nota MIDI e **aguarda sua duração terminar** antes de retornar ao chamador. Ideal para linhas melódicas sequenciais. |

---

## Protocolo em Memória das Partituras (`.data`)

### 1. Eventos da Partitura
Cada partitura é um array alinhado em word (`.align 2`) formado por pares consecutivos de `.word` (`8 bytes` por evento):

```mips
.word CODIGO, VALOR
```

| `CODIGO` (Word 0) | `VALOR` (Word 1) | Significado Semântico | Ação no Interpretador |
| :---: | :---: | :--- | :--- |
| `0` a `127` | Duração em ms (`> 0`) | **Nota Melódica Síncrona** | Executa `tocar_nota_sync` (**Syscall 33**) |
| `1000` a `1127` | Duração em ms (`> 0`) | **Nota de Acorde Assíncrona** | Calcula `pitch = CODIGO - 1000` e executa `tocar_nota_async` (**Syscall 31**) |
| `-2` | Duração em ms (`> 0`) | **Pausa / Silêncio Musical** | Executa `executar_pausa` (**Syscall 32**) |
| `-3` | ID Instrumento (`0..127`) | **Mudança Dinâmica de Timbre** | Atualiza `$s1` (ignorado se `instrumento_override >= 0`) |
| `-4` | Volume (`0..127`) | **Mudança Dinâmica de Volume** | Atualiza `$s2` para as próximas notas |
| `-1` | `0` | **Sentinela `FIM_PARTITURA`** | Encerra o loop e retorna da sub-rotina |

#### Como codificar acordes polifônicos
Para tocar um acorde de Dó Maior (`C4=60`, `E4=64`, `G4=67`) por `600 ms`, dispare as primeiras vozes de forma assíncrona (`+1000`) e a última de forma síncrona (ou todas assíncronas seguidas de pausa `-2`):

```mips
.word 1060, 600   # Dispara C4 via Syscall 31 (nao bloqueia)
.word 1064, 600   # Dispara E4 via Syscall 31 (nao bloqueia)
.word 67,   600   # Toca G4 via Syscall 33 (bloqueia 600ms enquanto todas soam juntas)
```

### 2. Catálogo de Músicas (`catalogo_musicas`)
Cada entrada no catálogo ocupa **4 words (`16 bytes`)**:

- `+0`: Ponteiro para string `.asciiz` do título
- `+4`: Instrumento General MIDI padrão (`0..127`)
- `+8`: Volume inicial padrão (`0..127`)
- `+12`: Ponteiro para o início do array de eventos da partitura

### 3. Como Adicionar uma Nova Música
1. Crie uma string com o título na seção `.data` (ex.: `titulo_nova: .asciiz "Minha Musica"`).
2. Crie o array da partitura precedido por `.align 2` e finalizado obrigatoriamente com `.word -1, 0`.
3. Adicione uma nova linha de 4 words em `catalogo_musicas`:
   ```mips
   .word titulo_nova, 0, 100, partitura_nova
   ```
4. Atualize o limite de índice em `tocar_musica_catalogo`, `modo_jukebox` e o despacho no menu `main`.

---

## Tabela de Referência MIDI

### Notas MIDI (C2 a C6)

| Nota | C | C# / Db | D | D# / Eb | E | F | F# / Gb | G | G# / Ab | A | A# / Bb | B |
| :---: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: |
| **Oitava 2** | 36 | 37 | 38 | 39 | 40 | 41 | 42 | 43 | 44 | 45 | 46 | 47 |
| **Oitava 3** | 48 | 49 | 50 | 51 | 52 | 53 | 54 | 55 | 56 | 57 | 58 | 59 |
| **Oitava 4** | **60** | 61 | 62 | 63 | 64 | 65 | 66 | 67 | 68 | 69 | 70 | 71 |
| **Oitava 5** | 72 | 73 | 74 | 75 | 76 | 77 | 78 | 79 | 80 | 81 | 82 | 83 |
| **Oitava 6** | 84 | — | — | — | — | — | — | — | — | — | — | — |

*(Dó Central = `C4 = 60`. As partituras utilizam da oitava 2 até a oitava 6 (`84` = C6). Para uso assíncrono em acordes, some `1000` ao pitch: ex. `C4` assíncrono = `1060`.)*

### Instrumentos General MIDI Usados no Projeto

| ID MIDI | Instrumento | Uso no Projeto |
| :---: | :--- | :--- |
| `0` | Acoustic Grand Piano | Padrão de *Ode to Joy*, *Minecraft (C418)*, *JoJo — Il Vento D'oro (3:46–4:00)* e Demo de Polifonia |
| `11` | Vibraphone | Preset no seletor de timbre |
| `19` | Church Organ | Preset no seletor de timbre |
| `21` | Accordion (Sanfona) | Padrão de *Asa Branca* |
| `24` | Acoustic Guitar (Nylon) | Preset no seletor de timbre |
| `29` | Overdriven Guitar | Padrão de *DOOM (E1M1)* |
| `40` | Violin | Preset no seletor de timbre |
| `73` | Flute | Troca dinâmica (`-3, 73`) no 2º verso de *Asa Branca* |
| `80` | Lead 1 (Square Wave) | Padrão de *Chiptune 8-Bit* |

---

## Arquitetura de Sub-rotinas (`.text`)

- `main` / `exibir_menu`: Interface interativa no console do MARS, validação de entrada e despacho de ações.
- `tocar_musica_catalogo`: Lê a entrada do catálogo (`indice * 16`), aplica `instrumento_override` se ativo e invoca o interpretador.
- `interpretar_partitura`: Motor decodificador de eventos em loop com preservação de `$ra` e `$s0-$s4` em stack frame de `24 bytes`.
- `modo_jukebox`: Reproduz sequencialmente todas as faixas do catálogo com pausa de `1000 ms` entre elas.
- `selecionar_instrumento`: Permite escolher presets ou ID MIDI customizado (`0..127`), ou restaurar o modo automático (`-1`), com preview sonoro em acorde.
- `demo_polifonia`: Demonstração dedicada de acordes assíncronos de 4 vozes (`syscall 31`) temporizados com `syscall 32`.
- `tocar_nota_sync`, `tocar_nota_async`, `executar_pausa`, `imprimir_detalhes_nota`: Procedimentos folha encapsulando syscalls e formatação de log.
