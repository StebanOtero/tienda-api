-- Categoría
INSERT INTO categorias (nombre, descripcion)
VALUES ('Flores', 'Flores de cannabis seleccionadas, en presentación por gramos.')
ON CONFLICT (nombre) DO NOTHING;

-- Productos (datos ficticios)
INSERT INTO productos
  (categoria_id, nombre, tipo_cultivo, genetica, thc_pct, cbd_pct,
   descripcion, aroma, cultivo, gramos, precio, stock, imagen_url)
SELECT c.id, v.nombre, v.tipo_cultivo, v.genetica, v.thc_pct, v.cbd_pct,
       v.descripcion, v.aroma, v.cultivo, v.gramos, v.precio, v.stock, v.imagen_url
FROM categorias c
CROSS JOIN (VALUES
  ('Ámbar Real', 'indoor', 'hibrida', 0.20, 23.50,
   'Híbrida de cultivo interior con cogollos grandes, compactos y muy resinosos. Tonos ámbar y naranja sobre un verde intenso, con tacto pegajoso.',
   'Dulce y cítrico, con fondo tropical y un toque azucarado.',
   'Cultivo interior hidropónico, con luz, humedad y nutrientes controlados durante todo el ciclo. Da lotes muy uniformes.',
   5, 520.00, 40, '/imagenes/ambar-real.jpg'),

  ('Baya Rubí', 'invernadero_vidrio', 'hibrida', 0.10, 18.50,
   'Híbrida equilibrada de cogollos medianos y alargados. Verde oscuro con pistilos rojizos y tricomas blancos.',
   'Muy dulce, con notas de bayas maduras, flores y lima. Recuerda a un caramelo de frutas.',
   'Invernadero de vidrio con luz solar y control de humedad y temperatura. Cultivo sin pesticidas.',
   5, 420.00, 55, '/imagenes/baya-rubi.jpg'),

  ('Bruma Tropical', 'invernadero', 'sativa', 0.15, 18.00,
   'Cogollos medianos y redondeados, con naranjas y púrpuras intensos cubiertos de tricomas. Muy resistente al frío.',
   'Suave y dulce, con un regusto de mango y papaya. Delicado, nunca invasivo.',
   'Invernadero en zona de montaña, con luz artificial solo en la etapa inicial del ciclo.',
   5, 390.00, 60, '/imagenes/bruma-tropical.jpg'),

  ('Escarcha Boreal', 'invernadero_vidrio', 'hibrida', 0.20, 16.50,
   'Cogollos pequeños a medianos y parejos, cubiertos de cristales blancos de resina sobre verde con pistilos naranja oscuro.',
   'Bosque, tierra y pino, con un final de fruta exótica. Intenso y envolvente.',
   'Invernadero de vidrio en clima frío, con luz natural y lámparas en invierno. Planta robusta que pide poco fertilizante.',
   5, 410.00, 45, '/imagenes/escarcha-boreal.jpg'),

  ('Pradera Melón', 'invernadero', 'indica', 0.15, 16.80,
   'Indica de cogollos medianos y alargados, verde muy claro y con una gruesa capa de resina.',
   'Fresco y frutal: cítricos, melón y pomelo, con fondo de pino y tierra.',
   'Invernadero en llanura con aireación y riego adaptados. Variedad resistente que también se adapta al aire libre.',
   5, 380.00, 50, '/imagenes/pradera-melon.jpg')
) AS v(nombre, tipo_cultivo, genetica, thc_pct, cbd_pct,
       descripcion, aroma, cultivo, gramos, precio, stock, imagen_url)
WHERE c.nombre = 'Flores'
ON CONFLICT (nombre) DO NOTHING;