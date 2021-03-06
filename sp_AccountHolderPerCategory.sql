USE [VanguardFinancialsDB_KDS_VNEXT]
GO
/****** Object:  StoredProcedure [dbo].[sp_AccountHolderPerCategory]    Script Date: 14/04/2022 09:17:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 
 ---exec [sp_AccountHolderPerCategory1] '1934EF3D-C0B4-C148-F0D6-08D30617F260','02/17/2016'
CREATE procedure [dbo].[sp_AccountHolderPerCategory]
 
 @ProductID varchar(100), 
 @EndDate DateTime 
 as
 begin
 set @EndDate=	(select DATEADD(day, DATEDIFF(day, 0, @EndDate), '23:59:59'));
 
 With AccountHolderPerCategory(AccountNo,AccountName,idno,Narration,Balance)
	AS
	(	
 select dbo.vfin_Customers.Reference1,(dbo.vfin_Customers.Individual_FirstName+''+dbo.vfin_Customers.Individual_LastName) as name,
  dbo.vfin_Customers.Individual_IdentityCardNumber,dbo.vfin_Enumerations.Description, SUM(dbo.vfin_JournalEntries.Amount) AS BALANCE

FROM            dbo.vfin_Customers INNER JOIN
                         dbo.vfin_CustomerAccounts ON dbo.vfin_Customers.Id = dbo.vfin_CustomerAccounts.CustomerId INNER JOIN
                         dbo.vfin_JournalEntries ON dbo.vfin_CustomerAccounts.Id = dbo.vfin_JournalEntries.CustomerAccountId INNER JOIN
                         dbo.vfin_Enumerations ON dbo.vfin_Customers.Individual_Type = dbo.vfin_Enumerations.Value INNER JOIN
                         dbo.vfin_SavingsProducts ON dbo.vfin_CustomerAccounts.CustomerAccountType_TargetProductId = dbo.vfin_SavingsProducts.Id AND 
                         dbo.vfin_JournalEntries.ChartOfAccountId = dbo.vfin_SavingsProducts.ChartOfAccountId
WHERE        (dbo.vfin_Enumerations.[Key] = 'CustomerType')  and @productid=vfin_Enumerations.id and dbo.vfin_JournalEntries.CreatedDate<=@EndDate
GROUP BY dbo.vfin_Customers.Reference1, dbo.vfin_Enumerations.Description,dbo.vfin_CustomerAccounts.CustomerAccountType_TargetProductId,
dbo.vfin_Customers.Individual_FirstName,dbo.vfin_Customers.Individual_IdentityCardNumber,dbo.vfin_Customers.Individual_LastName)


select AccountNo,AccountName,idno,Narration,Balance
from AccountHolderPerCategory
order by Narration,AccountNo
end





