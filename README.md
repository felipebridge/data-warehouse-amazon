# Data Warehouse Amazon

![PowerBI Dashboard](docs/dashboard%20BI/Panel%20Ejecutivo%20(1).png)

Proyecto Data Warehouse utilizando:

- Python (ETL)
- MySQL (OLTP + Data Warehouse)
- Power BI (explotación OLAP)
- Docker (infraestructura reproducible)

---

## Star Schema
![Star Schema](docs/star%20schema/Star%20Schema.png)

---

## Objetivo

Construir un Data Warehouse a partir de un dataset de e-commerce
para analizar:

- Ingresos
- Descuentos
- Unidades vendidas
- Comportamiento por producto
- Comportamiento por cliente
- Análisis geográfico
- Análisis temporal

El modelo se explota mediante herramientas OLAP (Power BI).

---

## Arquitectura General

1. Dataset CSV (Amazon Sales)
2. Staging Layer (MySQL)
3. OLTP Model (3NF)
4. Data Warehouse (Star Schema)
5. Power BI (Visualización)

---

##  Infraestructura

El proyecto utiliza Docker para levantar MySQL.

