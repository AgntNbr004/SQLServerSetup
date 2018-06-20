/*
Created by	: Brent C. Rockwell
Written on	: 2018-06-19
Description	: This script creates a SQL Server Agent job to automatically run the cleanup stored procedure.
*/

-- Switch to the msdb environment for creating jobs.
USE msdb

SET NOCOUNT ON

GO

-- Create the job
EXEC dbo.sp_add_job
	@job_name = 'TEMP Cleanup',
	@description = 'This job is designed to ensure that the TEMP schema stays clean by dropping old objects.'

-- Inside the job created, add a step to complete
EXEC dbo.sp_add_jobstep
	@job_name = 'TEMP Cleanup',
	@step_name = 'RUN Cleanup Stored Procedure',
	@subsystem = 'TSQL',
	@command = 'EXEC BrentRockwell.TEMP.SchemaCleanup'

-- Create a schedule for the job to run on
DECLARE
	@Tomorrow NVARCHAR(8) = CONVERT(NVARCHAR(8), DATEADD(DD, 1, CAST(GETUTCDATE() AS DATE)), 112),
	@TwoAM NVARCHAR(5) = '20000'

EXEC dbo.sp_add_jobschedule
	@job_name = 'TEMP Cleanup',
	@name = 'Nightly Housekeeping',
	@freq_type = 4,
	@freq_interval = 1,
	@active_start_date = @Tomorrow,
	@active_start_time = @TwoAM

-- Attach the job to SQL Server
DECLARE
	@ServerName NVARCHAR(50) = @@SERVERNAME

EXEC dbo.sp_add_jobserver
	@job_name = 'TEMP Cleanup',
	@Server_name = @ServerName

GO


