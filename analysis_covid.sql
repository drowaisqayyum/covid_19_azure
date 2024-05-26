-- Get the total confirmed cases for top 20 country
SELECT TOP 20 country, MAX(total_confirmed) AS total_confirmed
FROM countries
GROUP BY country
ORDER BY total_confirmed DESC;

-- Find the top 10 states with the highest number of confirmed cases:
SELECT TOP 10 state, MAX(total_confirmed) AS total_confirmed
FROM states
GROUP BY state
ORDER BY total_confirmed DESC;

-- Find the top 10 cities with the highest number of confirmed cases:
SELECT TOP 10 city, MAX(total_confirmed) AS total_confirmed
FROM cities
GROUP BY city
ORDER BY total_confirmed DESC;

-- Calculate the case fatality rate (CFR) for top 50 country:
SELECT TOP 50 country, (MAX(total_deaths) * 1.0 / MAX(total_confirmed)) * 100 AS case_fatality_rate
FROM countries
GROUP BY country
ORDER BY case_fatality_rate DESC;

-- Find the states with the highest number of active cases (confirmed - deaths - recovered)
SELECT TOP 10 state, MAX(total_confirmed) - MAX(total_deaths) - MAX(total_recovered) AS active_cases
FROM states
GROUP BY state
ORDER BY active_cases DESC;

-- Get the countries with the highest number of tests performed per million population
SELECT TOP 10 country, (MAX(total_tests) * 1000000.0 / MAX(total_population)) AS tests_per_million
FROM countries
GROUP BY country
ORDER BY tests_per_million DESC;


