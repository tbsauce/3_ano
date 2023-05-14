-- a)
GO
CREATE PROC storedProcedure_remove @ssn INT 
AS
	BEGIN
		DELETE FROM  [Dependent] WHERE Essn=@ssn;
		DELETE FROM  Works_on WHERE Essn=@ssn;
		UPDATE  Department SET Mgr_ssn=NULL WHERE Mgr_ssn=@ssn;
		UPDATE  Employee set Super_ssn=NULL WHERE Super_ssn=@ssn;
		DELETE FROM  Employee WHERE Ssn=@ssn;
	END;

-- b)
GO
CREATE PROC storedProcedure_managers (@mgr_ssn INT OUTPUT, @worked_yrs INT OUTPUT)
AS
	BEGIN
		SELECT Employee.* FROM  Employee INNER JOIN  Department ON  Employee.Ssn= Department.Mgr_ssn;
		SELECT @mgr_ssn = Department.Mgr_ssn, @worked_yrs = DATEDIFF(year, Mgr_start_date, GETDATE()) FROM  Department 
			WHERE Mgr_start_date = (SELECT MIN(Mgr_start_date) from  Department);
	END

-- c)
GO
CREATE TRIGGER trigger_checkuniquedept ON  Department INSTEAD OF INSERT, UPDATE
AS
	BEGIN
		IF (SELECT count(*) FROM inserted) > 0
			BEGIN
				DECLARE @employee_ssn AS INT;
				SELECT @employee_ssn = Mgr_ssn FROM inserted;

				IF (@employee_ssn) IS NULL OR ((SELECT count(*) FROM Employee WHERE Ssn=@employee_ssn) = 0)
					RAISERROR('No Employee with these SSN', 16, 1);
				ELSE
					BEGIN
						IF (SELECT COUNT(Dnumber) FROM  Department WHERE Mgr_ssn=@employee_ssn) >=1
							RAISERROR('only one department per Employee', 16, 1);	
						ELSE
							INSERT INTO  Department SELECT * FROM inserted;
					END
			END
	END

-- d)
GO
CREATE TRIGGER trigger_lowerthangestor ON  Employee AFTER INSERT, UPDATE
AS
	BEGIN
		DECLARE @ssn_emp AS INT;
		DECLARE @sal_emp AS INT;
		DECLARE @dno AS INT;
		DECLARE @mgr_sal AS INT;

		SELECT @ssn_emp=inserted.Ssn, @sal_emp=inserted.Salary, @dno=inserted.Dno FROM inserted;
		SELECT @mgr_sal= Employee.Salary FROM  Department INNER JOIN  Employee ON  Department.Mgr_Ssn= Employee.Ssn WHERE @dno= Department.Dnumber;

		IF @sal_emp > @mgr_sal
		BEGIN
			UPDATE  Employee SET  Employee.Salary=@mgr_sal-1
			WHERE  Employee.Ssn=@ssn_emp
		END
	END

-- e)
GO
CREATE FUNCTION  udf_ssnFullInfo (@emp_ssn INT) RETURNS @table
TABLE([name] VARCHAR(45), [location] VARCHAR(15))
AS
	BEGIN
		INSERT @table
			SELECT  Project.Pname,  Project.Plocation FROM  Project INNER JOIN  Works_on ON  Works_on.Pno= Project.Pnumber WHERE Works_on.Essn=@emp_ssn
		RETURN;
	END
