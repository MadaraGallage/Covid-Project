/*

Queries used for Tableau Project

*/

-- 1. 

Select SUM(CAST (new_cases as float)) as total_cases, SUM(cast(new_deaths as float)) as total_deaths, SUM(cast(new_deaths as float))/SUM(CAST(New_Cases as float))*100 as DeathPercentage 
From [Portfolio Project]..CovidDeaths 
where continent is not null 
order by 1,2

Go
DROP VIEW IF EXISTS dbo.DeathPercentageView01;
GO
CREATE VIEW dbo.DeathPercentageView01 AS
SELECT 
    SUM(CAST(new_cases AS float)) AS total_cases, 
    SUM(CAST(new_deaths AS float)) AS total_deaths, 
    (SUM(CAST(new_deaths AS float)) / SUM(CAST(new_cases AS float))) * 100 AS DeathPercentage
FROM [Portfolio Project]..CovidDeaths
WHERE continent IS NOT NULL;
GO


SELECT*FROM DeathPercentageView01


Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From [Portfolio Project]..CovidDeaths
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc



DROP VIEW IF EXISTS dbo.TotalDeathsByLocation;
GO


CREATE VIEW dbo.TotalDeathsByLocation AS
SELECT 
    location, 
    SUM(CAST(new_deaths AS INT)) AS TotalDeathCount
FROM [Portfolio Project]..CovidDeaths
WHERE continent IS NULL
  AND location NOT IN ('World', 'European Union', 'International')
GROUP BY location;
GO


SELECT * 
FROM dbo.TotalDeathsByLocation
ORDER BY TotalDeathCount DESC;  


-- 3.

Select Location, Population, MAX(CAST(total_cases as float)) as HighestInfectionCount,  Max(CAST(total_cases as float)/(CAST(population as float)))*100 as PercentPopulationInfected
From [Portfolio Project]..CovidDeaths
Group by Location, Population
order by PercentPopulationInfected desc


DROP VIEW IF EXISTS dbo.HighestInfectionsByLocation;
GO


CREATE VIEW dbo.HighestInfectionsByLocation AS
SELECT 
    Location, 
    Population, 
    MAX(CAST(total_cases AS FLOAT)) AS HighestInfectionCount,  
    MAX(CAST(total_cases AS FLOAT) / CAST(population AS FLOAT) * 100) AS PercentPopulationInfected
FROM [Portfolio Project]..CovidDeaths
GROUP BY Location, Population;
GO


SELECT * 
FROM dbo.HighestInfectionsByLocation
ORDER BY PercentPopulationInfected DESC;


-- 4.


Select Location, Population,date, MAX(CAST(total_cases as float)) as HighestInfectionCount,  Max(CAST(total_cases as float)/(CAST(population as float)))*100 as PercentPopulationInfected
From [Portfolio Project]..CovidDeaths

Group by Location, Population, date
order by PercentPopulationInfected desc


DROP VIEW IF EXISTS dbo.HighestInfectionsByLocationByDate;
GO


CREATE VIEW dbo.HighestInfectionsByLocationByDate AS
SELECT 
    Location,
    Population,
    date,
    MAX(CAST(total_cases AS FLOAT)) AS HighestInfectionCount,
    MAX(CAST(total_cases AS FLOAT) / CAST(population AS FLOAT) * 100) AS PercentPopulationInfected
FROM [Portfolio Project]..CovidDeaths
GROUP BY Location, Population, date;
GO


SELECT *
FROM dbo.HighestInfectionsByLocationByDate
ORDER BY PercentPopulationInfected DESC;

