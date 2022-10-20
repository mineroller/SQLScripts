DECLARE @OldAudit_Rows INT, @ToDel_Rows INT;
SET @OldAudit_Rows = 1;

SELECT @ToDel_Rows = (SELECT count(*) from TestEntry WHERE ActionDateLocal < DATEADD(DAY,-1,GETDATE()));

PRINT 'For today (' + CAST(SYSDATETIME() AS VARCHAR) + ') there are '+ CAST(@ToDel_Rows AS VARCHAR) +' to delete. Starting Delete.';

WHILE (@OldAudit_Rows > 0)
	BEGIN
		BEGIN TRANSACTION
		DELETE TOP(10000) FROM TestEntry WHERE ActionDateLocal < DATEADD(DAY,-1,GETDATE())

		SET @OldAudit_Rows = @@ROWCOUNT;

		COMMIT TRANSACTION

	END
