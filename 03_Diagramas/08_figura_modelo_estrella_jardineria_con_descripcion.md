# Figura 08. Modelo estrella propuesto para el data mart de ventas de Jardinería con descripción de campos

```mermaid
erDiagram

    DimTiempo {
        INT id_tiempo PK "Clave primaria de la dimensión tiempo en formato YYYYMMDD"
        DATE fecha "Fecha del pedido registrada en la venta"
        INT anio "Año correspondiente a la transacción"
        INT trimestre "Trimestre del año de la transacción"
        INT mes "Número del mes de la transacción"
        VARCHAR nombre_mes "Nombre del mes en texto"
        INT dia "Día del mes en que se realizó el pedido"
    }

    DimProducto {
        INT id_producto PK "Clave primaria del producto"
        VARCHAR codigo_producto "Código original del producto en la base transaccional"
        VARCHAR nombre_producto "Nombre comercial del producto"
        VARCHAR categoria "Categoría a la que pertenece el producto"
        VARCHAR proveedor "Proveedor asociado al producto"
        VARCHAR dimensiones "Dimensiones o presentación del producto"
        DECIMAL precio_venta "Precio unitario de venta del producto, definido como DECIMAL(15,2)"
        SMALLINT cantidad_en_stock "Cantidad disponible en inventario"
    }

    DimCliente {
        INT id_cliente PK "Clave primaria del cliente"
        VARCHAR nombre_cliente "Nombre o razón social del cliente"
        VARCHAR nombre_contacto "Nombre completo del contacto del cliente"
        VARCHAR ciudad "Ciudad donde se ubica el cliente"
        VARCHAR region "Región o departamento del cliente"
        VARCHAR pais "País del cliente"
        VARCHAR codigo_postal "Código postal del cliente"
        DECIMAL limite_credito "Límite de crédito asignado al cliente, definido como DECIMAL(15,2)"
    }

    DimEmpleado {
        INT id_empleado PK "Clave primaria del empleado"
        VARCHAR nombre_empleado "Nombre completo del empleado asociado a la venta"
        VARCHAR puesto "Cargo o puesto del empleado"
        VARCHAR email "Correo electrónico del empleado"
        VARCHAR codigo_oficina "Código de la oficina donde trabaja el empleado"
        VARCHAR ciudad_oficina "Ciudad de la oficina del empleado"
        VARCHAR pais_oficina "País de la oficina del empleado"
    }

    DimEstadoPedido {
        INT id_estado PK "Clave primaria del estado del pedido"
        VARCHAR estado "Nombre del estado del pedido"
    }

    FactVentas {
        INT id_fact_venta PK "Clave primaria de la tabla de hechos"
        INT id_tiempo FK "Llave foránea hacia la dimensión tiempo"
        INT id_producto FK "Llave foránea hacia la dimensión producto"
        INT id_cliente FK "Llave foránea hacia la dimensión cliente"
        INT id_empleado FK "Llave foránea hacia la dimensión empleado"
        INT id_estado FK "Llave foránea hacia la dimensión estado del pedido"
        INT id_pedido_origen "Identificador del pedido en la base transaccional"
        INT id_detalle_origen "Identificador del detalle del pedido en la base origen"
        INT cantidad "Cantidad de unidades vendidas"
        DECIMAL precio_unidad "Precio unitario registrado en la venta, definido como DECIMAL(15,2)"
        DECIMAL importe_venta "Valor total de la línea de venta, definido como DECIMAL(15,2)"
    }

    DimTiempo ||--o{ FactVentas : clasifica
    DimProducto ||--o{ FactVentas : describe
    DimCliente ||--o{ FactVentas : compra
    DimEmpleado ||--o{ FactVentas : vende
    DimEstadoPedido ||--o{ FactVentas : estado