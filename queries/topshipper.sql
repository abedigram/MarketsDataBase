SELECT shipper.*
FROM (orders JOIN orderslog USING (orderID)) JOIN shipper USING (shipperID)
GROUP BY shipperID
ORDER BY AVG(orders.amount) DESC
LIMIT 1