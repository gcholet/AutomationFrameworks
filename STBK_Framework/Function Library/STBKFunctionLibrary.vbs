
Option Explicit
Dim SystemName, TestIdentifier
Dim ObjScreen,TestStepIDNbr_prev,DataTableRow_Prev
'Dim ErrorScreenShotFlag
'#######################################################################################################################
'Set of Variable
Set ObjScreen = TeWindow("TeWindow").TEScreen("TeScreen")
'#######################################################################################################################

'Function Name	: Search
'Purpose	This function Search a particular value or set of values based upon the Screen it is on.
'Input Parameters    				1. number_of_field -  number of field entered on excelsheet
'													 2. ScreenName - Screen Name to validate if on correct screen
'													3. Action - Action that is performed
'													4 TestCaseID - Test Case Id mentioned in the Test Data Sheet
'													5 objExcel_Act - Environmental Variable set by Login_CC function
'Output Parameters 				1 SearchedRow - Row in which record is found
'													2	ExitScenario  - Flag to check whether Scenario should exit or not
'													3	sfailCnt   - To capture number of failures on a Scenario.
'#######################################################################################################################

Public Function Search(ByVal Con_Screenmap,Byval number_of_field, Byval ScreenName,Byval Action,ByVal TestCaseID,ByVal objExcel_Act,Byref SearchedRow,ByRef ExitScenario,ByRef sfailCnt,ByVal ApplicationName)

    Dim oDesc,collect,reportStatus,Status,fName,fValue,Comment,ScreenSearch,SkipCond,oCollection,Message,fn,fv
	Dim n,z,j,f1,f2,v1,v2,SearchField, NumberOfLists,SearchRecord,oFieldDesc,FieldCount,A_TEXT,SearchFiled
	SearchedRow = ""
'	Code to handle three Screens on which search can be performed
	If ValidateScreen(Con_Screenmap,ScreenName,Comment) = MicFail Then
		If Environment.Value ("Emp_Policy_Pick") = "N" or Environment.Value ("Patient_Pick") = "N" or Environment.Value ("Provider_Pick") = "N" Then
			 Status = "PASSED"
			ExitScenario = "NO"
			Text = "Skipping the step since the Provider Pick Screen has appeared instead of " &ScreenName
			reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Text, sfailCnt )
			Exit Function
		End If
	Else
		If  ScreenName = "EMC_Status"Then
				ScreenSearch = "EMC"
		ElseIF ScreenName = "ARI" Then
				ScreenSearch = "ARI"
		ElseIf ScreenName = "PAI" Then
				ScreenSearch = "PAI"
		 ElseIf Ucase(ScreenName) ="EMPLOYEE_POLICY_PICK" Then
				 ScreenSearch ="EMPLOYEE_POLICY_PICK"
		ElseIf Ucase(ScreenName) ="PATIENT_PICK" Then
				 ScreenSearch ="PATIENT_PICK"
		Else
				ScreenSearch = "NONE"
		End If
	
		Select Case ucase(ScreenSearch)
	' Code to handle Search on EMC Screen
			Case ucase("EMC")
					 f1 = DataTable.Value("FieldName1","DataSheet")
					v1 = DataTable.Value("FieldValue1","DataSheet")
					f2 =  DataTable.Value("FieldName2","DataSheet")
					v2 =  DataTable.Value("FieldValue2","DataSheet")
					If  len (v2) > 2Then
						Comment="The length of text being entered is more than expected"
						Search = micFail
						Status = "FAILED"
						step_status = micFail
						ExitScenario = "NO"
						 fv = v1&"/"&v2
						 fn= f1 & "/ " & f2
						reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
						Exit function
					End If
					Do Until len( v2)  >= 2
						v2 = "0" & v2
					Loop
					
					SearchFiled = v1&" "&v2
					fn= f1 & "/ " & f2
					fv = v1&" "&v2
					
					If (ValidateScreen(Con_Screenmap,ScreenName,Comment)=micPass) then
							SearchRecord=False
							For SearchedRow=7 to 23 'Records come from 7th row to 23rd row 
								SkipCond = False
								Set oFieldDesc = Description.Create
								oFieldDesc("start row").Value = SearchedRow
								Set oCollection = ObjScreen.ChildObjects(oFieldDesc)
								FieldCount = oCollection.Count
								For n = 0 To FieldCount - 1 
										A_TEXT=oCollection(n).GetROProperty("text")
										If fv=Trim(A_TEXT) Then
												SearchRecord=True
												Exit For
										Else
												SearchRecord=False
										End If  
										If (n=  FieldCount - 1) and (SearchRecord=False) Then
												SkipCond = True
												Exit For
										End If
								Next					
								If SearchRecord =True Then
										Exit For
								End If
								If  (SearchedRow = 23)  Then    ' Code to handle multiple screen search
										Message = Trim(ObjScreen.GetText(SearchedRow,4,SearchedRow,9)) 
									If Message <>"" Then
										ObjScreen.SendKey TE_PF8
										WaitTillBusy
										SearchedRow = 6
									Else
									   If Message="" Then
										   Exit For
									  End If
									End If
								End If
						Next
						If  SearchRecord = False Then
								SearchedRow = ""
						End If
						If  SearchedRow <> "" Then
								Status = "PASSED"
								ExitScenario  = "NO"
								Comment = "SEARCH is successful"
								fv = v1&"/"&v2
								reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
						else
								Status = "FAILED"
								ExitScenario  = "YES"
								Comment = "SEARCH is NOT successful, Hence exiting the entire Scenario"
								fv = v1&"/"&v2
								reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID,  fn,fv,Status, Comment, sfailCnt )
						End If
				Else
						Status = "FAILED"
						Comment = "Screen Not Found, Hence exiting the entire Scenario"
						ExitScenario  = "YES"
						fv = v1&"/"&v2
						reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName, Action, TestCaseID,  fn,fv,Status, Comment, sfailCnt )
				End If	
	
	' Code to handle Search on ARI Screen
			Case ucase("ARI")
						If (ValidateScreen(Con_Screenmap,ScreenName,Comment)=micPass) then
						SearchRecord=False
							For SearchedRow=6 to 22 'Records come from 6th row to 22nd row 
								For j=29 to 1Step -1
									If (DataTable.Value("FieldValue"& j,"DataSheet") <> "") then						
										number_of_field = j
										Exit for
									Else
										number_of_field = ""
									End If			
								Next
								If number_of_field = "" Then
									Exit For
								End If
									
								Message=Trim(ObjScreen.GetText(24,3,24,80))  
								For z= 1 To number_of_field
										fn = DataTable.Value("FieldName"& z,"DataSheet")
										fv=  DataTable.Value("FieldValue"& z,"DataSheet")
										SkipCond = False
										Set oFieldDesc = Description.Create
										oFieldDesc("start row").Value = SearchedRow
										Set oCollection = ObjScreen.ChildObjects(oFieldDesc)
										FieldCount = oCollection.Count
										
										For n = 0 To FieldCount - 1 
												A_TEXT=oCollection(n).GetROProperty("text")
												If fv=Trim(A_TEXT) Then
														SearchRecord=True
														Exit For
												Else
														SearchRecord=False
												End If  
												If (n=  FieldCount - 1) and (SearchRecord=False) Then
														SkipCond = True
														Exit For
												End If
										Next
										
										If  SkipCond = True Then
												Exit For
										End If
								Next
								
								If SearchRecord =True Then
										Exit For
								End If
								If  (SearchedRow = 22) and (instr(1,Message,"W758 NO MORE RECORDS")=0)  Then    ' Code to handle multiple screen search
										ObjScreen.SendKey TE_ENTER
										WaitTillBusy
										SearchedRow = 5
								End If
						Next
		
						If  SearchRecord = False Then
								SearchedRow = ""
						End If
						If  SearchedRow <> "" Then
								Status = "PASSED"
								ExitScenario  = "NO"
								Comment = "SEARCH is successful"
								reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fName,fValue,Status, Comment, sfailCnt )
						else
								Status = "FAILED"
								ExitScenario  = "YES"
								Comment = "SEARCH is NOT successful, Hence exiting the entire Scenario"
								reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID,  fName,fValue,Status, Comment, sfailCnt )
						End If
				Else
						Status = "FAILED"
						Comment = "Screen Not Found, Hence exiting the entire Scenario"
						ExitScenario  = "YES"
						reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID,  fName,fValue,Status, Comment, sfailCnt )
				End If		
	' Code to handle Search on PAI Screen
			Case ucase("PAI")
						If (ValidateScreen(Con_Screenmap,ScreenName,Comment)=micPass) then
						SearchRecord=False  
							For j=29 to 1Step -1
								If (DataTable.Value("FieldValue"& j,"DataSheet") <> "") then						
									number_of_field = j
									Exit for
								Else
									number_of_field = ""
								End If			
							Next			
						For SearchedRow=6 to 22 step 2 'Records come from 6th row to 22nd row and steping by 2 as we search for 2 rows in one go
							 If number_of_field = "" Then
									Exit For
							 End If
							For z= 1 To number_of_field
									fn = DataTable.Value("FieldName"& z,"DataSheet")
									fv=  DataTable.Value("FieldValue"& z,"DataSheet")
									SkipCond = False
									Set oFieldDesc = Description.Create
									oFieldDesc("start row").Value = SearchedRow
									Set oCollection = ObjScreen.ChildObjects(oFieldDesc)
									FieldCount = oCollection.Count	
									For n = 0 To FieldCount - 1 
											A_TEXT=oCollection(n).GetROProperty("text")
											If fv=Trim(A_TEXT) Then
													SearchRecord=True
													Exit For
											Else
													SearchRecord=False
											End If     			   
											If (FieldCount = 11) and  (n=10)   Then 'Code to handle 2 line of search as in PAI screen to search for a particular set of records we have to traverse through 2 lines every time
													oFieldDesc("start row").Value = SearchedRow + 1 
													Set oCollection = ObjScreen.ChildObjects(oFieldDesc)
													FieldCount = oCollection.Count -1
													n=-1
											End If
											If (n=  FieldCount - 1) and (SearchRecord=False) Then
													SkipCond = True
													Exit For
											End If
									Next		
									If  SkipCond = True Then
											Exit For
									End If
							Next
							If SearchRecord =True Then
									Exit For
							End If
							If  (SearchedRow = 22) Then ' Code to handle multiple screen search
									Message = Trim(ObjScreen.GetText(SearchedRow,5,SearchedRow,14)) 
									If Message <>  "----------" Then
										ObjScreen.SetText 2,2, "PAN"
										ObjScreen.SendKey TE_ENTER
										WaitTillBusy
										SearchedRow = 4
									End If
							End If
						Next  	
						If  SearchRecord = False Then
								SearchedRow = ""
						End If
						If  SearchedRow <> "" Then
								Status = "PASSED"
								ExitScenario  = "NO"
								Comment = "SEARCH is successful"
								reportStatus=appendValidationSheet(objExcel_Act, ScreenName,ApplicationName, Action, TestCaseID, fName,fValue,Status, Comment, sfailCnt )
						else
								Status = "FAILED"
								ExitScenario  = "YES"
								Comment = "SEARCH is NOT successful, Hence exiting the entire Scenario"
								reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID,  fName,fValue,Status, Comment, sfailCnt )
						End If
				Else ' If the desired screen is not present 
						Status = "FAILED"
						Comment = "Screen Not Found, Hence exiting the entire Scenario"
						ExitScenario  = "YES"
						reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID,  fName,fValue,Status, Comment, sfailCnt )
				End If      
	' Code to handle Search on ARI Screen
			Case ucase ("EMPLOYEE_POLICY_PICK") , ("PATIENT_PICK")
						WaitTillBusy
						If (ValidateScreen(Con_Screenmap,ScreenName,Comment)=micPass) then
						SearchRecord=False
							For SearchedRow=5 to 22 'Records come from 5th row to 22nd row 
								For j=1 to 10 Step 1
									If (DataTable.Value("FieldValue"& j,"DataSheet") <> "") then
										number_of_field = j
										Exit for
									Else
										number_of_field = ""
									End If
								Next
								If number_of_field = "" Then
									Exit For
								End If
									
								'Message=Trim(ObjScreen.GetText(23,2,23,23))  
								For z= 1 To number_of_field
										fn = DataTable.Value("FieldName"& z,"DataSheet")
										fv=  DataTable.Value("FieldValue"& z,"DataSheet")
										SkipCond = False
										Set oFieldDesc = Description.Create
										oFieldDesc("start row").Value = SearchedRow
										Set oCollection = ObjScreen.ChildObjects(oFieldDesc)
										FieldCount = oCollection.Count
										
										For n = 0 To FieldCount - 1 
												A_TEXT=oCollection(n).GetROProperty("text")
												If fv=Trim(A_TEXT) Then
														SearchRecord=True
														Exit For
												Else
														SearchRecord=False
												End If  
												If (n=  FieldCount - 1) and (SearchRecord=False) Then
														SkipCond = True
														Exit For
												End If
										Next
										
										If  SkipCond = True Then
												Exit For
										End If
								Next
								
								If SearchRecord =True Then
										Exit For
								End If
								If  (SearchedRow = 22) Then
									If Ucase(ScreenName) =  ("EMPLOYEE_POLICY_PICK") and Trim(ObjScreen.GetText(20,10,20,16)) <> "" Then    ' Code to handle multiple screen search Then
										ObjScreen.SendKey TE_PF8
										WaitTillBusy
										SearchedRow = 5
									ElseIf Ucase(ScreenName) = ("PATIENT_PICK") and ObjScreen.GetText(21,7,21,16) <> "----------" Then    ' Code to handle multiple screen search
										ObjScreen.SendKey TE_PF8
										WaitTillBusy
										SearchedRow = 5
									End If
								End If
						Next
		
						If  SearchRecord = False Then
								SearchedRow = ""
						End If
						If  SearchedRow <> "" Then
								Status = "PASSED"
								ExitScenario  = "NO"
								Comment = "SEARCH is successful"
								If Ucase(ScreenName) = "EMPLOYEE_POLICY_PICK" Then
									SearchedRow = SearchedRow - 1
								Else
									SearchedRow = SearchedRow
								End If
								
								reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
						else
								Status = "FAILED"
								ExitScenario  = "YES"
								Comment = "SEARCH is NOT successful, Hence exiting the entire Scenario"
								reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
						End If
				Else
						Status = "FAILED"
						Comment = "Screen Not Found, Hence exiting the entire Scenario"
						ExitScenario  = "YES"
						reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID,  fn,fv,Status, Comment, sfailCnt )
				End If		
					
			Case ucase("NONE")
					Status = "FAILED"
					Comment = "Screen Not Valid for performing Search Function.Hence exiting the entire Scenario"
					ExitScenario  = "YES"
					reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
	
		
			End Select
	End If
End Function

''#######################################################################################################################

'Function Name	WaitTillBusy
'Purpose	This function waits till the status of emulator is Ready
'Input Parameters    		None
'Output Parameters 	 	None
'#######################################################################################################################

Public Function WaitTillBusy
		TeWindow("TeWindow").WaitProperty "emulator status", "Ready", 900000
End Function


'#######################################################################################################################
'Function Name	SetText
'Purpose	This function puts the value on Online Screen for a particular field
'Input Parameters    		obj, screen, text
'Output Parameters 	 	Comments 	:Text to be reported in case of failures
'											row   : Row number of the filed
'											col    : Column of the field
'											fieldlen : Field length of the field
'#######################################################################################################################

Public function SetText(byVal Con_Screenmap,byval obj,  byval screen,  byval text, Byref Comment,Byref row,Byref col, Byref fieldlen)
	   Dim Protected
	   On Error Resume Next
			If isnull(text) then
				text=""
			End if 
			If ((Fetch_row_col (Con_Screenmap,screen,obj,  row, col,fieldlen,Protected,Comment)=micPass) and (ValidateScreen(Con_Screenmap,Screen,Comment)=micPass)) then 
				If  fieldlen < len(text) Then
					SetText=micFail
					Comment="The length of text being entered is more than expected"
					SetText=micFail	
					Exit function
				Else
					WaitTillBusy
					ObjScreen.Sync
					ObjScreen.SetText row,col, text
					Comment="The text '"& text & "' is set in the field "& obj
					SetText=micPass	
				End If
			Else
				SetText=micFail
			End if
			If Err.Description <> "" Then
				SetText=micFail
				Comment = "Encounterd Run Time Error with error number : "& err.number & " and Description as : " & Err.Description 
				Err.Clear
			End If
End Function



