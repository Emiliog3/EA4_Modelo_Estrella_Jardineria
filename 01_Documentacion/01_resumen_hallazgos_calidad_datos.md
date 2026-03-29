# Resumen de hallazgos de calidad de datos

## Proyecto
EA4 - Proyecto integrador - Repositorio de todas las actividades

## Base analizada
Jardineria

## Síntesis del análisis realizado
Se ejecutaron pruebas de calidad de datos sobre la base transaccional `jardineria` y sobre el modelo estrella de ventas construido en SQL Server. Las pruebas incluyeron revisión de valores nulos, duplicados, integridad referencial, consistencia temporal, rangos válidos y consistencia de medidas en la tabla de hechos.

## Hallazgos en la base transaccional
1. No se identificaron valores nulos en campos críticos de las tablas `cliente` y `producto`.
2. Se detectó un registro duplicado del cliente **Lasas S.A.** con el mismo teléfono y ciudad.
3. Se identificaron **4 pedidos con fechas inconsistentes**, en los que la fecha esperada es menor que la fecha del pedido.
4. Se identificaron **3 pedidos con estado Entregado pero sin fecha de entrega**.
5. No se evidenciaron precios negativos, stock negativo ni problemas de integridad referencial en las pruebas ejecutadas.

## Hallazgos en el modelo estrella
1. No se encontraron claves nulas en la tabla `FactVentas`.
2. No se encontraron medidas nulas en la tabla `FactVentas`.
3. No se detectaron cantidades inválidas, precios inválidos ni importes negativos.
4. No se encontraron inconsistencias entre `importe_venta` y el cálculo `cantidad * precio_unidad`.
5. No se evidenciaron problemas de integridad referencial entre la tabla de hechos y las dimensiones evaluadas.
6. No se identificaron duplicados potenciales en la combinación `id_pedido_origen` + `id_detalle_origen`.

## Conclusión
La base transaccional presenta algunas anomalías de calidad, especialmente en duplicidad de clientes y consistencia temporal de pedidos. Sin embargo, el modelo estrella construido presenta una estructura consistente y limpia para fines analíticos, lo cual evidencia un proceso adecuado de transformación y carga de datos.
