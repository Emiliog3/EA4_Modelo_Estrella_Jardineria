USE jardineria;
GO

/* =========================================================
CONSULTAS CON FILTROS LIBRES - DATA MART JARDINERIA
Objetivo: visualizar todos los datos sin TOP 1
para poder aplicar filtros manuales en cada resultado.
========================================================= */

------------------------------------------------------------
-- 1. Vista general completa del modelo estrella
--    Aquí podrás filtrar por año, mes, categoría, cliente,
--    producto, empleado, estado, etc.
------------------------------------------------------------
SELECT
    f.id_fact_venta,
    dt.fecha,
    dt.anio,
    dt.trimestre,
    dt.mes,
    dt.nombre_mes,
    dt.dia,
    dp.id_producto,
    dp.codigo_producto,
    dp.nombre_producto,
    dp.categoria,
    dp.proveedor,
    dp.dimensiones,
    dc.id_cliente,
    dc.nombre_cliente,
    dc.nombre_contacto,
    dc.ciudad,
    dc.region,
    dc.pais,
    de.id_empleado,
    de.nombre_empleado,
    de.puesto,
    des.estado,
    f.id_pedido_origen,
    f.id_detalle_origen,
    f.cantidad,
    f.precio_unidad,
    f.importe_venta
FROM FactVentas f
INNER JOIN DimTiempo dt
    ON f.id_tiempo = dt.id_tiempo
INNER JOIN DimProducto dp
    ON f.id_producto = dp.id_producto
INNER JOIN DimCliente dc
    ON f.id_cliente = dc.id_cliente
LEFT JOIN DimEmpleado de
    ON f.id_empleado = de.id_empleado
INNER JOIN DimEstadoPedido des
    ON f.id_estado = des.id_estado
ORDER BY dt.anio, dt.mes, dt.fecha, f.id_fact_venta;
GO

------------------------------------------------------------
-- 2. Ventas por año
------------------------------------------------------------
SELECT
    dt.anio,
    SUM(f.cantidad) AS total_unidades,
    SUM(f.importe_venta) AS total_ventas
FROM FactVentas f
INNER JOIN DimTiempo dt
    ON f.id_tiempo = dt.id_tiempo
GROUP BY dt.anio
ORDER BY dt.anio;
GO

------------------------------------------------------------
-- 3. Ventas por año y mes
------------------------------------------------------------
SELECT
    dt.anio,
    dt.mes,
    dt.nombre_mes,
    SUM(f.cantidad) AS total_unidades,
    SUM(f.importe_venta) AS total_ventas
FROM FactVentas f
INNER JOIN DimTiempo dt
    ON f.id_tiempo = dt.id_tiempo
GROUP BY dt.anio, dt.mes, dt.nombre_mes
ORDER BY dt.anio, dt.mes;
GO

------------------------------------------------------------
-- 4. Ventas por categoría
------------------------------------------------------------
SELECT
    dp.categoria,
    SUM(f.cantidad) AS total_unidades,
    SUM(f.importe_venta) AS total_ventas
FROM FactVentas f
INNER JOIN DimProducto dp
    ON f.id_producto = dp.id_producto
GROUP BY dp.categoria
ORDER BY dp.categoria;
GO

------------------------------------------------------------
-- 5. Ventas por producto
------------------------------------------------------------
SELECT
    dp.codigo_producto,
    dp.nombre_producto,
    dp.categoria,
    SUM(f.cantidad) AS total_unidades,
    SUM(f.importe_venta) AS total_ventas
FROM FactVentas f
INNER JOIN DimProducto dp
    ON f.id_producto = dp.id_producto
GROUP BY
    dp.codigo_producto,
    dp.nombre_producto,
    dp.categoria
ORDER BY dp.nombre_producto;
GO

------------------------------------------------------------
-- 6. Ventas por cliente
------------------------------------------------------------
SELECT
    dc.nombre_cliente,
    dc.ciudad,
    dc.region,
    dc.pais,
    SUM(f.cantidad) AS total_unidades,
    SUM(f.importe_venta) AS total_comprado
FROM FactVentas f
INNER JOIN DimCliente dc
    ON f.id_cliente = dc.id_cliente
GROUP BY
    dc.nombre_cliente,
    dc.ciudad,
    dc.region,
    dc.pais
ORDER BY dc.nombre_cliente;
GO

------------------------------------------------------------
-- 7. Ventas por empleado
------------------------------------------------------------
SELECT
    de.nombre_empleado,
    de.puesto,
    de.ciudad_oficina,
    de.pais_oficina,
    SUM(f.cantidad) AS total_unidades,
    SUM(f.importe_venta) AS total_vendido
FROM FactVentas f
LEFT JOIN DimEmpleado de
    ON f.id_empleado = de.id_empleado
GROUP BY
    de.nombre_empleado,
    de.puesto,
    de.ciudad_oficina,
    de.pais_oficina
ORDER BY de.nombre_empleado;
GO

------------------------------------------------------------
-- 8. Ventas por estado del pedido
------------------------------------------------------------
SELECT
    des.estado,
    SUM(f.cantidad) AS total_unidades,
    SUM(f.importe_venta) AS total_ventas
FROM FactVentas f
INNER JOIN DimEstadoPedido des
    ON f.id_estado = des.id_estado
GROUP BY des.estado
ORDER BY des.estado;
GO

------------------------------------------------------------
-- 9. Cruce libre: año + categoría + producto + cliente
--    Esta consulta es muy útil porque permite muchos filtros
------------------------------------------------------------
SELECT
    dt.anio,
    dt.nombre_mes,
    dp.categoria,
    dp.nombre_producto,
    dc.nombre_cliente,
    de.nombre_empleado,
    des.estado,
    f.cantidad,
    f.precio_unidad,
    f.importe_venta
FROM FactVentas f
INNER JOIN DimTiempo dt
    ON f.id_tiempo = dt.id_tiempo
INNER JOIN DimProducto dp
    ON f.id_producto = dp.id_producto
INNER JOIN DimCliente dc
    ON f.id_cliente = dc.id_cliente
LEFT JOIN DimEmpleado de
    ON f.id_empleado = de.id_empleado
INNER JOIN DimEstadoPedido des
    ON f.id_estado = des.id_estado
ORDER BY
    dt.anio,
    dt.nombre_mes,
    dp.categoria,
    dp.nombre_producto,
    dc.nombre_cliente;
GO