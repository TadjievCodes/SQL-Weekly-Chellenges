-- Practtice exercises

CREATE OR REPLACE FUNCTION CustOrders
RETURN NUMBER IS
      custid NUMBER(4,0) := 1001; -- HARDCORE FOR NOW iniatialised for 1001
      order_total NUMBER(4,0) :=0;
BEGIN 
     SELECT COUNT(o.Id) INTO order_total
     FROM customers c INNER JOIN orders o
          ON c.Id = o.customerId
     WHERE c.Id = custid;
     RETURN order_total;
     END;            

/*
Lines of Note:
• Line 1 – names the function CustOrders
• Line 2 – defines what is to be returned from the function in this case a NUMBER
• Line 3 – defines a variable called custid that has a NUMBER datatype initialized to an existing customer id
• Line 4 – defines another numeric variable called order_total initialized to zero
• Line 6 – places the result from the SELECT in to the order_total variable using the INTO keyword
• Line 9 – filters the results using the custid variable value
• Line 10 – returns the variable after it’s been loaded with data
Looking at the table of differences from above, item 3 suggests we can use our custom function the same way we use other Oracle functions. Let’s test this out using our old friend the DUAL table to test it out.
We
*/


-- if there are errors do 

SELECT * FROM user_errors;





-- test our function for customer


SELECT CustOrders AS "Total Orders For Customer 1001" FROM DUAL;






-- use of function in regular procedure

 
 CREATE OR REPLACE PROCEDURE test_CustOrders IS
 cust_number NUMBER := 1001;  -- STILL HARDCODED
BEGIN
 dbms_output.put_line('Customer ' || cust_number || ' has made ' || CustOrders || ' orders' );
END; 



-- Use of function CustOrders in anonymous procedure

BEGIN
  dbms_output.put_line('Customer 1001 has made ' || CustOrders || ' orders.');
END;





-- run the procedure

BEGIN
test_CustOrders;
END;

-- Exception Handling


CREATE OR REPLACE PROCEDURE test_CustOrders (cust_in IN NUMBER) IS
 order_tot NUMBER := 0;
BEGIN
 order_tot :=  CustOrders(cust_in);
IF order_tot = 0 THEN
  RAISE NO_DATA_FOUND;
ELSE 
  dmbs_output.put_line('Customer ' || cust_in || 'has made ' || order_tot || ' orders.');
END IF;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
   DBMS_OUTPUT.PUT_LINE('Customer ' || cust_in || ' has no orders.');        
END;











-- Week  12 LAB questions and answers

--====================================================================================================================
-- Question Number 2
/*
A stored procedure called pTopProductForMonth that has one input parameter month that can handle lower and upper case values).a.
Converts the string parameter to a corresponding month numberb.
Calls the Q1 function to obtain the product id with the top salesc.Dumps out a heading (include your name) 
and a line indicating the top product # for the monthd.If an invalid month is passed just print out an error
*/


CREATE OR REPLACE PROCEDURE pTopProductForMonth(ok IN VARCHAR2) IS 
vari NUMBER(2,0) := 0;
ans NUMBER(4,0) := 0;
BEGIN

CASE
WHEN lower(ok) = 'january' THEN vari := 1;
WHEN lower(ok) = 'february' THEN vari := 2;
WHEN lower(ok) = 'march' THEN vari := 3;
WHEN lower(ok) = 'april' THEN vari := 4;
WHEN lower(ok) = 'may' THEN vari := 5;
WHEN lower(ok) = 'june' THEN vari := 6;
WHEN lower(ok) = 'july' THEN vari := 7;
WHEN lower(ok) = 'august' THEN vari := 8;
WHEN lower(ok) = 'september' THEN vari := 9;
WHEN lower(ok) = 'october' THEN vari := 10;
WHEN lower(ok) = 'november' THEN vari := 11;
WHEN lower(ok) = 'december' THEN vari := 12;
ELSE vari := 0;
END CASE;
 


IF vari != 0 THEN
ans := topSeller(vari);          
dbms_output.put_line('Lab 10 - Tadjiev Muhammad');  
dbms_output.put_line('The top product for '|| ok ||' is product - '|| ans || CHR(10) );
ELSE
dbms_output.put_line('Invalid month entered');
END IF;
END;




-- changed the function name from HP_FUNCTION and changed my name







--***************************8888888888888
-- Question number 1 
/*
Create a function called topSeller that receives a month (as a number from1-12) and returns the product Id that has the highest 
sales (QtyOrdered x QuotedPrice) for the month variable.
*/
-- was callled HP_FUNCTION for the name of the function

CREATE OR REPLACE FUNCTION topSeller (monthNum IN NUMBER)
RETURN NUMBER IS
answer NUMBER(4,0) := 0;
BEGIN 
SELECT DISTINCT ORDER_DETAILS.PRODUCTID INTO answer 
FROM ORDER_DETAILS 
WHERE (ORDER_DETAILS.QUOTEDPRICE * ORDER_DETAILS.QTYORDERED) = (SELECT MAX(ORDER_DETAILS.QUOTEDPRICE * ORDER_DETAILS.QTYORDERED) 
FROM ORDER_DETAILS INNER JOIN ORDERS ON ORDER_DETAILS.ORDERID = ORDERS.ID  WHERE EXTRACT(MONTH FROM ORDERS.ORDERDATE) = monthNum);
RETURN answer;
END;






-- Another version of Q1 from Wonder

CREATE OR REPLACE FUNCTION topSeller (monthNum IN NUMBER)
RETURN NUMBER IS
answer NUMBER(4) := 0;
BEGIN 
SELECT PRODUCTID INTO answer 
FROM ORDER_DETAILS INNER JOIN ORDERS ON ORDERS.ID = ORDER_DETAILS.ORDERID  
WHERE EXTRACT(MONTH FROM ORDERS.ORDERDATE) = monthNum
GROUP BY PRODUCTID
ORDER BY SUM(ORDER_DETAILS.QTYORDERED * ORDER_DETAILS.QUOTEDPRICE) DESC
FETCH FIRST ROW ONLY;
RETURN answer;
END;








-- wonder's corrected version for q2
 

CREATE OR REPLACE PROCEDURE pTopProductForMonth(ok IN VARCHAR2) IS 
vari NUMBER(2,0) := 0;
ans NUMBER(4,0) := 0;
BEGIN

CASE
WHEN lower(ok) = 'january' THEN vari := 1;
WHEN lower(ok) = 'february' THEN vari := 2;
WHEN lower(ok) = 'march' THEN vari := 3;
WHEN lower(ok) = 'april' THEN vari := 4;
WHEN lower(ok) = 'may' THEN vari := 5;
WHEN lower(ok) = 'june' THEN vari := 6;
WHEN lower(ok) = 'july' THEN vari := 7;
WHEN lower(ok) = 'august' THEN vari := 8;
WHEN lower(ok) = 'september' THEN vari := 9;
WHEN lower(ok) = 'october' THEN vari := 10;
WHEN lower(ok) = 'november' THEN vari := 11;
WHEN lower(ok) = 'december' THEN vari := 12;
ELSE vari := 0;
END CASE;

ans := topSeller(vari);

IF vari != 0 THEN          
dbms_output.put_line('Lab 10 - Tadjiev Muhammad');  
dbms_output.put_line('The top product for '|| ok ||' is product - '|| ans || CHR(10) );
ELSE
RAISE NO_DATA_FOUND;
END IF;
EXCEPTION WHEN NO_DATA_FOUND THEN
dbms_output.put_line('Invalid month entered');
END;