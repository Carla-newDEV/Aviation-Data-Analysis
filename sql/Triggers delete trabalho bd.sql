/* Triggers para Delete*/
DELIMITER $$

CREATE TRIGGER bloqueia_delete_customer
BEFORE DELETE ON costumers
FOR EACH ROW
BEGIN 
  INSERT INTO log_tentativas_costumer(
    timestamp,
  user,
  operation,
  issue,
  sql_text
  )
  VALUES(
    NOW(),
    CURRENT_USER(),
    'DELETE',
      CONCAT('Attempt to delete customer employeeNumber: ', OLD.employeeNumber),
      CONCAT('DELETE FROM customer WHERE employeeNumber = ', OLD.employeeNumber)
  );

  SIGNAL SQLSTATE '45000'
  SET MESSAGE_TEXT = 'Exclusion not permitted'

END$$

DELIMITER $$

CREATE TRIGGER bloqueia_delete_payments
BEFORE DELETE ON payments
FOR EACH ROW 
BEGIN
  INSERT INTO log_tentativas_payments(
    timestamp,
  user,
  operation,
  issue,
  sql_text
  )
  VALUES(
    NOW(),
    CURRENT_USER(),
    'DELETE',
      CONCAT('Attempt to delete payment customerNumber: ', OLD.customerNumber),
      CONCAT('DELETE FROM payment WHERE customerNumber = ', OLD.customerNumber)
  );

END$$

DELIMITER $$

CREATE TRIGGER bloqueia_delete_orders
BEFORE DELETE ON orders
FOR EACH ROW 
BEGIN
  INSERT INTO log_tentativas_orders(
    timestamp,
  user,
  operation,
  issue,
  sql_text
  )
  VALUES(
    NOW(),
    CURRENT_USER(),
    'DELETE',
      CONCAT('Attempt to delete order orderNumber: ', orderNumber),
      CONCAT('DELETE FROM order WHERE orderNumber = ', orderNumber)
  );

END$$

DELIMITER $$

CREATE TRIGGER bloqueia_delete_orderdetails
BEFORE DELETE ON orderdetails
FOR EACH ROW 
BEGIN
  INSERT INTO log_tentativas_orderdetails(
    timestamp,
  user,
  operation,
  issue,
  sql_text
  )
  VALUES(
    NOW(),
    CURRENT_USER(),
    'DELETE',
      CONCAT('Attempt to delete orderdetails orderNumber: ', orderNumber),
      CONCAT('DELETE FROM orderdetails WHERE orderNumber = ', orderNumber)
  );

END$$