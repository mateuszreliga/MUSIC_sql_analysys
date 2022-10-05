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

--who report to who
select
e.FirstName ||" "|| e.LastName as supervisor,
e2.FirstName ||" "||e2.LastName as employee
from Employee e
join Employee e2 
on e.EmployeeId = e2.ReportsTo 



