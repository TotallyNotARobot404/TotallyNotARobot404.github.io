REM   Script: Artifact Three
REM   Refurbished Artifact Three

--Create the table customers with info
create table Customers (   
CustomerID        	number,   
HiddenID           	number, 
FirstName         	varchar2(25) not null,   
LastName    	      varchar2(25) not null,   
Street 		          varchar2(50), 
City 		            varchar2(50), 
State 		          varchar2 (25), 
ZipCode 		        number, 
Telephone 	        varchar2(15), 
  constraint pk_customerID primary key (CustomerID)   --set primary key
);

--Create the table Orders
create table Orders ( 
OrderID 		  number, 
CustomerID 	  number, 
HiddenID      number, 
SKU 		      varchar2(20), 
Description 	varchar2(75), 
Datestamp     date, 
TimeoDate     varchar2(50), 
constraint pk_orderID primary key (OrderID) --set primary key  
);

--add a new foreign key to orders from customer info
ALTER TABLE Orders    
      ADD (constraint fk_customers_ID foreign key (CustomerID)  
      references Customers (CustomerID));

--Created the table RMA
create table RMA ( 
RMAID 		  number, 
OrderID 		number, 
HiddenID    number, 
Datestamp   date, 
TimeoDate   varchar2(50), 
Step 		    varchar2(50) not null, 
Status 		  varchar2(50), 
Reason 		  varchar2(50), 
constraint pk_key primary key (RMAID)  --set primary key
);

--alter to add foreign key
ALTER TABLE Orders    
      ADD (constraint fk_Order_ID foreign key (OrderID)  
      references Orders (OrderID));

--create a trigger to place in a 32 digit hiddenID to track each piece of data
--trigger procs when new data is added
--placed into Customers
create or replace trigger  Customers_BIU 
    before insert or update on Customers 
    for each row 
begin 
    if inserting and :new.HiddenID is null then 
        :new.HiddenID := to_number(sys_guid(),  
            'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'); 
    end if; 
end; 
/

--same as before but for orders
create or replace trigger  Orders_BIU 
    before insert or update on Orders 
    for each row 
begin 
    if inserting and :new.HiddenID is null then 
        :new.HiddenID := to_number(sys_guid(),  
            'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'); 
    end if; 
end; 
/

--same as before but for RMA
create or replace trigger  RMA_BIU 
    before insert or update on RMA 
    for each row 
begin 
    if inserting and :new.HiddenID is null then 
        :new.HiddenID := to_number(sys_guid(),  
            'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'); 
    end if; 
end; 
/

--inserting the data into the system to test
INSERT INTO Customers (CustomerID, FirstName, LastName, Street, City, State, ZipCode, Telephone) 
  WITH names AS ( 
SELECT 000014, 'Leona', 'Kingscholar', '2 Palace Land', 'Farena’s Palace', 'Afterglow Savana', 38239, '149-985-5191' FROM dual UNION ALL 
SELECT 000015,'Ruggie', 'Bucchi', '45 Savana Village', 'Hyena Village', 'Afterglow Savana', 38183, '167-952-5696' FROM dual UNION ALL 
SELECT 000016,'Jack', 'Howl', '27 Village Home', 'Cute Little Village', 'Land of Pyroxene', 93000, '938-045-9015' FROM dual UNION ALL 
SELECT 000017,'Rozeal', 'Caelux', '13 Real Street', 'NotFarmingham', 'Massachusetts', 23447, '124-235-2345' FROM dual UNION ALL 
    SELECT 997745, 'Riddle', 'Rosehearts', '27 House Street', 'Rosebud City', 'Rose Queendom', 23513, '679-690-0897' FROM dual UNION ALL  
    SELECT 463634, 'Ace', 'Trappola', '9 Home Ln', 'Flowers Town', 'Rose Queendom', 23234, '917-062-2685'   FROM dual UNION ALL  
    SELECT 091273, 'Teneva', 'Digibris', '86 Sure Exists', 'Farmingham', 'Massachusetts', 76566, '356-676-5433' FROM dual UNION ALL  
    SELECT 420952, 'Deuce', 'Spade', '5 Best Boy Ave', 'Bloomingville', 'Rose Queendom', 23039, '182-708-6353'    FROM dual UNION ALL 
    SELECT 238952, 'Trey', 'Clover', '63 Baker’s Lane', 'Rosebud City', 'Rose Queendom', 23514, '124-611-0886' FROM dual UNION ALL 
    SELECT 328571, 'Aradia', 'Caelux', '13 Real Street', 'Farmingham', 'Massachusetts', 23447, '565-234-2348' FROM dual UNION ALL 
    SELECT 398571, 'Cater', 'Diamond', '7 House St', 'Somewhere City', 'Land of Pyroxene', 93218, '802-050-7045' FROM dual 
)  
  SELECT * FROM names 
