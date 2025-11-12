-- show databases;
-- create database techcorp;
-- use techcorp;

-- show tables;

create table Products (
	product_id INT auto_increment primary key,
    product_name varchar(100) not null,
    category varchar(50),
    price decimal(10,2),
    stock_quantity int
    );

create table Customers (
	customer_id int auto_increment primary key,
    first_name varchar(50) not null,
    last_name varchar(50) not null,
    email varchar(50) unique,
    phone varchar(20),
    address varchar(200)
);

create table Orders (
	order_id int auto_increment primary key,
    customer_id int,
    order_date date,
    total_amount decimal(10,2),
    foreign key (customer_id) references Customers(customer_id)
);

create table OrderDetails (
	order_detail_id int auto_increment primary key,
    order_id int,
    product_id int,
    quantity int,
    unit_price decimal(10,2),
    foreign key (order_id) references Orders(order_id),
    foreign key (product_id) references Products(product_id)
);

create table Employees (
	employee_id INT auto_increment primary key,
    first_name varchar(50),
    last_name varchar(50),
    email varchar(100),
    phone varchar(20),
    hire_date date,
    department varchar(50)
);

create table SupportTickets (
	ticket_id int auto_increment primary key,
    customer_id int,
    employee_id int,
    issue text,
    status varchar(20),
    created_at datetime,
    resolved_at datetime,
    foreign key (customer_id) references Customers(customer_id),
    foreign key (employee_id) references Employees(employee_id)
);

alter table Products add column discount decimal(5,2) default 0;