DELIMITER $$

CREATE TRIGGER op1
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
  DECLARE opens time;
  DECLARE closes time;
  DECLARE mAmount int;
  DECLARE oAmount int;
  DECLARE shippers varchar(20);
  DECLARE price int;
  DECLARE message varchar(20);
  DECLARE oldstatus varchar(20);
  DECLARE newstatus varchar(20);
  SET oldstatus = new.orderstatus;
    SET opens = (SELECT m.openTime
    FROM market as m
    WHERE marketID = new.marketID);
    
    SET closes = (SELECT m.closeTime
    FROM market as m
    WHERE marketID = new.marketID);
   
     SET mAmount = (SELECT p.amount
                   FROM product as p
                   WHERE p.marketID = new.marketID
                   and p.productID = new.productID);
     SET oAmount = new.amount;
     
     SET shippers = (SELECT s.shipperStatus
                    from shipper as s
                    where new.marketID = s.marketID);
  SET price = (SELECT p.price * new.amount
                   FROM product as p
                   WHERE p.marketID = new.marketID
                   and p.productID = new.productID); 

                   
IF date_format(NOW(),'%H:%i:%s') BETWEEN date_format(opens,'%H:%i:%s') and date_format(closes,'%H:%i:%s') THEN
IF mAmount >= oAmount THEN
IF shippers = "free" THEN
        SET message = "no problem";
              SET newstatus = "sending";
              UPDATE shipper SET shipperstatus = "busy" WHERE new.marketID = shipper.marketID;
              if new.payment = "bank" THEN
              INSERT INTO banklog (customerID,bankName,creditAmount,transactionDate,transactionType) values (new.customerID,"Shaparak",price,now(),"internetShop");
              ELSEIF new.payment = "credit" THEN
              UPDATE customer SET credit = credit - price WHERE new.customerID = customerID;   
        END IF; 
ELSE SET newstatus = "ignored"; SET message = "no free shipper";
END IF;
ELSE SET newstatus = "ignored"; SET message = "not much amount";
END IF;
ELSE SET newstatus = "ignored"; SET message = "market is closed";
END IF;
INSERT INTO orderslog(supporterID, operatorID, ordersID, statusOld, statusNew, why, logDate) VALUES (new.marketID,new.marketID,new.OrdersID,oldStatus,newstatus,message,NOW());
SET new.orderstatus = newstatus;
END$$
DELIMITER ;