# Atajos de Teclado (Keybindings)

Esta documentación recopila todos los atajos de teclado configurados en el entorno de Neovim.

## General y Edición

| Atajo | Modo | Descripción |
|-------|------|-------------|
| `<Space>` | Normal | Tecla Líder (Leader Key) |
| `\` | Normal | Tecla Local Leader |
| `;` | Normal | Entrar en modo comando (`:`) |
| `jk` | Insert | Salir a modo Normal (`<ESC>`) |
| `<Esc>` | Normal | Limpiar resaltados (`:noh`) |
| `<C-s>` | Normal | Guardar archivo |
| `<C-c>` | Normal | Copiar todo el archivo |
| `<leader>n` | Normal | Alternar números de línea |
| `<leader>rn` | Normal | Alternar números relativos |
| `zR` | Normal/Visual | Abrir todos los folds |
| `zM` | Normal/Visual | Cerrar todos los folds |
| `<leader>wK` | Normal | Mostrar todos los keymaps (WhichKey) |
| `<leader>wk` | Normal | Consultar atajo específico |

### Movimiento en Insert Mode

| Atajo | Modo | Descripción |
|-------|------|-------------|
| `<C-b>` | Insert | Ir al inicio de línea |
| `<C-e>` | Insert | Ir al final de línea |
| `<C-h>` | Insert | Mover izquierda |
| `<C-l>` | Insert | Mover derecha |
| `<C-j>` | Insert | Mover abajo |
| `<C-k>` | Insert | Mover arriba |

## Gestión de Ventanas y Buffers

| Atajo | Modo | Descripción |
|-------|------|-------------|
| `<C-h>` | Normal | Foco a ventana izquierda |
| `<C-l>` | Normal | Foco a ventana derecha |
| `<C-j>` | Normal | Foco a ventana abajo |
| `<C-k>` | Normal | Foco a ventana arriba |
| `<leader>b` | Normal | Nuevo buffer |
| `<Tab>` | Normal | Buffer siguiente |
| `<S-Tab>` | Normal | Buffer anterior |
| `<leader>x` | Normal | Cerrar buffer actual |

## Exploradores de Archivos

| Atajo | Modo | Descripción |
|-------|------|-------------|
| `<C-n>` | Normal | Toggle NvimTree |
| `<leader>e` | Normal | Focus NvimTree |
| `-` | Normal | Abrir directorio padre (Oil) |
| `<localleader>e` | Normal | Toggle Neo-tree |

## Búsqueda (Telescope)

| Atajo | Modo | Descripción |
|-------|------|-------------|
| `<leader>ff` | Normal | Buscar archivos |
| `<leader>fa` | Normal | Buscar todos los archivos (incl. ocultos) |
| `<leader>fw` | Normal | Búsqueda de texto en vivo (Live Grep) |
| `<leader>fb` | Normal | Buscar buffers abiertos |
| `<leader>fh` | Normal | Buscar ayuda (help tags) |
| `<leader>fo` | Normal | Archivos recientes (oldfiles) |
| `<leader>fz` | Normal | Buscar en buffer actual |
| `<leader>cm` | Normal | Commits de Git |
| `<leader>gt` | Normal | Estado de Git |
| `<leader>th` | Normal | Temas de NvChad |
| `<leader>fp` | Normal | Buscar archivos de Plugins |
| `<leader>fc` | Normal | Buscar archivos de Configuración |

## Código y LSP

| Atajo | Modo | Descripción |
|-------|------|-------------|
| `<leader>fm` | Normal | Formatear archivo |
| `<leader>/` | Normal/Visual | Comentar/Descomentar línea(s) |
| `<leader>ds` | Normal | Diagnósticos (Loclist) |
| `<leader>ca` | Normal/Visual | Acciones de código (Code Action) |
| `gr` | Normal | Referencias |
| `gi` | Normal | Implementación |
| `<leader>sh` | Normal | Ayuda de firma (Signature Help) |
| `<leader>ih` | Normal | Toggle Inlay Hints |

## Git

| Atajo | Modo | Descripción |
|-------|------|-------------|
| `<leader>lg` | Normal | Abrir LazyGit |
| `<leader>ga` | Normal | Git fetch all |
| `<leader>gl` | Normal | Git pull |

## Debugging (DAP)

| Atajo | Modo | Descripción |
|-------|------|-------------|
| `<localleader>db` | Normal | Toggle Breakpoint |
| `<localleader>dB` | Normal | Breakpoint condicional |
| `<localleader>dc` | Normal | Continuar (Continue) |
| `<localleader>di` | Normal | Step Into |
| `<localleader>do` | Normal | Step Out |
| `<localleader>dO` | Normal | Step Over |
| `<localleader>dt` | Normal | Terminar sesión |
| `<localleader>dr` | Normal | Toggle REPL |
| `<localleader>dw` | Normal | Widgets hover |

## Terminal

| Atajo | Modo | Descripción |
|-------|------|-------------|
| `<C-x>` | Terminal | Escapar modo terminal |
| `<leader>h` | Normal | Nueva terminal horizontal |
| `<leader>v` | Normal | Nueva terminal vertical |
| `<A-v>` | Normal/Term | Toggle terminal vertical |
| `<A-h>` | Normal/Term | Toggle terminal horizontal |
| `<A-i>` | Normal/Term | Toggle terminal flotante |

## Data Science (Molten & Quarto)

### Molten (Jupyter)

| Atajo | Modo | Descripción |
|-------|------|-------------|
| `<leader>mi` | Normal | Inicializar Molten |
| `<leader>me` | Normal | Evaluar operador |
| `<leader>ml` | Normal | Evaluar línea |
| `<leader>mv` | Visual | Evaluar selección visual |
| `<leader>mr` | Normal | Re-evaluar celda |
| `<leader>mo` | Normal | Mostrar output |
| `<leader>mh` | Normal | Ocultar output |
| `<leader>md` | Normal | Borrar celda |
| `]c` | Normal | Siguiente celda |
| `[c` | Normal | Celda anterior |

### Quarto

| Atajo | Modo | Descripción |
|-------|------|-------------|
| `<localleader>qp` | Normal | Quarto Preview |
| `<localleader>qq` | Normal | Quarto Close Preview |
| `<localleader>rc` | Normal | Run Cell |
| `<localleader>ra` | Normal | Run Cell and Above |

## Notas (Obsidian & Telekasten)

### Obsidian

| Atajo | Modo | Descripción |
|-------|------|-------------|
| `<leader>on` | Normal | Nueva nota |
| `<leader>oo` | Normal | Abrir en app Obsidian |
| `<leader>os` | Normal | Buscar notas |
| `<leader>oc` | Normal | Toggle checkbox |
| `<leader>ot` | Normal | Nota de hoy (Daily) |
| `<leader>op` | Normal | Pegar imagen |
| `<leader>oT` | Normal | Insertar template |

### Telekasten

| Atajo | Modo | Descripción |
|-------|------|-------------|
| `<leader>zz` | Normal | Panel principal |
| `<leader>zf` | Normal | Buscar notas |
| `<leader>zn` | Normal | Nueva nota |
| `<leader>zd` | Normal | Daily notes |

## Bases de Datos (DBee)

| Atajo | Modo | Descripción |
|-------|------|-------------|
| `<leader>db` | Normal | Toggle DBee |
| `<leader>do` | Normal | Abrir DBee |
| `<leader>de` | Normal | Ejecutar Query |
| `<leader>dn` | Normal | Página siguiente (Resultados) |
| `<leader>dp` | Normal | Página anterior (Resultados) |

## IA (Copilot Chat)

| Atajo | Modo | Descripción |
|-------|------|-------------|
| `<leader>cc` | Normal | Abrir Chat |
| `<leader>ce` | Normal/Visual | Explicar código |
| `<leader>ct` | Normal/Visual | Generar tests |
| `<leader>cr` | Normal/Visual | Revisar código |
| `<leader>cf` | Normal/Visual | Arreglar código |
| `<leader>cd` | Normal/Visual | Generar documentación |

## Utilidades Varias

| Atajo | Modo | Descripción |
|-------|------|-------------|
| `<leader>cp` | Normal | Selector de Color (Minty) |
| `<localleader>cp`| Normal | Guardar color (Minty) |
| `<localleader>p` | Normal | Pegar imagen del portapapeles |
| `<leader>snl` | Normal | Noice: Último mensaje |
| `<leader>snh` | Normal | Noice: Historial |
| `<leader>snd` | Normal | Noice: Descartar todo |