''''#######################################################################################################################

'Function Name	GetText
'Purpose	This function gets the value on Online Screen for a particular field
'Input Parameters    		obj, screen
'Output Parameters 	 	text	:Value in the filed
'											row   : Row number of the filed
'											col    : Column of the field
'											fieldlen : Field length of the field
'#######################################################################################################################
Public function GetText(byVal Con_Screenmap,byval obj,  byval screen,  byref text,byref row,byref col,byref fieldlen,byref comment)

 Dim fLength,Protected,status1,status2,Comment1,Comment2
   On Error Resume Next
	status1 = Fetch_row_col (Con_Screenmap,screen,obj,  row, col,fieldlen,Protected,Comment1)
	status2 = ValidateScreen(Con_Screenmap,Screen,Comment2)
	 If ((status1=0) and (status2=0)) then 
		  fLength = col + (fieldlen -1)
		 text=trim(ObjScreen.GetText (row,col,row,fLength))
		 GetText=micPass
	 else
		If status1<> 0 Then
			Comment = Comment1
		Else
			Comment = Comment2
		End If
	   GetText=micFail
	 End if
		If Err.Description <> "" Then
				GetText=micFail
				Comment = "Encounterd Run Time Error with error number : "& err.number & " and Description as : " & Err.Description 
				Err.Clear
		End If
End Function

'''#######################################################################################################################

'Function Name	ValidateScreen
'Purpose	This function checks whether we are on expected Screen or not
'Input Parameters    		Screen
'Output Parameters 	 	Comment	:Text to be reported in case of failures

'#######################################################################################################################
Public Function ValidateScreen(byVal Con_Screenmap,byval Screen, Byref Comment)

		Dim RS, Stmt, Start_row, Start_col,end_row,end_col,expected_title,actual_title
		Dim x,found,strCount
		Dim Title
		Stmt = "select StartRow, StartCol, EndRow, EndCol, Title from ScreenLookup  where ScreenId ='"&Screen&"'" 
        Set RS=CreateObject("ADODB.Recordset")
		rs.open Stmt,Con_Screenmap,1,1
        strCount = RS.recordcount
		If strCount = 0 Then
				'		No matches
				ValidateScreen=micFail
				Comment="Unable to find ScreenId " & Screen & " in ScreenLookup"
        ElseIf strCount > 1 Then
				'			More than one record matched
				ValidateScreen = micFail
				Comment="Multiple definitions for ScreenId '" & ScreenId 
		Else
				'				Only One Record Found

		
		'Retrieve the values
				Start_row	= RS("StartRow")
                Start_col	 = RS("StartCol")
				end_row	 = RS("EndRow")
				end_col	=RS("EndCol")
				expected_Title	=RS("Title")
				If  expected_Title = "Process_Initiator" then
					expected_Title = " "
				End If
			'Calculation Logic  to determine end row and end column
			found=ObjScreen.WaitString(Title,,,,,60000)
			
				If found=false Then
					ValidateScreen=micFail
					Comment="Not on expected Screen"
					elseif found=true then
					waitTillBusy
					Actual_title=ObjScreen.GetText(Start_row,Start_col,end_row,end_col)	
					If Actual_title=expected_title Then
                        ValidateScreen=micPass
						Comment="On Expected Screen" 	 
						ElseIf expected_title = "EDS 1" Then
							Actual_title=ObjScreen.GetText(6,2,6,6)	
							If Actual_title=expected_title Then
								ValidateScreen=micPass
								Comment="On Expected Screen"
							Else
								ValidateScreen=micFail
								Comment="Not on expected Screen"
							End If
						Else
						ValidateScreen=micFail
						Comment="Not on expected Screen"
					End If	
				End If
		
		End if 	
Set RS=nothing		

End Function

'#######################################################################################################################

'Function Name	Fetch_row_col
'Purpose	This function fetches the row an column coordinates from OR for the specified field on the specified screen
'Input Parameters    			1	DBCon	DB Connection
'												 2	Table	Screen Map
'												3	Field	To be searched
'Output Parameters 			1	row	Row Number
'											    2	col	Column Number
'											    3	FieldLength	Field Length
'                                              4 	Protected	Protected Status
'											   5  	Comment	Text to be reported in case of failures

'#######################################################################################################################

Public Function Fetch_row_col(DBCon,Table,Field,byref row, byref col,byref FieldLength,ByRef Protected, Byref Comment)
		Dim RS, Stmt,strCount,x
'Check for existance of theTable

On error resume next
			Set RS=CreateObject("ADODB.Recordset")
			Stmt="select  StartRow, StartColumn,FieldLength, Protected  from " &Table &" where FieldName = '"&Field &"'"
			rs.open Stmt,DBCon,1,1

			If CStr(Err.Number)=0 Then
				strCount = RS.recordcount
				If strCount = 0 Then 					'No matches
					Fetch_row_col = micFail
					Comment= "Unable to find field '" & Field & "' in " & Table & " table"
				ElseIf strCount > 1 Then				'More than one record matched
					Fetch_row_col = micFail
					Comment="Multiple definitions for field '" & Field & "' in " & Table & " table"
				Else 				'Only One Record Found    Retrieve the values
					row	= RS("StartRow")
					col	 = RS("StartColumn")
					FieldLength	 = RS("FieldLength")
					Protected = RS("Protected")
					Fetch_row_col = micPass
				End if 
			Else
				Fetch_row_col = micFail
				Comment= "Unable to find Table '" & Table & "' in ScreenDump"
			End If
On Error GoTo 0
Set RS=nothing
End Function

'#######################################################################################################################

'Function Name	IfTableExists
'Purpose	This function checks in the MDB if the Table exists
'Input Parameters    			1	DBCon	DB Connection
'												 2	Table	Screen Map

'#######################################################################################################################

Public Function IfTableExists(Byval DBCon,Byval table)
			Dim RS
			Const adSchemaTables = 20
            Set RS = DBCon.OpenSchema (adSchemaTables)
			Do Until RS.EOF
'--- Skip system tables
				If StrComp(RS("TABLE_TYPE").Value, "SYSTEM TABLE") <> 0 Then
						If UCASE( RS("TABLE_NAME").Value)=UCASE(table) then
							IfTableExists=micPass
                            Exit Do
						Else
                            IfTableExists=micFail
						end If
                End If
				RS.movenext
            Loop
End Function

''''################################################################################################################################
'Function Name	InputFunction
'Purpose	This function is used to enter value given in the data sheet for a particular field in Online Screen.
'Input Parameters       			 1. number_of_field -  number of field entered on excelsheet
'													 2. ScreenName - Screen Name to validate if on correct screen
'													3. Action - Action that is performed
'													4 TestCaseID - Test Case Id mentioned in the Test Data Sheet
'													5 objExcel_Act - Environmental Variable set by Login_CC function
'Output Parameters 			 1	ExitScenario	Flag to check whether Scenario should exit or not
'												2	sfailCnt	To capture number of failures on a Scenario.
'################################################################################################################################

Function InputFunction(ByVal Con_Screenmap,ByVal SearchedRow,Byval number_of_field, Byval ScreenName,Byval Action,ByVal TestCaseID,ByVal objExcel_Act,ByRef ExitScenario,ByRef sfailCnt, ByVal ApplicationName)

	Dim fn,fv,z,reportStatus,Status,Text,Fieldv,counter,Comment,row,col,fieldlen,step_status,Protected
	If ValidateScreen(Con_Screenmap,ScreenName,Comment) = MicFail Then
		If Environment.Value ("Emp_Policy_Pick") = "N" or Environment.Value ("Patient_Pick") = "N" or Environment.Value ("Provider_Pick") = "N" Then
			 Status = "PASSED"
			ExitScenario = "NO"
			Text = "Skipping the step since the Provider Pick Screen has appeared instead of " &ScreenName
			reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Text, sfailCnt )
			Exit Function
		End If
	Else
		If ScreenName = "Provider_Pick" Then
			step_status= SetText(Con_Screenmap,"SUF",ScreenName,"E",Comment,row,col,fieldlen)
		ElseIf (ScreenName = "HCFA_Claim_Info" OR ScreenName = "UB92_Claim_Info") Then
			step_status= SetText(Con_Screenmap,"NXT",ScreenName,"M",Comment,row,col,fieldlen)
		End If
		 
		If UCase(ScreenName) = "HOME" Then
			If ValidateScreen(Con_Screenmap,ScreenName,Comment) = MicFail Then
				Do
					ObjScreen.SendKey TE_CLEAR
					WaitTillBusy
					If ValidateScreen(Con_Screenmap,ScreenName,Comment) = MicPass Then
						Exit Do
					End If
					counter = counter + 1
				Loop While counter <= 10
			End If
		End If
		If number_of_field <>  "" Then
	'Iterate through all the field values given in the Test Data Sheet 
			For z=1 to number_of_field Step 1
				fn = DataTable.Value("FieldName"& z,"DataSheet")
				fv=  DataTable.Value("FieldValue"& z,"DataSheet")
		' If field value is blank 
			   IF fn = "" Then
						 InputFunction = micFail
						Status = "FAILED"
						Comment = "No field selected where input needs to be done"
						reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName, Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
						ExitScenario = "NO"
						Exit For
				End If
		  'Code which calls Function_Key_Press function
		If Ucase(fn) = "FUNCTION KEY" Then
			step_status = Function_Key_Press(objExcel_Act, ScreenName, Action, TestCaseID, fn,fv, Status, Comment, sfailCnt, ApplicationName)
	
		Else
	
		'Code which handles the Search Functionality
			If (ScreenName = "EMC_Status" AND fn = "Option") or (ScreenName = "ARI" AND fn = "Select") or (ScreenName = "ARI" AND fn = "Action") or (ScreenName = "PAI" AND fn = "Select") or (ScreenName = "PAI" AND fn = "Action") or (Ucase(ScreenName) = "EMPLOYEE_POLICY_PICK" AND fn = "Policy_Selection") or (Ucase(ScreenName) = "PATIENT_PICK" AND fn = "Patient_Selection") Then
					  If (ValidateScreen(Con_Screenmap,ScreenName,Comment)=micPass) then 
						  If  SearchedRow <> "" Then
								  If len (fv)  > 1 Then
										 InputFunction = micFail
										Status = "FAILED"
										Comment = "The length of text being entered is more than expected"
										reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName, Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
										ExitScenario = "NO"
										Exit For
								  End If
								  If  ScreenName = "PAI" Then
									ObjScreen.SetText SearchedRow,1, fv
									WaitTillBusy
								Else
									ObjScreen.SetText SearchedRow,2, fv
									WaitTillBusy
								End If
								InputFunction = micPass
								Status = "PASSED"
								Comment = "The text '" & fv & "' is set in the field " & fn
								reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName, Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
								ExitScenario = "NO"
								Exit For
							End If
					Else
						InputFunction = micFail
						Status = "FAILED"
						Comment =   "Screen '" &ScreenName&"'  On Which Action needs to be performed not found. Hence exiting the entire Test Scenario."
						reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName, Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
						ExitScenario = "YES"
						Exit For
						
					End if
	
		' Code which handles the dollar field if $ is given as prefix in Test Data Sheet
				ElseIf left(fv,1) = "$" Then
					fieldv = split(fv,".")
					fieldv(0) = mid( fieldv(0),2)
	
					step_status=Fetch_row_col(Con_Screenmap,ScreenName,fn,row,col,fieldlen,Protected,Comment)
					
					If  step_status = micPass Then
						If  fieldlen < len (fieldv(0)) Then
						  Comment="The length of text being entered is more than expected"
							InputFunction = micFail
							Status = "FAILED"
							step_status = micFail
							ExitScenario = "NO"
	
						End If
						Do Until len( fieldv(0)) >= fieldlen 
								fieldv(0) = "0" & fieldv(0)
						Loop
						  step_status= SetText(Con_Screenmap,fn,screenname,fieldv(0),Comment,row,col,fieldlen)
						  col = col+fieldlen +1
		'Code to handle if  cent value is given  when $ is suffixed in the field value 			  
					  If instr(1,fv,".")>0  Then   
						  If   len(fieldv(1)) > 2 Then
							Comment="The length of text being entered is more than expected"
							InputFunction = micFail
							Status = "FAILED"
							step_status = micFail
							ExitScenario = "NO"
						 End If
						 If  step_status = micPass Then
								On Error Resume Next
								ObjScreen.SetText row,col, fieldv(1)
								 If Err.Description <> "" Then
													Status = "FAILED"
													ExitScenario = "NO"
													Text = "Encounterd Run Time Error with error number : "& err.number & " and Description as : " & Err.Description
													reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName, Action, TestCaseID, fn,fv,Status, Text, sfailCnt)
													Err.Clear
								Else
									Comment="The text '" & fv & "' is set in the field " & fn
									InputFunction = micPass
									Status = "PASSED"
									reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName, Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
	
								End If
						Else
								 InputFunction = micFail
								Status = "FAILED"
		'Code to handle the reporting part where actual result will  depend upon the comments
								If ((instr(1,Comment,"Unable to find ScreenId")>0) or (instr(1,Comment,"Not on expected Screen")>0) ) Then
										Comment =   "Screen '" &ScreenName&"'  On Which Action needs to be performed not found. Hence exiting the entire Test Scenario."
										reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName, Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
										ExitScenario = "YES"
										Exit For
								Else
										reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName, Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
										ExitScenario = "NO"
								End If
						End If
		'Code to handle if  cent value is not given  when $ is suffixed in the field value 	
					Else 
						If  step_status = micPass Then
								Comment="The text '" & fv & "' is set in the field " & fn
								InputFunction = micPass
								Status = "PASSED"
								reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName, Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
						Else
								 InputFunction = micFail
								Status = "FAILED"
		'Code to handle the reporting part where actual result will  depend upon the comments
								If ((instr(1,Comment,"Unable to find ScreenId")>0) or (instr(1,Comment,"Not on expected Screen")>0) ) Then
										Comment =   "Screen '" &ScreenName&"'  On Which Action needs to be performed not found. Hence exiting the entire Test Scenario."
										reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName, Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
										ExitScenario = "YES"
										Exit For
								Else
										reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName, Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
										ExitScenario = "NO"
								End If
						End If
					End If
						
						Else
							InputFunction = micFail
							Comment =   "Screen '" &ScreenName&"'  On Which Action needs to be performed not found. Hence exiting the entire Test Scenario."
							Status = "FAILED"
							reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName, Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
							ExitScenario = "YES"
							Exit For
						End If
		'Code for normal input    
				 Else
					step_status= SetText(Con_Screenmap,fn,screenname,fv,comment,row,col,fieldlen)
					If step_status = micPass Then
						 InputFunction = micPass
						Status = "PASSED"
						reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName, Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
						ExitScenario = "NO"
						Else
						InputFunction = micFail
						Status = "FAILED"
						If ((instr(1,Comment,"Unable to find ScreenId")>0) or (instr(1,Comment,"Not on expected Screen")>0) ) Then
								Comment =   "Screen '" &ScreenName&"'  On Which Action needs to be performed not found. Hence exiting the entire Test Scenario."
								reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName, Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
								ExitScenario = "YES"
								Exit For
						Else
								reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName, Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
								ExitScenario = "NO"
						End If
					End if
			End if	  
			End If	
			Next
		'Code to transmit once all the fileds which are given in the Test Data Sheet has been entred
			If  step_status = micPass and Ucase(fn) <> "FUNCTION KEY" Then
				Environment.Value("Transmit") = "Y"
				ObjScreen.SendKey TE_ENTER
				WaitTillBusy
			End If
		Else 
			InputFunction = micFail
			Status = "FAILED"
			Comment = "No field selected where input needs to be done"
			reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
			ExitScenario = "NO"
			Environment.Value("Transmit") = "N"
		End If
	End If
End Function




'''################################################################################################################################

'Function Name	OutputFunction
'Purpose	This function is used to compare the values given in the datasheet to the actual value present on Online Screen
'Input Parameters    	number_of_field,ScreenName, Action, TestCaseID, objExcel_Act
'Output Parameters 			 1	ExitScenario	Flag to check whether Scenario should exit or not
'												2	sfailCnt	To capture number of failures on a Scenario.

'################################################################################################################################

Function OutputFunction(ByVal Con_Screenmap,Byval number_of_field, Byval ScreenName,Byval Action,ByVal TestCaseID,ByVal objExcel_Act,ByRef ExitScenario,ByRef sfailCnt,ByVal ApplicationName)
 
 Dim fn,fv,z,reportStatus,row,col,fieldlen,Centtext,A_Text,Comment
 Dim Text,StepStatus,Status, Message,E_Text,Flength,step_status
 Message =  Trim(DataTable.Value("Warning_Error_Message","DataSheet"))
