/*Simple Queries*/
/*Selecting number of Orders A Customer has ordered*/

Select C.id, O.id, O.Product_ID, C.name
From Customers as C, Customer_Orders as O
Where C.id=O.Customer_ID;

Explain Analyze Select C.id,(Count (*))
                From Customers as C, Customer_Orders as O
                Where C.id=O.Customer_ID
                Group By C.id;

Select C.id,(Count (*))
From Customers as C, Customer_Orders as O
Where C.id=O.Customer_ID
Group By C.id;

/*Selecting number of Orders A Driver is driving*/

Select D.id, O.transportation_driver_id, D.name
From Transportation_Drivers as D, Order_Delivered_By as O
Where D.id=O.transportation_driver_id;

Explain Analyze Select D.id,(Count (*))
                From Transportation_Drivers as D, Order_Delivered_By as O
                Where D.id=O.transportation_driver_id
                Group By D.id;

Select D.id,(Count (*))
From Transportation_Drivers as D, Order_Delivered_By as O
Where D.id=O.transportation_driver_id
Group By D.id;

/*Selecting number of Products Handled by a SalesPerson*/

Select S.id,S.name,P.id,P.name
From Sales_Person as S,Product_Catalog as P
Where S.id=P.Sales_Person_ID;

Explain Analyze Select S.id,(Count (*))
                From Sales_Person as S,Product_Catalog as P
                Where S.id=P.Sales_Person_ID
                Group By S.id;

Select S.id,(Count (*))
From Sales_Person as S,Product_Catalog as P
Where S.id=P.Sales_Person_ID
Group By S.id;

/*Selecting Number of Employees that work for each transportation company*/

Select E.id,E.name,C.id,C.name
From Transportation_Drivers as E, Transportation_Company as C
Where E.Transportation_Company_ID=C.id;

Explain  Analyze Select C.id,(Count (*))
From Transportation_Drivers as E, Transportation_Company as C
Where E.Transportation_Company_ID=C.id
Group By C.id;

Select C.id,(Count (*))
From Transportation_Drivers as E, Transportation_Company as C
Where E.Transportation_Company_ID=C.id
Group By C.id;

/*Selecting Number of Employees that work for each sales company*/

Select E.id,E.name,C.id,C.name
From Sales_Person as E, Sales_Company as C
Where E.Sales_Company_ID=C.id;

Explain Analyze Select C.id,(Count (*))
        From Sales_Person as E, Sales_Company as C
        Where E.Sales_Company_ID=C.id
        Group By C.id;

Select C.id,(Count (*))
From Sales_Person as E, Sales_Company as C
Where E.Sales_Company_ID=C.id
Group By C.id;

/*Complex Queries*/
/*Selecting Transportation Company that have more then n employees*/

Explain Analyze Select C.id,(Count (*))
        From Transportation_Drivers as E, Transportation_Company as C
        Where E.Transportation_Company_ID=C.id
        Group By C.id
        Having Count(*)>2
        Order BY C.id;

Select C.id,(Count (*))
From Transportation_Drivers as E, Transportation_Company as C
Where E.Transportation_Company_ID=C.id
Group By C.id
Having Count(*)>2
Order BY C.id;

/*Selecting  Sales Company that have more then n employees*/

Explain Analyze Select C.id,(Count (*))
        From Sales_Person as E, Sales_Company as C
        Where E.Sales_Company_ID=C.id
        Group By C.id
        Having Count(*)>2
        Order By C.id;


Select C.id,(Count (*))
From Sales_Person as E, Sales_Company as C
Where E.Sales_Company_ID=C.id
Group By C.id
Having Count(*)>2
Order By C.id;

/*Selecting Customers With More then any order unpaid for*/
Explain Analyze Select C.id,(Count (*))
        From Customers as C, Customer_Orders as O
        Where C.id=O.Customer_ID AND O.Payment_Status='pending'
        Group By C.id
        Order By C.id;

Select C.id,(Count (*))
From Customers as C, Customer_Orders as O
Where C.id=O.Customer_ID AND O.Payment_Status='pending'
Group By C.id
Order By C.id;

/*Selecting Products Sold and Sorting them as per quantity*/
Explain Analyze Select P.name,(Count (*))
        From Product_Catalog as P,Customer_Orders as O
        Where P.id=O.Product_ID
        Group By P.name
        Order By Count(*);

Select P.name,(Count (*))
From Product_Catalog as P,Customer_Orders as O
Where P.id=O.Product_ID
Group By P.name
Order By Count(*);

/*Get The Order Delivery Location and the Warehouse_Location to pick it up from*/
Explain Analyze Select P.id,C.Address,W.Location
        From Product_Catalog as P, Customers as C, Warehouse_Location as W,Customer_Orders as O
        Where P.Warehouse_ID=W.id AND O.Product_ID=P.id AND O.Customer_ID=C.id
        Order By P.id;

Select P.id,C.Address,W.Location
From Product_Catalog as P, Customers as C, Warehouse_Location as W,Customer_Orders as O
Where P.Warehouse_ID=W.id AND O.Product_ID=P.id AND O.Customer_ID=C.id
Order By P.id;

/*Nested Queries*/
/*Get Customers Who have an order that is worth more then 1000*/
Explain Analyze Select C.name,C.id
                From Customers as C, Customer_Orders as E
                Where E.id in (  Select O.id 
                                 From Customer_Orders as O,Product_Catalog as P
                                 Where O.Product_ID=P.Id and O.Quantity*P.Price>1000)
                        AND 
                      E.Customer_Id=C.id;

Select C.name,C.id
From Customers as C, Customer_Orders as E
Where E.id in (  Select O.id 
                 From Customer_Orders as O,Product_Catalog as P
                 Where O.Product_ID=P.Id and O.Quantity*P.Price>1000)
        AND 
        E.Customer_Id=C.id;

/*Second One */
/*Have to do The last three queries. Will figure them out tomr bro*/