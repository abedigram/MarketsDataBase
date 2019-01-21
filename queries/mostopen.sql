CREATE PROCEDURE ignoreds()
BEGIN
    SELECT
        p.phone
    FROM
        phones, customer, orders, orderslog
    WHERE
        phone.customerID = customer.customerID AND customer.customerID = orders.customerID AND orders.ordersID = orderslog.ordersID AND orderslog.statusNew = "ignored";
END