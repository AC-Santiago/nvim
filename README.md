# Configuración Personal de Neovim

Esta es mi configuración personal de Neovim optimizada para desarrollo en Linux. Esta configuración esta basado en la configuración de NvChad junto a la modificación  de ProgrammingRainbow, solo ha sido probada en Fedora.

## Requisitos Previos

Antes de comenzar, asegúrate de tener instalado:

- Neovim (versión 0.9.0 o superior)
- Git
- Node.js y npm
- Python 3 y pip
- Compilador C (gcc/clang)
- [Nerd Font](https://www.nerdfonts.com/) instalada (recomendada: JetBrainsMono Nerd Font)
- Make
- ripgrep
- fd-find
- luarocks

### Requisitos para Jupyter y Quarto

Para usar las funcionalidades de Jupyter Notebook y Quarto:

- **uv** - Gestor de paquetes de Python (recomendado):
  ```bash
  curl -LsSf https://astral.sh/uv/install.sh | sh
  ```

- **Jupyter** - Para soporte de notebooks:
  ```bash
  uv tool install jupyter
  # O con pip: pip install jupyter
  ```

- **Quarto** - Para publicación científica y técnica:
  ```bash
  # Descargar desde https://quarto.org/docs/get-started/
  # O en Fedora:
  sudo dnf install quarto
  ```

- **pynvim** - Proveedor de Python para Neovim:
  ```bash
  uv tool install pynvim
  # O con pip: pip install pynvim
  ```

- **Opcional - Terminal con soporte de imágenes** (para visualización de gráficos):
  - Kitty (recomendado)
  - WezTerm
  - iTerm2 (macOS)

### Instalación de Dependencias en Fedora

```bash
sudo dnf install -y python3-neovim git nodejs npm python3-pip gcc make ripgrep fd-find luarocks quarto
# Instalar uv para gestión de paquetes Python
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### Instalación de Dependencias en Arch

```bash
sudo pacman -S --needed neovim python-pynvim unzip luarocks xclip wl-clipboard quarto
# Instalar uv para gestión de paquetes Python
curl -LsSf https://astral.sh/uv/install.sh | sh
```

## Instalación

1. Clona este repositorio en tu directorio de configuración de Neovim:

```bash
git clone https://github.com/AC-Santiago/nvim.git ~/.config/nvim
```

2. La primera vez que abras Neovim, el gestor de plugins Lazy.nvim se instalará automáticamente y comenzará a instalar todos los plugins configurados.

```bash
nvim
```

3. Espera a que se complete la instalación de todos los plugins.

## Características Principales

- 🤖 Integración con Copilot y Avante.nvim para asistencia de IA
- 🌳 Soporte de TreeSitter para mejor resaltado de sintaxis
- 📦 Gestor de paquetes LSP (Mason) para autocompletado y análisis de código
- 🔍 Búsqueda difusa con Telescope
- 🛠️ Depuración integrada con nvim-dap
- 🎨 Resaltado de sintaxis mejorado
- 📝 Autocompletado inteligente con nvim-cmp
- 📓 **Soporte para Jupyter Notebooks** con Molten.nvim
- 📊 **Soporte para Quarto** - Publicación científica y técnica
- 🐍 Integración con **uv** para gestión de paquetes Python

## Uso de Jupyter Notebooks y Quarto

### Configuración de un proyecto con uv

```bash
# Crear un nuevo proyecto
uv init mi-proyecto
cd mi-proyecto

# Crear entorno virtual
uv venv

# Instalar dependencias de Jupyter
uv add jupyter ipykernel

# Activar el entorno (opcional, Neovim lo detectará automáticamente)
source .venv/bin/activate
```

### Trabajar con Jupyter en Neovim

1. Abre un archivo Python o Quarto (.qmd)
2. Inicializa Molten: `<leader>mi`
3. Ejecuta código:
   - `<leader>ml` - Ejecutar línea actual
   - `<leader>mv` - Ejecutar selección visual
   - `<leader>me` - Ejecutar operador
4. Ver resultados: `<leader>mo`
5. Navegación entre celdas: `]c` (siguiente), `[c` (anterior)

### Crear documentos Quarto

```bash
# Crear un nuevo documento Quarto
nvim documento.qmd
```

En el documento `.qmd`, puedes mezclar Markdown con bloques de código ejecutables:

````markdown
---
title: "Mi Análisis"
format: html
---

## Introducción

Este es un documento Quarto.

```{python}
import pandas as pd
import matplotlib.pyplot as plt

# Tu código aquí
```
````

Para renderizar el documento:
```bash
quarto render documento.qmd
```

## Atajos de Teclado

Para ver una lista completa de todos los atajos de teclado disponibles, consulta [KEYBINDINGS.md](KEYBINDINGS.md).

### Atajos Generales
- `<Space>` es la tecla líder
- `<leader>ac` - Iniciar chat con IA
- `<leader>ff` - Buscar archivos

### Atajos para Jupyter/Molten
- `<leader>mi` - Inicializar Molten (kernel de Jupyter)
- `<leader>ml` - Ejecutar línea actual
- `<leader>mv` - Ejecutar selección visual
- `<leader>me` - Ejecutar con operador
- `<leader>mr` - Re-ejecutar celda
- `<leader>mo` - Mostrar salida
- `<leader>mh` - Ocultar salida
- `<leader>md` - Eliminar celda
- `]c` - Ir a la siguiente celda
- `[c` - Ir a la celda anterior

## Personalización

Puedes personalizar la configuración editando los archivos en `~/.config/nvim/lua/`:

- `chadrc.lua` - Configuraciones visuales
- `options.lua` - Configuraciones generales de Neovim
- `mappings.lua` - Atajos de teclado personalizados
- `plugins/` - Configuraciones específicas o sencillas de plugins
- `configs/` - Configuraciones adicionales de los plugins

## Estructura del Proyecto

```
~/.config/nvim/
├── init.lua
├── lazy-lock.json
├── LICENSE
├── lua
│   ├── chadrc.lua
│   ├── configs
│   │   ├── conform.lua
│   │   ├── DAP
│   │   │   ├── init.lua
│   │   │   └── lang
│   │   │       ├── python.lua
│   │   │       └── ...
│   │   ├── lazy.lua
│   │   └── ...
│   ├── custom
│   │   └── configs
│   │       └── ...
│   ├── mappings.lua
│   ├── options.lua
│   └── plugins
│       ├── init.lua
│       └── ...
└── README.md
```

## Solución de Problemas

Si encuentras algún problema:

1. Actualiza Neovim a la última versión
2. Elimina la caché de plugins: `rm -rf ~/.local/share/nvim/`
3. Actualiza todos los plugins dentro de Neovim: `:Lazy sync`

## Contribuciones

Las contribuciones son bienvenidas. Por favor, siente libre de hacer un fork y enviar pull requests.
