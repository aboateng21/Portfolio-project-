select *
from [Portfolio project].dbo.['Covid deaths$']
where continent is not null
order by 3,4;


select location, date, total_cases, new_cases, total_deaths, population
from [Portfolio project].dbo.['Covid deaths$']
order by 1,2;



alter table [Portfolio project].dbo.['Covid deaths$']
alter column total_cases float;

alter table [Portfolio project].dbo.['Covid deaths$']
alter column total_deaths float;

alter table [portfolio project].dbo.['covid vaccinations$']
alter column new_vaccinations float;


select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as [percentage of deaths]
from [Portfolio project].dbo.['Covid deaths$']
where location like '%kingdom' 


 
select location, date, population, total_cases, (total_cases/population)*100 as [percentage of cases per population]
from [Portfolio project].dbo.['Covid deaths$']
where location like '%kingdom' 
order by 1,2;

select location, population, max(total_cases) as [total cases] ,max ((total_cases/population)) *100 as [percentage of population infected]
from [Portfolio project].dbo.['Covid deaths$']
group by location, population 
order by [percentage of population infected] desc;


select location, population, max(total_deaths) as [total deaths] ,max ((total_deaths/population)) *100 as [percentage of population deaths]
from [Portfolio project].dbo.['Covid deaths$']
group by location, population 
order by [percentage of population deaths] desc;

select continent , max(total_deaths) as [total deaths per continent] 
from [Portfolio project].dbo.['Covid deaths$']
where continent is not null and continent not like '%income'
group by continent
order by [total deaths per continent] desc;


select location, max(total_deaths) as [total deaths per location] 
from [Portfolio project].dbo.['Covid deaths$']
where continent is not null
group by location
order by [total deaths per location] desc
 ;


 select date, sum(new_cases) as [total new cases], sum (new_deaths) as [total new deaths], (SUM(new_deaths) / NULLIF(SUM(new_cases), 0)) * 100 AS [percentage of deaths]
 from [Portfolio project].dbo.['Covid deaths$']
 group by date
 order by [percentage of deaths] desc;


 with [vac vs population] (continent, location,date,population, new_vaccinations,[rolling count per location])
 as


 (select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location, dea.date) as [rolling count per location]
 from [Portfolio project].dbo.['Covid deaths$'] dea
 join [Portfolio project].dbo.['Covid vaccinations$'] vac
 on dea.location=vac.location 
 and dea.date = vac.date
 where dea.continent is not null
 )

 select *,([rolling count per location]/population)*100 as [rolling count per population] from 
 [vac vs population]


 create view [Population vs Vaccinations] as 
 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location, dea.date) as [rolling count per location]
 from [Portfolio project].dbo.['Covid deaths$'] dea
 join [Portfolio project].dbo.['Covid vaccinations$'] vac
 on dea.location=vac.location 
 and dea.date = vac.date
 where dea.continent is not null;

 select * 
 from [Population vs Vaccinations]