' If Environment.Value ("Emp_Policy_Pick") = "N" or Environment.Value ("Patient_Pick") = "N" Then
'     Status = "PASSED"
'	ExitScenario = "NO"
'	Text = "Skipping the step since the Provider Pick Screen has appeared instead of " &ScreenName
'	reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Text, sfailCnt )
'	Exit Function
' End If
 If number_of_field <> "" Then

	 For z=1 to number_of_field Step 1
			fn = DataTable.Value("FieldName"& z,"DataSheet")
			fv=  ltrim(rtrim((DataTable.Value("FieldValue"& z,"DataSheet")))) 
			If fv <> "" Then
			 If Ucase(fn) = "FUNCTION KEY" Then
				Status = "FAILED"
				ExitScenario = "NO"
				Text = "Function Key is not a valid field name in case Action is 'Output'"
				reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Text, sfailCnt)
				Exit Function
			 End If
				If (GetText(Con_Screenmap,fn,screenname,Text,row,col,fieldlen,Comment) = MicPass) Then
						  If Instr(fv,"$") Then
								   E_Text=Split(fv,"$")(1)
	
								   									   Flength=TeWindow("TeWindow").TEScreen("TeScreen").tefield("start row:="&row, "start column:="&col).getroproperty("length")    '(fieldlen-3) 
										If instr(1,Text,".") = 0 Then
											On Error Resume Next
											Centtext=TeWindow("TeWindow").TEScreen("TeScreen").tefield("start row:="&row, "start column:="&col+Flength+1).getroproperty("text")
											 If Err.Description <> "" Then
													Status = "FAILED"
													ExitScenario = "NO"
													 Text = "Encounterd Run Time Error with error number : "& err.number & " and Description as : " & Err.Description
													reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Text, sfailCnt)
													Err.Clear
											Else
													A_Text=Text&"."&Centtext
											End if
										Else
											A_Text=Text
										End If
										A_Text = ltrim(rtrim(A_Text))
									 If step_status = micPass Then
											On Error Resume Next
											If CCur(A_Text) = CCur(E_Text) Then
												If Err.Description <> "" Then
													Status = "FAILED"
													ExitScenario = "NO"
													Text = "Value in the field " & fn & " is " & A_Text
													reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Text, sfailCnt)
													Err.Clear

												Else
												Status = "PASSED"
												ExitScenario = "NO"
												Text = "Value in the field " & fn & " is " & A_Text
												reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Text, sfailCnt )
												End if
												' call reportet function giving the value as PASSED
											else
												Status = "FAILED"
												ExitScenario = "NO"
												Text = "Value in the field " & fn & " is " & A_Text
												reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Text, sfailCnt)
											End If
											
									 End If 
	
									 
							 Else
								 Text = ltrim(rtrim(Text))
								  If  step_status = micPass Then
										If fv = "BLANK" Then
											Text= trim(replace(Text,"-",""))
											If Text = "" Then
												Text ="BLANK"
											End If
                                   End If
									   If Text = fv Then
											Status = "PASSED"
											ExitScenario = "NO"
											Text = "Value in the field " & fn & " is " & Text
											reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Text, sfailCnt )
											' call reportet function giving the value as PASSED
										   else
											 Status = "FAILED"
											 ExitScenario = "NO"
											 Text = "Value in the field " & fn & " is " & Text
												reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Text, sfailCnt )
									   End If
								  else
									   status = "FAILED"
									   text =  "Screen '" &ScreenName&"'  On Which Action needs to be performed not found. Hence exiting the entire Test Scenario."
                                        ExitScenario = "YES"
										reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Text, sfailCnt )
										Exit For
								  End if
							 End If  
							 
				  Else
	
					  If ((instr(1,Comment,"Unable to find ScreenId")>0) or (instr(1,Comment,"Not on expected Screen")>0) ) Then
								status = "FAILED"
								Comment =   "Screen '" &ScreenName&"'  On Which Action needs to be performed not found. Hence exiting the entire Test Scenario."
								reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
								ExitScenario = "YES"
								Exit For
						Else
								status = "FAILED"
								reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
								ExitScenario = "NO"
						End If
					
				  End If

			End If
			  
		 Next
		 
	End If
	If  (ExitScenario <> "YES") and (ScreenName = "MPC" OR Message <> "") Then
		Call Message_Validation(Con_Screenmap,ScreenName,Action,TestCaseID,Message,objExcel_Act,Comment,sfailCnt,ExitScenario,ApplicationName)
	End If
  
End Function





''################################################################################################################################

'Function Name	LOGOFF
'Purpose	This function is used to LogOff from any screen.
'Input Parameters   			   1. ScreenName - Screen Name to validate if on correct screen
'													2. Action - Action that is performed
'												   3 TestCaseID - Test Case Id mentioned in the Test Data Sheet
'												  4 objExcel_Act - Environmental Variable set by Login_CC function
'Output Parameters 			 1	ExitScenario	Flag to check whether Scenario should exit or not
'												2	sfailCnt	To capture number of failures on a Scenario.

'################################################################################################################################

Public Function LOGOFF (ByVal Con_Screenmap,Byval ScreenName,Byval Action,ByVal TestCaseID,ByVal objExcel_Act,ByRef ExitScenario,ByRef sfailCnt,ByVal ApplicationName)

   Dim fn,fv,reportStatus,Text,Comment,status
	fn = DataTable.Value("FieldName1","DataSheet")
	fv=  ltrim(rtrim((DataTable.Value("FieldValue1","DataSheet"))))
    If  (ValidateScreen(Con_Screenmap,"Region",Comment)<>micPass) Then
			ObjScreen.SendKey TE_CLEAR
			WaitTillBusy
			ObjScreen.SendKey TE_CLEAR
			WaitTillBusy
			While ((ValidateScreen(Con_Screenmap,"Home",Comment)<>micPass) AND (ValidateScreen(Con_Screenmap,"Process_Initiator",Comment)<>micPass))
					ObjScreen.SendKey TE_CLEAR
					WaitTillBusy
			Wend
			ObjScreen.SetText 1,2, "CLEAR-TRANSID"
			WaitTillBusy
			ObjScreen.SendKey TE_ENTER
			WaitTillBusy
			ObjScreen.SetText 1,2, "LOGOFF "
			WaitTillBusy
			ObjScreen.SendKey TE_ENTER
			WaitTillBusy
			wait(5)
		   If  (ValidateScreen(Con_Screenmap,"Region",Comment)=micPass)Then
				status = "PASSED"
				text = "Logoff successful"
				ExitScenario  = "NO"
				reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Text, sfailCnt )
			Else
				status = "FAILED"
				text = "Logoff not successful"
				ExitScenario  = "NO"
				reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName, Action, TestCaseID, fn,fv,Status, Text, sfailCnt )
			End If
	Else 
			status = "PASSED"
			text = "Logoff successful"
			ExitScenario  = "NO"
			reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName, Action, TestCaseID, fn,fv,Status, Text, sfailCnt )
   End If
   
End Function

'################################################################################################################################

'Function Name	SessionConnect
'Purpose	This function is used if application has disconnected
'Input Parameters    	None	
'Output Parameters 			 1	ExitScenario	Flag to check whether Scenario should exit or not
'												2	Comment	Text to be reported in case of failures

'################################################################################################################################

Public Function SessionConnect(ByVal TestCaseID,ByVal objExcel_Act,Byref ExitScenario, Byref Comment)
   'Checking if Application has Disconnected
	'If Application has disconnected then 1) Connect to TE Session, 2) Set the ExitScenario Value as Y
	If (ObjScreen.Exist) = False Then
			If (TeWindow("TeWindow").WinMenu("Menu").exist)= True Then
				Window("Window").WinMenu("Menu").Select "Communication;Connect"
			 End If
			SystemUtil.Run "pcsws.exe", "tn3270.WS"
			WaitTillBusy
			wait(10)
	End if
End Function


'###################################################################################################################################

'Function Name	Exception_Handling
'Purpose	This function is used for exception handling 
'Input Parameters    	None	
'Output Parameters 		 1	ExitScenario	Flag to check whether Scenario should exit or not
'											2	Comment	Text to be reported in case of failures

'###################################################################################################################################


Public Function Exception_Handling(ByVal TestCaseID, Byval Action, ByVal objExcel_Act,Byref ExitScenario, Byref Comment, Byref ExceptionHandler, byref sfailCnt,ByVal ApplicationName)
   Dim Screen_Text,Status,reportStatus,ScreenName,fn,fv
	'Checking if Application has Disconnected
	'If Application has disconnected then 1) Connect to TE Session, 2) Set the ExitScenario Value as Y
	Call SessionConnect(TestCaseID,objExcel_Act,ExitScenario,Comment)
	'If Value of Exit Scenario is NO then validate ABEND
	If ucase(ExitScenario) = "NO" Then
		'Getting text from entire screen
		Screen_Text = Trim(ObjScreen.GetText())
		'Checking if Application has encountered an ABEND error
		'If Application has encountered an ABEND error then 1) Close all TeWindow application, 2) Open a new TE Session, 3) Set the ExitScenario Value as Y
		If instr(1,Screen_Text ,"ABEND") > 0 Then
            ExitScenario = "YES"
			Comment = "Application encountered ABEND Error."
			Status = "FAILED"
			reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
'			TeWindow("TeWindow").WinMenu("Menu").Select "File;Exit All"
'			SystemUtil.Run "pcsws.exe", "tn3270.WS"
			Call Exit_TE()
			ExceptionHandler = "YES"	
			sfailCnt = sfailCnt +1
			wait(10)

		elseIf instr(1,Screen_Text ,"COMMAND UNRECOGNIZED") > 0 Then
		   	Call SessionConnect(TestCaseID,objExcel_Act,ExitScenario,Comment)
			If UCASE(Action) = "LOGIN_CC" Then
				ExitScenario = "NO"
				Environment.Value("Login_CC_Flag") = "N"
			Else
		         ExitScenario = "YES"
			End If
				Comment = "Application encountered COMMAND UNRECOGNIZED Error."
				Status = "FAILED"
				reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
'				TeWindow("TeWindow").WinMenu("Menu").Select "File;Exit All"
'				SystemUtil.Run "pcsws.exe", "tn3270.WS"
				Call Exit_TE()
				ExceptionHandler = "YES"
				sfailCnt = sfailCnt +1
				WaitTillBusy
				wait(10)
			
		elseIf instr(1,Screen_Text ,"COMMAND SYNTAX") > 0 Then
			If UCASE(Action) = "LOGIN_CC" Then
				ExitScenario = "NO"
				Environment.Value("Login_CC_Flag") = "N"
			Else
		         ExitScenario = "YES"
			End If
                Status = "FAILED"
				Comment = "Application encountered COMMAND SYNTAX Error."
                reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID,  fn,fv,Status, Comment, sfailCnt )
'				TeWindow("TeWindow").WinMenu("Menu").Select "File;Exit All"
'				SystemUtil.Run "pcsws.exe", "tn3270.WS"
				Call Exit_TE()
				ExceptionHandler = "YES"
				sfailCnt = sfailCnt +1
				WaitTillBusy
				wait(10)
			
			
		elseIf instr(1,Screen_Text ,"Xpediter/CICS is not active") > 0 Then
			ExitScenario = "NO"
			Comment = "Application encountered Xpediter/CICS is not active Error."
			Status = "FAILED"
			reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
'			TeWindow("TeWindow").WinMenu("Menu").Select "File;Exit All"
'			SystemUtil.Run "pcsws.exe", "tn3270.WS"
			Call Exit_TE()
			ExceptionHandler = "YES"
			sfailCnt = sfailCnt +1
			wait(10)
			Environment.Value("Login_CC_Flag") = "N"

		elseIf instr(1,Screen_Text ,"Your userid is invalid.") > 0 Then
			ExitScenario = "NO"
			Comment = "Your userid is invalid."
			Status = "FAILED"
			reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
'			TeWindow("TeWindow").WinMenu("Menu").Select "File;Exit All"
'			SystemUtil.Run "pcsws.exe", "tn3270.WS"
			Call Exit_TE()
			ExceptionHandler = "YES"	
			sfailCnt = sfailCnt +1
			wait(10)
			Environment.Value("Login_CC_Flag") = "N"

		elseIf instr(1,Screen_Text ,"Your password is invalid") > 0 Then
			ExitScenario = "NO"
			Comment = "Your password is invalid."
			Status = "FAILED"
			reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
'			TeWindow("TeWindow").WinMenu("Menu").Select "File;Exit All"
'			SystemUtil.Run "pcsws.exe", "tn3270.WS"
			Call Exit_TE()
			ExceptionHandler = "YES"	
			sfailCnt = sfailCnt +1
			wait(10)
			Environment.Value("Login_CC_Flag") = "N"
			
		elseIf instr(1,Screen_Text ,"INVALID CONTROL TYPE") > 0 Then
           ExitScenario = "NO"
			Comment = "Application encountered INVALID CONTROL TYPE,"
			Status = "FAILED"
			reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
'			TeWindow("TeWindow").WinMenu("Menu").Select "File;Exit All"
'			SystemUtil.Run "pcsws.exe", "tn3270.WS"
			Call Exit_TE()
			ExceptionHandler = "YES"
			sfailCnt = sfailCnt +1
			WaitTillBusy
			wait(10)

		elseIf instr(1,Screen_Text ,"INVALID CONTROL LINE") > 0 Then
			ExitScenario = "YES"
			Comment = "Application encountered INVALID CONTROL LINE,"
			Status = "FAILED"
			reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
'			TeWindow("TeWindow").WinMenu("Menu").Select "File;Exit All"
'			SystemUtil.Run "pcsws.exe", "tn3270.WS"
			Call Exit_TE()
			ExceptionHandler = "YES"
			sfailCnt = sfailCnt +1
			WaitTillBusy
			wait(10)

		elseIf instr(1,Screen_Text ,"ADJSTR NOT SIGNED ON,") > 0 Then
             ExitScenario = "YES"
			Comment = "Application encountered ADJSTR NOT SIGNED ON,"
			Status = "FAILED"
			sfailCnt = sfailCnt +1
			reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
'			TeWindow("TeWindow").WinMenu("Menu").Select "File;Exit All"
'			SystemUtil.Run "pcsws.exe", "tn3270.WS"
			Call Exit_TE()
			ExceptionHandler = "YES"
			
			WaitTillBusy
			wait(10)


		elseIf instr(1,Screen_Text ,"ADJUSTER LOCKED OUT,") > 0 Then
             ExitScenario = "YES"
			Comment = "Application encountered ADJUSTER LOCKED OUT,"
			Status = "FAILED"
			sfailCnt = sfailCnt +1
			reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
'			TeWindow("TeWindow").WinMenu("Menu").Select "File;Exit All"
'			SystemUtil.Run "pcsws.exe", "tn3270.WS"
			Call Exit_TE()
			ExceptionHandler = "YES"
			
			WaitTillBusy
			wait(10)	
	
		elseIf instr(1,Screen_Text ,"CONTROL LINE CHANGED") > 0 Then
            ExitScenario = "YES"
			Comment = "Application encountered CONTROL LINE CHANGED"
			Status = "FAILED"
			reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
'			TeWindow("TeWindow").WinMenu("Menu").Select "File;Exit All"
'			SystemUtil.Run "pcsws.exe", "tn3270.WS"
			Call Exit_TE()
			ExceptionHandler = "YES"
			sfailCnt = sfailCnt +1
			WaitTillBusy
			wait(10)

		elseIf instr(1,Screen_Text ,"INVALID SIGN-ON") > 0 Then
            ExitScenario = "YES"
			Comment = "Application encountered INVALID SIGN-ON"
			Status = "FAILED"
			reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
'			TeWindow("TeWindow").WinMenu("Menu").Select "File;Exit All"
'			SystemUtil.Run "pcsws.exe", "tn3270.WS"
			Call Exit_TE()
			ExceptionHandler = "YES"
			sfailCnt = sfailCnt +1
			WaitTillBusy
			wait(10)
			
		elseIf instr(1,Screen_Text ,"CONTROL TYPE SEQUENCE") > 0 Then
           ExitScenario = "YES"
			Comment = "Application encountered CONTROL TYPE SEQUENCE"
			Status = "FAILED"
			reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
'			TeWindow("TeWindow").WinMenu("Menu").Select "File;Exit All"
'			SystemUtil.Run "pcsws.exe", "tn3270.WS"
			Call Exit_TE()
			ExceptionHandler = "YES"
			sfailCnt = sfailCnt +1
			WaitTillBusy
			wait(10)
			
		elseIf instr(1,Screen_Text ,"is not recognized") > 0 Then
            If UCASE(Action) = "LOGIN_CC" Then
				ExitScenario = "NO"
				Environment.Value("Login_CC_Flag") = "N"
			Else
		         ExitScenario = "YES"
			End If
			Comment = "Application encountered : is not recognized"
			Status = "FAILED"
			reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
'			TeWindow("TeWindow").WinMenu("Menu").Select "File;Exit All"
'			SystemUtil.Run "pcsws.exe", "tn3270.WS"
			Call Exit_TE()
			ObjScreen.Sync
			ExceptionHandler = "YES"
			WaitTillBusy
			sfailCnt = sfailCnt +1
			wait(10)

		elseIf instr(1,Screen_Text ,"NOT AUTHORIZED,") > 0 Then
			ExitScenario = "YES"
			Comment = "Application encountered NOT AUTHORIZED, exception"
			Status = "FAILED"
			reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
			reportStatus = Exit_TE()
'			TeWindow("TeWindow").WinMenu("Menu").Select "File;Exit All"
'			SystemUtil.Run "pcsws.exe", "tn3270.WS"
			Call Exit_TE()
            ObjScreen.Sync
			ExceptionHandler = "YES"
			WaitTillBusy
			sfailCnt = sfailCnt +1
			wait(10)
		elseIf instr(1,Screen_Text ,"CAPS (I) NOT READY.") > 0 Then
			ExitScenario = "YES"
			Comment = "Region Down CAPS (I) NOT READY."
			Status = "FAILED"
			reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
			reportStatus = Exit_TE()
