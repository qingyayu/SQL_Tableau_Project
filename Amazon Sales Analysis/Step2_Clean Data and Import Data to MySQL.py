import pandas as pd
import pymysql
from sqlalchemy import create_engine

# Import raw data from https://www.kaggle.com/datasets/thedevastator/unlock-profits-with-e-commerce-sales-data/data
df_amazon = pd.read_csv('/Users/qingyayu/Documents/Project/Amazon Sales/Input/Amazon Sale Report.csv')
df_sale = pd.read_csv('/Users/qingyayu/Documents/Project/Amazon Sales/Input/Sale Report.csv')

#%% Clean Amazon Sale Report data
# Delete unused columns
df_amazon.drop(columns=['index','fulfilled-by', 'promotion-ids', 'fulfilled-by', 'Unnamed: 22'],inplace=True)
# Check null values
print(df_amazon.isnull().sum())
# Fill null values
df_amazon['Courier Status'].fillna('n/a', inplace=True)
df_amazon['currency'].fillna('n/a', inplace=True)
df_amazon['Amount'].fillna(0, inplace=True)
df_amazon['ship-city'].fillna('n/a', inplace=True)
df_amazon['ship-state'].fillna('n/a', inplace=True)
df_amazon['ship-postal-code'].fillna('n/a', inplace=True)
df_amazon['ship-country'].fillna('n/a', inplace=True)
# Check null values
print(df_amazon.isnull().sum())

# rename column names to better format
name_map_amazon = {'Order ID': 'order_id', 'Date': 'date', 'Status': 'status', 'Fulfilment': 'fulfilment',
                    'Sales Channel ': 'sales_channel', 'ship-service-level': 'ship_service_level', 'Style': 'style',
                    'Category': 'category', 'Size': 'size', 'Courier Status': 'courier_status', 'Qty': 'quantity',
                    'Amount': 'amount', 'ship-city': 'ship_city', 'ship-state': 'ship_state', 
                    'ship-postal-code': 'ship_postal_code', 'ship-country': 'ship_country', 'B2B': 'customer_type'
                    }
df_amazon.rename(columns=name_map_amazon, inplace=True)

# format Date column
df_amazon['date']=pd.to_datetime(df_amazon['date'], format='%m-%d-%y')

# Replacing 'TRUE' with 'Business'; replacing 'FALSE' with 'Customer'
df_amazon['customer_type'] = df_amazon['customer_type'].apply(lambda x: 'Business' if x == True else 'Customer')

# Concatenate SKU and ASIN together to create a unique id of the product
df_amazon['SKU_ASIN'] = df_amazon[['SKU', 'ASIN']].agg('|'.join, axis=1)

# format data in the amount column to float format
df_amazon['amount'] = pd.to_numeric(df_amazon['amount']).astype(float)
df_amazon['ship_postal_code'] = df_amazon['ship_postal_code'].astype(str)



#%%Clean Sale Report data
# Delete unused columns
df_sale.drop(columns=['index'],inplace=True)
# Delete rows with missing value
df_sale.dropna(inplace=True)

# rename column names to better format
name_map_sale = {'SKU Code': 'SKU', 'Design No.': 'design_no', 'Stock': 'stock', 'Category': 'category',
                 'Size': 'size', 'Color': 'color'}
df_sale.rename(columns=name_map_sale, inplace=True)

# Delete rows where SKU Code is '#REF!'
df_sale = df_sale[df_sale['SKU'] != '#REF!']



#%% import amazon sale report data to the temp_amazon_sale table
# Configuration
db_user = 'root'
db_password = 'xxx'
db_host = 'localhost'
db_port = 3306         # default MySQL port
db_name = 'Amazon_Sale' # remember to update database name
table_name = 'temp_amazon_sale' # remember to update table name

# Create a database connection using SQLAlchemy
engine = create_engine(f'mysql+pymysql://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}')

# Load the processed data into a new DataFrame
data = df_amazon

# Import the DataFrame into the MySQL table
try:
    # Write the DataFrame to the table
    data.to_sql(table_name, con=engine, if_exists='replace', index=False)
    print(f"Data successfully imported into the table `{table_name}`.")
except Exception as e:
    print(f"An error occurred: {e}")


#%% import sale report data to the stock table
# Configuration
db_user = 'root'
db_password = 'xxx'
db_host = 'localhost'
db_port = 3306         # default MySQL port
db_name = 'Amazon_Sale' # remember to update database name
table_name = 'stock' # remember to update table name

# Create a database connection using SQLAlchemy
engine = create_engine(f'mysql+pymysql://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}')

# Load the processed data into a new DataFrame
data = df_sale

# Import the DataFrame into the MySQL table
try:
    # Write the DataFrame to the table
    data.to_sql(table_name, con=engine, if_exists='replace', index=False)
    print(f"Data successfully imported into the table `{table_name}`.")
except Exception as e:
    print(f"An error occurred: {e}")
