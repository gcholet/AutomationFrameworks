	'******************************************************************************************************************************************
	'# Functionname: cf_closeAllBrowsers()
	'# Description: Function is used to close all the browsers
	'#
	'# Parameters:
	'# Input Parameters:NA	
	'#
	'# OutPut Parameters: NA	
	'# 
	'# Usage:
	'# The usage of this procedure is
	'# >Call cf_closeAllBrowsers()
	'******************************************************************************************************************************************
	Public Sub cf_closeAllBrowsers()
		'Updated for handling the Medipad settings
			Dim objDesc,numOfBrowsers,browserElements
			Set objDesc = Description.Create()
			objDesc("micClass").Value = "Browser"
			Set browserElements = Desktop.ChildObjects(objDesc)
			numOfBrowsers = browserElements.Count
			For intCnt = 0 To numOfBrowsers - 1
				If (InStr(browserElements(intCnt).GetROProperty("title"),"Quality Center") = 0 And InStr(browserElements(intCnt).GetROProperty("title"),"WebEx") = 0 And InStr(browserElements(intCnt).GetROProperty("title"),"Microsoft Office Live Meeting") = 0) And Not IsEmpty(browserElements(intCnt).GetROProperty("title")) Then
							 browserElements(intCnt).close			
				End If
			Next
			Set browserElements=Nothing
			Set objDesc=Nothing
			'	Dim strSQL,ProcColl,oWMIService
			'	Set oWMIService = Nothing
			'	Set ProcColl = Nothing
			'	Set oElem = Nothing
			'	strSQL = "Select * From Win32_Process Where Name = 'iexplore.exe'"
			'	Set oWMIService = GetObject("winmgmts:\\.\root\cimv2")
			'	Set ProcColl = oWMIService.ExecQuery(strSQL)
			'	For Each oElem in ProcColl
			'		oElem.Terminate
			'	Next
			'	Set oWMIService = Nothing
			'	Set ProcColl = Nothing
			'	Set oElem = Nothing
	End Sub
	
	'******************************************************************************************************************************************
	'# Functionname: cf_getDateFormat()
	'# Description: Function used to get different date formats
	'#
	'# Parameters:
	'# Input Parameters:NA	
	'#
	'# OutPut Parameters: NA	
	'# 
	'# Usage:
	'# The usage of this procedure is
	'# >Call cf_getDateFormat(strDate,format)
	'******************************************************************************************************************************************

