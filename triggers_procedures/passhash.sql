DELIMITER $$

CREATE TRIGGER passHash
BEFORE insert ON customer
FOR EACH ROW BEGIN
DECLARE p varchar(256);
set p = new.pass;
set new.pass = aes_encrypt(p,"1234");

END$$