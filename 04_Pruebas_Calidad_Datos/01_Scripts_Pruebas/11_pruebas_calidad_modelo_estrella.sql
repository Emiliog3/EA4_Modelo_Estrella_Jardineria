USE jardineria;
GO

/* =========================================================
PRUEBAS DE CALIDAD DE DATOS - MODELO ESTRELLA
Objetivo: validar consistencia, completitud e integridad
del data mart de ventas.
========================================================= */

------------------------------------------------------------
-- 1. Registros nulos en claves de la tabla de hechos
------------------------------------------------------------
SELECT
    COUNT(*) AS hechos_con_claves_nulas
FROM FactVentas
WHERE id_tiempo IS NULL
   OR id_producto IS NULL
   OR id_cliente IS NULL
   OR id_estado IS NULL;
GO

------------------------------------------------------------
-- 2. Registros nulos en medidas de la tabla de hechos
------------------------------------------------------------
SELECT
    COUNT(*) AS hechos_con_medidas_nulas
FROM FactVentas
WHERE cantidad IS NULL
   OR precio_unidad IS NULL
   OR importe_venta IS NULL;
GO

------------------------------------------------------------
-- 3. Registros con cantidad inválida
------------------------------------------------------------
SELECT *
FROM FactVentas
WHERE cantidad <= 0;
GO

------------------------------------------------------------
-- 4. Registros con precio unitario inválido
------------------------------------------------------------
SELECT *
FROM FactVentas
WHERE precio_unidad < 0;
GO

------------------------------------------------------------
-- 5. Registros con importe inválido
------------------------------------------------------------
SELECT *
FROM FactVentas
WHERE importe_venta < 0;
GO

------------------------------------------------------------
-- 6. Validación de cálculo de importe_venta
------------------------------------------------------------
SELECT
    id_fact_venta,
    cantidad,
    precio_unidad,
    importe_venta,
    (cantidad * precio_unidad) AS importe_calculado
FROM FactVentas
WHERE importe_venta <> (cantidad * precio_unidad);
GO

------------------------------------------------------------
-- 7. Integridad referencial con DimTiempo
------------------------------------------------------------
SELECT f.*
FROM FactVentas f
LEFT JOIN DimTiempo d
    ON f.id_tiempo = d.id_tiempo
WHERE d.id_tiempo IS NULL;
GO

------------------------------------------------------------
-- 8. Integridad referencial con DimProducto
------------------------------------------------------------
SELECT f.*
FROM FactVentas f
LEFT JOIN DimProducto d
    ON f.id_producto = d.id_producto
WHERE d.id_producto IS NULL;
GO

------------------------------------------------------------
-- 9. Integridad referencial con DimCliente
------------------------------------------------------------
SELECT f.*
FROM FactVentas f
LEFT JOIN DimCliente d
    ON f.id_cliente = d.id_cliente
WHERE d.id_cliente IS NULL;
GO

------------------------------------------------------------
-- 10. Integridad referencial con DimEmpleado
------------------------------------------------------------
SELECT f.*
FROM FactVentas f
LEFT JOIN DimEmpleado d
    ON f.id_empleado = d.id_empleado
WHERE f.id_empleado IS NOT NULL
  AND d.id_empleado IS NULL;
GO

------------------------------------------------------------
-- 11. Integridad referencial con DimEstadoPedido
------------------------------------------------------------
SELECT f.*
FROM FactVentas f
LEFT JOIN DimEstadoPedido d
    ON f.id_estado = d.id_estado
WHERE d.id_estado IS NULL;
GO

------------------------------------------------------------
-- 12. Duplicados potenciales en la tabla de hechos
------------------------------------------------------------
SELECT
    id_pedido_origen,
    id_detalle_origen,
    COUNT(*) AS cantidad
FROM FactVentas
GROUP BY id_pedido_origen, id_detalle_origen
HAVING COUNT(*) > 1;
GO

------------------------------------------------------------
-- 13. Dimensiones con claves duplicadas
------------------------------------------------------------
SELECT id_producto, COUNT(*) AS cantidad
FROM DimProducto
GROUP BY id_producto
HAVING COUNT(*) > 1;
GO

SELECT id_cliente, COUNT(*) AS cantidad
FROM DimCliente
GROUP BY id_cliente
HAVING COUNT(*) > 1;
GO

SELECT id_empleado, COUNT(*) AS cantidad
FROM DimEmpleado
GROUP BY id_empleado
HAVING COUNT(*) > 1;
GO

SELECT id_tiempo, COUNT(*) AS cantidad
FROM DimTiempo
GROUP BY id_tiempo
HAVING COUNT(*) > 1;
GO

------------------------------------------------------------
-- 14. Estados cargados en la dimensión
------------------------------------------------------------
SELECT *
FROM DimEstadoPedido;
GO

------------------------------------------------------------
-- 15. Resumen ejecutivo de calidad del modelo estrella
------------------------------------------------------------
SELECT 'hechos_con_claves_nulas' AS prueba, COUNT(*) AS total
FROM FactVentas
WHERE id_tiempo IS NULL
   OR id_producto IS NULL
   OR id_cliente IS NULL
   OR id_estado IS NULL

UNION ALL

SELECT 'hechos_con_medidas_nulas', COUNT(*)
FROM FactVentas
WHERE cantidad IS NULL
   OR precio_unidad IS NULL
   OR importe_venta IS NULL

UNION ALL

SELECT 'hechos_con_cantidad_invalida', COUNT(*)
FROM FactVentas
WHERE cantidad <= 0

UNION ALL

SELECT 'hechos_con_precio_invalido', COUNT(*)
FROM FactVentas
WHERE precio_unidad < 0

UNION ALL

SELECT 'hechos_con_importe_invalido', COUNT(*)
FROM FactVentas
WHERE importe_venta < 0

UNION ALL

SELECT 'hechos_con_importe_inconsistente', COUNT(*)
FROM FactVentas
WHERE importe_venta <> (cantidad * precio_unidad);
GO