'			TeWindow("TeWindow").WinMenu("Menu").Select "File;Exit All"
'			SystemUtil.Run "pcsws.exe", "tn3270.WS"
			ObjScreen.Sync
			ExceptionHandler = "YES"
			WaitTillBusy
			sfailCnt = sfailCnt +1
			Call Exit_TE()
            wait(10)

		elseIf instr(1,Screen_Text ,"CAPS (I) ENTER DATA, MODE ( ).") > 0 Then
			ExitScenario = "YES"
			Comment = "Region Down CAPS (I) ENTER DATA, MODE ( )."
			Status = "FAILED"
			reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
			reportStatus = Exit_TE()
'			TeWindow("TeWindow").WinMenu("Menu").Select "File;Exit All"
'			SystemUtil.Run "pcsws.exe", "tn3270.WS"
			ObjScreen.Sync
			ExceptionHandler = "YES"
			WaitTillBusy
			sfailCnt = sfailCnt +1
			Call Exit_TE()
            wait(10)	

			elseIf instr(1,Screen_Text ,"ID ALREADY SIGNED ON") > 0 Then
			ExitScenario = "YES"
			Comment = "ID ALREADY SIGNED ON."
			Status = "FAILED"
			reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
			ObjScreen.Sync
			ExceptionHandler = "YES"
			WaitTillBusy
			sfailCnt = sfailCnt +1
			Call Exit_TE()
            wait(10)
									
		Else
			'If Application is in Ready state Set the ExitScenario Value as N
			ExitScenario = "NO"
		End If
	End If
	
End Function



''*****************************************************************************************************************************************************************
''Function Name: Capture_Screen
''Input Parameters:TestCaseID,DataRow,sAction,step_status
''Output Parameters:None
''Description: This function is used to Capture Screen Shot and store it in a defined path
''********************************************************************************************************************************************************************

'Public Function Capture_Screen(ByVal TestCaseID,ByVal DataRow,ByVal step_status)
'
'   If ucase(Environment.Value("CaptureAllScreens"))="ALWAYS" Then
'	   ObjScreen.Sync(0)
'					On error resume next
'					ObjScreen.CaptureBitmap Environment.Value("ScreenShotFolderPath")&"\"&TestCaseID&"_"&DataRow&".png",True
'				elseif (ucase(Environment.Value("CaptureAllScreens"))="ON ERROR") AND (step_status="FAILED") then
'					On error resume next
'					ObjScreen.CaptureBitmap Environment.Value("ScreenShotFolderPath")&"\"&TestCaseID&"_"&DataRow&".png",True
'	End If
'				
'End Function

'################################################################################################################################

'Function Name	Message_Validation
'Purpose	This function is used to validate Error & Warning Messages & Functional Error Messages
'Input Parameters    			   1. ScreenName - Screen Name to validate if on correct screen
'													2. Action - Action that is performed
'													3. TestCaseID - Test Case Id mentioned in the Test Data Sheet
'													4. Message - Error message to be validated
'Output Parameters           	1. Comment	- Text to be reported in case of failures

'################################################################################################################################

Public Function Message_Validation (Byval Con_Screenmap,Byval ScreenName,Byval Action,ByVal TestCaseID,ByVal Message,ByVal objExcel_Act, ByRef Comment,ByRef sfailCnt,ByRef ExitScenario,ByVal ApplicationName)
   Dim Case_Option, Text, Text1, Text2, Comma, strlength, CommaExists, ActualMessage, DupText, Flag, ExpectedMessage, ExpectedStrLen, ActualMessageTemp, StartPos,i,Status,fn,fv,Text10Char,TextSpace
   Dim reportStatus,PartMessage,MessageLen, counter,ScreenCount,worksheetname1,currRow,dtRow
   Dim fso, ErrorFolder1
   Dim TestStepIDNbr,TestStepIDNbr_tmp
    counter = 1
	'If Message consists of pipe sign "|" sign Message is validated by Case 1 else its validated by Case 2
	'Validation will be done by Case 3  if screen is MHI
	fn = "Expected Message"
	fv = Message
	ScreenCount = 1
	If ValidateScreen(Con_Screenmap,ScreenName,Comment)=micPass Then
		If ApplicationName = "STBK" Then
			Case_Option = "4"
        ElseIf ScreenName = "MHI" Then
			Case_Option = "3"
		ElseIf ScreenName = "MPC" Then
			Case_Option = "1"
		Else
			Case_Option = "2"
        End if
		Select Case Case_Option
			'Case 1 to validate Error & Warning Messages 
			Case "1"
				' Code to concatenate error message appearing in application
'				'get the current row where script can start writing
'				worksheetname1 = "DetailedSheet"
'				currRow=objExcel_Act.Worksheets(worksheetname1).usedrange.rows.count 
'				dtRow = currRow +1
'				Set fso = CreateObject("Scripting.FileSystemObject")
'				Environment.Value("ErrorWarningScreenShotFolderPath") = Environment.Value("ErrorWarningScreenShotFolderPath")&"\"&TestCaseID
'				Set ErrorFolder1 = fso.CreateFolder (Environment.Value("ErrorWarningScreenShotFolderPath"))
'				Set fso = nothing
'				Set ErrorFolder1 = nothing
				Do 
					Text = ObjScreen.GetText (24,2,24,80)
					 If instr(1,LEFT(Trim(Text),1),"W") = 0 AND  instr(1,LEFT(Trim(Text),1),"E") = 0 Then
						Text = RTrim(Text)
					Else
						Text = Trim(Text)
					 End If
					WaitTillBusy
					Comma = right(Text,1)
					
					Text1 = Trim(ObjScreen.GetText (24,3,24,80))
					Text10Char = Trim(ObjScreen.GetText (24,3,24,13))
					WaitTillBusy
					Text1 = Split(Text1,",")
					'If Text doesn't contain a "," then CommaExists is set to No else its set to Yes
					If Comma <> "," Then
						strlength = Len(Text1( Ubound(Text1)))
						CommaExists = "No"
					Else
						CommaExists = "Yes"
					End If
					'Validates if 1st warning or error message exists in the concatenated string & Transmits
					If instr(1,ActualMessage,Text10Char)=0 Then
'                   'To capture screenshots for each screen incase of warning & error validation
						ObjScreen.Sync(0)
						WaitTillBusy
'						currRow=objExcel_Act.Worksheets(worksheetname1).usedrange.rows.count   
'						TestStepIDNbr_tmp = split(objExcel_Act.Worksheets(worksheetname1).Cells(currRow,1),"_")
'						TestStepIDNbr = TestStepIDNbr_tmp(1)+1
'						TestStepIDNbr = "Step_" & TestStepIDNbr
'						ObjScreen.CaptureBitmap Environment.Value("ErrorWarningScreenShotFolderPath")&"\"&"Validation Message for MPC Screen for Row  "&TestStepIDNbr&"_"&ScreenCount&".png",True
                        ObjScreen.SendKey TE_ENTER
