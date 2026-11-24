# Roteiro de apresentação: Sintetizador MIDI em Assembly MIPS

Duração estimada: 8 a 10 minutos (cerca de 3 minutos por integrante).
Foco: arquitetura, decisões de projeto e funcionamento das partes centrais de `sintetizador.asm`, sem leitura linha a linha do código.

---

## Slide 1: Capa

**Guilherme Cezarino:**
Bom dia a todos. Nosso projeto para Arquitetura de Computadores II é a Máquina de Música, um sintetizador e interpretador de partituras desenvolvido em Assembly MIPS. Dividimos a apresentação em três partes: eu começo apresentando o que o sistema faz, a motivação da arquitetura e a leitura dos arquivos. Em seguida, Gabriel Eduardo mostra como o texto da partitura é compilado na memória. Por fim, Felipe Guedes explica o motor de execução MIDI, a polifonia e os ajustes de latência e qualidade sonora.

---

## Slide 2: O que é o projeto

Na prática, o `sintetizador.asm` é uma aplicação interativa com 1.306 linhas que lê partituras musicais escritas em arquivos de texto, traduz essas notas para o padrão MIDI e toca melodias e acordes polifônicos em tempo real.

O sistema já traz seis faixas prontas no catálogo: Ode to Joy (Beethoven), Tema Clássico Arcade (Chiptune 8-Bit), Asa Branca (Luiz Gonzaga), At Doom's Gate (DOOM E1M1), Sweden (Minecraft / C418) e Il Vento D'oro (JoJo), além de um modo Jukebox que toca todas em sequência e uma opção para carregar qualquer arquivo `.txt` criado pelo usuário.

Como dá para ver no trecho de `asa_branca.txt`, a notação fica em português (`DO`, `RE`, `MI`, `FA`, `SOL`, `LA`, `SI`), com suporte a sustenidos, bemóis, pausas, acordes com o prefixo `+` e troca de instrumento ou volume no meio da música, como `INST 73` para mudar da sanfona para a flauta no segundo verso.

---

## Slide 3: Motivação e arquitetura do sistema

Agora que vimos o que o programa faz, vale explicar por que ele foi estruturado dessa forma. Quem já tentou programar música em Assembly MIPS sabe que o caminho mais comum é declarar dezenas de vetores com números MIDI direto na seção `.data`. O problema desse modelo é que qualquer ajuste em uma música exige editar o código-fonte e montar o programa novamente.

Ao mover as partituras para arquivos `.txt` externos, o Assembly passa a funcionar como um interpretador genérico reutilizável em três etapas:
1. O programa lê o arquivo `.txt` escolhido pelo usuário.
2. Um compilador interno converte esse texto para eventos numéricos em memória.
3. O motor de execução percorre esses eventos e aciona as chamadas de áudio do sistema.

---

## Slide 4: Leitura de arquivos e catálogo

Passando para a parte de entrada de dados, a sub-rotina `carregar_partitura_arquivo` usa três chamadas de sistema padrão:
- A `syscall 13` abre o arquivo em modo de leitura e devolve o descritor em `$v0`. Se o arquivo não existir no diretório de trabalho, o retorno é negativo e o programa exibe uma mensagem de erro orientando o usuário.
- A `syscall 14` lê até 16.383 bytes para dentro do `buffer_arquivo`. Deixamos 1 byte de folga no buffer de 16 KB para gravar manualmente o terminador nulo (`0`) logo após o último byte lido, garantindo que o parser saiba onde o texto termina.
- Logo em seguida, a `syscall 16` fecha o descritor do arquivo.

No caso da opção 8, em que o usuário digita o nome de uma partitura própria, a rotina `tocar_arquivo_customizado` lê o texto via `syscall 8` e percorre a string para remover caracteres de quebra de linha (`\n` e `\r`) antes de tentar abrir o arquivo.

Já as seis músicas principais ficam indexadas em `catalogo_musicas`. Cada entrada ocupa 16 bytes na memória, divididos em quatro palavras: o ponteiro para o título exibido na tela, o instrumento MIDI inicial, o volume inicial e o ponteiro para o nome do arquivo `.txt`. Quando o usuário escolhe uma opção de 1 a 6, o código apenas multiplica o índice por 16 para localizar os metadados da faixa.

Passo a palavra para o Gabriel Eduardo, que vai explicar como o texto lido vira informação executável.

---

## Slide 5: Compilação das partituras em tempo de execução

**Gabriel Eduardo:**
Obrigado, Guilherme. Com o texto já carregado em `buffer_arquivo`, entra em ação a sub-rotina `converter_texto_para_partitura`. Ela funciona como um compilador simples de uma passada só.

Primeiro, o parser percorre os caracteres ignorando espaços, tabulações, quebras de linha e comentários iniciados por `#`. Quando encontra um comando válido, ele identifica se a linha começa com `+`, que marca uma nota assíncrona de acorde, e depois lê o nome da nota ou a palavra-chave (`PAUSA`, `INST` ou `VOL`).

Um cuidado que tivemos foi tornar a notação tolerante à escrita. O código aceita letras maiúsculas, minúsculas e até vogais acentuadas em UTF-8, como `dó4` ou `fá#4`. Para isso, ele converte os caracteres ASCII para maiúsculo e pula os bytes extras da acentuação na hora de avançar o cursor.

