SELECT CAST(
        CEILING(
            AVG(CAST(Salary AS Float)) -
            AVG(CAST(REPLACE(Salary, 0, '')AS Float))
        ) AS INT)
FROM EMPLOYEES;