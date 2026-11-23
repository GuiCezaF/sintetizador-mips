# Máquina de Música — Sintetizador MIDI em Assembly MIPS (MARS 4.5)

Sintetizador e compilador/interpretador de partituras musicais escrito em **Assembly MIPS** para o simulador **MARS 4.5**. As partituras ficam armazenadas em arquivos de texto legíveis (`.txt`) usando notação musical em português (`DO`, `RE`, `MI`, `FA`, `SOL`, `LA`, `SI`, `#`/`b`, pausas e comandos dinâmicos), sendo lidas em tempo de execução via syscalls de arquivo (`13`, `14`, `16`), convertidas dinamicamente para eventos MIDI em memória e reproduzidas pelas syscalls de áudio e temporização (`31`, `32`, `33`).

---

## Como Abrir, Montar e Executar no MARS 4.5

- **Atalho rápido no Windows:** Execute **`iniciar_mars_hd.bat`** (dois cliques ou via terminal). Ele fixa o diretório do projeto para a leitura dos `.txt`, instala automaticamente qualquer `.sf2` presente na pasta como SoundFont HD e abre o MARS já com `sintetizador.asm` carregado.

1. Caso abra manualmente, inicie o simulador **MARS 4.5** (`Mars4_5.jar`).
   - **Importante (diretório de trabalho):** As músicas são carregadas a partir de caminhos relativos (`ode_to_joy.txt`, `chiptune.txt`, etc.). Para o MARS encontrá-las, **inicie o MARS a partir da pasta do projeto** (ex.: abra o terminal na pasta `sintetizador` e execute `java -jar Mars4_5.jar`, ou garanta que o *Working Directory* do atalho do MARS seja a pasta do repositório).
2. No menu superior, acesse **File → Open...** e selecione `sintetizador.asm` (se ainda não estiver aberto).
3. Pressione **`F3`** (ou **Run → Assemble**) para montar o programa.
   - Certifique-se de que a opção padrão **Settings → Permit extended (pseudo) instructions and formats** esteja habilitada.
4. Pressione **`F5`** (ou **Run → Go**) para executar.
5. Utilize a aba **Run I/O** no console inferior do MARS para navegar pelo menu interativo:
   - `[1]` **Ode to Joy — Beethoven** (`ode_to_joy.txt`)
   - `[2]` **Chiptune 8-Bit — Tema Clássico Arcade** (`chiptune.txt`)
   - `[3]` **Asa Branca — Luiz Gonzaga** (`asa_branca.txt`)
   - `[4]` **DOOM (E1M1) — At Doom's Gate** (`doom.txt`)
   - `[5]` **Minecraft — C418 (Sweden / Calm)** (`minecraft.txt`)
   - `[6]` **JoJo — Il Vento D'oro (3:46 a 4:00 Piano Break)** (`jojo.txt`)
   - `[7]` **Modo Jukebox** (Carrega e toca todos os 6 arquivos `.txt` em sequência)
   - `[8]` **Carregar e Tocar Arquivo `.txt` Customizado** (Digite o nome de qualquer partitura `.txt`, ex.: `minha_musica.txt`)
   - `[9]` **Seletor de Timbre / Instrumento Global** (Override de instrumento MIDI com preview sonoro em acorde)
   - `[10]` **Alternar Log Detalhado de Notas (`OFF`/`ON`)** (Padrão `OFF` para áudio sem latência; `ON` exibe eventos no console)
   - `[11]` **Demonstração de Polifonia** (Progressão `C → F → G7 → C` com 4 vozes simultâneas via `syscall 31` + `syscall 32`)
   - `[0]` **Sair**

---

## Formato dos Arquivos de Partitura (`.txt`)

Você pode editar as músicas existentes ou criar novos arquivos `.txt` e tocá-los pela opção `[8]`. Cada linha aceita um comando ou nota (linhas em branco e comentários iniciados por `#` são ignorados):

| Sintaxe no `.txt` | Exemplo | Conversão para Memória (`.word CODIGO, VALOR`) |
| :--- | :--- | :--- |
| `<NOTA>[#\|b]<OITAVA> <MS>` | `MI4 400`, `FA#4 240`, `SIb3 320`, `dó4 400` | **Nota Síncrona (`syscall 33`)**: `CODIGO = (oitava + 1) * 12 + semitom`, `VALOR = <MS>` |
| `+<NOTA>[#\|b]<OITAVA> <MS>` | `+DO3 700`, `+FA#3 300` | **Nota de Acorde Assíncrona (`syscall 31`)**: `CODIGO = 1000 + pitch`, `VALOR = <MS>` |
| `PAUSA <MS>` ou `P <MS>` | `PAUSA 150`, `P 60` | **Pausa / Silêncio (`syscall 32`)**: `CODIGO = -2`, `VALOR = <MS>` |
| `INST <0..127>` | `INST 73` | **Mudança Dinâmica de Timbre**: `CODIGO = -3`, `VALOR = <ID>` (ignorado se override global estiver ativo) |
| `VOL <0..127>` | `VOL 108` | **Mudança Dinâmica de Volume**: `CODIGO = -4`, `VALOR = <VOL>` |
| `# comentário` | `# Frase principal` | Ignorado até o fim da linha (`\n`) |

