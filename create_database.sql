--Create database DBFiverr
USE [master]
GO
--Check if database exists
IF DB_ID('DBFiverr') IS NOT NULL
	DROP DATABASE [DBFiverr]
GO
--Create the database
CREATE DATABASE [DBFiverr]
GO
use DBFiverr

--creating person table
CREATE TABLE Person(
	email_id varchar(100),
	password binary(64) NOT NULL,
	firstname varchar(100) NOT NULL,
	lastname varchar(100) NOT NULL,
	credit money DEFAULT 0,
	CONSTRAINT ck_checkmoneypositive CHECK (credit >= 0),
	CONSTRAINT pk_email PRIMARY KEY (email_id)
	);
GO

--creating table category
CREATE TABLE Category(
	category_id int,
	category_name varchar(100) NOT NULL,
	CONSTRAINT pk_categoryid PRIMARY KEY (category_id)
	);
GO

--creating mapping table between person and category
CREATE TABLE Person_Category(
	email_id varchar(100), 
	category_id int,
	CONSTRAINT pk_email_category PRIMARY KEY (email_id, category_id),
	CONSTRAINT fk_email FOREIGN KEY (email_id) REFERENCES Person(email_id),
	CONSTRAINT fk_categorgy FOREIGN KEY (category_id) REFERENCES Category(category_id)
	);
GO

--creating table new request
CREATE TABLE New_Request(
	request_id uniqueidentifier 
		DEFAULT newid(),
	email_id varchar(100) NOT NULL,
	category_id int NOT NULL, 
	description varchar(max),
	deadline datetime, 
	CONSTRAINT pk_requestid PRIMARY KEY (request_id),
	CONSTRAINT fk_email_request FOREIGN KEY (email_id) REFERENCES Person(email_id),
	CONSTRAINT fk_categorgy_request FOREIGN KEY (category_id) REFERENCES Category(category_id)
	);
GO

--creating table pending request
CREATE TABLE Pending_Request(
	pending_request_id uniqueidentifier default NEWID(),
	requester_id varchar(100) NOT NULL,
	provider_id varchar(100) NOT NULL,
	category_id int NOT NULL, 
	description varchar(max),
	deadline datetime, 
	CONSTRAINT pk_pending_requestid PRIMARY KEY (pending_request_id),
	CONSTRAINT fk_email_requester FOREIGN KEY (requester_id) REFERENCES Person(email_id),
	CONSTRAINT fk_email_provider FOREIGN KEY (provider_id) REFERENCES Person(email_id),
	CONSTRAINT fk_categorgy_byrequester FOREIGN KEY (category_id) REFERENCES Category(category_id)
	);
GO

--creating table completed request
CREATE TABLE Completed_Request(
	completed_request_id uniqueidentifier default NEWID(),
	requester_id varchar(100) NOT NULL,
	provider_id varchar(100) NOT NULL,
	category_id int NOT NULL, 
	description varchar(max),
	accepted bit NOT NULL, 
	CONSTRAINT pk_completed_requestid PRIMARY KEY (completed_request_id),
	CONSTRAINT fk_email_requester_complete FOREIGN KEY (requester_id) REFERENCES Person(email_id),
	CONSTRAINT fk_email_provider_complete FOREIGN KEY (provider_id) REFERENCES Person(email_id),
	CONSTRAINT fk_categorgy_byrequester_complete FOREIGN KEY (category_id) REFERENCES Category(category_id)
	);
GO


--creating table service
CREATE TABLE Service(
	service_id uniqueidentifier 
		DEFAULT newid(),
	email_id varchar(100) NOT NULL,
	category_id int NOT NULL, 
	description varchar(max), 
	CONSTRAINT pk_serviceid PRIMARY KEY (service_id),
	CONSTRAINT fk_service_provider_email FOREIGN KEY (email_id) REFERENCES Person(email_id),
	CONSTRAINT fk_service_category FOREIGN KEY (category_id) REFERENCES Category(category_id)
	);
GO

--creating table message
CREATE TABLE Message(
	message_id uniqueidentifier 
		DEFAULT newid(),
	author_id varchar(100) NOT NULL,
	thread_id uniqueidentifier 
		DEFAULT newid(),
	msg_subject varchar(100),
	body varchar(max),
	msg_date datetime, 
	CONSTRAINT pk_messageid PRIMARY KEY (message_id),
	CONSTRAINT fk_author_email FOREIGN KEY (author_id) REFERENCES Person(email_id)
	);
GO

--creating table placeholder
CREATE TABLE Placeholder(
	placeholder_id int IDENTITY,
	placeholder_name varchar(50),
	CONSTRAINT pk_placeholderid PRIMARY KEY (placeholder_id)
	);
Go


--creating mapping table person_message
--thread_id in user message and message are not linked because we want to delete the mappings to remove the messasge from a user's folder but not the message from the message table so that it exists in other users folders if the conversation  exists

