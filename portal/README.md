# Portal Financiero — Mi Banco · MVP v1.0
**Stack:** Bootstrap 5 + Supabase + Vercel

---

## Estructura del proyecto

```
portal/
├── index.html                  ← M1: Login
├── css/
│   └── styles.css              ← Estilos globales + variables corporativas
├── js/
│   └── supabase.js             ← Cliente Supabase + utilidades compartidas
├── modulos/
│   ├── registro.html           ← M1: Registro de nuevo cliente
│   ├── dashboard.html          ← M2: Dashboard con saldos
│   ├── transacciones.html      ← M3: Historial + filtros
│   ├── pagos.html              ← M4: Pagos de servicios
│   ├── prestamos.html          ← M5: Simulador + solicitud de préstamo
│   └── ahorro.html             ← M6: Cuenta de ahorro + progreso
└── supabase_setup.sql          ← Script SQL completo para Supabase
```

---

## Paso 1 — Configurar Supabase

1. Crear cuenta en [supabase.com](https://supabase.com) → **New Project**
2. Ir a **SQL Editor** en el panel izquierdo
3. Pegar el contenido de `supabase_setup.sql` y hacer clic en **Run**
4. Ir a **Settings → API** y copiar:
   - `Project URL` → reemplazar `SUPABASE_URL` en `js/supabase.js`
   - `anon / public key` → reemplazar `SUPABASE_KEY` en `js/supabase.js`

```js
// js/supabase.js — líneas 7-8
const SUPABASE_URL = 'https://abcdefgh.supabase.co';
const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
```

---

## Paso 2 — Configurar Supabase Auth

En el panel de Supabase:
1. Ir a **Authentication → Providers → Email**
2. Habilitar **Email Auth** (si no está activo)
3. Ir a **Authentication → URL Configuration**
4. Agregar en **Redirect URLs**: `http://localhost:5500` (para desarrollo local)

---

## Paso 3 — Probar en local

1. Abrir VS Code con la carpeta `portal/`
2. Instalar la extensión **Live Server** (si no la tienes)
3. Clic derecho en `index.html` → **Open with Live Server**
4. Registrarse con un correo → verificar en Supabase que se crearon las cuentas de demo

---

## Paso 4 — Subir a GitHub

```bash
cd portal/
git init
git add .
git commit -m "feat: MVP Portal Financiero Mi Banco v1.0"
git branch -M main
git remote add origin https://github.com/TU_USUARIO/portal-financiero.git
git push -u origin main
```

---

## Paso 5 — Deploy en Vercel

1. Ir a [vercel.com](https://vercel.com) → **Add New Project**
2. Importar el repositorio de GitHub
3. Framework Preset: **Other** (HTML estático)
4. En **Environment Variables** agregar:
   - `SUPABASE_URL` = tu URL de Supabase
   - `SUPABASE_KEY` = tu anon key
5. Clic en **Deploy**
6. Actualizar las Redirect URLs de Supabase con la URL de Vercel

> **Nota:** Como el proyecto usa módulos ES nativos (`type="module"`), Vercel lo despliega
> sin configuración adicional. Solo asegúrate de que los CDN de Bootstrap y Supabase
> estén disponibles (requiere conexión a internet en el cliente).

---

## Módulos completados

| Módulo | Archivo | HU cubiertas | RF cubiertos |
|--------|---------|-------------|--------------|
| M1 Login/Registro | `index.html`, `registro.html` | HU-01, HU-02, HU-03 | RF-01 al RF-07 |
| M2 Dashboard | `dashboard.html` | HU-04, HU-05 | RF-08 al RF-11 |
| M3 Transacciones | `transacciones.html` | HU-06, HU-07 | RF-12 al RF-15 |
| M4 Pagos | `pagos.html` | HU-08, HU-09 | RF-16 al RF-20 |
| M5 Préstamos | `prestamos.html` | HU-10, HU-11 | RF-21 al RF-25 |
| M6 Ahorro | `ahorro.html` | HU-12, HU-13 | RF-26 al RF-28 |

---

## Notas para el equipo

- Cada módulo es **autónomo**: incluye su propio navbar y conexión a Supabase
- El **Row Level Security (RLS)** de Supabase garantiza que cada usuario solo ve sus datos
- Los datos demo se crean automáticamente al registrar un nuevo usuario
- La fórmula de préstamo implementada es **amortización francesa**: `C = P × [r(1+r)^n] / [(1+r)^n - 1]`
