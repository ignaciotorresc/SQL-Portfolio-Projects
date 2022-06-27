Use Covid19_Project;

Select * 
From coviddeaths
order by 3,4;

--Select * 
--From covidvaccination
--order by 3,4;

--After doing some exploration, i realized that in the location column there is data grouped by continent, so i will adding
--'where continent is not null' in the first queries.

-- I also added "Where location = 'United State'" as a comment looking for the United State numbers. Just curiosity

--Select Data that we are going to be using

Select 
	iso_code, 
	location, 
	date, 
	population,
	total_cases,
	new_cases, 
	total_deaths
From 
	coviddeaths
--Where location = 'United State'
Where 
	continent is not Null
order by 2,3;

--Total Deaths vs Total Cases:
--Show likelihood of dying if your contract covid in your country

Select 
	location, 
	date, 
	population,
	total_cases, 
	total_deaths, 
	ROUND(((total_deaths/total_cases)*100), 2) as DeathPorcentage
From 
	coviddeaths
--Where location = 'United State'
	Where 
		continent is not Null
order by 1,2;

--Total Cases vs Population:
--Show what porcentage of populaltion got Covid

Select 
	location, 
	date, 
	population,
	total_cases, 
	total_deaths,  
	ROUND(((total_cases/population)*100), 3) as PercentPopulationInfected
From 
	coviddeaths
--Where location = 'United State'
Where 
	continent is not Null
order by 1,2;

--Countries with highest infection rate per population:

Select 
	location, 
	population, 
	MAX(total_cases) as HighestInfectionCount, 
	ROUND(max((total_cases/population)*100), 2) as	PercentPopulationInfected
From 
	coviddeaths
Where 
	continent is not Null
group by location, population
order by PercentPopulationInfected desc;

--Highest death count per Countries :

Select 
	location, 
	MAX(cast(total_deaths as int)) as TotalDeathCount
From 
	coviddeaths
Where 
	continent is not Null
group by location, population
order by TotalDeathCount desc;

--By Continent
--Data by continent grouped in continent column is not accurate. I could find the right number in location column

Select 
	location, 
	--date,
	--total_deaths
	MAX(cast(total_deaths as int)) as TotalDeathCount
From 
	coviddeaths
Where 
	continent is Null
  group by location
--order by TotalDeathCount desc
--order by date asc;

--Global Numbers

Select 
	--date,
   	SUM(new_cases) as total_cases, 
	SUM(cast(new_deaths as int)) as total_deaths, 
	Round((SUM(cast(new_deaths as int))/SUM(new_cases)*100), 2) as DeathPorcentage
From 
	coviddeaths
Where
	continent is not null
	--Group by date


--Population vs Vaccination

Select 
	cd.continent,
	cd.location,
	cd.date,
	cd.population,
	cv.people_vaccinated,
	ROUND(((cast(cv.people_vaccinated as bigint)/population)*100), 2) as PorcentagePeopleVaccinated
From 
	coviddeaths cd
Join
	covidvaccination cv on cd.location = cv.location
	and
	cd.date = cv.date
Where cd.continent is not null 
		--and cv.people_vaccinated is not null
Order by 2,3;