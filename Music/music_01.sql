--join song title with artist name table
select
a.Title as Song_title,
ar.Name as Artist_name
from Album a 
join Artist ar
on a.ArtistId = ar.ArtistId 

--create view for next step top 5 profitable Artist 
CREATE VIEW v_album_data as
select
a.Title as Song_title,
ar.Name as Artist_name,
a.AlbumId 
from Album a 
join Artist ar
on a.ArtistId = ar.ArtistId 

--which top 5 Artist is most profitable
select
SUM(il.UnitPrice * il.Quantity) as Artist_profit,
ad.Artist_name
from InvoiceLine il 
join Track t 
on t.TrackId = il.TrackId 
join v_album_data ad 
on ad.AlbumId = t.AlbumId 
GROUP BY ad.Artist_name
ORDER BY Artist_profit DESC 
LIMIT 5

--who report to who (selfjoin)
select
e.FirstName ||" "|| e.LastName as supervisor,
e2.FirstName ||" "||e2.LastName as employee
from Employee e
join Employee e2 
on e.EmployeeId = e2.ReportsTo 
order by e.FirstName 


--track genre count
create view v_genre_appearance as
select  
count(*) over (partition by g.Name) as genre_appearance,
g.Name
from Genre g
join Track t 
on t.GenreId = g.GenreId 


select
*
from v_genre_appearance 
group by Name
order by genre_appearance desc


--track genre in percentage
create view v_track_count as
select 
count(*) as track_count
from Track t 

select
v_g.Name,
round(v_g.genre_appearance*1.0/v_t.track_count*100, 2) as percentage_of_total
from v_genre_appearance v_g
cross join v_track_count v_t
group by v_g.Name
order by v_g.genre_appearance desc


--basic analysys minutes by Genre
select distinct
t.GenreId,
round(avg(t.Milliseconds) over (partition by t.GenreId)/1000.0/60, 2) as avg_min,
round(min(t.Milliseconds) over (partition by t.GenreId)/1000.0/60, 2) as min_min,
round(max(t.Milliseconds) over (partition by t.GenreId)/1000.0/60, 2) as max_min
from Track t 

--there are some track with less than 1 minute so let's check how much are that kind of trucks
create view v_track_in_minutes as
select
Name ,
GenreId ,
round(Milliseconds / 1000.0 / 60, 2) as minutes
from Track t 
order by Milliseconds 

--step 1:
--check percentile 10% ERROR to check
--select
--PERCENTILE_CONT(0.1) within group (order by vtim.minutes) over() as 01_per
--from v_track_in_minutes vtim 

create view v_min_feature as
select
*,
case
	when minutes < 1 then "less then minute"
	when minutes >= 1 then "over minute"
end as min_feature
from v_track_in_minutes vtim 

select DISTINCT 
min_feature,
COUNT(*) over (order by min_feature) as min_feature_count
from v_min_feature




