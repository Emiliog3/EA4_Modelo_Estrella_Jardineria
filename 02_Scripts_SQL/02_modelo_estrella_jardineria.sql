USE jardineria;
GO

/* =========================================================
MODELO ESTRELLA - DATA MART DE VENTAS JARDINERIA
Grano: 1 fila = 1 línea de pedido ENTREGADO
========================================================= */

DROP TABLE IF EXISTS FactVentas;

DROP TABLE IF EXISTS DimEstadoPedido;

DROP TABLE IF EXISTS DimEmpleado;

DROP TABLE IF EXISTS DimCliente;

DROP TABLE IF EXISTS DimProducto;

DROP TABLE IF EXISTS DimTiempo;
GO

CREATE TABLE DimTiempo (
    id_tiempo INT NOT NULL PRIMARY KEY,
    fecha DATE NOT NULL,
    anio INT NOT NULL,
    trimestre INT NOT NULL,
    mes INT NOT NULL,
    nombre_mes VARCHAR(20) NOT NULL,
    dia INT NOT NULL
);
GO

CREATE TABLE DimProducto (
    id_producto INT NOT NULL PRIMARY KEY,
    codigo_producto VARCHAR(15) NOT NULL,
    nombre_producto VARCHAR(70) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    proveedor VARCHAR(50) NULL,
    dimensiones VARCHAR(25) NULL,
    precio_venta DECIMAL(15, 2) NOT NULL,
    cantidad_en_stock SMALLINT NOT NULL
);
GO

CREATE TABLE DimCliente (
    id_cliente INT NOT NULL PRIMARY KEY,
    nombre_cliente VARCHAR(50) NOT NULL,
    nombre_contacto VARCHAR(70) NULL,
    ciudad VARCHAR(50) NOT NULL,
    region VARCHAR(50) NULL,
    pais VARCHAR(50) NULL,
    codigo_postal VARCHAR(10) NULL,
    limite_credito DECIMAL(15, 2) NULL
);
GO

CREATE TABLE DimEmpleado (
    id_empleado INT NOT NULL PRIMARY KEY,
    nombre_empleado VARCHAR(120) NOT NULL,
    puesto VARCHAR(50) NULL,
    email VARCHAR(100) NOT NULL,
    codigo_oficina VARCHAR(10) NOT NULL,
    ciudad_oficina VARCHAR(30) NOT NULL,
    pais_oficina VARCHAR(50) NOT NULL
);
GO

CREATE TABLE DimEstadoPedido (
    id_estado INT IDENTITY (1, 1) PRIMARY KEY,
    estado VARCHAR(15) NOT NULL
);
GO

CREATE TABLE FactVentas (
    id_fact_venta INT IDENTITY (1, 1) PRIMARY KEY,
    id_tiempo INT NOT NULL,
    id_producto INT NOT NULL,
    id_cliente INT NOT NULL,
    id_empleado INT NULL,
    id_estado INT NOT NULL,
    id_pedido_origen INT NOT NULL,
    id_detalle_origen INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unidad DECIMAL(15, 2) NOT NULL,
    importe_venta DECIMAL(15, 2) NOT NULL,
    CONSTRAINT FK_FactVentas_DimTiempo FOREIGN KEY (id_tiempo) REFERENCES DimTiempo (id_tiempo),
    CONSTRAINT FK_FactVentas_DimProducto FOREIGN KEY (id_producto) REFERENCES DimProducto (id_producto),
    CONSTRAINT FK_FactVentas_DimCliente FOREIGN KEY (id_cliente) REFERENCES DimCliente (id_cliente),
    CONSTRAINT FK_FactVentas_DimEmpleado FOREIGN KEY (id_empleado) REFERENCES DimEmpleado (id_empleado),
    CONSTRAINT FK_FactVentas_DimEstado FOREIGN KEY (id_estado) REFERENCES DimEstadoPedido (id_estado)
);
GO

/* =========================
CARGA DE DIMENSIONES
========================= */

INSERT INTO
    DimTiempo (
        id_tiempo,
        fecha,
        anio,
        trimestre,
        mes,
        nombre_mes,
        dia
    )
SELECT DISTINCT
    CONVERT(
        INT,
        CONVERT(CHAR(8), p.fecha_pedido, 112)
    ) AS id_tiempo,
    p.fecha_pedido AS fecha,
    YEAR(p.fecha_pedido) AS anio,
    DATEPART (QUARTER, p.fecha_pedido) AS trimestre,
    MONTH(p.fecha_pedido) AS mes,
    CASE MONTH(p.fecha_pedido)
        WHEN 1 THEN 'Enero'
        WHEN 2 THEN 'Febrero'
        WHEN 3 THEN 'Marzo'
        WHEN 4 THEN 'Abril'
        WHEN 5 THEN 'Mayo'
        WHEN 6 THEN 'Junio'
        WHEN 7 THEN 'Julio'
        WHEN 8 THEN 'Agosto'
        WHEN 9 THEN 'Septiembre'
        WHEN 10 THEN 'Octubre'
        WHEN 11 THEN 'Noviembre'
        WHEN 12 THEN 'Diciembre'
    END AS nombre_mes,
    DAY(p.fecha_pedido) AS dia
