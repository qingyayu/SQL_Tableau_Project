# Amazon Sales Analysis Project
In today's competitive e-commerce landscape, gaining insights into sales performance and customer behavior is key to driving growth. This project dives into Amazon’s Q2 2022 sales in India, using data analytics to uncover trends in revenue, product popularity, and customer preferences.

## Overview
This project utilized the "E-Commerce Sales Dataset" sourced from Kaggle. The dataset provides an in-depth look at the profitability of e-commerce sales. It contains data on SKU codes, sales channels, ship service levels, product categories, sizes, colors, etc. By analyzing these data points, the project explores patterns that provide a comprehensive understanding of sales dynamics.

Dataset: [E-Commerce Sales Dataset](https://www.kaggle.com/datasets/thedevastator/unlock-profits-with-e-commerce-sales-data/data)
Tableau Public workbook: [Amazon Sales Analysis](https://public.tableau.com/app/profile/qingya.yu/viz/AmazonSalesAnalysis_17375797226230/AmazonSalesAnalysis?publish=yes)

## Objectives and Key Questions
This analysis focused on answering these core questions:
  * Which regions contributed the highest revenue?
  * What product categories and items drove sales?
  * How did customers choose between standard and expedited shipping?
  * What monthly sales trends were observed during Q2?
The ultimate objective was to distill actionable insights for decision-makers to refine operational and marketing strategies.

## Tools and Technology
  * **Python**
    + Cleaned the raw data with Python, including filling null values, formatting date, creating product unique ID, renaming column names, etc.
    + Imported processed data into MySQL Workbench, using Python.
  * **SQL (MySQL Workbench)**
    + Created database and relational tables to organize data for sale data ('amazon_sale'), product information ('SKU_info'), and stock data ('stock').
    + Executed SQL queries to explore sales trends.
  * **Tableau**
    + Designed interactive dashboards to present findings visually, focusing on key areas such as location-based revenue, category-specific revenue, and revenue trends.

## Visual Outputs
  * **Regional and Categorical Sales Analysis**
    A map visualization and bubble chart reveal revenue and quantity distribution across Indian states and product categories. Maharashtra and Karnataka generate the highest revenue, with "Set" and "Kurta" emerging as the top-performing categories. Bubble sizes reflect revenue, highlighting dominant categories within high-revenue regions.
  * **Delivery Status, Fulfillment, and Customer Insights**
    Pie and bar charts showcase order statuses, fulfillment methods, and customer types. Approximately 94% of orders are successfully delivered, with in-house logistics being the primary fulfillment method. Sales to individual customers dominate, accounting for over 99% of total quantities.
  * **Revenue Trends Over Time**
    Line and bar charts illustrate a gradual decline in revenue from April to June, with a peak in early May, likely due to promotions. Category-specific trends reveal how certain categories influence overall revenue, offering valuable insights for seasonal strategies.
  * **Category-Specific Revenue Insights**
    Bar charts analyze revenue and quantity for top categories, including "Set," "Kurta," "Western Dress," and "Top." Size and color preferences vary significantly, with pink Sets, blue Kurtas, and green Western Dresses generating the highest revenue. This highlights distinct customer preferences within categories.
  * **Shipping Service Level Analysis**
    A bar chart compares expedited and standard shipping across categories. Expedited shipping is preferred across all categories, though some—like "Western Dress"—fall below the expedited shipping average while exceeding the standard shipping average. Insights guide inventory and logistics strategies.
  * **Top 10 Revenue-Generating Products**
    A detailed bar chart highlights the top 10 products, with SKUs, categories, sizes, and colors. The list is dominated by 4 "Sets" and 6 "Western Dresses," reflecting strong consumer demand and providing actionable insights for managing high-performing inventory.

## Files Included in the Repository
[`Step1_Create SQL Database Tables.sql`](https://github.com/qingyayu/SQL_Tableau_Project/blob/main/Amazon%20Sales%20Analysis/Step1_Create%20SQL%20Database%20Tables.sql): SQL script for creating the database schema.
[`Step2_Clean Data and Import Data to MySQL.py`](https://github.com/qingyayu/SQL_Tableau_Project/blob/main/Amazon%20Sales%20Analysis/Step2_Clean%20Data%20and%20Import%20Data%20to%20MySQL.py): Python script for cleaning the raw data and importing processed data into MySQL Workbench.
[`Step3_Analyze Data.SQL`](https://github.com/qingyayu/SQL_Tableau_Project/blob/main/Amazon%20Sales%20Analysis/Step3_Analyze%20Data.SQL): SQL script containing the queries used for data exploration.
[`Amazon Sales Analysis.twb`](https://github.com/qingyayu/SQL_Tableau_Project/blob/main/Amazon%20Sales%20Analysis/Amazon%20Sales%20Analysis.twb): Tableau workbook with dashboards for all visualizations.
[`Amazon Sales Analysis.png`](https://github.com/qingyayu/SQL_Tableau_Project/blob/main/Amazon%20Sales%20Analysis/Amazon%20Sales%20Analysis.png): Image version of the Tableau workbook.
[`README.md.twb`](https://github.com/qingyayu/SQL_Tableau_Project/blob/main/Amazon%20Sales%20Analysis/README.md): This file with project details.
