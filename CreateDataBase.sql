USE [master]
GO
/****** Object:  Database [Bank_DB]    Script Date: 19.02.2022 18:41:54 ******/
CREATE DATABASE [Bank_DB]
GO
USE [Bank_DB]
GO
/****** Object:  Table [dbo].[Credits_Table]    Script Date: 19.02.2022 18:41:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Credits_Table](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DebetorID] [int] NOT NULL,
	[Amount] [money] NOT NULL,
	[Balance] [money] NOT NULL,
	[OpenDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Debetors_Table]    Script Date: 19.02.2022 18:41:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Debetors_Table](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[PostNumber] [int] NOT NULL,
	[PhoneNumber] [nvarchar](50) NULL,
 CONSTRAINT [PK_ID] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Payments_Table]    Script Date: 19.02.2022 18:41:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Payments_Table](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CreditsID] [int] NOT NULL,
	[Anount] [decimal](9, 2) NOT NULL,
	[PaymentDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Credits_Table]  WITH CHECK ADD FOREIGN KEY([DebetorID])
REFERENCES [dbo].[Debetors_Table] ([ID])
GO
ALTER TABLE [dbo].[Payments_Table]  WITH CHECK ADD FOREIGN KEY([CreditsID])
REFERENCES [dbo].[Credits_Table] ([ID])
GO
/****** Object:  StoredProcedure [dbo].[GetAllDebitors]    Script Date: 19.02.2022 18:41:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetAllDebitors]
AS
BEGIN
SELECT * FROM Debetors_Table ORDER BY [Name]
END
GO
/****** Object:  StoredProcedure [dbo].[GetAllGreditsByCurrentDebitor]    Script Date: 19.02.2022 18:41:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetAllGreditsByCurrentDebitor](@debitorID INT)
AS
BEGIN
SELECT * FROM Credits_Table WHERE DebetorID=@debitorID ORDER BY OpenDate
END
GO
/****** Object:  StoredProcedure [dbo].[GetAllGreditsByCurrentDebitorWhere]    Script Date: 19.02.2022 18:41:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetAllGreditsByCurrentDebitorWhere](@debitorID INT)
AS
BEGIN
SELECT * FROM Credits_Table WHERE DebetorID=@debitorID AND Balance>0 ORDER BY OpenDate
END
GO
/****** Object:  StoredProcedure [dbo].[GetAllPaymentsCurrentCreditsID]    Script Date: 19.02.2022 18:41:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetAllPaymentsCurrentCreditsID](@creditsID INT)
AS
BEGIN
SELECT * FROM Payments_Table WHERE CreditsID=@creditsID Order By PaymentDate
END
GO
/****** Object:  StoredProcedure [dbo].[InsertCredits_Table]    Script Date: 19.02.2022 18:41:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertCredits_Table]
@debitorID INT = NULL,
@Amount MONEY = NULL,
@Balance MONEY = NULL,
@OpenDate DATETIME = NULL
AS
BEGIN
INSERT INTO Credits_Table(DebetorID, Amount, Balance, OpenDate)
                VALUES (@debitorID, @Amount, @Balance, @OpenDate)
END
GO
/****** Object:  StoredProcedure [dbo].[InsertDebitors_Table]    Script Date: 19.02.2022 18:41:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertDebitors_Table]
@Name NVARCHAR(50) = NULL,
@PostNumber INT = NULL,
@PhoneNumber NVARCHAR(30) = NULL
AS
BEGIN
INSERT INTO Debetors_Table ([Name], PostNumber, PhoneNumber)
                VALUES (@Name,@PostNumber,@PhoneNumber)
END
GO
/****** Object:  StoredProcedure [dbo].[InsertPayment_Table]    Script Date: 19.02.2022 18:41:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertPayment_Table]
@CreditsID INT = NULL,
@Anount DECIMAL = NULL,
@PaymentDate DATETIME = NULL
AS
BEGIN
INSERT INTO Payments_Table
                (CreditsID, Anount, PaymentDate)
                VALUES (@CreditsID, @Anount, @PaymentDate)
END
GO
/****** Object:  StoredProcedure [dbo].[SearchDebitor]    Script Date: 19.02.2022 18:41:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SearchDebitor]
@debName NVARCHAR(50),
@debPostNum NVARCHAR(50),
@debPhoneNumber NVARCHAR(50)

AS
BEGIN

SELECT * FROM Debetors_Table WHERE
[Name] LIKE '%'+@debName+'%' AND
cast(PostNumber AS nvarchar(50)) LIKE '%'+@debPostNum+'%' AND
PhoneNumber LIKE '%'+@debPhoneNumber+'%'
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateCredit_Table]    Script Date: 19.02.2022 18:41:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateCredit_Table]
@payAmount1 MONEY,
@ID INT 
AS
BEGIN
UPDATE Credits_Table SET Balance = (Balance-@payAmount1) WHERE ID = @ID
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateDebitors_Table]    Script Date: 19.02.2022 18:41:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateDebitors_Table]
@ID INT, 
@Name NVARCHAR(50),
@PostNumber INT,
@PhoneNumber NVARCHAR(50)
AS
BEGIN
UPDATE Debetors_Table SET 
[Name] = @Name,
[PostNumber] = @PostNumber,
PhoneNumber = @PhoneNumber
WHERE ID = @ID
END
GO
USE [master]
GO
ALTER DATABASE [Bank_DB] SET  READ_WRITE 
GO
