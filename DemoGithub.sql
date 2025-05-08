Use flightdb;
select * from flight;

/* where clause */

select * from flight where source = (select source from flight where flightname = 'Indigo');

select flightname, (select length(destination)) as LengthDestination from flight;

select * from flight where destination in(select destination from flight where source = 'Hyderabad');

select * from flight where source in ('hyderabad','delhi');

create table flightdetails(
id int primary key,
flightid int not null,
price decimal(10,2),
noofseats int,
foreign key(flightid) references flight(flightid)
);
select * from flightdetails;

insert into flightdetails values(4,11,4800,67);

select * from flight f left join flightdetails fd on f.flightid = fd.flightid;


/* name of flight whole price is maximum */
select f.flightname from flight f join flightdetails fd on f.flightid = fd.flightid
order by fd.price desc limit 1;

select f.flightname from flight f where flightid = (
select flightid from flightdetails order by price desc limit 1);

select * from flight f join flightdetails fd on f.flightid = fd.flightid
where fd.price = (select max(price) from flightdetails);


use flightdb;
select * from flight;
create table booking(
bookingid int Primary key auto_increment,
flightid int,
passengername varchar(100),
bookingdate date,
foreign key(flightid) references flight(flightid));

insert into booking(flightid,passengername,bookingdate) values(1,'Aysha','2025-03-19'),(1,'Asha','2025-03-17'),(2,'Quincy','2025-03-15'),
(2,'iwona','2025-02-17'),(3,'candace','2025-03-16'),(2,'pavi','2025-02-15'),
(4,'Sing','2025-01-15');

select * from booking;

select * from flight where flightid in (
select flightid from booking group by flightid having count(*) >= 2);

select * from flight f left join booking b on f.flightid = b.flightid
where bookingid is null;

select * from flight where source = 'Hyderabad' and startdate=(
select min(startdate) from flight where source = 'Hyderabad');

select f.flightid,f.flightname from flight f join booking b on f.flightid = b.flightid
group by f.flightid, f.flightname
having count(*) >(
select avg(countflights) from 
(select count(*) as countflights from booking group by flightid) as avgbooking);

Use flightdb;
select * from flight where source = 'Hyderabad' and flightid in (
select flightid from flight where destination = 'Chennai');

with chennaiflights as(
select * from flight where destination = 'Chennai'
)
select * from chennaiflights where source = 'Hyderabad';

create database StudentInfo;
Use StudentInfo;
create table course(
courseid int primary key,
coursename varchar(50),
coursefee int
);
create table student(
studentid int primary key,
studentname varchar(50),
courseid int,
marks int,
grade char(1),
foreign key(courseid) references course(courseid)
);



insert into course values(1,'ECE',56000),(2,'IT',67000),(3,'CSE',89000),(4,'Civil',45000),
(5,'Mech',43000),(6,'AIML',98000);

insert into student values(1,'Quincy',1,78,'C'),(2,'Iwona',1,75,'D'),(3,'Jamie',3,88,'B'),(4,'Jack',3,88,'B'),
(5,'Hung',6,96,'A');

create table college(
collegeid int primary key,
collegename varchar(50),
studentid int,
courseid int,
foreign key(studentid) references student(studentid),
foreign key(courseid) references course(courseid)
);

insert into college values(1,'CMR',1,1),(2,'RVR',2,1),(3,'RVR',3,3);

select * from course;
select * from student;
select * from college;

select * from college c right join student s on c.studentid = s.studentid
right join course cs on cs.courseid = c.courseid;

--- all students who enrolled in CSE
select * from student where courseid=(
select courseid from course where coursename = 'CSE');

with CSEStudents as(
select * from course where coursename = 'CSE'
)
select * from student s join CSEStudents c on s.courseid = c.courseid;



-- list of students who are not enrolled in any college under course CSE

select * from student s left join college c on s.studentid = c.studentid
join course cs on cs.courseid = s.courseid
where collegeid is null and cs.coursename = 'CSE';

with cte as(
   select s.studentid,s.studentname,s.courseid as courseid from student s left join college c on s.studentid = c.studentid
   where collegeid is null
)
select * from cte c join course cs on c.courseid = cs.courseid
where cs.coursename = 'CSE';

-- the student details whose marks is greater then average marks in their course

with CTE as(
select courseid,avg(marks) as avgmarks from student s 
group by courseid
)
select * from student s join CTE c on s.courseid = c.courseid
where s.marks >= c.avgmarks;
































































