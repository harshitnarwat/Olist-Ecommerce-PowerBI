# Olist E-Commerce Analytics — Power BI

## 📊 Project Overview

An end-to-end e-commerce analytics project built using the Brazilian Olist e-commerce dataset.

The project combines Python, MySQL, SQL, DAX, and Power BI to transform raw e-commerce data into an interactive business intelligence dashboard.

The analysis focuses on sales performance, customers, products, payments, delivery performance, sellers, and customer satisfaction.

---

## 🎯 Project Objectives

- Analyze overall sales and order performance
- Understand customer purchasing behavior
- Identify high-performing product categories
- Analyze payment methods and installment behavior
- Evaluate delivery performance and delays
- Compare seller performance
- Analyze customer reviews and satisfaction
- Build an interactive Power BI dashboard for business insights

---

## 🛠️ Tools & Technologies

| Tool / Technology | Purpose |
|---|---|
| Power BI | Interactive dashboard and data visualization |
| DAX | Measures and business calculations |
| SQL / MySQL | Data analysis, validation, and querying |
| Python | Data loading and database connectivity |
| Pandas | Data handling and preprocessing |
| SQLAlchemy | Python–MySQL connectivity |
| PyMySQL | MySQL database driver |
| GitHub | Project documentation and version control |

---

## 🔄 Project Workflow

Olist CSV Dataset
        ↓
Python
        ↓
MySQL
        ↓
SQL
        ↓
Power BI
        ↓
Interactive Business Intelligence Dashboard

---

## 📁 Dataset

The project uses the Olist Brazilian e-commerce dataset containing information about:

- Customers
- Orders
- Order Items
- Payments
- Reviews
- Products
- Sellers
- Geolocation
- Product Category Translation

The raw CSV datasets are not included in this repository.

---

## 🐍 Python Data Pipeline

Python was used to load the Olist CSV datasets into MySQL and establish the database workflow.

The Python scripts include:

- Loading CSV files into MySQL tables
- Converting relevant date columns into datetime format
- Creating the MySQL database connection
- Testing the MySQL connection
- Loading data efficiently in chunks

The GitHub versions of the scripts do not contain actual database credentials.

---

## 🗄️ MySQL Database

The Olist datasets were loaded into MySQL as separate tables.

### Main Tables

- customers
- geolocation
- order_items
- order_payments
- order_reviews
- orders
- products
- sellers
- category_translation

MySQL was used as the analytical database layer before performing SQL analysis and connecting the results to the Power BI workflow.

---

## 🔍 SQL Analysis

The SQL analysis covers multiple areas of the Olist business.

### Data Validation

- Database and table inspection
- Data integrity checks
- Relationship and key validation
- Duplicate and consistency checks

### Sales & Orders

- Overall orders
- Revenue analysis
- Order status analysis
- Average order value
- Minimum and maximum order values
- Order-value distribution
- Median order value

### Product Analysis

- Product-category performance
- Revenue by category
- Category-level business performance

### Customer Analysis

- Customer purchasing behavior
- Top customers
- Repeat customers
- Customer order frequency

### Geographic Analysis

- State-wise performance
- Customer distribution
- Geographic business patterns

### Payment Analysis

- Payment methods
- Payment share
- Installment behavior

### Delivery Analysis

- Delivery time
- Late deliveries
- Delivery performance
- Estimated vs. actual delivery performance

### Seller Analysis

- Seller performance
- Seller-level order and revenue analysis

### Customer Satisfaction

- Review score analysis
- Review scores vs. delivery performance

---

## 📊 Power BI Dashboard

The Power BI dashboard converts the analyzed data into an interactive business intelligence report.

The dashboard provides analysis across key business areas including:

- Sales performance
- Orders
- Customers
- Products and categories
- Payments
- Delivery performance
- Sellers
- Customer reviews and satisfaction

Interactive filters and visualizations allow users to explore the data across different business dimensions.

---

## 📈 Dashboard Pages

The Power BI report is organized into three analytical pages covering the major areas of the Olist business.

### Page 1 — Sales & Customer Analysis

Focuses on overall business performance, sales, orders, customers, and customer purchasing behavior.

### Page 2 — Product & Payment Analysis

Focuses on product categories, revenue performance, payment methods, and installment behavior.

### Page 3 — Delivery & Seller Analysis

Focuses on delivery performance, late deliveries, seller performance, and customer review patterns.

---

## 💡 Key Business Questions

The project helps answer questions such as:

1. How are sales and orders performing?
2. Which product categories generate the most revenue?
3. Which states contribute most to the business?
4. Who are the highest-value customers?
5. How frequently do customers make repeat purchases?
6. Which payment methods are most commonly used?
7. How does installment behavior vary across customers?
8. How well are sellers performing?
9. How frequently are orders delivered late?
10. Is there a relationship between delivery performance and customer reviews?

---

## 📂 Repository Structure

Olist-Ecommerce-PowerBI/
│
├── PowerBI/
│   └── Olist_Ecommerce_Dashboard.pbix
│
├── SQL/
│   └── olist_analysis.sql
│
├── Python/
│   ├── 01_load_data_to_mysql.py
│   ├── 02_test_mysql_connection.py
│   └── requirements.txt
│
├── Screenshots/
│   ├── Page_1.png
│   ├── Page_2.png
│   └── Page_3.png
│
├── Data/
│   └── README.md
│
└── README.md

---

## 🔐 Security

Database credentials are not included in this repository.

The Python scripts use placeholder database configuration for demonstration purposes.

For local execution, users should provide their own MySQL credentials.

---

## 📌 Project Highlights

This project demonstrates an end-to-end Business Intelligence workflow:

Data Ingestion → Database Management → SQL Analysis → Data Modeling → DAX → Visualization → Business Insights

It showcases practical skills in:

SQL • Python • MySQL • Power BI • DAX • Data Analysis • Business Intelligence

---

## 🚀 Skills Demonstrated

- Data Cleaning & Preparation
- Data Loading
- Relational Database Management
- SQL Querying
- Exploratory Data Analysis
- Business Intelligence
- Data Visualization
- DAX Measures
- Customer Analytics
- Sales Analytics
- Delivery Analytics
- Seller Analytics
- Dashboard Design
- Business Insight Generation

---

## 👤 Author

Harshit Narwat

GitHub: @harshitnarwat
