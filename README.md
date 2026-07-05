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

#### Revenue
- 93,923 total orders generated $86,193,863.07 in total revenue with an average order value of $917.71
- The electronics category was the top revenue-generating category, accounting for 17.01% of total revenue
- The top 3 categories (electronics, sports & outdoors and books) combined made up 50.39% of total revenue
- Average order value was consistent across all categories, ranging from approximately $911 (home & kitchen) to $927 (clothing), which suggests category type does not have influence on spending per order
- Texas led all states in total revenue at $21,523,935.95, followed by California and North Carolina
- Average Order value was consistent across all states, ranging from approximatelty $896 (DC) to $926 (Colorado), which suggests geography had little influence on spending per order

#### Time Trends
- Revenue remained fairly stable across all five years, ranging from $17.0M to $17.4M. 2023 was the strongest year while 2024 saw a slight decline, though the overall variance across years was less then 2.5%
- Monthly revenue for all 5 years showed minimal seasonal variance, ranging from $6.5M in February to $7.4M in January
- The strongest month across the dataset was August, 2020 with $1,537,473.65 in revenue
- The weakest month was February, 2022 with $1,276,430.69 in revenue
- Month-over-month revenue growth averaged 0.02%, indicating stable sales with no meaningful overall growth trend
- February consistently saw the sharpest monthly decline each year, rangin from -6% to -16% and March reliably rebounded following each February dip

#### Discounting
- Orders with no discount had an average order value of $987 vs $738 for high discounted orders (25%+)
- Average order value decreased consistently as discount level increased, dropping approximately 25% from the no discount tier to the high discount tier

#### Cancellations
- The overall cancellation rate was 3.03%
- The electronics category had the highest cancellation rate at 3.23%
- Indiana had the highest cancellation rate at 3.56%

### Conclusions
Revenue and units sold were evenly distributed across categories and states, wih no segment dramatically outperforming others. Texas led in total revenue but at the same average order value as lower performing states, this indicates volume rather than higher spending drives geographic differences. 

The overall sales remained stable across all five years with minimal growth (average MoM growth of 0.02%), this suggests a consistent market with no strong seasonal patterns outside of a recurring dip in February and a rebound in March. 

Discounting was associated with lower average order values across all tiers, with heavily discounted orders averaging 25% less than non-discounted orders. This suggests discounts to not drive larger purchases.

The overall cancellation rate was lowe at 3.03%, this indicates a generally good order fulfillment across all categories and states.

NOTE: The consistency observed across all dimensions is consistent with the synthetic nature of this dataset
