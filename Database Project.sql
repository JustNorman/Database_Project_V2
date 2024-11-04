CREATE TABLE EMPLOYEE ( --WORKS
    EMP_ID INT PRIMARY KEY,
    EMP_FNAME VARCHAR(50) NOT NULL,
    EMP_LNAME VARCHAR(50) NOT NULL,
    EMP_ADDRESS VARCHAR(100),
    EMP_PHONE VARCHAR(15),
    EMP_DOB DATE,
    EMP_TITLE VARCHAR(50) NOT NULL,
    TYPE VARCHAR(20),
    MANAGER_ID INT,
    CONSTRAINT FK_EMPLOYEE_MANAGER
        FOREIGN KEY (MANAGER_ID)
        REFERENCES EMPLOYEE(EMP_ID)
);


CREATE TABLE JOB_TITLE ( --WORKS
    EMP_TITLE VARCHAR(50) PRIMARY KEY,
    JOB_DESC VARCHAR(255),
    JOB_SALARY DECIMAL(10, 2)
);

CREATE TABLE EMPLOYMENT_HISTORY_BRIDGE ( --WORKS
    EMP_ID INT,
    EMP_TITLE VARCHAR(50),
    START_DATE DATE,
    END_DATE DATE,
    SALARY DECIMAL(10, 2),
    PRIMARY KEY (EMP_ID, START_DATE),
    FOREIGN KEY (EMP_ID) REFERENCES EMPLOYEE (EMP_ID),
    FOREIGN KEY (EMP_TITLE) REFERENCES JOB_TITLE (EMP_TITLE)
);

CREATE TABLE SALARY ( --WORKS
    EMP_ID INT PRIMARY KEY,
    BASE_SALARY DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (EMP_ID) REFERENCES EMPLOYEE (EMP_ID)
);


CREATE TABLE WAGE ( --WORKS
    EMP_ID INT PRIMARY KEY,
    HOURLY_RATE DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (EMP_ID) REFERENCES EMPLOYEE (EMP_ID)
);

--D TYPE RELATIONSHIP
CREATE TRIGGER trg_disjoint_salary_wage
ON SALARY
AFTER INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM WAGE WHERE WAGE.EMP_ID = (SELECT EMP_ID FROM inserted))
    BEGIN
        ROLLBACK;
        RAISERROR ('Employee already has a wage entry', 16, 1);
    END
END;
GO

CREATE TRIGGER trg_disjoint_wage_salary
ON WAGE
AFTER INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM SALARY WHERE SALARY.EMP_ID = (SELECT EMP_ID FROM inserted))
    BEGIN
        ROLLBACK;
        RAISERROR ('Employee already has a salary entry', 16, 1);
    END
END;
GO

CREATE TABLE [SHIFT] ( --WORKS
    [SHIFT_ID] INT PRIMARY KEY,
    [SHIFT_START] DATETIME,
    [SHIFT_END] DATETIME,
    [BREAK] VARCHAR(50)
);

CREATE TABLE [CLOCK_IN_BRIDGE] ( --WORKS
    [SHIFT_ID] INT,
    [EMP_ID] INT,
    [START_TIME] DATETIME,
    [END_TIME] DATETIME,
    PRIMARY KEY ([SHIFT_ID], [EMP_ID]),
    FOREIGN KEY ([SHIFT_ID]) REFERENCES [SHIFT]([SHIFT_ID]),
    FOREIGN KEY ([EMP_ID]) REFERENCES WAGE(EMP_ID)
);

CREATE TABLE CHEF (
    EMP_ID INT PRIMARY KEY,
    FOREIGN KEY (EMP_ID) REFERENCES EMPLOYEE (EMP_ID)
);

CREATE TABLE MANAGER (
    EMP_ID INT PRIMARY KEY,
    FOREIGN KEY (EMP_ID) REFERENCES EMPLOYEE (EMP_ID)
);

CREATE TRIGGER trg_disjoint_salary_manager
ON SALARY
AFTER INSERT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM MANAGER WHERE MANAGER.EMP_ID = (SELECT EMP_ID FROM inserted)) AND 
       NOT EXISTS (SELECT 1 FROM CHEF WHERE CHEF.EMP_ID = (SELECT EMP_ID FROM inserted))
    BEGIN
        ROLLBACK;
        RAISERROR ('Only Managers or Chefs can have salary entries', 16, 1);
    END
END;
GO

CREATE TRIGGER trg_disjoint_salary_manager
ON SALARY
AFTER INSERT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM MANAGER WHERE MANAGER.EMP_ID = (SELECT EMP_ID FROM inserted)) AND 
       NOT EXISTS (SELECT 1 FROM CHEF WHERE CHEF.EMP_ID = (SELECT EMP_ID FROM inserted))
    BEGIN
        ROLLBACK;
        RAISERROR ('Only Managers or Chefs can have salary entries', 16, 1);
    END
END;
GO

CREATE TRIGGER trg_disjoint_manager_salary
ON MANAGER
AFTER INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM CHEF WHERE CHEF.EMP_ID = (SELECT EMP_ID FROM inserted)) OR
       EXISTS (SELECT 1 FROM SALARY WHERE SALARY.EMP_ID = (SELECT EMP_ID FROM inserted))
    BEGIN
        ROLLBACK;
        RAISERROR ('Employee cannot be both a Manager and a Chef', 16, 1);
    END
END;
GO

CREATE TRIGGER trg_disjoint_chef_salary
ON CHEF
AFTER INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM MANAGER WHERE MANAGER.EMP_ID = (SELECT EMP_ID FROM inserted)) OR
       EXISTS (SELECT 1 FROM SALARY WHERE SALARY.EMP_ID = (SELECT EMP_ID FROM inserted))
    BEGIN
        ROLLBACK;
        RAISERROR ('Employee cannot be both a Chef and a Manager', 16, 1);
    END
END;
GO

CREATE TABLE [CHEF_CRED_BRIDGE] ( --WORKS
    [EMP_ID] INT,
    [CERT_ID] INT,
    [EXAM_DATE] DATE,
    [CERT_EXP_DATE] DATE,
    PRIMARY KEY ([EMP_ID], [CERT_ID]),
    FOREIGN KEY ([EMP_ID]) REFERENCES CHEF(EMP_ID),
    FOREIGN KEY ([CERT_ID]) REFERENCES CHEF_CERT(CERT_ID)
);


CREATE TABLE [CHEF_CERT] ( --WORKS
  [CERT_ID] INT,
  [CERT_FEE] DECIMAL(10, 2),
  [CERT_DATE_OFFER] DATE,
  PRIMARY KEY ([CERT_ID])
);


CREATE TABLE [MAN_CERT] ( --WORKS
  [CERT_ID] INT,
  [CERT_FEE] DECIMAL(10, 2),
  [CERT_DATE_OFFER] DATE,
  PRIMARY KEY ([CERT_ID])
);

CREATE TABLE [MAN_CRED_BRIDGE] ( --WORKS
  [EMP_ID] INT,
  [CERT_ID] INT,
  [EXAM_DATE] DATE,
  [CERT_EXP_DATE] DATE,
  PRIMARY KEY ([EMP_ID], [CERT_ID]),
  FOREIGN KEY ([EMP_ID]) REFERENCES MANAGER(EMP_ID),
  FOREIGN KEY ([CERT_ID]) REFERENCES MAN_CERT(CERT_ID)
);