CREATE TABLE Person_Message(
	email_id varchar(100),
	message_id uniqueidentifier 
		DEFAULT newid(),
	placeholder_id int NOT NULL,
	thread_id uniqueidentifier 
		DEFAULT newid(),
	is_read bit DEFAULT 0, 
	CONSTRAINT pk_person_message PRIMARY KEY (email_id,message_id),
	CONSTRAINT fk_email_person FOREIGN KEY (email_id) REFERENCES Person(email_id),
	CONSTRAINT fk_placeholder FOREIGN KEY (placeholder_id) REFERENCES Placeholder(placeholder_id)
	);
GO

--Insert records into Person table
INSERT [dbo].Person (email_id, password, firstname, lastname) VALUES ('john.doe@gmail.com', HASHBYTES('SHA2_512', 'vfdwes'), N'John',N'Doe');
INSERT [dbo].Person (email_id, password, firstname, lastname) VALUES ('michelle.davison@gmail.com', HASHBYTES('SHA2_512', 'adsvc'), N'Michelle',N'Davison');
INSERT [dbo].Person (email_id, password, firstname, lastname) VALUES ('mayteh.kendall@yahoo.com', HASHBYTES('SHA2_512', 'ghjgss'), N'Kendall',N'Mayteh');
INSERT [dbo].Person (email_id, password, firstname, lastname) VALUES ('bruce.onandonga12@gmail.com', HASHBYTES('SHA2_512', 'vhbdsserfsa'), N'Onandonga',N'Bruce');
INSERT [dbo].Person (email_id, password, firstname, lastname) VALUES ('tony.antavius@asu.edu', HASHBYTES('SHA2_512', 'vcngfhgfscx'), N'Antavius',N'Anthony');
INSERT [dbo].Person (email_id, password, firstname, lastname) VALUES ('danny.bradley34@gmail.com', HASHBYTES('SHA2_512', 'jtkjhkhfg'), N'Bradlee',N'Danny');
INSERT [dbo].Person (email_id, password, firstname, lastname) VALUES ('reynaldo.suscipe@gmail.com', HASHBYTES('SHA2_512', 'asgfdvger'), N'Suscipe',N'Reynaldo');
INSERT [dbo].Person (email_id, password, firstname, lastname) VALUES ('ger.sullivan@asu.edu', HASHBYTES('SHA2_512', 'sgfdhgft'), N'Sullivan',N'Geraldine');
INSERT [dbo].Person (email_id, password, firstname, lastname) VALUES ('nicole.reh123@gmail.com', HASHBYTES('SHA2_512', 'ssfsfawqq'), N'Nicole',N'Rehdahl');
INSERT [dbo].Person (email_id, password, firstname, lastname) VALUES ('katy.smith@yahoo.com', HASHBYTES('SHA2_512', 'bgfbrtsf'), N'Katy',N'Smith');

--Insert sample categories for services
INSERT [dbo].Category (category_id, category_name) VALUES (1, 'Graphics & Design');
INSERT [dbo].Category (category_id, category_name) VALUES (2, 'Digital Marketing');
INSERT [dbo].Category (category_id, category_name) VALUES (3, 'Video & Animation');
INSERT [dbo].Category (category_id, category_name) VALUES (4, 'Audio & Music');
INSERT [dbo].Category (category_id, category_name) VALUES (5, 'Programming & Technology');
INSERT [dbo].Category (category_id, category_name) VALUES (6, 'Advertising');

--insert each persons category preferences
INSERT [dbo].Person_Category (email_id, category_id) VALUES ('john.doe@gmail.com', 1);
INSERT [dbo].Person_Category (email_id, category_id) VALUES ('john.doe@gmail.com', 3);
INSERT [dbo].Person_Category (email_id, category_id) VALUES ('john.doe@gmail.com', 4);
INSERT [dbo].Person_Category (email_id, category_id) VALUES ('michelle.davison@gmail.com', 4);
INSERT [dbo].Person_Category (email_id, category_id) VALUES ('michelle.davison@gmail.com', 2);
INSERT [dbo].Person_Category (email_id, category_id) VALUES ('michelle.davison@gmail.com', 5);
INSERT [dbo].Person_Category (email_id, category_id) VALUES ('mayteh.kendall@yahoo.com', 6);
INSERT [dbo].Person_Category (email_id, category_id) VALUES ('mayteh.kendall@yahoo.com', 3);
INSERT [dbo].Person_Category (email_id, category_id) VALUES ('mayteh.kendall@yahoo.com', 1);
INSERT [dbo].Person_Category (email_id, category_id) VALUES ('bruce.onandonga12@gmail.com', 5);
INSERT [dbo].Person_Category (email_id, category_id) VALUES ('bruce.onandonga12@gmail.com', 3);
INSERT [dbo].Person_Category (email_id, category_id) VALUES ('tony.antavius@asu.edu', 5);
INSERT [dbo].Person_Category (email_id, category_id) VALUES ('tony.antavius@asu.edu', 2);
INSERT [dbo].Person_Category (email_id, category_id) VALUES ('danny.bradley34@gmail.com', 1);
INSERT [dbo].Person_Category (email_id, category_id) VALUES ('danny.bradley34@gmail.com', 2);
INSERT [dbo].Person_Category (email_id, category_id) VALUES ('reynaldo.suscipe@gmail.com', 2);
INSERT [dbo].Person_Category (email_id, category_id) VALUES ('reynaldo.suscipe@gmail.com', 6);
INSERT [dbo].Person_Category (email_id, category_id) VALUES ('ger.sullivan@asu.edu', 3);
INSERT [dbo].Person_Category (email_id, category_id) VALUES ('ger.sullivan@asu.edu', 5);
INSERT [dbo].Person_Category (email_id, category_id) VALUES ('nicole.reh123@gmail.com', 5);
INSERT [dbo].Person_Category (email_id, category_id) VALUES ('nicole.reh123@gmail.com', 6);
INSERT [dbo].Person_Category (email_id, category_id) VALUES ('katy.smith@yahoo.com', 2);
INSERT [dbo].Person_Category (email_id, category_id) VALUES ('katy.smith@yahoo.com', 4);

