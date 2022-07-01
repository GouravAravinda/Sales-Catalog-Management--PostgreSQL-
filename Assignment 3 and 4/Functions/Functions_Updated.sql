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
    perform Assign_Driver(Order_ID);
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
Drop Trigger If Exists Decrease_Quantity_In_Product_Quantity on Product_Catalog;
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

    /*
    Select into RowCount (Select Count(*) from Order_Delivered_By);
    for driver in (Select D.id
                   From Transportation_Company as C,Transportation_Drivers as D, Product_Catalog as P
                   Where C.id=D.Transportation_Company_ID AND P.id=Product_ID AND P.Transportation_Company_ID=C.id)
    loop
    Insert into Order_Delivered_By Values(driver.id,Customer_ID);
    Exception 
	   when 'Driver Already has 3 orders to take care of' then continue;
       else end loop;
    Select into AfterRowCount (Select Count(*) from Order_Delivered_By);
    If AfterRowCount=RowCount then 
        Raise 'Sorry No Drivers to deliver your order. Try Again later';
    end if;
    
    Select D.id into Driver
    From Transportation_Company as C,Transportation_Drivers as D, Product_Catalog as P
    Where C.id=D.Transportation_Company_ID AND P.id=Product_ID AND P.Transportation_Company_ID=C.id
    Limit 1;
    Insert into Order_Delivered_By Values(Driver.id,Customer_ID); */
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




/*Function to insert new entries into product catalog */
create or replace function CatalogInsert(Fname varchar, Product_ID varchar, price float, qty int, descp text, scompid varchar, sperid varchar, prodwarehid varchar, transpcompid varchar, warehouse varchar)
returns void
language plpgsql 
as
$$
    declare
        check_insert integer;
        curs cursor for select Name, ID from Sales_Person;
        pointer record;

    begin
        
        insert into Product_Catalog values(Fname, Product_ID, price, qty, descp, scompid, sperid, prodwarehid, transpcompid, warehouse);
        get diagnostics check_insert = ROW_COUNT;

        if check_insert = 0 then
            raise notice 'Sales Person with ID:% already handles 3 products ', sperid;
            open curs;
            loop
                fetch curs into pointer;
                exit when not found;

                insert into Product_Catalog values(Fname, Product_ID, price, qty, descp, scompid, pointer.ID, prodwarehid, transpcompid, warehouse);
                get diagnostics check_insert = ROW_COUNT;

                if check_insert = 1 then
                    raise notice 'Order has been alloted to Sales Person with ID: %', pointer.ID ;
                    exit;
                end if;
            end loop;
            
            if check_insert = 0 then
                raise exception 'All Sales Persons have been alloted 3 products!!';
            end if;
            close curs;

        else
            raise notice 'Order has been alloted to Sales Person with ID: %', sperid;
        end if;   
    end;
$$;


Create or replace function Assign_SalesPerson_Trigger()
   returns TRIGGER
   language plpgsql
  as
$$
declare 
    Number_Of_Products int;
begin
    Select into Number_Of_Products  ( Select Count(*)
                                    From Product_Catalog
                                    Where Sales_Person_ID = New.Sales_Person_ID);
    If Number_Of_Products >= 3 then 
        return null;
    End If;
    return new;
end;
$$;


CREATE OR REPLACE TRIGGER Assign_SalesPerson_Check
  BEFORE INSERT
  ON Product_Catalog
  FOR EACH ROW
  EXECUTE PROCEDURE Assign_SalesPerson_Trigger();


create or replace function CatalogUpdate(Product_ID varchar, Quantity_Increase int)
returns void
language plpgsql 
as
$$
    declare
        rowsUpserted integer;
    begin
        Update Product_Catalog 
        Set Available_QTY=Available_QTY + Quantity_Increase
        Where ID=Product_ID;

        get diagnostics rowsUpserted = ROW_COUNT;
        if rowsUpserted = 0 then
            Raise Exception 'Product ID not found';
        end if;
    end;
$$;


/* Trigger to check for redundant entries and handle them accordingly in product catalog*/
create or replace function remove_redundant_product()
returns trigger As
$$
    declare
    cur cursor for select * from Product_Catalog as C;
    pointer record;
    flag integer :=0;

    begin
        open cur;
    loop
        fetch cur into pointer;
        exit when not found;
        if pointer.Name = NEW.Name then
            flag := 1;
            Raise Exception 'Product Named % already exists with ID %! Instead perform an UPDATE.', pointer.Name, pointer.ID;
            exit;
        end if;
    end loop;
    close cur;

    if flag = 1 then
        return null;
    else
        return NEW;
    end if;
    end;
$$ language plpgsql;

create or replace trigger redundantprod
    before insert on Product_Catalog
    for each row
    execute procedure remove_redundant_product();



/* Views along with access privileges */
create materialized view prodCatalog_view
AS
select * from Product_Catalog;

create materialized view custOrders_view
AS
select * from Customer_Orders;

create materialized view deliv_view
AS 
select * from Order_Delivered_By;


create user customer_xyz
with
password 'passwd101';
grant select on prodCatalog_view to customer_xyz;

create user SPerson_xyz
with
password 'pwd102';
grant select on custOrders_view to SPerson_xyz;

create user driver_xyz
with
password 'passwd103';
grant select on deliv_view to driver_xyz;

/*
Create or replace function updateAll()
   returns TRIGGER
   language plpgsql
  as
$$
begin
    select updateProduced();
    select updateStored();
    select updateTransported();
end;
$$;

Create or replace function updateProduced()
   returns void
   language plpgsql
  as
$$
begin
    insert into Product_Produced values(NEW.Product_Warehouse_ID, NEW.ID);
end;
$$;

Create or replace function updateStored()
   returns void
   language plpgsql
  as
$$
begin
    insert into Product_Stored values(NEW.Warehouse_ID, NEW.ID);
end;
$$;

Create or replace function updateTransported()
   returns void
   language plpgsql
  as
$$
begin
    insert into Product_Transported values(NEW.Transportation_Company_ID, NEW.ID);
end;
$$;

create or replace trigger updateAll_trigger
    after insert on Product_Catalog
    for each row
    execute procedure updateAll();
*/