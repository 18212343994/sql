/*�����û���Ϣ��ṹ*/
create table user1
(    userno int primary key,
     username varchar(50) not null,
     usersex varchar(50) not null,
     userbirth date not null,
     check (usersex in('��','Ů'))
);

/*������ƱԱ��Ϣ��ṹ*/
create table seller
(   sellerno int primary key,
     sellername varchar(50) not null,
     sellersex varchar(50) not null,
     sellerwage int not null,
     check(sellersex in('��','Ů'))
);

/*�����г���Ϣ��ṹ*/
create table car
(     carno varchar(50) primary key,
       cartype varchar(50) not null,
       seatnum int not null
);

/*�����û�������ϵ��ṹ*/
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

/*��������Ա��Ϣ��ṹ*/
create table admin
(    
	AdminNo int primary key,
	AdminName varchar(50) not null,
	AdminSex varchar(50) not null
);

/*����������Ϣ��ṹ*/
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

/*����������Ϣ���ļ�¼��ṹ*/
create table trainupdate
(
	trainno varchar(50) primary key,
	updatetype varchar(50) not null,
	updatecontent varchar(50) not null
);

/*���û���Ϣ�в�������*/
insert into user1 values(001,'����','��','1998-01-10');
insert into user1 values(002,'�ư���','Ů','1998-02-25');
insert into user1 values(003,'ޱ��','Ů','1998-03-17');
insert into user1 values(004,'¬����','��','1998-04-25');
insert into user1 values(005,'��ŷ��','Ů','1998-05-04');
insert into user1 values(006,'����','Ů','1998-06-10');
insert into user1 values(007,'������˹','��','1998-07-10');
insert into user1 values(008,'��������','Ů','1998-08-10');
insert into user1 values(009,'������','��','1998-09-10');
insert into user1 values(010,'˹ά��','��','1998-10-10');

/*���г���Ϣ���в�������*/
insert into car values('113','��г��',100);
insert into car values('114','���˺�',120);
insert into car values('115','̩̹��˺�',100);

/*����ƱԱ��Ϣ���в�������*/
insert into seller values('1001','������','��',5000);
insert into seller values('1002','���ȿ�','��',4000);
insert into seller values('1003','�׿���','Ů',5000);
insert into seller values('1004','�Ƽ�˹','��',6000);

/*�ڳ�����Ϣ���в�������*/
insert into  train values('G46','������',963.5,'������','2018-08-01 09:34:00','114',20);
insert into  train values('G6','������',963.5,'������','2019-08-01  18:01:00','114',54);
insert into  train values('G55','������',963.5,'������','2019-08-01  20:55:00','115',78);
insert into  train values('G1322','������',734.5,'�Ϻ�����','2019-8-01 9:07:00','113',0);
insert into  train values('Z162','������',456.5,'�人','2018-08-01 04:09:00','114',0);

insert into  train values('G06','������',963.5,'������','2018-08-02 09:34:00','114',5);
insert into  train values('G8','������',963.5,'������','2019-08-02  18:01:00','114',10);
insert into  train values('G755','������',963.5,'������','2019-08-02  20:55:00','115',99);
insert into  train values('G1334','������',734.5,'�Ϻ�����','2019-8-02 11:22:00','115',30);
insert into  train values('G82','������',1519.0,'�人','2018-08-02 08:37:00','113',20);

insert into  train values('G406','������',963.5,'������','2018-08-03 09:34:00','114',17);
insert into  train values('G86','������',963.5,'������','2019-08-03  18:01:00','114',38);
insert into  train values('G555','������',963.5,'������','2019-08-03  20:55:00','115',40);
insert into  train values('G1338','������',734.5,'�Ϻ�����','2019-8-03 14:01:00','114',20);
insert into  train values('G1540','������',796.0,'�人','2018-08-03 12:29:00','115',11);

/*�ڹ���Ա��Ϣ���в�������*/
insert into admin values(10001,'ǧ��','��');
insert into admin values(10002,'������˹','��');

/*������ͼ*/
create view beijing
as
select *
from  train
where Bd='������';

create view shanghai
as
select *
from  train
where Bd='�Ϻ�����';

create view wuhan
as
select *
from  train
where Bd='�人';

create view orderupdate
as
select Dno,updatetype,updatetime
from order1;

/*������������ճ�����Ϣ���ʱ������������������*/
 create index traintime on train(stardata)


