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





