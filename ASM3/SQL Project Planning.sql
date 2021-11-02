with tbl as (
    select Start_Date, End_Date, row_number() over(order by Start_Date) as rn
    from Projects
)
select min(Start_Date), max(End_Date)
from tbl
group by datediff(day, rn, Start_Date)
order by datediff(day, min(Start_Date), max(End_Date)), min(Start_Date);