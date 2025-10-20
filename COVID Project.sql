Select *
From [Portfolio Project]..CovidDeaths
Where continent is not null
order by 3,4

--Select *
--From [Portfolio Project]..CovidVaccinations
--order by 3,4
--Select Data that we are going to be using  

Select Location, date, total_cases, new_cases, total_deaths, population
From [Portfolio Project]..CovidDeaths
Where continent is not null
order by 1,2


--looking at Total cases vs Total Deaths
 --Shows likelihood of dying if you contract covid in your country
Select Location, date, total_cases, total_deaths,(CAST(total_deaths AS float) / NULLIF(CAST(total_cases AS float),0))*100 as DeathPercentage
From [Portfolio Project]..CovidDeaths
Where location like '%Sri Lanka%' and continent is not null
order by 1,2

--looking at Total cases VS Population
--Shows what percentage of population got covid

Select Location, date, total_cases, population,(CAST(total_cases AS float) / NULLIF(CAST(population AS float),0))*100 as PopulationPercentage
From [Portfolio Project]..CovidDeaths
Where location like '%Sri Lanka%'and continent is not null
order by 1,2

--Looking at counties with highest infection rate compared to population

Select Location, population,MAX(total_cases) as HighestInfectionCount, MAX((CAST(total_cases AS float)/ (NULLIF (CAST(population AS float),0)) *100)) AS PopulationPercentageInfected
From [Portfolio Project]..CovidDeaths
Where continent is not null
Group by Location,Population
order by PopulationPercentageInfected desc

--Showing countires with Highest Death Count per Population
Select Location, MAX(total_deaths) as TotalDeathCount
From [Portfolio Project]..CovidDeaths
Where continent is not null
Group by Location
order by TotalDeathCount desc

--break things down by countries
--Showing continents with the highest deathcount per population
Select continent, MAX(total_deaths) as TotalDeathCount
From [Portfolio Project]..CovidDeaths
Where continent is not null
Group by continent
order by TotalDeathCount desc

--Global Numbers
Select date, total_cases, total_deaths,(CAST(total_deaths AS float) / NULLIF(CAST(total_cases AS float),0))*100 as DeathPercentage
From [Portfolio Project]..CovidDeaths
Where continent is not null
order by 1,2


 Select date, SUM (CAST (new_cases as float)) as total_cases, SUM (CAST(New_deaths as float)) as total_deaths,SUM (CAST(new_deaths AS float) / NULLIF(CAST(new_cases AS float),0))*100 as DeathPercentage
From [Portfolio Project]..CovidDeaths
Where continent is not null
Group by date
order by 1,2

 Select  SUM (CAST (new_cases as float)) as total_cases, SUM (CAST(New_deaths as float)) as total_deaths,SUM (CAST(new_deaths AS float) / NULLIF(CAST(new_cases AS float),0))*100 as DeathPercentage
From [Portfolio Project]..CovidDeaths
Where continent is not null
order by 1,2


--Looking at total population vs vaccination
Select*
From [Portfolio Project]..CovidVaccinations vac
Join [Portfolio Project]..CovidDeaths dea
On dea.location = vac.location
and dea.date = vac.date

Select dea.continent, dea.location, dea.date,dea.population,vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as float)) OVER (Partition by dea.Location Order by dea.Date) as RollingPeopleVaccinated
From [Portfolio Project]..CovidVaccinations vac
Join [Portfolio Project]..CovidDeaths dea
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 1,2,3

--USE CTE
With PopvsVac (Continent, Location,Date,Population,new_Vaccinations, RollingPeopleVaccinated)
as (
Select dea.continent, dea.location, dea.date,dea.population,vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as float)) OVER (Partition by dea.Location Order by dea.Date) as RollingPeopleVaccinated
From [Portfolio Project]..CovidVaccinations vac
Join [Portfolio Project]..CovidDeaths dea
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
)
Select*,(RollingPeopleVaccinated/Population)*100
From PopvsVac

--Temp table
Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(225),
Location nvarchar(225),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into  #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date,dea.population,vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as float)) OVER (Partition by dea.Location Order by dea.Date) as RollingPeopleVaccinated
From [Portfolio Project]..CovidVaccinations vac
Join [Portfolio Project]..CovidDeaths dea
On dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null

Select*,(RollingPeopleVaccinated/Population)*100
From  #PercentPopulationVaccinated


--Creating view to store data for later visualizations
DROP VIEW IF exists PercentPopulationVaccinated
Go

CREATE VIEW PercentPopulationVaccinated as
Select 
dea.continent,
dea.location, 
dea.date,
dea.population,
vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as float)) 
OVER (Partition by dea.Location Order by dea.Date) as RollingPeopleVaccinated
From [Portfolio Project]..CovidVaccinations vac
Join [Portfolio Project]..CovidDeaths dea
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

Go

Select*
From PercentPopulationVaccinated