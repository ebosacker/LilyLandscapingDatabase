/*
The following SQL query displays the Project Information shown in Exhibit B, Part C.
NOTE : All queries for Exhibit B are for ContractID 3- chosen at random.
         It can apply for any other ContractID.
*/
SELECT c.ContractID, ContractName, SiteAddress, SiteCity, SiteState, SiteZip,
       TaskDescription
FROM CONTRACT c JOIN Bid b ON c.ContractID = b.ContractID
WHERE c.ContractID = 3;

/*
The following SQL query displays the work hour breakdown shown in
   Exhibit B, Part D.
NOTE: All queries for Exhibit B are for ContractID 3- chosen at random.
         It can apply for any other ContractID.
*/
SELECT lr.Skill, FemaleWorkHours, MinorityWorkHours
FROM CONTRACT c JOIN TIME_ENTRY te ON c.ContractID = te.ContractID
    JOIN LABOR_RATE lr ON te.Skill = lr.Skill
WHERE c.ContractID = 3;


/*
The following SQL query displays the Regular Hours shown in Exhibit D, Part D.
NOTE: I created the EmployeeTotal subquery to ensure that the non-Overtime Hours
         are from the same Pay Statement, rather than total hours Employee has ever worked.
NOTE 2: All queries for Exhibit D are for ContractID 3- chosen at random.
         It can apply for any other ContractID.
*/
SELECT te.EmployeeID, te.Skill, PayRate, FringeBenefitsCompensation,(PayRate +
       FringeBenefitsCompensation) AS TotalPayRate, TotalHours,
       ((PayRate + FringeBenefitsCompensation)* EmployeeTotal.TotalHours) AS Gross
FROM TIME_ENTRY te JOIN LABOR_RATE lr ON te.Skill = lr.Skill
    JOIN PAY_STATEMENT ps ON te.PayStatementID = ps.PayStatementID
    JOIN (SELECT te.EmployeeID, te.PayStatementID,
            CASE
                WHEN SUM(WorkHours) > 40 THEN 40
                ELSE SUM(WorkHours)
            END AS TotalHours
        FROM TIME_ENTRY te JOIN PAY_STATEMENT ps ON te.PayStatementID = ps.PayStatementID
        GROUP BY te.EmployeeID, te.PayStatementID) EmployeeTotal
        ON te.EmployeeID = EmployeeTotal.EmployeeID
WHERE ContractID = 3;

/*
The following SQL query displays the Overtime Hours shown
 in Exhibit D, Part E.
NOTE: I created the EmployeeTotal subquery to ensure that the Overtime Hours
         are from the same Pay Statement, rather than total hours Employee has
         ever worked.
NOTE 2: All queries for Exhibit D are for ContractID 3- chosen at random.
         It can apply for any other ContractID.
*/
SELECT te.EmployeeID, te.Skill, PayRate, FringeBenefitsCompensation,((PayRate * 1.5) +
       FringeBenefitsCompensation) AS TotalPayRate, EmployeeTotal.OvertimeHours,
       ((PayRate + FringeBenefitsCompensation)* EmployeeTotal.OvertimeHours) AS Gross
FROM TIME_ENTRY te JOIN LABOR_RATE lr ON te.Skill = lr.Skill
    JOIN PAY_STATEMENT ps ON te.PayStatementID = ps.PayStatementID
    JOIN (SELECT te.EmployeeID, te.PayStatementID,
            CASE
                WHEN SUM(WorkHours) > 40 THEN (SUM(WorkHours)- 40)
                ELSE 0
            END AS OvertimeHours
          FROM TIME_ENTRY te JOIN PAY_STATEMENT ps ON te.PayStatementID = ps.PayStatementID
          GROUP BY te.EmployeeID, te.PayStatementID) EmployeeTotal
        ON te.EmployeeID = EmployeeTotal.EmployeeID
WHERE EmployeeTotal.OvertimeHours > 0
AND ContractID = 3;

/*
The following SQL query displays the Total Hours Worked Per Skill Classification
   shown in Exhibit D, Part F.
NOTE: I created the EmployeeTotal subquery to ensure that the hours per skill
         are from the same Pay Statement, rather than total hours that skill has
         ever had 
NOTE 2: All queries for Exhibit D are for ContractID 3- chosen at random.
         This can apply for any other ContractID.
*/
SELECT lr.Skill, RegularHours, OvertimeHours, (RegularHours + OvertimeHours) AS
       TotalHours
