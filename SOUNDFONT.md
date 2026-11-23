# Guia Passo a Passo: Melhorando o Áudio do MARS com SoundFont HD (`.sf2`)

Este guia mostra como substituir o banco de som padrão do Java usado pelo simulador **MARS 4.5** por um **SoundFont (`.sf2`)** de alta qualidade, melhorando drasticamente os timbres de Piano (*JoJo*, *Minecraft C418*, *Ode to Joy*), Guitarra (*DOOM E1M1*), Sanfona (*Asa Branca*) e Sintetizador (*Chiptune*).

---

## 1. Por que o som padrão do MARS parece simples?

As syscalls MIDI do MARS (`31` e `33`) utilizam internamente o sintetizador MIDI nativo do Java (**Gervill**). Por padrão, o Java carrega um banco de som de emergência muito pequeno (~1,8 MB) chamado `soundbank-emg.sf2`, cujos samples são simples e têm ataque lento na guitarra distorcida e pouco corpo no piano.

Felizmente, o sintetizador **Gervill** procura automaticamente por um arquivo personalizado chamado `soundbank-emg.sf2` na pasta `.gervill` do seu usuário — permitindo trocar todos os 128 instrumentos General MIDI **sem modificar o `Mars4_5.jar`**.

---

## 2. SoundFonts (`.sf2`) Gratuitos Recomendados

Escolha um dos arquivos `.sf2` abaixo de acordo com o estilo desejado:

| SoundFont | Tamanho Aprox. | Destaque |
| :--- | :---: | :--- |
| **GeneralUser GS** | ~30 MB | **Melhor equilíbrio geral.** Ótimo Piano para *JoJo* e *Minecraft C418*, boas guitarras, sanfona e baixo latência. |
| **Roland SC-55 SoundFont** | ~15–35 MB | **Fidelidade retrô.** Emula o módulo Roland Sound Canvas SC-55 usado na composição original de **DOOM (1993)**. |
| **FluidR3_GM** | ~140 MB | **Timbres encorpados de estúdio.** Excelente para Piano acústico, Flauta e Violão. |

---

## 3. Método 1 — Automático com `iniciar_mars_hd.bat` (Recomendado no Windows)

O script [`iniciar_mars_hd.bat`](iniciar_mars_hd.bat) faz toda a configuração sozinho e ainda garante que o MARS abra no diretório correto para ler os arquivos `.txt` (`ode_to_joy.txt`, `doom.txt`, `jojo.txt`, etc.).

1. Baixe o arquivo `.sf2` escolhido (ex.: `GeneralUser_GS.sf2`).
2. Coloque o arquivo `.sf2` **dentro da pasta raiz deste projeto** (`sintetizador/`).
3. Dê **dois cliques** em `iniciar_mars_hd.bat` (ou execute `.\iniciar_mars_hd.bat` no terminal).
4. O script irá:
   - Fixar o diretório de trabalho na pasta do projeto (`cd /d "%~dp0"`).
   - Criar `%USERPROFILE%\.gervill` e copiar o seu `.sf2` para `%USERPROFILE%\.gervill\soundbank-emg.sf2`.
   - Localizar automaticamente o `Mars4_5.jar` (na pasta do projeto, `Downloads` ou `Desktop` — ou pedir o caminho caso esteja em outro lugar).
   - Abrir o MARS já com `sintetizador.asm` carregado.
5. No MARS, pressione **`F3`** (Assemble) e **`F5`** (Go).

---

## 4. Método 2 — Instalação Manual no Java Gervill

Caso prefira configurar manualmente (ou esteja usando Linux / macOS):

### Windows (PowerShell)
```powershell
New-Item -ItemType Directory -Force "$env:USERPROFILE\.gervill"
Copy-Item "C:\caminho\para\seu_soundfont.sf2" "$env:USERPROFILE\.gervill\soundbank-emg.sf2"
```

### Windows (Prompt de Comando / CMD)
```bat
mkdir "%USERPROFILE%\.gervill"
copy "C:\caminho\para\seu_soundfont.sf2" "%USERPROFILE%\.gervill\soundbank-emg.sf2"
```

### Linux / macOS
```bash
mkdir -p ~/.gervill
cp /caminho/para/seu_soundfont.sf2 ~/.gervill/soundbank-emg.sf2
```

> **Como voltar ao som original do Java:** Basta apagar ou renomear o arquivo `soundbank-emg.sf2` dentro da pasta `.gervill`.

*(Nota: Em versões específicas de JDK onde `.gervill` não for lido automaticamente, copie também o `soundbank-emg.sf2` para `<JAVA_HOME>\lib\audio\soundbank-emg.sf2`.)*

---

## 5. Método 3 — Alternativas Avançadas

### A. Driver MIDI Externo no Windows (*CoolSoft VirtualMIDISynth*)
1. Instale o **CoolSoft VirtualMIDISynth**.
2. Adicione um ou mais arquivos `.sf2` na interface do programa e aplique.
3. Defina o *VirtualMIDISynth* como dispositivo MIDI padrão do Windows.
4. Isso libera polifonia estendida, *reverb* e *chorus* dedicados fora da JVM.

### B. Patch Direto no Código-Fonte do MARS (`ToneGenerator.java`)
Se você optar por recompilar o `Mars4_5.jar`, o ponto exato de inicialização do sintetizador MIDI fica em `mars/mips/instructions/syscalls/ToneGenerator.java`. Após `synth.open()`, basta carregar explicitamente seu arquivo `.sf2`:

```java
synth.loadAllInstruments(MidiSystem.getSoundbank(new File("seu_banco.sf2")));
```

---

## 6. Dica Extra no Próprio Sintetizador

Lembre-se de manter a opção **`[10]` Log Detalhado de Notas** em **`OFF`** (padrão). Com o log desligado (*Zero-Latency Audio*), o MARS dispara acordes e riffs rápidos sem o atraso de ~20–45 ms causado pela impressão de texto no console Swing.
