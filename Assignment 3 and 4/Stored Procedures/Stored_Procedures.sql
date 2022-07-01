--Getting Product Pick Up location from Order_ID
Drop Procedure Pick_Up_Product;
Create procedure Pick_Up_Product(Order_ID varchar(20))
language plpgsql
as $$
declare
    Pick_Up_Location varchar(20);
begin
    Select W.Location into Pick_Up_Location
    From Product_Catalog as P,Warehouse_Location as W,Customer_Orders as O
    Where P.Warehouse_ID=W.id AND O.Product_ID=P.id AND O.id=Order_ID;
    Raise Notice 'Pick up location is (%)',Pick_Up_Location;
end; 
$$;

--Getting Product Drop Location from Order_ID
Drop Procedure Drop_Product;
Create procedure Drop_Product(Order_ID varchar(20))
language plpgsql
as $$
declare
    Drop_Location varchar(20);
begin
    Select C.Address into Drop_Location
    From Product_Catalog as P, Customers as C,Customer_Orders as O
    Where O.Product_ID=P.id AND O.Customer_ID=C.id And O.id=Order_ID;
    Raise Notice 'Drop location is (%)',Drop_Location;
end; 
$$;