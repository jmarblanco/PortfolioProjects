select * from CovidDeaths order by 3,4;

--select * from CovidVaccinations order by 3,4;

select Location, date, total_cases, new_cases, total_deaths, population 
from CovidDeaths order by 1,2

--Looking at Total cases vs Total Deaths

select Location, date, total_cases, population, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
from  CovidDeaths where location like '%states%' order by 1,2;

--Looking at total cases vs Population

select Location, population, max(total_cases) as Highest_Infectio_Count,
max((total_cases/population))*100 as PercentPopulationInfected
from  CovidDeaths 
--where location like '%states%' 
Group by location, population
order by PercentPopulationInfected desc;

--Looking at countries with highest infection rate compared to population

-- Showing countries with highest death count per population

select Location, max(cast(total_deaths as int)) as TotalDeathCount
from  CovidDeaths 
--where location like '%states%' 
where continent is not null
Group by location
order by TotalDeathCount desc;

--Let's break things down by continent

select continent, max(cast(total_deaths as int)) as TotalDeathCount
from  CovidDeaths 
--where location like '%states%' 
where continent is not null
Group by continent
order by TotalDeathCount desc;

select Location, max(cast(total_deaths as int)) as TotalDeathCount
from  CovidDeaths 
--where location like '%states%' 
where continent is null
Group by location
order by TotalDeathCount desc;

-- Showing continents with the highest death count per population

select Location, max(cast(total_deaths as int)) as TotalDeathCount
from  CovidDeaths 
--where location like '%states%' 
where continent is null
Group by location
order by TotalDeathCount desc;

-- GLOBAL NUMBERS

select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, 
sum(cast(new_deaths as int))/sum(new_cases)*100 as Death_Percentage
from  CovidDeaths 
--where location like '%states%' 
where continent is not null
group by date
order by 1,2;

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, 
sum(cast(new_deaths as int))/sum(new_cases)*100 as Death_Percentage
from  CovidDeaths 
--where location like '%states%' 
where continent is not null
--group by date
order by 1,2;

--Looking at total population vs vaccinations

select dea.continent, dea.location, dea.date, dea.population,
vac.new_vaccinations, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location
Order by dea.location, dea.date) as RollingPeopleVaccinated,
-- (RollingPeopleVaccinated/population)*100 as Percentage_PeopleVaccinated
from PortafolioProject..CovidDeaths dea
join PortafolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
and dea.new_vaccinations is not null
and dea.continent like 'Europe'
order by 2,3

--USE CITY

with PopvsVac (continent, location, date, population, New_Vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population,
vac.new_vaccinations, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location
Order by dea.location, dea.date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100 as Percentage_PeopleVaccinated
from PortafolioProject..CovidDeaths dea
join PortafolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
and dea.new_vaccinations is not null
--and dea.continent like 'Europe'
--order by 2,3
)

select *, (RollingPeopleVaccinated/population)*100
from PopvsVac

--TEMP TABLE

drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinaions numeric,
RollingPeopleVaccinated numeric
)


insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population,
vac.new_vaccinations, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location
Order by dea.location, dea.date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100 as Percentage_PeopleVaccinated
from PortafolioProject..CovidDeaths dea
join PortafolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--and dea.new_vaccinations is not null
--and dea.continent like 'Europe'
--order by 2,3

select *, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated

select * from #PercentPopulationVaccinated

--CREATING VIEW TO STORE DATA FOR LATER VISUALIZATIONS

create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population,
vac.new_vaccinations, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location
Order by dea.location, dea.date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/population)*100 as Percentage_PeopleVaccinated
from PortafolioProject..CovidDeaths dea
join PortafolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--and dea.new_vaccinations is not null
--and dea.continent like 'Europe'
--order by 2,3

select *
from PercentPopulationVaccinated