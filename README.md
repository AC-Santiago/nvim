# Configuración Personal de Neovim

Esta es mi configuración personal de Neovim optimizada para desarrollo en Linux.

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

### Instalación de Dependencias en Fedora

```bash
sudo dnf install -y neovim git nodejs npm python3-pip gcc make ripgrep fd-find

## Instalación

1. Clona este repositorio en tu directorio de configuración de Neovim:

```bash
git clone https://github.com/TU_USUARIO/nvim-config.git ~/.config/nvim
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

## Atajos de Teclado Principales

### General
- `<Space>` es la tecla líder

### IA Assistant (Avante)
- `<leader>ac` - Iniciar chat con IA
- `<leader>ae` - Editar con IA
- `<leader>ai` - Chat en línea con IA
- `<leader>ax` - Explicar código con IA

## Personalización

Puedes personalizar la configuración editando los archivos en `~/.config/nvim/lua/`:

- `options.lua` - Configuraciones generales de Neovim
- `mappings.lua` - Atajos de teclado personalizados
- `plugins/` - Configuraciones específicas de plugins

## Estructura del Proyecto

```
~/.config/nvim/
├── init.lua
├── lua/
│   ├── options.lua
│   ├── mappings.lua
│   └── plugins/
│       ├── avante.lua
│       └── ...
```

## Solución de Problemas

Si encuentras algún problema:

1. Actualiza Neovim a la última versión
2. Elimina la caché de plugins: `rm -rf ~/.local/share/nvim/`
3. Actualiza todos los plugins dentro de Neovim: `:Lazy sync`

## Contribuciones

Las contribuciones son bienvenidas. Por favor, siente libre de hacer un fork y enviar pull requests.

## Licencia

Este proyecto está bajo la licencia MIT.
