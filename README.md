# Pairs Trading (Long/Short) — Reducing Systemic Market Risk with Quantitative Methods

Capstone project exploring **Pairs Trading / Long & Short** in the Brazilian equity market, aiming to **reduce systemic (market-wide) exposure** by operating on the **spread** between two related assets.

> **Core idea:** hold a **long** position in one asset and a **short** position in another related asset. Profit/loss is driven primarily by changes in the **spread**, not by the overall market direction.

---

## 1) Problem & Motivation

Brazil is a highly volatile emerging market. The local equity market has faced multiple internal/external crises (e.g., 2008, 2009, 2012, 2015, 2018, 2020), which makes it hard to sustain consistent returns without carrying substantial market risk.

This project investigates whether the market has enough **structure and relationships** (correlations, sector dynamics, economic connections) to support a systematic Long/Short approach.

---

## 2) Scope

This repository focuses on:

- Building a workable equity universe for Long/Short in Brazil
- Defining variables and filters relevant to real-world execution (especially **liquidity**)
- Conducting **Exploratory Data Analysis (EDA)** to validate that relationships exist (a prerequisite for pairs trading)

> Note: the dataset and EDA prepare the ground for full trading rules/backtests (see “Next Steps”).

---

## 3) Data Sources

Data was assembled from the following sources:

- **Yahoo Finance** (historical prices)
- **Alpha Vantage** (auxiliary market data)
- **Status Invest** (market/company attributes)
- **B3** (sector/subsector classification)

---

## 4) Key Variables (Features)

Primary variables for assessing relationships between assets:

- **Close price** and **Adjusted Close**
- **Returns** (daily % change derived from price series)
- **Time** (the relationship is evaluated as a time series)
- **Sector / Subsector / Segment** (economic causal context)
- **Connected tickers** (e.g., companies with common ON/PN structures)

---

## 5) Universe & Filters

### Market overview (before filtering)
- ~**400 companies**
- **573** listed assets (tickers)
- Price range: **R$0.57 to R$592.63**
- Market cap range: **R$4M to R$597B**
- Daily liquidity range: **R$1K to R$3B**
- Companies classified into **11 sectors** and **41 subsectors**

### Data quality issue (missing data)
Between **Jan/2018 and Jun/2019**, Yahoo Finance presented ~**18% missing data**, mainly due to:
- Market holidays (no trading)
- Recently listed stocks (incomplete history)
- Delisted companies
- Low-liquidity assets (sparse history)

### Practical filters (execution-oriented)
To support a realistic Long/Short setup (including borrow availability), the dataset was filtered by:
- Removing assets with **incomplete history** due to missing data
- Removing assets with **average daily liquidity < R$15M**

**Result after filtering**
- From **~400 companies** → **~130 companies**
- From **573 tickers** → **~135 tickers**

---

## 6) Exploratory Analysis (What Was Tested)

### 6.1 Market volatility (why Long/Short matters here)
Using IBOV (Jan/2018 → Jun/2021), the analysis highlights high volatility and tail events, especially around March/2020 (pandemic shock).

Annualized volatility estimates:
- **2018:** 22.26%
- **2019:** 18.03%
- **2020:** 45.13%
- **2021:** 21.26%

### 6.2 Company characteristics (pre vs post filter)
The post-filter universe preserves companies across most sizes, but removes very small caps with insufficient trading activity.

Classifications used:
- **Market Cap:** Nano, Micro, Small, Mid, Large, Mega
- **Liquidity buckets:** up to 250k … above 15M (study focus)

### 6.3 Relationship evidence (necessary condition for pairs)
The EDA looks for “signals” that relationships exist:

- **Returns co-movement:** periods where assets move together (up or down), often in different magnitudes → potential spread opportunities
- **Correlation heatmap:**
  - No strong negative correlations observed
  - Many assets show high correlation even over multi-year periods
  - Correlations observed roughly between **0.56 and 0.97**
- **Economic ties:**
  - Companies with both **common (ON)** and **preferred (PN)** shares (direct structural connection)
  - Sector and subsector groupings (shared market pressures)

Sector counts example (post-filter, indicative):
- Consumo Cíclico, Financeiro, Utilidade Pública, Bens Industriais, Materiais Básicos, etc.

Top subsectors example:
- Energia Elétrica, Construção Civil, Intermediários Financeiros, Comércio, Transporte, etc.

---

## 7) What You Can Expect in This Repo

R Codes and data.

---

## 8) Author

**Cassiano Cavalcanti**  
Capstone: *Pairs Trading — Reducing systemic market risk through quantitative Long & Short methods*

