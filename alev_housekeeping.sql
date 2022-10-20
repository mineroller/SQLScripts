DECLARE @OldAudit_Rows INT, @ToDel_Rows INT, @Older_Than INT;
SET @OldAudit_Rows = 1;

-------------------------------------------------------------
-- Change this value to set different retention.
-- MUST be in Negative number (i.e. -31 = older than 31 days)
SET @Older_Than = -31;
-------------------------------------------------------------

SELECT @ToDel_Rows = (SELECT count(*) from AuditEntry WHERE ActionDateLocal < DATEADD(DAY,@Older_Than,GETDATE()));

PRINT 'For today (' + CAST(SYSDATETIME() AS VARCHAR) + ') there are '+ CAST(@ToDel_Rows AS VARCHAR) +' records older than '+ CAST(@Older_Than AS VARCHAR) + ' days to delete. Starting Delete.';

WHILE (@OldAudit_Rows > 0)
	BEGIN
		BEGIN TRANSACTION
		DELETE TOP(10000) FROM AuditEntry WHERE ActionDateLocal < DATEADD(DAY,@Older_Than,GETDATE())

		SET @OldAudit_Rows = @@ROWCOUNT;

		COMMIT TRANSACTION

	END