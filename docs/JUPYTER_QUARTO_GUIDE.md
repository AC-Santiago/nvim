# Guía de Jupyter y Quarto en Neovim

Esta guía te ayudará a configurar y usar Jupyter Notebooks y Quarto en tu configuración de Neovim.

## Tabla de Contenidos

1. [Requisitos](#requisitos)
2. [Configuración Inicial](#configuración-inicial)
3. [Uso de Jupyter con Molten](#uso-de-jupyter-con-molten)
4. [Uso de Quarto](#uso-de-quarto)
5. [Atajos de Teclado](#atajos-de-teclado)
6. [Solución de Problemas](#solución-de-problemas)

## Requisitos

### Instalación de uv (recomendado)

[uv](https://github.com/astral-sh/uv) es un gestor de paquetes Python ultrarrápido escrito en Rust:

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### Instalación de Dependencias

```bash
# Con uv (recomendado)
uv tool install jupyter
uv tool install pynvim
uv tool install ipykernel

# O con pip tradicional
pip install jupyter pynvim ipykernel
```

### Instalación de Quarto

Descarga e instala desde [quarto.org](https://quarto.org/docs/get-started/):

```bash
# Fedora
sudo dnf install quarto

# Ubuntu/Debian
sudo apt-get install quarto

# Arch Linux
yay -S quarto-cli
```

### Terminal con soporte de imágenes (Opcional)

Para visualizar gráficos y imágenes directamente en Neovim:

- **Kitty** (recomendado): `sudo dnf install kitty` o `sudo apt install kitty`
- **WezTerm**: Descarga desde [wezfurlong.org/wezterm](https://wezfurlong.org/wezterm/)
- **iTerm2** (macOS): Descarga desde [iterm2.com](https://iterm2.com/)

## Configuración Inicial

### 1. Crear un proyecto con uv

```bash
# Crear directorio del proyecto
mkdir mi-proyecto
cd mi-proyecto

# Inicializar proyecto con uv
uv init

# Crear entorno virtual
uv venv

# Agregar dependencias
uv add jupyter pandas numpy matplotlib seaborn scikit-learn
```

Neovim detectará automáticamente el entorno virtual en `.venv/`.

### 2. Configuración alternativa con venv tradicional

```bash
python -m venv .venv
source .venv/bin/activate  # Linux/Mac
# o
.venv\Scripts\activate  # Windows

pip install jupyter pandas numpy matplotlib
```

## Uso de Jupyter con Molten

### Workflow básico

1. **Abrir un archivo Python**:
   ```bash
   nvim mi_script.py
   ```

2. **Inicializar el kernel de Jupyter**:
   - Presiona `<leader>mi` (normalmente `<Space>mi`)
   - Selecciona el kernel deseado (ej: `python3`)

3. **Escribir y ejecutar código**:
   ```python
   import pandas as pd
   import numpy as np
   
   # Crear un DataFrame
   df = pd.DataFrame({
       'A': np.random.randn(10),
       'B': np.random.randn(10)
   })
   
   print(df.head())
   ```

4. **Ejecutar código**:
   - Línea actual: `<leader>ml`
   - Selección visual: Selecciona el código en modo visual y presiona `<leader>mv`
   - Operador: `<leader>me` seguido de un movimiento

5. **Ver resultados**:
   - Mostrar salida: `<leader>mo`
   - Ocultar salida: `<leader>mh`

### Navegación entre celdas

Molten trata los comentarios `# %%` como delimitadores de celdas:

```python
# %% Celda 1: Importaciones
import pandas as pd
import numpy as np

# %% Celda 2: Cargar datos
df = pd.read_csv('datos.csv')

# %% Celda 3: Análisis
print(df.describe())
```

- Siguiente celda: `]c`
- Celda anterior: `[c`
- Re-ejecutar celda: `<leader>mr`

## Uso de Quarto

### Crear un documento Quarto

```bash
nvim documento.qmd
```

### Estructura básica de un documento .qmd

```markdown
---
title: "Mi Análisis"
author: "Tu Nombre"
format: 
  html:
    code-fold: true
    toc: true
jupyter: python3
---

## Introducción

Texto en Markdown...

## Código Python

```{python}
import pandas as pd

# Tu código aquí
df = pd.read_csv('datos.csv')
print(df.head())
```

## Visualización

```{python}
#| label: fig-plot
#| fig-cap: "Mi gráfico"

import matplotlib.pyplot as plt
plt.plot(df['columna'])
plt.show()
```
```

### Opciones de bloques de código

Quarto soporta muchas opciones para personalizar bloques:

```markdown
```{python}
#| echo: false      # No mostrar código
#| eval: true       # Ejecutar código
#| warning: false   # Ocultar advertencias
#| label: fig-1     # Etiqueta para referencias
#| fig-cap: "..."   # Leyenda de figura

# Tu código aquí
```
```

### Renderizar documentos

Desde la terminal:

```bash
# Renderizar a HTML
quarto render documento.qmd

# Renderizar a PDF
quarto render documento.qmd --to pdf

# Preview con recarga automática
quarto preview documento.qmd
```

### LSP y autocompletado

El LSP de Quarto proporciona:
- Autocompletado de código Python/R dentro de bloques
- Verificación de sintaxis
- Hover documentation (presiona `K` sobre una función)
- Ir a definición: `gd`
- Buscar referencias: `gr`

## Atajos de Teclado

### Molten (Jupyter)

| Atajo | Acción |
|-------|--------|
| `<leader>mi` | Inicializar kernel de Jupyter |
| `<leader>ml` | Ejecutar línea actual |
| `<leader>mv` | Ejecutar selección visual |
| `<leader>me` | Ejecutar con operador |
| `<leader>mr` | Re-ejecutar celda actual |
| `<leader>mo` | Mostrar salida |
| `<leader>mh` | Ocultar salida |
| `<leader>md` | Eliminar celda |
| `]c` | Ir a la siguiente celda |
| `[c` | Ir a la celda anterior |

### Quarto LSP

| Atajo | Acción |
|-------|--------|
| `K` | Mostrar documentación |
| `gd` | Ir a definición |
| `gr` | Buscar referencias |
| `<leader>rn` | Renombrar símbolo |
| `<leader>fm` | Formatear documento |

## Solución de Problemas

### El kernel no se inicia

1. Verifica que Jupyter esté instalado:
   ```bash
   jupyter --version
   ```

2. Verifica que pynvim esté instalado:
   ```bash
   python -m pip show pynvim
   ```

3. Reinicia Neovim y ejecuta:
   ```vim
   :UpdateRemotePlugins
   ```

### Las imágenes no se muestran

1. Verifica que estés usando un terminal con soporte de imágenes (Kitty, WezTerm, iTerm2)

2. Verifica la configuración de image.nvim en `lua/plugins/image.lua`:
   ```lua
   vim.g.molten_image_provider = "image.nvim"
   ```

### El LSP de Quarto no funciona

1. Verifica que Quarto esté instalado:
   ```bash
   quarto check
   ```

2. Instala el servidor LSP de Quarto:
   ```bash
   # Se instalará automáticamente con Mason
   # O manualmente:
   npm install -g @quarto/quarto-lsp
   ```

3. Verifica que el lenguaje Quarto esté habilitado en `lua/configs/languages.lua`:
   ```lua
   quarto = true,
   ```

### Problemas con uv y detección de entornos virtuales

1. Asegúrate de que el entorno virtual esté en `.venv/` en la raíz del proyecto

2. Si usas otro nombre, actualiza `init.lua`:
   ```lua
   local uv_venv = vim.fn.getcwd() .. "/tu-nombre-venv/bin/python"
   ```

3. Verifica que Python encuentre los paquetes:
   ```bash
   uv run python -c "import jupyter; print(jupyter.__version__)"
   ```

## Ejemplos Avanzados

### Ejecutar código de forma interactiva

```python
# %% Importar librerías
import pandas as pd
import matplotlib.pyplot as plt

# %% Cargar datos
df = pd.read_csv('datos.csv')

# %% Explorar datos
df.info()
df.describe()

# %% Visualizar
plt.figure(figsize=(10, 6))
plt.hist(df['columna'])
plt.show()
```

### Documento Quarto con múltiples lenguajes

```markdown
---
title: "Análisis Multi-lenguaje"
format: html
---

## Python

```{python}
import pandas as pd
df = pd.DataFrame({'x': [1, 2, 3]})
```

## Bash

```{bash}
ls -la | head -n 5
```

## Lua

```{lua}
print("Hola desde Lua")
```
```

## Recursos Adicionales

- [Documentación de Quarto](https://quarto.org/)
- [Molten.nvim GitHub](https://github.com/benlubas/molten-nvim)
- [Guía de uv](https://docs.astral.sh/uv/)
- [Jupyter Documentation](https://jupyter.org/documentation)
- [Referencia de jmbuhr/nvim-config](https://github.com/jmbuhr/nvim-config)
