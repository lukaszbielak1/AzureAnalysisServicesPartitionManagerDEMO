--Procedure for chceck last status of partition manager execution
--set model id which processing status should be verified
create procedure dbo.usp_ProcessFinishedSuccess @ModelID INT
as
declare @maxId int
declare @lastStatus char(6)   
set @maxId = (select max([PartitioningLogID]) from [dbo].[ProcessingLog]) 
set @lastStatus = (select LEFT([Message],6) from [dbo].[ProcessingLog] where [ModelConfigurationID] = @ModelID and [PartitioningLogID] = @maxId)

if @lastStatus = 'Finish'
	select 1
else 
	raiserror(50005,10,1,N'Failed')
	

