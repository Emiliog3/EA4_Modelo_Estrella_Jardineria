# Figura 1. Modelo estrella propuesto para el data mart de ventas de Jardinería

```mermaid
erDiagram

    DimTiempo {
        INT id_tiempo PK
        DATE fecha
        INT anio
        INT trimestre
        INT mes
        VARCHAR nombre_mes
        INT dia
    }

    DimProducto {
        INT id_producto PK
        VARCHAR codigo_producto
        VARCHAR nombre_producto
        VARCHAR categoria
        VARCHAR proveedor
        VARCHAR dimensiones
        DECIMAL precio_venta
        SMALLINT cantidad_en_stock
    }

    DimCliente {
        INT id_cliente PK
        VARCHAR nombre_cliente
        VARCHAR nombre_contacto
        VARCHAR ciudad
        VARCHAR region
        VARCHAR pais
        VARCHAR codigo_postal
        DECIMAL limite_credito
    }

    DimEmpleado {
        INT id_empleado PK
        VARCHAR nombre_empleado
        VARCHAR puesto
        VARCHAR email
        VARCHAR codigo_oficina
        VARCHAR ciudad_oficina
        VARCHAR pais_oficina
    }

    DimEstadoPedido {
        INT id_estado PK
        VARCHAR estado
    }

    FactVentas {
        INT id_fact_venta PK
        INT id_tiempo FK
        INT id_producto FK
        INT id_cliente FK
        INT id_empleado FK
        INT id_estado FK
        INT id_pedido_origen
        INT id_detalle_origen
        INT cantidad
        DECIMAL precio_unidad
        DECIMAL importe_venta
    }

    DimTiempo ||--o{ FactVentas : "clasifica"
    DimProducto ||--o{ FactVentas : "describe"
    DimCliente ||--o{ FactVentas : "compra"
    DimEmpleado ||--o{ FactVentas : "vende"
    DimEstadoPedido ||--o{ FactVentas : "estado"