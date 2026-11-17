import { Request, Response } from "express";
import { pool } from "../db";

export async function listarProductos(req: Request, res: Response) {
  try {
    const { tipo_cultivo, genetica, cbd_min, cbd_max, buscar } = req.query;

    const condiciones: string[] = ["p.activo = TRUE"];
    const valores: unknown[] = [];

    if (typeof tipo_cultivo === "string" && tipo_cultivo !== "") {
      valores.push(tipo_cultivo);
      condiciones.push(`p.tipo_cultivo = $${valores.length}`);
    }
    if (typeof genetica === "string" && genetica !== "") {
      valores.push(genetica);
      condiciones.push(`p.genetica = $${valores.length}`);
    }
    if (typeof cbd_min === "string" && cbd_min !== "" && !isNaN(Number(cbd_min))) {
      valores.push(Number(cbd_min));
      condiciones.push(`p.cbd_pct >= $${valores.length}`);
    }
    if (typeof cbd_max === "string" && cbd_max !== "" && !isNaN(Number(cbd_max))) {
      valores.push(Number(cbd_max));
      condiciones.push(`p.cbd_pct <= $${valores.length}`);
    }
    if (typeof buscar === "string" && buscar.trim() !== "") {
      valores.push(`%${buscar.trim()}%`);
      condiciones.push(`p.nombre ILIKE $${valores.length}`);
    }

    const consulta = `
      SELECT p.id, p.nombre, p.tipo_cultivo, p.genetica,
             p.thc_pct::float8 AS thc_pct,
             p.cbd_pct::float8 AS cbd_pct,
             p.gramos,
             p.precio::float8 AS precio,
             p.stock, p.imagen_url,
             c.nombre AS categoria
      FROM productos p
      JOIN categorias c ON c.id = p.categoria_id
      WHERE ${condiciones.join(" AND ")}
      ORDER BY p.nombre
    `;

    const resultado = await pool.query(consulta, valores);
    res.json({ ok: true, total: resultado.rows.length, productos: resultado.rows });
  } catch (error) {
    console.error(error);
    res.status(500).json({ ok: false, error: "Error al obtener los productos" });
  }
}

export async function obtenerProducto(req: Request, res: Response) {
  try {
    const id = Number(req.params.id);
    if (!Number.isInteger(id) || id <= 0) {
      return res.status(400).json({ ok: false, error: "El id debe ser un número entero positivo" });
    }

    const consulta = `
      SELECT p.id, p.nombre, p.tipo_cultivo, p.genetica,
             p.thc_pct::float8 AS thc_pct,
             p.cbd_pct::float8 AS cbd_pct,
             p.descripcion, p.aroma, p.cultivo,
             p.gramos,
             p.precio::float8 AS precio,
             p.stock, p.imagen_url,
             c.nombre AS categoria
      FROM productos p
      JOIN categorias c ON c.id = p.categoria_id
      WHERE p.id = $1 AND p.activo = TRUE
    `;

    const resultado = await pool.query(consulta, [id]);
    if (resultado.rows.length === 0) {
      return res.status(404).json({ ok: false, error: "Producto no encontrado" });
    }

    res.json({ ok: true, producto: resultado.rows[0] });
  } catch (error) {
    console.error(error);
    res.status(500).json({ ok: false, error: "Error al obtener el producto" });
  }
}