### Regras do Parser em Assembly MIPS
- **Notas suportadas:** `DO` (`0`), `RE` (`2`), `MI` (`4`), `FA` (`5`), `SOL` (`7`), `LA` (`9`), `SI` (`11`).
- **Tolerância a escrita:** Aceita maiúsculas, minúsculas e vogais acentuadas (`dó4`, `ré4`, `fá#4`, `lá3`).
- **Acidentes:** `#` soma `+1` semitom; `b` subtrai `-1` semitom.
- **Oitavas:** `0` a `8` (padrão `4` se omitida).
- **Acordes polifônicos:** Prefixe as primeiras vozes com `+` (`syscall 31`, retorna imediatamente) e finalize o acorde com a última voz sem `+` (`syscall 33`, aguarda a duração):
  ```text
  +DO4 600
  +MI4 600
  SOL4 600
  ```

---

## Como Melhorar a Qualidade Sonora no MARS

O MARS usa o sintetizador MIDI nativo do Java (**Gervill**) com o banco de som (*SoundFont*) padrão da JVM, que é leve porém básico — especialmente em guitarras distorcidas e pianos graves. É possível melhorar drasticamente o áudio em três frentes:

### 1. Modo *Zero-Latency Audio* no Código (Já Ativo por Padrão)
Imprimir logs no console Swing do MARS (`syscall 4` / `syscall 1`) entre cada nota introduz um atraso de **~20 a 45 ms por nota**, dessincronizando acordes assíncronos e causando *jitter* rítmico em riffs rápidos (*DOOM* e *JoJo*).
- Neste projeto, `log_detalhado` inicia em **`0` (`OFF`)**, mantendo o loop de reprodução sem chamadas de I/O de texto. Use a opção `[10]` apenas quando quiser inspecionar as notas no console.

### 2. Substituir o SoundFont Padrão do Java (`.sf2`) no MARS
> Consulte o guia completo passo a passo em **[SOUNDFONT.md](SOUNDFONT.md)** (inclui recomendações de bancos gratuitos como *GeneralUser GS* e *Roland SC-55*, além do script automático `iniciar_mars_hd.bat`).

