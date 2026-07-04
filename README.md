# Amazon Sales Analysis
## Ditte Joergensen

### Objective
Primary: Which product categories and states drove the most revenue?  

Supporting objectives:
- How did overall sales trend month-over-month from 2020 to 2024?
- Does discounting correlate with higher or lower order value?
- Which categories and states have the highest cancellation rates?  
  
### Dataset
100,000 rows, 18 columns, 2020-2024 synthetic Amazon sales data  
Link: https://www.kaggle.com/datasets/rohiteng/amazon-sales-dataset/data  

### Assumptions & Data Decisions
- Orders with a status of 'Cancelled' or 'Returned' were excluded from all revenue and sales analysis, as these orders did not represent realized revenue.
- Discount column is a decimal not a percentage
- Verified that TotalAmount column = (Quantity x UnitPrice x(1 - Discount)) + Tax + ShippingCost

### Tools Used
SQL Server, SSMS, Tableau

### Key Findings
