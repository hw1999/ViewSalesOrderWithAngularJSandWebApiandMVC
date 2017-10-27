/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2016 (13.0.4001)
    Source Database Engine Edition : Microsoft SQL Server Enterprise Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2016
    Target Database Engine Edition : Microsoft SQL Server Enterprise Edition
    Target Database Engine Type : Standalone SQL Server
*/

USE [AdventureWorks2014]
GO

/****** Object:  StoredProcedure [dbo].[GetSalesOrderInfo]    Script Date: 10/18/2017 3:19:35 PM ******/
DROP PROCEDURE [dbo].[GetSalesOrderInfo]
GO

/****** Object:  StoredProcedure [dbo].[GetSalesOrderInfo]    Script Date: 10/18/2017 3:19:35 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Hongwei Li
-- Create date: 2017-10-12
-- Description:	get sales order info
-- =============================================
CREATE PROCEDURE [dbo].[GetSalesOrderInfo]
	 --@OrderDateFrom datetime,
	 --@OrderDateTo datetime,
	 --@DueDateFrom datetime =null,
	 --@DueDateTo datetime =null,
	 --@ShipDateFrom datetime = null,
	 --@ShipDateTo datetime = null,
	 --@CustomerName nvarchar(500) = null

	 @OrderDateFrom nvarchar(100),
	 @OrderDateTo nvarchar(100),
	 @DueDateFrom nvarchar(100) =null,
	 @DueDateTo nvarchar(100) =null,
	 @ShipDateFrom nvarchar(100) = null,
	 @ShipDateTo nvarchar(100) = null,
	 @CustomerName nvarchar(500) = null
AS
BEGIN
	SET NOCOUNT ON;
	
	select 
		@OrderDateFrom = isnull(@OrderDateFrom, ''),
		@OrderDateTo = isnull(@OrderDateTo, ''),
		@DueDateFrom = isnull(@DueDateFrom, ''),
		@DueDateTo = isnull(@DueDateTo, ''),
		@ShipDateFrom = isnull(@ShipDateFrom, ''),
		@ShipDateTo = isnull(@ShipDateTo, ''),
		@CustomerName = isnull(@CustomerName, '')

	select
		@OrderDateFrom = ltrim(rtrim(@OrderDateFrom)),
		@OrderDateTo = ltrim(rtrim(@OrderDateTo)),
		@DueDateFrom = ltrim(rtrim(@DueDateFrom)),
		@DueDateTo = ltrim(rtrim(@DueDateTo)),
		@ShipDateFrom = ltrim(rtrim(@ShipDateFrom)),
		@ShipDateTo = ltrim(rtrim(@ShipDateTo)),
		@CustomerName = ltrim(rtrim(@CustomerName))

	select * into #tempTable1
	from [Sales].[SalesOrderHeader] soh with (nolock)
	where OrderDate between @OrderDateFrom and @OrderDateTo

	create table 	#tempCommonTable (
	[SalesOrderID] [int] NULL,
	[RevisionNumber] [tinyint]  NULL,
	[OrderDate] [datetime]  NULL,
	[DueDate] [datetime]  NULL,
	[ShipDate] [datetime] NULL,
	[Status] [tinyint]  NULL,
	[OnlineOrderFlag] nvarchar(100)  NULL,
	[SalesOrderNumber]  nvarchar(255),
	[PurchaseOrderNumber] nvarchar(500) NULL,
	[AccountNumber] nvarchar(500) NULL,
	[CustomerID] [int]  NULL,
	[SalesPersonID] [int] NULL,
	[TerritoryID] [int] NULL,
	[BillToAddressID] [int]  NULL,
	[ShipToAddressID] [int]  NULL,
	[ShipMethodID] [int]  NULL,
	[CreditCardID] [int] NULL,
	[CreditCardApprovalCode] [varchar](15) NULL,
	[CurrencyRateID] [int] NULL,
	[SubTotal] [money]  NULL,
	[TaxAmt] [money]  NULL,
	[Freight] [money]  NULL,
	[TotalDue] [money] null,
	[Comment] [nvarchar](128) NULL,
	[rowguid]  [nvarchar](500)  NULL,
	[ModifiedDate] [datetime] NULL
	)

	create index tempCommonTableIndex01 ON #tempCommonTable(DueDate)
	create index tempCommonTableIndex02 ON #tempCommonTable(ShipDate)

	insert into #tempCommonTable
	select * 
	from #tempTable1

	drop table #tempTable1

	if @DueDateFrom != '' and @DueDateTo != ''
	begin
		select * into #tempTable2
		from #tempCommonTable 
		where DueDate between @DueDateFrom and @DueDateTo

		truncate table #tempCommonTable

		insert into #tempCommonTable
		select * 
		from #tempTable2

		drop table #tempTable2
	end

	if @ShipDateFrom != '' and @ShipDateTo != ''
	begin
		select * into #tempTable3
		from #tempCommonTable 
		where ShipDate between @ShipDateFrom and @ShipDateTo

		truncate table #tempCommonTable

		insert into #tempCommonTable
		select *
		from #tempTable3

		drop table #tempTable3
	end
    
	if @CustomerName != ''
	begin
		select soh.*, pe.FirstName + ' ' + pe.MiddleName + ' ' + pe.LastName as CustomerName into #tempTable4
		from #tempCommonTable soh
		join [Sales].[Customer] cu with (nolock) on cu.CustomerID = soh.CustomerID
		left join [Person].[BusinessEntityContact] bec with (nolock) on bec.PersonID = cu.PersonID
		left join [Person].[Person] pe with (nolock) on bec.BusinessEntityID = pe.BusinessEntityID
		
		select * into #tempTable5
		from #tempTable4
		where CustomerName like '%' + @CustomerName +'%'

		truncate table #tempCommonTable

		insert into #tempCommonTable
		select 
		SalesOrderID,	RevisionNumber,	OrderDate,	DueDate,	ShipDate,	Status,	OnlineOrderFlag,	SalesOrderNumber,	
		PurchaseOrderNumber,	AccountNumber,	CustomerID,	SalesPersonID,	TerritoryID,	BillToAddressID,	ShipToAddressID,	ShipMethodID,	CreditCardID,	CreditCardApprovalCode,	CurrencyRateID,	SubTotal,	TaxAmt,	Freight,	TotalDue,	Comment,	rowguid,	ModifiedDate
		from #tempTable5

		drop table #tempTable4
		drop table #tempTable5
	end

	select 
	    soh.SalesOrderID,
		pe.FirstName + ' ' + pe.MiddleName + ' ' + pe.LastName as 'CustomerName',
		soh.AccountNumber as 'AccountNumber', 
		ad.[AddressLine1] +',' + ad.City + ',' + sp.StateProvinceCode + ' '+ ad.PostalCode + ', ' + sp.CountryRegionCode  'ShipToAddress',
		sm.Name as 'ShipMethod',
		soh.SubTotal as 'SubTotal',
		soh.TaxAmt as Tax,
		soh.Freight,
		soh.TotalDue as Total,
		soh.OrderDate,
		soh.DueDate,
		soh.ShipDate
		
	from #tempCommonTable soh with (nolock)
	join [Person].[Address] ad with (nolock) on soh.ShipToAddressID = ad.AddressID
	join [Purchasing].[ShipMethod] sm with (nolock) on soh.ShipMethodID = sm.ShipMethodID
	join [Person].[StateProvince] sp with (nolock) on sp.StateProvinceID = ad.StateProvinceID
	join [Sales].[Customer] cu with (nolock) on cu.CustomerID = soh.CustomerID
	left join [Person].[BusinessEntityContact] bec with (nolock) on bec.PersonID = cu.PersonID
	left join [Person].[Person] pe with (nolock) on bec.BusinessEntityID = pe.BusinessEntityID		
	order by 2, 3,4

	drop table #tempCommonTable
END
GO