Public Function cf_getDateFormat(strDate,strFormat)
  Dim d,m,y,a
  d = DatePart("D",strDate)
  m = DatePart("M",strDate)
  y = DatePart("YYYY",strDate)
  s = DatePart("s",strDate)

  If len(d) < 2 then
   d = "0" & d
  end if
  
  if len(m) < 2 then
   m = "0" & m
  end if

  if len(s) < 2 then
   s = "0" & s
  end if
  
		  Select Case strFormat
			   Case "yyyy/mm/dd"
				cf_getDatestrFormat = y & "/" & m & "/" & d
			   Case "yy/mm/dd"
				cf_getDateFormat = right(y,2) & "/" & m & "/" & d
			   Case "dd/mm/yy"
				cf_getDateFormat =  d & "/" & m & "/" &  right(y,2)
			   Case "dd/mm/yyyy"
				cf_getDateFormat =  d & "/" & m & "/" &  y
			   Case "yyyy-mm-dd"
				cf_getDateFormat = y & "-" & m & "-" & d
			   Case "yy-mm-dd"
				cf_getDateFormat = right(y,2) & "-" & m & "-" & d
			   Case "dd-mm-yy"
				cf_getDateFormat =  d & "-" & m & "-" &  right(y,2)
			   Case "dd-mm-yyyy"
				cf_getDateFormat =  d & "-" & m & "-" &  y
			   Case "ddmmyyyy"
				cf_getDateFormat =  d & m & y
			   Case "ddmmyy"
				cf_getDateFormat =  d & m & right(y,2)
			   Case "mmddyy"
				cf_getDateFormat =  m & d & right(y,2)
			   Case "mm/dd/yyyy"
				cf_getDateFormat =  m & "/" & d & "/" & y 
			   Case "mmddyyyy"
				cf_getDateFormat =  m & d & y
			   Case "yyyymmdd"
				cf_getDateFormat = y &  m & d
			   Case "yymmdd"
				cf_getDateFormat = right(y,2) & m & d
			   Case "yyyy"
				cf_getDateFormat = y
			   Case "Short"
				cf_getDateFormat = formatdatetime(strDate,vbShortDate)
			   Case "Long"
				cf_getDateFormat = formatdatetime(strDate,vbLongDate)
			   Case "dd-Month-yyyy"
				m = MonthName (m,True)
				cf_getDateFormat = d & "-" & m & "-" & y
				Case "dd Month yyyy"
				m = MonthName (m,True)
				cf_getDateFormat = d & " " & m & " " & y
			   Case "dd-Month-yy"
				m = MonthName (m,True)
				cf_getDateFormat = d & "-" & m & "-" & right(y,2)
			   Case "DayName"
				cf_getDateFormat = WeekDayName(Weekday(strDate),False)
			   Case "DayNameAbbr"
				cf_getDateFormat = WeekDayName(Weekday(strDate),True)
			   Case "SiteDate"
				cf_getDateFormat = WeekDayName(Weekday(strDate),False) & ", " & DateSuffix(DatePart("D",strDate)) & " of " & MonthName(m,false) & ", " & fixDate(strDate,"yyyy")
			   Case "Stamp"
				cf_getDateFormat = fixdate(Now(),"yyyymmdd") & fixTime(Now(),"Stamp")
				Case "dd/mm/yyyy/hh:mm"
                cf_getDateFormat =  d & "/" & m & "/" &  y & " " &  FormatDateTime(time, 4) 
				Case "dd Month yyyy hh:mm"
				m = MonthName (m,True)
                cf_getDateFormat =  d & " " & m & " " &  y & " " &  FormatDateTime(time, 4) 
                Case "dd/mm/yyyy/hh:mm:ss"
                cf_getDateFormat =  d & "/" & m & "/" &  y & " " &  FormatDateTime(time, 4) &":"&s
				Case "mm/dd/yyyy hh:mm:ss"
                cf_getDateFormat =  m & "/" & d & "/" &  y & " " &  FormatDateTime(time, 4) &":"&s
				Case "yyyy-mm-dd/hh:mm:ss"
				Case "yyyymmddhhmmss"
					cf_getDateFormat =  y  & m  & d & Right("0"& Hour(Now), 2) & Right("0"& Minute(Now), 2) & Right("0"& Second(Now), 2)
				Case Else
					cf_getDateFormat =  d & "/" & m & "/" &  y
		  End Select
End Function
'******************************************************************************************************************************************
	'# Functionname: CF_sendKeys(ByVal strKey)
	'# Description: Function is used to enter the keyboard input
	'#Author:		Madhubabu
	'#
	'# Parameters:
	'# Input Parameters:NA	
	'# strKey : Keyboard input
	'#
	'# OutPut Parameters: NA	
	'# 
	'# Usage:
	'# The usage of this function is
	'# >Call CF_sendKeys(micCtrlUp)																  
	'#>Call CF_sendKeys("Allergy")
'******************************************************************************************************************************************
	Public Function CF_sendKeys(ByVal strMethod, ByVal strScreenType,ByVal strKey)
		Dim objPar, oWshShell, oMyDeviceReplay
		
		Select Case (UCase(strMethod))
			Case "METHOD-A"
				If Trim(Lcase(strScreenType))=Trim(LCase("Window")) Then
					Set objPar=Window("regexpwndclass:=Internet Explorer_TridentDlgFrame","index:=0").WinObject("regexpwndclass:=Internet Explorer_Server")
				Else
					Set objPar=Window("regexpwndtitle:=Windows Internet Explorer.*","index:=0").WinObject("regexpwndclass:=Internet Explorer_Server")
				End If
				
				If objPar.Exist then
					objPar.Type strKey
					CF_sendKeys=True
				Else
					CF_sendKeys=False
				End If
				
			Case "METHOD-B"
				Set oWshShell = CreateObject("WScript.Shell")
				oWshShell.SendKeys strKey
				
			Case "METHOD-C"
				Set oMyDeviceReplay = CreateObject("Mercury.DeviceReplay")
				oMyDeviceReplay.SendString strKey
		End Select
		
		'Destroy Variables
		Set objPar = Nothing
		Set oWshShell = Nothing
	End Function

