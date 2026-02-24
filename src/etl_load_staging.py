import pandas as pd
import mysql.connector

DB_CONFIG = {
    "host": "localhost",
    "port": 13306,          
    "user": "root",
    "password": "root",
    "database": "staging_amazon",
}

CSV_PATH = "data/raw/amazon.csv"
TABLE_NAME = "stg_orders_raw"


STAGING_COLUMNS = [
    "order_id",
    "order_date",
    "status",
    "item_id",
    "sku",
    "qty_ordered",
    "price",
    "value",
    "discount_amount",
    "total",
    "category",
    "payment_method",
    "bi_st",
    "cust_id",
    "year",
    "month",
    "ref_num",
    "name_prefix",
    "first_name",
    "middle_initial",
    "last_name",
    "gender",
    "age",
    "full_name",
    "email",
    "sign_in_date",
    "phone_no",
    "place_name",
    "county",
    "city",
    "state",
    "zip",
    "region",
    "user_name",
    "discount_percent",
]


def get_connection():
    return mysql.connector.connect(**DB_CONFIG)


def normalize_columns(df: pd.DataFrame) -> pd.DataFrame:
    cols = (
        df.columns.astype(str)
        .str.strip()
        .str.lower()
        .str.replace(" ", "_", regex=False)
        .str.replace(".", "_", regex=False)
    )

    cols = cols.str.replace(r"_+", "_", regex=True)

    cols = cols.str.replace(r"^_+|_+$", "", regex=True)

    df.columns = cols
    return df


def apply_column_mapping(df: pd.DataFrame) -> pd.DataFrame:
    rename_map = {
        "e_mail": "email",
        "discount_percent": "discount_percent",  
    }

    if "phone_no_" in df.columns and "phone_no" not in df.columns:
        rename_map["phone_no_"] = "phone_no"

    df = df.rename(columns=rename_map)
    return df


def align_to_staging(df: pd.DataFrame) -> pd.DataFrame:
    missing = [c for c in STAGING_COLUMNS if c not in df.columns]
    if missing:
        raise ValueError(f"Faltan columnas para staging: {missing}")

    df = df[STAGING_COLUMNS].copy()
    return df


def insert_batches(df: pd.DataFrame, batch_size: int = 2000) -> None:
    conn = get_connection()
    cur = conn.cursor()

    cols_sql = ", ".join(STAGING_COLUMNS)
    placeholders = ", ".join(["%s"] * len(STAGING_COLUMNS))

    insert_sql = f"INSERT INTO {TABLE_NAME} ({cols_sql}) VALUES ({placeholders})"

    data = df.where(pd.notnull(df), None).values.tolist()

    print(f"Insertando {len(data)} filas en {TABLE_NAME} (batch_size={batch_size})")

    for i in range(0, len(data), batch_size):
        batch = data[i : i + batch_size]
        cur.executemany(insert_sql, batch)
        conn.commit()
        print(f"Insertadas {i + len(batch)} / {len(data)}")

    cur.close()
    conn.close()
    print("Carga a staging finalizada.")


def count_rows_in_table() -> int:
    conn = get_connection()
    cur = conn.cursor()
    cur.execute(f"SELECT COUNT(*) FROM {TABLE_NAME}")
    (cnt,) = cur.fetchone()
    cur.close()
    conn.close()
    return int(cnt)


def main():
    print(f"Leyendo CSV: {CSV_PATH}")
    df = pd.read_csv(CSV_PATH)

    print(f"Filas leídas: {len(df)}")
    print(f"Columnas originales: {list(df.columns)}")

    df = normalize_columns(df)
    df = apply_column_mapping(df)
    df = align_to_staging(df)

    print(f"Columnas listas para staging: {list(df.columns)}")

    before = count_rows_in_table()
    insert_batches(df)
    after = count_rows_in_table()

    inserted = after - before
    print(f"Filas antes: {before} | Filas después: {after} | Insertadas en esta corrida: {inserted}")

    if inserted != len(df):
        print("ATENCIÓN: insertadas != filas del CSV (puede haber fallas o duplicados).")
    else:
        print("Validación OK: insertadas == filas del CSV.")


if __name__ == "__main__":
    main()