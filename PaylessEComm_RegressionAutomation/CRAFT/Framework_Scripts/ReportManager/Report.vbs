Class Report

	'=================================================================================
	' Purpose		: Function to create Run-Time Error Reporting HTML File on the 
	'		  	  				client machine & writes the header to it.
	' Author			: Cognizant Tecnology Solutions
	' Reviewer		:
	'=================================================================================
		Dim timestart,timeend	
		Dim  strTime, strTimeEnd

		Function WriteHTMLHeader(ByRef objEnvironmentVariables)
			
				Dim fso, flReport, strFilePath
				
				strFilePath = objEnvironmentVariables.TempFilePath & "\" & objEnvironmentVariables.TestCaseName & ".html"
				
				Set fso = CreateObject("Scripting.FileSystemObject")
				If fso.FileExists(strFilePath)=FALSE Then
					strFileData = ""
					strFileData = strFileData + "<HTML>" + vbcrlf + vbtab + "<Title>Run-Time Error Reporting</Title>" + vbcrlf
					strFileData = strFileData + + vbtab + "<HEAD></HEAD>" + vbcrlf + vbtab +"<BODY>" + vbcrlf + vbtab + "<HR><Font Align=Center Name=CG Times Size=4 Style=Bold>" + vbcrlf + vbtab 
					Set flReport = fso.CreateTextFile(strFilePath,TRUE)
					flReport.WriteLine strFileData
				Else
					strFileData = ""
					strFileData = strFileData + vbcrlf + vbtab + "</TABLE>"
					strFileData = strFileData + vbcrlf + vbtab + "<BR><BR>"
					strFileData = strFileData + vbcrlf + vbtab + "<HR>"
					Set flReport = fso.OpenTextFile(strFilePath,2)
					flReport.WriteLine strFileData
				End If
				
				strFileData = ""
				
				strFileData = strFileData + "<TABLE frame=vsides Width=100%>" + vbcrlf + vbtab + vbtab + "<tr><th align=center>Execution Date/Time</th>" + vbcrlf + vbtab + vbtab + "<th align=center>Browser Name</th>" + vbcrlf + vbtab + vbtab + "<th align=center>Machine Name</th>" + vbcrlf + vbtab + vbtab + "<th align=center>Test Case Name</th>" + vbcrlf + vbtab + vbtab
				strFileData = strFileData + "<tr><td align=center>" + CStr(Now()) + "</td>" + vbcrlf + vbtab + vbtab + "<td align=center>" + objEnvironmentVariables.BrowserName + "</td>" + vbcrlf + vbtab + vbtab + "<td align=center>" + Environment("LocalHostName") + "</td>" + vbcrlf + vbtab + vbtab + "<td align=center>" + objEnvironmentVariables.TestCaseName + "</td></tr>" + vbcrlf + vbtab + "</TABLE>" + vbcrlf +vbtab + "<HR>"
				strFileData = strFileData + "</Font><br>" + vbcrlf + vbtab + "<font Name=Bodoni MT Style=Normal>" + vbcrlf + vbtab + "<TABLE Width=100% Border=1 bordercolor=#000000>"+ vbcrlf + vbtab
				strFileData = strFileData + "<Caption><h1><Font Name=CG Times Size=4 Style=Bold>The List of Failed Actions</Font></h1></Caption>" + vbcrlf + vbtab + vbtab + "<tr bgcolor=#D3D3D3>" + vbcrlf + vbtab+ vbtab +"<th>Sr.No.</th>" + vbcrlf + vbtab+ vbtab +"<th>Object Name</th>" + vbcrlf + vbtab+ vbtab +"<th>InputValue</th>" + vbcrlf + vbtab + vbtab +"<th>Failed Action</th>" + vbcrlf + vbtab + vbtab +"<th>Error Description</th>" + vbcrlf + vbtab + vbtab +"<th>Sheet Name</th>" + vbcrlf + vbtab +"</tr>" + vbcrlf + vbtab
				
				flReport.WriteLine strFileData
				flReport.Close
				Set flReport = Nothing
				Set fso = Nothing
				
		End Function


		'=================================================================================
		' Purpose		: Function to open the already existing Run-Time Error Reporting
		'		  	  				HTML file whenever the error occurs & writes the details about
		'		    	  			the same error.
		' Author			: Cognizant Technology Solutions
		' Reviewer		:
		'=================================================================================
		Function WriteHTMLErrorLog(ByRef objEnvironmentVariables, ByVal rptDesc, ByVal rptShtNm, ByVal intRowNum, BYVal strInputValue)
			Dim fso, flReport
			Dim rpt_ObjectName,rpt_InputValue,rpt_Action
		
			rpt_ObjectName = DataTable("LabelName", rptShtNm)
			rpt_InputValue = strInputValue
			rpt_Action = DataTable("Action", rptShtNm)
			Test_Path = Environment("TestDir")
			Split_Path=Split(Test_Path,"Framework_Scripts")
			strControlPath=Split_Path(0)
			Test_Script_Sheet=rptShtNm
			
			If rpt_ObjectName = "" Then
				rpt_ObjectName = Space(3)
			End If
			If rpt_InputValue = "" Then
				rpt_InputValue = "&nbsp"
			End If
			If rpt_Action = "" Then
				rpt_Action = Space(3)
			End If
			
			'msgbox objEnvironmentVariables.ScriptPath		
			strFilePath = objEnvironmentVariables.TempFilePath & "\" & objEnvironmentVariables.TestCaseName & ".html"
			
			Set fso=Nothing
			Set fso = CreateObject("Scripting.FileSystemObject")
			Set flReport = fso.OpenTextFile(strFilePath,8)
	
			strFileData = strFileData + "<tr>" + vbcrlf + vbtab+ vbtab +"<td>" + CStr(objEnvironmentVariables.ErrNum) + "</td>" 
			'msgbox strFileData
			strFileData = strFileData + vbcrlf + vbtab + vbtab +"<td>" + rpt_ObjectName + "</td>" + vbcrlf + vbtab+ vbtab 
			'msgbox strFileData
			strFileData = strFileData + "<td>" + rpt_InputValue + "</td>" + vbcrlf + vbtab + vbtab +"<td>" + rpt_Action + "</td>" 
			'msgbox strFileData
			strFileData = strFileData + vbcrlf + vbtab + vbtab +"<td>" + rptDesc + "</td>" + vbcrlf + vbtab + vbtab +"<td>" 
			'msgbox strFileData
			strFileData = strFileData + "Row Number: " + CStr(intRowNum+1) + "<br>" 
			'msgbox strFileData
			strFileData = strFileData + "<a href="&objEnvironmentVariables.ScriptPath&">"+ Test_Script_Sheet + "</a></td>" + vbcrlf + vbtab +"</tr>" + vbcrlf + vbtab
			'msgbox strFileData
			flReport.WriteLine strFileData
			'msgbox strFileData
			flReport.Close
			Set flReport = Nothing
			Set fso = Nothing
		
		End Function
	
		'=================================================================================
		' Purpose		: Function to create Verification Result HTML File on the 
		'		  	  central machine & writes the header to it if it does not exists.
		' Author		: Cognizant Tecnology Solutions
		' Reviewer		:
		'=================================================================================
		Function WriteHTML_Verification(ByRef objEnvironmentVariables)
		
			Dim fso, flReport, strFilePath, flLog
			
			strFilePath = objEnvironmentVariables.TestResultPath & "\" & strGroupName & "_TestResultLog.html"
			'msgbox strFilePath
			strLogFilePath = objEnvironmentVariables.TempFilePath & "\" & objEnvironmentVariables.TestCaseName & ".log"
			'msgbox strLogFilePath
			
			strTime = Left(MonthName(Month(Date())),3) & " " & Day(Date()) & ", " & Year(Date()) & " " & Time()
			
			Set fso = CreateObject("Scripting.FileSystemObject")
			If fso.FileExists(strFilePath)=FALSE Then
	
				strFileData = strFileData + "<html><head><title>Validated Result Log</title></head>"
				strFileData = strFileData + "<br><b><font face=Arial size=4 color=#3366FF>" + objEnvironmentVariables.ProjectName + " Test Case Details</font></b>"
				'strFileData = strFileData + "<br><br><font face=Arial size=2>For Test Cases with results: <b>"
				strFileData = strFileData + "<br><br>"	
				'strFileData = strFileData + "<font color=#FF0000>PASS, FAIL.</font></b></font><br><br>"
				strFileData = strFileData + "<br><br>"
				strFileData = strFileData + "<table border=1 width=100% cellspacing=0 cellpadding=0 bordercolorlight=#3366FF bgcolor=#CCFFFF id=table1 style=font-family: Arial; font-size: 10px>"
				strFileData = strFileData + "<tr><th bordercolorlight=#6699FF bgcolor=#66CCFF align=center width=254>"
				strFileData = strFileData + "<font face=Arial size=2>Test case Names</font></th><th bordercolorlight=#6699FF bgcolor=#66CCFF align=center>"
				strFileData = strFileData + "<font face=Arial size=2>Results</font></th><th bordercolorlight=#6699FF bgcolor=#66CCFF align=center width=118>"
				strFileData = strFileData + "<font face=Arial size=2>Test Cycles</font></th><th bordercolorlight=#6699FF bgcolor=#66CCFF align=center width=163>"
				strFileData = strFileData + "<font face=Arial size=2>Product Versions</font></th></tr>"
	
				Set flReport = fso.CreateTextFile(strFilePath,TRUE)
				flReport.Write strFileData
			
			Else
				
				Set flReport = fso.OpenTextFile(strFilePath,8)
	
			End If
	
			strFileData = ""
			Set flLog = fso.OpenTextFile(strLogFilePath,1)
	
			strFileData = strFileData & "<tr><td bgcolor=#CCFFFF width=254><font face=Arial size=2>"
			strFileData = strFileData & objEnvironmentVariables.TestCaseName & "</font></td><td bgcolor=#CCFFFF><font face=Arial size=2>"
			'strFileData = strFileData & "Run by " & objEnvironmentVariables.RunBy & " on " & strTime & ": "		
			strFileData = strFileData & flLog.ReadAll
			strFileData = strFileData & "</td><td bgcolor=#CCFFFF width=118>"
			strFileData = strFileData & "<font face=Arial size=2>" & objEnvironmentVariables.TestCycle & "</font></td><td bgcolor=#CCFFFF width=163><font face=Arial size=2>"
			strFileData = strFileData & objEnvironmentVariables.Build & "</font></td></tr>"
			
			
			flReport.Write strFileData
	
			strFileData = ""
			'flReport.Write flLog.ReadAll    
			flReport.Close			
			
			flLog.Close
			Set flLog = fso.GetFile(strLogFilePath)	
			flLog.Delete(TRUE)	
				
			
			Set flLog = Nothing
			Set flReport = Nothing
			Set fso = Nothing
			
		End Function
	
		'=================================================================================
		' Purpose		: Function to open the already existing Run-Time Error Reporting
		'		  	  HTML file whenever the error occurs & writes the details about
		'			  the same error.
		' Author		: Cognizant Tecnology Solutions
		' Reviewer		:
		'=================================================================================
		Function WriteHTMLResultLog(ByRef objEnvironmentVariables, ByVal rptDesc, ByVal intPassFail)
		
			Dim fso, flReport
	
			'Desc: To handle QC integration	
	
			Dim clsQCIntegration
			Set clsQCIntegration = New QCIntegration_Module
	
			strTime = Left(MonthName(Month(Date())),3) & " " & Day(Date()) & ", " & Year(Date()) & " " & Time()	
			strFilePath = objEnvironmentVariables.TempFilePath & "\" & objEnvironmentVariables.TestCaseName & ".log"		
			Set fso = CreateObject("Scripting.FileSystemObject")
			
			If fso.FileExists(strFilePath) = TRUE Then
				Set flReport = fso.OpenTextFile(strFilePath,8)
			Else
				Set flReport = fso.CreateTextFile(strFilePath,TRUE)
			End If			   
			if intPassFail = "START" then 
				strTime = Now
				'timestart=hour(strTime)*3600+minute(strTime)*60+second(strTime)
				timestart=Now
				strFileData = strFileData & "Run by " & objEnvironmentVariables.RunBy & " on " & strTime & ": "
	
				If Instr(rptDesc,"Iteration")=0 then
					strFileData=""
				End If
				'strFileData = strFileData & "<br>"& "<Font Color=#008000>" & rptDesc & "</Font>"			
				strFileData = strFileData & "<br><B>"& "<Font Color=#A80C78>" & rptDesc & "</Font></B>"			
				
			'Teekam 24 March
			ElseIf intPassFail = "NEW" then                                     
				'strFileData = strFileData & "<br><hr color= blue>"& "<Font Color=#A80C78>" & rptDesc & "</Font>"
				strFileData = strFileData & "<br><hr><B>"& "<Font Color=#A80C78>" & rptDesc & "</Font></B>"
			
			Elseif intPassFail = "END" then 
				strTimeEnd = Now
				'timeend=hour(strTimeEnd)*3600+minute(strTimeEnd)*60+second(strTimeEnd)
				timeend=Now
	
				'diff=timeend-timestart			
				diff=DateDiff ( "s", timestart , timeend )
	
				hours=diff\3600
				hours1=diff mod 3600
				minutes=hours1\60
				minutes1=hours1 mod 60
				seconds=minutes1
				if len(hours)<2 then
					hours="0"&hours
				end if
				if len(minutes)<2 then
					minutes="0"&minutes
				end if
				if len(seconds)<2 then
					seconds="0"&seconds
				end if
				
				timedifference=hours &":"& minutes &":"& seconds
				strFileData = strFileData & "<br>"&"Execution completed at &nbsp;"&strTimeEnd
				strFileData = strFileData & "<br>"& "<table border=1 width=100% cellspacing=0 cellpadding=0 bordercolorlight=#3366FF><Tr><Td><b><Font face = Arial Size =2 Color=black>"&"Execution Time =&nbsp;"&"</FONT></b><font face = Arial size =2 color=blue>"& timedifference &"</FONT><BR> <Font Color=blue>" & rptDesc & "Overall Result &nbsp;"& "</Font>" 					
				if objEnvironmentVariables.TestCaseStatus = True then 
			
					strFileData = strFileData & "<Font Color=#008000> " & "PASS"  &  "</Font></Td></Tr></Table>"
				Else
					strFileData = strFileData & "<Font Color=red> " & "FAIL"  &  "</Font></Td></Tr></Table>"
				End if 
			
			ElseIf intPassFail = 0 Then
	
				strFileData = strFileData & "<br>" & "<a href=" & objEnvironmentVariables.ScreenShotPath & "><Font Color=red>FAIL</a></Font>&nbsp;"	
				
				strFileData = strFileData & rptDesc
				
				'Desc: To handle QC integration and To add the test result in Test Result excel file
				
				
				'MsgBox "objEnvironmentVariables.TestStepCount=" & objEnvironmentVariables.TestStepCount
				StepName = "Step " & objEnvironmentVariables.TestStepCount
				'MsgBox iRowCnt
				'MsgBox StepName
				'MsgBox "Calling to write data in excel"
				'MsgBox objEnvironmentVariables.TestCaseName & "," & StepsName & "," & rptDesc
				'MsgBox "Resutl file nanme" & clsEnvironmentVariables.TestResultExcelFile
				strQCDesc= objEnvironmentVariables.ActionLabelName & ":" & objEnvironmentVariables.TestStepAction
				strExpectedResult = "Not expected : " & rptDesc 
				If clsEnvironmentVariables.QCUpdation Then
					clsQCIntegration.WriteTestResultInExcel objEnvironmentVariables.TestCaseNameFromQC, StepName ,strQCDesc,strExpectedResult, rptDesc,"FAILED",clsEnvironmentVariables.UseExcelObject,clsEnvironmentVariables.TestResultExcelFile			
				End If
	
			ElseIf intPassFail = 2 Then
				If UCase(objEnvironmentVariables.TestStepAction) = "VERIFYSCREEN" Then 
					strFileData = strFileData & "<br>" & "<a href=" & objEnvironmentVariables.ScreenShotPath & "><Font Color=#008000>"&"DONE&nbsp;"&"</a></Font>"		
				Elseif UCase(objEnvironmentVariables.TestStepAction) = "SCREENSHOT"  Then
					strFileData = strFileData & "<br>" & "<a href=" & objEnvironmentVariables.ScreenShotPath & "><Font Color=#A80C78>"&"DONE&nbsp;"&"</a></Font>"				
				Else
					strFileData = strFileData & "<br>" & "<Font Color=#008000>"&"DONE&nbsp;"&"</Font>"			
				End If 			
				
				strFileData = strFileData & rptDesc	
				
				'Desc: To handle QC integration and To add the test result in Test Result excel file
							
				'MsgBox "objEnvironmentVariables.TestStepCount=" & objEnvironmentVariables.TestStepCount
				StepName = "Step " & objEnvironmentVariables.TestStepCount
				'MsgBox iRowCnt
				'MsgBox StepName
				'MsgBox "Calling to write data in excel"
				'MsgBox objEnvironmentVariables.TestCaseName & "," & StepsName & "," & rptDesc
				'MsgBox "Resutl file nanme" & clsEnvironmentVariables.TestResultExcelFile
				strQCDesc= objEnvironmentVariables.ActionLabelName & ":" & objEnvironmentVariables.TestStepAction
				strExpectedResult = rptDesc
				If clsEnvironmentVariables.QCUpdation Then
					clsQCIntegration.WriteTestResultInExcel objEnvironmentVariables.TestCaseNameFromQC, StepName ,strQCDesc,strExpectedResult, rptDesc,"PASSED",clsEnvironmentVariables.UseExcelObject,clsEnvironmentVariables.TestResultExcelFile
				End If
			Else
				strFileData = strFileData & "<br>" & "<Font Color=#008000>PASS </Font>"
				
				strFileData = strFileData & rptDesc	
	
				'Desc: To handle QC integration
				
				'MsgBox "objEnvironmentVariables.TestStepCount=" & objEnvironmentVariables.TestStepCount
				StepName = "Step " & objEnvironmentVariables.TestStepCount
				'MsgBox iRowCnt
				'MsgBox StepName
				'MsgBox "Calling to write data in excel"
				'MsgBox objEnvironmentVariables.TestCaseName & "," & StepsName & "," & rptDesc
				strQCDesc= objEnvironmentVariables.TestStepAction & " : " & objEnvironmentVariables.ActionLabelName
				strExpectedResult = rptDesc
				If clsEnvironmentVariables.QCUpdation Then
					clsQCIntegration.WriteTestResultInExcel objEnvironmentVariables.TestCaseNameFromQC, StepName ,strQCDesc,strExpectedResult, rptDesc,"PASSED",clsEnvironmentVariables.UseExcelObject,clsEnvironmentVariables.TestResultExcelFile
				End If
			End If
	
			flReport.Write strFileData
			
			flReport.Close
			Set flReport = Nothing
			Set fso = Nothing
		
		End Function
	
	
		'=================================================================================
		' Purpose		: Function to create the summary report.
		' Author		: Cognizant Tecnology Solutions
		' Reviewer		:
		'=================================================================================
		Function Write_Summary_Header(ByVal Iteration_Count, ByRef objEnvironmentVariables)
	
			Dim fso, MyFile
			strFilename = Environment.value("TestName")
			Set fso = CreateObject("Scripting.FileSystemObject")
			'Test_Path = Environment("TestDir")
			'Split_Path=Split(Test_Path,"Framework_Scripts")
			strControlPath=objEnvironmentVariables.CntrlPath
			'msgbox strControlPath
			Set MyFile = fso.CreateTextFile(strControlPath & "Framework_Scripts\Reports\"&objEnvironmentVariables.ProjectName&"\Summary\" & strGroupName & "_" & strFilename & ".html", True)
			MyFile.Close
				Set MyFile = fso.OpenTextFile(strControlPath & "Framework_Scripts\Reports\"&objEnvironmentVariables.ProjectName&"\Summary\" & strGroupName & "_" & strFilename & ".html",8)
			Myfile.Writeline("<html>")
				Myfile.Writeline("<head>")
			Myfile.Writeline("<meta http-equiv=" & "Content-Language" & "content=" & "en-us>")
			Myfile.Writeline("<meta http-equiv="& "Content-Type" & "content=" & "text/html; charset=windows-1252" & ">")
			Myfile.Writeline("<title>ECOM Automation Execution Summary Report</title>")
			Myfile.Writeline("</head>")
			Myfile.Writeline("<body>")
			Myfile.Writeline("<blockquote>")
			Myfile.Writeline("<p>")
			Myfile.Writeline("&nbsp;")
			Myfile.Writeline("</p>")
			Myfile.Writeline("</blockquote>")
			Myfile.Writeline("<p align=left>&nbsp;&nbsp;")
			Myfile.Writeline("<blockquote>")
			Myfile.Writeline("<blockquote>")
			Myfile.Writeline("<blockquote>")
			Myfile.Writeline("</p>")
			Myfile.Writeline("<table border=2 bordercolor=" & "#000000 id=table1 width=844 height=31 bordercolorlight=" & "#000000>")
			Myfile.Writeline("<tr>")
			Myfile.Writeline("<td COLSPAN =" & Iteration_Count+1 & " bgcolor = #1E90FF>")
			Myfile.Writeline("<p><img src=" & strControlPath & "Framework_Scripts\Reports\"&objEnvironmentVariables.ProjectName&"\Summary\CTSLogo.BMP align =left><img src=" & strControlPath & "Framework_Scripts\Reports\"&objEnvironmentVariables.ProjectName&"\Summary\PayLessLogo.BMP align =right></p><p align=center><font color=#000000 size=4 face= "& chr(34)&"Copperplate Gothic Bold"&chr(34) & ">&nbsp;PAYLESS_ECOMM-Automation Execution Summary-" & strGroupName &" </font><font face= " & chr(34)&"Copperplate Gothic Bold"&chr(34) & "></font> </p>")
			Myfile.Writeline("</td>")
			Myfile.Writeline("</tr>")
			Myfile.Writeline("<tr>")
			Myfile.Writeline("<td COLSPAN = " & Iteration_Count +1& " bgcolor = #87CEFA>")
			Myfile.Writeline("<p align=justify><b><font color=#000000 size=2 face= Verdana>"& "&nbsp;"& "DATE :&nbsp;&nbsp;" &  now  & "&nbsp;&nbsp;" & "<a href=" & strControlPath & "Framework_Scripts\Reports\"&objEnvironmentVariables.ProjectName&"\Test_Results_Log\" & strGroupName & "_TestResultLog.html>View detail report</a>")
			Myfile.Writeline("</td>")
			Myfile.Writeline("</tr>")
			Myfile.Writeline("<tr bgcolor=#F08080>")
			Myfile.Writeline("<td width=300")
			Myfile.Writeline("<p align=" & "center><b><font color = white face=" & "Arial Narrow " & "size=" & "2" & ">" & "Test Case Name</b></td>")
			Myfile.Writeline("<td width=300")
			For Iteration=1 to Iteration_Count
				Myfile.Writeline("<p align=" & "center" & ">" & "<b><font color = white face=" & "Arial Narrow " & "size=" & "2" & ">" & "Iteration&nbsp;" & Iteration & "</b></td>")
				if Iteration<>Iteration_Count Then
					Myfile.Writeline("<td width=300")
				End If
			Next
			Myfile.Writeline("</blockquote>")
			Myfile.Writeline("</body>")
			Myfile.Writeline("</html>")
			MyFile.Close
	
		End Function
	
		'=================================================================================
		' Purpose		: Function to add detail in summary report .
		' Author		: Cognizant Tecnology Solutions
		' Reviewer		:
		'=================================================================================
		Function Add_Results_Summary(ByVal Iteration_Count, ByRef objEnvironmentVariables)
			Dim vPassCtr(), vFailCtr(), vNRCtr()
			ReDim vPassCtr(Iteration_Count+1), vFailCtr(Iteration_Count+1), vNRCtr(Iteration_Count+1)
			strFilename = Environment.value("TestName")
			Set fso = CreateObject("Scripting.FileSystemObject")
			Set Myfile = fso.OpenTextFile(strControlPath & "Framework_Scripts\Reports\"&objEnvironmentVariables.ProjectName&"\Summary\" & strGroupName & "_" & strFilename & ".html",8)
			strRowCount = intRowCountMaster		
			For i = 1 to strRowCount
				Datatable.GetSheet("Master").SetCurrentRow(i)
				strTestCase = Datatable("TestCase_Name","Master")
				Myfile.Writeline("<tr bgcolor = #FDEEF4 >")
				Myfile.Writeline("<td width=300>")
				Myfile.Writeline("<p align=" & "left><font face=" & "Verdana " & "size=" & "2" & ">" & strTestCase & "</a></td>")
				For ColumnCount=1 to Iteration_Count
					res=Datatable("Iteration_" & ColumnCount,"Master")
					Myfile.Writeline("<td width=300" & "nowrap>")
					if UCase(res) = UCase("True") then
						vPassCtr(ColumnCount) = vPassCtr(ColumnCount) + 1
					elseif UCase(res) = UCase("False") then
						vFailCtr(ColumnCount) = vFailCtr(ColumnCount) + 1
					else
						vNRCtr(ColumnCount) = vNRCtr(ColumnCount) + 1
					End If
					if UCase(res) = UCase("True") then
						Myfile.Writeline("<p align=" & "justify" & ">" & "<b><font face=" & "Verdana " & "size=" & "2" & " color=" & "#008000" & ">" & "PASS" & "</font></b>" & "</td>")
					elseif UCase(res) = UCase("False") then
						Myfile.Writeline("<p align=" & "justify" & ">" & "<b><font face=" & "Verdana " & "size=" & "2" & " color=" & "red >" & "FAIL" & "</font></b>" & "</td>")
					else
						Myfile.Writeline("<p align=" & "justify" & ">" & "<b><font face=" & "Verdana " & "size=" & "2" & " color=" & "#000080" & ">" & "NO RUN" & "</font></b>" & "</td>")
					End If
				Next
			next
			For ColumnCount=1 to Iteration_Count
				if vPassCtr(ColumnCount) = "" then
					vPassCtr(ColumnCount) = 0
				End If	
				if vFailCtr(ColumnCount) = "" then
					vFailCtr(ColumnCount) = 0
				End If
				if vNRCtr(ColumnCount) = "" then
					vNRCtr(ColumnCount) = 0
				End If
			Next
			Myfile.Writeline("<tr bgcolor = #FDEEF4>")
			Myfile.Writeline("<td COLSPAN = " & Iteration_Count+1 & ">")
			Myfile.Writeline("<p align=justify><b><font color=#000080 size=2 face= Verdana>"& "&nbsp;"& "Total Count:&nbsp;&nbsp;" &  strRowCount  & "&nbsp;")
			Myfile.Writeline("</td>")
			Myfile.Writeline("</tr>")
			Myfile.Writeline("<tr bgcolor = #FDEEF4>")
			Myfile.Writeline("<td width = 300>")
			Myfile.Writeline("<p align=justify><b><font color=#000080 size=2 face= Verdana>"& "&nbsp;"& "Total Passed:&nbsp;&nbsp;")
			Myfile.Writeline("</td>")
			For ColumnCount=1 to Iteration_Count
				Myfile.Writeline("<td width = 300>")
				Myfile.Writeline("<p align=justify><b><font color=#000080 size=2 face= Verdana>"& "&nbsp;"& vPassCtr(ColumnCount)  & "&nbsp;")
				Myfile.Writeline("</td>")
			Next
			Myfile.Writeline("</tr>")
			Myfile.Writeline("<tr bgcolor = #FDEEF4>")
			Myfile.Writeline("<td width=300>")
			Myfile.Writeline("<p align=justify><b><font color=#000080 size=2 face= Verdana>"& "&nbsp;"& "Total Failed:&nbsp;&nbsp;")
			Myfile.Writeline("</td>")
			For ColumnCount=1 to Iteration_Count
				Myfile.Writeline("<td width=300>")
				Myfile.Writeline("<p align=justify><b><font color=#000080 size=2 face= Verdana>"& "&nbsp;"& vFailCtr(ColumnCount)  & "&nbsp;")
				Myfile.Writeline("</td>")
			Next
			Myfile.Writeline("</tr>")
			Myfile.Writeline("<tr bgcolor = #FDEEF4>")
			Myfile.Writeline("<td width=300>")
			Myfile.Writeline("<p align=justify><b><font color=#000080 size=2 face= Verdana>"& "&nbsp;"& "Total Not Run:&nbsp;&nbsp;")
			Myfile.Writeline("</td>")
			For ColumnCount=1 to Iteration_Count
				Myfile.Writeline("<td width=300>")
				Myfile.Writeline("<p align=justify><b><font color=#000080 size=2 face= Verdana>"& "&nbsp;"& vNRCtr(ColumnCount)  & "&nbsp;")
				Myfile.Writeline("</td>")
			Next
			Myfile.Writeline("</tr>")
			Myfile.Writeline("</table>")
			Myfile.Close			
			
		End Function

End Class