--insert new service offers for each user
INSERT [dbo].Service(email_id, category_id, description) VALUES ('john.doe@gmail.com', 3, 'I will create videos for you!!!');
INSERT [dbo].Service(email_id, category_id, description) VALUES ('michelle.davison@gmail.com', 4, 'Let me create music using my amazing music skills for you!');
INSERT [dbo].Service(email_id, category_id, description) VALUES ('mayteh.kendall@yahoo.com', 2, 'I have 1500 followers on Facebook. I can market your product to them!');
INSERT [dbo].Service(email_id, category_id, description) VALUES ('bruce.onandonga12@gmail.com', 1, 'I can design your next flyer!');
INSERT [dbo].Service(email_id, category_id, description) VALUES ('tony.antavius@asu.edu', 6, 'I will hand out flyers for your business.');
INSERT [dbo].Service(email_id, category_id, description) VALUES ('danny.bradley34@gmail.com', 5, 'I will fix the HTML, CSS bugs on your website.');
INSERT [dbo].Service(email_id, category_id, description) VALUES ('reynaldo.suscipe@gmail.com', 4, 'I can write classical music for you.');
INSERT [dbo].Service(email_id, category_id, description) VALUES ('ger.sullivan@asu.edu', 5, 'I will help you normalize your database design!');
INSERT [dbo].Service(email_id, category_id, description) VALUES ('nicole.reh123@gmail.com', 1, 'I can paint a new poster for you');
INSERT [dbo].Service(email_id, category_id, description) VALUES ('katy.smith@yahoo.com', 6, 'I can help you advertise.');

--insert records into pending requests table
INSERT [dbo].Pending_Request(requester_id, provider_id, category_id, description, deadline) VALUES ('katy.smith@yahoo.com','bruce.onandonga12@gmail.com', 6, 'I need someone to hand out flyers for my ice cream business.', '20160408');
INSERT [dbo].Pending_Request(requester_id, provider_id, category_id, description, deadline) VALUES ('reynaldo.suscipe@gmail.com','ger.sullivan@asu.edu', 5, 'I need my database design normalized.', '20160410');
INSERT [dbo].Pending_Request(requester_id, provider_id, category_id, description, deadline) VALUES ('mayteh.kendall@yahoo.com','nicole.reh123@gmail.com', 1, 'I need a new poster painted.', '20160405');
INSERT [dbo].Pending_Request(requester_id, provider_id, category_id, description, deadline) VALUES ('tony.antavius@asu.edu','john.doe@gmail.com', 3, 'I need a video of my birthday made.', '20160402');
INSERT [dbo].Pending_Request(requester_id, provider_id, category_id, description, deadline) VALUES ('nicole.reh123@gmail.com','bruce.onandonga12@gmail.com', 1, 'I need a new design for a flyer.', '20160414');
INSERT [dbo].Pending_Request(requester_id, provider_id, category_id, description, deadline) VALUES ('bruce.onandonga12@gmail.com','michelle.davison@gmail.com', 4, 'I need someone to create music for my movie.', '20160412');
INSERT [dbo].Pending_Request(requester_id, provider_id, category_id, description, deadline) VALUES ('michelle.davison@gmail.com','mayteh.kendall@yahoo.com', 2, 'I need my amazing product marketed to businesses.', '20160415');
INSERT [dbo].Pending_Request(requester_id, provider_id, category_id, description, deadline) VALUES ('john.doe@gmail.com','danny.bradley34@gmail.com', 6, 'I need some HTML/CSS fixed for my website', '20160409');
INSERT [dbo].Pending_Request(requester_id, provider_id, category_id, description, deadline) VALUES ('michelle.davison@gmail.com','katy.smith@yahoo.com', 6, 'I need someone to help me advertise my business', '20160408');
INSERT [dbo].Pending_Request(requester_id, provider_id, category_id, description, deadline) VALUES ('danny.bradley34@gmail.com','bruce.onandonga12@gmail.com', 1, 'I need someone to design a new flyer.', '20160424');