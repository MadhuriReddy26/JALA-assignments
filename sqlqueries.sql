USE assignment;
 CREATE TABLE salespeople (snum INT PRIMARY KEY,sname VARCHAR(50),city VARCHAR(50),comm DECIMAL(5,2));
INSERT INTO salespeople (snum, sname, city, comm)VALUES(1, 'John Doe', 'New York', 0.12),(2, 'Jane Smith', 'London', 0.10),(3, 'Alice Johnson', 'Barcelona', 0.15),(4, 'Bob Brown', 'London', 0.13);
CREATE TABLE customers (
    cnum INT PRIMARY KEY,
    cname VARCHAR(50),
    city VARCHAR(50),
    rating INT
);

INSERT INTO customers (cnum, cname, city, rating)
VALUES
(1, 'Michael Green', 'San Jose', 100),
(2, 'Sarah White', 'London', 300),
(3, 'David Black', 'Rome', 250),
(4, 'Laura Blue', 'San Jose', 350);
CREATE TABLE orders (
    orderno INT PRIMARY KEY,
    cnum INT,
    snum INT,
    amt DECIMAL(10,2),
    order_date DATE,
    FOREIGN KEY (cnum) REFERENCES customers(cnum),
    FOREIGN KEY (snum) REFERENCES salespeople(snum)
);

INSERT INTO orders (orderno, cnum, snum, amt, order_date)
VALUES
(1, 1, 1, 1200.50, '1994-10-03'),
(2, 2, 2, 1500.75, '1994-10-03'),
(3, 3, 3, 800.00, '1994-10-04'),
(4, 4, 4, 2500.00, '1994-10-04');
CREATE TABLE salesperson_customer (
    snum INT,
    cnum INT,
    PRIMARY KEY (snum, cnum),
    FOREIGN KEY (snum) REFERENCES salespeople(snum),
    FOREIGN KEY (cnum) REFERENCES customers(cnum)
);

INSERT INTO salesperson_customer (snum, cnum)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4);

SELECT snum, sname, city, comm FROM salespeople;
SELECT DISTINCT snum FROM orders;
SELECT sname, comm FROM salespeople WHERE city = 'London';
SELECT * FROM customers WHERE rating = 100;
SELECT orderno, amt, order_date FROM orders;
SELECT * FROM customers WHERE city = 'San Jose' AND rating > 200;
SELECT * FROM customers WHERE city = 'San Jose' OR rating > 200;
SELECT * FROM orders WHERE amt > 1000;
SELECT sname, city FROM salespeople WHERE city = 'London' AND comm > 0.10;
SELECT * FROM customers WHERE NOT (rating <= 100 AND city <> 'Rome');
SELECT * FROM salespeople WHERE city IN ('Barcelona', 'London');
SELECT * FROM salespeople WHERE comm > 0.10 AND comm < 0.12;
SELECT * FROM customers WHERE city IS NULL;
SELECT * FROM orders WHERE order_date IN ('1994-10-03', '1994-10-04');
SELECT c.* FROM customers c
JOIN salesperson_customer sc ON c.cnum = sc.cnum
JOIN salespeople s ON sc.snum = s.snum
WHERE s.sname IN ('Peel', 'Motika');
SELECT * FROM customers WHERE cname LIKE 'A%' OR cname LIKE 'B%';
SELECT * FROM orders WHERE amt > 0 OR amt IS NOT NULL;
SELECT COUNT(DISTINCT snum) FROM orders;
SELECT snum, MAX(amt), order_date FROM orders GROUP BY snum, order_date;
SELECT snum, MAX(amt), order_date FROM orders WHERE amt > 3000 GROUP BY snum, order_date;
SELECT order_date, SUM(amt) AS total_amount
FROM orders
GROUP BY order_date
ORDER BY total_amount DESC
LIMIT 1;

SELECT COUNT(*) 
FROM orders
WHERE order_date = '1994-10-03';

SELECT COUNT(DISTINCT city)
FROM customers
WHERE city IS NOT NULL;

SELECT c.cnum, c.cname, MIN(o.amt) AS smallest_order
FROM customers c
JOIN orders o ON c.cnum = o.cnum
GROUP BY c.cnum;

SELECT cname 
FROM customers
WHERE cname LIKE 'G%'
ORDER BY cname ASC
LIMIT 1;

