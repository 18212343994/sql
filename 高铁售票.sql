/*创建用户信息表结构*/
create table user1
(    userno int primary key,
     username varchar(50) not null,
     usersex varchar(50) not null,
     userbirth date not null,
     check (usersex in('男','女'))
);

/*创建售票员信息表结构*/
create table seller
(   sellerno int primary key,
     sellername varchar(50) not null,
     sellersex varchar(50) not null,
     sellerwage int not null,
     check(sellersex in('男','女'))
);

/*创建列车信息表结构*/
create table car
(     carno varchar(50) primary key,
       cartype varchar(50) not null,
       seatnum int not null
);

/*创建用户订单关系表结构*/
create table order1
(    dno int primary key,
      userno int,
      trainno varchar(50),
      ddate datetime not null,
      sellerno int,
       updatetype varchar(50),
       updatetime date,
      foreign key (userno) references user1(userno),
      foreign key (trainno) references train(trainno),
      foreign key (sellerno) references seller(sellerno)
);

/*创建管理员信息表结构*/
create table admin
(    
	AdminNo int primary key,
	AdminName varchar(50) not null,
	AdminSex varchar(50) not null
);

/*创建车次信息表结构*/
create table train
(
	trainno varchar(50) primary key,
	Ad varchar(50) not null,
	price int not null,
	Bd varchar(50) not null,
	stardata datetime not null,
	carno varchar(50) not null,
        yp int not null,
	foreign key(carno) references car(carno)
);

/*创建车次信息更改记录表结构*/
create table trainupdate
(
	trainno varchar(50) primary key,
	updatetype varchar(50) not null,
	updatecontent varchar(50) not null
);

/*在用户信息中插入数据*/
insert into user1 values(001,'盖伦','男','1998-01-10');
insert into user1 values(002,'菲奥娜','女','1998-02-25');
insert into user1 values(003,'薇恩','女','1998-03-17');
insert into user1 values(004,'卢锡安','男','1998-04-25');
insert into user1 values(005,'蕾欧娜','女','1998-05-04');
insert into user1 values(006,'凯尔','女','1998-06-10');
insert into user1 values(007,'德莱厄斯','男','1998-07-10');
insert into user1 values(008,'卡特琳娜','女','1998-08-10');
insert into user1 values(009,'德莱文','男','1998-09-10');
insert into user1 values(010,'斯维因','男','1998-10-10');

/*在列车信息表中插入数据*/
insert into car values('113','和谐号',100);
insert into car values('114','复兴号',120);
insert into car values('115','泰坦尼克号',100);

/*在售票员信息表中插入数据*/
insert into seller values('1001','卡萨丁','男',5000);
insert into seller values('1002','卡兹克','男',4000);
insert into seller values('1003','雷克赛','女',5000);
insert into seller values('1004','科加斯','男',6000);

/*在车次信息表中插入数据*/
insert into  train values('G46','贵阳北',963.5,'北京西','2018-08-01 09:34:00','114',20);
insert into  train values('G6','贵阳北',963.5,'北京西','2019-08-01  18:01:00','114',54);
insert into  train values('G55','贵阳北',963.5,'北京西','2019-08-01  20:55:00','115',78);
insert into  train values('G1322','贵阳北',734.5,'上海虹桥','2019-8-01 9:07:00','113',0);
insert into  train values('Z162','贵阳北',456.5,'武汉','2018-08-01 04:09:00','114',0);

insert into  train values('G06','贵阳北',963.5,'北京西','2018-08-02 09:34:00','114',5);
insert into  train values('G8','贵阳北',963.5,'北京西','2019-08-02  18:01:00','114',10);
insert into  train values('G755','贵阳北',963.5,'北京西','2019-08-02  20:55:00','115',99);
insert into  train values('G1334','贵阳北',734.5,'上海虹桥','2019-8-02 11:22:00','115',30);
insert into  train values('G82','贵阳北',1519.0,'武汉','2018-08-02 08:37:00','113',20);

insert into  train values('G406','贵阳北',963.5,'北京西','2018-08-03 09:34:00','114',17);
insert into  train values('G86','贵阳北',963.5,'北京西','2019-08-03  18:01:00','114',38);
insert into  train values('G555','贵阳北',963.5,'北京西','2019-08-03  20:55:00','115',40);
insert into  train values('G1338','贵阳北',734.5,'上海虹桥','2019-8-03 14:01:00','114',20);
insert into  train values('G1540','贵阳北',796.0,'武汉','2018-08-03 12:29:00','115',11);

/*在管理员信息表中插入数据*/
insert into admin values(10001,'千珏','男');
insert into admin values(10002,'卡尔萨斯','男');

/*创建视图*/
create view beijing
as
select *
from  train
where Bd='北京西';

create view shanghai
as
select *
from  train
where Bd='上海虹桥';

create view wuhan
as
select *
from  train
where Bd='武汉';

create view orderupdate
as
select Dno,updatetype,updatetime
from order1;

/*设计索引：按照车次信息表的时间升序来创建索引。*/
 create index traintime on train(stardata)


