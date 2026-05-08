DELIMITER $$

-- Trigger para a tabela CUSTOMERS
CREATE TRIGGER bloqueia_delete_customer
BEFORE DELETE ON customers
FOR EACH ROW
BEGIN 
  INSERT INTO log_tentativas_deletar (timestamp, user, operation, issue, sql_text)
  VALUES (NOW(), CURRENT_USER(), 'DELETE', 
          CONCAT('Tentativa de excluir cliente: ', OLD.customerNumber), 
          CONCAT('DELETE FROM customers WHERE customerNumber = ', OLD.customerNumber));

  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Exclusão não permitida na tabela customers';
END$$

-- Trigger para a tabela PAYMENTS
CREATE TRIGGER bloqueia_delete_payments
BEFORE DELETE ON payments
FOR EACH ROW 
BEGIN
  INSERT INTO log_tentativas_deletar (timestamp, user, operation, issue, sql_text)
  VALUES (NOW(), CURRENT_USER(), 'DELETE', 
          CONCAT('Tentativa de excluir pagamento do cliente: ', OLD.customerNumber), 
          CONCAT('DELETE FROM payments WHERE customerNumber = ', OLD.customerNumber));

  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Exclusão não permitida na tabela payments';
END$$

-- Trigger para a tabela ORDERS
CREATE TRIGGER bloqueia_delete_orders
BEFORE DELETE ON orders
FOR EACH ROW 
BEGIN
  INSERT INTO log_tentativas_deletar (timestamp, user, operation, issue, sql_text)
  VALUES (NOW(), CURRENT_USER(), 'DELETE', 
          CONCAT('Tentativa de excluir pedido: ', OLD.orderNumber), 
          CONCAT('DELETE FROM orders WHERE orderNumber = ', OLD.orderNumber));

  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Exclusão não permitida na tabela orders';
END$$

-- Trigger para a tabela ORDERDETAILS
CREATE TRIGGER bloqueia_delete_orderdetails
BEFORE DELETE ON orderdetails
FOR EACH ROW 
BEGIN
  INSERT INTO log_tentativas_deletar (timestamp, user, operation, issue, sql_text)
  VALUES (NOW(), CURRENT_USER(), 'DELETE', 
          CONCAT('Tentativa de excluir detalhe do pedido: ', OLD.orderNumber), 
          CONCAT('DELETE FROM orderdetails WHERE orderNumber = ', OLD.orderNumber));

  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Exclusão não permitida na tabela orderdetails';
END$$

DELIMITER ;