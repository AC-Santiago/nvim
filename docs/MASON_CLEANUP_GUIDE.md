# Limpieza manual de paquetes de Mason

Al iniciar Neovim, se crea el archivo `nvim_language_state.json` si falta en el directorio de datos de Neovim. Guarda los perfiles habilitados, la fecha y la versión de Neovim. El inicio, el guardado de archivos y los cambios en los perfiles conservan los paquetes instalados y cualquier línea base existente.

## Revisar y ejecutar una limpieza

1. Deshabilita el perfil, por ejemplo `sql`, en la configuración y reinicia Neovim. [Perfiles de lenguaje](../lua/configs/languages.lua)
2. Consulta la línea base y los perfiles deshabilitados.

   ```vim
   :lua vim.print(require('utils.lang_loader').get_state_info())
   ```

3. Ejecuta la limpieza manual.

   ```vim
   :lua require('utils.lang_loader').manual_cleanup()
   ```

   Si `sql` estaba habilitado en la línea base, pueden aparecer `sql-formatter` y `sqlls` cuando estén instalados y ningún perfil activo los use. La confirmación muestra cada candidato una vez. Elige **Yes** para desinstalar, incluso si aparece un solo paquete. **No** es la opción predeterminada y **Esc** también cancela.

4. Revisa el resultado de cada paquete en `:messages`. Si falla una desinstalación, consulta `:MasonLog` y vuelve a ejecutar la limpieza. Los paquetes ya desinstalados quedan fuera del reintento.
5. Cuando quieras adoptar los perfiles activos como nueva línea base, ejecuta el comando siguiente. Este actualiza el archivo de estado y conserva los paquetes instalados.

   ```vim
   :lua require('utils.lang_loader').update_language_state()
   ```

## Paquetes protegidos

La limpieza conserva las herramientas del perfil `base`, las de cualquier perfil habilitado, incluidos sus adaptadores DAP, y las protecciones explícitas. `prettier`, `stylua` y `lua-language-server` están protegidos por defecto. Por ejemplo, Ruff se conserva mientras Python siga habilitado aunque otro perfil que lo declare se desactive.

Agrega protecciones en tu configuración con los nombres de paquete de Mason.

```lua
require("utils.mason_cleanup").setup({
    protected_tools = { "sql-formatter" },
})
```

## Recuperar la línea base

- Si el archivo falta, se crea con los perfiles habilitados en ese momento, sin desinstalar paquetes. Una línea base válida con una lista vacía deja la limpieza sin candidatos.
- Si el archivo es ilegible o inválido, la limpieza se detiene. Restaura una copia válida o ejecuta `update_language_state()` para adoptar los perfiles actuales.
- Si desaparece la declaración de un perfil anterior, la limpieza muestra su nombre y conserva los paquetes instalados. Recupera la declaración para revisar sus herramientas o, tras revisar el inventario, adopta la configuración actual con `update_language_state()`.

Para reinstalar herramientas declaradas y habilitadas, usa `:LanguageToolsInstall`. Para revertir una migración del perfil, restaura la configuración, el lockfile, los checkouts de plugins, los paquetes y enlaces de Mason, los parsers y la línea base de ese mismo perfil como un conjunto. [Plan de verificación y reversión](./designs/neovim-modernization.md#verification-plan)
