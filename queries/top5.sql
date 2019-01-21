DELIMITER $$
CREATE PROCEDURE top5()
BEGIN
    
    SELECT max(amount)
    from orders, ordersLog, market
    WHERE orders.ordersID = ordersLog.ordersID
    group by market.marketID
    limit 5;
END$$
DELIMITER ;