-- 1) Nuevo valor permitido: invernadero_vidrio
ALTER TABLE productos DROP CONSTRAINT IF EXISTS productos_tipo_cultivo_check;
ALTER TABLE productos ADD CONSTRAINT productos_tipo_cultivo_check
  CHECK (tipo_cultivo IN ('indoor', 'invernadero', 'invernadero_vidrio', 'outdoor'));

-- 2) Campos nuevos para la ficha
ALTER TABLE productos
  ADD COLUMN IF NOT EXISTS genetica VARCHAR(10)
    CHECK (genetica IN ('indica', 'sativa', 'hibrida')),
  ADD COLUMN IF NOT EXISTS aroma TEXT,
  ADD COLUMN IF NOT EXISTS cultivo TEXT;

-- 3) Evitar productos duplicados por nombre
ALTER TABLE productos DROP CONSTRAINT IF EXISTS productos_nombre_unico;
ALTER TABLE productos ADD CONSTRAINT productos_nombre_unico UNIQUE (nombre);