/*定义触发器*/
/*1.用户购买相应车次的车票时检查余票是否为0,为0则无法购票;大于0则相应车次车票数量减少并且同步到用户订单*/
create trigger t_1
on order1
for insert
as
begin
  declare @cc varchar(50)
  select @cc=trainno from inserted
  if((select yp from train where trainno= @cc )<1)
  begin
  print '余票为零,购买失败 '
  rollback transaction
  end
  else
	update train set yp=yp-1 where trainno=@cc
   end

/*
select * from train;
select * from order1;

insert into order1 values(4,004,'G06','2019-08-01 09:07:00',1004,null,null)
insert into order1 values(4,004,'G06','2019-08-02 09:34:00',1004,null,null)

drop trigger t_1;
*/

   
/*2.售票员或用户退票触发器*/
create trigger tp
on order1
after delete
as
begin
	declare @tno varchar(50)
	declare @dno int
	select @tno=trainno,@dno=Dno from deleted;
	update train set yp=yp+1 where trainno=@tno;
	insert into orderupdate values(@dno,'退票',getdate());
	print'退票成功'
	end;
	
/*
select * from train;
select * from order1;
select * from orderupdate;

insert into order1 values(4,004,'G06','2019-08-02 09:34:00',1004,null,null);
delete from order1 where trainno='G06';

drop trigger tp;
*/

/*3.售票员或用户更改已购买订单信息的同时同步到订单更改记录表*/
create trigger gq 
on order1
after update
as
if(update(trainno))
begin
declare @q varchar(50),@h varchar(50),@dno int
select @h=trainno from inserted
select @q=trainno from deleted
update train set yp=yp+1 where trainno=@q
update train set yp=yp-1 where trainno=@h
select @dno=dno from order1 where trainno=@h
update orderupdate set updatetype='改签',updatetime=getdate() where dno=@dno
end

/*
select * from train;
select * from order1;
select * from orderupdate;

insert into order1 values(4,004,'G06','2019-08-02 09:34:00',1004,null,null);
update order1 set trainno='G1334' where userno=4;

drop trigger gq;
*/

/*管理员修改发车时间*/
create trigger gg 
on train
after update
as
if(update(stardata))
begin
declare @q varchar(50),@h varchar(50)
select @h=stardata from inserted
select @q=trainno from train where stardata=@h
insert into trainupdate values(@q,'发车时间改为:',@h);
end

/*
select * from train;
select * from trainupdate;

update train set stardata='2018-08-03 08:34:00' where trainno='G06';

drop trigger gg;
*/

/*给用户授权*/
grant select,insert,update,delete on order1 TO 盖伦; grant select on train to 盖伦;
grant select,insert,update,delete on order1 TO 菲奥娜; grant select on train to 菲奥娜;
grant select,insert,update,delete on order1 TO 薇恩; grant select on train to 薇恩;
grant select,insert,update,delete on order1 TO 卢锡安; grant select on train to 卢锡安;
grant select,insert,update,delete on order1 TO 蕾欧娜; grant select on train to 蕾欧娜;
grant select,insert,update,delete on order1 TO 凯尔; grant select on train to 凯尔;
grant select,insert,update,delete on order1 TO 德莱厄斯; grant select on train to 德莱厄斯;
grant select,insert,update,delete on order1 TO 卡特琳娜; grant select on train to 卡特琳娜;
grant select,insert,update,delete on order1 TO 德莱文; grant select on train to 德莱文;
grant select,insert,update,delete on order1 TO 斯维因; grant select on train to 斯维因;

/*给售票员授权*/
grant select,insert,update,delete on order1 TO 卡萨丁;
grant select,insert,update,delete on user1 TO 卡萨丁;
grant select on train to 卡萨丁;
grant select,insert,update,delete on order1 TO 卡兹克;
grant select,insert,update,delete on user1 TO 卡兹克;
grant select on train to 卡兹克;
grant select,insert,update,delete on order1 TO 雷克赛;
grant select,insert,update,delete on user1 TO 雷克赛;
grant select on train to 雷克赛;
grant select,insert,update,delete on order1 TO 科加斯;
grant select,insert,update,delete on user1 TO 科加斯;
grant select on train to 科加斯;

/*给管理员授权*/
grant select,insert,update,delete on user1 TO 千珏;
grant select,insert,update,delete on seller TO 千珏;
grant select,insert,update,delete on car TO 千珏;
grant select,insert,update,delete on order1 TO 千珏;
grant select,insert,update,delete on train TO 千珏;
grant select,insert,update,delete on trainupdate TO 千珏;
grant select,insert,update,delete on orderupdate TO 千珏;

grant select,insert,update,delete on user1 TO 卡尔萨斯;
grant select,insert,update,delete on seller TO 卡尔萨斯;
grant select,insert,update,delete on car TO 卡尔萨斯;
grant select,insert,update,delete on order1 TO 卡尔萨斯;
grant select,insert,update,delete on train TO 卡尔萨斯;
grant select,insert,update,delete on trainupdate TO 卡尔萨斯;
grant select,insert,update,delete on orderupdate TO 卡尔萨斯;