'						WaitTillBusy
'						ScreenCount = ScreenCount +1
'						ErrorScreenShotFlag = "YES"
						WaitTillBusy
						'If CommaExists is "No" then Get text warning error message text & validate if duplicate text exists in the next line of error message
						'If Duplicate Text exists then remove the duplicate text from the string
						'Else keep the same string
						If CommaExists = "No" Then
							DupText = Trim(ObjScreen.GetText (24,3,24,80))
							DupText = Left(DupText,strlength)
							If instr(1,DupText,Trim(Text1(Ubound(Text1))))>0  Then
			                                    Text2 = Left(Text,len(Text)-strlength)
							Else
			                                    Text2 = Text
							End If
						Else
		                                    Text2 = Text
						End If
						'Concatenate new string with the concatenated string to get the complete string
						ActualMessage = ActualMessage & Text2
						Flag = "Continue"
					Else
						Flag = "Stop"
					End If
				Loop While Flag = "Continue"
				'----------------------------------------------------
				
            'To validate Part message in MPC Screen
			Environment.Value("ScreenCount") = ScreenCount
			If left(UCase(Message),5) = "PART:"  or left(UCase(Message),6) = "PART :" Then
				Message = Trim(Message)
				MessageLen = Len(Message)
				If instr(1,UCase(Message),"PART:") <> 0 Then
					PartMessage = right(Message,MessageLen-5)
				Else
					PartMessage = right(Message,MessageLen-6)							
				End If
				If instr(1,Ucase(ActualMessage),Trim(Ucase(PartMessage)))<>0 Then
					Status = "PASSED"
					fn = "Expected Message"
					fv = Trim(Ucase(PartMessage))
					Comment = "Expected message: "& Trim(Ucase(PartMessage))& " exists in Actual Message: " & ActualMessage
					reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
                    Message_Validation = MicPass
				Else
					Status = "FAILED"
					fn = "Expected Message"
					fv = Trim(Ucase(PartMessage))
					Comment ="Expected message: "& Trim(Ucase(PartMessage))& " doesn't exist in Actual Message: " & ActualMessage
					reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
					Message_Validation = MicFail
				End If
			Else
				If Trim(Ucase(Message)) = Trim(Ucase(ActualMessage)) Then
					Status = "PASSED"
					fn = "Expected Message"
					fv = Trim(Ucase(Message))
					Comment = "Actual and Expected message match. Actual Message: " & ActualMessage
					reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
                    Message_Validation = MicPass
				Else
					Status = "FAILED"
					fn = "Expected Message"
					fv = Trim(Ucase(Message))
					Comment ="Mismatch in Actual and Expected messages. Actual Message: " & ActualMessage
					reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
					Message_Validation = MicFail
				End If
			End If
			'Case 2 to validate functional validation messages
			Case "2"
				ActualMessage = Trim(ObjScreen.GetText (24,2,24,80))
				WaitTillBusy
                'To validate Part message in Other Screens
				If left(UCase(Message),5) = "PART:"  or left(UCase(Message),6) = "PART :" Then
					Message = Trim(Message)
					MessageLen = Len(Message)
					If instr(1,UCase(Message),"PART:") <> 0 Then
						PartMessage = right(Message,MessageLen-5)
					Else
						PartMessage = right(Message,MessageLen-6)							
					End If
                If instr(1,Ucase(ActualMessage),Trim(Ucase(PartMessage)))<>0 Then
						Status = "PASSED"
						fn = "Expected Message"
						fv = Trim(Ucase(PartMessage))
						Comment = "Expected message: "& Trim(PartMessage)& " exists in Actual Message: " & ActualMessage
						reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
						Message_Validation = MicPass
					Else
						Status = "FAILED"
						fn = "Expected Message"
						fv = Trim(Ucase(PartMessage))
						Comment ="Expected message: "& Trim(Ucase(PartMessage))& " doesn't exist in Actual Message: " & ActualMessage
						reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
						Message_Validation = MicFail
					End If
				Else
					If Trim(Ucase(ActualMessage)) = Trim(Ucase(Message)) Then
						Status = "PASSED"
						fn = "Expected Message"
						fv = Trim(Ucase(Message))
						Comment = "Actual and Expected message match.  Actual Message: " & ActualMessage
						reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
						Message_Validation = MicPass
					Else
						Status = "FAILED"
						fn = "Expected Message"
						fv = Trim(Ucase(Message))
						Comment ="Mismatch in Actual and Expected messages. Actual Message: " & ActualMessage
						reportStatus=appendValidationSheet(objExcel_Act, ScreenName,ApplicationName, Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
						Message_Validation = MicFail
					End If
				End If
			'Case 3 to validate MHI functional validation messages
			Case "3"
				Do
					If counter <> 1 Then
						ObjScreen.SendKey TE_ENTER
						WaitTillBusy
					End If
					ActualMessage = Trim(ObjScreen.GetText (24,2,24,80))
                    WaitTillBusy
					'To validate Part message in MHIScreen
					If left(UCase(Message),5) = "PART:"  or left(UCase(Message),6) = "PART :" Then
						Message = Trim(Message)
						MessageLen = Len(Message)
						If instr(1,UCase(Message),"PART:") <> 0 Then
							PartMessage = right(Message,MessageLen-5)
						Else
							PartMessage = right(Message,MessageLen-6)							
						End If
                        If instr(1,Ucase(ActualMessage),Trim(Ucase(PartMessage)))<>0 Then
							Status = "PASSED"
							fn = "Expected Message"
							fv = Trim(Ucase(PartMessage))
							Comment = "Expected message: "& Trim(Ucase(PartMessage))& " exists in Actual Message: " & ActualMessage
							reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
							Message_Validation = MicPass
							Exit Function
						Else
							Status = "FAILED"
							fn = "Expected Message"
							fv = Trim(Ucase(PartMessage))
                            Comment ="Expected message: "& Trim(Ucase(PartMessage))& " doesn't exist in Actual Message: " & ActualMessage
                            Message_Validation = MicFail
						End If
					Else
						If Trim(Ucase(ActualMessage)) = Trim(Ucase(Message)) Then
							Status = "PASSED"
							fn = "Expected Message"
							fv = Trim(Ucase(Message))
							Comment = "Actual and Expected message match.  Actual Message: " & ActualMessage
							reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
							Message_Validation = MicPass
							Exit Function
						Else
							Status = "FAILED"
							fn = "Expected Message"
							fv = Trim(Ucase(Message))
							Comment ="Mismatch in Actual and Expected messages. Actual Message: " & ActualMessage
                            Message_Validation = MicFail
						End If
					End If
					If ObjScreen.GetText (2,2,2,4) = "MHI" Then
						reportStatus=appendValidationSheet(objExcel_Act, ScreenName,ApplicationName, Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
					End If
					counter = counter+1
				Loop While ObjScreen.GetText (2,2,2,4) <> "MHI"

			Case "4"
				ActualMessage = Trim(ObjScreen.GetText (23,2,23,80))
				WaitTillBusy
				'To validate Part message in Other Screens
				If left(UCase(Message),5) = "PART:"  or left(UCase(Message),6) = "PART :" Then
					Message = Trim(Message)
					MessageLen = Len(Message)
					If instr(1,UCase(Message),"PART:") <> 0 Then
						PartMessage = right(Message,MessageLen-5)
					Else
						PartMessage = right(Message,MessageLen-6)							
					End If
                If instr(1,Ucase(ActualMessage),Trim(Ucase(PartMessage)))<>0 Then
						Status = "PASSED"
						fn = "Expected Message"
						fv = Trim(Ucase(PartMessage))
						Comment = "Expected message: "& Trim(PartMessage)& " exists in Actual Message: " & ActualMessage
						reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
						Message_Validation = MicPass
					Else
						Status = "FAILED"
						fn = "Expected Message"
						fv = Trim(Ucase(PartMessage))
						Comment ="Expected message: "& Trim(Ucase(PartMessage))& " doesn't exist in Actual Message: " & ActualMessage
						reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
						Message_Validation = MicFail
					End If
				Else
					If Trim(Ucase(ActualMessage)) = Trim(Ucase(Message)) Then
						Status = "PASSED"
						fn = "Expected Message"
						fv = Trim(Ucase(Message))
						Comment = "Actual and Expected message match.  Actual Message: " & ActualMessage
						reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
						Message_Validation = MicPass
					Else
						Status = "FAILED"
						fn = "Expected Message"
						fv = Trim(Ucase(Message))
						Comment ="Mismatch in Actual and Expected messages. Actual Message: " & ActualMessage
						reportStatus=appendValidationSheet(objExcel_Act, ScreenName,ApplicationName, Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
						Message_Validation = MicFail
					End If
				End If
		End Select
		ExitScenario = "NO" 
	Else
		Status = "FAILED"
		Comment = "Not on Expected screen. Hence exiting the entire Test Scenario."
		ExitScenario = "YES" 
		reportStatus=appendValidationSheet(objExcel_Act, ScreenName,ApplicationName, Action, TestCaseID, fn,fv,Status, Comment, sfailCnt )
	End If
End Function
'######################################################################################################
''*****************************************************************************************************************************************************************
''Function Name: AddSheet_Report
''Input Parameters:sFunction
''Output Parameters:sfileName
''Description: This function is used to create the excel file for both Detailed and Summarysheet Report. And also generates the columns in both sheet.
''********************************************************************************************************************************************************************

	Public function addsheets_Report(ByVal ResultFolderPath, byval sFunction,byref sfileName)

	Dim xlApp,xlWorkbook,xlWorksheet,myrange,i,j,SumStr,SelectedColumn,xlWorksheet_Sumry
	Dim hr,min,sec,dtTemp,szMonth,szDay,szYear,MyTime1,szDayName,total
	
	Set xlApp = CreateObject("Excel.Application")
	xlApp.Visible = True
	set xlWorkbook = xlApp.WorkBooks.Add

	''Code to create the Summary Report Sheet

	set xlWorksheet_Sumry = xlWorkBook.Worksheets.Add
	xlWorksheet_Sumry.Name="SummarySheet"
	
	'' creating the Header
	xlWorksheet_Sumry.Range("A1:E1").HorizontalAlignment = -4108
	
    xlWorksheet_Sumry.Cells(1,1)="S.No"
	xlWorksheet_Sumry.Cells(1,1).Font.Bold=True
	xlWorksheet_Sumry.Cells(1,1).Interior.ColorIndex = 1
	xlWorksheet_Sumry.Cells(1,1).ColumnWidth = 5
	xlWorksheet_Sumry.Cells(1,1).Font.ColorIndex = 2    
	      
	xlWorksheet_Sumry.Cells(1,2)="TD Test Case Name"
	xlWorksheet_Sumry.Cells(1,2).Font.Bold=True
	xlWorksheet_Sumry.Cells(1,2).Interior.ColorIndex = 1
	xlWorksheet_Sumry.Cells(1,2).ColumnWidth =20
	xlWorksheet_Sumry.Cells(1,2).Font.ColorIndex = 2          
	
	xlWorksheet_Sumry.Cells(1,3)="Start Time"
	xlWorksheet_Sumry.Cells(1,3).Font.Bold=True
	xlWorksheet_Sumry.Cells(1,3).Interior.ColorIndex = 1
	xlWorksheet_Sumry.Cells(1,3).ColumnWidth =12
	xlWorksheet_Sumry.Cells(1,3).Font.ColorIndex = 2          
	
	xlWorksheet_Sumry.Cells(1,4)="End Time"
	xlWorksheet_Sumry.Cells(1,4).Font.Bold=True
	xlWorksheet_Sumry.Cells(1,4).ColumnWidth = 12
	xlWorksheet_Sumry.Cells(1,4).Interior.ColorIndex = 1
	xlWorksheet_Sumry.Cells(1,4).Font.ColorIndex = 2      
	
	xlWorksheet_Sumry.Cells(1,5)="Status"
	xlWorksheet_Sumry.Cells(1,5).Font.Bold=True
	xlWorksheet_Sumry.Cells(1,5).ColumnWidth = 10
	xlWorksheet_Sumry.Cells(1,5).Interior.ColorIndex = 1
	xlWorksheet_Sumry.Cells(1,5).Font.ColorIndex = 2   


	''Code to create the DetailedSheet Report 
	set xlWorksheet = xlWorkBook.Worksheets.Add
    xlWorksheet.Name="DetailedSheet"

    '' creating the Header
	xlWorksheet.Range("A1:J1").HorizontalAlignment = -4108
	
	xlWorksheet.Cells(1,1)="TestStepID"
	xlWorksheet.Cells(1,1).Font.Bold=True
	xlWorksheet.Cells(1,1).Interior.ColorIndex = 1
	xlWorksheet.Cells(1,1).ColumnWidth = 10
	xlWorksheet.Cells(1,1).Font.ColorIndex = 2    
	      
	xlWorksheet.Cells(1,2)="TDTest Case Name"
	xlWorksheet.Cells(1,2).Font.Bold=True
	xlWorksheet.Cells(1,2).Interior.ColorIndex = 1
	xlWorksheet.Cells(1,2).ColumnWidth =20
	xlWorksheet.Cells(1,2).Font.ColorIndex = 2

	xlWorksheet.Cells(1,3)="Application Name"
	xlWorksheet.Cells(1,3).Font.Bold=True
	xlWorksheet.Cells(1,3).Interior.ColorIndex = 1
	xlWorksheet.Cells(1,3).ColumnWidth =20
	xlWorksheet.Cells(1,3).Font.ColorIndex = 2                   
	
	xlWorksheet.Cells(1,4)="Test Step"
	xlWorksheet.Cells(1,4).Font.Bold=True
	xlWorksheet.Cells(1,4).Interior.ColorIndex = 1
	xlWorksheet.Cells(1,4).ColumnWidth =25
	xlWorksheet.Cells(1,4).Font.ColorIndex = 2          
	
	xlWorksheet.Cells(1,5)="Screen"
	xlWorksheet.Cells(1,5).Font.Bold=True
	xlWorksheet.Cells(1,5).ColumnWidth = 10
	xlWorksheet.Cells(1,5).Interior.ColorIndex = 1
	xlWorksheet.Cells(1,5).Font.ColorIndex = 2      
	
	xlWorksheet.Cells(1,6)="Field"
	xlWorksheet.Cells(1,6).Font.Bold=True
	xlWorksheet.Cells(1,6).ColumnWidth = 20
	xlWorksheet.Cells(1,6).Interior.ColorIndex = 1
	xlWorksheet.Cells(1,6).Font.ColorIndex = 2      
	
	xlWorksheet.Cells(1,7)="Value"
	xlWorksheet.Cells(1,7).Font.Bold=True
	xlWorksheet.Cells(1,7).ColumnWidth = 10
	xlWorksheet.Cells(1,7).Interior.ColorIndex = 1
	xlWorksheet.Cells(1,7).Font.ColorIndex = 2      

	xlWorksheet.Cells(1,8)="Expected Result"
	xlWorksheet.Cells(1,8).Font.Bold=True
	xlWorksheet.Cells(1,8).ColumnWidth = 52
	xlWorksheet.Cells(1,8).Interior.ColorIndex = 1
	xlWorksheet.Cells(1,8).Font.ColorIndex = 2     

	xlWorksheet.Cells(1,9)="Actual Result"
	xlWorksheet.Cells(1,9).Font.Bold=True
	xlWorksheet.Cells(1,9).ColumnWidth = 60
	xlWorksheet.Cells(1,9).Interior.ColorIndex = 1
	xlWorksheet.Cells(1,9).Font.ColorIndex = 2     
	
	xlWorksheet.Cells(1,10)="Status"
	xlWorksheet.Cells(1,10).Font.Bold=True
	xlWorksheet.Cells(1,10).ColumnWidth = 10
	xlWorksheet.Cells(1,10).Interior.ColorIndex = 1
	xlWorksheet.Cells(1,10).Font.ColorIndex = 2 	

	xlWorksheet.Cells(1,11)="Screen Capture Link"
	xlWorksheet.Cells(1,11).Font.Bold=True
	xlWorksheet.Cells(1,11).ColumnWidth = 20
	xlWorksheet.Cells(1,11).Interior.ColorIndex = 1
	xlWorksheet.Cells(1,11).Font.ColorIndex = 2 	

	xlWorksheet.cells(1, 1).autofilter ''Filter on the result
 
	xlWorkBook.Worksheets("Sheet1").Delete
	xlWorkBook.Worksheets("Sheet2").Delete
	xlWorkBook.Worksheets("Sheet3").Delete

    ''' For TimeStamping in the file
	hr=Hour(now)
	min=Minute(now)
	sec=Second(now) 
	dtTemp = Date
	szMonth = left(MonthName(Month(dtTemp)),3)
	szDay = Day(dtTemp)
	szYear = Year(dtTemp)
    MyTime1=szMonth&"_"&szDay&"_"&szYear&"_"&hr&"_"&min&"_"&sec
	
	'' save the file with timestamp info
	sfilename=ResultFolderPath&"\"&sFunction&"_"&MyTime1&".xls"
	xlWorkbook.SaveAs sfilename
	xlApp.quit

End Function
								

   							
'*****************************************************************************************************************************************************************
''Function Name: AppendValidationSheet
''Input Parameters:objExcel_Act,sScreenName,sAction,sTestCaseID,sFieldName,sFieldValue,Result,Text,sLinkAddress
''Output Parameters:sfailCnt
''Description: This function is used to ENTER the data in the detailed sheet.
''********************************************************************************************************************************************************************
	Public function  appendValidationSheet (byval objExcel_Act, ByVal sScreenName, ByVal sApplicationName, ByVal sAction, ByVal sTestCaseID, ByVal sFieldName,ByVal sFieldValue, ByVal Result, Byval Text,byRef sfailCnt)

  Dim TestStepIDNbr,worksheetname1,ExpectedResult,Action,currRow,dtRow,TestStepID,var_addr,cellAlign,TestStepIDNbr_tmp,iColumnCount,DataTableRow
'    Dim FileSysObj,ErrorFolder1
   '' Prepare for the ActualResult and ExpectedResult based on the Action perform
		worksheetname1 = "DetailedSheet"

		Select Case UCASE(sAction)
			Case "INPUT"
				ExpectedResult ="The text '" & sFieldValue & "' is set in the Field "&  sFieldName
				Action = sAction & " " &  sFieldName
			Case "VALIDATE"   	
				ExpectedResult = "Value in Field '" & sFieldName & "' is " & sFieldValue
				Action = "Validate Data"
			Case "SEARCH"
				If sScreenName = "EMC_Status" Then
						ExpectedResult = "The FLN/Suffix "& sFieldValue  & "  exists."
				ElseIf sScreenName = "ARI" Then
						ExpectedResult = "Search Values given for ARI screen exists."
				ElseIf sScreenName = "PAI" Then
						ExpectedResult = "Search Values given for PAC screen exists."
				End If
				Action = "SEARCH"
			Case "LOGOFF"	
				ExpectedResult = "Session Logged Off."
				Action = "LOGOFF"
			Case "LOGIN_CC"
				ExpectedResult = "The text '" & sFieldValue & "' is set in the Field "&  sFieldName
				Action = "LOGIN_CC"
			Case "LOGOFF_CC"	
				ExpectedResult = "Logoff from Code Coverage successful"
				Action = "LOGOFF_CC"
			Case "LOGOFF_STBK"	
				ExpectedResult = "Logoff from STBK successful"
				Action = "LogOff STBK"
				
		End Select

		If  ucase(Result) = "FAILED" Then
			sfailCnt =sfailCnt+1

		''In case if some mandatory fields are left blank
			
		End If

		''get the current row where script can start write
        currRow=objExcel_Act.Worksheets(worksheetname1).usedrange.rows.count 
		 dtRow = currRow + 1

		 ''=========================
		 If objExcel_Act.Worksheets(worksheetname1).Cells(dtRow-1,2) <>  trim(sTestCaseID) Then
			TestStepIDNbr = 1
		Else
			TestStepIDNbr_tmp = split(objExcel_Act.Worksheets(worksheetname1).Cells(dtRow-1,1),"_")
			TestStepIDNbr = TestStepIDNbr_tmp(1)+1
		End If
		''=========================
		'' Enter values in the all columns
		
		TestStepID = "Step_" & TestStepIDNbr
		objExcel_Act.Worksheets(worksheetname1).Cells(dtRow,1) = trim(TestStepID)
		objExcel_Act.Worksheets(worksheetname1).Cells(dtRow,2) = trim(sTestCaseID)
		objExcel_Act.Worksheets(worksheetname1).Cells(dtRow,3) = trim(sApplicationName)
		objExcel_Act.Worksheets(worksheetname1).Cells(dtRow,4) = trim(Action)                                                              
		objExcel_Act.Worksheets(worksheetname1).Cells(dtRow,5) = trim(sScreenName)
		objExcel_Act.Worksheets(worksheetname1).Cells(dtRow,6) = trim(sFieldName)
		objExcel_Act.Worksheets(worksheetname1).Cells(dtRow,7) = trim(sFieldValue)
		objExcel_Act.Worksheets(worksheetname1).Cells(dtRow,8) = trim(ExpectedResult)
		objExcel_Act.Worksheets(worksheetname1).Cells(dtRow,9) = trim(Text)
		objExcel_Act.Worksheets(worksheetname1).Cells(dtRow,10) = trim(Result)
		 If instr(1,trim(Result),"FAILED")<>0 Then
			   If ucase(Environment.Value("CaptureAllScreens")) <>  "NEVER" Then
				   'In case of ErrorWarning Message Validation SnapShotLink pointing to the folder
'					If ErrorScreenShotFlag = "YES" Then
'						objExcel_Act.Worksheets(worksheetname1).Cells(dtRow,10) = "SnapShot Link"
'						objExcel_Act.Worksheets(worksheetname1).Cells(dtRow,9).Interior.ColorIndex = 3
'						var_addr = objExcel_Act.Worksheets(worksheetname1).Cells(dtRow,10).address(false,false)
'						wait (3)
'						objExcel_Act.Worksheets(worksheetname1).Hyperlinks.Add objExcel_Act.Range(var_addr), Environment.Value("ErrorWarningScreenShotFolderPath")
'						If instr(1,trim(Result),"PASSED")<>0 Then
'							'Code to delete folder
'	                        Set FileSysObj = CreateObject("Scripting.FileSystemObject")
'							Set ErrorFolder1 = FileSysObj.GetFolder(Environment.Value("ErrorWarningScreenShotFolderPath"))
'							ErrorFolder1.Delete
'							set FileSysObj = nothing
'							set ErrorFolder1 = nothing
'						End If
'					Else
						ObjScreen.Sync(0)
						On error resume next
						currRow=objExcel_Act.Worksheets(worksheetname1).usedrange.rows.count   
						TestStepIDNbr_tmp = split(objExcel_Act.Worksheets(worksheetname1).Cells(currRow,1),"_")
'						TestStepIDNbr = TestStepIDNbr_tmp(1)
'						TestStepIDNbr = "Step_" & TestStepIDNbr
						DataTableRow = DataTable.GetSheet("DataSheet").GetCurrentRow
						If Environment.Value("Transmit") = "Y" or Environment.Value("F8") = "Y" or Environment.Value("F7") = "Y" or DataTableRow <> DataTableRow_Prev  Then
							If DataTableRow <> DataTableRow_Prev Then
								Environment.Value("Transmit") = "N"
								Environment.Value("F8") = "N"
								Environment.Value("F7") = "N"
							End If
							TestStepIDNbr = TestStepIDNbr_tmp(1)
                            TestStepIDNbr = "Step_" & TestStepIDNbr
							TestStepIDNbr_prev = TestStepIDNbr
                            DataTableRow_Prev = DataTableRow
							ObjScreen.CaptureBitmap Environment.Value("ScreenShotFolderPath")&"\"&sTestCaseID&"_"&TestStepIDNbr&".png",True
                        Else
							TestStepIDNbr = TestStepIDNbr_prev
						End If
						objExcel_Act.Worksheets(worksheetname1).Cells(dtRow,11) = "SnapShot Link"
						objExcel_Act.Worksheets(worksheetname1).Cells(dtRow,10).Interior.ColorIndex = 3
						var_addr = objExcel_Act.Worksheets(worksheetname1).Cells(dtRow,11).address(false,false)
						wait (3)
						objExcel_Act.Worksheets(worksheetname1).Hyperlinks.Add objExcel_Act.Range(var_addr), Environment.Value("ScreenShotFolderPath")&"\"&sTestCaseID&"_"&TestStepIDNbr&".png" 
'					End If
				Else
					objExcel_Act.Worksheets(worksheetname1).Cells(dtRow,10).Interior.ColorIndex = 3
				End If
		Else
				objExcel_Act.Worksheets(worksheetname1).Cells(dtRow,11) = ""
				 If ucase(Environment.Value("CaptureAllScreens")) =  "ALWAYS"  Then
'					 If ErrorScreenShotFlag = "YES" Then
'						objExcel_Act.Worksheets(worksheetname1).Cells(dtRow,10) = "SnapShot Link"
'                        var_addr = objExcel_Act.Worksheets(worksheetname1).Cells(dtRow,10).address(false,false)
'						wait (3)
'						objExcel_Act.Worksheets(worksheetname1).Hyperlinks.Add objExcel_Act.Range(var_addr), Environment.Value("ErrorWarningScreenShotFolderPath")
'					Else
						ObjScreen.Sync(0)

						currRow=objExcel_Act.Worksheets(worksheetname1).usedrange.rows.count   
						TestStepIDNbr_tmp = split(objExcel_Act.Worksheets(worksheetname1).Cells(currRow,1),"_")
						TestStepIDNbr = TestStepIDNbr_tmp(1)
						TestStepIDNbr = "Step_" & TestStepIDNbr
						ObjScreen.CaptureBitmap Environment.Value("ScreenShotFolderPath")&"\"&sTestCaseID&"_"&TestStepIDNbr&".png",True
						objExcel_Act.Worksheets(worksheetname1).Cells(dtRow,11) = "SnapShot Link"

						var_addr = objExcel_Act.Worksheets(worksheetname1).Cells(dtRow,11).address(false,false)
						wait (3)
						objExcel_Act.Worksheets(worksheetname1).Hyperlinks.Add objExcel_Act.Range(var_addr), Environment.Value("ScreenShotFolderPath")&"\"&sTestCaseID&"_"&TestStepIDNbr&".png" 
'					End If
'				ElseIf ErrorScreenShotFlag = "YES" Then
'					'Code to delete folder
'                        Set FileSysObj = CreateObject("Scripting.FileSystemObject")
'						Set ErrorFolder1 = FileSysObj.GetFolder(Environment.Value("ErrorWarningScreenShotFolderPath"))
'								ErrorFolder1.Delete
'						set FileSysObj = nothing
'						set ErrorFolder1 = nothing
			End If
        End If

		iColumnCount = objExcel_Act.Worksheets(worksheetname1).UsedRange.Columns.Count
		For cellAlign = 1 to iColumnCount
			var_addr = objExcel_Act.Worksheets(worksheetname1).Cells(dtRow,cellAlign).address(false,false)
			objExcel_Act.Worksheets(worksheetname1).Range(var_addr).HorizontalAlignment = -4108
		Next
 	
		objExcel_Act.ActiveWorkbook.Save 

'	Environment.Value("ErrorWarningScreenShotFolderPath") = Environment.Value("ScreenShotFolderPath")&"\Warning_Error_Message_ScreenShots"
'	ErrorScreenShotFlag = ""
End Function




''*****************************************************************************************************************************************************************
''Function Name: AppendSummarySheet
''Input Parameters:objExcel_Act,  sTestCaseID,  stTimr
''Output Parameters: endTimr,  sfailCnt
''Description: This function is used to ENTER the data in the Summary sheet.
''********************************************************************************************************************************************************************

  Public function  appendSummarySheet (byval objExcel_Act, byval sTestCaseID, byref stTimr, byref endTimr, byref sfailCnt)

	 Dim srNbr,worksheetname1,dtRow,currRow,cellAlign,var_addr
	 worksheetname1 = "SummarySheet"
	 
	 ''get the current row where script can start write
	 currRow=objExcel_Act.Worksheets(worksheetname1).usedrange.rows.count 
	
	 dtRow = currRow+1
	 
	 '' Enter values in the all columns
	 srNbr = currRow
	 objExcel_Act.Worksheets(worksheetname1).Cells(dtRow,1) = trim(srNbr)
	 objExcel_Act.Worksheets(worksheetname1).Cells(dtRow,2) = trim(sTestCaseID)
	 objExcel_Act.Worksheets(worksheetname1).Cells(dtRow,3) = trim(stTimr)   
	 endTimr =  Hour(now)&":"&Minute(now)&":"&Second(now)                                                              
	 objExcel_Act.Worksheets(worksheetname1).Cells(dtRow,4) = trim(endTimr)     

		''If the sfailCnt>0 then mark this testcass as Failed
	 If sfailCnt>0 Then
		objExcel_Act.Worksheets(worksheetname1).Cells(dtRow,5) = "FAILED" 
		objExcel_Act.Worksheets(worksheetname1).Cells(dtRow,5).Interior.ColorIndex = 3    
	Else
		objExcel_Act.Worksheets(worksheetname1).Cells(dtRow,5) = "PASSED"     	
	 End If

	''code for center aligning the content
	For cellAlign = 1 to 5
		var_addr = objExcel_Act.Worksheets(worksheetname1).Cells(dtRow,cellAlign).address(false,false)
		objExcel_Act.Worksheets(worksheetname1).Range(var_addr).HorizontalAlignment = -4108
	Next
 
	 objExcel_Act.ActiveWorkbook.Save 

 
End Function




'################################################################################################################################

'Function Name	LogOff_CC
'Purpose	This function is used to Log off from Code Coverage, i.e. halting the Test, deleteing the test  & Logging off from application.
'Input Parameters    			   1. ScreenName - Screen Name to validate if on correct screen
'													2. Action - Action that is performed
'													3. TestCaseID - Test Case Id mentioned in the Test Data Sheet
'													4. Row_Num - Environmental Variable set by Login_CC function
'Output Parameters           	1. ExitScenario - Flag to check whether Scenario should exit or not

'################################################################################################################################

Public Function LogOff_CC (Byval Con_Screenmap,Byval ScreenName,Byval Action,byval objExcel_Act,ByVal TestCaseID, ByRef ExitScenario,ByRef sfailCnt,ByVal ApplicationName)
 Dim ScreenText,TestStatus,Status,Text
 Dim FN,FV,FNArr,FVArr,reportStatus,Comment
 Dim Clear_TransID, XpeditorDefH,CCTestName,CCTestName1,CCTestIdentifier,CCTestIdentifier1
 Dim i,StatusRecord,Row_Num
 'Validate If Login_CC has successfully executed
    If Environment.Value("Login_CC_Flag") = "Y" Then
  'If Screen is Process Initiator put PROI to navigate application to Home Page
  If ValidateScreen(Con_Screenmap,"Process_Initiator",Comment) = micPass Then
   ObjScreen.SetText 1,2, "PROI"
  End If
  'Hit Clear button till the time Home or ProcessInitiator Screen appears
  While (ValidateScreen(Con_Screenmap,"Home",Comment)<>micPass)
   ObjScreen.SendKey TE_CLEAR
   WaitTillBusy
  Wend
  'Type CLEAR-TRANSID
  ObjScreen.SetText 1,2, "CLEAR-TRANSID"
  ObjScreen.SendKey TE_ENTER
  WaitTillBusy
  WaitTillBusy
  Clear_TransID = ObjScreen.GetText(24,2,24,18)
  If Clear_TransID <> "CLEAR  COMPLETED." Then
   Status = "FAILED"
   Text = "Not on Expected Screen after Clear-TransID"
   reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, "Clear-TransID","Clear-TransID",Status, Text, sfailCnt )
            ExitScenario = "YES"
   LogOff_CC = MicFail
   Exit Function  
  End If
  ObjScreen.SendKey TE_CLEAR
  'Type XVCC to navigate to Xpeditor Primary Menu
  WaitTillBusy
  ObjScreen.SetText 1,2, "XVCC"
  ObjScreen.SendKey TE_ENTER
  WaitTillBusy
  'Check if Xpeditor Primary Menu has opened
  If (ValidateScreen(Con_Screenmap,"XpeditorPrimaryMenu",Comment)<>micPass) Then
   ScreenText = Trim(ObjScreen.GetText())
   If Instr(1,ScreenText,"Xpediter/CICS is not active") Then
    Status = "FAILED"
    Text = "Xpediter/CICS is not active"
    reportStatus=appendValidationSheet(objExcel_Act, "XpeditorPrimaryMenu", ApplicationName,Action, TestCaseID, "XpeditorPrimaryMenu","XpeditorPrimaryMenu",Status, Text, sfailCnt )
   Else
    Status = "FAILED"
    Text = "XpeditorPrimaryMenu Screen did not appear"
    reportStatus=appendValidationSheet(objExcel_Act, "XpeditorPrimaryMenu", ApplicationName,Action, TestCaseID, "XpeditorPrimaryMenu","XpeditorPrimaryMenu",Status, Text, sfailCnt )
   End If
   LogOff_CC = MicFail
   ExitScenario = "YES"
   Exit Function  
  Else
   'Set Value 1 in Command field
   ScreenName = "XpeditorPrimaryMenu"
   ObjScreen.SetText 2,15, "1"
   ObjScreen.SendKey TE_ENTER
   WaitTillBusy
   'Check if Xpeditor Test Definition has opened
   If (ValidateScreen(Con_Screenmap,"XpediterTestDef",Comment)<>micPass) Then
    Status = "FAILED"
    Text = "XpediterTestDef Screen did not appear"
                reportStatus=appendValidationSheet(objExcel_Act, "XpediterTestDef", ApplicationName,Action, TestCaseID, "XpediterTestDef","XpediterTestDef",Status, Text, sfailCnt )
    ExitScenario = "YES"
    LogOff_CC = MicFail
    Exit Function
   Else
    'Type H in front of the row corresponding to the current test
    'Row_Num will be an Environment Variable value of which will be populated by Login_CC Function
    ScreenName = "XpediterTestDef"
    'To search row number of record
    For i = 14 to 22
     StatusRecord = ObjScreen.GetText (i, 1, i, 80)
                    If instr (1, StatusRecord ,SystemName) >0 and  instr (1, StatusRecord ,TestIdentifier)>0 Then
      Row_Num = i
      Exit For
     End If
    Next
    ObjScreen.SetText Row_Num,3, "H"
    XpeditorDefH = ObjScreen.GetText(Row_Num,3,Row_Num,1)
    If XpeditorDefH <> "H" Then
     Status = "FAILED"
     Text = "Text 'H' not set"
     reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, "XpediterTestDef","XpediterTestDef",Status, Text, sfailCnt )
                    ExitScenario = "YES"
     LogOff_CC = MicFail
     Exit Function 
    End If
    ObjScreen.SendKey TE_ENTER
    WaitTillBusy
    'Get & validate the status of corresponding to the current test
    TestStatus = Trim(ObjScreen.GetText(Row_Num,52,Row_Num,64))
                'Get text for Test Name
    CCTestName = Trim(ObjScreen.GetText(Row_Num,7,Row_Num,22))
    CCTestIdentifier = Trim(ObjScreen.GetText(Row_Num,24,Row_Num,41))
    If TestStatus = "Quiescing" Then
     'If Status is Quiescing enter D
     ObjScreen.SetText Row_Num,3, "D"
     ObjScreen.SendKey TE_ENTER
     WaitTillBusy
     'Get text for Test Name again
     CCTestName1 = Trim(ObjScreen.GetText(Row_Num,7,Row_Num,22))
     CCTestIdentifier1 = Trim(ObjScreen.GetText(Row_Num,24,Row_Num,41))
     'Validate the Test Text
     If CCTestName = CCTestName1 and CCTestIdentifier = CCTestIdentifier1 Then
      Status = "FAILED"
      Text = "Record Not deleted"
      reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, "XpediterTestDef","XpediterTestDef",Status, Text, sfailCnt )     
                        LogOff_CC = MicFail
     End If
     'Type =X in Command field
     ObjScreen.SetText 2,15, "=X"
     ObjScreen.SendKey TE_ENTER
     WaitTillBusy
     'Get Screen Text & validate if End Of COde Coverage has appeared
     ScreenText = Trim(ObjScreen.GetText())
     If instr (1, ScreenText ,"End") >0 and  instr (1, ScreenText ,"Code")>0 and  instr (1, ScreenText ,"Coverage") >0 Then
      ObjScreen.SendKey TE_CLEAR
      WaitTillBusy
      ObjScreen.SetText 1,1, "OFF"
      ObjScreen.SendKey TE_ENTER
      WaitTillBusy
     Else
      Status = "FAILED"
      Text = "Session Not Ended"
      reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, "XpediterTestDef","XpediterTestDef",Status, Text, sfailCnt )     
                        ExitScenario = "YES"
      LogOff_CC = MicFail
      Exit Function
     End If
    Else
     Status = "FAILED"
     Text = "Current Status of the Test is " & Status
     reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, "XpediterTestDef","XpediterTestDef",Status, Text, sfailCnt )     
                    ExitScenario = "YES"
     LogOff_CC = MicFail
     Exit Function
    End If
   End If
  End If
  WaitTillBusy
  wait(5)
  If  (ValidateScreen(Con_Screenmap,"Region",Comment)=micPass)Then
   Status = "PASSED"
   Text = "Logoff from Code Coverage successful"
   ExitScenario  = "NO"
   reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, "XpediterTestDef","XpediterTestDef",Status, Text, sfailCnt )     
            LogOff_CC = MicPass
  Else
   Status = "FAILED"
   Text = "Logoff from Code Coverage was Unsuccessful"
   ExitScenario  = "NO"
   reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, "XpediterTestDef","XpediterTestDef",Status, Text, sfailCnt )     
   LogOff_CC = MicFail
  End If
 Else
  Status = "FAILED"
  Text = "Logoff from Code Coverage was Unsuccessful since Login_CC was not successful"
  ExitScenario  = "NO"
  reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, "XpediterTestDef","XpediterTestDef",Status, Text, sfailCnt )     
        LogOff_CC = MicFail
 End If
Environment.Value("Login_CC_Flag") = "N"
End Function



'################################################################################################################################

'Function Name	Login_CC
'Purpose	This function is used to Login into Code Coverage, i.e. Logging into application, Creating System Test Record & Starting the collection Process.
'Input Parameters    			   1. objExcel_Act - Excel Sheet Object
'Output Parameters           	1. Comment - Comment which is returned to detailed report
'													2. Row - Row of the field
'													3. Col - Column of the field
'													4. fieldlen - Field Length of the field
'													5. sfailCnt - Fail Counter

'################################################################################################################################

Public Function Login_CC(ByVal Con_Screenmap,ByVal TestCaseID , ByVal Action,ByVal objExcel_Act, ByRef Comment, ByRef Row,ByRef Col, ByRef fieldlen, ByRef sfailCnt,ByRef ExceptionHandler, ByRef ExitScenario,ByVal ApplicationName)
   Dim FN, FV, SysNameText,i,Status,Text, FNArr, FVArr,ScreenText,j,RegionTextMsg, CICS_TextMsg,XPedPrimeMenuText,StatusRecord, Row_Num, RecStatus
   Dim Login_CC_Flag,ScreenName,reportStatus,stepstatus
   Dim SystemName,TestIdentifier
	DataTable.GetSheet("Login_credentials").SetCurrentRow(2)

	If ExceptionHandler = "YES" Then'' if there is one login credentials serving the multiple test scenarios and one ExitScenarios occurs and now previous credential would be required to login
            FN = DataTable.Value("FieldName1","Login_credentials")
              FV = DataTable.Value("FieldValue1","Login_credentials")
			   For i = 2 to 11
                  FN = FN &","& Trim(DataTable.Value("FieldName"&i,"Login_credentials"))
				  FV = FV &","& Trim(DataTable.Value("FieldValue"&i,"Login_credentials"))
			   Next
  	Else
		
		   FN = Trim(DataTable.Value("FieldName1","DataSheet"))
			FV = Trim(DataTable.Value("FieldValue1","DataSheet"))
			DataTable.Value("FieldName1","Login_credentials") = FN
              DataTable.Value("FieldValue1","Login_credentials") = FV
			For i = 2 to 11
				FN = FN &","& Trim(DataTable.Value("FieldName"&i,"DataSheet"))
				DataTable.Value("FieldName"&i,"Login_credentials") = Trim(DataTable.Value("FieldName"&i,"DataSheet"))
				FV = FV &","& Trim(DataTable.Value("FieldValue"&i,"DataSheet"))
				DataTable.Value("FieldValue"&i,"Login_credentials") = Trim(DataTable.Value("FieldValue"&i,"DataSheet"))
				
			Next
			''Get the current value of Login_CC_Flag - environment variable
			   Login_CC_Flag =  Environment.Value("Login_CC_Flag") 
	End If

	FNArr = Split (FN,",")
	FVArr = Split (FV,",")
	'Setting Value in Region Screen
	ScreenName = "Region"
	stepstatus= SetText(Con_Screenmap,FNArr(0),  ScreenName,  FVArr(0),  Comment, row, col,  fieldlen)
	If stepstatus = micFail Then
		Environment.Value("Login_CC_Flag") = "N"
		Status = "FAILED"
		ExitScenario = "NO"
		Comment = Comment&" Hence skipping to next step"
		reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, FNArr(0),FVArr(0),Status, Comment, sfailCnt )
		 Exit Function
	Else
		Status = "PASSED"
		ExitScenario = "NO"
		Text = "Value in the field " & FNArr(0) & " has been set as " & FVArr(0)
		reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID,FNArr(0),FVArr(0),Status, Text, sfailCnt )
		Login_CC = MicPass
	End If
	ObjScreen.SendKey TE_ENTER
	WaitTillBusy
	Call  Exception_Handling(TestCaseID,Action,objExcel_Act,ExitScenario,Comment,ExceptionHandler,sfailCnt,ApplicationName)
	If ExceptionHandler = "YES" Then
		Exit Function
	End If
	
	'Setting Value in Process Initiator Screen
	ScreenName = "Process_Initiator"
	WaitTillBusy
	stepstatus= SetText(Con_Screenmap,FNArr(1),  ScreenName,  FVArr(1),  Comment, row, col,  fieldlen)
	If stepstatus = micFail Then
		Environment.Value("Login_CC_Flag") = "N"
		Status = "FAILED"
		ExitScenario = "NO"
		Comment = Comment&" Hence skipping to next step"
		reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, FNArr(1),FVArr(1),Status, Comment, sfailCnt )
		 Login_CC = MicFail
		 Exit Function
	Else
		Status = "PASSED"
		ExitScenario = "NO"
		Text = "Value in the field " & FNArr(1) & " has been set as " & FVArr(1)
		reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, FNArr(1),FVArr(1),Status, Text, sfailCnt )
		Login_CC = MicPass
	End If
    ObjScreen.SendKey TE_ENTER
	WaitTillBusy
    Call  Exception_Handling(TestCaseID,Action,objExcel_Act,ExitScenario,Comment,ExceptionHandler,sfailCnt,ApplicationName)
	If ExceptionHandler = "YES" Then
		Exit Function
	End If
	'Setting Value in CICS Login Screen
	'Setting User ID
	ScreenName = "CIC_Login"
	If SetText(Con_Screenmap,FNArr(2),  ScreenName,  FVArr(2),  Comment, row, col,  fieldlen) = MicPass Then
        Status = "PASSED"
		ExitScenario = "NO"
		Text = "Value in the field " & FNArr(2) & " has been set as " & FVArr(2)
        reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, FNArr(2),FVArr(2),Status, Text, sfailCnt )
		Login_CC = MicPass
	Else
		Environment.Value("Login_CC_Flag") = "N"
		Status = "FAILED"
		ExitScenario = "NO"
		Text = "Value in the field " & FNArr(2) & " has not been set Successfully. Hence skipping to next step"
		reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, FNArr(2),FVArr(2),Status, Text, sfailCnt )
		Login_CC = MicFail
		Exit Function
	End If
	'Setting Password
	stepstatus= SetText(Con_Screenmap,FNArr(3),  ScreenName,  FVArr(3),  Comment, row, col,  fieldlen)
	If stepstatus = micFail Then
		Environment.Value("Login_CC_Flag") = "N"
		Status = "FAILED"
		ExitScenario = "NO"
		reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, FNArr(3),FVArr(3),Status, Comment, sfailCnt )
		 Login_CC = MicFail
		 Exit Function
	End If
	ObjScreen.SendKey TE_ENTER
	WaitTillBusy
	CICS_TextMsg = ObjScreen.GetText ()
	If  instr (1, CICS_TextMsg ,"Sign-on is complete") > 0 Then
		Status = "PASSED"
		ExitScenario = "NO"
		Text = "Value in the field " & FNArr(3) & " has been set as " & FVArr(3)&"SignOn Complete"
		reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, FNArr(3),FVArr(3),Status, Text, sfailCnt )
		Login_CC = MicPass
	Else
		Call  Exception_Handling(TestCaseID,Action,objExcel_Act,ExitScenario,Comment,ExceptionHandler,sfailCnt,ApplicationName)
		If ExceptionHandler = "YES" Then
			Exit Function
		End If
	End If
	'Clearing screen to put XVCC command
	ObjScreen.SendKey TE_CLEAR
	WaitTillBusy
	ScreenName = "Process_Initiator"
	stepstatus= SetText(Con_Screenmap,"Process Initiator",  ScreenName,  "XVCC",  Comment, row, col,  fieldlen)
	'ObjScreen.SetText 1,1,"XVCC"
	ObjScreen.SendKey TE_ENTER
	WaitTillBusy
   If (ValidateScreen(Con_Screenmap,"XpeditorPrimaryMenu",Comment)=micPass) Then
		WaitTillBusy
		Status = "PASSED"
		ExitScenario = "NO"
		Login_CC = MicPass
	Else
		Environment.Value("Login_CC_Flag") = "N"
		Status = "FAILED"
		ExitScenario = "NO"
		Text = "Value XVCC  has not been opened Successfully. Hence skipping to next step"
		reportStatus=appendValidationSheet(objExcel_Act, ScreenName,ApplicationName, Action, TestCaseID, "XVCC","XVCC",Status, Text, sfailCnt )
		Login_CC = MicFail
		Exit Function
	End If
	'Set 1 in Xpeditor Primary Menu to navigate to XpediterTestDefinition screen
	ScreenName = "XpeditorPrimaryMenu"
	stepstatus =  SetText(Con_Screenmap,FNArr(4),  ScreenName,  FVArr(4),  Comment, row, col,  fieldlen)
	If stepstatus = micFail Then
		Environment.Value("Login_CC_Flag") = "N"
		Status = "FAILED"
		ExitScenario = "NO"
		reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, FNArr(4),FVArr(4),Status, Comment, sfailCnt )
		 Login_CC = MicFail
		 Exit Function
	End If
	ObjScreen.SendKey TE_ENTER
	WaitTillBusy
	XPedPrimeMenuText  = ObjScreen.GetText ()
	If FVArr(4) = "" Then
		Environment.Value("Login_CC_Flag") = "N"
		Status = "FAILED"
		ExitScenario = "NO"
		Text = "Value in the field " & FNArr(4) & " has not been set Successfully. Hence skipping to next step"
		reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, FNArr(4),FVArr(4),Status, Text, sfailCnt )
		Login_CC = MicFail
		Exit Function
    ElseIf instr (1, XPedPrimeMenuText ,"Command not recognized") = 0  Then
		Status = "PASSED"
		ExitScenario = "NO"
		Text = "Value in the field " & FNArr(4) & " has been set as " & FVArr(4)
		reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, FNArr(4),FVArr(4),Status, Text, sfailCnt )
		Login_CC = MicPass
	Else
		Environment.Value("Login_CC_Flag") = "N"
		Status = "FAILED"
		ExitScenario = "NO"
		Text = "Value in the field " & FNArr(4) & " has not been set Successfully. Hence skipping to next step"
		reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, FNArr(4),FVArr(4),Status, Text, sfailCnt )
		Login_CC = MicFail
		ObjScreen.SetText 2,15, "=X"
		ObjScreen.SendKey TE_ENTER
		WaitTillBusy
		ObjScreen.SendKey TE_CLEAR
		WaitTillBusy
		ObjScreen.SetText 1,1, "OFF"
		ObjScreen.SendKey TE_ENTER
		Exit Function
	End If
	'Set System Name & Test Identification in XpediterTestDefinition screen
	 j = 14
	Do 
		SysNameText = Trim(Replace(ObjScreen.GetText (j,3,j,38),"_",""))
		If SysNameText = "" Then
            'Set value in System Name field
			If Len(FVArr(5))>15 Then
				Environment.Value("Login_CC_Flag") = "N"
				Status = "FAILED"
				ExitScenario = "NO"
				Text = "Field Length greater than Expected length. Hence skipping to next step"
				reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID,  FNArr(5),FVArr(5),Status, Text, sfailCnt )
				Login_CC = MicFail
				Exit Function
			End If
			If Len(FVArr(6))>15 Then
				Environment.Value("Login_CC_Flag") = "N"
				Status = "FAILED"
				ExitScenario = "NO"
				Text = "Field Length greater than Expected length. Hence skipping to next step"
				reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID,  FNArr(6),FVArr(6),Status, Text, sfailCnt )
				Login_CC = MicFail
				Exit Function
			End If
			ObjScreen.SetText j,7,FVArr(5)
			SystemName = FVArr(5)
            'Set value in Test Identifier field
			ObjScreen.SetText j,24,FVArr(6)
			TestIdentifier = FVArr(6)
            ObjScreen.SendKey TE_ENTER
			WaitTillBusy
			Exit Do
		Else
			j = j+1
		End If
		'Validate if all row on the page are populated then scroll to next page
		If j > 23 Then
			ObjScreen.SendKey TE_PF8
			j = 14
		End If
	Loop While j <= 23
	'Validate Status of Record Created
	ScreenName = "XpediterTestDef"
	'To search row number of record
	For i = 14 to 22
		StatusRecord = ObjScreen.GetText (i, 1, i, 80)
		If instr (1, StatusRecord ,SystemName) >0 and  instr (1, StatusRecord ,TestIdentifier)>0 Then
			Row_Num = i
			Exit For
		End If
	Next
	RecStatus = Trim(ObjScreen.GetText(Row_Num,52,Row_Num,61))
    If RecStatus = "Incomplete" Then
		Status = "PASSED"
		ExitScenario = "NO"
		Text = "Status of record is "& RecStatus
		reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, "Staus",RecStatus,Status, Text, sfailCnt )
		Login_CC = MicPass
		ObjScreen.SetText Row_Num,3,"S"
		ObjScreen.SendKey TE_ENTER
		WaitTillBusy
	Elseif RecStatus = "Collecting" Then
		Status = "PASSED"
		ExitScenario = "NO"
		Text = "Status of record is 'Collecting'"
		reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, "Staus",RecStatus,Status, Text, sfailCnt )
		Login_CC = MicPass
        Environment.Value("Login_CC_Flag") = "Y"
		ObjScreen.SetText 2,15, "=X"
		ObjScreen.SendKey TE_ENTER
		WaitTillBusy
		ObjScreen.SendKey TE_CLEAR
		WaitTillBusy
        Exit Function
	Else
		Environment.Value("Login_CC_Flag") = "N"
		Status = "FAILED"
		ExitScenario = "NO"
	   Text = "Status of record is " & RecStatus&". Hence skipping to next step."
       reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID,  "Staus",RecStatus,Status, Text, sfailCnt )
		Login_CC = MicFail
		ObjScreen.SetText 2,15, "=X"
		ObjScreen.SendKey TE_ENTER
		WaitTillBusy
		ObjScreen.SendKey TE_CLEAR
		WaitTillBusy
		ObjScreen.SetText 1,1, "OFF"
		ObjScreen.SendKey TE_ENTER
		Exit Function
	End If
	'Set User Id in Xpediter Collection Specification Screen
	ScreenName = "XpediterCollectSpec"
	If SetText(Con_Screenmap,FNArr(7),  ScreenName,  FVArr(7),  Comment, row, col,  fieldlen) = MicPass Then
        Status = "PASSED"
		ExitScenario = "NO"
		Text = "Value in the field " & FNArr(7) & " has been set as " & FVArr(7)
		reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, FNArr(7),FVArr(7),Status, Text, sfailCnt )
		Login_CC = MicPass
	Else
		Environment.Value("Login_CC_Flag") = "N"
		Status = "FAILED"
		ExitScenario = "NO"
		Text = "Value in the field " & FNArr(7) & " has not been set Successfully. Hence skipping to next step"
		reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, FNArr(7),FVArr(7),Status, Text, sfailCnt )
		Login_CC = MicFail
		Exit Function
	End If
	'Set Transaction in Xpediter Collection Specification Screen
	If SetText(Con_Screenmap,FNArr(8),  ScreenName,  FVArr(8),  Comment, row, col,  fieldlen) = MicPass Then
        Status = "PASSED"
		ExitScenario = "NO"
		Text = "Value in the field " & FNArr(8) & " has been set as " & FVArr(8)
		reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, FNArr(8),FVArr(8),Status, Text, sfailCnt )
		Login_CC = MicPass
	Else
		Environment.Value("Login_CC_Flag") = "N"
		Status = "FAILED"
		ExitScenario = "NO"
		Text = "Value in the field " & FNArr(8) & " has not been set Successfully. Hence skipping to next step"
		reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, FNArr(8),FVArr(8),Status, Text, sfailCnt )
		Login_CC = MicFail
		Exit Function
	End If
	'Set Program in Xpediter Collection Specification Screen
	If SetText(Con_Screenmap,FNArr(9),  ScreenName,  FVArr(9),  Comment, row, col,  fieldlen) = MicPass Then
        Status = "PASSED"
		ExitScenario = "NO"
		Text = "Value in the field " & FNArr(9) & " has been set as " & FVArr(9)
		reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, FNArr(9),FVArr(9),Status, Text, sfailCnt )
		Login_CC = MicPass
	Else
		Environment.Value("Login_CC_Flag") = "N"
		Status = "FAILED"
		ExitScenario = "NO"
		Text = "Value in the field " & FNArr(9) & " has not been set Successfully. Hence skipping to next step"
		reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, FNArr(9),FVArr(9),Status, Text, sfailCnt )
		Login_CC = MicFail
		Exit Function
	End If
	'Set CSECT in Xpediter Collection Specification Screen
	If SetText(Con_Screenmap,FNArr(10),  ScreenName,  FVArr(10),  Comment, row, col,  fieldlen) = MicPass Then
		ObjScreen.SendKey TE_ENTER
		WaitTillBusy
		Status = "PASSED"
		ExitScenario = "NO"
		Text = "Value in the field " & FNArr(10) & " has been set as " & FVArr(10)
		reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, FNArr(10),FVArr(10),Status, Text, sfailCnt )
		Login_CC = MicPass
	Else
		Environment.Value("Login_CC_Flag") = "N"
		Status = "FAILED"
		ExitScenario = "NO"
		Text = "Value in the field " & FNArr(10) & " has not been set Successfully. Hence skipping to next step"
		reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, FNArr(10),FVArr(10),Status, Text, sfailCnt )
		Login_CC = MicFail
		Exit Function
	End If
	'Press F3 to navigate back to XpediterTestDefinition screen
	ObjScreen.SendKey TE_PF3
	WaitTillBusy
	'Check Status of the record
	ScreenName = "XpediterTestDef"
	If ObjScreen.GetText(Row_Num,52,Row_Num,60) = "Available" Then
		Status = "PASSED"
		ExitScenario = "NO"
		Text = "Status of record is 'Available'"
		reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, "Status","Available",Status, Text, sfailCnt )
		Login_CC = MicPass
		ObjScreen.SetText Row_Num,3,"SC"
        ObjScreen.SendKey TE_ENTER
		WaitTillBusy
	Else
		Environment.Value("Login_CC_Flag") = "N"
		Status = "FAILED"
		ExitScenario = "NO"
		Text = "Status of record is not 'Available'"
		reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, "Status","Available",Status, Text, sfailCnt )
		Login_CC = MicFail
		Exit Function
	End If
    'Validate Status of the record
	If ObjScreen.GetText(Row_Num,52,Row_Num,61) = "Collecting" Then
		Status = "PASSED"
		ExitScenario = "NO"
		Text = "Status of record is 'Collecting'"
		reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, "Status","Collecting",Status, Text, sfailCnt )
		Login_CC = MicPass
		Environment.Value("Login_CC_Flag") = "Y"
	Else
		Environment.Value("Login_CC_Flag") = "N"
		Status = "FAILED"
		ExitScenario = "NO"
		Text = "Status of record is not 'Collecting'"
		reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID,  "Status","Collecting",Status, Text, sfailCnt )
		Login_CC = MicFail
		Exit Function
	End If
	'To Close Code Coverage Session
	ObjScreen.SetText 2,15, "=X"
	ObjScreen.SendKey TE_ENTER
    WaitTillBusy
	'Get Screen Text & validate if End Of COde Coverage has appeared
	ScreenText = Trim(ObjScreen.GetText())
    If instr (1, ScreenText ,"End") >0 and  instr (1, ScreenText ,"Code")>0 and  instr (1, ScreenText ,"Coverage") >0 Then
		ObjScreen.SendKey TE_CLEAR
		WaitTillBusy
		Environment.Value("Login_CC_Flag") = "Y"
		Status = "PASSED"
		Text = "Logoff from Code Coverage successful"
		ExitScenario  = "NO"
		reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, "Log Out Code Coverage","Log Out Code Coverage",Status, Text, sfailCnt )
		Login_CC = MicPass
	Else
		Environment.Value("Login_CC_Flag") = "N"
		Status = "FAILED"
		Text = "Session Not Ended"
		reportStatus=appendValidationSheet(objExcel_Act, ScreenName,ApplicationName, Action, TestCaseID, "Log Out Code Coverage","Log Out Code Coverage",Status, Text, sfailCnt )
		ExitScenario = "NO"
		Login_CC = MicFail
		Exit Function
	End If
End Function


''*****************************************************************************************************************************************************************
''Function Name: loginToTOPS
''Input Parameters:Con_Screenmap,number_of_field,Action,TestCaseID,objExcel_Act,ExitScenario,LoginScenario,sfailCnt
''Output Parameters:sfailCnt
''Description: This function is used to Login into TOPS application using given login credentials in the testdata sheet
''********************************************************************************************************************************************************************
Public function loginToTOPS (ByVal Con_Screenmap, ByVal number_of_field, ByVal Action, ByVal TestCaseID,ByVal objExcel_Act, ByRef ExitScenario, byval LoginScenario, byRef ExceptionHandler, byref LoginFail,byref sfailCnt,ByVal ApplicationName)

 Dim fn,fv,z,y,Status,Text,Fieldv,Login_CC_Flag,row,col,fieldlen
 Dim restoreLogin,fname,fname_tmp,screenname,step_status,comment
Waittillbusy

 ''   Screen, field validation and also setting the value on the screen
 If  restoreLogin = "YES" Then
	z=0
 End If
number_of_field = 7
If  ExceptionHandler <> "YES" Then

		 For z=1 to number_of_field
					 fname = DataTable.Value("FieldName"& z,"DataSheet")
					  fname_tmp = split(fname,"|")
					  screenname = trim(fname_tmp(0))
					  fn = trim(fname_tmp(1))
					  fv=  DataTable.Value("FieldValue"& z,"DataSheet")
					DataTable.GetSheet("Login_credentials").SetCurrentRow(1)
					DataTable.Value("FieldName"& z,"Login_credentials") = fname
					DataTable.Value("FieldValue"& z,"Login_credentials") = fv
		Next	 
End If
z=0
  For z=1 to number_of_field
		  
			If ExceptionHandler = "YES"  and UCASE(Action) <> "LOGIN" Then'' if there is one login credentials serving the multiple test scenarios and one ExitScenarios occurs and now previous credential would be required to login
			DataTable.GetSheet("Login_credentials").SetCurrentRow(1)
			 fname = DataTable.Value("FieldName"& z,"Login_credentials")
			  fname_tmp = split(fname,"|")
			  screenname = trim(fname_tmp(0))
			  fn = trim(fname_tmp(1))
			  fv=  DataTable.Value("FieldValue"& z,"Login_credentials")
	  	Else
			  fname = DataTable.Value("FieldName"& z,"DataSheet")
			  fname_tmp = split(fname,"|")
			  screenname = trim(fname_tmp(0))
			  fn = trim(fname_tmp(1))
			  fv=  DataTable.Value("FieldValue"& z,"DataSheet")
			DataTable.GetSheet("Login_credentials").SetCurrentRow(1)
			DataTable.Value("FieldName"& z,"Login_credentials") = fname
			DataTable.Value("FieldValue"& z,"Login_credentials") = fv
		
			End If

			'Get the current value of Login_CC_Flag - environment variable
			   Login_CC_Flag =  Environment.Value("Login_CC_Flag") 
	   If UCASE(Login_CC_Flag) = "Y" and trim(ucase(fn)) = "REGION"  and LoginScenario <> "Y"  Then  
			If (ValidateScreen(Con_Screenmap,"Region",Comment)=micPass) Then
					step_status= SetText(Con_Screenmap,fn,screenname,fv,comment,row,col,fieldlen)
					ObjScreen.SendKey TE_ENTER
					WaitTillBusy
					If step_status = micPass Then
							 Status = "PASSED"
							Action = "Input"
							y=appendValidationSheet(objExcel_Act, ScreenName, Action, TestCaseID,fn,fv,Status, Comment, sfailCnt )
							 ExitScenario = "NO"
					Else
							Status = "FAILED"
							ExitScenario = "NO"
							reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID,fn,fv,Status, Comment, sfailCnt )
							 loginToTOPS = MicFail
					End If
			End If
		   Else
			 ''Set the values for login
			step_status= SetText(Con_Screenmap,fn,screenname,fv,comment,row,col,fieldlen)

				Action = "Input"
				
				
			   If step_status = micPass Then
					Status = "PASSED"
					Action = "Input"
					''In the Login screen only one Transmit is required and not for the PASSWORD,FILM OFFICE NBR & ADJUSTING OFFICE fields
					If  ucase(trim(fn))="PASSWORD" or  ucase(trim(fn))="FILM OFFICE NBR" or ucase(trim(fn))="ADJUSTING OFFICE"  Then
					Else
						ObjScreen.SendKey TE_ENTER
						WaitTillBusy
					End If
					y=appendValidationSheet(objExcel_Act, ScreenName,ApplicationName, Action, TestCaseID,fn,fv,Status, Comment, sfailCnt )
					ExitScenario = "NO"
					''Exception Handling need to be call opn every transmit to check if  ExitScenario = "NO", then is there any exception occurs which is documented with our team
					Call  Exception_Handling(TestCaseID,Action,objExcel_Act,ExitScenario,Comment,ExceptionHandler,sfailCnt,ApplicationName)
					If ExitScenario = "YES" Then
						LoginFail ="YES"
						Exit For
					End If
				Else
				''Report failure and also skip the current scenarios
                   Status = "FAILED"
					If ((instr(1,Comment,"Unable to find ScreenId")>0) or (instr(1,Comment,"Not on expected Screen")>0) ) Then
						 Comment =   "Screen '" &ScreenName&"'  On Which Action needs to be performed not found. Hence exiting the entire Test Scenario."
							y=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID,fn,fv,Status, Comment, sfailCnt )
						  ExitScenario = "YES"
						  Exit For
					Else	
							y=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID,fn,fv,Status, Comment, sfailCnt )
						ExitScenario = "NO"
					 If  ucase(trim(fn))="PASSWORD" or  ucase(trim(fn))="FILM OFFICE NBR" or ucase(trim(fn))="ADJUSTING OFFICE"  Then
					Else
						ObjScreen.SendKey TE_ENTER
						WaitTillBusy
					End If
						Call  Exception_Handling(TestCaseID,Action,objExcel_Act,ExitScenario,Comment,ExceptionHandler,sfailCnt,ApplicationName)
					End If
			   End if
 End If
 Next
 ''set restoreLogin back to No state
	Action = ""
 If  (ObjScreen.GetText(24,11,24,26) = "SIGN ON COMPLETE" )Then
				ObjScreen.SendKey TE_CLEAR
				WaitTillBusy
End If
End Function



''''################################################################################################################################
'  Function Name									navigateToHome
'  Purpose												 Function to reach to HOME screen
'
'  Input Params										Con_Screenmap		

'  Output Params					         	  None
'
'  Changes											  Date				By					Description
'--------------------------------------------------------------------------------------------------------
Public function navigateToHome(ByVal Con_Screenmap)
   Dim ExitScenario,i
	 If  ExitScenario = "YES"  Then
		 For i=1 to 5
			ObjScreen.SendKey TE_CLEAR
		 Next
	   End If
End Function



'''################################################################################################################################
''  Function Name									UPDATE_TD_RESULTS
''  Purpose												 Function to update Results in Test Director 
''
''  Input Params										SummaryReportFile		
''																  TestLabFolderPath 		       			
''																  TestLabTestSetName	           		    
''
''  Output Params							   None
''
''  Changes											  Date				By					Description
''--------------------------------------------------------------------------------------------------------
''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'
'Public Function UPDATE_TD_RESULTS(byval objExcel_Act,ByVal SummaryReportFile, ByVal TestLabTestSetPath, ByVal TestLabTestSetName)
' 
'  Dim j, TDTestCase, Status,tdc ,TestSetFact, TSTestFact, theTestSet , theTSTest , TestSetTestsList , TestSetsList,  tsTreeMgr, tSetFolder
'  Dim i ,worksheetname1,TestSetFound, ObjLclSheet, URL,  DomainName, ProjectName, UserID, Password, rowcount,TestName, rfact, myrun, Body
'  worksheetname1 = "SummarySheet"
'  objExcel_Act.Worksheets(worksheetname1).Cells(1,6)="TD Status"
'  objExcel_Act.Worksheets(worksheetname1).Cells(1,6).Font.Bold=True
'  objExcel_Act.Worksheets(worksheetname1).Cells(1,6).ColumnWidth = 10
'  objExcel_Act.Worksheets(worksheetname1).Cells(1,6).Interior.ColorIndex = 1
'    objExcel_Act.Worksheets(worksheetname1).Cells(1,6).Font.ColorIndex = 2  
'  'Get Test Director Credentials
'  DataTable.AddSheet("TD Credentials")
''  DataTable.ImportSheet "C:\TOPS Automation\Scheduler\DriverSheet.xls", "TD Credentials" ,"TD Credentials"
'  DataTable.ImportSheet PathFinder.Locate("..\..\Scheduler\DriverSheet.xls"), "TD Credentials" ,"TD Credentials"
'  URL = DataTable.Value("URL","TD Credentials")
'  DomainName = DataTable.Value("Domain","TD Credentials")
'  ProjectName = DataTable.Value("Project","TD Credentials")
'  UserID = DataTable.Value("User_ID","TD Credentials")
'  Password = DataTable.Value("Password","TD Credentials")
'  rowcount =objExcel_Act.Worksheets(worksheetname1).usedrange.rows.count
'  set tdc=CreateObject("TDAPIOLE80.TDConnection.1")  
'    On Error Resume Next
'  tdc.InitConnectionEx URL
'  tdc.ConnectProjectEx DomainName, ProjectName, UserID, Password
'  Set TestSetFact = tdc.TestSetFactory  
'  Set tsTreeMgr = tdc.TestSetTreeManager  
'  Set tSetFolder = tsTreeMgr.NodeByPath(TestLabTestSetPath)  
'  Set TestSetsList = tSetFolder.FindTestSets(TestLabTestSetName)  
'  Set theTestSet = TestSetsList.Item(1)  
'  Set TSTestFact = theTestSet.TSTestFactory  
'  Set TestSetTestsList = TSTestFact.NewList("") 
'  
'  For i=2 to rowcount
'   Err.Clear
'   For Each theTSTest In TestSetTestsList
'    TDTestCase=objExcel_Act.Worksheets(worksheetname1).Cells(i,2)
'    TDTestCase = "[1]"&TDTestCase
'    Status=objExcel_Act.Worksheets(worksheetname1).Cells(i,5)
'    TestName=theTSTest.Name
'    
'    If  Ucase(TDTestCase) = Ucase(TestName) then  
'    Set rfact = theTSTest.RunFactory 
'    Set myrun = rfact.AddItem("Test Run") 
'    myrun.Status = Status 
'    myrun.Post 
'     Body=Body&vbcrlf&theTSTest.Name& Status
'     TestSetFound = TRUE
'    Exit for
'    End if
'    TestSetFound = FALSE
'   Next 
'   If Err.Description <> "" and TestSetFound = FALSE Then
'    objExcel_Act.Worksheets(worksheetname1).Cells(i,6) ="Not Updated : Please Check the details provided in Driver sheet for : TD Path, URL, Domain, Project, User ID and Password" 
'    Err.Clear
'   ElseIf Err.Description = "" and TestSetFound <> TRUE then
'    objExcel_Act.Worksheets(worksheetname1).Cells(i,6) ="Not Updated : Test Case not found"
'   Else
'   objExcel_Act.Worksheets(worksheetname1).Cells(i,6) = "UPDATED"
'   End If
'    objExcel_Act.ActiveWorkbook.Save 
'  Next
'  
'  tdc.DisconnectProject
'  tdc.ReleaseConnection
'End Function
' 


''*****************************************************************************************************************************************************************
''Function Name: Exit_TE
''Input Parameters:None
''Output Parameters:None
''Description: This function is used to  kill all process of TE Window and open a fresh one
''********************************************************************************************************************************************************************

Public Function Exit_TE()
Dim wdProcessId
	While  TeWindow("TeWindow").TEScreen("TeScreen").exist 
			wdProcessId=TeWindow("TeWindow").GetROProperty("process id")
			SystemUtil.CloseProcessById (wdProcessId)
	Wend
    SystemUtil.Run "pcsws.exe", "tn3270.WS"
	  	
End Function

'#######################################################################################################################

'Function Name	: Function_Key_Press
'Purpose	This function presses any key from F1-F12 depending on the value given by the user.
'Input Parameters    			   1.  objExcel_Act - Excel sheet object for reporting
'													2. sScreenName - Screen Name
'													3. sAction - Action
'													4. sTestCaseID - Test Case ID
'													5. sFieldName -  Field Name given in Test data sheet
'													 6. sFieldValue - Field Value given in Test data sheet
'Output Parameters 				1. Status - Pass Fail Status from each case
'													2. 	Comment - COmments from Each Case
'													3.	sfailCnt   - To capture number of failures on a Scenario.
'#######################################################################################################################

Public Function  Function_Key_Press(byval objExcel_Act, ByVal sScreenName, ByVal sAction, ByVal sTestCaseID, ByVal sFieldName,ByVal sFieldValue,ByRef Status, ByRef Comment,byRef sfailCnt,ByVal ApplicationName)
   Dim reportStatus
    Select Case sFieldValue
		Case "F1"
			ObjScreen.SendKey TE_PF1
			WaitTillBusy
			Comment = "F1 Pressed"
			Status = "PASSED"
			Function_Key_Press = micPass
			reportStatus=appendValidationSheet(objExcel_Act, sScreenName, ApplicationName,sAction, sTestCaseID, sFieldName,sFieldValue,Status, Comment, sfailCnt )
		Case "F2"
			ObjScreen.SendKey TE_PF2
			WaitTillBusy
			Comment = "F2 Pressed"
			Status = "PASSED"
			Function_Key_Press = micPass
			reportStatus=appendValidationSheet(objExcel_Act, sScreenName, ApplicationName,sAction, sTestCaseID, sFieldName,sFieldValue,Status, Comment, sfailCnt )
		Case "F3"
			ObjScreen.SendKey TE_PF3
			WaitTillBusy
			Comment = "F3 Pressed"
			Status = "PASSED"
			Function_Key_Press = micPass
			reportStatus=appendValidationSheet(objExcel_Act, sScreenName, ApplicationName,sAction, sTestCaseID, sFieldName,sFieldValue,Status, Comment, sfailCnt )
		Case "F4"
			ObjScreen.SendKey TE_PF4
			WaitTillBusy
			Comment = "F4 Pressed"
			Status = "PASSED"
			Function_Key_Press = micPass
			reportStatus=appendValidationSheet(objExcel_Act, sScreenName, ApplicationName,sAction, sTestCaseID, sFieldName,sFieldValue,Status, Comment, sfailCnt )
		Case "F5"
			ObjScreen.SendKey TE_PF5
			WaitTillBusy
			Comment = "F5 Pressed"
			Status = "PASSED"
			Function_Key_Press = micPass
			reportStatus=appendValidationSheet(objExcel_Act, sScreenName, ApplicationName,sAction, sTestCaseID, sFieldName,sFieldValue,Status, Comment, sfailCnt )
		Case "F6"
			ObjScreen.SendKey TE_PF6
			WaitTillBusy
			Comment = "F6 Pressed"
			Status = "PASSED"
			Function_Key_Press = micPass
			reportStatus=appendValidationSheet(objExcel_Act, sScreenName, ApplicationName,sAction, sTestCaseID, sFieldName,sFieldValue,Status, Comment, sfailCnt )
		Case "F7"
			ObjScreen.SendKey TE_PF7
			WaitTillBusy
			Comment = "F7 Pressed"
			Status = "PASSED"
			Environment.Value("F7") = "Y"
			Function_Key_Press = micPass
			reportStatus=appendValidationSheet(objExcel_Act, sScreenName, ApplicationName,sAction, sTestCaseID, sFieldName,sFieldValue,Status, Comment, sfailCnt )
		Case "F8"
			ObjScreen.SendKey TE_PF8
			WaitTillBusy
			Comment = "F8 Pressed"
			Status = "PASSED"
			Environment.Value("F8") = "Y"
			Function_Key_Press = micPass
			reportStatus=appendValidationSheet(objExcel_Act, sScreenName, ApplicationName,sAction, sTestCaseID, sFieldName,sFieldValue,Status, Comment, sfailCnt )
		Case "F9"
			ObjScreen.SendKey TE_PF9
			WaitTillBusy
			Comment = "F9 Pressed"
			Status = "PASSED"
			Function_Key_Press = micPass
			reportStatus=appendValidationSheet(objExcel_Act, sScreenName, ApplicationName,sAction, sTestCaseID, sFieldName,sFieldValue,Status, Comment, sfailCnt )
		Case "F10"
			ObjScreen.SendKey TE_PF10
			WaitTillBusy
			Comment = "F10 Pressed"
			Status = "PASSED"
			Function_Key_Press = micPass
			reportStatus=appendValidationSheet(objExcel_Act, sScreenName, ApplicationName,sAction, sTestCaseID, sFieldName,sFieldValue,Status, Comment, sfailCnt )
		Case "F11"
			ObjScreen.SendKey TE_PF11
			WaitTillBusy
			Comment = "F11 Pressed"
			Status = "PASSED"
			Function_Key_Press = micPass
			reportStatus=appendValidationSheet(objExcel_Act, sScreenName, ApplicationName,sAction, sTestCaseID, sFieldName,sFieldValue,Status, Comment, sfailCnt )
		Case "F12"
			ObjScreen.SendKey TE_PF12
			WaitTillBusy
			Comment = "F12 Pressed"
			Status = "PASSED"
			Function_Key_Press = micPass
			reportStatus=appendValidationSheet(objExcel_Act, sScreenName, ApplicationName,sAction, sTestCaseID, sFieldName,sFieldValue,Status, Comment, sfailCnt )
		Case Else
			Comment = "Invalid Key Pressed"
			Status = "FAILED"
			Function_Key_Press = micFail
			reportStatus=appendValidationSheet(objExcel_Act, sScreenName, ApplicationName,sAction, sTestCaseID, sFieldName,sFieldValue,Status, Comment, sfailCnt )
	End Select
End Function

Public Function  LogOff_STBK(ByVal Con_Screenmap,Byval ScreenName,Byval Action,ByVal TestCaseID,ByVal objExcel_Act,ByRef ExitScenario,ByRef sfailCnt,ByVal ApplicationName)
   Dim fn,fv,reportStatus,Text
   If  (ValidateScreen(Con_Screenmap,"Region",Comment)=micFail)Then
		fn = DataTable.Value("FieldName1","DataSheet")
		fv=  ltrim(rtrim((DataTable.Value("FieldValue1","DataSheet"))))
		ObjScreen.SendKey TE_CLEAR
		WaitTillBusy
		If  (ValidateScreen(Con_Screenmap,"Main_Menu",Comment)=micPass)Then
			ObjScreen.SetText 4,19, "L"
			WaitTillBusy
			ObjScreen.SendKey TE_ENTER
			WaitTillBusy
		End If
			ObjScreen.SendKey TE_CLEAR
			WaitTillBusy
			ObjScreen.SetText 1,2, "LOGOFF "
			WaitTillBusy
			ObjScreen.SendKey TE_ENTER
			WaitTillBusy
			wait(5)
		   If  (ValidateScreen(Con_Screenmap,"Region",Comment)=micPass)Then
				status = "PASSED"
				text = "Logoff from STBK successful"
				ExitScenario  = "NO"
				reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Text, sfailCnt )
			Else
				status = "FAILED"
				text = "Logoff from STBK not successful"
				ExitScenario  = "NO"
				reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName, Action, TestCaseID, fn,fv,Status, Text, sfailCnt )
			End If
		Else
			status = "PASSED"
				text = "Logoff from STBK successful"
				ExitScenario  = "NO"
				reportStatus=appendValidationSheet(objExcel_Act, ScreenName, ApplicationName,Action, TestCaseID, fn,fv,Status, Text, sfailCnt )
		End If
End Function