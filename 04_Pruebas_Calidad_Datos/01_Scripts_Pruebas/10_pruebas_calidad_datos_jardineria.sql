USE jardineria;
GO

/* =========================================================
PRUEBAS DE CALIDAD DE DATOS - BASE JARDINERIA
Objetivo: evaluar consistencia, integridad y calidad
de los datos del modelo transaccional.
========================================================= */

------------------------------------------------------------
-- 1. Valores nulos en campos críticos de cliente
------------------------------------------------------------
SELECT
    'cliente' AS tabla,
    COUNT(*) AS registros_con_nulos
FROM cliente
WHERE nombre_cliente IS NULL
   OR telefono IS NULL
   OR ciudad IS NULL;
GO

------------------------------------------------------------
-- 2. Valores nulos en campos críticos de producto
------------------------------------------------------------
SELECT
    'producto' AS tabla,
    COUNT(*) AS registros_con_nulos
FROM producto
WHERE CodigoProducto IS NULL
   OR nombre IS NULL
   OR Categoria IS NULL
   OR precio_venta IS NULL;
GO

------------------------------------------------------------
-- 3. Clientes duplicados por combinación básica
------------------------------------------------------------
SELECT
    nombre_cliente,
    telefono,
    ciudad,
    COUNT(*) AS cantidad
FROM cliente
GROUP BY nombre_cliente, telefono, ciudad
HAVING COUNT(*) > 1;
GO

------------------------------------------------------------
-- 4. Productos duplicados por código de producto
------------------------------------------------------------
SELECT
    CodigoProducto,
    COUNT(*) AS cantidad
FROM producto
GROUP BY CodigoProducto
HAVING COUNT(*) > 1;
GO

------------------------------------------------------------
-- 5. Pedidos con fechas inconsistentes
-- fecha_esperada menor que fecha_pedido
------------------------------------------------------------
SELECT
    ID_pedido,
    fecha_pedido,
    fecha_esperada,
    fecha_entrega,
    estado
FROM pedido
WHERE fecha_esperada < fecha_pedido;
GO

------------------------------------------------------------
-- 6. Pedidos entregados sin fecha de entrega
------------------------------------------------------------
SELECT
    ID_pedido,
    fecha_pedido,
    fecha_esperada,
    fecha_entrega,
    estado
FROM pedido
WHERE estado = 'Entregado'
  AND fecha_entrega IS NULL;
GO

------------------------------------------------------------
-- 7. Pedidos con fecha de entrega anterior a la fecha del pedido
------------------------------------------------------------
SELECT
    ID_pedido,
    fecha_pedido,
    fecha_esperada,
    fecha_entrega,
    estado
FROM pedido
WHERE fecha_entrega IS NOT NULL
  AND fecha_entrega < fecha_pedido;
GO

------------------------------------------------------------
-- 8. Productos con precios inválidos
------------------------------------------------------------
SELECT
    ID_producto,
    CodigoProducto,
    nombre,
    precio_venta,
    precio_proveedor
FROM producto
WHERE precio_venta < 0
   OR precio_proveedor < 0;
GO

------------------------------------------------------------
-- 9. Productos con stock negativo
------------------------------------------------------------
SELECT
    ID_producto,
    CodigoProducto,
    nombre,
    cantidad_en_stock
FROM producto
WHERE cantidad_en_stock < 0;
GO

------------------------------------------------------------
-- 10. Detalles de pedido con cantidades o precios inválidos
------------------------------------------------------------
SELECT
    ID_detalle_pedido,
    ID_pedido,
    ID_producto,
    cantidad,
    precio_unidad
FROM detalle_pedido
WHERE cantidad <= 0
   OR precio_unidad < 0;
GO

------------------------------------------------------------
-- 11. Integridad referencial: clientes con representante inexistente
------------------------------------------------------------
SELECT
    c.ID_cliente,
    c.nombre_cliente,
    c.ID_empleado_rep_ventas
FROM cliente c
LEFT JOIN empleado e
    ON c.ID_empleado_rep_ventas = e.ID_empleado
WHERE c.ID_empleado_rep_ventas IS NOT NULL
  AND e.ID_empleado IS NULL;
GO

------------------------------------------------------------
-- 12. Integridad referencial: pedidos con cliente inexistente
------------------------------------------------------------
SELECT
    p.ID_pedido,
    p.ID_cliente
FROM pedido p
LEFT JOIN cliente c
    ON p.ID_cliente = c.ID_cliente
WHERE c.ID_cliente IS NULL;
GO

------------------------------------------------------------
-- 13. Integridad referencial: detalle_pedido con pedido inexistente
------------------------------------------------------------
SELECT
    dp.ID_detalle_pedido,
    dp.ID_pedido
FROM detalle_pedido dp
LEFT JOIN pedido p
    ON dp.ID_pedido = p.ID_pedido
WHERE p.ID_pedido IS NULL;
GO

------------------------------------------------------------
-- 14. Integridad referencial: detalle_pedido con producto inexistente
------------------------------------------------------------
SELECT
    dp.ID_detalle_pedido,
    dp.ID_producto
FROM detalle_pedido dp
LEFT JOIN producto pr
    ON dp.ID_producto = pr.ID_producto
WHERE pr.ID_producto IS NULL;
GO

------------------------------------------------------------
-- 15. Resumen ejecutivo de pruebas de calidad
------------------------------------------------------------
SELECT 'clientes_nulos' AS prueba, COUNT(*) AS total
FROM cliente
WHERE nombre_cliente IS NULL
   OR telefono IS NULL
   OR ciudad IS NULL

UNION ALL

SELECT 'productos_nulos', COUNT(*)
FROM producto
WHERE CodigoProducto IS NULL
   OR nombre IS NULL
   OR Categoria IS NULL
   OR precio_venta IS NULL

UNION ALL

SELECT 'pedidos_fechas_inconsistentes', COUNT(*)
FROM pedido
WHERE fecha_esperada < fecha_pedido

UNION ALL

SELECT 'pedidos_entregados_sin_fecha', COUNT(*)
FROM pedido
WHERE estado = 'Entregado'
  AND fecha_entrega IS NULL

UNION ALL

SELECT 'productos_stock_negativo', COUNT(*)
FROM producto
WHERE cantidad_en_stock < 0

UNION ALL

SELECT 'detalles_cantidad_precio_invalidos', COUNT(*)
FROM detalle_pedido
WHERE cantidad <= 0
   OR precio_unidad < 0;
GO