'******************************************************************************************************************************************
	'# Functionname: CF_syncWait(ByVal intSyncTime)
	'# Description: Function is used to sync the App with given sync time
	'#Author:		Madhubabu
	'#
	'# Parameters:
	'# Input Parameters:NA	
	'# strKey : Keyboard input
	'#
	'# OutPut Parameters: NA	
	'# 
	'# Usage:
	'# The usage of this function is
	'# >Call CF_syncWait(pubSync_Medium)
'	***************************************************************************************************************************************
	Public Function CF_syncWait(ByVal intSyncTime)
	   Wait intSyncTime
	End Function

'******************************************************************************************************************************************
	'# Functionname: CF_sDynamicPopup(ByVal iWaitPeriod, ByVal iWaitFrequency)
	'# Description: Function is used to display Popup to User with Timer
	'#Author:		Govardhan
	'# Parameters:
	'# Input Parameters:NA	
	'# iWaitPeriod : Number of instances the pop-up appears on screen
	'# iWaitFrequency : Time after which Pop-up closes mentioned at Header level
	'# Usage:The usage of this function is
	'# >Call CF_sDynamicPopup(20, 1)
'	***************************************************************************************************************************************
   Sub CF_sDynamicPopup (ByVal iWaitPeriod, ByVal iWaitFrequency)
		Dim oWshShell, BtnCode
		If StrComp(Environment.Value("DynamicPopup"), "Y", 1) = 0 Then
			If IsNumeric(iWaitPeriod) And IsNumeric(iWaitFrequency) Then
				Set oWshShell = CreateObject("WScript.Shell")
				While iWaitPeriod > 0
					iBtnCode = oWshShell.Popup("Popup will autoclose after appearing "& iWaitPeriod &" times", iWaitFrequency, "Count Down Timer (Wait Frequency - "& iWaitFrequency &" Second(s))" , 1 + 64)
					If iBtnCode = 2 Then
						iWaitPeriod = 0	
					End If
					iWaitPeriod = iWaitPeriod - 1
				Wend
				Set oWshShell = Nothing
			Else
				Call htmlReport_reporterExecutionStatus(micFail, "Invalid Wait Time period" & iWaitPeriod & " (OR) Invalid Wait Time Frequency" & iWaitFrequency & ", NOT as expected")
			End If
		Else
			Wait (iWaitPeriod * iWaitFrequency)
		End If
	End Sub

'  ******************************************************************************************************************************************
	'# Functionname: CF_compareContent(ByVal strSourceFileName,ByVal strDestinationFilename)
	'# Description: Function is used to Compare the source and destination files
	'#Author:		Madhubabu
	'#
	'# Parameters:
	'# Input Parameters:
	'# strSourceFileName : Path of the source file
	'# strDestinationFilename : Path of the Destination file
	'# OutPut Parameters: True, if the source and destination file content matches
	'#                                         False,  if the source and destination file content not matches	
	'# 
	'# Usage:
	'# The usage of this function is
	'# >Call CF_compareContent(strSourceFileName,strDestinationFilename)
