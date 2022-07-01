--Allows a customer to place an order by giving their payment method,product id, quantity and their customer_id. Will update the customer_orders. 
Drop Function Ordering_Product(varchar,varchar,varchar,varchar,int);
Create or replace function Ordering_Product(Customer_ID varchar, Order_Id varchar, Payment_Method varchar(50),Product_ID varchar,Quantity int)
   returns  void 
   language plpgsql
  as
$$
begin
    perform Decrease_Quantity(Product_ID,Quantity) ;
    Insert into Customer_Orders Values(Customer_ID,Order_Id,Payment_Method,'Unpaid',Product_ID,Quantity);
    perform Assign_Driver(Product_ID,Order_ID);
end;
$$;


--Decreasing Quantity()--Will decrease the quantity. Updates the record. There is a trigger check for that. Will update the Product_Catalog 
Drop Function If Exists Decrease_Quantity(varchar,int);
Create or Replace function Decrease_Quantity(Product_ID_Decrease varchar(50),Quantity_Decrease int)
   returns void 
   language plpgsql
  as
$$
begin
    Update Product_Catalog 
    Set Available_QTY=Available_QTY-Quantity_Decrease
    Where ID=Product_ID_Decrease;
end;
$$;


--This trigger will ensure that the quantity of the product as per product_catalog is not taken to a negative value
Drop Function If Exists Decrease_Quantity_Trigger_Check() Cascade;
Create or Replace function Decrease_Quantity_Trigger_Check()
   returns TRIGGER
   language plpgsql
  as
$$
begin
    if NEW.Available_QTY<0 then
        Raise Exception 'Quantity is decreasing below zero. Please Order a Quantity that is lower then the one you have chosen';
    end if;
    return new;
end;
$$;
CREATE TRIGGER Decrease_Quantity_In_Product_Quantity
  BEFORE UPDATE
  ON Product_Catalog
  FOR EACH ROW
  EXECUTE PROCEDURE Decrease_Quantity_Trigger_Check();






--Assign_Driver()--Will select from one of the available drivers and update the Order_Delivered_By table
Drop Function if exists Assign_Driver(varchar) Cascade;
Create or replace function Assign_Driver(Customer_ID varchar)
   returns void
   language plpgsql
  as
$$
declare 
    check_insert integer :=0;
    cur cursor for select Name, ID from Transportation_Drivers;
    pointer record;
begin
    open cur;
    loop
        fetch cur into pointer;
        exit when not found;
        Insert into Order_Delivered_By Values(pointer.ID,Customer_ID);
        get diagnostics check_insert = ROW_COUNT;
        if check_insert = 1 then
            raise notice 'Order has been alloted to driver % with Driver_ID: %', pointer.Name, pointer.ID ;
            exit;
        end if;
    end loop;
    close cur;
    if check_insert = 0 then
        raise exception 'All drivers already have 3 orders to deliver!!';
    end if;
end;
$$;




--This trigger will ensure that the number of orders handled by a driver is restricted to 3
Drop Function If Exists Assign_Driver_Trigger() Cascade;
Create or replace function Assign_Driver_Trigger()
   returns TRIGGER
   language plpgsql
  as
$$
declare 
    Number_Of_Orders int;
begin
    Select into Number_Of_Orders  ( Select Count(*)
                                    From Order_Delivered_By
                                    Where Transportation_Driver_ID = New.Transportation_Driver_ID);
    If Number_Of_Orders >= 3 then 
        return null;
    End If;
    return new;
end;
$$;


Drop Trigger If Exists Assign_Driver_Check on Order_Delivered_By;
CREATE TRIGGER Assign_Driver_Check
  BEFORE INSERT
  ON Order_Delivered_By
  FOR EACH ROW
  EXECUTE PROCEDURE Assign_Driver_Trigger();