DELIMITER $$

CREATE TRIGGER op2
BEFORE update ON shipper
FOR EACH ROW
BEGIN
  DECLARE s varchar(20);
    DECLARE price int;
    DECLARE c int;
    SET c = new.credit;
    SET price = (SELECT p.price * o.amount * 0.05
                   from orders as o, orderslog as ol, product as p
                   where new.shipperID = ol.supporterID
                   and o.ordersID=  ol.ordersID
                   and o.productID = p.productID);
    
    IF new.shipperstatus = "busy" THEN
    SET s = "free";
    ELSE
    SET s = "busy";
    END IF;
  

    IF new.shipperstatus = "free" THEN               
    SET new.credit = c + price ;
    END IF;
    
    INSERT INTO shipperslog (shipperID,statusOld,statusNew,logDate) VALUES
    (new.shipperID,s,new.shipperstatus,now());
END$$
DELIMITER ;