'	***************************************************************************************************************************************

	Public Function CF_compareContent(ByVal strSourceFileName,ByVal strDestinationFilename)
			Const ForReading = 1
			pubstrStepName="Verify the Base and Actual content of Narrative Content"
			Dim objSourceFile,objDestinationFile,strDestinationData,strSourceData
			blnFlag=True
			Set objFSO = CreateObject("Scripting.FileSystemObject")
			Set objSourceFile = ObjFSOReport.OpenTextFile(strSourceFileName, ForReading)
			Set objDestinationFile = ObjFSOReport.OpenTextFile(strDestinationFilename, ForReading)		
			Do Until objDestinationFile.AtEndOfStream and objSourceFile.AtEndOfstream
				strDestinationData = objDestinationFile.ReadLine
				strSourceData= objSourceFile.ReadLine
				If  strSourceData="" and strDestinationData="" Then
					strSourceData="Space"
					strDestinationData=strSourceData
				End If
				If Instr(strDestinationData,strSourceData)=0 Then
					blnFlag=False
					Call htmlReport_reporterExecutionStatus(micFail,"Base content:  '"& strSourceData &"' not matches with the Actual Content: '"&strDestinationData &"'")					
				End If
			Loop
			objSourceFile.Close	
			objDestinationFile.Close
			If blnFlag=True Then
				Call htmlReport_reporterExecutionStatus(micPass,"Base and Actual Content matches succesfully and Data is avaiable in the path '"& strSourceFileName&"'")	
				CF_compareContent=True
			 Else
				CF_compareContent=False
			End If
	End Function

	'******************************************************************************************************************************************
	'# Functionname: CF_VerifyLineInTextFile (ByVal strSourceFilePathName, ByVal strRowPos, ByVal strVerifyCode)
	'# Description: The function is useful to perform the connectivity to XML and create the valid Record set
	'# Parameters:
	'# Input Parameters:	
	'# strFilePathName	 - Valid Template Path Name
	'# strRowPos 			- Valid Row Position / Line Starting with
	'# strDBQuery		 - Valid Line Text  to compare
	'# OutPut Parameters: Complete File Path including the Name of the File
	'# Usage:
	'# The usage of this procedure is
	'# >Call CF_VerifyLineInTextFile("<File Template Location>",1, "HDR|TEST|")
	'******************************************************************************************************************************************
    Public Function CF_VerifyLineInTextFile(ByVal strSourceFilePathName, ByVal iRowPos, ByVal strVerifyCode) ' <@as> Bool
		Dim strFuncName, objSourceFile, strSourceData, iSkip

		Const ForReading = 1
		strFuncName = "Functiona call : CF_VerifyLineInTextFile(), "

		If IsNumeric(iRowPos) And iRowPos > 0 Then
			Set objFSO = CreateObject("Scripting.FileSystemObject")
			Set objSourceFile = ObjFSO.OpenTextFile(strSourceFilePathName, ForReading)

			For iSkip = 1 To iRowPos - 1
				objSourceFile.skipline
			Next
			strSourceData= objSourceFile.ReadLine
	
			If Instr(UCase(Trim(strVerifyCode)), UCase(Trim(strSourceData))) = 0 Then
				Call htmlReport_reporterExecutionStatus (micFail, strFuncName &" Verifying Text "& strSourceData &" at Line : "& iRowPos &" in File - "& strSourceFilePathName &" doesn't match with the Input textstream "& strVerifyCode &", Not as Expected")
				CF_VerifyLineInTextFile = False
			Else
				Call htmlReport_reporterExecutionStatus (micPass, strFuncName &" Verifying Text "& strSourceData &" at Line : "& iRowPos &" in File - "& strSourceFilePathName &" matches with the Input textstream "& strVerifyCode &", As Expected")
				CF_VerifyLineInTextFile = True
			End If
			objSourceFile.Close	
		Else
			Call htmlReport_reporterExecutionStatus (micFail, strFuncName &" Verifying Input supplied : "& iRowPos &" for File - "& strSourceFilePathName &" is not a Valid Line Number, NOT As Expected")
		End If

		'Release Variables
		Set objFSO = Nothing
		Set objSourceFile = Nothing
	End Function

'  ******************************************************************************************************************************************
	'# Functionname: CF_createTextFile(ByVal strFilePath,ByVal strContent)
	'# Description: Function is used to create a file with given set of data and will save in given path
	'#Author:		Madhubabu
	'#
	'# Parameters:
	'# Input Parameters:
	'# strFilePath : Path of the file
	'# strContent :Content of the data to save
	'# OutPut Parameters: True, if the source and destination file content matches
	'#                               False,  if the source and destination file content not matches	
	'# 
	'# Usage:
	'# The usage of this function is
	'# >Call CF_createTextFile(strTemp,"Madhu"&Vbnewline&"Sai")
'	***************************************************************************************************************************************
Public Function CF_createTextFile(ByVal strFilePath,ByVal strContent)	
	Set objOutFile = ObjFSOReport.CreateTextFile(strFilePath,True)
	objOutFile.Write(strContent)
	objOutFile.Close
End Function
'  **************************************************************************************************************************************************************************************************************************************************************************************************
	'# Functionname: CF_sendEmail(ByVal strEmailToList,ByVal strEmailCCList,ByVal strSubject,ByVal strBody,ByVal strAttachementPath)
	'# Description: Function is used to send a email with attachement
	'#Author:		Madhubabu
	'#
	'# Parameters:
	'# Input Parameters:
	'# strEmailToList :  List of email addresses, TO
	'# strEmailCCList :List of email addresses, CC
	'# strSubject :  Subject of the email
	'# strBody :Body of the Email
	'# strAttachementPath :Attachement folder path to send along with email
	'# OutPut Parameters: NA
	'# 
	'# Usage:
	'# The usage of this function is
	'# >Call CF_sendEmail("Madhubabuv.kopparaju@optum.com","","CareTracker Automation Execution Summary","CareTracker Automation Execution Summary","C:\CareTraker Automation\Reports")
