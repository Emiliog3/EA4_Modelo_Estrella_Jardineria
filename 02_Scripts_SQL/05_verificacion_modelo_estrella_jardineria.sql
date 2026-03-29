USE jardineria;
GO

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
  AND TABLE_NAME IN ('DimTiempo','DimProducto','DimCliente','DimEmpleado','DimEstadoPedido','FactVentas')
ORDER BY TABLE_NAME;
GO

SELECT 'DimTiempo' AS tabla, COUNT(*) AS cantidad FROM DimTiempo
UNION ALL
SELECT 'DimProducto', COUNT(*) FROM DimProducto
UNION ALL
SELECT 'DimCliente', COUNT(*) FROM DimCliente
UNION ALL
SELECT 'DimEmpleado', COUNT(*) FROM DimEmpleado
UNION ALL
SELECT 'DimEstadoPedido', COUNT(*) FROM DimEstadoPedido
UNION ALL
SELECT 'FactVentas', COUNT(*) FROM FactVentas;
GO
