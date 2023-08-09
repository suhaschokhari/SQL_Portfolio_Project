
Portfolio Project || SQL Covid19 Data Exploration ||


-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country.

Select Location, date, total_cases,total_deaths, cast(total_deaths as float)/(total_cases)*100 as DeathPercentage
From CovidDeaths
Where location = 'india'
AND location not in ('world','asia','oceania','europe','Africa','North America','South America')
order by DeathPercentage DESC


-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select Location, date, Population, total_cases,  cast(total_cases as float)/(population)*100 as PercentPopulationInfected
From CovidDeaths
where location = 'india'
AND location not in ('world','asia','oceania','europe','Africa','North America','South America')
order by PercentPopulationInfected DESC

-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(cast(total_cases as int)) as HighestInfectionCount,  Max(cast(total_cases as float))/(population)*100 as PercentPopulationInfected
From CovidDeaths
Where location = 'india'
AND location not in ('world','asia','oceania','europe','Africa','North America','South America')
Group by Location, Population
order by HighestInfectionCount  desc

-- Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidDeaths
Where location = 'india'
AND location not in ('world','asia','oceania','europe','Africa','North America','South America')
Group by Location
order by TotalDeathCount desc

-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidDeaths
Where location not in ('world','asia','oceania','europe','Africa','North America','South America')
Group by continent
order by TotalDeathCount desc

-- GLOBAL NUMBERS

Select  Continent, SUM(cast(new_cases as int)) as total_cases, SUM(cast(new_deaths as int)) as total_deaths , SUM(cast(new_deaths as float))/SUM(cast(New_Cases as float))*100 as DeathPercentage
From CovidDeaths
Where location not in ('world','asia','oceania','europe','Africa','North America','South America')
Group by continent


-- Total Population vs Vaccinations


Select d.continent, d.location, d.date, d.population, v.new_vaccinations
, SUM(CONVERT(int,v.new_vaccinations)) OVER (Partition by d.Location Order by d.location, d.Date) as RollingPeopleVaccinated
From CovidDeaths d
Join Covid_Vaccinations v
On d.location = v.location
and d.date = v.date
Where d.location not in ('world','asia','oceania','europe','Africa','North America','South America')
order by RollingPeopleVaccinated DESC

-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select d.continent, d.location, d.date, d.population, v.new_vaccinations
, SUM(CONVERT(int,v.new_vaccinations)) OVER (Partition by d.Location Order by d.location, d.Date) as RollingPeopleVaccinated
From CovidDeaths d
Join Covid_Vaccinations v
	On d.location = v.location
	and d.date = v.date
Where d.location not in ('world','asia','oceania','europe','Africa','North America','South America')
)
Select *
From PopvsVac
order by RollingPeopleVaccinated DESC

-- Creating View to store data for later visualizations

Create View Population_Vaccinated as
Select d.continent, d.location, d.date, d.population, v.new_vaccinations
, SUM(CONVERT(int,v.new_vaccinations)) OVER (Partition by d.Location Order by d.location, d.Date) as RollingPeopleVaccinated

From CovidDeaths d
Join Covid_Vaccinations v
	On d.location = v.location
	and d.date = v.date
Where d.location not in ('world','asia','oceania','europe','Africa','North America','South America')
order by RollingPeopleVaccinated DESC

