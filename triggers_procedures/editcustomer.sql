DELIMITER $$
CREATE PROCEDURE editCustomer ( in editorID int, in toEditID int,
                               in customerID1 int,
                               in pass1 varchar(256),
                               in email1 varchar(20),
                               in fname1 varchar(20),
                               in lname1 varchar(20),
                               in postcode1 int,
                               in gender1 int,
                               in credit1 int)
BEGIN
	IF editorID = toEditID THEN
    UPDATE customer
    SET customerID = customerID1,
    	pass = pass1,
        email = email1,
        fname = fname1,
        lname = lname1,
        postcode = postcode1,
        gender = gender1,
        credit = credit1
	WHERE customerID = toEditID;
    END IF;
END$$