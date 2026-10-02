# 🍲 Local Food Wastage Management System

An end-to-end data analytics and business intelligence platform designed to reduce municipal food waste by systematically connecting commercial surplus food generators with local relief beneficiaries (NGOs, shelters, charities).

![Streamlit Executive Dashboard](Streamlit%20Screenshot.png)

---

## 📌 Project Overview

Food wastage represents a critical logistical, economic, and humanitarian challenge coexisting with local food insecurity. This project implements a full-stack data solution featuring:
- **Normalized Relational Database (3NF):** Managing 4,000 records across 4 interconnected tables (`providers`, `receivers`, `food_listings`, and `claims`).
- **Data Cleansing Pipeline:** Resolving multi-line RFC-4180 parsing issues and ensuring atomic batch imports.
- **15 Business Intelligence SQL Queries:** Evaluating supplier velocity, regional distribution bottlenecks, and fulfillment ratios.
- **Interactive Streamlit Web Dashboard:** Delivering real-time executive KPI metrics, interactive Plotly visualizations, dynamic inventory filtering, and full CRUD management.

---

## 📊 Key Metrics & Achievements

- **Total Available Food Units Tracked:** `25,794 units`
- **Total Food Listings:** `1,000 listings`
- **Registered Donors:** `1,000 entities` (Restaurants, Supermarkets, Caterers, Grocery Stores)
- **Registered Receivers:** `1,000 organizations` (NGOs, Shelters, Charities, Individuals)
- **Claim Fulfillment Rate:** `33.9% Completed` | `32.5% Pending` | `33.6% Cancelled`
- **Primary Food Donors:** Restaurants (6,923 units) and Supermarkets (6,696 units) account for **>52%** of surplus volume.

---

## 🛠️ Technology Stack

| Layer | Tools & Libraries |
| :--- | :--- |
| **Database** | MySQL Server 8.0, MySQL Workbench, SQLite3 |
| **Language** | Python 3.10+ |
| **Web Framework** | Streamlit |
| **Data Analysis** | Pandas, Regular Expressions (`re`) |
| **Visualization** | Plotly Express |
| **Version Control** | Git, GitHub |

---

## 🗄️ Database Architecture (3NF Schema)
┌─────────────────┐       ┌───────────────────────┐       ┌─────────────────┐
│    providers    │ 1   * │     food_listings     │ 1   * │     claims      │
├─────────────────┤───────├───────────────────────┤───────├─────────────────┤
│ PK Provider_ID  │       │ PK Food_ID            │       │ PK Claim_ID     │
│    Name         │       │    Food_Name          │       │ FK Food_ID      │
│    Type         │       │    Quantity           │       │ FK Receiver_ID  │
│    Address      │       │    Expiry_Date        │       │    Status       │
│    City         │       │ FK Provider_ID        │       │    Timestamp    │
│    Contact      │       │    Provider_Type      │       └─────────────────┘
└─────────────────┘       │    Location           │                *
│    Food_Type          │                │ 1
│    Meal_Type          │       ┌─────────────────┐
└───────────────────────┘       │    receivers    │
├─────────────────┤
│ PK Receiver_ID  │
│    Name         │
│    Type         │
│    City         │
│    Contact      │
└─────────────────┘


---

## 💻 Visual Evidence & Application Modules

### 1. Executive Management Dashboard
Live KPI tracking cards displaying total available food volume (25,794 units) alongside interactive Plotly charts showing volume contributions by provider type and claim status distributions.
![Executive Dashboard](Streamlit%20Screenshot.png)

### 2. Search, Filter & Claim Portal
Multi-criteria cascading filters across City/Location, Dietary Food Type (Vegan, Vegetarian, Non-Vegetarian), and Meal Type, linked to an in-app claim placement engine.
![Search & Claim Portal](Streamlit%20Screenshot%202.png)

### 3. Interactive 15 SQL Business Insights Console
Real-time query execution interface allowing business analysts to run all 15 project queries with syntax-highlighted SQL code alongside live result tables.
![15 SQL Business Queries](Streamlit%20Screenshot%203.png)

