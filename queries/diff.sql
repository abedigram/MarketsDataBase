SELECT AVG(a.amount) - AVG(b.amount)
FROM orders as a, orders as b
WHERE b.customerID = 5 and not  a.customerID = 5