SELECT CONCAT('For ', DATE_FORMAT(order_date, '%d/%m/%y'), ' there are ', COUNT(*) , ' orders') AS order_summary
FROM orders
GROUP BY order_date;

SELECT o.orderno, o.snum, o.amt * 0.12 AS commission
FROM orders o;

SELECT city, MAX(rating) AS highest_rating
FROM customers
GROUP BY city;

SELECT order_date, SUM(amt) AS total_amount
FROM orders
GROUP BY order_date
ORDER BY total_amount DESC;

SELECT s.sname, c.cname
FROM salespeople s
JOIN customers c ON s.city = c.city;

SELECT c.cname, s.sname
FROM customers c
JOIN salesperson_customer sc ON c.cnum = sc.cnum
JOIN salespeople s ON sc.snum = s.snum;

SELECT o.orderno, c.cname
FROM orders o
JOIN customers c ON o.cnum = c.cnum;

SELECT o.orderno, s.sname, c.cname
FROM orders o
JOIN salespeople s ON o.snum = s.snum
JOIN customers c ON o.cnum = c.cnum;

SELECT c.cname
FROM customers c
JOIN salesperson_customer sc ON c.cnum = sc.cnum
JOIN salespeople s ON sc.snum = s.snum
WHERE s.comm > 0.12;

SELECT o.orderno, o.snum, o.amt * s.comm AS commission
FROM orders o
JOIN salespeople s ON o.snum = s.snum
JOIN customers c ON o.cnum = c.cnum
WHERE c.rating > 100;

SELECT c1.cname AS customer1, c2.cname AS customer2, c1.rating
FROM customers c1
JOIN customers c2 ON c1.rating = c2.rating AND c1.cnum < c2.cnum;

SELECT sc1.snum AS salesperson1, sc2.snum AS salesperson2, sc3.snum AS salesperson3, sc.cnum
FROM salesperson_customer sc
JOIN salesperson_customer sc1 ON sc.cnum = sc1.cnum
JOIN salesperson_customer sc2 ON sc.cnum = sc2.cnum
JOIN salesperson_customer sc3 ON sc.cnum = sc3.cnum
WHERE sc1.snum < sc2.snum AND sc2.snum < sc3.snum;

SELECT c.cname, c.city
FROM customers c
WHERE c.city IN (
    SELECT s.city
    FROM salespeople s
    WHERE s.sname = 'Serres'
);

SELECT c1.cname AS customer1, c2.cname AS customer2, sc.snum
FROM customers c1
JOIN customers c2 ON c1.cnum < c2.cnum
JOIN salesperson_customer sc ON c1.cnum = sc.cnum AND c2.cnum = sc.cnum;

SELECT s1.sname AS salesperson1, s2.sname AS salesperson2, s1.city
FROM salespeople s1
JOIN salespeople s2 ON s1.city = s2.city AND s1.snum < s2.snum;

SELECT c.cname, c.city
FROM customers c
JOIN salespeople s ON c.cnum = s.snum
WHERE s.sname = 'Hoffman' AND c.rating = (SELECT rating FROM customers WHERE cname = 'Hoffman');

SELECT o.orderno, o.amt
FROM orders o
JOIN salespeople s ON o.snum = s.snum
WHERE s.sname = 'Motika';

SELECT o.orderno, o.amt
FROM orders o
JOIN salespeople s ON o.snum = s.snum
WHERE s.sname = 'Hoffman';

SELECT * 
FROM orders 
WHERE amt > (SELECT AVG(amt) FROM orders WHERE order_date = '1994-10-04');

SELECT AVG(comm) AS avg_commission
FROM salespeople
WHERE city = 'London';

SELECT o.orderno, o.amt
FROM orders o
JOIN salesperson_customer sc ON o.cnum = sc.cnum
JOIN salespeople s ON sc.snum = s.snum
WHERE s.city = 'London';

SELECT DISTINCT s.sname, s.comm
FROM salespeople s
JOIN salesperson_customer sc ON s.snum = sc.snum
JOIN customers c ON sc.cnum = c.cnum
WHERE c.city = 'London';

SELECT c.cname
FROM customers c
JOIN salespeople s ON c.cnum > (s.snum + 1000)
WHERE s.sname = 'Serres';

SELECT COUNT(*)
FROM customers
WHERE rating > (SELECT AVG(rating) FROM customers WHERE city = 'San Jose');