FROM TIME_ENTRY te JOIN LABOR_RATE lr ON te.Skill = lr.Skill
    JOIN PAY_STATEMENT ps ON te.PayStatementID = ps.PayStatementID
    JOIN (SELECT te.EmployeeID, te.PayStatementID,
            CASE
                WHEN SUM(WorkHours) > 40 THEN (SUM(WorkHours)- 40)
                ELSE 0
            END AS OvertimeHours,
            CASE
                WHEN SUM(WorkHours) > 40 THEN 40
                ELSE SUM(WorkHours)
            END AS RegularHours
        FROM TIME_ENTRY te JOIN PAY_STATEMENT ps ON te.PayStatementID = ps.PayStatementID
        GROUP BY te.EmployeeID, te.PayStatementID) EmployeeHours
       ON te.EmployeeID = EmployeeHours.EmployeeID
WHERE ContractID = 3
ORDER BY lr.Skill;

/*
The following SQL query displays the General Employee Information Form shown
   in Exhibit E.
Note: I am using the Employee 'James Worker' for the following Query. This can
   be done for any employee. 
*/
SELECT SocialSecurityNumber, LastName, FirstName, MiddleInitial, StreetAddress,
       City, StateAbbr, Zip, PhoneNumber, Birthdate, Gender, MaritalStatus,
       EEOCCode
FROM EMPLOYEE
WHERE LastName = 'Worker';

/*
The following SQL query displays the Statement of Earnings and Deductions
   for Regular Pay shown in Exhibit F.
Note: I am using the Employee 'James Worker' for the following Query. This can
   be done for any employee. 
*/
SELECT ContractName, lr.WorkDescription, PayRate, FringeBenefitsCompensation,
    (PayRate + FringeBenefitsCompensation) AS TotalPayRate, TotalHours,
       ((PayRate + FringeBenefitsCompensation)* EmployeeTotal.TotalHours) AS Gross
FROM TIME_ENTRY te JOIN LABOR_RATE lr ON te.Skill = lr.Skill
    JOIN PAY_STATEMENT ps ON te.PayStatementID = ps.PayStatementID
    JOIN (SELECT te.EmployeeID, te.PayStatementID,
            CASE
                WHEN SUM(WorkHours) > 40 THEN 40
                ELSE SUM(WorkHours)
            END AS TotalHours
        FROM TIME_ENTRY te JOIN PAY_STATEMENT ps ON te.PayStatementID = ps.PayStatementID
        GROUP BY te.EmployeeID, te.PayStatementID) EmployeeTotal
        ON te.EmployeeID = EmployeeTotal.EmployeeID
    JOIN EMPLOYEE e ON te.EmployeeID = e.EmployeeID
    JOIN CONTRACT c ON te.ContractID = c.ContractID
WHERE LastName = 'Worker'
ORDER BY ContractName;

/*
The following SQL query displays the Statement of Earnings and Deductions
   for Overtime Pay shown in Exhibit F.
Note: I am using the Employee 'James Worker' for the following Query. This can
   be done for any employee. 
*/
SELECT ContractName, lr.WorkDescription, PayRate, FringeBenefitsCompensation,((PayRate * 1.5) +
       FringeBenefitsCompensation) AS TotalPayRate, EmployeeTotal.OvertimeHours,
       ((PayRate + FringeBenefitsCompensation)* EmployeeTotal.OvertimeHours) AS Gross
FROM TIME_ENTRY te JOIN LABOR_RATE lr ON te.Skill = lr.Skill
    JOIN PAY_STATEMENT ps ON te.PayStatementID = ps.PayStatementID
    JOIN (SELECT te.EmployeeID, te.PayStatementID,
            CASE
                WHEN SUM(WorkHours) > 40 THEN (SUM(WorkHours)- 40)
                ELSE 0
            END AS OvertimeHours
          FROM TIME_ENTRY te JOIN PAY_STATEMENT ps ON te.PayStatementID = ps.PayStatementID
          GROUP BY te.EmployeeID, te.PayStatementID) EmployeeTotal
        ON te.EmployeeID = EmployeeTotal.EmployeeID
    JOIN EMPLOYEE e ON te.EmployeeID = e.EmployeeID
    JOIN CONTRACT c ON te.ContractID = c.ContractID
WHERE EmployeeTotal.OvertimeHours > 0
AND LastName = 'Worker';