'	***********************************************************************************************************************************************************************************************************************************************************************************************
Public Function CF_sendEmail(ByVal strEmailToList,ByVal strEmailCCList,ByVal strSubject,ByVal strBody,ByVal strAttachementPath)
    Set objOutLookApp = CreateObject("Outlook.Application")
  
	strHTMLBody=CF_readTheHtmlReportSummary(strAttachementPath&"\Care Tracker Execution Summary Report.html")


	Set objOutLookItem = objOutLookApp.CreateItem(0)
'	Set objItem = objOutLookApp.ActiveInspector.CurrentItem

	With objOutLookItem
		  .To = strEmailToList
		  .CC = strEmailCCList
		  .Subject = strSubject
		  .ReadReceiptRequested = False
		   strZipPath=strAttachementPath&".Zip"
		   Call CF_zipTheFolder(strZipPath,strAttachementPath)
		   Wait 5
		  .Attachments.Add(strZipPath)
'		  strBodyText= "Hi, "& vbCrLf  &vbCrLf  &"  Please find the attached  Care Tracker Automation Test Execution Report for " & strBody &"."& vbCrLf  & vbCrLf  & "Thanks,"& vbCrLf  & "CareTracker Automation Team."& vbCrLf 
'		   strBodyContent="(This is an Auto generated email, will triger after completion of Automation Test Execution every time, please do not reply to this mail ID)"	
'
'		  .Body  = strBodyText & vbCrLf  & vbCrLf  & vbCrLf& strBodyContent
		   .HTMLBody = strHTMLBody
  End With
  objOutLookItem.Send
End Function
'  ******************************************************************************************************************************************
	'# Functionname: CF_zipTheFolder(ByVal strZipFileName , ByVal strFolderToBeZipped )
	'# Description: Function is used to zip the specified folder
	'#Author:		Madhubabu
	'#
	'# Parameters:
	'# Input Parameters:
	'# strZipFileName : The Zip filename 
	'# strFolderToBeZipped :Folder path to be zipped
	'# OutPut Parameters: NA	
	'# 
	'# Usage:
	'# The usage of this function is
	'# >Call CF_zipTheFolder(strZipPath,strAttachementPath)
'	***************************************************************************************************************************************

Private Sub CF_zipTheFolder(ByVal strZipFileName , ByVal strFolderToBeZipped )
  Set objShell=CreateObject("WScript.Shell")
  Const ZIP_EXE_PATH = "c:\program files\winzip\winzip64.exe"
'  If file to be zipped
'  objShell.Exec ZIP_EXE_PATH & " -a " & Chr(34) & ZipFileName & Chr(34) & " " & Chr(34) &   fileToBeZipped & Chr(34)
' If folder to be zipped
   objShell.Exec ZIP_EXE_PATH & " -min -a -r -p " & Chr(34) & strZipFileName & Chr(34) & " " & Chr(34) &   strFolderToBeZipped & Chr(34)
End Sub

'  ******************************************************************************************************************************************
	'# Functionname: CF_GetRegExString(ByVal strInputValue , ByVal strFormat )
	'# Description: Function is used to get the RegExp Value as per the supplied format
	'#Author:		Govardhan
	'#
	'# Parameters:
	'# Input Parameters:
	'# strInputValue				 : The Input  Original String
	'# strFormat						 :Format of Input String
	'# OutPut Parameters: NA	
	'# Usage: If Match Found will return the First available Match from the String
	'					If No Match Found will return a Blank Value
	'# The usage of this function is
	'# >Call CF_GetRegExString("Test 210 Input", "/d{3}")
'	***************************************************************************************************************************************

Public Function CF_GetRegExString(ByVal strInputValue , ByVal strFormat )
  Dim sRegExp, sMatches, sMatch

  'Create a Valid Regular Expression
  Set oRegExp = New RegExp
  With oRegExp
      .Pattern    = strFormat
      .IgnoreCase = False
      .Global     = False
  End With

  'Identify if there are any matches and  return the first Value If Found
  CF_GetRegExString = ""
  Set sMatches = oRegExp.Execute(strInputValue)
	For Each sMatch in sMatches
	  CF_GetRegExString = sMatch.Value
	  Exit For
	Next

	'Release Variable
	Set oRegExp = Nothing
