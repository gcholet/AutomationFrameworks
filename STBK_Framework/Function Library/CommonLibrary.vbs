''################################################################################################################################
'  Function Name									UPDATE_TD_RESULTS
'  Purpose												 Function to update Results in Test Director 
'
'  Input Params										SummaryReportFile		
'																  TestLabFolderPath 		       			
'																  TestLabTestSetName	           		    
'
'  Output Params							   None
'
'  Changes											  Date				By					Description
'--------------------------------------------------------------------------------------------------------
'
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Public Function UPDATE_TD_RESULTS(byval objExcel_Act,ByVal SummaryReportFile, ByVal TestLabTestSetPath, ByVal TestLabTestSetName)
 
  Dim j, TDTestCase, Status,tdc ,TestSetFact, TSTestFact, theTestSet , theTSTest , TestSetTestsList , TestSetsList,  tsTreeMgr, tSetFolder
  Dim i ,worksheetname1,TestSetFound, ObjLclSheet, URL,  DomainName, ProjectName, UserID, Password, rowcount,TestName, rfact, myrun, Body
  worksheetname1 = "SummarySheet"
  objExcel_Act.Worksheets(worksheetname1).Cells(1,6)="TD Status"
  objExcel_Act.Worksheets(worksheetname1).Cells(1,6).Font.Bold=True
  objExcel_Act.Worksheets(worksheetname1).Cells(1,6).ColumnWidth = 10
  objExcel_Act.Worksheets(worksheetname1).Cells(1,6).Interior.ColorIndex = 1
    objExcel_Act.Worksheets(worksheetname1).Cells(1,6).Font.ColorIndex = 2  
  'Get Test Director Credentials
  DataTable.AddSheet("TD Credentials")
'  DataTable.ImportSheet "C:\TOPS Automation\Scheduler\DriverSheet.xls", "TD Credentials" ,"TD Credentials"
  DataTable.ImportSheet PathFinder.Locate("..\..\Scheduler\DriverSheet.xls"), "TD Credentials" ,"TD Credentials"
  URL = DataTable.Value("URL","TD Credentials")
  DomainName = DataTable.Value("Domain","TD Credentials")
  ProjectName = DataTable.Value("Project","TD Credentials")
  UserID = DataTable.Value("User_ID","TD Credentials")
  Password = DataTable.Value("Password","TD Credentials")
  rowcount =objExcel_Act.Worksheets(worksheetname1).usedrange.rows.count
  set tdc=CreateObject("TDAPIOLE80.TDConnection.1")  
    On Error Resume Next
  tdc.InitConnectionEx URL
  tdc.ConnectProjectEx DomainName, ProjectName, UserID, Password
  Set TestSetFact = tdc.TestSetFactory  
  Set tsTreeMgr = tdc.TestSetTreeManager  
  Set tSetFolder = tsTreeMgr.NodeByPath(TestLabTestSetPath)  
  Set TestSetsList = tSetFolder.FindTestSets(TestLabTestSetName)  
  Set theTestSet = TestSetsList.Item(1)  
  Set TSTestFact = theTestSet.TSTestFactory  
  Set TestSetTestsList = TSTestFact.NewList("") 
  
  For i=2 to rowcount
   Err.Clear
   For Each theTSTest In TestSetTestsList
    TDTestCase=objExcel_Act.Worksheets(worksheetname1).Cells(i,2)
    TDTestCase = "[1]"&TDTestCase
    Status=objExcel_Act.Worksheets(worksheetname1).Cells(i,5)
    TestName=theTSTest.Name
    
    If  Ucase(TDTestCase) = Ucase(TestName) then  
    Set rfact = theTSTest.RunFactory 
    Set myrun = rfact.AddItem("Test Run") 
    myrun.Status = Status 
    myrun.Post 
     Body=Body&vbcrlf&theTSTest.Name& Status
     TestSetFound = TRUE
    Exit for
    End if
    TestSetFound = FALSE
   Next 
   If Err.Description <> "" and TestSetFound = FALSE Then
    objExcel_Act.Worksheets(worksheetname1).Cells(i,6) ="Not Updated : Please Check the details provided in Driver sheet for : TD Path, URL, Domain, Project, User ID and Password" 
    Err.Clear
   ElseIf Err.Description = "" and TestSetFound <> TRUE then
    objExcel_Act.Worksheets(worksheetname1).Cells(i,6) ="Not Updated : Test Case not found"
   Else
   objExcel_Act.Worksheets(worksheetname1).Cells(i,6) = "UPDATED"
   End If
    objExcel_Act.ActiveWorkbook.Save 
  Next
  
  tdc.DisconnectProject
  tdc.ReleaseConnection
End Function
 
