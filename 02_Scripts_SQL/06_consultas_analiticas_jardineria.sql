USE jardineria;
GO

-- 1. Ventas por categoría
SELECT 
    dp.categoria,
    SUM(f.importe_venta) AS total_ventas
FROM FactVentas f
INNER JOIN DimProducto dp
    ON f.id_producto = dp.id_producto
GROUP BY dp.categoria
ORDER BY total_ventas DESC;
GO

-- 2. Top 5 clientes por ventas
SELECT TOP 5
    dc.nombre_cliente,
    SUM(f.importe_venta) AS total_comprado
FROM FactVentas f
INNER JOIN DimCliente dc
    ON f.id_cliente = dc.id_cliente
GROUP BY dc.nombre_cliente
ORDER BY total_comprado DESC;
GO

-- 3. Top 5 productos por importe vendido
SELECT TOP 5
    dp.nombre_producto,
    SUM(f.importe_venta) AS total_vendido
FROM FactVentas f
INNER JOIN DimProducto dp
    ON f.id_producto = dp.id_producto
GROUP BY dp.nombre_producto
ORDER BY total_vendido DESC;
GO

-- 4. Ventas por año y mes
SELECT
    dt.anio,
    dt.nombre_mes,
    SUM(f.importe_venta) AS total_ventas
FROM FactVentas f
INNER JOIN DimTiempo dt
    ON f.id_tiempo = dt.id_tiempo
GROUP BY dt.anio, dt.mes, dt.nombre_mes
ORDER BY dt.anio, dt.mes;
GO

-- 5. Ventas por empleado
SELECT
    de.nombre_empleado,
    SUM(f.importe_venta) AS total_ventas
FROM FactVentas f
LEFT JOIN DimEmpleado de
    ON f.id_empleado = de.id_empleado
GROUP BY de.nombre_empleado
ORDER BY total_ventas DESC;
GO