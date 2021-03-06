USE [VanguardFinancialsDB_KDS_VNEXT]
GO
/****** Object:  StoredProcedure [dbo].[sp_AccountsOpened]    Script Date: 14/04/2022 09:34:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_AccountsOpened '01/01/2017','02/01/2017'
ALTER PROC [dbo].[sp_AccountsOpened]

@StartDate Datetime,
@EndDate DateTime

AS
set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));

SELECT       COALESCE( ltrim(rtrim(CASE dbo.vfin_Customers.Individual_Salutation WHEN '1' THEN 'Mr' WHEN '2' THEN 'Mrs' WHEN '3' THEN 'Miss' WHEN '4' THEN 'Dr' WHEN '5'
							  THEN 'Prof' WHEN '6' THEN 'Rev' WHEN '7' THEN 'Eng' WHEN '8' THEN 'Hon' WHEN '9' THEN 'Cllr' WHEN '13' THEN 'Sir' WHEN '11' THEN
							  'Ms' ELSE '' END + ' ' + isnull(dbo.vfin_Customers.Individual_FirstName,'') + ' ' + isnull(dbo.vfin_Customers.Individual_LastName,''))),'')+ COALESCE(  dbo.vfin_Customers.NonIndividual_Description,'') AS FullName, 
							 COALESCE( Individual_IdentityCardNumber,'')+COALESCE(NonIndividual_RegistrationNumber,'') as IdNo  ,Reference1 as AccountNo, Reference3 as PayrollNo,dbo.vfin_DutyStations.Description AS Station,RecruitedBy
FROM            dbo.vfin_Customers LEFT OUTER JOIN
                         dbo.vfin_DutyStations ON dbo.vfin_Customers.DutyStationId = dbo.vfin_DutyStations.Id
						 where dbo.vfin_Customers.RegistrationDate BETWEEN @StartDate and @EndDate 


						 --SELECT COALESCE(column1,'') + COALESCE(column2,'')


