Class QCIntegration_Module	

		Public Excel

		'********************************************************************************************************************************************************
		'FUNCTION HEADER
		'********************************************************************************************************************************************************
		' Name:DownloadAttachementFromQC
		' Description: This function is used to download attachment attached to test case of qc
		' Input Parameter: ServerName, ByVal UserName, ByVal Password, ByVal Domain,  ByVal Project, ByVal FolderName, ByVal TestNameFromQC,ByVal DownloadPath,ByVal TestScriptName
		
		'********************************************************************************************************************************************************
		
		Function DownloadAttachementFromQC(ByVal ServerName, ByVal UserName, ByVal Password, ByVal Domain,  ByVal Project, ByVal FolderName, ByVal TestNameFromQC,ByVal DownloadPath,ByVal TestScriptName)    
		
			QCServerPath = "http://" & ServerName & "/qcbin/"
			
			Set QCConnection = QCUtil.QCConnection
		
			Set treeMgr = QCConnection.TreeManager
			Set testFactory= QCConnection.TestFactory			
		
			If Len(FolderName) <> 0 Then
				SubjectPath = "Subject\" & FolderName
			Else
				SubjectPath = "Subject" 
			End If
					
			Set TestFilter = testFactory.Filter 
			TestFilter.Filter("TS_NAME") = Chr(34) & Trim(TestNameFromQC)  & Chr(34)
			Set TestList = testFactory.NewList(TestFilter.Text)
			Set GetTest = TestList.Item(1)
			Set attachFact = GetTest.Attachments 
			Set attachList = attachFact.NewList("") 
								
			For each tAttach In attachList
				Set attachemntstorage = tAttach.AttachmentStorage
					
				attachemntstorage.ClientPath = DownloadPath 						
				QCFileName=tAttach.name(0)
				ActualFileName=tAttach.name(1)		
				DownloadFileName =Mid(ActualFileName,1,Len(ActualFileName)-4)
												
				If StrComp(TestScriptName,DownloadFileName,1)=0 Then									
					attachemntstorage.Load tAttach.name,True
					Set renfile = CreateObject("Scripting.FileSystemObject")												
					If renFile.FolderExists(attachemntstorage.ClientPath) Then
						If  renFile.FileExists(attachemntstorage.ClientPath & "\" & ActualFileName) Then
							Set delfile = renFile.GetFile(attachemntstorage.ClientPath & "\" & ActualFileName)
							delfile.delete
						End If									
						renFile.MoveFile attachemntstorage.ClientPath & "\" & QCFileName,attachemntstorage.ClientPath & "\" & ActualFileName 
					End If
				End If
			Next
		
		End Function
		
		
		Function UploadTestResultsInQCFromExcel(ByVal ServerName, ByVal UserName, ByVal Password, ByVal Domain,  ByVal Project, ByVal spa_Path, ByVal spa_tst ,ByVal  ExcelFile)
		
			Dim StartLoopCnt,MaxLoopCnt
			Dim blnNextTestCase,blnFailed
				
			GetFromExcel TestNameArr, StepsNameArr, DescriptionArr, ExpectedResultArr, ActualResultArr, StatusArr, ExcelFile
		
			MaxLoopCnt= UBound(TestNameArr)	
			blnProceed = True
			
			QCServerPath = "http://" & ServerName & "/qcbin/"
			 
			Set QCConnection = QCUtil.QCConnection
		
				StartLoopCnt = 0
				Set spa_TrMgr = QCConnection.TestSetTreeManager		
				Set spa_Folder = spa_TrMgr.NodeBypath(spa_Path)		
				Set spa_TestSetF = spa_Folder.TestSetFactory		
				Set spa_tsetList = spa_TestSetF.NewList("")		
				For Each spa_Mytestset In spa_tsetList			
					If spa_Mytestset.Name = spa_tst Then
						Set spa_TestSetF1  = spa_MYtestset.TSTestFactory
						Set spa_TestSetF2  = QCConnection.TestFactory
						blnNextTestCase = True
						StartLoopCnt = 0 
						Do while StartLoopCnt <= MaxLoopCnt
							spa_Tid= TestNameArr(StartLoopCnt)					
							If blnNextTestCase Then
								Set spa_Testsetlist = spa_TestSetF2.Newlist("SELECT  *  FROM  TEST  WHERE  TS_NAME ='" & spa_Tid & "'")						
								 For each spa_Tstt IN spa_TestsetList
									Set spa_MYtestset1 = spa_TestSetF1.AddItem(spa_Tstt.ID)													  
									spa_TestsetID = spa_Tstt.ID							
									spa_Mytestset1.Status= "No Run" ' spa_Status
									spa_Mytestset1.Post
									Set spa_RunF = spa_Mytestset1.RunFactory
									Set spa_Myrun= spa_RunF.AddItem("Run_" & DatePart("m",Date) & "-" & DatePart("d", Date) & "_" & DatePart("h",Time) & "-" & DatePart("n", Time)  & "-" & DatePart("s", Time))
																						
									spa_Myrun.Status = "No Run"'spa_Status
									spa_Myrun.Post
								Next
							End If
							StepName = StepsNameArr(StartLoopCnt)					
							StepDescription = DescriptionArr(StartLoopCnt)
							ExpectedResult =ExpectedResultArr(StartLoopCnt)
							ActualResult =ActualResultArr(StartLoopCnt)
							Status=StatusArr(StartLoopCnt)
												
							Set spa_run = spa_Myrun.StepFactory
							Set spa_Mystep= spa_run.AddItem(StepName)
							spa_Mystep.Name = StepName
							spa_Mystep.Field("ST_DESCRIPTION")=StepDescription
							spa_Mystep.Field("ST_EXPECTED")=ExpectedResult
							spa_Mystep.Field("ST_ACTUAL")=ActualResult
							spa_Mystep.Status = Status
							spa_Mystep.Post
		
							StartLoopCnt = StartLoopCnt+1
							If  (StrComp(Status,"FAILED",1) = 0)  Then
								blnFailed =True
							End If
										
							If StartLoopCnt <= MaxLoopCnt  Then
								If  (StrComp(spa_Tid, TestNameArr(StartLoopCnt),1) <>0)  Then
									blnNextTestCase = True
								Else
									blnNextTestCase = False
								End If
							Else
								blnNextTestCase = True
							End If
												
							If blnNextTestCase Then
								If blnFailed Then
									spa_Myrun.Status = "Failed"
								Else
									spa_Myrun.Status = "Passed"
								End If
								spa_Myrun.Post
								blnFailed = False
							End If	
										
						loop
					End If
				Next
					
		End Function


		
		Function GetFromExcel (ByRef TestName , ByRef  StepsName ,ByRef stepDescription, ByRef ExpectedResult, ByRef  ActualResult, ByRef Status, ByVal ExcelFile)
		
				Dim Sheet 
				Dim usedRowsCount 
				Dim rowObj
				Dim columnObj 
				Dim curRow 
				Dim curCol 
				Dim strTestID 
				Dim strTestName 
				Dim strStepname 
				Dim strActualResult 
			Dim strDescription
			Dim strExpectedResult
		
			Set ExcelObject = CreateObject("Excel.Application")
				ExcelObject.DisplayAlerts = False
				ExcelObject.Workbooks.Open(ExcelFile)
			   
			Set Sheet = ExcelObject.Sheets("AutoTest")
				
				' Total rows are used in the current worksheet
				usedRowsCount =  Sheet.UsedRange.Rows.Count 
				columnObj = 1
		
			For rowObj = 2 To (usedRowsCount)
				curRow = rowObj 
				curCol = columnObj 
				' get the value that is in the cell 
				
				strTestName =  strTestName &  Sheet.Cells(curRow, curCol).Value & "|"
				strStepname = strStepname &  Sheet.Cells(curRow, curCol + 1).Value & "|"
				strDescription = strDescription &  Sheet.Cells(curRow, curCol + 2).Value & "|"
				strExpectedResult = strExpectedResult &  Sheet.Cells(curRow, curCol + 3).Value & "|"
				strActualResult = strActualResult & Sheet.Cells(curRow, curCol+4).Value & "|"
				strStatus = strStatus & Sheet.Cells(curRow, curCol+5).Value & "|"
			  Next
		
				strTestName = Mid(strTestName,1,Len(strTestName) -1)  
				strStepname = Mid(strStepname,1,Len(strStepname) -1) 
				strDescription =Mid(strDescription,1,Len(strDescription) -1) 
				strExpectedResult =Mid(strExpectedResult,1,Len(strExpectedResult) -1) 
				strActualResult = Mid(strActualResult,1,Len(strActualResult) -1) 
				strStatus = Mid(strStatus,1,Len(strStatus) -1) 
				
			'Split the string into array to fill  the value into array
			TestName = Split(strTestName,"|")
			StepsName = Split(strStepname,"|")
			StepDescription = Split(strDescription,"|")
			ExpectedResult = Split(strExpectedResult,"|")
			ActualResult = Split(strActualResult,"|")
			Status = Split(strStatus,"|")
		
				If Not Sheet Is Nothing Then
				set  Sheet = Nothing
			End If
				
			If Not ExcelObject Is Nothing Then
				ExcelObject.Quit()
				set ExcelObject = Nothing
			End If
		
		End Function
		
		
		Function CloseExcelFile(ByVal ObjExcel)
				
			ObjExcel.Quit
			set ObjExcel = Nothing
		End Function
		
		Function CreateExcelFile()
		
				
			'Create an Excel Object
			Set ObjExcel = CreateObject ("Excel.Application")
			
			'Add workbook
			ObjExcel.WorkBooks.Add()
			
			' Set the alerts to false for excel
			ObjExcel.DisplayAlerts = 0	
			Set CreateExcelFile = ObjExcel
		End Function
		

		
		''By Teekam 9 Sep 2009 , New and applicable
		Function WriteTestResultInExcel (ByRef TestName , ByRef  StepsName ,ByRef stepDescription, ByRef ExpectedResult, ByRef  ActualResult, ByRef Status, ByRef UseExcelObject,ByRef ExcelFile)
		
			'Create an Excel Object		
		
			' Set the active sheet
			Set objSheet = UseExcelObject.ActiveSheet
			
			' Set the sheet name'		
			objSheet.Name = "AutoTest"
		
			'Set the columen header of excel
			objSheet.Cells(1, 1).Value = "TestCase_Name"
			objSheet.Cells(1, 2).Value = "Step_Name"
			objSheet.Cells(1, 3).Value = "Description"
			objSheet.Cells(1, 4).Value = "Expected_Result"
			objSheet.Cells(1, 5).Value = "Actual_Result"
			objSheet.Cells(1, 6).Value = "Status"
		
			Set rngUsed = objSheet.UsedRange
		
			nRows=rngUsed.Rows.count
		
			''If condition added by Teekam , 9 Sep
			If  instr(TestName , ":" ) > 1 Then
				arr_TestName = Split(TestName , ":" )
				For iloop= 0 to UBound(arr_TestName)		
					nRow = nRows+1			
					' Set the excel values
					objSheet.Cells(nRow, 1).Value = Trim( arr_TestName(iloop))		
					objSheet.Cells(nRow, 2).Value = StepsName
					objSheet.Cells(nRow, 3).Value =stepDescription
					objSheet.Cells(nRow, 4).Value = ExpectedResult
					objSheet.Cells(nRow, 5).Value = ActualResult
					objSheet.Cells(nRow, 6).Value = Status
					nRows = nRow   			
				Next
			Else
				nRow = nRows+1			
				' Set the excel values
				objSheet.Cells(nRow, 1).Value = TestName
				objSheet.Cells(nRow, 2).Value = StepsName
				objSheet.Cells(nRow, 3).Value =stepDescription
				objSheet.Cells(nRow, 4).Value = ExpectedResult
				objSheet.Cells(nRow, 5).Value = ActualResult
				objSheet.Cells(nRow, 6).Value = Status      
			End If
		
			UseExcelObject.ActiveWorkbook.SaveAs(ExcelFile)
		
		
		
		''==========================================
		''Teekam Code for ascending result in Excel for case of more than 1 test case update by on e automation script
		''10 Sep 
		
			Const XLascending =1 
			Set ObjExcel = UseExcelObject  	
		   Set Wbook = ObjExcel.WorkBooks.Open (ExcelFile)
			Set objSheet1=Wbook.Worksheets (1)   	
			set objrange = objSheet1.UsedRange
			set objrange2 = ObjExcel.Range("A1")
			objrange.sort  objrange2 , XLascending , ,   , ,   , , 1
		
			ObjExcel.ActiveWorkbook.Save
		
			Set objrange2= Nothing
			Set objrange= Nothing
			Set objSheet1= Nothing
			Set Wbook= Nothing
			Set ObjExcel= Nothing
		
		End Function
		
		
		
		Function UploadResultLogInQC(ByVal strDriveName, ByVal strProjectName)    			
				
				QCPAYLESSProject = "Subject\"
		
				QCPAYLESSProject ="Subject\"		
				TestResultLogPathInQC = QCPAYLESSProject & "PaylessEComm_RegressionAutomation\CRAFT\Framework_Scripts\Reports\" & strProjectName & "\Test_Results_Log"
				TestResultLogPath = strDriveName & "PaylessEComm_RegressionAutomation\CRAFT\Framework_Scripts\Reports\" & strProjectName & "\Test_Results_Log"
				ScreenshotPathInQC = QCPAYLESSProject & "PaylessEComm_RegressionAutomation\CRAFT\Framework_Scripts\Reports\" & strProjectName & "\Screen_Shot"
				ScreenshotPath = strDriveName & "PaylessEComm_RegressionAutomation\CRAFT\Framework_Scripts\Reports\" & strProjectName & "\Screen_Shot"
		
				Set QC = QCUtil.QCConnection
				Set treeMgr = QC.TreeManager
			
				Set attachFolder = treeMgr.NodeByPath(TestResultLogPathInQC)
				'Call the FolderAttachment routine to upload all the attachment	
				Set Attachments = attachFolder.Attachments
				'Get the list of attachments and upload new attachement one at a time. 
				Set fso = CreateObject("Scripting.FileSystemObject")
				Set fldr = fso.GetFolder(TestResultLogPath)
				Set flsc = fldr.Files
				For Each fl In flsc
					If UCase(Right(fl.Name,4)) = "HTML" Then
						Rep_File_Path= TestResultLogPath & "\" & fl.Name
						arrTemp = Split(fl.Name,".",-1,1)
						strFix = Replace(Replace(Now,"/",""),":","")
						strFix = Replace(strFix," ","")				
						Rep_NewFile_Path = TestResultLogPath & "\" & arrTemp(0) & strFix & "." & arrTemp(1)
						fl.Copy Rep_NewFile_Path						
			
						Set Attachment = Attachments.AddItem(Null)
						Attachment.FileName = Rep_NewFile_Path
						Attachment.Description = "Test Result Log "
						Attachment.Type = 1
						Attachment.Post 
						Wait(2)
						Set fld = fso.GetFile(Rep_NewFile_Path)	
						fld.Delete
						Set fld = Nothing
					End If			
				Next 		
					
				Set attachFolder = treeMgr.NodeByPath(ScreenshotPathInQC)
				' Call the FolderAttachment routine to upload all the attachment	
				Set Attachments = attachFolder.Attachments
				' Get the list of attachments and upload new attachement one at a time. 		
				Set fldr = fso.GetFolder(ScreenshotPath)
				Set flsc = fldr.Files
				For Each fl In flsc
					If UCase(Right(fl.Name,3)) = "PNG" Then
						Rep_File_Path= ScreenshotPath & "\" & fl.Name				
						Set Attachment = Attachments.AddItem(Null)
						Attachment.FileName = Rep_File_Path
						Attachment.Description = "Screen shot"
						Attachment.Type = 1
						Attachment.Post
					End If 				
				Next 
				Set fl = Nothing
				Set flsc = Nothing
				Set fldr = Nothing
				Set fso = Nothing
				Set QC = Nothing
				
		End Function

End Class