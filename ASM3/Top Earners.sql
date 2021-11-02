select max(months * salary), count(months * salary)
from Employee
where months * salary = (
    select max(months * salary)
    from employee
    )

--

select (months * salary), count(months * salary)
from Employee
where months * salary = (
    select max(months * salary)
    from employee
    )
group by (months * salary)