### 4. Community Directory
Dual-panel operational directory displaying verified donor contacts and beneficiary organizations for rapid offline coordination.
![Community Directory](Streamlit%20screenshot%204.png)

---

## 📑 15 Core SQL Business Queries & Strategic Insights

| # | Business Problem / Focus | Analytical SQL Statement | Key Strategic Finding |
|---|---|---|---|
| **Q1** | Provider & Receiver Density by City | `SELECT p.City, COUNT(DISTINCT p.Provider_ID), COUNT(DISTINCT r.Receiver_ID)...` | Identifies major hubs (South Christopherborough, New Carol) needing receiver onboarding. |
| **Q2** | Surplus Food Contribution by Provider | `SELECT Provider_Type, SUM(Quantity), COUNT(Food_ID) FROM food_listings...` | Restaurants (6,923 units) and Supermarkets (6,696) contribute over 52% of surplus. |
| **Q3** | Provider Contact Dispatch Directory | `SELECT Name, Type, Address, City, Contact FROM providers...` | Provides verified phone numbers and addresses for daily transport dispatch. |
| **Q4** | Top Food Claiming Beneficiaries | `SELECT r.Name, r.Type, COUNT(c.Claim_ID), SUM(f.Quantity)...` | Reveals high-capacity NGO partners capable of absorbing large donation batches. |
| **Q5** | Total Available Food Inventory | `SELECT SUM(Quantity), COUNT(Food_ID) FROM food_listings;` | Verifies 25,794 surplus units available across 1,000 listings (mean: 25.79 units/batch). |
| **Q6** | City with Highest Food Listings | `SELECT Location, COUNT(Food_ID), SUM(Quantity) GROUP BY Location...` | Maps high-density supply zones to optimize cold-storage warehouse placement. |
| **Q7** | Most Common Available Food Types | `SELECT Food_Type, COUNT(Food_ID), SUM(Quantity) GROUP BY Food_Type...` | Balanced supply: Vegan (8,798 units), Non-Veg (8,656 units), Vegetarian (8,340 units). |
| **Q8** | Claim Demand Velocity by Food Item | `SELECT f.Food_Name, COUNT(c.Claim_ID) GROUP BY f.Food_Name...` | High-frequency staples (Rice, Bread, Pasta) experience highest turnover velocity. |
| **Q9** | Highest Successful Claim Providers | `SELECT p.Name, p.Type, COUNT(c.Claim_ID) WHERE c.Status='Completed'...` | Recognizes high-reliability commercial partners for CSR certification. |
| **Q10** | Claim Status Breakdown (%) | `SELECT Status, COUNT(Claim_ID), ROUND(COUNT(*)*100.0/1000, 2)...` | Completed: 33.9% (339), Cancelled: 33.6% (336), Pending: 32.5% (325). |
| **Q11** | Average Quantity Claimed per Receiver | `SELECT r.Name, ROUND(AVG(f.Quantity), 2) WHERE c.Status='Completed'...` | Distinguishes bulk institutional distributors (shelters) from individual household claims. |
| **Q12** | Most Claimed Meal Category | `SELECT f.Meal_Type, COUNT(c.Claim_ID) GROUP BY f.Meal_Type...` | Snacks (6,693 units) and Breakfast (6,667 units) lead in overall claim demand. |
| **Q13** | Cumulative Food Donated by Provider | `SELECT p.Name, p.City, SUM(f.Quantity) GROUP BY p.Name, p.City...` | Produces quantitative audit trails required for corporate tax deductions. |
| **Q14** | Urgent Near-Expiry Redistribution | `SELECT Food_Name, Expiry_Date, Location, Quantity ORDER BY Expiry_Date ASC...` | Powers frontend urgency alerts, dispatching foods expiring within 24-48 hours. |
| **Q15** | City-Wise Distribution Efficiency | `SELECT p.City, COUNT(DISTINCT f.Food_ID), COUNT(DISTINCT c.Claim_ID)...` | Evaluates supply-demand throughput, showing listings vs. actual processed claims. |

---