;

--create a view for systems similar to former data
create view Collaborators as 
 select CustomerID as CollaboratorID, FirstName, LastName, Street, City, State, ZipCode, Telephone 
from Customers;

SELECT * FROM Collaborators 
;

--insert orders into orders table to use
INSERT INTO Orders (OrderID, CustomerID, SKU, Description, Datestamp, TimeoDate) 
  WITH orderinfo AS (  
SELECT 4546572, 997745, 'ADV-24-10C ', 'Advanced Switch 10GigE Copper 24 port', TO_DATE(sysdate, 'yyyy/mm/dd hh24:mi:ss'),  to_char(sysdate,'MM/DD/YYYY HH:MI:SS') FROM dual UNION ALL 
SELECT 7580695, 463634, 'ADV-48-10F ', 'Advanced Switch 10 GigE Copper/Fiber 44 port copper 4 port fiber ', TO_DATE(sysdate, 'yyyy/mm/dd hh24:mi:ss'),  to_char(sysdate,'MM/DD/YYYY HH:MI:SS') FROM dual UNION ALL 
SELECT 3562743, 091273, 'ENT-24-10F ', 'Enterprise Switch 10GigE SFP+ 24 Port', TO_DATE(sysdate, 'yyyy/mm/dd hh24:mi:ss'),  to_char(sysdate,'MM/DD/YYYY HH:MI:SS') FROM dual UNION ALL 
SELECT 5175, 420952, ' ENT-48-10F ', 'Enterprise Switch 10GigE SFP+ 48 port', TO_DATE(sysdate, 'yyyy/mm/dd hh24:mi:ss'),  to_char(sysdate,'MM/DD/YYYY HH:MI:SS') FROM dual UNION ALL 
SELECT 214151, 238952, 'ADV-24-10C ', 'Advanced Switch 10GigE Copper 24 port', TO_DATE(sysdate, 'yyyy/mm/dd hh24:mi:ss'),  to_char(sysdate,'MM/DD/YYYY HH:MI:SS') FROM dual UNION ALL 
SELECT 32526216, 328571, 'ENT-24-10F ', 'Enterprise Switch 10GigE SFP+ 24 Port', TO_DATE(sysdate, 'yyyy/mm/dd hh24:mi:ss'),  to_char(sysdate,'MM/DD/YYYY HH:MI:SS') FROM dual UNION ALL 
SELECT 2104129041, 398571, 'ENT-24-10F ', 'Enterprise Switch 10GigE SFP+ 24 Port', TO_DATE(sysdate, 'yyyy/mm/dd hh24:mi:ss'),  to_char(sysdate,'MM/DD/YYYY HH:MI:SS') FROM dual 
) 
SELECT * FROM orderinfo 
;

Select * from Orders;

--insert RMA into RMA table for use
INSERT INTO RMA (RMAID, OrderID, Datestamp, TimeoDate, Step, Status, Reason)   
WITH rma AS ( 
SELECT 953209, 4546572, TO_DATE(sysdate, 'yyyy/mm/dd hh24:mi:ss'),  to_char(sysdate,'MM/DD/YYYY HH:MI:SS'), 'Failed Submission', 'Incomplete', 'Rejected' FROM dual UNION ALL 
SELECT 241415, 5175, TO_DATE(sysdate, 'yyyy/mm/dd hh24:mi:ss'),  to_char(sysdate,'MM/DD/YYYY HH:MI:SS'), 'Awaiting customer Documentation', 'Pending', 'needed documentation' FROM dual UNION ALL 
SELECT 463314, 7580695, TO_DATE(sysdate, 'yyyy/mm/dd hh24:mi:ss'),  to_char(sysdate,'MM/DD/YYYY HH:MI:SS'), 'Credit Customer Account', 'Complete', 'Customer has paid' FROM dual UNION ALL 
SELECT 938275, 3562743, TO_DATE(sysdate, 'yyyy/mm/dd hh24:mi:ss'),  to_char(sysdate,'MM/DD/YYYY HH:MI:SS'), 'NA', 'Incomplete', 'Rejected' FROM dual 
) 
 
