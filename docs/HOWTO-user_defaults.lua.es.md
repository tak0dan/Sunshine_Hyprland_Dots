# Cómo configurar aplicaciones predeterminadas en Sunshine Hyprland Dots (`user_defaults.lua`)

En **Sunshine Hyprland Dots (2026)** con el flujo de configuración en Lua, todas las aplicaciones predeterminadas personales (emulador de terminal, gestor de archivos, editores de texto y motor de búsqueda web) se administran en:

```
~/.config/hypr/UserConfigs/user_defaults.lua
```

Esta guía explica cómo funciona `user_defaults.lua`, cómo interactúan los valores del sistema con las modificaciones de usuario y ofrece ejemplos prácticos para configurar sus programas preferidos.

---

## 1. Descripción general y arquitectura

### Valores del sistema vs. Valores del usuario

- **Valores del sistema (`~/.config/hypr/lua/user_defaults.lua`)**:
  Inicializa la tabla global `SUNSHINEDOTS_DEFAULTS` con valores predeterminados de reserva. Si variables de entorno como `$EDITOR` o `$VISUAL` están definidas, se leen automáticamente; de lo contrario, se usan opciones estándar como `nano`, `kitty` y `thunar`.
- **Valores del usuario (`~/.config/hypr/UserConfigs/user_defaults.lua`)**:
  Se carga inmediatamente después de los valores del sistema para sobrescribir cualquier clave en `SUNSHINEDOTS_DEFAULTS`. Los cambios realizados aquí se conservan durante las actualizaciones de Sunshine Hyprland Dots.

### Claves admitidas

La tabla `SUNSHINEDOTS_DEFAULTS` admite las siguientes claves de configuración:

| Clave | Tipo | Descripción | Valor de reserva |
|---|---|---|---|
| `term` | string | Emulador de terminal lanzado por atajos de teclado | `"kitty"` |
| `edit` | string | Editor de texto en terminal (ej. `nvim`, `nano`, `hx`, `micro`) | `$EDITOR` o `"nano"` |
| `visual` | string | Editor gráfico o IDE (ej. `code`, `gedit`, `kate`) | `$VISUAL` o `""` |
| `files` | string | Administrador de archivos gráfico (ej. `thunar`, `nautilus`, `dolphin`, `yazi`) | `"thunar"` |
| `search_engine` | string | Plantilla de URL para búsquedas web (`{}` se reemplaza por la consulta) | `"https://www.google.com/search?q={}"` |

---

## 2. Instrucciones paso a paso

### Paso 1: Abrir `user_defaults.lua`
Abra el archivo en su editor preferido o desde la terminal:

```bash
nano ~/.config/hypr/UserConfigs/user_defaults.lua
# o
nvim ~/.config/hypr/UserConfigs/user_defaults.lua
```

*(También puede presionar `SUPER + SHIFT + E` para abrir el menú de edición rápida de Sunshine Hyprland Dots).*

### Paso 2: Asegurar la inicialización de la tabla
Verifique que la tabla base esté presente:

```lua
SUNSHINEDOTS_DEFAULTS = SUNSHINEDOTS_DEFAULTS or {}
```

### Paso 3: Agregar sus aplicaciones personalizadas
Asigne los nombres de ejecutables o patrones de URL deseados a las claves de `SUNSHINEDOTS_DEFAULTS`:

```lua
SUNSHINEDOTS_DEFAULTS = SUNSHINEDOTS_DEFAULTS or {}

SUNSHINEDOTS_DEFAULTS.term = "kitty"
SUNSHINEDOTS_DEFAULTS.edit = "nvim"
SUNSHINEDOTS_DEFAULTS.visual = "code"
SUNSHINEDOTS_DEFAULTS.files = "thunar"
SUNSHINEDOTS_DEFAULTS.search_engine = "https://duckduckgo.com/?q={}"
```

### Paso 4: Guardar y recargar
1. Guarde el archivo.
2. Recargue la configuración de Hyprland:
   ```bash
   hyprctl reload
   ```
   *(o presione `SUPER + ALT + R`).*

---

## 3. Ejemplos prácticos

### Ejemplo A: Configuración TUI moderna (Neovim + Ghostty + Yazi)

```lua
SUNSHINEDOTS_DEFAULTS = SUNSHINEDOTS_DEFAULTS or {}

SUNSHINEDOTS_DEFAULTS.term = "ghostty"
SUNSHINEDOTS_DEFAULTS.edit = "nvim"
SUNSHINEDOTS_DEFAULTS.visual = "nvim"
SUNSHINEDOTS_DEFAULTS.files = "kitty -e yazi"
SUNSHINEDOTS_DEFAULTS.search_engine = "https://duckduckgo.com/?q={}"
```

### Ejemplo B: Ecosistema GNOME / GTK (Nautilus + Editor de texto)

```lua
SUNSHINEDOTS_DEFAULTS = SUNSHINEDOTS_DEFAULTS or {}

SUNSHINEDOTS_DEFAULTS.term = "alacritty"
SUNSHINEDOTS_DEFAULTS.edit = "micro"
SUNSHINEDOTS_DEFAULTS.visual = "gnome-text-editor"
SUNSHINEDOTS_DEFAULTS.files = "nautilus"
SUNSHINEDOTS_DEFAULTS.search_engine = "https://www.google.com/search?q={}"
```

### Ejemplo C: Ecosistema KDE / Qt (Dolphin + Kate)

```lua
SUNSHINEDOTS_DEFAULTS = SUNSHINEDOTS_DEFAULTS or {}

SUNSHINEDOTS_DEFAULTS.term = "foot"
SUNSHINEDOTS_DEFAULTS.edit = "nano"
SUNSHINEDOTS_DEFAULTS.visual = "kate"
SUNSHINEDOTS_DEFAULTS.files = "dolphin"
SUNSHINEDOTS_DEFAULTS.search_engine = "https://search.brave.com/search?q={}"
```

---

## 4. Solución de problemas y verificación

1. **Comprobar la sintaxis**:
   Valide la sintaxis del archivo Lua:
   ```bash
   luac -p ~/.config/hypr/UserConfigs/user_defaults.lua
   ```

2. **Verificar el lanzamiento**:
   Pruebe iniciar su terminal (`SUPER + ENTER` o `SUPER + T`) y el administrador de archivos (`SUPER + E`) para asegurarse de que abran las aplicaciones actualizadas.
