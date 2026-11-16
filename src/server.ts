import express from "express";
import { pool } from "./db";

const app = express();
app.use(express.json());

app.get("/salud", async (_req, res) => {
  try {
    const resultado = await pool.query("SELECT NOW() AS ahora");
    res.json({ ok: true, horaBaseDeDatos: resultado.rows[0].ahora });
  } catch (error) {
    console.error(error);
    res.status(500).json({ ok: false, error: "No se pudo conectar a la base de datos" });
  }
});

const PORT = Number(process.env.PORT) || 3000;
app.listen(PORT, () => {
  console.log(`API escuchando en http://localhost:${PORT}`);
});