FROM pedido p;
GO

INSERT INTO
    DimProducto (
        id_producto,
        codigo_producto,
        nombre_producto,
        categoria,
        proveedor,
        dimensiones,
        precio_venta,
        cantidad_en_stock
    )
SELECT p.ID_producto, p.CodigoProducto, p.nombre, cp.Desc_Categoria, p.proveedor, p.dimensiones, CAST(
        p.precio_venta AS DECIMAL(15, 2)
    ), p.cantidad_en_stock
FROM
    producto p
    INNER JOIN Categoria_producto cp ON p.Categoria = cp.Id_Categoria;
GO

INSERT INTO
    DimCliente (
        id_cliente,
        nombre_cliente,
        nombre_contacto,
        ciudad,
        region,
        pais,
        codigo_postal,
        limite_credito
    )
SELECT
    c.ID_cliente,
    c.nombre_cliente,
    LTRIM(
        RTRIM(
            ISNULL(c.nombre_contacto, '') + ' ' + ISNULL(c.apellido_contacto, '')
        )
    ) AS nombre_contacto,
    c.ciudad,
    c.region,
    c.pais,
    c.codigo_postal,
    CAST(
        c.limite_credito AS DECIMAL(15, 2)
    )
FROM cliente c;
GO

INSERT INTO
    DimEmpleado (
        id_empleado,
        nombre_empleado,
        puesto,
        email,
        codigo_oficina,
        ciudad_oficina,
        pais_oficina
    )
SELECT e.ID_empleado, LTRIM(
        RTRIM(
            e.nombre + ' ' + e.apellido1 + ' ' + ISNULL(e.apellido2, '')
        )
    ) AS nombre_empleado, e.puesto, e.email, o.Descripcion, o.ciudad, o.pais
FROM empleado e
    INNER JOIN oficina o ON e.ID_oficina = o.ID_oficina;
GO

INSERT INTO
    DimEstadoPedido (estado)
SELECT DISTINCT
    p.estado
FROM pedido p;
GO

/* =========================
CARGA DE TABLA DE HECHOS
SOLO PEDIDOS ENTREGADOS
========================= */

INSERT INTO
    FactVentas (
        id_tiempo,
        id_producto,
        id_cliente,
        id_empleado,
        id_estado,
        id_pedido_origen,
        id_detalle_origen,
        cantidad,
        precio_unidad,
        importe_venta
    )
SELECT
    CONVERT(
        INT,
        CONVERT(CHAR(8), p.fecha_pedido, 112)
    ) AS id_tiempo,
    dp.ID_producto,
    p.ID_cliente,
    c.ID_empleado_rep_ventas,
    de.id_estado,
    p.ID_pedido,
    dp.ID_detalle_pedido,
    dp.cantidad,
    CAST(
        dp.precio_unidad AS DECIMAL(15, 2)
    ),
    CAST(
        dp.cantidad * dp.precio_unidad AS DECIMAL(15, 2)
    ) AS importe_venta
FROM
    detalle_pedido dp
    INNER JOIN pedido p ON dp.ID_pedido = p.ID_pedido
    INNER JOIN cliente c ON p.ID_cliente = c.ID_cliente
    INNER JOIN DimEstadoPedido de ON p.estado = de.estado
WHERE
    p.estado = 'Entregado';
GO

/* =========================
CONSULTAS DE VALIDACION
========================= */

-- 1. Producto más vendido
SELECT
    TOP 1 dp.nombre_producto,
    SUM(f.cantidad) AS total_unidades_vendidas
FROM FactVentas f
    INNER JOIN DimProducto dp ON f.id_producto = dp.id_producto
GROUP BY
    dp.nombre_producto
ORDER BY total_unidades_vendidas DESC;
GO

-- 2. Categoría con más productos
SELECT
    TOP 1 categoria,
    COUNT(*) AS total_productos
FROM DimProducto
GROUP BY
    categoria
ORDER BY total_productos DESC;
GO

-- 3. Año con más ventas
SELECT TOP 1 dt.anio, SUM(f.importe_venta) AS total_ventas
FROM FactVentas f
    INNER JOIN DimTiempo dt ON f.id_tiempo = dt.id_tiempo
GROUP BY
    dt.anio
ORDER BY total_ventas DESC;
GO

/* =========================
CONSULTA GENERAL DEL MODELO
========================= */
SELECT f.id_fact_venta, dt.fecha, dt.anio, dp.nombre_producto, dp.categoria, dc.nombre_cliente, de.nombre_empleado, f.cantidad, f.precio_unidad, f.importe_venta
FROM
    FactVentas f
    INNER JOIN DimTiempo dt ON f.id_tiempo = dt.id_tiempo
    INNER JOIN DimProducto dp ON f.id_producto = dp.id_producto
    INNER JOIN DimCliente dc ON f.id_cliente = dc.id_cliente
    LEFT JOIN DimEmpleado de ON f.id_empleado = de.id_empleado;
GO