End Function

'  ******************************************************************************************************************************************
	'# Functionname: CF_readTheHtmlReportSummary(ByVal strReportPath)
	'# Description: Function is used to read the summary information form HTML Report
	'#Author:		Madhubabu
	'#
	'# Parameters:
	'# Input Parameters:
	'# strReportPath : The Path of the Report
	'# strFolderToBeZipped :Folder path to be zipped
	'# OutPut Parameters: NA	
	'# 
	'# Usage:
	'# The usage of this function is
	'# >Call CF_readTheHtmlReportSummary(strReportPath)
'	***************************************************************************************************************************************
Public Function CF_readTheHtmlReportSummary(ByVal strReportPath)	

	Set objFSO= CreateObject("Scripting.FileSystemObject")
	Set objFileToRead =objFSO.OpenTextFile(strReportPath, 1)    
	strFileText = objFileToRead.ReadAll()

    'Read the Summary from Report
	arVal=Split(strFileText,"<td align=center Class=TestDetailsHead>",2)(0)
	strText=strReverse(arVal)
	strActText= Split(strText,">elbat/<",2)(1)
	strActText= strReverse(strActText)&"</table>"
	strActText=Replace(strActText,"<IMG SRC='..\Reports\ScreenShots\OptumPM.png'>","")
	strActText=Replace(strActText,"<IMG SRC='..\Reports\ScreenShots\UHG.jpg'>","")

	strBodyHeader="<html><table><TR COLS=2><TD WIDTH=20% ></TD><TD WIDTH=20% align=Right></TD></TABLE><table border='0' cellpadding='5' cellspacing='0' width='100%' ><tr><td>Hi,</td></tr><tr>"
	strBodyHeader=strBodyHeader&"<td>   Please find the attached Automation Test Execution Summary Report and high level summary below. </td></tr></html>"
	strBodyFooter="<html></table><table><TR COLS=2><TD WIDTH=20% ></TD><TD WIDTH=20% align=Right></TD></TABLE><table border='0' cellpadding='5' cellspacing='0' width='100%' ><tr><td></td>"
	strBodyFooter=strBodyFooter&"</tr><tr><td></td></tr><tr><td>Thanks,</td></tr><tr><td>CareTracker Automation Team </td></tr><tr><td> </td></tr>"
	strBodyFooter=strBodyFooter&"<tr><td>(This is an Auto generated email, will triger after completion of Automation Test Execution every time, please do not reply to this mail ID) </td></tr> </table></html>"

	CF_readTheHtmlReportSummary=strBodyHeader&strActText&strBodyFooter
End Function

'  ******************************************************************************************************************************************
	'# Functionname: CF_WaitProcessWheelObject(ByVal sElementName, ByVal iTimeout)
	'# Description: Wait for the ajax-based (WebElement processing request wheel)  object specified to finish processing a request.
	'#Author:		Hung Nguyen, Govardhan Choletti <Moved function form ChartSync iSTARR Framework>
	'# Parameters:
	'# Input Parameters:
	'# 
	'# Usage:
	'# The usage of this function is
	'# >Call CF_WaitProcessWheelObject("Browser("brwEmerald").Page("pgeEmerald"), "Loading", 120)	'waiting for the 'Processing Request wheel object to finish in 60 secs time out
	'# >Call CF_WaitProcessWheelObject("Browser("brwEmerald").Page("pgeEmerald"), "Please Wait",60)	        'waiting for the 'Please Wait' wheel object to finish in 60 secs time out
