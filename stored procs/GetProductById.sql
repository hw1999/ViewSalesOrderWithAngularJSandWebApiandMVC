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

/****** Object:  StoredProcedure [dbo].[GetProductById]    Script Date: 10/18/2017 10:14:29 PM ******/
DROP PROCEDURE [dbo].[GetProductById]
GO

/****** Object:  StoredProcedure [dbo].[GetProductById]    Script Date: 10/18/2017 10:14:29 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Hongwei Li
-- Create date: 2017-10-14
-- Description:	get the product by product id
-- =============================================
CREATE PROCEDURE [dbo].[GetProductById]
	@SalesOrderDetailID int,
	@ProductID int
AS
BEGIN
	SET NOCOUNT ON;

    select 
		sod.SalesOrderID,
		sod.SalesOrderDetailID,
		pr.ProductID,
		pr.Name,
		pr.ProductNumber ,
		sod.OrderQty ,
		sod.UnitPrice ,
		sod.UnitPriceDiscount ,
		sod.LineTotal 
	from [Sales].[SalesOrderDetail] sod with (nolock)
	join [Production].[Product] pr with (nolock) on sod.ProductID = pr.ProductID
	where sod.SalesOrderDetailID = @SalesOrderDetailID and pr.ProductID = @ProductID 
	order by sod.SalesOrderID, pr.Name

	
END
GO

