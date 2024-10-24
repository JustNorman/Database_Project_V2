CREATE TABLE [EMPLOYEE] (
  [EMP_ID] <type>,
  [SUP_ID] <type>,
  [EMP_FNAME] <type>,
  [EMP_LNAME] <type>,
  [EMP_ADDRESS] <type>,
  [EMP_PHONE] <type>,
  [EMP_DOB] <type>,
  [EMP_TITLE] <type>,
  [TYPE] <type>,
  [MANAGER_ID] <type>,
  PRIMARY KEY ([EMP_ID]),
  CONSTRAINT [FK_EMPLOYEE.EMP_ID]
    FOREIGN KEY ([EMP_ID])
      REFERENCES [EMPLOYEE]([EMP_LNAME])
);

test