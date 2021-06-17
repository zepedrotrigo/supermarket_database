GO
CREATE PROCEDURE dbo.login 
@username INT,  
@pass VARCHAR(128),
@retval BIT=0 OUTPUT
AS
	BEGIN
		SET NOCOUNT ON;
		SET @retval=0
		IF EXISTS (SELECT TOP 1 [user] FROM supermarket.login WHERE [user] = @username)
			BEGIN
				IF EXISTS (SELECT TOP 1 [password] FROM supermarket.login WHERE [password] = @pass)
					BEGIN
						SET @retval=1
					END
			END
	END
GO

CREATE PROCEDURE dbo.getnumrows
@table VARCHAR(30),
@retval INT OUTPUT
AS
	BEGIN
		SET NOCOUNT ON;
		declare @sql varchar(max)
		set @sql='SELECT * FROM '+@table
		execute(@sql)
		SET @retval = @@ROWCOUNT
	END
GO

GO
CREATE PROCEDURE dbo.getEmployees
AS
	BEGIN
		SET NOCOUNT ON;
		SELECT person.[name], person.NIF, employee.employeeID, person.phone, person.email,
			employee.jobTitle, employee.salary, employee.employeeSince
			FROM supermarket.person JOIN supermarket.employee on person.NIF = employee.NIF;
	END
GO

GO

CREATE PROCEDURE dbo.getEmployeeColumns
AS
	BEGIN
		SET NOCOUNT ON;
		SELECT DISTINCT COLUMN_NAME
			FROM INFORMATION_SCHEMA.COLUMNS
			WHERE TABLE_NAME like 'employee' OR TABLE_NAME like 'person'
	END
GO

GO
CREATE PROC dbo.filterEmployees
(
    @nif INT = NULL,
    @name VARCHAR(50) = NULL,
	@address VARCHAR(100) = NULL,
	@phone VARCHAR(15) = NULL,
	@email VARCHAR(30) = NULL,
    @employeeID INT = NULL,
	@employeeSince DATE = NULL,
	@salary FLOAT(2) = NULL,
    @jobTitle VARCHAR(20) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
    SELECT DISTINCT * 
    FROM supermarket.person JOIN supermarket.employee on person.NIF = employee.NIF
    WHERE   (@nif IS NULL OR person.NIF = @nif)
            AND (@name IS NULL OR [name] LIKE @name+'%')
			AND (@address IS NULL OR [address] LIKE @address+'%')
			AND (@phone IS NULL OR phone LIKE @phone+'%')
            AND (@email IS NULL OR email LIKE @email+'%')
            AND (@employeeID IS NULL OR employeeID = @employeeID)
			AND (@employeeSince IS NULL OR employeeSince >= @employeeSince)
			AND (@salary IS NULL OR salary >= @salary)
            AND (@jobTitle IS NULL OR jobTitle LIKE @jobTitle+'%')
END
GO

GO
CREATE PROC dbo.addEmployee
(
    @nif INT = NULL,
    @name VARCHAR(50) = NULL,
	@address VARCHAR(100) = NULL,
	@phone VARCHAR(15) = NULL,
	@email VARCHAR(30) = NULL,
    @employeeID INT = NULL,
	@employeeSince DATE = NULL,
	@salary FLOAT(2) = NULL,
    @jobTitle VARCHAR(20) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO supermarket.person(NIF, [name], [address], phone, email)
	VALUES(@nif, @name, @address, @phone, @email);
	
	INSERT INTO supermarket.employee(employeeID, employeeSince, salary, jobtitle, NIF)
	VALUES(@employeeID, @employeeSince, @salary, @jobTitle, @nif);
END
GO