select * from rma;

--test to see if worked
select * from RMA;

--start specific query to find state with Massachusetts
SELECT COUNT(*) 
FROM Customers  
WHERE UPPER(Customers.state) = 'MASSACHUSETTS';

--add old customer data into the system again
INSERT INTO Customers (CustomerID, FirstName, LastName, Street, City, State, ZipCode, Telephone)   
WITH names AS ( 
SELECT 100004, 'Luke', 'Skywalker', '15 Maiden Lane ', 'New York City', 'New York', 10222, '212-555-1234' FROM dual UNION ALL 
SELECT 100005, 'Winston', 'Smith', '123 Sycamore Street ', ' Greensboro ', 'North Carolina', 27401, '919-555-6623' FROM dual UNION ALL 
SELECT 100006, 'MaryAnne', 'Jenkins', '1 Coconut Way ', ' Jupiter ', 'Florida', 33458, '321-555-8907' FROM dual UNION ALL 
SELECT 100007, 'Janet', 'Williams', '55 Redondo Beach Blvd ', 'Torrence', 'California', 90501, '310-555-5678' FROM dual 
) 
 
Select * from names 
;

--add old order data into system again
INSERT INTO Orders (OrderID, CustomerID, SKU, Description, Datestamp, TimeoDate) 
  WITH orderinfo AS (  
SELECT 1204305, 100004, 'ADV-24-10C ', 'Advanced Switch 10GigE Copper 24 port', TO_DATE(sysdate, 'yyyy/mm/dd hh24:mi:ss'),  to_char(sysdate,'MM/DD/YYYY HH:MI:SS')  FROM dual UNION ALL 
SELECT 1204306, 100005, 'ADV-48-10F ', 'Advanced Switch 10 GigE Copper/Fiber 44 port copper 4 port fiber ', TO_DATE(sysdate, 'yyyy/mm/dd hh24:mi:ss'),  to_char(sysdate,'MM/DD/YYYY HH:MI:SS')  FROM dual UNION ALL 
SELECT 1204307, 100006, 'ENT-24-10F ', 'Enterprise Switch 10GigE SFP+ 24 Port  ', TO_DATE(sysdate, 'yyyy/mm/dd hh24:mi:ss'),  to_char(sysdate,'MM/DD/YYYY HH:MI:SS')  FROM dual UNION ALL 
SELECT 1204308, 100007, ' ENT-48-10F ', 'Enterprise Switch 10GigE SFP+ 48 port ', TO_DATE(sysdate, 'yyyy/mm/dd hh24:mi:ss'),  to_char(sysdate,'MM/DD/YYYY HH:MI:SS')  FROM dual  
) 
SELECT * FROM orderinfo 
;

--confirm it went through
select * from Orders;

--search for city to ensure it works properly
SELECT COUNT(*) 
From Customers 
WHERE UPPER(Customers.city) = 'ROSEBUD CITY';

--search for one specific RMA
SELECT Status, Step 
FROM RMA 
WHERE OrderID = 5175;

--Using update in CRUD functionality
UPDATE RMA 
SET Status = 'Complete', Step = 'Credit Customer Account' 
WHERE OrderID = 5175;

--search again to confirm change
SELECT Status, Step 
FROM RMA 
WHERE OrderID = 5175;

--using delete in CRUD functionality
DELETE FROM RMA 
WHERE UPPER(Reason) = 'REJECTED';

--confirm if everything went correctly with the tables
select * from RMA;

select * from Customers;

select * from Orders;

