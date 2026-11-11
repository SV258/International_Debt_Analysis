# International Debt Analysis

An end-to-end analysis of World Bank International Debt Statistics using Python, MySQL and Power BI.

**Author:** Suganthi Veeraraju

## Project objective

Explore external debt across reporting countries, compare country debt levels and examine trends from 2000 to 2024. The main external debt indicator is `DT.DOD.DECT.CD` (external debt stocks, total, current US dollars).

## Tools

- Python and Pandas for data inspection, cleaning and transformation
- Matplotlib, Seaborn and Plotly for visualizations
- MySQL and MySQL Connector/Python for database loading and SQL analysis
- Power BI for interactive dashboards
- VS Code and Jupyter notebooks for development

## Workflow

1. Read the World Bank IDS data and country metadata CSV files.
2. Inspect missing values, duplicates and data types.
3. Reshape year columns into a long-format dataset.
4. Prepare country, indicator and debt observation data for analysis.
5. Load prepared data into MySQL.
6. Analyze the data using 30 SQL queries: 10 basic, 10 intermediate and 10 advanced.
7. Create Python visualizations and a three-page Power BI report.

## Analysis included

- Top countries by external debt in 2024
- External debt trends from 2000 to 2024
- China and India debt comparisons and annual growth
- Regional debt comparisons for 2020
- Country shares, rankings and debt stock indicator comparisons
- SQL joins, aggregations, subqueries, CTEs, window functions and a view

## Power BI dashboard

The report contains four pages with year filters and dynamic titles.

### Debt Overview

![Debt Overview](../screenshots/Debt_Overview.png)

### Debt Trends Analysis

![Debt Trends Analysis](../screenshots/Debt_Trends_Analysis.png)

### Country Debt Analysis

![Country Debt Analysis](../screenshots/Country_Debt_Analysis.png)

### Indicator Analysis

![Indicator Analysis](../screenshots/Indicator_Analysis.png)

## Main filess

| File | Purpose |
| --- | --- |
| `International_Debt_Analysis_GitHub.ipynb` | Python cleaning, analysis, database queries and visualizations |
| `SQL queries project 2.sql` | 30 SQL analysis queries |
| `validation_queries.sql` | Database validation queries |
| `load_debt_data.py` | Database loading script |
| `International_Debt_Analysis.pbix` | Power BI report |
| `IDS_ALLCountries_Data.csv` | Source IDS observations |
| `IDS_CountryMetaData.csv` | Source country metadata |
| `international_debt_powerbi.csv` | Prepared data for Power BI |
| `screenshots/` | Dashboard preview images |

## Running the project

1. Install Python and the required packages:

   ```bash
   pip install pandas matplotlib seaborn plotly mysql-connector-python ipykernel
   ```

2. Keep the notebook and its required CSV files together in the project folder.
3. Open the notebook in VS Code or Jupyter and select the Python environment containing these packages.
4. For database sections, start MySQL and prepare the `international_debt_analysis` database with its tables and data. The SQL analysis uses `countries`, `indicators` and `debt_observations`.
5. Review `load_debt_data.py` and configure the connection for your own MySQL installation before using it. The notebook prompts for MySQL credentials.
6. Run notebook cells in order. Database query cells require the populated database.
7. Open the `.pbix` file in Power BI Desktop. If necessary, update CSV source paths in Power Query before refreshing.

## Interpretation notes

- Debt stocks are balances at a point in time. Summing balances across years does not represent new borrowing.
- Country coverage varies by year; totals reflect available observations rather than all countries worldwide.
- Debt indicators can overlap and use different units. Compare compatible indicators and avoid adding overlapping components.
- Missing observations do not necessarily mean zero debt.
- Historical trend analysis focuses on 2000–2024; later source years are outside this project's historical comparison.

## Data source

World Bank International Debt Statistics (IDS), using CSV files supplied for the project. Data reflects the supplied dataset and is not a live feed.