Sem alterar uma única linha do simulador, você pode trocar o banco de som padrão do Gervill por um SoundFont General MIDI de alta definição (como **GeneralUser GS**, **FluidR3_GM.sf2** ou **Timbres of Heaven**):
1. Baixe um arquivo `.sf2` General MIDI de sua preferência.
2. Copie o arquivo para a pasta do sintetizador Java do seu usuário com o nome **`soundbank-emg.sf2`**:
   - **Windows:** `C:\Users\<SEU_USUARIO>\.gervill\soundbank-emg.sf2` (crie a pasta `.gervill` caso não exista) ou substitua em `<JAVA_HOME>\lib\audio\`.
3. Reinicie o MARS 4.5 — todas as notas MIDI passarão a usar os novos samples de estúdio automaticamente.
*(Alternativa via código Java do MARS: caso recompile o `.jar` do MARS, carregue o arquivo em `mars/mips/instructions/syscalls/ToneGenerator.java` com `synth.loadAllInstruments(MidiSystem.getSoundbank(new File("seu_banco.sf2")))`.)*

### 3. Usar um Sintetizador MIDI Externo no Windows (CoolSoft VirtualMIDISynth)
- Instale o **CoolSoft VirtualMIDISynth**, carregue um SoundFont `.sf2` de alta qualidade e defina-o como dispositivo MIDI padrão do Windows. Isso adiciona polifonia ampla, *reverb* e *chorus* reais fora da JVM.

### 4. Boas Práticas de Escrita nas Partituras `.txt`
- **Separe acompanhamento e melodia com `VOL`:** Use `VOL 60..66` antes de notas graves assíncronas (`+`) e `VOL 102..112` para a melodia principal (técnica aplicada em `minecraft.txt`).
- **Articule notas repetidas com `PAUSA 40..90`:** Evita que ataques consecutivos da mesma tecla soem embolados (aplicado em `jojo.txt` e `chiptune.txt`).
- **Escolha timbres de ataque rápido:** No banco padrão do Java, `29` (*Overdriven Guitar*) ataca com mais definição que `30` (*Distortion Guitar*) em riffs rápidos como `doom.txt`.

---

## Syscalls Utilizadas

| Syscall (`$v0`) | Nome | Argumentos Principais | Uso no Projeto |
| :---: | :--- | :--- | :--- |
| **`13`** | `Open File` | `$a0` = nome, `$a1` = flags (`0`), `$a2` = mode (`0`) | Abre o arquivo `.txt` e retorna descritor em `$v0` |
| **`14`** | `Read File` | `$a0` = fd, `$a1` = `buffer_arquivo`, `$a2` = `16383` | Lê a partitura textual para a memória |
| **`16`** | `Close File` | `$a0` = fd | Fecha o descritor após a leitura |
| **`31`** | `MIDI out` (Assíncrono) | `$a0` = pitch, `$a1` = ms, `$a2` = inst, `$a3` = vol | Dispara notas de acorde simultâneas sem bloquear |
| **`32`** | `Sleep` | `$a0` = ms | Executa pausas musicais e sustentação de acordes |
| **`33`** | `MIDI out synchronous` | `$a0` = pitch, `$a1` = ms, `$a2` = inst, `$a3` = vol | Toca nota melódica aguardando sua conclusão |

---

## Tabela de Referência MIDI

### Notas MIDI (C2 a C6)

| Nota | DO (`C`) | DO# / REb | RE (`D`) | RE# / MIb | MI (`E`) | FA (`F`) | FA# / SOLb | SOL (`G`) | SOL# / LAb | LA (`A`) | LA# / SIb | SI (`B`) |
| :---: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: |
| **Oitava 2** | 36 | 37 | 38 | 39 | 40 | 41 | 42 | 43 | 44 | 45 | 46 | 47 |
| **Oitava 3** | 48 | 49 | 50 | 51 | 52 | 53 | 54 | 55 | 56 | 57 | 58 | 59 |
| **Oitava 4** | **60** | 61 | 62 | 63 | 64 | 65 | 66 | 67 | 68 | 69 | 70 | 71 |
| **Oitava 5** | 72 | 73 | 74 | 75 | 76 | 77 | 78 | 79 | 80 | 81 | 82 | 83 |
| **Oitava 6** | 84 | — | — | — | — | — | — | — | — | — | — | — |

### Instrumentos General MIDI Usados no Projeto

| ID MIDI | Instrumento | Uso no Projeto |
| :---: | :--- | :--- |
| `0` | Acoustic Grand Piano | Padrão de *Ode to Joy*, *Minecraft (C418)*, *JoJo — Il Vento D'oro* e Demo de Polifonia |
| `11` | Vibraphone | Preset no seletor de timbre |
| `19` | Church Organ | Preset no seletor de timbre |
| `21` | Accordion (Sanfona) | Padrão de *Asa Branca* |
| `24` | Acoustic Guitar (Nylon) | Preset no seletor de timbre |
| `29` | Overdriven Guitar | Padrão de *DOOM (E1M1)* |
| `40` | Violin | Preset no seletor de timbre |
| `73` | Flute | Troca dinâmica (`INST 73`) no 2º verso de *Asa Branca* |
| `80` | Lead 1 (Square Wave) | Padrão de *Chiptune 8-Bit* |

---

## Arquitetura de Sub-rotinas (`sintetizador.asm`)

- `main` / `exibir_menu`: Loop interativo no console, status de timbre/log e despacho das opções `0..11`.
- `tocar_musica_catalogo`: Lê metadados da entrada do catálogo (`indice * 16`), carrega o arquivo `.txt` correspondente e invoca o interpretador.
- `tocar_arquivo_customizado`: Lê um nome de arquivo via `syscall 8`, carrega, compila e reproduz qualquer partitura `.txt`.
- `carregar_partitura_arquivo`: Abre (`13`), lê (`14`) e fecha (`16`) o arquivo `.txt`, acionando o conversor.
- `converter_texto_para_partitura` / `ler_inteiro_buffer`: Compila notação `DO..SI` (`#`/`b`, `+`, minúsculas/acentos), `PAUSA`/`P`, `INST` e `VOL` para pares `.word CODIGO, VALOR` em `buffer_partitura` terminando em `-1, 0`.
- `alternar_log_detalhado`: Alterna `log_detalhado` entre `0` (*Zero-Latency Audio*) e `1` (*Debug Console*).
- `interpretar_partitura`: Motor de execução com preservação de `$ra` e `$s0-$s4` em stack frame de `24 bytes`.
- `modo_jukebox`, `selecionar_instrumento`, `demo_polifonia`, `tocar_nota_sync`, `tocar_nota_async`, `executar_pausa`, `imprimir_detalhes_nota`: Controle de sequência, timbres, polifonia e wrappers de syscalls.
