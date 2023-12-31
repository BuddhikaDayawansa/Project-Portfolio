--Test Databases

Select * From trainDB.dbo.CovidDeaths
order by 3,4;

--Select * From trainDB.dbo.CovidVaccinations
--order by 3,4;

--Getting data

Select location, date, total_cases, new_cases, total_deaths, population
From trainDB.dbo.CovidDeaths
Where continent is not NULL
order by 1,2

--Get data for total deaths and total cases
Select location, date, total_cases, total_deaths, population, (total_deaths/total_cases)*100 as precentage_population_infected
From trainDB.dbo.CovidDeaths
Where continent is not NULL

--Where location = 'Sri Lanka'
order by 1,2

--Get the countries with highest infection rate
Select location,population, MAX(total_cases) as highest_infection_count, MAX((total_cases/population))*100 as death_precentage
From trainDB.dbo.CovidDeaths
Where continent is not NULL
Group by population,location
--Where location = 'Sri Lanka'
Order by death_precentage desc

--Get the countries with highest death count
Select location, MAX(CAST(total_deaths as Int)) as total_death_count
From trainDB.dbo.CovidDeaths
Where continent is not NULL
Group by location
--Where location = 'Sri Lanka'
Order by total_death_count desc


--Get the continent with highest death count

Select continent, MAX(CAST(total_deaths as Int)) as total_death_count
From trainDB.dbo.CovidDeaths
Where continent is not NULL
Group by continent
--Where location = 'Sri Lanka'
Order by total_death_count desc

--Get the continent with highest death count
Select date, SUM(new_cases) as total_cases , SUM(CAST(new_deaths as int)) as total_deaths,
SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as death_precentage
From trainDB.dbo.CovidDeaths
Where continent is not NULL
Group by date
--Where location = 'Sri Lanka'
Order by 1,2 

--Join covid deaths and vaccination
Select dea.continent, dea.date, dea.location, dea.population , vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location,dea.date) as cumalative_vaccination
FROM trainDB.dbo.CovidDeaths dea
Join trainDB.dbo.CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not NULL
order by 1,2

With popvac(continent,date,location,population,new_vaccinations,cumalative_vaccination)
As
(--Join covid deaths and vaccination
Select dea.continent, dea.date, dea.location, dea.population , vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location,dea.date) as cumalative_vaccination
FROM trainDB.dbo.CovidDeaths dea
Join trainDB.dbo.CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not NULL)
--order by 1,2
Select * , (cumalative_vaccination/population)*100 as precentage_of_vaccinaion
from popvac



--Create Temporary Tabel
Drop table if exists dbo.precentage_population_vaccinates
create table  dbo.precentage_population_vaccinates
(
continent varchar(255),
date datetime,
location varchar(255),
population numeric,
new_vaccination numeric,
precentage_of_vaccinaion numeric
)
Insert Into dbo.precentage_population_vaccinates
Select dea.continent, dea.date, dea.location, dea.population , vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location,dea.date) as precentage_of_vaccinaion
FROM trainDB.dbo.CovidDeaths dea
Join trainDB.dbo.CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not NULL
--order by 1,2
Select * , (precentage_of_vaccinaion/population)*100 as precentage_of_vaccinaion
from dbo.precentage_population_vaccinates