"""Load cleaned international debt data into MySQL."""

from pathlib import Path
from getpass import getpass

import pandas as pd
import mysql.connector


PROJECT_DIR = Path(__file__).resolve().parent
DATABASE_NAME = "international_debt_analysis"
BATCH_SIZE = 5000
def read_debt_data():
    """Read the cleaned CSV and check its required fields."""

    file_path = PROJECT_DIR / "debt_all_indicators.csv"

    columns = [
        "country_code",
        "indicator_code",
        "year",
        "debt_value"
    ]

    debt = pd.read_csv(file_path, usecols=columns)
    debt = debt[columns]

    if debt.empty:
        raise ValueError("The debt CSV contains no records.")

    if debt[columns].isna().any().any():
        raise ValueError("Required fields contain missing values.")

    if debt.duplicated(
        subset=["country_code", "indicator_code", "year"]
    ).any():
        raise ValueError("Duplicate country-indicator-year records found.")
    debt["year"] = pd.to_numeric(
    debt["year"], errors="raise"
    )
    debt["debt_value"] = pd.to_numeric(
    debt["debt_value"], errors="raise"
    )

    if not debt["year"].between(2000, 2024).all():
        raise ValueError("Years must be between 2000 and 2024.")

    if (debt["year"] % 1 != 0).any():
        raise ValueError("Years must be whole numbers.")

    if not debt["debt_value"].map(
        lambda value: float("-inf") < value < float("inf")
    ).all():
        raise ValueError("Debt values must be finite numbers.")

    debt["year"] = debt["year"].astype(int)
    debt["debt_value"] = debt["debt_value"].astype(float)
    return debt


def connect_database():
    """Connect to the project's MySQL database."""
    username = input("MySQL username: ").strip()
    password = getpass("MySQL password: ")

    return mysql.connector.connect(
        host="localhost",
        user=username,
        password=password,
        database=DATABASE_NAME
    )
def validate_references(cursor, debt):
    """Check country and indicator codes before loading."""
    cursor.execute("SELECT country_code FROM countries")
    valid_countries = {row[0] for row in cursor.fetchall()}

    cursor.execute("SELECT indicator_code FROM indicators")
    valid_indicators = {row[0] for row in cursor.fetchall()}

    missing_countries = set(debt["country_code"]) - valid_countries
    missing_indicators = set(debt["indicator_code"]) - valid_indicators

    if missing_countries:
        raise ValueError(
            f"Unknown country codes: {sorted(missing_countries)}"
        )

    if missing_indicators:
        raise ValueError(
            f"Unknown indicator codes: {sorted(missing_indicators)}"
        )
def insert_debt_data(cursor, debt):
    """Insert debt records in batches, preserving existing records."""
    query = """
        INSERT INTO debt_observations
            (country_code, indicator_code, year, debt_value)
        VALUES (%s, %s, %s, %s)
        ON DUPLICATE KEY UPDATE
            debt_value = debt_observations.debt_value
    """

    for start in range(0, len(debt), BATCH_SIZE):
        batch = debt.iloc[start:start + BATCH_SIZE]
        records = list(batch.itertuples(index=False, name=None))

        cursor.executemany(query, records)

        processed = min(start + BATCH_SIZE, len(debt))
        print(f"Processed {processed:,} of {len(debt):,} records")
def main():
    """Read, validate and load the debt data."""
    debt = read_debt_data()
    print(f"CSV records: {len(debt):,}")

    connection = connect_database()
    cursor = None

    try:
        cursor = connection.cursor()

        validate_references(cursor, debt)
        insert_debt_data(cursor, debt)

        connection.commit()
        print("Loading completed. Database changes committed.")

    except Exception:
        connection.rollback()
        print("Loading failed. Database changes rolled back.")
        raise

    finally:
        if cursor is not None:
            cursor.close()
        connection.close()


if __name__ == "__main__":
    main()

