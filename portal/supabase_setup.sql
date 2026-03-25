-- ============================================================
-- SUPABASE — Script de configuración completa
-- Portal Financiero Mi Banco · MVP v1.0
-- ============================================================
-- INSTRUCCIONES:
-- 1. Ir a tu proyecto en supabase.com
-- 2. Abrir el SQL Editor (ícono de terminal en el sidebar)
-- 3. Pegar este script completo y ejecutar con "Run"
-- ============================================================


-- ── 1. Tabla: cuentas ─────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.cuentas (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id        UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  tipo           TEXT NOT NULL CHECK (tipo IN ('corriente', 'ahorro')),
  numero_cuenta  TEXT NOT NULL,
  saldo          NUMERIC(12,2) NOT NULL DEFAULT 0,
  moneda         TEXT NOT NULL DEFAULT 'PEN',
  created_at     TIMESTAMPTZ DEFAULT now()
);

-- ── 2. Tabla: transacciones ───────────────────────────────
CREATE TABLE IF NOT EXISTS public.transacciones (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id        UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  cuenta_id      UUID REFERENCES public.cuentas(id) ON DELETE SET NULL,
  tipo           TEXT NOT NULL CHECK (tipo IN ('debito', 'credito')),
  descripcion    TEXT NOT NULL,
  monto          NUMERIC(12,2) NOT NULL,
  fecha          TIMESTAMPTZ DEFAULT now()
);

-- ── 3. Tabla: pagos ───────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.pagos (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id          UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  servicio         TEXT NOT NULL CHECK (servicio IN ('agua','luz','cable','telefono','gas')),
  numero_contrato  TEXT NOT NULL,
  monto            NUMERIC(10,2) NOT NULL,
  estado           TEXT NOT NULL DEFAULT 'completado',
  fecha            TIMESTAMPTZ DEFAULT now()
);

-- ── 4. Tabla: solicitudes_prestamo ───────────────────────
CREATE TABLE IF NOT EXISTS public.solicitudes_prestamo (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id        UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  monto          NUMERIC(12,2) NOT NULL,
  plazo_meses    INTEGER NOT NULL,
  tasa_anual     NUMERIC(5,2) NOT NULL,
  cuota_mensual  NUMERIC(10,2) NOT NULL,
  proposito      TEXT,
  estado         TEXT NOT NULL DEFAULT 'pendiente',
  created_at     TIMESTAMPTZ DEFAULT now()
);

-- ── 5. Tabla: cuentas_ahorro ──────────────────────────────
CREATE TABLE IF NOT EXISTS public.cuentas_ahorro (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  saldo           NUMERIC(12,2) NOT NULL DEFAULT 0,
  meta_ahorro     NUMERIC(12,2) NOT NULL DEFAULT 10000,
  tasa_interes    NUMERIC(5,2) NOT NULL DEFAULT 3.5,
  fecha_apertura  DATE DEFAULT CURRENT_DATE
);


-- ============================================================
-- ROW LEVEL SECURITY (RLS) — Cada usuario solo ve sus datos
-- ============================================================

-- Habilitar RLS en todas las tablas
ALTER TABLE public.cuentas              ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.transacciones        ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.pagos                ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.solicitudes_prestamo ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cuentas_ahorro       ENABLE ROW LEVEL SECURITY;

-- ── Políticas: cuentas ────────────────────────────────────
CREATE POLICY "Usuario ve sus propias cuentas"
  ON public.cuentas FOR ALL
  USING (auth.uid() = user_id);

-- ── Políticas: transacciones ──────────────────────────────
CREATE POLICY "Usuario ve sus propias transacciones"
  ON public.transacciones FOR ALL
  USING (auth.uid() = user_id);

-- ── Políticas: pagos ──────────────────────────────────────
CREATE POLICY "Usuario ve sus propios pagos"
  ON public.pagos FOR ALL
  USING (auth.uid() = user_id);

-- ── Políticas: solicitudes_prestamo ──────────────────────
CREATE POLICY "Usuario ve sus propias solicitudes"
  ON public.solicitudes_prestamo FOR ALL
  USING (auth.uid() = user_id);

-- ── Políticas: cuentas_ahorro ─────────────────────────────
CREATE POLICY "Usuario ve su propia cuenta de ahorro"
  ON public.cuentas_ahorro FOR ALL
  USING (auth.uid() = user_id);


-- ============================================================
-- DATOS DE DEMOSTRACIÓN (opcional)
-- Descomenta el bloque siguiente si quieres insertar datos
-- de prueba manualmente en la tabla sin pasar por el registro
-- ============================================================

--/*
-- Primero regístrate en el portal, luego reemplaza el UUID:
-- Ejecuta: SELECT id FROM auth.users; para obtener tu UUID

DO $$
DECLARE
  uid UUID := 'TU-UUID-AQUI';  -- <-- pegar el UUID de tu usuario
  cc_id UUID;
  ca_id UUID;
BEGIN
  -- Cuentas
  INSERT INTO public.cuentas (user_id, tipo, numero_cuenta, saldo)
  VALUES (uid, 'corriente', '019-1234567', 4250.00)
  RETURNING id INTO cc_id;

  INSERT INTO public.cuentas (user_id, tipo, numero_cuenta, saldo)
  VALUES (uid, 'ahorro', '019-7654321', 12875.50)
  RETURNING id INTO ca_id;

  -- Cuenta ahorro
  INSERT INTO public.cuentas_ahorro (user_id, saldo, meta_ahorro, tasa_interes, fecha_apertura)
  VALUES (uid, 12875.50, 20000, 3.5, '2024-01-15');

  -- Transacciones
  INSERT INTO public.transacciones (user_id, cuenta_id, tipo, descripcion, monto, fecha) VALUES
    (uid, cc_id, 'debito',  'Pago agua SEDAPAL',       85.00,   now() - interval '1 day'),
    (uid, cc_id, 'credito', 'Transferencia recibida',  500.00,  now() - interval '2 days'),
    (uid, cc_id, 'debito',  'Compra supermercado WONG',230.50,  now() - interval '3 days'),
    (uid, cc_id, 'debito',  'Pago Netflix',            39.90,   now() - interval '5 days'),
    (uid, cc_id, 'credito', 'Depósito sueldo',         3500.00, now() - interval '7 days'),
    (uid, ca_id, 'credito', 'Depósito ahorro',         1000.00, now() - interval '10 days'),
    (uid, cc_id, 'debito',  'Pago luz ENEL',           120.00,  now() - interval '12 days'),
    (uid, cc_id, 'credito', 'Devolución compra',       150.00,  now() - interval '15 days');
END $$;
*/