'	***************************************************************************************************************************************
Public Function CF_WaitProcessWheelObject(ByVal oAppBrowser, ByVal sElementName, ByVal iTimeout)	

	Dim cnt,oElement,oChildren,iChildrenCount,i,iFound,iX
	strFuncName = "Functiona call : CF_WaitProcessWheelObject(), "
	CF_WaitProcessWheelObject=False	'init return value

	'verify parameters
	If not IsNumeric(iTimeout) then
		Call htmlReport_reporterExecutionStatus (micFail, strFuncName &" Parameter 'iTimeout' must contains a numeric value, Not as Expected")
		Exit Function
	End If
	If sElementName="" or isempty(sElementName) then
		Call htmlReport_reporterExecutionStatus (micFail, strFuncName &" Parameter 'sElementName' must contains a value, Not as Expected")
		Exit Function
	End If

	'any Browser obj which contains the ajax-based processing request obj - expect one only!
	oAppBrowser.Sync

	On error resume next
	cnt=0
	Do while cnt <=iTimeout
		Set oElement=description.Create    
		oElement("micclass").value="WebElement"
		oElement("class").value="feedbackbox"
		oElement("html tag").value="DIV"
		oElement("innertext").value=sElementName

		Set oChildren=oAppBrowser.ChildObjects(oElement)
		iChildrenCount=oChildren.Count
		Call htmlReport_reporterExecutionStatus (micInfo, strFuncName &" object found=" &iChildrenCount &". Checking if visible...")

		If iChildrenCount > 0 Then			
			For i=0 to iChildrenCount - 1
				iFound=0
				If oChildren(i).GetROProperty("x") > 0 Then
					iX=oChildren(i).GetROProperty("x")
					Call htmlReport_reporterExecutionStatus (micInfo, strFuncName &" Object index '" &i &"' is visible at position=" &iX,"Expect to disappear at next Do loop...")
					iFound=1
					Exit For
				Else
					Call htmlReport_reporterExecutionStatus (micInfo, strFuncName &" Object index '" &i &"' is not visible")
				End If
			Next	'child

			If iFound=0 Then 
				CF_WaitProcessWheelObject=True	'return value
				Call htmlReport_reporterExecutionStatus (micInfo, strFuncName &" Object '" &sElementName &"' does not exist or no longer visible.")
				Exit Do
			End If 
		Else
			CF_WaitProcessWheelObject=True	'return value
			Call htmlReport_reporterExecutionStatus (micInfo, strFuncName &" Object '" &sElementName &"' not found")
			Exit Do
		End If

		Set oElement=Nothing
		Set oChildren=Nothing
		Call htmlReport_reporterExecutionStatus (micInfo, strFuncName &"next do loop... till object disappears.")
		Wait(1)		'sec loop interval
		cnt=cnt+1
	Loop

	On error goto 0	'reset
End Function

