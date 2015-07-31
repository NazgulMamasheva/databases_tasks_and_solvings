USE [master]
GO

CREATE DATABASE [tournament]
GO

USE [tournament]
GO

CREATE TABLE [dbo].[team](
	[team_id] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[team_name] [nvarchar](5) NOT NULL,
	[city] [nvarchar](10) NOT NULL,
	[captain] [nvarchar](10) NOT NULL,
	[score] [int] NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[game](
	[game_id] [int] NOT NULL IDENTITY(1,1) PRIMARY KEY,
	[game_name] [nvarchar](10) NOT NULL,
	[date] [date] NOT NULL,
	[team_1] [int] NOT NULL REFERENCES [dbo].[team]([team_id]),
	[team_2] [int] NOT NULL REFERENCES [dbo].[team]([team_id]),
	[score_of_teams] [nvarchar](10) NULL
) ON [PRIMARY]
GO

INSERT INTO dbo.team
		   (team_name
           ,city
           ,captain
		   ,score)
     SELECT
           LEFT(CAST(NEWID() AS VARCHAR(100)), 5), 
           LEFT(CAST(NEWID() AS VARCHAR(100)), 10), 
           LEFT(CAST(NEWID() AS VARCHAR(100)), 10), 
		   CAST(CEILING(RAND() * 100) AS INT) % 20
GO 20

INSERT INTO dbo.game
		   (game_name
           ,date
           ,team_1
           ,team_2
           ,score_of_teams)
     SELECT
           LEFT(CAST(NEWID() AS VARCHAR(100)), 10), 
           DATEADD(day, +CAST(CEILING(RAND() * 100) AS INT), GETDATE()),
		   (SELECT TOP 1 team_id FROM dbo.team ORDER BY NEWID()),
		   (SELECT TOP 1 team_id FROM dbo.team ORDER BY NEWID()),
           LEFT(CAST(NEWID() AS VARCHAR(100)), 10)
GO 20

UPDATE dbo.game SET team_2=(SELECT TOP 1 team_id FROM dbo.team where team_id<>team_1 ORDER BY NEWID())
WHERE team_1=team_2

-----------------------------------------------------------------------------------------------------------
---subquery in select---
SELECT game_id, game_name, date, 
	(SELECT team_name FROM team WHERE team_id = team_1) as first_team, 
	(SELECT team_name FROM team WHERE team_id = team_2) as second_team
	 FROM game

---with inner join---
SELECT game_id, game_name, date, first_team, team_name as second_team 
FROM (SELECT game_id, game_name, date, team_name as first_team, team_2 FROM game inner join team on team_1=team_id) t
inner join team on team_2=team_id 