Depois de identificar o semitom base da nota (de `0` para Dó até `11` para Si), o parser verifica se há acidente: `#` soma 1 ao semitom e `b` subtrai 1. Em seguida, lê a oitava entre `0` e `8`, usando a oitava `4` como padrão se ela for omitida. A conversão para o padrão MIDI usa a fórmula:

`(oitava + 1) * 12 + semitom`

O resultado passa por uma verificação de limites entre `0` e `127`. Por fim, a função auxiliar `ler_inteiro_buffer` extrai a duração em milissegundos.

---

## Slide 6: Modelo de memória intermediário

Em vez de interpretar texto durante a reprodução, o que seria lento e causaria atrasos no ritmo, o compilador grava tudo em uma representação binária compacta dentro de `buffer_partitura`.

Reservamos 4.096 bytes para esse buffer. Cada evento ocupa exatamente 8 bytes, formados por dois inteiros de 32 bits: `CODIGO` e `VALOR`. Isso permite armazenar até 510 eventos por música, encerrados sempre pelo par sentinela `-1, 0`.

A tabela mostra como o `CODIGO` diferencia cada ação:
- Valores de `0` a `127` representam uma nota síncrona comum, e o `VALOR` guarda a duração em milissegundos.
- Valores a partir de `1000` (`1000 + pitch`) indicam notas assíncronas, geradas quando a partitura tem o prefixo `+`.
- O código `-2` representa uma pausa musical.
- O código `-3` altera o instrumento ativo naquele ponto da música.
- O código `-4` altera o volume ativo.

Esse formato deixa o motor de execução bem direto, porque ele só precisa comparar inteiros em registradores. Agora o Felipe Guedes mostra como esse buffer é reproduzido.

---

## Slide 7: Motor de execução e polifonia

**Felipe Guedes:**
Obrigado, Gabriel. A sub-rotina `interpretar_partitura` é o coração da reprodução. Logo na entrada, ela aloca um stack frame de 24 bytes na pilha para salvar o endereço de retorno `$ra` e os registradores `$s0` a `$s4`.

Dentro do loop principal, `$s0` funciona como o ponteiro do evento atual, avançando 8 bytes por ciclo. Os registradores `$s1` e `$s2` mantêm, respectivamente, o instrumento e o volume ativos, que podem ser alterados dinamicamente quando o loop encontra os códigos `-3` e `-4` (respeitando o override global caso o usuário tenha fixado um timbre no menu).

O ponto mais interessante dessa etapa é a polifonia. A `syscall 33` toca uma nota de forma síncrona, ou seja, o programa fica parado esperando a duração da nota terminar. Já a `syscall 31` é assíncrona: ela envia o comando MIDI e retorna imediatamente para a próxima instrução.

Para tocar um acorde ou separar acompanhamento e melodia, fazemos como no trecho de `minecraft.txt` exibido no slide: definimos um volume mais baixo (`VOL 62`), disparamos as notas graves com `+` usando a `syscall 31`, subimos o volume (`VOL 104`) e tocamos a melodia principal com a `syscall 33`. Como as notas graves têm duração de 1.900 ms e não bloqueiam o processador, elas continuam soando por baixo enquanto a melodia avança.

---

## Slide 8: Latência zero e qualidade sonora

Durante os testes de faixas rápidas como *DOOM* e *JoJo*, percebemos um gargalo prático: sempre que o programa imprimia o log de cada nota no console (`syscall 4` e `syscall 1`), a interface gráfica introduzia um atraso entre 20 e 45 milissegundos por evento. Esse atraso quebrava o tempo das notas e dessincronizava os acordes.

Para corrigir isso, criamos a flag `log_detalhado` iniciando em `0`, que chamamos de modo *Zero-Latency Audio*. Com o log desligado, o loop vai direto para as syscalls MIDI sem tocar no console de texto. Se alguém quiser inspecionar pitch e duração durante uma apresentação ou depuração, basta alternar a opção 10 no menu.

Outro limite que encontramos foi o banco de som padrão. As syscalls MIDI usam o sintetizador nativo do Java, o Gervill, que carrega um banco de emergência de apenas 1,8 MB (`soundbank-emg.sf2`). Sem alterar o ambiente de execução, descobrimos que o Gervill procura automaticamente um arquivo com esse mesmo nome na pasta `.gervill` do usuário.

Por isso incluímos um script de inicialização e o guia `SOUNDFONT.md`. Se houver um SoundFont `.sf2` de qualidade na pasta do projeto, como o GeneralUser GS ou o Roland SC-55, o script instala esse banco automaticamente para o Java e garante o diretório correto para localizar os arquivos `.txt`.

---

## Encerramento e demonstração ao vivo

Para encerrar, vamos fazer uma demonstração rápida do sistema rodando:
1. Montamos e executamos o `sintetizador.asm` na pasta do projeto.
2. Rodamos a opção 11 para ouvir a progressão de acordes com quatro vozes simultâneas, mostrando na prática a combinação das syscalls 31 e 32.
3. Selecionamos uma faixa do catálogo, como *Asa Branca*, para mostrar a troca automática de sanfona para flauta no segundo verso via `INST 73`, e em seguida um trecho de *At Doom's Gate* para evidenciar o ritmo estável sem latência de console.

Ficamos à disposição para perguntas. Obrigado.
