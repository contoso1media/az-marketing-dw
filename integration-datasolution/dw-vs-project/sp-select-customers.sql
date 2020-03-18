CREATE PROCEDURE [dbo].[sp-select-customers]
	@custid int = 0
AS
	SELECT count(*) from dbo.Customer where id = @custid
RETURN 0
