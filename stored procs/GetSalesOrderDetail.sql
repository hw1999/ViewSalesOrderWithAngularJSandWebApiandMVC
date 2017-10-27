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

/****** Object:  StoredProcedure [dbo].[GetSalesOrderDetail]    Script Date: 10/15/2017 10:09:02 PM ******/
DROP PROCEDURE [dbo].[GetSalesOrderDetail]
GO

/****** Object:  StoredProcedure [dbo].[GetSalesOrderDetail]    Script Date: 10/15/2017 10:09:02 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Hongwei Li
-- Create date: 2017-10-13
-- Description:	get the sales order detail
-- =============================================
CREATE PROCEDURE [dbo].[GetSalesOrderDetail]
	@SalesOrderID int = null
AS
BEGIN
	SET NOCOUNT ON;

	if @SalesOrderID is null 
	begin	    
		select top 50
			sod.ProductID,
			sod.SalesOrderID,	
			sod.SalesOrderDetailID,	
			sod.CarrierTrackingNumber,	
			sod.OrderQty,				
			sod.SpecialOfferID,	
			sod.UnitPrice,	
			sod.UnitPriceDiscount,	
			sod.LineTotal,	
			sod.ModifiedDate
		from [Sales].[SalesOrderDetail] sod with (nolock)				
		order by sod.ProductID, sod.SalesOrderID
	end
	else
	begin
		select 
			sod.ProductID,
			sod.SalesOrderID,	
			sod.SalesOrderDetailID,	
			sod.CarrierTrackingNumber,	
			sod.OrderQty,				
			sod.SpecialOfferID,	
			sod.UnitPrice,	
			sod.UnitPriceDiscount,	
			sod.LineTotal,	
			sod.ModifiedDate
		from [Sales].[SalesOrderDetail] sod with (nolock)	
		where sod.SalesOrderID = @SalesOrderID	
		order by sod.ProductID, sod.SalesOrderID
	end

END
GO

