/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

Select *
From PortfolioProject.CovidDeaths
Where continent is not null 
order by 3,4;


-- Select Data that we are going to be starting with

SELECT location,date,total_cases,new_cases,total_deaths,population
FROM coviddeaths
order by
1,2;

-- Total cases vs Total deaths
-- Show likelihood of death if contracted in your country

SELECT location,date,total_cases,total_deaths, round((total_deaths/total_cases),4) * 100 as 'death% per case'
FROM coviddeaths
where LOCATION LIKE '%STATES%'
	and Continent is not null
order by
1,2;

--  total_cases vs population
-- Shows percentage of population who have contracted Covid

SELECT location,date,total_cases,population, round((total_cases/population),4) * 100 as 'Case% per population'
FROM coviddeaths
-- where LOCATION LIKE '%STATES%'
order by
1,2;

-- Countries with highest infection rate compared to population

SELECT location,max(total_cases) as 'Higest Infection Count',population, max(round((total_cases/population),4)) * 100 as PercentofPopulationInfected
FROM coviddeaths
-- where LOCATION LIKE '%STATES%'
GROUP BY location, population
order by
PercentofPopulationInfected desc;

-- Countries with Highest Death Count per Population

Select Location, max(cast( Total_Deaths as unsigned)) as TotalDeathCount
From coviddeaths
-- Where location like '%states%'
Where continent is not null 
Group by Location
order by TotalDeathCount desc; 

-- BREAKING THINGS DOWN BY CONTINENT

-- Contintents with the highest death count per population


Select continent, max(CAST( Total_Deaths AS unsigned))  as TotalDeathCount
From coviddeaths
-- Where location like '%states%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc;

  -- GLOBAL NUMBERS
  
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as unsigned)) as total_deaths, SUM(cast(new_deaths as unsigned))/SUM(New_Cases)*100 as DeathPercentage
From coviddeaths
-- Where location like '%states%'
where continent is not null 
-- Group By date
order by 1,2;

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select 
dea.continent, 
dea.location, 
dea.date, dea.population, 
vac.new_vaccinations, 
SUM(Cast(vac.new_vaccinations as unsigned)) as RollingPeopleVaccinated,
(RollingPeopleVaccinated/population)*100
From coviddeaths dea
Join covidvaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3;

-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) as RollingPeopleVaccinated,
 (RollingPeopleVaccinated/population)*100
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null ;


Select *
from percentpopulationvaccinated;

