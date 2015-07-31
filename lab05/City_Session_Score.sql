WITH T1 AS (
SELECT 
(SELECT City_Name from Cities where City_ID = RegForms_Headers.City_ID) AS RHCN,
RegForms_Items.Item_ID AS RII,
(SELECT Session_name from Exams_Sessions where Session_ID = (SELECT SESSION_ID FROM Exams_Schedule WHERE Schedule_ID = RegForms_Items.Schedule_ID)) AS RISN,
(SELECT Session_Start from Exams_Sessions where Session_ID = (SELECT SESSION_ID FROM Exams_Schedule WHERE Schedule_ID = RegForms_Items.Schedule_ID)) AS RISD
FROM 
RegForms_Headers INNER JOIN RegForms_Items ON RegForms_Headers.Header_ID = RegForms_Items.Header_ID),

T2 AS (
SELECT RHT.Header_ID, RHT.RegForm_Item_ID, RHT.Notify_Score FROM RegForms_Items INNER JOIN 
(SELECT * FROM Results_Headers WHERE isFinal = 'True') RHT ON [dbo].[RegForms_Items].Item_ID = RHT.RegForm_Item_ID),

T3 AS (
SELECT 
RII, RHCN, RISN,RISD, Notify_Score 
FROM T1 INNER JOIN T2 ON T1.RII = T2.RegForm_Item_ID)

SELECT T3.RHCN, T3.RISN, SUM(CASE WHEN T3.Notify_Score >= 75 then 1 ELSE 0 END) * 100 / COUNT(Notify_Score) AS NS  FROM T3 GROUP BY T3.RHCN, T3.RISN, T3.RISD ORDER BY T3.RHCN, RISD ASC

