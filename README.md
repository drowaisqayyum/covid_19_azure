# COVID-19 Data Analysis using Azure

This repository showcases an end-to-end data analytics pipeline
designed for COVID-19 data analysis utilizing Azure services. The
pipeline seamlessly ingests data from CSV files hosted on GitHub,
stores it in Azure Data Lake Storage Gen2, conducts transformations
and enrichments through Azure Databricks, and conducts advanced
analytics via Azure Synapse Analytics.

## Data Source
The COVID-19 dataset used in this project is sourced from the
[COVID-19 Data
Hub](https://covid19datahub.io/articles/data.html). This hub offers a
comprehensive collection of COVID-19 pandemic-related data, including
confirmed cases, deaths, recoveries, tests, and vaccinations at
various administrative levels such as country, state, and city.

### Data Retrieval
To retrieve the raw data from the COVID-19 Data Hub, follow these
steps:

1. Visit the [COVID-19 Data Hub
   website](https://covid19datahub.io/articles/data.html).

2. The data is categorized into three levels:
   - Country level data
   - State level data
   - City level data

3. Access the data for each level using the following URLs:
   - Country level data: [https://storage.covid19datahub.io/level/1.csv](https://storage.covid19datahub.io/level/1.csv)
   - State level data: [https://storage.covid19datahub.io/level/2.csv](https://storage.covid19datahub.io/level/2.csv)
   - City level data: [https://storage.covid19datahub.io/level/3.csv](https://storage.covid19datahub.io/level/3.csv)

4. Download the CSV files for the desired level of analysis.

### Data Ingestion

Once you have downloaded the raw data files, you can ingest them into
your data storage or processing system. In this project, we utilize
Azure Data Factory for ingesting data into Azure Data Lake Storage
Gen2.

Here's an overview of the data ingestion process:

1. Create an Azure Data Factory pipeline.

2. Configure the pipeline to retrieve the raw data files from the
   COVID-19 Data Hub using the provided URLs.

3. Set up the pipeline to store the retrieved data in Azure Data Lake
   Storage Gen2.

4. Schedule the pipeline to run at regular intervals to maintain
   up-to-date data.

By ingesting the data into Azure Data Lake Storage Gen2, you
centralize the raw data, making it accessible for further processing
and analysis.

### Data Structure

The raw data files from the COVID-19 Data Hub contain various
attributes related to COVID-19 cases, deaths, recoveries, tests, and
vaccinations. This data is provided at different administrative levels
(country, state, and city) and includes daily records.

Key attributes in the raw data files include:

- `date`: The date of the recorded data.
- `confirmed`: The number of confirmed COVID-19 cases.
- `deaths`: The number of deaths due to COVID-19.
- `recovered`: The number of recovered cases.
- `tests`: The number of COVID-19 tests conducted.
- `vaccines`: The number of COVID-19 vaccine doses administered.
- `people_vaccinated`: The number of people who received at least one dose of the COVID-19 vaccine.
- `people_fully_vaccinated`: The number of people who have been fully vaccinated against COVID-19.

The raw data files also include additional attributes related to
administrative areas, such as country, state, and city names, along
with their respective codes and population figures.

### Data Usage

Once the raw data is ingested into Azure Data Lake Storage Gen2, it
can be further processed, transformed, and analyzed using various
Azure services, such as Azure Databricks and Azure Synapse Analytics.

The ingested raw data serves as the starting point for the COVID-19
data analytics pipeline. It can be utilized for data cleaning,
aggregation, and enrichment to prepare for advanced analytics and
reporting.

Leveraging the raw data from the COVID-19 Data Hub enables gaining
valuable insights into the spread and impact of the pandemic at
different administrative levels, supporting data-driven decisions for
public health measures and resource allocation.

Ensure to regularly update the raw data by scheduling the data
ingestion pipeline to ensure that your analytics and reporting reflect
the most up-to-date information available.

## Architecture Overview

The project architecture encompasses the following key components:

1. **Data Ingestion**: Utilizes Azure Data Factory to ingest COVID-19
   datasets from GitHub repositories, ensuring robust and efficient
   data retrieval.

2. **Data Storage**: Employs Azure Data Lake Storage Gen2 for storing
   the ingested dataset, providing scalability and optimized
   performance for large-scale data analytics.

3. **Data Transformation**: Leverages Azure Databricks, a fully
   managed Apache Spark platform, for transforming and enriching the
   dataset. This stage encompasses data manipulation, cleansing, and
   feature engineering to prepare the data for advanced analytics.

4. **Enriched Data Storage**: Persistently stores the transformed and
   enriched dataset back into Azure Data Lake Storage Gen2,
   establishing a centralized repository for processed data.

5. **Advanced Analytics**: Executes advanced analytical computations
   on the enriched dataset utilizing Azure Synapse
   Analytics. Distributed computing and SQL capabilities are employed
   to unveil patterns, trends, and insights within the data.

## Setup and Configuration

To set up and configure the project environment, adhere to the
following steps:

1. **Application Registration**: Register an application in Azure
   Active Directory to enable connectivity between Azure Databricks
   and Azure Data Lake Storage Gen2.

2. **Key Vault Configuration**: Establish an Azure Key Vault to
   securely store application registration keys (client ID, tenant ID,
   and secret key). Grant access permissions to Azure Databricks for
   retrieving secrets from the Key Vault.

3. **Azure Databricks Integration**: Create a secret scope within
   Azure Databricks to access key values from the Key Vault. Assign
   appropriate permissions, such as "Storage Blob Data Contributor,"
   to the registered application (covid_app) for accessing data in
   Azure Data Lake Storage Gen2.

4. **Data Ingestion**: Utilize Azure Data Factory to construct a data
   pipeline responsible for ingesting COVID-19 datasets from GitHub
   repositories and storing them in Azure Data Lake Storage Gen2.

5. **Data Transformation**: Utilize Azure Databricks notebooks to
   transform and enrich the dataset. Perform data manipulations,
   cleansing, and feature engineering to prepare the data for advanced
   analytics.
   
   - Mounting the data to Databricks:
   ```python
   # Get the secret values from the secret scope
   client_id = dbutils.secrets.get(scope="key-vault-scope", key="clientid")
   client_secret = dbutils.secrets.get(scope="key-vault-scope", key="applicationkey")
   tenant_id = dbutils.secrets.get(scope="key-vault-scope", key="tenantid")

	# Update the configs dictionary with the secret values
	configs = {
    "fs.azure.account.auth.type": "OAuth",
    "fs.azure.account.oauth.provider.type": "org.apache.hadoop.fs.azurebfs.oauth2.ClientCredsTokenProvider",
    "fs.azure.account.oauth2.client.id": client_id,
    "fs.azure.account.oauth2.client.secret": client_secret,
    "fs.azure.account.oauth2.client.endpoint": f"https://login.microsoftonline.com/{tenant_id}/oauth2/token"
	}

	# Mount the Azure Data Lake Storage using the updated configs
	
	dbutils.fs.mount(
    source="abfss://covid-19-data@covidstoragefiles.dfs.core.windows.net",
    mount_point="/mnt/covid-19-data",
    extra_configs=configs
	)
   ```
   
   - Transforming the data - Countries
	 ```python
	 from pyspark.sql.functions import col, to_date
	 
	 # Assuming your DataFrame is named 'countries'
	 transformed_countries = countries.select(
	 col("id"),
	 to_date(col("date")).alias("date"),
	 col("confirmed").cast("integer"),
	 col("deaths").cast("integer"),
	 col("recovered").cast("integer"),
	 col("tests").cast("long"),
	 col("vaccines").cast("long"),
	 col("people_vaccinated").cast("integer"),
	 col("people_fully_vaccinated").cast("integer"),
	 col("hosp").cast("integer"),
	 col("icu").cast("integer"),
	 col("vent").cast("integer"),
	 col("population").cast("integer"),
	 col("administrative_area_level_1")
) 
	```
	
6. **Advanced Analytics**: Use Azure Synapse Analytics to perform
   advanced analytical computations on the enriched dataset. Leverage
   distributed computing and SQL capabilities to gain insights from
   the data.
   
   ```sql
   -- Get the total confirmed cases for top 20 country
	   SELECT TOP 20 country, MAX(total_confirmed) AS total_confirmed
	   FROM countries
	   GROUP BY country
	   ORDER BY total_confirmed DESC;
   ```
   ```sql
	-- Find the top 10 states with the highest number of confirmed cases:
		SELECT TOP 10 state, MAX(total_confirmed) AS total_confirmed
		FROM states
		GROUP BY state
		ORDER BY total_confirmed DESC;
	```
	```sql
	-- Find the top 10 cities with the highest number of confirmed cases:
		SELECT TOP 10 city, MAX(total_confirmed) AS total_confirmed
		FROM cities
		GROUP BY city
		ORDER BY total_confirmed DESC;
   ```

## Usage

Follow these steps to utilize the repository:

1. Clone the repository to your local environment.
2. Implement the setup and configuration steps as outlined above.
3. Execute the data pipeline within Azure Data Factory to ingest the data.
4. Run the Azure Databricks notebooks to perform data transformation
   and enrichment.
5. Conduct advanced analytics using Azure Synapse Analytics.
6. Explore the generated results and insights derived from the
   COVID-19 data analysis.

## Folder Structure
```
project_root/
│
├── data/
│   ├── raw/
│   └── processed/
│
├── databricks/
│   ├── notebooks/
│   └── libraries/
│
├── data_factory/
│   └── pipelines/
│
└── README.md
```
# Contributing
Contributions are welcome! If you find any issues or have suggestions
for improvement, please open an issue or submit a pull request.

## License 
This project is licensed under the MIT License
