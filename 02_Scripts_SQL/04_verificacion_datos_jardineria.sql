USE jardineria;
GO

SELECT 'oficina' AS tabla, COUNT(*) AS cantidad FROM oficina
UNION ALL
SELECT 'empleado', COUNT(*) FROM empleado
UNION ALL
SELECT 'Categoria_producto', COUNT(*) FROM Categoria_producto
UNION ALL
SELECT 'cliente', COUNT(*) FROM cliente
UNION ALL
SELECT 'pedido', COUNT(*) FROM pedido
UNION ALL
SELECT 'producto', COUNT(*) FROM producto
UNION ALL
SELECT 'detalle_pedido', COUNT(*) FROM detalle_pedido
UNION ALL
SELECT 'pago', COUNT(*) FROM pago;