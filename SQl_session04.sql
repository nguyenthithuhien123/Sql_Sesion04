create database project_Md3;
use project_Md3;
create table PRODUCT(
product_Id Char(5) Primary key,
product_Name Varchar(150) Not null Unique,
manufacturer Varchar(200) Not null,
created Date Default(CURRENT_DATE),
batch Smallint Not null,
quantity Int Not null default 0,
product_Status Bit Default 1
);
insert into PRODUCT(product_Id,product_Name,manufacturer,batch,quantity) values
('A001','vải thô','Thịnh thế',101,100),
('B001','vải lụa','Thịnh thế',102,150),
('C001','kim may','Hoàng hà',103,120),
('D001','chỉ may','Hoàng hà',104,90);
create table EMPLOYEE(
emp_Id Char(5) Primary key,
emp_Name Varchar(100) Not null Unique,
birth_Of_Date Date,
email Varchar(100) Not null,
phone Varchar(100)  Not null,
address Text Not null,
emp_Status Smallint Not null
);
insert into EMPLOYEE values
('H001','Hạnh','2003-10-10','hanh@gmail.com','0976860171','hà nội',0),
('H002','Hoa','2004-10-10','hoa@gmail.com','0976860172','hải phòng',1),
('H003','Phúc','2005-10-10','phuc@gmail.com','0976860173','phú thọ',2),
('H004','Ngọc','2006-10-10','ngoc@gmail.com','0976860174','bắc ninh',1),
('H005','Minh','2007-10-10','minh@gmail.com','0976860175','hà tây',1);
create table ACCOUNTS(
acc_id Int primary key auto_increment,
user_name varchar(30),
passwords varchar(30),
permission bit default 1,
emp_id char(5) not null unique,
foreign key (emp_id) references EMPLOYEE(emp_Id),
acc_status bit default 1
);
insert into ACCOUNTS(user_name,passwords,emp_id) values
('hanh@gmail.com','0976860171','H001'),
('hoa@gmail.com','0976860172','H002'),
('phuc@gmail.com','0976860173','H003'),
('minh@gmail.com','0976860174','H005');
create table BILL(
bill_Id int primary key auto_increment,
bill_Code varchar(10) not null,
bill_Type bit not null,
emp_Id_Created char(5) not null,
foreign key(emp_Id_Created) references  EMPLOYEE(emp_Id),
created date default(current_date()),
emp_Id_Auth char(5) not null,
foreign key(emp_Id_Auth) references  EMPLOYEE(emp_Id),
auth_Date date default(current_date()),
bill_Status smallint not null default 0
);
insert into BILL(bill_Code,bill_Type,emp_Id_Created,emp_Id_Auth,bill_Status) values
('B001',1,'H001','H004',0),
('B002',0,'H003','H005',0),
('B003',1,'H001','H004',0),
('B004',0,'H003','H005',0);
create table BILL_DETAIL(
bill_Detail_Id int Primary key auto_increment,
bill_Id int not null,
foreign key(bill_Id) references BILL(bill_Id),
product_Id char(5) not null,
foreign key(product_Id) references PRODUCT(product_Id),
quantity int not null check(quantity>0),
price float not null check(price>0)
);
insert into BILL_DETAIL(bill_Id,product_Id,quantity,price) values
(1,'A001',100,1200),
(2,'B001',150,1000),
(1,'C001',120,1500),
(3,'B001',90,1300);
-- 1. Danh sách sản phẩm
select * from product limit 10;
-- 2. Thêm mới sản phẩm
insert into PRODUCT(product_Id,product_Name,manufacturer,batch,quantity) value
('F001','vải da cá','Thịnh thế',105,100);
-- 3. Cập nhật sản phẩm
update PRODUCT set product_Name ='vải lanh' where product_Id='F001';
-- 4. Tìm kiếm sản phẩm
select * from PRODUCT where product_Name like 'v%' limit 3;
-- 5. Cập nhật trạng thái sản phẩm
update PRODUCT set product_Status =0 where product_Id='F001';
select * from BILL;
UPDATE `project_md3`.`BILL` SET `bill_Status` = '2' WHERE (`bill_Id` = '2');
UPDATE `project_md3`.`BILL` SET `bill_Status` = '1' WHERE (`bill_Id` = '4');
-- 5. Duyệt phiếu nhập
UPDATE BILL set bill_Status= 2 where bill_Status=0;
-- 5. Thống kê số nhân viên theo từng trạng thái
-- -- 6. Thống kê sản phẩm nhập nhiều nhất trong khoảng thời gian
select p.product_Name, bb.auth_Date, max(b.quantity) from PRODUCT p join BILL_DETAIL b
on p.product_Id = b.product_Id
join BILL bb
on b.bill_Id = bb.bill_Id
where bb.auth_Date between '2024-1-1' and '2024-12-1'
group by bb.auth_Date,p.product_Name;
-- 1. Thống kê chi phí theo ngày, tháng, năm
select p.product_Name, sum(b.quantity*b.price) from PRODUCT p join BILL_DETAIL b
on p.product_Id = b.product_Id
join BILL bb
on b.bill_Id = bb.bill_Id
where bb.auth_Date between '2024-1-1' and '2024-12-1'and bb.bill_Type=1
group by p.product_Name;