'******************************************************************************************************************************************
	'# FunctionName: cf_getDateRange(aEnrolStartDate, aEnrolEndDate, sSortOrder)
	'# Description: Function is used get the valid Months and Year from the specified date range as input
	'# Parameters:	aEnrolStartDate = Array("01/02/2012", "01/01/2011", "01/05/2010")
	'							   aEnrolEndDate = Array("31/03/2013", "31/01/2012", "31/12/2010")
	'								sSortOrder = "ASC" or "DESC"
	'# Input Parameters:	Nothing
	'# Usage:
	'# The usage of this procedure is
	'# Call cf_getDateRange (aEnrolStartDate, aEnrolEndDate, sSortOrder)
	'******************************************************************************************************************************************
		Function cf_getDateRange (ByVal aEnrolStartDate, ByVal aEnrolEndDate, ByVal sSortOrder, ByVal strDateFormat)
			Dim sOutput
			Dim iRange
			Dim aConvertStartDate, aConvertEndDate, aConvertPrevEndDate
			Dim dEnrolStartDate, dEnrolEndDate

			strFuncName = "Function call : cf_getDateRange(), "
			pubstrStepName = "Get Date Range in Months "
		   If IsArray(aEnrolStartDate) And IsArray(aEnrolStartDate) Then
				If UBound(aEnrolStartDate) = UBound(aEnrolEndDate) Then
					sOutput = ""

					'Perform action basis on Sort Order
					If sSortOrder = "ASC"Then
						'Do Nothing
					Else
						aEnrolStartDate = cf_ArrayReverse(aEnrolStartDate)
						aEnrolEndDate = cf_ArrayReverse(aEnrolEndDate)
					End If
	
					For iRange = LBound(aEnrolStartDate) To UBound(aEnrolEndDate) STEP 1
						Select Case UCase(strDateFormat)
							Case "MM/DD/YYYY"
								dEnrolStartDate = CDate(aEnrolStartDate(iRange))
								dEnrolEndDate = CDate(aEnrolEndDate(iRange))

								'Get the date so that over lap date is ignored
								If iRange = 0 Then
									dEnrolPrevEndDate = DateAdd("M", -1, CDate(dEnrolStartDate))
								Else
									dEnrolPrevEndDate = CDate(aEnrolEndDate(iRange - 1))
								End If

							Case "DD/MM/YYYY"
								aConvertStartDate = Split(aEnrolStartDate(iRange), "/")
								dEnrolStartDate = CDate(aConvertStartDate(1) &"/"& aConvertStartDate(0) &"/"& aConvertStartDate(2))
								aConvertEndDate = Split(aEnrolEndDate(iRange), "/")
								dEnrolEndDate = CDate(aConvertEndDate(1) &"/"& aConvertEndDate(0) &"/"& aConvertEndDate(2))

								'Get the date so that over lap date is ignored
								If iRange = 0 Then
									dEnrolPrevEndDate = DateAdd("M", -1, CDate(dEnrolStartDate))
								Else
									aConvertPrevEndDate = Split(aEnrolEndDate(iRange - 1), "/")
									dEnrolPrevEndDate = CDate(aConvertPrevEndDate(1) &"/"& aConvertPrevEndDate(0) &"/"& aConvertPrevEndDate(2))
								End If
						End Select
		
						Do
							'Append the Year to the String
							If Instr(1, sOutput, Year(dEnrolStartDate), 1) = 0 Then
								If sOutput = "" Then
									sOutput = Year(dEnrolStartDate)
								Else
									sOutput = sOutput &"~"& Year(dEnrolStartDate)
								End If
							End If 
		
							'Append the Months to the String
							If DateDiff("M", dEnrolPrevEndDate, dEnrolStartDate) > 0 Then
								sOutput = sOutput &":"& UCase(MonthName(Month(dEnrolStartDate), True))
							Else
								'Ignore the Month....
							End If
							dEnrolStartDate = DateAdd ("M", 1, dEnrolStartDate)
						'Loop While (DateDiff("d", dEnrolStartDate, dEnrolEndDate) > 0)
						Loop While ((Month(dEnrolStartDate) <= Month(dEnrolEndDate)) AND (Year(dEnrolStartDate) =Year(dEnrolEndDate))) OR (Year(dEnrolStartDate) < Year(dEnrolEndDate))
					Next

					cf_getDateRange = sOutput
				Else
					Call htmlReport_reporterExecutionStatus(micFail,  strFuncName &" Invalid Array Inputs, First Array Input (aEnrolStartDate) size is - '"&  UBound(aEnrolStartDate) &"', where as other Array Input (aEnrolEndDate) Size is - '"&  UBound(aEnrolEndDate) &"', Not as Expected")
					cf_getDateRange = ""
				End If 
			Else
				Call htmlReport_reporterExecutionStatus(micFail,  strFuncName &" Invalid Inputs, First  Input (aEnrolStartDate) & Second Inputs (aEnrolEndDate) must be Array Inputs")
				cf_getDateRange = ""
			End If
		End Function

'******************************************************************************************************************************************
	'# FunctionName: cf_ArrayReverse(arrInput)
	'# Description: Function is used Reverse the Array elements
	'# Parameters:	arrInput = Array("01/02/2012", "01/01/2011", "01/05/2010")
	'# Output Parameters:	Array in Reverse Format, Else a Null Value for Invalid Input
	'# Usage:
	'# The usage of this procedure is
	'# Call cf_ArrayReverse (aEnrolStartDate)
	'******************************************************************************************************************************************
		Function cf_ArrayReverse( ByVal arrInput )
			strFuncName = "Function call : cf_ArrayReverse(), "
			pubstrStepName = "Reverse Array Elements "
			Dim iLoop, iLastArrayElement, iMidArrayElement, strHolder

			If  IsArray(arrInput)Then
				iLastArrayElement = UBound( arrInput )
				iMidArrayElement = Int( iLastArrayElement / 2 )
			
				For iLoop = 0 To iMidArrayElement
					strHolder             		 = arrInput( iLoop )
					arrInput( iLoop )        = arrInput( iLastArrayElement - iLoop )
					arrInput( iLastArrayElement - iLoop ) = strHolder
				Next
				cf_ArrayReverse = arrInput
			Else
				Call htmlReport_reporterExecutionStatus(micFail,  strFuncName &" Invalid Inputs, First Input (arrInput) must be an Array Input")
				cf_ArrayReverse = Array("") 
			End If
		End Function