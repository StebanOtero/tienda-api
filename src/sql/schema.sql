-- USUARIOS
CREATE TABLE IF NOT EXISTS usuarios (
  id            INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nombre        VARCHAR(100) NOT NULL,
  correo        VARCHAR(150) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  rol           VARCHAR(10)  NOT NULL DEFAULT 'cliente'
                CHECK (rol IN ('cliente', 'admin')),
  creado_en     TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

-- CATEGORIAS
CREATE TABLE IF NOT EXISTS categorias (
  id          INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nombre      VARCHAR(80) NOT NULL UNIQUE,
  descripcion TEXT
);

-- PRODUCTOS
CREATE TABLE IF NOT EXISTS productos (
  id           INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  categoria_id INTEGER NOT NULL REFERENCES categorias(id),
  nombre       VARCHAR(100) NOT NULL,
  tipo_cultivo VARCHAR(20)  NOT NULL
               CHECK (tipo_cultivo IN ('indoor', 'invernadero', 'outdoor')),
  thc_pct      NUMERIC(5,2) NOT NULL DEFAULT 0 CHECK (thc_pct BETWEEN 0 AND 100),
  cbd_pct      NUMERIC(5,2) NOT NULL DEFAULT 0 CHECK (cbd_pct BETWEEN 0 AND 100),
  descripcion  TEXT,
  gramos       INTEGER      NOT NULL CHECK (gramos > 0),
  precio       NUMERIC(10,2) NOT NULL CHECK (precio >= 0),
  stock        INTEGER      NOT NULL DEFAULT 0 CHECK (stock >= 0),
  imagen_url   TEXT,
  activo       BOOLEAN      NOT NULL DEFAULT TRUE,
  creado_en    TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

-- PEDIDOS
CREATE TABLE IF NOT EXISTS pedidos (
  id         INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  usuario_id INTEGER NOT NULL REFERENCES usuarios(id),
  estado     VARCHAR(20) NOT NULL DEFAULT 'pendiente'
             CHECK (estado IN ('pendiente', 'en_preparacion', 'listo', 'entregado', 'cancelado')),
  total      NUMERIC(10,2) NOT NULL DEFAULT 0 CHECK (total >= 0),
  creado_en  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- DETALLE DE PEDIDO
CREATE TABLE IF NOT EXISTS detalle_pedido (
  id              INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  pedido_id       INTEGER NOT NULL REFERENCES pedidos(id) ON DELETE CASCADE,
  producto_id     INTEGER NOT NULL REFERENCES productos(id),
  cantidad        INTEGER NOT NULL CHECK (cantidad > 0),
  precio_unitario NUMERIC(10,2) NOT NULL CHECK (precio_unitario >= 0)
);

-- ÍNDICES en las claves foráneas (aceleran las búsquedas)
CREATE INDEX IF NOT EXISTS idx_productos_categoria ON productos(categoria_id);
CREATE INDEX IF NOT EXISTS idx_pedidos_usuario     ON pedidos(usuario_id);
CREATE INDEX IF NOT EXISTS idx_detalle_pedido      ON detalle_pedido(pedido_id);