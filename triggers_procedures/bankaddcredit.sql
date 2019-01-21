DELIMITER $$

CREATE TRIGGER bankAddCredit
AFTER INSERT ON banklog
FOR EACH ROW
BEGIN
	DECLARE a int;
    DECLARE d int;
IF NEW.transactionType = "addCredit" THEN
    SET d = new.customerID;
    SET a = new.creditAmount;
    UPDATE customer
    SET credit = credit + a
    where customerID = d;
END IF;
END$$
DELIMITER ;