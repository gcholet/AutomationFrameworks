'General Header
'#####################################################################################################################
'Script Description		         : General Business Components
'Test Tool/Version		        : HP Quick Test Professional 9.5 and above
'Test Tool Settings		        : N.A.
'Application Automated	: Flight Application
'Author					: Cigniti
'Date Created			: 30/05/2014
'#####################################################################################################################
Option Explicit	'Forcing Variable declarations

''#####################################################################################################################
'Function Name		          : OpenApplication
'Function Description 		  : Function to invoke the Application
'Entry Point			         : Nil	
'Exit Point				 : Application is invoked sucessfully
'Datasheet(s) used		:  NA
'Input Parameters 		: None
'Return Value    		        : None
'Author					: Cigniti
'Date Created			: 30/05/2014
'Component Status		: Completed
'#####################################################################################################################
Sub OpenApplication()
	Dim  AllProcess, Process, strFoundProcess 
	strFoundProcess = False 
	Set AllProcess = getobject("winmgmts:")
	For Each Process In AllProcess.InstancesOf("Win32_process")
		If (Instr (Ucase(Process.Name),"IEXPLORE.EXE") = 1) Then
			SystemUtil.CloseProcessByName "iexplore.exe"
              		Exit for 
       		End If 
    	Next 
	Set AllProcess = nothing
	SystemUtil.Run "iexplore.exe", CRAFT_GetData("General_Data","App_Path")
	Wait(4)
	
'	Browser("CreationTime:=0").Maximize
'	Set gobjPath = Browser("CreationTime:=0")
'	hwnd_Optum = gobjPath.GetROProperty("hwnd")
'	Window("hwnd:=" & cstr(hwnd_Optum)).Maximize
End Sub
'#####################################################################################################################

''#####################################################################################################################
'Function Name		          : Login
'Function Description 		  : Function to Login to the Application
'Entry Point			         : Nil	
'Exit Point				 : Successfully Login to the Application
'Datasheet(s) used		:  NA
'Input Parameters 		: None
'Return Value    		        : None
'Author					: Cigniti
'Date Created			: 30/05/2014
'Date Updated			: 12/08/2014
'Component Status		: Completed
'#####################################################################################################################
Sub Login()
	Dim int_Wait_Timer
	int_Wait_Timer = 0
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'Login to Application
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	With Browser("Gmail").Page("Gmail-SignIn")
		.WebEdit("Email_Edit").Set CRAFT_GetData("General_Data","UserName")
		.WebEdit("Passwd_Edit").Set CRAFT_GetData("General_Data","Password")
		Wait(2)
		.WebButton("SignIn_Wbtn").Click
	End With
	
	'Wait(2)
	
	'Browser("Gmail").Navigate "www.gmail.com"
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'Wait for Application Home Screen to Load
	Wait(8)
	
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'Report Login Pass/Fail Results
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	If Browser("Gmail").Page("Gmail-Inbox").Link("LoggedInUser_Link").Exist(5) Then
		CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
				"Verify User Login to GMail", "User Logged into the GMail Successfully", "Pass"
	Else
		CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
				"Verify User Login to GMail", "User NOT Logged into the GMail Successfully", "Fail"
	End If
End Sub
'#####################################################################################################################

'#####################################################################################################################
'Function Name		          : Logout
'Function Description 		  : Function to Logout of the Application
'Entry Point			         : Nil	
'Exit Point				 : Successfully Logout from the Application
'Datasheet(s) used		:  NA
'Input Parameters 		: None
'Return Value    		        : None
'Author					: Cigniti
'Date Created			: 04/06/2014
'Component Status		: Completed
'#####################################################################################################################
Sub Logout()
	Browser("Gmail").Page("Gmail-Inbox").Link("LoggedInUser_Link").Click
	Wait(2)
	Browser("Gmail").Page("Gmail-Inbox").Link("Signout_Link").Click
	Wait(6)
	
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'Report Logout Pass/Fail Results
	'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	If Browser("Gmail").Page("Gmail-SignIn").WebEdit("Email_Edit").Exist(5) Then
		CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
				"Verify User Logout to GMail", "User Logged Out from GMail Successfully", "Pass"
	Else
		CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
				"Verify User Login to GMail", "User NOT Logged out from GMail Successfully", "Fail"
	End If
End Sub
'#####################################################################################################################

''#####################################################################################################################
'Function Name		          : E1_CloseApplication
'Function Description 		  : Function to Close to the JD Edwards One Application
'Entry Point			         : Nil	
'Exit Point				 : Successfully Close of the Application
'Datasheet(s) used		:  NA
'Input Parameters 		: None
'Return Value    		        : None
'Author					: Cigniti
'Date Created			: 30/05/2014
'Component Status		: Completed
'#####################################################################################################################
Sub CloseApplication()
	Dim appStatus
	SystemUtil.CloseProcessByName "iexplore.exe"
   	appStatus = Browser("Gmail").Exist(5)
	If  CBool(appStatus) = False Then
		CRAFT_ReportEvent Environment.Value("ReportedEventSheet"),_ 
				"Close Application", "Application closed successfully", "Completed"
	End If
End Sub
'#####################################################################################################################

Sub SHORTWAIT
	Wait(5)
End Sub


Sub MEDIUMWAIT
	Wait(15)
End Sub

Sub LONGWAIT
	Wait(30)
End Sub
