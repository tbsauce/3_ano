use p9g3
go

CREATE TABLE VOO_AIRPORT(
	[Airport_code] [int] NOT NULL,
	[City] [varchar] (16) NOT NULL,
	[State] [varchar] (16) NOT NULL,
	[Name] [varchar] (32) NOT NULL,
	Constraint [ PK_VOO_AIRPORT] PRIMARY KEY CLUSTERED
	(
		[Airport_code]
	)
)
GO

CREATE TABLE VOO_AIRPLANE_TYPE(
	[Type_Name] [varchar] (32) NOT NULL,
	[Max_seats] [int] NOT NULL,
	[Company] [varchar] (32) NOT NULL,
		Constraint [ PK_VOO_AIRPLANETYPE] PRIMARY KEY CLUSTERED
	(
		[Type_Name]
	)
)
GO
 
Create table VOO_AIRPLANE (
	[Airplane_id] [int] NOT NULL,
	[Total_num_Seats] [int] NOT NULL,
	[Type_Name] [varchar] (32) NOT NULL,
	Constraint [ PK_VOO_AIRPLANE] PRIMARY KEY CLUSTERED
	(
		[Airplane_id]
	)
)
go 


ALTER table VOO_AIRPLANE with  check add constraint FK_VOO_AIRPLANE_VOO_AIRPLANE_TYPE
	foreign key ([Type_name]) references VOO_AIRPLANE_TYPE ([Type_Name


Create table VOO_LEG_INSTANCE (
	[Edate] [varchar] (32)NOT NULL,
	[Leg_no] [int] NOT NULL,
	[Number] [varchar] (32) NOT NULL,
	[Avaliable_seats] [int] NOT NULL,
	[Dep_time] [varchar] (32) NOT NULL,
	[Arr_time] [varchar] (32) not null,
	[Airplane_id] [int] not null,
	[Airport_code] [int] not null,
	Constraint [ PK_VOO_Leginstance_Date] PRIMARY KEY 
		( Edate,Leg_no,Number)
)

ALTER table VOO_LEG_INSTANCE with  check add constraint FK_legInstance_Airplane_id
	foreign key (Airplane_id) references VOO_AIRPLANE ([Airplane_id])
go

ALTER table VOO_LEG_INSTANCE with  check add constraint FK_legInstance_Airport_Airportcode
	foreign key (Airport_code) references VOO_AIRPORT ([Airport_code])
go



Create table VOO_SEAT (
	[Seat_num] [int] NOT NULL,
	[Edate] [varchar] (32)NOT NULL,
	[Number] [varchar] (32) NOT NULL,
	[Leg_no] [int] NOT NULL,
	[Customer_name] [varchar] (32) NOT NULL,
	[Customer_phone] [varchar] (32) not null,
	Constraint [ PK_seat_seatnum] PRIMARY KEY 
		( Seat_num),
	Constraint [FK_seat_Leginstance_date] FOREIGN KEY (Edate, Leg_no, Number) 
		REFERENCES VOO_LEG_INSTANCE(Edate, Leg_no, Number)
)

create table  VOO_FLIGHT_LEG(
	[Edate] [varchar] (32)NOT NULL,
	[Leg_no] [int] NOT NULL,
	[Number] [varchar] (32) NOT NULL,
	skedule_dep [varchar] (32) not null,
	skedule_arr [varchar](32) not null,
	Airportcode int not null,
	constraint pk_flightleg_leg_no primary key 
		(Leg_no),
 Constraint [FK_flightleg_Leginstance_date] FOREIGN KEY (Edate, Leg_no, Number) 
		REFERENCES VOO_LEG_INSTANCE(Edate, Leg_no, Number)

)

create table VOO_FLIGHT ( 
	[Edate] [varchar] (32)NOT NULL,
	[Leg_no] [int] NOT NULL,
	[Number] [varchar] (32) NOT NULL,
	Airline varchar( 32) NOT NULL,
	Weekday varchar(32) not null,
	constraint pk_flight_edate primary key
	(number),
	Constraint [FK_flight_Leginstance_date] FOREIGN KEY (Edate, Leg_no, Number) 
		REFERENCES VOO_LEG_INSTANCE(Edate, Leg_no, Number)
)

create table VOO_fare(
	Code int not null,
	Number varchar  (32) NOT NULL,
	restrictions varchar (32) not null,
	ammount int not null,
	constraint pk_fare_code primary key 
	(code ) ,
	constraint fk_fare_number foreign key (number)
		references VOO_FLIGHT (number)
)