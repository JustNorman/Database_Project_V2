CREATE TABLE EMPLOYEE (
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


CREATE TABLE EMPLOYMENT_HISTORY (
    EMP_ID INT,
    EMP_TITLE VARCHAR(50),
    START_DATE DATE,
    END_DATE DATE,
    SALARY DECIMAL(10, 2),
    PRIMARY KEY (EMP_ID, START_DATE),
    FOREIGN KEY (EMP_ID) REFERENCES EMPLOYEE(EMP_ID)
);


CREATE TABLE [JOB_TITLE] (
  [EMP_TITLE] VARCHAR(50),
  [JOB_DESC] VARCHAR(255),
  [JOB_SALARY] DECIMAL(10, 2),
  PRIMARY KEY ([EMP_TITLE])
);


CREATE TABLE [SHIFT] (
  [SHIFT_ID] INT PRIMARY KEY,
  [SHIFT_START] DATETIME,
  [SHIFT_END] DATETIME,
  [BREAK] VARCHAR(50)
);


CREATE TABLE [CLOCK_IN] (
  [SHIFT_ID] INT,
  [EMP_NUM] INT,
  [CLOCK_IN_TIME] DATETIME,
  [CLOCK_OUT_TIME] DATETIME,
  PRIMARY KEY ([SHIFT_ID], [EMP_NUM]),
  FOREIGN KEY ([SHIFT_ID]) REFERENCES [SHIFT]([SHIFT_ID])
);


CREATE TABLE [WAGE] (
  [EMP_ID] INT,
  PRIMARY KEY ([EMP_ID])
);