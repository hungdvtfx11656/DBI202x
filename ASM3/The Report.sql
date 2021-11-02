select case
        when Grade < 8 then null
        else Name
    end,
    Grade,
    Marks
from Students s, Grades g
where s.Marks between g.Min_Mark and g.Max_Mark
order by grade desc, name;