/*���崥����*/
/*1.�û�������Ӧ���εĳ�Ʊʱ�����Ʊ�Ƿ�Ϊ0,Ϊ0���޷���Ʊ;����0����Ӧ���γ�Ʊ�������ٲ���ͬ�����û�����*/
create trigger t_1
on order1
for insert
as
begin
  declare @cc varchar(50)
  select @cc=trainno from inserted
  if((select yp from train where trainno= @cc )<1)
  begin
  print '��ƱΪ��,����ʧ�� '
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

   
/*2.��ƱԱ���û���Ʊ������*/
create trigger tp
on order1
after delete
as
begin
	declare @tno varchar(50)
	declare @dno int
	select @tno=trainno,@dno=Dno from deleted;
	update train set yp=yp+1 where trainno=@tno;
	insert into orderupdate values(@dno,'��Ʊ',getdate());
	print'��Ʊ�ɹ�'
	end;
	
/*
select * from train;
select * from order1;
select * from orderupdate;

insert into order1 values(4,004,'G06','2019-08-02 09:34:00',1004,null,null);
delete from order1 where trainno='G06';

drop trigger tp;
*/

/*3.��ƱԱ���û������ѹ��򶩵���Ϣ��ͬʱͬ�����������ļ�¼��*/
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
update orderupdate set updatetype='��ǩ',updatetime=getdate() where dno=@dno
end

/*
select * from train;
select * from order1;
select * from orderupdate;

insert into order1 values(4,004,'G06','2019-08-02 09:34:00',1004,null,null);
update order1 set trainno='G1334' where userno=4;

drop trigger gq;
*/

/*����Ա�޸ķ���ʱ��*/
create trigger gg 
on train
after update
as
if(update(stardata))
begin
declare @q varchar(50),@h varchar(50)
select @h=stardata from inserted
select @q=trainno from train where stardata=@h
insert into trainupdate values(@q,'����ʱ���Ϊ:',@h);
end

/*
select * from train;
select * from trainupdate;

update train set stardata='2018-08-03 08:34:00' where trainno='G06';

drop trigger gg;
*/

/*���û���Ȩ*/
grant select,insert,update,delete on order1 TO ����; grant select on train to ����;
grant select,insert,update,delete on order1 TO �ư���; grant select on train to �ư���;
grant select,insert,update,delete on order1 TO ޱ��; grant select on train to ޱ��;
grant select,insert,update,delete on order1 TO ¬����; grant select on train to ¬����;
grant select,insert,update,delete on order1 TO ��ŷ��; grant select on train to ��ŷ��;
grant select,insert,update,delete on order1 TO ����; grant select on train to ����;
grant select,insert,update,delete on order1 TO ������˹; grant select on train to ������˹;
grant select,insert,update,delete on order1 TO ��������; grant select on train to ��������;
grant select,insert,update,delete on order1 TO ������; grant select on train to ������;
grant select,insert,update,delete on order1 TO ˹ά��; grant select on train to ˹ά��;

/*����ƱԱ��Ȩ*/
grant select,insert,update,delete on order1 TO ������;
grant select,insert,update,delete on user1 TO ������;
grant select on train to ������;
grant select,insert,update,delete on order1 TO ���ȿ�;
grant select,insert,update,delete on user1 TO ���ȿ�;
grant select on train to ���ȿ�;
grant select,insert,update,delete on order1 TO �׿���;
grant select,insert,update,delete on user1 TO �׿���;
grant select on train to �׿���;
grant select,insert,update,delete on order1 TO �Ƽ�˹;
grant select,insert,update,delete on user1 TO �Ƽ�˹;
grant select on train to �Ƽ�˹;

/*������Ա��Ȩ*/
grant select,insert,update,delete on user1 TO ǧ��;
grant select,insert,update,delete on seller TO ǧ��;
grant select,insert,update,delete on car TO ǧ��;
grant select,insert,update,delete on order1 TO ǧ��;
grant select,insert,update,delete on train TO ǧ��;
grant select,insert,update,delete on trainupdate TO ǧ��;
grant select,insert,update,delete on orderupdate TO ǧ��;

grant select,insert,update,delete on user1 TO ������˹;
grant select,insert,update,delete on seller TO ������˹;
grant select,insert,update,delete on car TO ������˹;
grant select,insert,update,delete on order1 TO ������˹;
grant select,insert,update,delete on train TO ������˹;
grant select,insert,update,delete on trainupdate TO ������˹;
grant select,insert,update,delete on orderupdate TO ������˹;