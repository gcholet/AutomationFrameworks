Class KeywordDrivenActionsScript

	Public strAccountList(),Query_Int_Result,PersonalAddress,UpdateCondition,PreviousQueryResult , GlobalTestCaseStatus, CurrentFailureCount
	'Public lasttime
	'==============================================================================
	' Version     		 : 
	' Comments     : 
	' Created on   : 
	' Author       		: Cognizant Tecnology Solutions
	' Reviewer     : 
	'==============================================================================

	Function KeywordDrivenActions(ByVal strSheet, ByVal Iteration_Count, ByRef objEnvironmentVariables, ByRef clsDatabase_Module)
				
		Dim clsReport, clsModuleScript
		Dim arrAction
		Dim ObjectData  ''' in used to get runtime value from object 
		Dim Values(),TableValues(), arrTemp ()
		ReDim Values(1,0),TableValues(1,0)
		Dim strParent '' store the parent window case for , Dialog wndow.
		Dim strGeneral
		
		
		'Disabling the QTP Reporting 
		Reporter.Filter = rfDisableAll

		Set clsReport = New Report
		Set clsModuleScript = New ModuleScript
		Set clsScreenShot=New Screen_Shots

		strSheet_Name = DataTable.GetSheet(strSheet).Name

		strControlPath=objEnvironmentVariables.CntrlPath
		Screen_shot_path=strControlPath & "Framework_Scripts\Reports\"&objEnvironmentVariables.ProjectName&"\Screen_Shot"
		If strSheet=objEnvironmentVariables.TestCaseName then
			strpartdesc="In the Test Case "& objEnvironmentVariables.TestCaseName
			objEnvironmentVariables.ScriptPath=strControlPath &"Business_Scripts\TestCase_Scripts\"&objEnvironmentVariables.ProjectName&"\"&strSheet&".xls"
			Start_Row=objEnvironmentVariables.CurrentTestStepCount
		Else
			strpartdesc="In the action script " &strSheet& " which is part of the Test Case named "& objEnvironmentVariables.TestCaseName
			objEnvironmentVariables.ScriptPath=strControlPath &"Business_Scripts\TestCase_Scripts\"&objEnvironmentVariables.ProjectName&"\Action_Scripts\"&strSheet&".xls"
			Start_Row=1	
		End If
		
'		On Error Resume Next    
'		Dim App 'As Application
'		Set App = CreateObject("QuickTest.Application")
'		App.WindowState = "Minimized"		
'		Set App= "Nothing"		
'		wait 1

		' Added for the Scripting.Dictionary Object for storing the intermediatory values'
		'******************************Start*********************************
		  Set StoreData=CreateObject("Scripting.Dictionary")
		'******************************End************************************
			'Desc: To handle QC integration
			StepCnt1=0
			For iRowCnt = Start_Row To DataTable.GetSheet(strSheet).GetRowCount
					
					DataTable.GetSheet(strSheet).SetCurrentRow(iRowCnt)
	
					'Takes the comman data from automation flow sheet 
					strAction = UCase(Replace(DataTable("Action" , strSheet_Name) , " " , "" ) )
					strLabel = DataTable( "LabelName" , strSheet_Name )
					strObjectName = Datatable( "ObjectName" , strSheet )
					strParentObject  =  UCase(Replace(DataTable( "Parent_Object" , strSheet_Name ) ," " , "" ) )  
					
					If Left(strAction,6)="ACTION" then
						objEnvironmentVariables.CompleteTestStepCount=iRowCnt
						Exit Function
					End If
	
					If (iRowCnt = DataTable.GetSheet(strSheet).GetRowCount) AND (strSheet=objEnvironmentVariables.TestCaseName) then
						objEnvironmentVariables.CompleteTestStepCount=iRowCnt
					End If
	
	
					If UCase( strParentObject )<> "BROWSER:PAGE"  AND _
						UCase( strParentObject )<> "DIALOG:PAGE"  AND _
						UCase( strParentObject )<> "BROWSER:DIALOG"  AND _
						UCase( strParentObject )<> "BROWSER:DIALOG:PAGE"  Then	'Ram: 5-14-10 - BROWSER:DIALOG:PAGE for FF
						Object_Name=Trim( strObjectName )
					Else
						Object_Name=Split(Trim( strObjectName ) , ":" )
					End If
			
					set obj = Nothing


''''-------------Teekam 19-Feb---------------------------------------------------------------
'''Code for getting value from sheet - Approach for EComm automation

					automationScriptName =	Environment.Value("strCurrentTestName")		
					
'					If UCase ( Right (  automationScriptName , 8 ) ) = "ORIG_QTP"  Then
'						strTestDataReference=Datatable("TestDataReference_Orig",strSheet)									
'						strInputValue = Datatable("InputData_Orig",strSheet)			
'                        strExpectedValue = Datatable("ExpectedData_Orig",strSheet) 					
'						strOptParam = Datatable("Opt_Param_Orig",strSheet)      						
'						ModuleName =  "Original"  '' For database connection   
'						strTitle = ".*Saucony Originals.*"  '' Added Teekam for handle the browser issue when keds get added  ''03/11/2010
'
'					Elseif UCase ( Right (  automationScriptName , 8 ) ) = "PERF_QTP"  Then						
'						strTestDataReference=Datatable("TestDataReference_Perf",strSheet)   
'						strInputValue = Datatable("InputData_Perf",strSheet)
'						strExpectedValue = Datatable("ExpectedData_Perf",strSheet)  
'						strOptParam = Datatable("Opt_Param_Perf",strSheet)						
'						ModuleName =  "Performance"  '' For database connection 
'						strTitle = "Saucony.*"       '' Added Teekam for handle the browser issue when keds get added  ''03/11/2010
'
'					Elseif UCase ( Right (  automationScriptName , 8 ) ) = "SPER_QTP"  Then
'						strTestDataReference=Datatable("TestDataReference_Sper",strSheet)   
'						strInputValue = Datatable("InputData_Sper",strSheet)
'						strExpectedValue = Datatable("ExpectedData_Sper",strSheet) 	
'						strOptParam = Datatable("Opt_Param_Sper",strSheet)          						
'						ModuleName =  "Sperry"  '' For database connection  
'						strTitle = "Sperry Top-Sider.*"      '' Added Teekam for handle the browser issue when keds get added  ''03/11/2010
'
'					End If

					If TRIM(automationScriptName) = "Original"  OR UCase ( Right (  automationScriptName , 8 ) ) = "ORIG_QTP"  Then
						strTestDataReference=Datatable("TestDataReference_Orig",strSheet)									
						strInputValue = Datatable("InputData_Orig",strSheet)			
                        strExpectedValue = Datatable("ExpectedData_Orig",strSheet) 					
						strOptParam = Datatable("Opt_Param_Orig",strSheet)      						
						ModuleName =  "Original"  '' For database connection   
						strTitle = ".*Saucony.*"  '' Added Teekam for handle the browser issue when keds get added  ''03/11/2010

					Elseif TRIM(automationScriptName) = "Performance" OR UCase ( Right (  automationScriptName , 8 ) ) = "PERF_QTP"Then						
						strTestDataReference=Datatable("TestDataReference_Perf",strSheet)   
						strInputValue = Datatable("InputData_Perf",strSheet)
						strExpectedValue = Datatable("ExpectedData_Perf",strSheet)  
						strOptParam = Datatable("Opt_Param_Perf",strSheet)						
						ModuleName =  "Performance"  '' For database connection 
						strTitle = "Saucony.*"       '' Added Teekam for handle the browser issue when keds get added  ''03/11/2010

					Elseif TRIM(automationScriptName) = "Sperry"   OR UCase ( Right (  automationScriptName , 8 ) ) = "SPER_QTP"  Then
						strTestDataReference=Datatable("TestDataReference_Sper",strSheet)   
						strInputValue = Datatable("InputData_Sper",strSheet)
						strExpectedValue = Datatable("ExpectedData_Sper",strSheet) 	
						strOptParam = Datatable("Opt_Param_Sper",strSheet)          						
						ModuleName =  "Sperry"  '' For database connection  
						strTitle = "Sperry Top-Sider.*"      '' Added Teekam for handle the browser issue when keds get added  ''03/11/2010

						Elseif TRIM(automationScriptName) = "Keds"   OR UCase ( Right (  automationScriptName , 8 ) ) = "KEDS_QTP"  Then
							strTestDataReference=Datatable("TestDataReference_Keds",strSheet)   
							strInputValue = Datatable("InputData_Keds",strSheet)
							strExpectedValue = Datatable("ExpectedData_Keds",strSheet) 	
							strOptParam = Datatable("Opt_Param_Keds",strSheet)          						
							ModuleName =  "Keds"  '' For database connection  
							strTitle = ".*Keds.*"      '' Added Teekam for handle the browser issue when keds get added  ''03/11/20

								If ModuleName="Keds" Then
											Browser("brwMain").SetTOProperty "name" , ".*Keds.*"
											Browser("brwMain").Page("pgeMain").SetTOProperty "title" , ".*Keds.*"   
											Browser("brwMain").Page("pgeProductList").SetTOProperty "title" , ".*Keds.*"   
											Browser("brwMain").Page("pgeGeneral").SetTOProperty "title" , ".*Keds.*" 
											Browser("brwMain").Page("pgeAddtoBag").SetTOProperty "title" , ".*Keds.*" 
											Browser("brwMain").Page("pgeShoppingBag").SetTOProperty "title" , ".*Keds.*" 
											Browser("brwMain").Page("pgeReviewOrder").SetTOProperty "title" , ".*Keds.*" 
								End If

					'Added on Aug-2-10 for GH
						Elseif TRIM(automationScriptName) = "Grasshoppers"   OR UCase ( Right (  automationScriptName , 8 ) ) = "GRAS_QTP"  Then
								strTestDataReference=Datatable("TestDataReference_Gras",strSheet)   
								strInputValue = Datatable("InputData_Gras",strSheet)
								strExpectedValue = Datatable("ExpectedData_Gras",strSheet) 	
								strOptParam = Datatable("Opt_Param_Gras",strSheet)          						
								ModuleName =  "Grasshoppers"  '' For database connection  
								strTitle = ".*Grasshopper.*"      '' Added Teekam for handle the browser issue when Gras get added  ''03/11/20
	
								If ModuleName="Grasshoppers" Then
											Browser("brwMain").SetTOProperty "name" , ".*Grasshopper.*"
											Browser("brwMain").Page("pgeMain").SetTOProperty "title" , ".*Grasshopper.*"   
											Browser("brwMain").Page("pgeProductList").SetTOProperty "title" , ".*Grasshopper.*"   
											Browser("brwMain").Page("pgeGeneral").SetTOProperty "title" , ".*Grasshopper.*" 
											Browser("brwMain").Page("pgeAddtoBag").SetTOProperty "title" , ".*Grasshopper.*" 
											Browser("brwMain").Page("pgeShoppingBag").SetTOProperty "title" , ".*Grasshopper.*" 
											Browser("brwMain").Page("pgeReviewOrder").SetTOProperty "title" , ".*Grasshopper.*" 
								End If

							
					End If

If  UCase ( strTestDataReference ) <> "NA" and _
	 Ucase ( strInputValue ) <> "NA" and _ 
	 Ucase ( strExpectedValue ) <> "NA" and _
	 UCase ( strOptParam ) <> "NA" Then


''''-------------Teekam 19-Feb----------------------------------------------------------------
''Teekam 1-March  Updated --------------------------
					If Left(strInputValue ,2)  ="<<" and Right ( strInputValue , 2) = ">>"  Then 							
                            clsDatabase_Module.Connect_Database strControlPath , strProjectName
							strSheetNameinTestData = ModuleName			

							If Left ( strInputValue ,2 )  ="<<" and Right ( strInputValue , 2 ) = ">>"  Then 					
								set dbRecords = clsDatabase_Module.Fetch_Value ("select  *   from [" & strSheetNameinTestData & "$]" ,"" )  
								int i = 0								
								strDbValue = ""			
								Do Until dbRecords.EOF  
										strInputValue1 =  dbRecords.fields ( strInputvalue ).Value 
										strDbValue = strDbValue & ":" & strInputValue1										
										
										If Right ( strDbValue ,1 ) = ":" Then
											strDbValue = Left  ( strDbValue , Len ( strDbValue ) - 1) 
										Elseif Left  ( strDbValue ,1 ) = ":" Then 
											strDbValue = Right  ( strDbValue , Len ( strDbValue ) - 1) 
										End If									
										dbRecords.MoveNext
										i = i +1 
								Loop 

								If UCase ( Left ( Trim ( strOptParam ) , 3 ) )  = "ENV"  Then
									arrDbValue = Split ( strOptParam , ":" ) 
									Environment.Value( arrDbValue(1) ) = strDbValue
								End If

							End if
							clsDatabase_Module.Close_Database
							                          
''Teekam 22-Feb Updated --------------------------
					ElseIf Left(strLabel ,1)  ="<" and Right ( strLabel, 1) = ">"  OR _
									Left(strInputValue ,1)  ="<" and Right ( strInputValue , 1) = ">" OR _
									Left(strExpectedValue ,1)  ="<" and Right ( strExpectedValue , 1) = ">"  OR _
									Left(strTestDataReference ,1)  ="<" and Right ( strTestDataReference , 1) = ">"  Then 			
							clsDatabase_Module.Connect_Database strControlPath , strProjectName
							strSheetNameinTestData = "GENERAL"  						
			
							If Left(strLabel ,1)  ="<" and Right ( strLabel, 1) = ">"  Then 							
								set dbRecords = clsDatabase_Module.Fetch_Value ("select * from ["& strSheetNameinTestData & "$] where VariableName='" & strLabel &"'" , "")
								strLabel =   dbRecords.fields(ModuleName).Value 
							End if 					
			
							If Left(strInputValue ,1)  ="<" and Right ( strInputValue , 1) = ">"  Then 					
								set dbRecords = clsDatabase_Module.Fetch_Value ("select * from ["& strSheetNameinTestData & "$] where VariableName='" & strInputValue &"'" , "")
								strInputValue =  dbRecords.fields(ModuleName).Value 
								IsStrIPValueFromExcel="Yes"
							End if 					
				
							If Left(strExpectedValue ,1)  ="<" and Right ( strExpectedValue , 1) = ">"  Then 							
								set dbRecords = clsDatabase_Module.Fetch_Value ("select * from ["& strSheetNameinTestData & "$] where VariableName='" & strExpectedValue &"'" , "")
								strExpectedValue = dbRecords.fields(ModuleName).Value  
							End if                  			
			
							If Left(strTestDataReference ,1)  ="<" and Right ( strTestDataReference , 1) = ">"  Then 							
								set dbRecords = clsDatabase_Module.Fetch_Value ("select * from ["& strSheetNameinTestData & "$] where VariableName='" & strTestDataReference &"'" , "")
								strTestDataReference =   dbRecords.fields(ModuleName).Value 
							End if 					
			
							clsDatabase_Module.Close_Database
					End If 								
''Teekam 22-Feb Updated --------------------------

					
					'Ram - 23-3-10 - Added to handle if the Thank You Dialog gets displayed at random
                    If Browser("brwMain").Exist(0) Then ''Added Teekam 03/26 for minimize the time to check browser
'						If ModuleName="Keds" Then
'								Browser("brwMain").SetTOProperty "name" , ".*Keds.*"
'								Browser("brwMain").Page("pgeGeneral").SetTOProperty "title" , ".*Keds.*"   
'						End If
						If Browser("brwMain").Page("pgeGeneral").WebElement("elmThankYou").Exist(1) Then
							Browser("brwMain").Page("pgeGeneral").WebButton("btnNoThanks").Click
						End If
					End If 

					'Setting the default browser as IE
'					'***************************************
'					'Ram - 5-5-10 - to be used for performing operations based on current browser
					'Environment.Value("CurrentBrowser")=""
isBDP="No"
					Select Case strParentObject
							
							Case "BROWSER:PAGE"
    										'Browser(Object_Name(0)).SetTOProperty "title" , strTitle	
		
										If NOT(isSetBrwFlag) Then
											Browser(Object_Name(0)).SetTOProperty "name" , strTitle	
											Browser(Object_Name(0)).Page(Object_Name(1)).SetTOProperty "title" , strTitle   
										End If

										If Object_Name(0)="brwGeneral_FireFox" Then
											Browser(Object_Name(0)).SetTOProperty "name" , ".*" 
										End If

										set objsub = Browser(Object_Name(0)).Page(Object_Name(1))        									        									
										strParent = "WEB"																									
										blnOptional = False
										If  UCase ( strTestDataReference) = "OPTIONAL" Then								 
											If  objsub.Exist(1) Then									
												blnOptional = True										 
											End If 
										End If  
										isSetBrwFlag=False



							Case "DIALOG:PAGE" 
										set objsub = Dialog(Object_Name(0)).Page(Object_Name(1))        									        									
										strParent = "WEB"		
									
										blnOptional = False
										If  UCase ( strTestDataReference) = "OPTIONAL" Then								 
											If  objsub.Exist(1) Then									
												blnOptional = True										 
											End If 
										End If  
															

						Case "BROWSER:DIALOG"
'							Browser(Object_Name(0)).SetTOProperty "title" , strTitle								   
							Browser(Object_Name(0)).SetTOProperty "name" , strTitle	

							set objsub = Browser(Object_Name(0)).Dialog(Object_Name(1))
							strParent = "DIALOG"				

							blnOptional = False
							If  UCase ( strTestDataReference) = "OPTIONAL" Then								 
								If  objsub.Exist(1) Then 
									blnOptional = True										 
								End If 
							End If  

						Case "BROWSER:DIALOG:PAGE"
'							'Ram 5-14-10							   
							Browser(Object_Name(0)).SetTOProperty "name" , strTitle	

							set objsub = Browser(Object_Name(0)).Dialog(Object_Name(1)).Page(Object_Name(2))
							strParent = "WEB"	
							isBDP="Yes"			

							blnOptional = False
							If  UCase ( strTestDataReference) = "OPTIONAL" Then								 
								If  objsub.Exist(1) Then 
									blnOptional = True										 
								End If 
							End If 

						Case "DIALOG"						
							
							set objsub = Dialog(Object_Name)
							strParent = "DIALOG"                

							blnOptional = False
							If  UCase ( strTestDataReference) = "OPTIONAL" Then								 
								If  objsub.Exist(1) Then 
									blnOptional = True										 
								End If 
							End If  


						Case "BROWSER"	
'							Browser(Object_Name).SetTOProperty "title" , strTitle	

						If NOT(isSetBrwFlag) Then							   
							Browser(Object_Name).SetTOProperty "name" , strTitle								   
						End If

							set objsub = Browser ( Object_Name )


					End Select
								
				'Intializes the flag to true for Verify action.
					If Left(strAction, 6)="VERIFY" Then
					   blnVerify=CBool(1)
					End if 
			
				
					'Desc: To handle QC integration
					If Len(Trim(strAction)) <> 0  Then
													
						StepCnt1 = StepCnt1+1					
						objEnvironmentVariables.TestStepCount = StepCnt1
						objEnvironmentVariables.TestStepAction = strAction
						objEnvironmentVariables.ActionLabelName = strLabel					
					End If

					GlobalTestCaseStatus = objEnvironmentVariables.TestCaseStatus
					objEnvironmentVariables.TestCaseStatus = True


					Select Case UCase(strAction) 	


							Case "GETPRODUCTNAME" 								
								set obj = objsub.WebElement(Object_Name)
								If obj.Exist (2)  Then
									strProductList = obj.GetROProperty ( "outertext")
									arrProduct = Split ( strProductList , "$", -1, 1)
									strProductName = arrProduct (0)		

									'Ram 30-3-10 - Get the product price
									strProductPrice = LEFT(arrProduct (1),5)
'									strProductPrice="$" & strProductPrice
								Else
									strProductName = "Product Not Listed"
								End If								
								If UCase ( Left ( Trim ( strOptParam ) , 3 ) )  = "ENV"  Then
									arrProductValue = Split ( strOptParam , ":" ) 
									Environment.Value( Trim(  arrProductValue(1) )  ) = strProductName

									'Ram 30-3-10 - Set the environment value for price also
									'*********************************************
									If  UBOUND(arrProductValue)>1 Then
										Environment.Value( Trim(  arrProductValue(3) )  ) = strProductPrice
									End If
								End If                              
								strDesc = "GETPRODUCTNAME: The product name "& chr(34) & strProductName & chr(34) &" set with environemnt variable "& chr(34) & arrProductValue(1)  & chr(34) 
								Reporter.Filter = rfEnableAll
								Reporter.ReportEvent micdone,"Step GETPRODUCTNAME ", strDesc
								Reporter.Filter = rfDisableAll 
								clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2


							Case "SELECTPRODUCT"
								If UCase ( Left ( Trim ( strOptParam ) , 3 ) )  = "ENV"  Then
									arrProductValue = Split ( strOptParam , ":" ) 
									strProductName = Environment.Value( Trim( arrProductValue(1) ) )

									strIndex = Trim (  arrProductValue (3)  )
								End If								
								Set lnkObj = Description.Create()
								lnkObj("micclass").Value = "Link"
								lnkObj("html tag").Value = "A"
								lnkObj("text").Value = strProductName
								lnkObj("index").Value = Cint ( strIndex ) 
								
								objsub.Link( lnkObj ).Click 
								strDesc = "SELECTPRODUCT: The product name "& chr(34) & strProductName & chr(34) &" selected from listed product"  
								Reporter.Filter = rfEnableAll
								Reporter.ReportEvent micdone,"Step SELECTPRODUCT ", strDesc
								Reporter.Filter = rfDisableAll 
								clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2


							Case "GETPRODUCTPRICE" 
									set obj = objsub.WebElement(Object_Name)
									strPricing = obj.GetROProperty ( "outertext")
									strPricing = Replace (  strPricing , "Reg." , "")


									If UCase ( Left ( Trim ( strOptParam ) , 3 ) )  = "ENV"  Then
										arrPriceValue = Split ( strOptParam , ":" ) 
										Environment.Value( Trim(arrPriceValue(1) )  ) = strPricing
									End If

									strDesc = "GETPRODUCTPRICE: The product price "& chr(34) & strPricing & chr(34) &" set with environemnt variable "& chr(34) & arrPriceValue(1) & chr(34) 
									Reporter.Filter = rfEnableAll
									Reporter.ReportEvent micdone,"Step GETPRODUCTPRICE ", strDesc
									Reporter.Filter = rfDisableAll 
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2


								'Added by Ram 31-3-10 to get the stock number from the add to bag product page
								Case "GETSTOCKNUMBER" 
									set obj = objsub.WebElement(Object_Name)
									strStockNo = obj.GetROProperty ("outertext")
									strStockNo = Replace (  strStockNo , "Stock#:" ,"")

									If UCase ( Left ( Trim ( strOptParam ) , 3 ) )  = "ENV"  Then
										arrStockNo = Split ( strOptParam , ":" ) 
										Environment.Value( Trim(arrStockNo(1) )  ) = strStockNo
									End If

									strDesc = "GETSTOCKNUMBER: The product's stock # "& chr(34) & strStockNo & chr(34) &" set with environemnt variable "& chr(34) & arrStockNo(1) & chr(34) 
									Reporter.Filter = rfEnableAll
									Reporter.ReportEvent micdone,"Step GETSTOCKNUMBER ", strDesc
									Reporter.Filter = rfDisableAll 
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2


							Case "RANDOMMAIL"
'								intNumber =  RandomNumber.Value( 1 , 1000 )
'								intNumber2 =  RandomNumber.Value( 1 , 1000 )
								intNumber=Day(date) & month(date) & year(date) & hour(time) & minute(time) & second(time)
								If UCase ( Left ( Trim ( strOptParam ) , 3 ) )  = "ENV"  Then
									arrRandomValue = Split ( strOptParam , ":" ) 
									'Environment.Value( Trim ( arrRandomValue ( 1 ) )  ) = intNumber & "test" & intNumber2 & strInputValue
									Environment.Value( Trim ( arrRandomValue ( 1 ) )  ) = "test" & intNumber & "_" & strInputValue
								End If

							Case "RANDOMTEXT"
								'@Ram (23-Jun-2010)
								arrStrOptParam=Split(strOptParam,":")								
									
                                Select Case UCASE(TRIM(strInputValue))
									Case "ALPHA"
										strVal=CHR(RandomNumber(97,122)) & CHR(RandomNumber(97,122)) & CHR(RandomNumber(97,122)) & CHR(RandomNumber(97,122))
										If  strTestDataReference<> "" Then
											strVal=strVal & TRIM(strTestDataReference)
										End If
										Environment.Value( Trim(  arrStrOptParam(1) ))=strVal
									Case "NUMBER"
										strVal=RandomNumber(100,999) &RandomNumber(100,999) & minute(time) & second(time)
										If  strTestDataReference<> "" Then
											strVal=strVal & TRIM(strTestDataReference)
										End If
										Environment.Value( Trim(  arrStrOptParam(1) ))=strVal
									Case "SPECIALCHAR"
										strVal=CHR(RandomNumber(33,40)) & CHR(RandomNumber(33,40)) & CHR(RandomNumber(33,40)) & CHR(RandomNumber(33,40))
										If  strTestDataReference<> "" Then
											strVal=strVal & TRIM(strTestDataReference)
										End If
										Environment.Value( Trim(  arrStrOptParam(1) ))=strVal
									Case "COMBO"
										strVal=CHR(RandomNumber(97,122)) & CHR(RandomNumber(97,122)) & CHR(RandomNumber(97,122)) & CHR(RandomNumber(97,122)) & RandomNumber(100,999) &RandomNumber(100,999) & minute(time) & second(time) &  "#$%^&"
										If  strTestDataReference<> "" Then
											strVal=strVal & TRIM(strTestDataReference)
										End If
										Environment.Value( Trim(  arrStrOptParam(1) ))=strVal
								End Select

						
							Case "WAIT"
								val = CInt(strInputValue)
								wait val


							Case "VERIFYPAGEEXIST"

								''Ram 9-4-10- added to handle a new browser existance (eg: team saucony)
								If strObjectName<>"" Then
									If Object_Name(0)="brwTeamSaucony"  Then

											If  Browser(Object_Name(0)).Exist(3) Then
			
												Set objsub=Browser(Object_Name(0)).Page(Object_Name(1))
												strTitleName = objsub.GetROProperty("title") 
												If objsub.Exist(3) Then		

														blnVerifyRes = True 
														objsub.Highlight
												Else									
														blnVerifyRes = False 
												End If
												
												If strExpectedValue = "" OR strExpectedValue = "TRUE" Then
													blnExpectedValue = True 
												Else
													blnExpectedValue = False 
												End If 
					
												If blnExpectedValue Then ' when expected is true 
													If blnVerifyRes Then  '' Page Exist , Pass 									
														strDesc = "VERIFYPAGEEXIST: Page " & chr(34) & strTitleName & chr(34) & " exists."
														clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1													
														Reporter.Filter = rfEnableAll 
														Reporter.ReportEvent micPass,"Step VERIFYPAGEEXIST ", strDesc							 
														Reporter.Filter = rfDisableAll	
														
													Else  '' Page not Exist , Fail								
														strDesc = strpartdesc&" at the row number "&iRowCnt+1&" the page " & chr(34) & strLabel & chr(34) & " does not exists."													
														Reporter.Filter = rfEnableAll 
														Reporter.ReportEvent micFail,"Step VERIFYPAGEEXIST ", strDesc
														objEnvironmentVariables.TestCaseStatus=False 
														Reporter.Filter = rfDisableAll
														clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables				   	
														clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
													End If
												Else ''when expected is false 
													If blnVerifyRes Then  '' Page Exist , Fail 									
														'objsub.Object.focus  ''Not Required 
														strDesc = strpartdesc&" at the row number "&iRowCnt+1&" the page " & chr(34) & strLabel & chr(34) & " exists."													
														Reporter.Filter = rfEnableAll 
														Reporter.ReportEvent micFail,"Step VERIFYPAGEEXIST ", strDesc
														objEnvironmentVariables.TestCaseStatus=False 
														Reporter.Filter = rfDisableAll
														clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables				   	
														clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
													Else  '' Page not Exist , Pass 								
														strDesc = "VERIFYPAGEEXIST: Page " & chr(34) & strLabel & chr(34) & " not exists as expected."
														clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1													
														Reporter.Filter = rfEnableAll 
														Reporter.ReportEvent micPass,"Step VERIFYPAGEEXIST ", strDesc							 
														Reporter.Filter = rfDisableAll
													End If
												End If 
											Else
													strDesc ="Browser - " & chr(34) & Object_Name(0) & chr(34) & " doesn't exist. So cannot proceed with page existance checking"
													Reporter.Filter = rfEnableAll 
													Reporter.ReportEvent micFail,"Step VERIFYPAGEEXIST ", strDesc
													objEnvironmentVariables.TestCaseStatus=False 
													Reporter.Filter = rfDisableAll
													clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables				   	
													clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
											End If
										 End If


								Else
									strTitleName = objsub.GetROProperty("title") 
									If objsub.Exist(5) Then								
											blnVerifyRes = True 
											objsub.Highlight
									Else									
											blnVerifyRes = False 
									End If
									
									If strExpectedValue = "" OR strExpectedValue = "TRUE" Then
										blnExpectedValue = True 
									Else
										blnExpectedValue = False 
									End If 
		
									If blnExpectedValue Then ' when expected is true 
										If blnVerifyRes Then  '' Page Exist , Pass 									
											strDesc = "VERIFYPAGEEXIST: Page " & chr(34) & strTitleName & chr(34) & " exists."
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1													
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micPass,"Step VERIFYPAGEEXIST ", strDesc							 
											Reporter.Filter = rfDisableAll	
											
										Else  '' Page not Exist , Fail								
											strDesc = strpartdesc&" at the row number "&iRowCnt+1&" the page " & chr(34) & strLabel & chr(34) & " does not exists."													
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micFail,"Step VERIFYPAGEEXIST ", strDesc
											objEnvironmentVariables.TestCaseStatus=False 
											Reporter.Filter = rfDisableAll
											clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables				   	
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
										End If
									Else ''when expected is false 
										If blnVerifyRes Then  '' Page Exist , Fail 									
											'objsub.Object.focus  ''Not Required 
											strDesc = strpartdesc&" at the row number "&iRowCnt+1&" the page " & chr(34) & strLabel & chr(34) & " exists."													
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micFail,"Step VERIFYPAGEEXIST ", strDesc
											objEnvironmentVariables.TestCaseStatus=False 
											Reporter.Filter = rfDisableAll
											clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables				   	
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
										Else  '' Page not Exist , Pass 								
											strDesc = "VERIFYPAGEEXIST: Page " & chr(34) & strLabel & chr(34) & " not exists as expected."
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1													
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micPass,"Step VERIFYPAGEEXIST ", strDesc							 
											Reporter.Filter = rfDisableAll
										End If
									End If 
								   End If






							'**************************************************************************************************************************************************************
							'Added by Ram -23-3-10 for checking a page's name and associated URL, These values would be passed under the columns: This was done for Saucony Performance
							'InputData - The URL that's expected
							'OptionalParam - Title of the page

							Case "VERIFYPAGEANDURL"
								isLoaded="No"
								Wait 2 ''Teekam 03/25
								strOptParam=TRIM(strOptParam)
								If strObjectName<>"" Then
									'Set both Brower and Page
									Object_Name=Split(Trim( strObjectName ) , ":" )
									Browser(Object_Name(0)).SetTOProperty "name" ,strOptParam	

									If  Browser(Object_Name(0)).Exist(2)=False Then
										strBrwExists=False
									Else

										strBrwExists=True
										Browser(Object_Name(0)).Highlight

										Browser(Object_Name(0)).Page(Object_Name(1)).SetTOProperty "title" ,strOptParam	
										Set objsub=Browser(Object_Name(0)).Page(Object_Name(1))									
										
										objsub.Sync   ''Teekam 03/26
									End If
								End If

								'Get the URL of the page
								'**************************** 
								
								blnURlExists=False
								blnPageExists=False
								If strBrwExists=True Then
									strPgeURL=TRIM(objsub.GetROProperty("url"))


		
									If  (INSTR(strPgeURL,TRIM(strInputValue))>0) Then
										blnURlExists=True

									Else
										blnURlExists=False
									End If
									
									If objsub.Exist(5) AND blnURlExists=True Then								
											blnPageExists = True 
											isLoaded="Yes"

									Else									
											blnPageExists = False 
									End If	
								End If					


	
								If blnPageExists Then  '' Page Exist , with the name and specified URL 	
										objsub.Highlight
										strDesc = "VERIFYPAGEANDURL: Page with title " & chr(34) & strOptParam & chr(34) & "and url " & chr(34) & strInputValue & chr(34) & " exists."
										clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1													
										Reporter.Filter = rfEnableAll 
										Reporter.ReportEvent micPass,"Step VERIFYPAGEANDURL ", strDesc							 
										Reporter.Filter = rfDisableAll  										
									Else  '' Page doesn't exist			
										strDesc = "VERIFYPAGEANDURL: Page with title " & chr(34) & strOptParam & chr(34) & "and url " & chr(34) & strInputValue & chr(34) & " doesn't exists."
										Reporter.Filter = rfEnableAll 
										Reporter.ReportEvent micFail,"Step VERIFYPAGEANDURL ", strDesc
										objEnvironmentVariables.TestCaseStatus=False 
										Reporter.Filter = rfDisableAll
										clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables				   	
										clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
									End If		

									'Standard Env value for page load
									Environment.Value("isLoaded") = isLoaded
	

								Case "APPSYNC"									
										'If Object_Name <> "" Then
											'wait 5
											'Set obj = objsub.WebTable(Object_Name)
										'Else
											Set obj = objsub
										'End If
										
										If obj.Exist(2) Then											
											'blnFlag = True
											'Do While blnFlag = True
												'If UCase(obj.Object.ReadyState) = "COMPLETE" Then
													'blnFlag = False
												'End If                                        
											'Loop 
											Wait 1
										End If

								Case "BROWSERSYNC"				

								'Waits til the browser navigation is done.
												objsub.Sync									
								

			'Value to be assigned to env value


							Case "VERIFYELEMENTEXIST"
								blnIsOptional=False
							If  Environment.Value("CurrentBrowser")<>"" Then

								If UCASE(Environment.Value("CurrentBrowser"))=UCASE(Environment.Value ("BrowserName")) Then

												set obj=objsub.WebElement(Object_Name)
												If strInputValue <> ""  Then
													'Ram - 24-3-10 - added to incorporate index value
													arrInpVal=Split(strInputValue,":")
														If UBOUND(arrInpVal)>0 Then ' To know it's passed as an array
																Select Case UCASE(TRIM(arrInpVal(0)))
																	Case "INDEX"
																		obj.setTOProperty "index", TRIM(arrInpVal(1))
																		'Ram - 29-3-10 Added to includ ENV Value
																	 Case "ENV"
																		strEleName=Environment.Value( Trim(  arrInpVal(1) ))

																		'In case of using elmGeneralRegEx
																		If  Object_Name="elmGeneralRegEx" Then
																			obj.setTOProperty "innertext",".*" & strEleName & ".*"
																		Else
																			obj.setTOProperty "innertext",strEleName
																		End If

																		strLabel=strEleName
																		If UBOUND(arrInpVal)>1 Then


																			If  UCASE(TRIM(arrInpVal(2)))="INDEX" Then
																				strIndx=TRIM(arrInpVal(3))
																				obj.setTOProperty "index",strIndx

																			End If
																		End If      
																End Select
														Else
															'Ram 19-may-2010 - Added to pass index to direct text also
															strInputValue=TRIM(strInputValue)
															arrIpVal=Split(strInputValue,"~")
															If UBOUND(arrIpVal)>0 Then ' u have index added to the direct text
																obj.setTOProperty "innertext", arrIpVal(0)
																obj.setTOProperty "index", arrIpVal(1)
															Else
																'Direct text. Nothing
																obj.setTOProperty "innertext", strInputValue ' Use what ever the string is passed in the column value
															End If
															
														End If							    
												End If
												'
												If strOptParam <> ""  Then																					
													obj.setTOProperty "html tag", strOptParam 							
												End If	
				
				
												' Ram 6-4-10 - Can be used to pass the required property to be set
												If  strTestDataReference<>"" Then '
													arrTDR=Split(strTestDataReference,"~")
													If UBOUND(arrTDR)>0 Then
														'Check for different properties and set them
														arrProperty=UCASE(TRIM(arrTDR(0)))
														arrValue=Trim(arrTDR(1))
														If  arrProperty="INNERTEXT" Then
															obj.setTOProperty "innertext",arrValue
														Elseif arrProperty="INDEX" Then
															obj.setTOProperty "index",arrValue
														End If
													Else
														''Can be used as optional
														If UCASE(TRIM( strTestDataReference))="OPTIONAL" Then
															blnIsOptional=True
														End If
													
													End If
												End If
				
												If obj.Exist(5) Then
													blnVerifyRes = True 
													msgValue = obj.getROProperty ("innertext")		
													obj.Highlight																
												Else
													blnVerifyRes = False 
												End If
				
												If strExpectedValue = "" OR strExpectedValue = "TRUE" Then
													blnExpectedValue = True 
												Else
													blnExpectedValue = False 
												End If
		
												If blnVerifyRes Then
													If blnExpectedValue Then ''expected true 	
														strDesc ="VERIFYELEMENTEXIST: The element " & chr(34) & msgValue & chr(34) & " exists."
														clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
														Reporter.Filter = rfEnableAll 
														Reporter.ReportEvent micPass,"Step VERIFYELEMENTEXIST", strDesc
														Reporter.Filter = rfDisableAll
													Else  ''expected false	
														strDesc =strpartdesc&" at the row number " & chr(34) & iRowCnt+1 & chr(34) & " the element " & chr(34) & msgValue & chr(34) &" exists, which is not expected."
														Reporter.Filter = rfEnableAll 
														Reporter.ReportEvent micFail,"Step VERIFYELEMENTEXIST", strDesc
														Reporter.Filter = rfDisableAll
														objEnvironmentVariables.TestCaseStatus=False
														clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
														clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
													End If							
												Else
													If blnExpectedValue then	'expected true 
														If NOT(blnIsOptional) Then
																				'										If strInputValue <>"" Then																				
					'											strDesc = strpartdesc&" at the row number "& chr(34) & iRowCnt+1& chr(34) & " the element "& chr(34) & strInputValue & chr(34) & " does not exist."
					'										Else
																strDesc = strpartdesc&" at the row number "& chr(34) & iRowCnt+1& chr(34) & " the element "& chr(34) & strLabel & chr(34) & " does not exist."
					'										End If 
															Reporter.Filter = rfEnableAll 
															Reporter.ReportEvent micFail,"Step VERIFYELEMENTEXIST", strDesc									
															Reporter.Filter = rfDisableAll		
															objEnvironmentVariables.TestCaseStatus=False
															clsScreenShot.Snap_Shots objsub , Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
															clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0					
														End If
											
													Else  ''expected false 
				'										If strInputValue <>"" Then																														
				'											strDesc = "VERIFYELEMENTEXIST: The element "& chr(34) & strInputValue & chr(34) & " does not exist as expected."
				'										Else
															strDesc = "VERIFYELEMENTEXIST: The element "& chr(34) & strLabel & chr(34) & " does not exist as expected."
				'										End If									
														Reporter.Filter = rfEnableAll 
														Reporter.ReportEvent micPass,"Step VERIFYELEMENTEXIST", strDesc
														Reporter.Filter = rfDisableAll
														clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1	
													End If							 
												End If

													If Object_Name="elmGeneral" OR Object_Name="elmgeneral"Then
														obj.SetTOProperty "innertext",""
														obj.SetTOProperty "html tag",""
													End If

											End If
							Else


							 set obj=objsub.WebElement(Object_Name)
								If strInputValue <> ""  Then
									'Ram - 24-3-10 - added to incorporate index value
									arrInpVal=Split(strInputValue,":")
										If UBOUND(arrInpVal)>0 Then ' To know it's passed as an array
												Select Case UCASE(TRIM(arrInpVal(0)))
													Case "INDEX"
														obj.setTOProperty "index", TRIM(arrInpVal(1))
														'Ram - 29-3-10 Added to includ ENV Value
													 Case "ENV"
														strEleName=Environment.Value( Trim(  arrInpVal(1) ))
														

																		'In case of using elmGeneralRegEx
														If  Object_Name="elmGeneralRegEx" Then
															obj.setTOProperty "innertext",".*" & strEleName & ".*"
														Else
															obj.setTOProperty "innertext",strEleName
														End If
														strLabel=strEleName
														If UBOUND(arrInpVal)>1 Then
															If  UCASE(TRIM(arrInpVal(2)))="INDEX" Then
																strIndx=TRIM(arrInpVal(3))
																obj.setTOProperty "index",strIndx
															End If
														End If      
												End Select
										Else
															'Ram 19-may-2010 - Added to pass index to direct text also
															strInputValue=TRIM(strInputValue)
															arrIpVal=Split(strInputValue,"~")
															If UBOUND(arrIpVal)>0 Then ' u have index added to the direct text
																obj.setTOProperty "innertext", arrIpVal(0)
																obj.setTOProperty "index", arrIpVal(1)
															Else
																'Direct text. Nothing
																obj.setTOProperty "innertext", strInputValue ' Use what ever the string is passed in the column value
															End If
										End If							    
								End If
								'
								If strOptParam <> ""  Then																					
									obj.setTOProperty "html tag", strOptParam 							
								End If	


								' Ram 6-4-10 - Can be used to pass the required property to be set
								If  strTestDataReference<>"" Then '
									arrTDR=Split(strTestDataReference,"~")
									If UBOUND(arrTDR)>0 Then
										'Check for different properties and set them
										arrProperty=UCASE(TRIM(arrTDR(0)))
										arrValue=Trim(arrTDR(1))
										If  arrProperty="INNERTEXT" Then

											obj.setTOProperty "innertext",arrValue
										Elseif arrProperty="INDEX" Then
															obj.setTOProperty "index",arrValue
										End If
									Else
																	''Can be used as optional
														If UCASE(TRIM( strTestDataReference))="OPTIONAL" Then
															blnIsOptional=True
														End If
									
									End If
								End If

								If obj.Exist(5) Then
									blnVerifyRes = True 
									msgValue = obj.getROProperty ("innertext")		
									obj.Highlight																
								Else
									blnVerifyRes = False 
								End If

								If strExpectedValue = "" OR strExpectedValue = "TRUE" Then
									blnExpectedValue = True 
								Else
									blnExpectedValue = False 
								End If
							
								If blnVerifyRes Then
									If blnExpectedValue Then ''expected true 	
										strDesc ="VERIFYELEMENTEXIST: The element " & chr(34) & msgValue & chr(34) & " exists."
										clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
										Reporter.Filter = rfEnableAll 
										Reporter.ReportEvent micPass,"Step VERIFYELEMENTEXIST", strDesc
										Reporter.Filter = rfDisableAll
									Else  ''expected false	
										strDesc =strpartdesc&" at the row number " & chr(34) & iRowCnt+1 & chr(34) & " the element " & chr(34) & msgValue & chr(34) &" exists, which is not expected."
										Reporter.Filter = rfEnableAll 
										Reporter.ReportEvent micFail,"Step VERIFYELEMENTEXIST", strDesc
										Reporter.Filter = rfDisableAll
										objEnvironmentVariables.TestCaseStatus=False
										clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
										clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
									End If							
								Else
									If blnExpectedValue then	'expected true 

										If NOT(blnIsOptional) Then

													'										If strInputValue <>"" Then																				
		'											strDesc = strpartdesc&" at the row number "& chr(34) & iRowCnt+1& chr(34) & " the element "& chr(34) & strInputValue & chr(34) & " does not exist."
		'										Else
													strDesc = strpartdesc&" at the row number "& chr(34) & iRowCnt+1& chr(34) & " the element "& chr(34) & strLabel & chr(34) & " does not exist."
		'										End If 
												Reporter.Filter = rfEnableAll 
												Reporter.ReportEvent micFail,"Step VERIFYELEMENTEXIST", strDesc									
												Reporter.Filter = rfDisableAll		
												objEnvironmentVariables.TestCaseStatus=False
												clsScreenShot.Snap_Shots objsub , Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
												clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0		
										End If
														
									Else  ''expected false 
'										If strInputValue <>"" Then																														
'											strDesc = "VERIFYELEMENTEXIST: The element "& chr(34) & strInputValue & chr(34) & " does not exist as expected."
'										Else
											strDesc = "VERIFYELEMENTEXIST: The element "& chr(34) & strLabel & chr(34) & " does not exist as expected."
'										End If									
										Reporter.Filter = rfEnableAll 
										Reporter.ReportEvent micPass,"Step VERIFYELEMENTEXIST", strDesc
										Reporter.Filter = rfDisableAll
										clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1	
									End If							 
								End If
													If Object_Name="elmGeneral" OR Object_Name="elmgeneral"Then
														obj.SetTOProperty "innertext",""
														obj.SetTOProperty "html tag",""
													End If
							End If
							Environment.Value("CurrentBrowser")=""

		
									Case "VERIFYELEMENTCONTAINS"
			
										'Ram 15-4-10 
										If  Environment.Value("CurrentBrowser")<>"" Then
												If UCASE(Environment.Value("CurrentBrowser"))=UCASE(Environment.Value ("BrowserName")) Then
														set obj=objsub.WebElement(Object_Name)

														If strOptParam <> ""  Then																					
															obj.setTOProperty "html tag", strOptParam 							
														End If	
				
														blnOptional=False
														If UCASE(TRIM(strTestDataReference))="OPTIONAL" Then
															blnOptional=True
														End If
																'Manipulate the input date
																strIsIndex="No"
																If strInputValue <> ""  Then
																		arrInpVal=Split(strInputValue,":")
																		If UBOUND(arrInpVal)>0 Then ' To know it's passed as an array
																			Select Case UCASE(TRIM(arrInpVal(0)))
																				 Case "ENV"
																					 'Get the expected value
																					 '****************************
																					strExpVal=Environment.Value( Trim(  arrInpVal(1) ))
																					strLabel=strExpVal
																					If UBOUND(arrInpVal)>1 Then
																						If  UCASE(TRIM(arrInpVal(2)))="INDEX" Then
																							'Set the index
																							strIsIndex="Yes"
																						End If
																					End If      
																			End Select
																			'Noramally passed
																		Else
																			strExpVal=strInputValue ' Use what ever the string is passed in the column value
																		End If		
																End If		
				'
																'User doesnt know under wch element it would occur
																'************************************************
																If Object_Name="elmGeneral" OR Object_Name="elmgeneral"Then
											
																	obj.SetTOProperty "innertext",""
																	obj.SetTOProperty "html tag",""
																	Set desc=Description.Create
																	desc("micClass").Value="WebElement"
																	If  strOptParam<>"" Then
																		desc("html tag").Value=strOptParam
																	End If													
																	
																	Set elmObj=objsub.ChildObjects(desc)
																	For i=0 to elmObj.count-1
																		strActual=elmObj(i).getroproperty("innertext")
											

											

																		If INSTR(strActual,strExpVal) Then
									
																			obj.SetTOProperty "innertext",strActual
																			If  strOptParam<>"" Then
																				obj.SetTOProperty "html tag",strOptParam
																			End If
																			If strIsIndex="Yes" Then
																				obj.setTOProperty "index",TRIm(arrInpVal(3))
																			End If
																			obj.Highlight
																			Exit For													
																		End If													
																	Next
		
																Else ' User knows the element and want to check if that text occurs inside that element
																		strActual=obj(i).getroproperty("innertext")
			
																		If  strOptParam<>"" Then
																				obj.SetTOProperty "html tag",strOptParam
																		End If
																		If INSTR(strActual,strExpVal) Then
																			obj.SetTOProperty "innertext",strActual
																			obj.Highlight
																		End If												
																End If
				
																If blnOptional<>True Then 'Not toptional
																	If obj.Exist(4) Then
																		blnVerifyRes = True 
																		If  strOptParam="DIV" OR strOptParam="P" Then
																			msgValue = strExpVal
																		Else
																			msgValue = obj.getROProperty ("innertext")		
																		End If
																		
																		obj.Highlight																
																	Else
																		blnVerifyRes = False 
																	End If
									
																	If strExpectedValue = "" OR strExpectedValue = "TRUE" Then
																		blnExpectedValue = True 
																	Else
																		blnExpectedValue = False 
																	End If
							
																	If blnVerifyRes Then
																		If blnExpectedValue Then ''expected true 	
																			strDesc ="VERIFYELEMENTCONTAINS: The element " & chr(34) & msgValue & chr(34) & " exists."
																			clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
																			Reporter.Filter = rfEnableAll 
																			Reporter.ReportEvent micPass,"Step VERIFYELEMENTCONTAINS", strDesc
																			Reporter.Filter = rfDisableAll
																		Else  ''expected false	
																			strDesc =strpartdesc&" at the row number " & chr(34) & iRowCnt+1 & chr(34) & " the element " & chr(34) & msgValue & chr(34) &" exists, which is not expected."
																			Reporter.Filter = rfEnableAll 
																			Reporter.ReportEvent micFail,"Step VERIFYELEMENTCONTAINS", strDesc
																			Reporter.Filter = rfDisableAll
																			objEnvironmentVariables.TestCaseStatus=False
																			clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
																			clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
																		End If							
																	Else
																		If blnExpectedValue then	'expected true 
									'										If strInputValue <>"" Then																				
									'											strDesc = strpartdesc&" at the row number "& chr(34) & iRowCnt+1& chr(34) & " the element "& chr(34) & strInputValue & chr(34) & " does not exist."
									'										Else
																				strDesc = strpartdesc&" at the row number "& chr(34) & iRowCnt+1& chr(34) & " the element "& chr(34) & strLabel & chr(34) & " does not exist."
									'										End If 
																			Reporter.Filter = rfEnableAll 
																			Reporter.ReportEvent micFail,"Step VERIFYELEMENTCONTAINS", strDesc									
																			Reporter.Filter = rfDisableAll		
																			objEnvironmentVariables.TestCaseStatus=False
																			clsScreenShot.Snap_Shots objsub , Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
																			clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0																
																		Else  ''expected false 
									'										If strInputValue <>"" Then																														
									'											strDesc = "VERIFYELEMENTEXIST: The element "& chr(34) & strInputValue & chr(34) & " does not exist as expected."
									'										Else
																				strDesc = "VERIFYELEMENTCONTAINS: The element "& chr(34) & strLabel & chr(34) & " does not exist as expected."
									'										End If									
																			Reporter.Filter = rfEnableAll 
																			Reporter.ReportEvent micPass,"Step VERIFYELEMENTCONTAINS", strDesc
																			Reporter.Filter = rfDisableAll
																			clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1	
																		End If							 
																	End If
				
																End If
													If Object_Name="elmGeneral" OR Object_Name="elmgeneral"Then
														obj.SetTOProperty "innertext",""
														obj.SetTOProperty "html tag",""
													End If
												End If
										Else								

												set obj=objsub.WebElement(Object_Name)

		
												If strOptParam <> ""  Then																					
													obj.setTOProperty "html tag", strOptParam 							
												End If	
		
												blnOptional=False
												If UCASE(TRIM(strTestDataReference))="OPTIONAL" Then
													blnOptional=True
												End If
														'Manipulate the input date
														strIsIndex="No"
														If strInputValue <> ""  Then
																arrInpVal=Split(strInputValue,":")
																If UBOUND(arrInpVal)>0 Then ' To know it's passed as an array
																	Select Case UCASE(TRIM(arrInpVal(0)))
																		 Case "ENV"
																			 'Get the expected value
																			 '****************************
																			strExpVal=Environment.Value( Trim(  arrInpVal(1) ))
			
																			strLabel=strExpVal
																			If UBOUND(arrInpVal)>1 Then
																				If  UCASE(TRIM(arrInpVal(2)))="INDEX" Then
																					'Set the index
																					strIsIndex="Yes"
																				End If
																			End If      
																	End Select
																	'Noramally passed
																Else
																	strExpVal=strInputValue ' Use what ever the string is passed in the column value
																End If		
														End If		
		'
														'User doesnt know under wch element it would occur
														'************************************************
														If Object_Name="elmGeneral" OR Object_Name="elmgeneral"Then

															obj.SetTOProperty "innertext",""
															obj.SetTOProperty "html tag",""

															Set desc=Description.Create
															desc("micClass").Value="WebElement"
															If  strOptParam<>"" Then
																desc("html tag").Value=strOptParam
															End If													

															Set elmObj=objsub.ChildObjects(desc)


															For i=1 to elmObj.count
																strActual=elmObj(i).getroproperty("innertext")



																If INSTR(strActual,strExpVal) Then
																	obj.SetTOProperty "innertext",strActual

																	If  strOptParam<>"" Then
																		obj.SetTOProperty "html tag",strOptParam
																	End If
																	If strIsIndex="Yes" Then
																		obj.setTOProperty "index",TRIm(arrInpVal(3))
																	End If
																	obj.Highlight
																	Exit For													
																End If													
															Next
																													
														Else ' User knows the element and want to check if that text occurs inside that element
																strActual=obj(i).getroproperty("innertext")
																If  strOptParam<>"" Then
																		obj.SetTOProperty "html tag",strOptParam
																End If
																If INSTR(strActual,strExpVal) Then
																	obj.SetTOProperty "innertext",strActual
																	obj.Highlight
																End If												
														End If
		
														If blnOptional<>True Then 'Not toptional
															If obj.Exist(4) Then
																blnVerifyRes = True 
																		If  strOptParam="DIV" OR strOptParam="P" Then
																			msgValue = strExpVal
																		Else
																			msgValue = obj.getROProperty ("innertext")		
																		End If
																obj.Highlight																
															Else
																blnVerifyRes = False 
															End If
							
															If strExpectedValue = "" OR strExpectedValue = "TRUE" Then
																blnExpectedValue = True 
															Else
																blnExpectedValue = False 
															End If
					
															If blnVerifyRes Then
																If blnExpectedValue Then ''expected true 	
																	strDesc ="VERIFYELEMENTCONTAINS: The element " & chr(34) & msgValue & chr(34) & " exists."
																	clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
																	Reporter.Filter = rfEnableAll 
																	Reporter.ReportEvent micPass,"Step VERIFYELEMENTCONTAINS", strDesc
																	Reporter.Filter = rfDisableAll
																Else  ''expected false	
																	strDesc =strpartdesc&" at the row number " & chr(34) & iRowCnt+1 & chr(34) & " the element " & chr(34) & msgValue & chr(34) &" exists, which is not expected."
																	Reporter.Filter = rfEnableAll 
																	Reporter.ReportEvent micFail,"Step VERIFYELEMENTCONTAINS", strDesc
																	Reporter.Filter = rfDisableAll
																	objEnvironmentVariables.TestCaseStatus=False
																	clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
																	clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
																End If							
															Else
																If blnExpectedValue then	'expected true 
							'										If strInputValue <>"" Then																				
							'											strDesc = strpartdesc&" at the row number "& chr(34) & iRowCnt+1& chr(34) & " the element "& chr(34) & strInputValue & chr(34) & " does not exist."
							'										Else
																		strDesc = strpartdesc&" at the row number "& chr(34) & iRowCnt+1& chr(34) & " the element "& chr(34) & strLabel & chr(34) & " does not exist."
							'										End If 
																	Reporter.Filter = rfEnableAll 
																	Reporter.ReportEvent micFail,"Step VERIFYELEMENTCONTAINS", strDesc									
																	Reporter.Filter = rfDisableAll		
																	objEnvironmentVariables.TestCaseStatus=False
																	clsScreenShot.Snap_Shots objsub , Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
																	clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0																
																Else  ''expected false 
							'										If strInputValue <>"" Then																														
							'											strDesc = "VERIFYELEMENTEXIST: The element "& chr(34) & strInputValue & chr(34) & " does not exist as expected."
							'										Else
																		strDesc = "VERIFYELEMENTCONTAINS: The element "& chr(34) & strLabel & chr(34) & " does not exist as expected."
							'										End If									
																	Reporter.Filter = rfEnableAll 
																	Reporter.ReportEvent micPass,"Step VERIFYELEMENTCONTAINS", strDesc
																	Reporter.Filter = rfDisableAll
																	clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1	
																End If							 
															End If
		
														End If
													If Object_Name="elmGeneral" OR Object_Name="elmgeneral"Then
														obj.SetTOProperty "innertext",""
														obj.SetTOProperty "html tag",""
													End If
													  End If
													  Environment.Value("CurrentBrowser")=""

'							Case "ASSIGNTOENVVAR"
'
'								'Env Var Name
'								Environment.Value( Trim(strOptParam))=TRIM(strInputValue) '					


                            'Ram - 24-3-10 - Added to check if 
								Case "VERIFYLINKBETWEENSECTIONS"
									Dim strSec1:strSec1=""
									Dim strSec2:strSec2=""
									'set obj=objsub.WebElement(Object_Name)
									If strInputValue <> ""  Then
										arrInpValue=Split(strInputValue,":")
										If  UBOUND(arrInpValue)>0 Then
											strSec1=TRIM(arrInpValue(0)) ' From Value
											strSec2=TRIM(arrInpValue(1)) 'To Value		
										Else
											strSec1=TRIM(strInputValue)
										End If
																		
									End If	

									If  strOptParam<>"" Then
										strExpectedVal=TRIM(strOptParam)
									End If

									Set Desc = Description.Create()
									Desc("micclass").value = "Link"										
									Set lnkObj = objsub.ChildObjects(Desc)

									'Get the value of all the links on that page																				
									For i = 0 To lnkObj.Count-1 
										strLnkText=lnkObj(i).GetROProperty("text") 
										strAllLnk=strAllLnk & ":" & strLnkText											
									Next 


									If strExpectedValue = "" OR strExpectedValue = "TRUE" Then
										blnExpectedValue = True 
									Else
										blnExpectedValue = False 
									End If
									
									'Now split the values b/w the two regions
									If  strSec2<>"" Then
										arrLnk1=Split(strAllLnk,strSec1)
										arrLnk2=Split(arrLnk1(1),strSec2)
										strActualValue=arrLnk2(0)

									Else
										arrLnk1=Split(strAllLnk,strSec1)
										'arrLnk2=Split(arrLnk1(1),strSec2)
										strActualValue=arrLnk1(1)

									End If

									'Check if the required link falls between these two values
									If  INSTR(strActualValue,strExpectedVal)>0 Then
										blnLnkExists=True								
									Else	
										blnLnkExists=False
									End If

										'Write the result
										'*****************
										If  blnExpectedValue Then
											If  blnLnkExists Then ' True
												If strSec2<>"" Then
													strDesc ="VERIFYLINKBETWEENSECTIONS: The product/link " & chr(34) & strExpectedVal & chr(34) & " exists between the sections " & chr(34) & strSec1 & chr(34) & " & " & chr(34) & strSec2 & chr(34) & "."
												Else
													strDesc ="VERIFYLINKBETWEENSECTIONS: The product/link " & chr(34) & strExpectedVal & chr(34) & " exists after the section " & chr(34) & strSec1 & "."
												End If
												
												clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
												Reporter.Filter = rfEnableAll 
												Reporter.ReportEvent micPass,"Step VERIFYLINKBETWEENSECTIONS", strDesc
												Reporter.Filter = rfDisableAll
											Else  ''expected false	
												If strSec2<>"" Then
													strDesc ="VERIFYLINKBETWEENSECTIONS: The product/link " & chr(34) & strExpectedVal & chr(34) & " doesn't exist between the sections " & chr(34) & strSec1 & chr(34) & " & " & chr(34) & strSec2 & chr(34) & "."
												Else
													strDesc ="VERIFYLINKBETWEENSECTIONS: The product/link " & chr(34) & strExpectedVal & chr(34) & " doesn't exist after the section " & chr(34) & strSec1 & "."
												End If
												
												Reporter.Filter = rfEnableAll 
												Reporter.ReportEvent micFail,"Step VERIFYLINKBETWEENSECTIONS", strDesc
												Reporter.Filter = rfDisableAll
												objEnvironmentVariables.TestCaseStatus=False
												clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
												clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0	
											End If
										Else
											If  blnLnkExists=False Then ' Link doesn't exist - Pass
												If strSec2<>"" Then
													strDesc ="VERIFYLINKBETWEENSECTIONS: The product/link " & chr(34) & strExpectedVal & chr(34) & " doesn't exist between the sections " & chr(34) & strSec1 & chr(34) & " & " & chr(34) & strSec2 & chr(34) & " as expected."
												Else
													strDesc ="VERIFYLINKBETWEENSECTIONS: The product/link " & chr(34) & strExpectedVal & chr(34) & " doesn't exist after  the sections " & chr(34) & strSec1 & " as expected."
												End If
												strDesc ="VERIFYLINKBETWEENSECTIONS: The product/link " & chr(34) & strExpectedVal & chr(34) & " doesn't exist between the sections " & chr(34) & strSec1 & chr(34) & " & " & chr(34) & strSec2 & chr(34) & " as expected."
												clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
												Reporter.Filter = rfEnableAll 
												Reporter.ReportEvent micPass,"Step VERIFYLINKBETWEENSECTIONS", strDesc
												Reporter.Filter = rfDisableAll
											Else  ''expected false	
												If strSec2<>"" Then
													strDesc ="VERIFYLINKBETWEENSECTIONS: The product/link " & chr(34) & strExpectedVal & chr(34) & " exists between the sections " & chr(34) & strSec1 & chr(34) & " & " & chr(34) & strSec2 & chr(34) & ", which is not expected."
												Else
													strDesc ="VERIFYLINKBETWEENSECTIONS: The product/link " & chr(34) & strExpectedVal & chr(34) & " exists after the sections " & chr(34) & strSec1 & ", which is not expected."
												End If
												
												Reporter.Filter = rfEnableAll 
												Reporter.ReportEvent micFail,"Step VERIFYLINKBETWEENSECTIONS", strDesc
												Reporter.Filter = rfDisableAll
												objEnvironmentVariables.TestCaseStatus=False
												clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
												clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0	
											End If											
										End If

										

							'Invoke the Application Browser
							Case "INVOKEAPP"														
								strURLNavigate = clsEnvironmentVariables.Environment 	

'								Browser("brwMain").SetTOProperty "name" ,strTitle	
'								If  Browser("brwMain").Exist(5) Then
'									Browser("brwMain").Close
'									Wait 5
'								End If

								If Environment.Value ("BrowserName") = "IE"  Then
									Wait 1
									SystemUtil.CloseDescendentProcesses	

									BrwNames=".*Saucony Originals.*~Saucony.*~.*Sperry.*~.*Keds.*~.*Grass.*"
									arrBrwNames=Split (BrwNames,"~")
									For i=0 to UBOUND(arrBrwNames)
										strBrwName=arrBrwNames(i)
										Browser("brwMain").SetTOProperty "name" ,strBrwName	
										While Browser("brwMain").Exist(5) 
											Browser("brwMain").Close
											Wait 2
										Wend
'										If  Browser("brwMain").Exist(5) Then
'											Browser("brwMain").Close
'											Wait 2
'										End If
									Next						
									Wait 2	
								End If

								If Environment.Value ("BrowserName") = "Firefox"  Then

									BrwNames=".*Saucony Originals.*~Saucony.*~.*Sperry.*~.*Keds.*~.*Grass.*"
									arrBrwNames=Split (BrwNames,"~")
									For i=0 to UBOUND(arrBrwNames)
										strBrwName=arrBrwNames(i)
										Browser("brwMain").SetTOProperty "name" ,strBrwName	
										While Browser("brwMain").Exist(5) 
											Browser("brwMain").Close
											Wait 2
										Wend
'										If  Browser("brwMain").Exist(5) Then
'											Browser("brwMain").Close
'											Wait 2
'										End If
									Next
									'Kill Process- FF
									strComputer ="."
									strProcessName="firefox.exe"
									Dim objWMIService, strWMIQuery
									
									strWMIQuery = "Select * from Win32_Process where name like '" & strProcessName & "'"	
									Set objWMIService = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2") 
									
									If objWMIService.ExecQuery(strWMIQuery).Count > 0 then
										Set colProcessList = objWMIService.ExecQuery ("SELECT * FROM Win32_Process WHERE Name = '" & strProcessName & "'")
										For Each objProcess in colProcessList
											objProcess.Terminate()
										Next
									End if
									Set objWMIService=Nothing
									Set colProcessList=Nothing		

									'Kill Process		- Crash Repoter
									strComputer1="."
									strProcessName1="crashreporter.exe"
									Dim objWMIService1, strWMIQuery1
									
									strWMIQuery1 = "Select * from Win32_Process where name like '" & strProcessName1 & "'"	
									Set objWMIService1 = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\" & strComputer1 & "\root\cimv2") 
									
									If objWMIService1.ExecQuery(strWMIQuery1).Count > 0 then
										Set colProcessList1 = objWMIService1.ExecQuery ("SELECT * FROM Win32_Process WHERE Name = '" & strProcessName1 & "'")
										For Each objProcess in colProcessList1
											objProcess.Terminate()
										Next
									End if
									Set objWMIService1=Nothing
									Set colProcessLis1t=Nothing		

								End If

								If Environment.Value ("BrowserName") = "IE"  Then
									SystemUtil.Run "iexplore.exe",strURLNavigate ,"" ,"" , 3
									strDesc = "INVOKEAPP action performed on " & chr(34) & "IE browser" & chr(34) &  " with URL " & chr(34) & strURLNavigate & chr(34) & "."
									
								ElseIf Environment.Value ("BrowserName") = "Firefox"  Then	
									SystemUtil.Run "Firefox.exe",strURLNavigate ,"" ,"" , 3
									strDesc = "INVOKEAPP action performed on " & chr(34) & "Firefox browser" & chr(34) & " with URL " & chr(34) & strURLNavigate & chr(34) & "."
								End If

								wait 4														
								'strDesc = "INVOKEAPP action performed on URL " & chr(34) & strURLNavigate & chr(34) & "."
								clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2
								Reporter.Filter = rfEnableAll 
								Reporter.ReportEvent micdone,"Step INVOKEWEBAPP", strDesc

								'Check for website down
								'****************************
								If  Browser("brwGeneral").Page("pgeGeneral").WebElement("elmWebsiteDown").Exist(3) Then
									strDesc = "<b><font size=3 color=RED> INVOKEWEBAPP - The Website is temporarily down. Cannot proceed further with the execution.</b></font>"
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micFail,"Step INVOKEWEBAPP", strDesc									
									Reporter.Filter = rfDisableAll		
									objEnvironmentVariables.TestCaseStatus=False
									clsScreenShot.Snap_Shots objsub , Screen_shot_path,strSheet_Name&"_"&iRowCnt+1,objEnvironmentVariables
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0			
						
								End if


							'Closes the Application Browser
							Case "BROWSERCLOSE"
								
								objsub.Sync
								objsub.Close
								SystemUtil.CloseDescendentProcesses
								strDesc = "BROWSERCLOSE action performed"
								clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2                        									
								Reporter.Filter = rfEnableAll 
								Reporter.ReportEvent micdone,"Step BROWSERCLOSE", strDesc									 
								Reporter.Filter = rfDisableAll

							 Case "CLOSEWINDOW"
								objsub.Sync
								objsub.Close
								strDesc = "CLOSEWINDOW: action performed"
								clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2
								Reporter.Filter = rfEnableAll 
								Reporter.ReportEvent micdone,"Step CLOSEWINDOW", strDesc								 
								Reporter.Filter = rfDisableAll


							Case "VERIFYEDITBOXTEXT"
								set obj=objsub.WebEdit(Object_Name)
	
								strToSearch = Trim(strExpectedValue)
								OptParam = UCase ( Trim ( strOptParam ))
								
								IF  OptParam = "BODYTEXTBLANK" then	
									strSearchString = Trim(obj.GetROproperty("Outertext"))
								Else
									strSearchString = Trim(obj.GetROproperty("value"))
								End if
																
										
								If strSearchString = strToSearch Then
									blnVerifyRes=True
								Else
									blnVerifyRes=False
								End If								
							
								If blnVerifyRes Then
									If Trim( strExpectedValue)  = "" Then 
										strDesc ="VERIFYEDITBOXTEXT: " & chr (34) &" Text box " & chr(34) & strLabel & chr(34) & " found as BLANK as expected."
									Else
										strDesc = "VERIFYEDITBOXTEXT: Text value " & chr(34) & strExpectedValue & chr(34) & " matches with the value " & chr(34) & strSearchString & chr(34) & "in text box " & chr(34) & strLabel & chr(34)  
									End IF
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1						
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micPass,"Step VERIFYEDITBOXTEXT", strDesc					 
									Reporter.Filter = rfDisableAll
								Else
									If Trim( strExpectedValue)  = "" Then 
										strDesc = strpartdesc&" at the row number "&iRowCnt+1& chr (34) & "Blank" & chr(34) &" text not found in text box " & chr(34) & strLabel & chr(34) 
									Else
										strDesc = strpartdesc&" at the row number "&iRowCnt+1&" Text value " & chr(34) & strExpectedValue & chr(34) & " does not matches with the value " & chr(34) & strSearchString & chr(34) & " in text box " & chr(34) & strLabel & chr(34)  
									END IF
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micFail,"Step VERIFYEDITBOXTEXT", strDesc
									objEnvironmentVariables.TestCaseStatus=False 
									Reporter.Filter = rfDisableAll
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables				   	
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
								End If


							Case "LINKCLICK" 

																							If  Environment.Value("CurrentBrowser")<>"" Then

								If UCASE(Environment.Value("CurrentBrowser"))=UCASE(Environment.Value ("BrowserName")) Then
									Set obj = objsub.Link(Object_Name)  									

									'Giving the name and index ..!!!
									If Trim(strInputValue) <> "" Then 
										'added by Ram' 22-3-10 inorder to define index as well, in case one or more objects of the same name exists, so adding code to change index @ runtime as well
										strArrayInputValue=Split(strInputValue,":")
										If UBOUND(strArrayInputValue)>0 Then
										'Setting the text to the value being specified in array (0)
										If strArrayInputValue(0)<>"" Then
											obj.setTOProperty "text",strArrayInputValue(0)                
											strLabel = strArrayInputValue(0)
										End If

									'Setting the index to the value being specified in array (1)
											obj.setTOProperty "index",strArrayInputValue(1)       
                                                                                                            
										Else

										obj.setTOProperty "text",strInputValue	
										strLabel = strInputValue
										End If
									End If

									'Ram 16-4-10 - Added to get the value from the env value. in strOptParam
									'***************
									If strOptParam <> ""  Then
										'Ram - 24-3-10 - added to incorporate index value
										arrOptParam=Split(strOptParam,":")
											If UBOUND(arrOptParam)>0 Then ' To know it's passed as an array
													Select Case UCASE(TRIM(arrOptParam(0)))
														 Case "ENV"
															strLinkName=Environment.Value( Trim(  arrOptParam(1) ))
															obj.setTOProperty "text",strLinkName
															strLabel=strLinkName
															If UBOUND(arrOptParam)>1 Then
																If  UCASE(TRIM(arrOptParam(2)))="INDEX" Then
																	obj.setTOProperty "index",TRIm(arrOptParam(3))
																End If
															End If      
													End Select
											Else
												'Nothing goes in here...!!!
												
											End If							    
									End If
									'

									If  UCase ( strTestDataReference) = "OPTIONAL"  Then		

										If blnOptional =Cbool("TRUE")  and  obj.Exist(1)  Then
											obj.Click								
											strDesc="LINKCLICK: action on "& chr(34) & strLabel & chr(34) &" successfully performed."
											Reporter.Filter = rfEnableAll
											Reporter.ReportEvent micdone,"Step LINKCLICK", " The Link "& chr(34) & strLabel & chr(34) &" has been clicked." 
											Reporter.Filter = rfDisableAll													
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2
										End If 
									Else                        	
										If obj.Exist(5) Then									
											obj.Click								
											strDesc="LINKCLICK: action on "& chr(34) & strLabel & chr(34) &" successfully performed."
											Reporter.Filter = rfEnableAll
											Reporter.ReportEvent micdone,"Step LINKCLICK", " The Link "& chr(34) & strLabel & chr(34) &" has been clicked." 
											Reporter.Filter = rfDisableAll													
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2
										Else
											strDesc=strpartdesc&" at the row number "& chr(34) & iRowCnt+1 & chr(34) &" link "& chr(34) & strLabel & chr(34) &" not Exist."
											Reporter.Filter = rfEnableAll
											Reporter.ReportEvent micdone,"Step LINKCLICK", " The Link "& chr(34) & strLabel & chr(34) &" no Exist." 
											Reporter.Filter = rfDisableAll	
											objEnvironmentVariables.TestCaseStatus=False 
											clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0																
										End If 							
									End If 

									End If
									Else
											Set obj = objsub.Link(Object_Name)  									

									'Giving the name and index ..!!!
									If Trim(strInputValue) <> "" Then 
										'added by Ram' 22-3-10 inorder to define index as well, in case one or more objects of the same name exists, so adding code to change index @ runtime as well
										strArrayInputValue=Split(strInputValue,":")
										If UBOUND(strArrayInputValue)>0 Then
										'Setting the text to the value being specified in array (0)
										If strArrayInputValue(0)<>"" Then
											obj.setTOProperty "text",strArrayInputValue(0)                
											strLabel = strArrayInputValue(0)
										End If

									'Setting the index to the value being specified in array (1)
											obj.setTOProperty "index",strArrayInputValue(1)       
                                                                                                                        
										Else

										obj.setTOProperty "text",strInputValue	
										strLabel = strInputValue
										End If
									End If

									'Ram 16-4-10 - Added to get the value from the env value. in strOptParam
									'***************
									If strOptParam <> ""  Then
										'Ram - 24-3-10 - added to incorporate index value
										arrOptParam=Split(strOptParam,":")
											If UBOUND(arrOptParam)>0 Then ' To know it's passed as an array
													Select Case UCASE(TRIM(arrOptParam(0)))
														 Case "ENV"
															strLinkName=Environment.Value( Trim(  arrOptParam(1) ))
															obj.setTOProperty "text",strLinkName
															strLabel=strLinkName
															If UBOUND(arrOptParam)>1 Then
																If  UCASE(TRIM(arrOptParam(2)))="INDEX" Then
																	obj.setTOProperty "index",TRIm(arrOptParam(3))
																End If
															End If      
													End Select
											Else
												'Nothing goes in here...!!!
												
											End If							    
									End If
									'

									If  UCase ( strTestDataReference) = "OPTIONAL"  Then		

										If blnOptional =Cbool("TRUE")  and  obj.Exist(1)  Then
											obj.Click								
											strDesc="LINKCLICK: action on "& chr(34) & strLabel & chr(34) &" successfully performed."
											Reporter.Filter = rfEnableAll
											Reporter.ReportEvent micdone,"Step LINKCLICK", " The Link "& chr(34) & strLabel & chr(34) &" has been clicked." 
											Reporter.Filter = rfDisableAll													
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2
										End If 
									Else                        	
										If obj.Exist(5) Then									
											obj.Click								
											strDesc="LINKCLICK: action on "& chr(34) & strLabel & chr(34) &" successfully performed."
											Reporter.Filter = rfEnableAll
											Reporter.ReportEvent micdone,"Step LINKCLICK", " The Link "& chr(34) & strLabel & chr(34) &" has been clicked." 
											Reporter.Filter = rfDisableAll													
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2
										Else
											strDesc=strpartdesc&" at the row number "& chr(34) & iRowCnt+1 & chr(34) &" link "& chr(34) & strLabel & chr(34) &" not Exist."
											Reporter.Filter = rfEnableAll
											Reporter.ReportEvent micdone,"Step LINKCLICK", " The Link "& chr(34) & strLabel & chr(34) &" no Exist." 
											Reporter.Filter = rfDisableAll	
											objEnvironmentVariables.TestCaseStatus=False 
											clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0																
										End If 							
									End If 
									End If
								
							'' Set the value in text box
							Case "SETTEXT"		

									set obj = objsub.WebEdit(Object_Name)


									If UCase ( Left ( Trim ( strOptParam ) , 3 ) )  = "ENV"  Then
										arrRandomValue = Split ( strOptParam , ":" ) 
										strInputValue = Environment.Value( Trim ( arrRandomValue ( 1 ) )  )

									End If
									
									'Ram - 24-3-10 Added to allow SPACE
									If UCase( TRIM(strInputValue) )="SPACE" Then
										obj.Set "  "

									''condition for BLANKadded by Teekam 03/25
									ElseIf Ucase ( TRIM(strInputValue ) )="BLANK" Then
										obj.Set ""
									ElseIf Ucase ( TRIM(strInputValue ) )="CLICK" Then
										obj.Click
									Else
									    obj.Set ""   ''Clearing previos data before entering new data , Teekam 03/25 
										obj.Set strInputValue
									End If

									'if hey word has value called space - Ram 24-3-10
									If  UCASE(TRIM(strInputValue))="SPACE" Then
										
										If obj.GetROProperty("value")="  " Then 
											strDesc="SETTEXT: action on " & chr(34) & strLabel & chr(34) &" successfully performed. Text entered as " & chr(34) & "SPACE" & chr(34) & "."
											Reporter.Filter = rfEnableAll
											ObjectData = obj.GetROProperty("value")
											Reporter.ReportEvent micPass,"Step SETTEXT" , strDesc
											Reporter.Filter = rfDisableAll
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1								
										Else
											strDesc=strpartdesc &" at the row number "& chr(34) & iRowCnt+1 & chr(34) &" the field "& chr(34) & strLabel & chr(34) &" does not exist."
											Reporter.Filter = rfEnableAll
											Reporter.ReportEvent micFail,"Step SETTEXT", strDesc
											objEnvironmentVariables.TestCaseStatus=False
											Reporter.Filter = rfDisableAll
											clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0																
										End If

									
								   		'' 03/25/2010 Added by Teekam for considering the blank value passing in field 
									ElseIf  UCase ( TRIM(strInputValue ) )="BLANK"  Then									
										If Trim( obj.GetROProperty("value") )=""  OR INSTR(Trim( obj.GetROProperty("value") ),"Search")>0 Then 
											strDesc="SETTEXT: action on " & chr(34) & strLabel & chr(34) &" successfully performed. Text entered as " & chr(34) &"BLANK" & chr(34) & "."
											Reporter.Filter = rfEnableAll											
											Reporter.ReportEvent micPass,"Step SETTEXT", strDesc
											Reporter.Filter = rfDisableAll
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1								
										Else
											strDesc=strpartdesc &" at the row number "& chr(34) & iRowCnt+1 & chr(34) &" the field "& chr(34) & strLabel & chr(34) &" does not exist."
											Reporter.Filter = rfEnableAll
											Reporter.ReportEvent micFail,"Step SETTEXT" ,  strDesc
											objEnvironmentVariables.TestCaseStatus=False
											Reporter.Filter = rfDisableAll
											clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0																
										End If

									'For clicking on that
									ElseIf  UCase ( TRIM(strInputValue ) )="CLICK"  Then									
										If Trim( obj.GetROProperty("value") )=""  OR INSTR(Trim( obj.GetROProperty("value") ),"Search")>0 Then 
											strDesc="SETTEXT: action on " & chr(34) & strLabel & chr(34) &" successfully performed. Click action successfully performed."
											Reporter.Filter = rfEnableAll											
											Reporter.ReportEvent micPass,"Step SETTEXT", strDesc
											Reporter.Filter = rfDisableAll
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1								
										Else
											strDesc=strpartdesc &" at the row number "& chr(34) & iRowCnt+1 & chr(34) &" the field "& chr(34) & strLabel & chr(34) &" does not exist."
											Reporter.Filter = rfEnableAll
											Reporter.ReportEvent micFail,"Step SETTEXT" ,  strDesc
											objEnvironmentVariables.TestCaseStatus=False
											Reporter.Filter = rfDisableAll
											clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0																
										End If
										'General Checking
			
									Elseif ( Trim(obj.GetROProperty("value"))=Trim(strInputValue) ) Then 'AND (UCase(Trim(obj.GetROProperty("name")))=UCase(Trim(obj.GetTOProperty("name")))) Then							
										strDesc="SETTEXT: action on " & chr(34) & strLabel & chr(34) &" successfully performed. Text entered: " & chr(34) & strInputValue & chr(34) & "."
										Reporter.Filter = rfEnableAll
										ObjectData = obj.GetROProperty("value")
										Reporter.ReportEvent micPass,"Step SETTEXT" , strDesc
										Reporter.Filter = rfDisableAll
										clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1								
									Else
										strDesc=strpartdesc &" at the row number "& chr(34) & iRowCnt+1 & chr(34) &" the field "& chr(34) & strLabel & chr(34) &" does not exist."
										Reporter.Filter = rfEnableAll
										Reporter.ReportEvent micFail,"Step SETTEXT" , strDesc
										objEnvironmentVariables.TestCaseStatus=False
										Reporter.Filter = rfDisableAll
										clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
										clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0																
									End If
								
						
							'Select the check box.
							Case "CHECKBOXSELECT" 				       	
								set obj = objsub.WebCheckBox(Object_Name)
								If  UCase(trim(strInputValue))="Y" Then						
									obj.Set "ON"
								Else
									obj.Set "OFF"
								End If
								If (obj.GetROProperty("checked")=1 and UCase(trim(strInputValue))="Y") OR (obj.GetROProperty("checked")=0 and UCase(trim(strInputValue))="N") Then
									strDesc="CHECKBOXSELECT: action on " & chr(34) & strLabel & chr(34) &" action successfully performed."
									Reporter.Filter = rfEnableAll								
									Reporter.ReportEvent 0,"Step CHECKBOXSELECT", " The checkbox "& chr(34) &  strLabel &" has been selected." 
									Reporter.Filter = rfDisableAll													
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
								Else
									strDesc=strpartdesc&" at the row number "& chr(34) & iRowCnt+1 & chr(34) &" the field "& chr(34) & strLabel & chr(34) &" does not exist."
									Reporter.Filter = rfEnableAll
									Reporter.ReportEvent micFail,"Step CHECKBOXSELECT", " The checkbox "  & chr(34) & strLabel & chr(34) &"  does not exist."
									objEnvironmentVariables.TestCaseStatus=False
									Reporter.Filter = rfDisableAll
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
								End If




							'Click the Image button
							Case "IMAGECLICK"

								set obj = objsub.Image(Object_Name) 

								If  strOptParam<>"" Then
									arrValue=Split(TRIM(strOptParam),":")
									If UCASE(TRIM(arrValue(0)))="ENV" Then
										strImgName=Environment.Value( Trim(arrValue(1) ))
										obj.SetTOProperty "alt",Trim(strImgName)
										If UBOUND(arrValue)>1 Then
											If  UCASE(TRIM(arrValue(2)))="INDEX" Then
												obj.SetTOProperty "Index",Trim(arrValue(3))
											End If											
										End If
									End If
								End If

								If obj.Exist(5) Then		

									obj.Click
									strDesc="IMAGECLICK: action on " & chr(34) & strLabel & chr(34) &" performed."
									Reporter.Filter = rfEnableAll
									Reporter.ReportEvent micdone,"Step IMAGECONTROLCLICK", " The IMAGE "& chr(34) & strLabel & chr(34) &" has been clicked." 
									Reporter.Filter = rfDisableAll
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2
								Else
									strDesc=strpartdesc&" at the row number "& chr(34) & iRowCnt+1 & chr(34) &" the field "& chr(34) & strLabel & chr(34) &" does not exist."
									Reporter.Filter = rfEnableAll
									Reporter.ReportEvent micFail,"Step IMAGECLICK", " The image "  & chr(34) & strLabel & chr(34) &"  does not exist."
									objEnvironmentVariables.TestCaseStatus=False
									Reporter.Filter = rfDisableAll
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
								End If

						
                        Case "VERIFYTEXTBOXSTATUS"
							Set obj = objsub.WebEdit (Object_Name)					
						    blnVerifyRes=False
							If Trim(strExpectedValue)="" OR UCase(strExpectedValue)="TRUE" then
								strExpectedValue= True 
							Else 
								strExpectedValue= False 
							End If

							arrStatus = Split ( strInputValue , ":" , -1, 1) 
							strGetValue = obj.GetROProperty ( arrStatus(0) )						
							strSetValue = arrStatus(1) 

							If CStr(strGetValue) = Cstr(strSetValue) Then
								blnVerifyRes = True
								obj.Highlight
							Else
								blnVerifyRes = False 
							End If
							If blnVerifyRes Then
								If strExpectedValue then  'True Case 
									strDesc ="VERIFYTEXTBOXSTATUS: The text box named " & chr(34) & strlabel & chr(34) & " get reflected with property as " & chr(34) & strSetValue  & chr(34) & " and highlighted" 
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micPass,"Step VERIFYTEXTBOXSTATUS", strDesc
									Reporter.Filter = rfDisableAll
								Else
									strDesc =strpartdesc&" at the row number "&iRowCnt+1&" the Link " & chr(34) & strLabel & chr(34) &"  exists, when it is not expected."
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micFail,"Step VERIFYTEXTBOXSTATUS", strDesc
									objEnvironmentVariables.TestCaseStatus=False
									Reporter.Filter = rfDisableAll
								End If
							Else
								If strExpectedValue then	''true
									strDesc = strpartdesc&" at the row number "&iRowCnt+1&" the text box named " & chr(34) & strlabel & chr(34) & " NOT get reflected with proper property and not highlighted"  
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micFail,"Step VERIFYTEXTBOXSTATUS", strDesc
									objEnvironmentVariables.TestCaseStatus=False
									Reporter.Filter = rfDisableAll
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0										
								Else
									strDesc = "VERIFYTEXTBOXSTATUS:  The text box named " & chr(34) & strlabel & chr(34) & " NOT get reflected with proper property as expected"  
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micPass,"Step VERIFYTEXTBOXSTATUS", strDesc
									Reporter.Filter = rfDisableAll
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1									
								End If						 
							End If



							'Select the radio button
							Case "RADIOSELECT" 
								set obj = objsub.WebRadioGroup(Object_Name)	
								If obj.exist(5) Then
									obj.Select strInputValue
									wait(1)
									blnVerify = True
								Else
									blnVerify = False
								End If	
								
								If blnVerify Then								
									strDesc="RADIOSELECT: The radio button "  & chr(34) & strLabel & chr(34) &" has been selected. Button Selected:"& chr(34) & strInputValue & chr(34) & "."
									Reporter.Filter = rfEnableAll
									Reporter.ReportEvent micDone,"Step RADIOSELECT", " The radio button "  &   strLabel &  "  has been selected." 
									Reporter.Filter = rfDisableAll
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2																				
								Else
									strDesc=strpartdesc&" at the row number "& chr(34) & iRowCnt+1 & chr(34) &" the field "& chr(34) &strLabel & chr(34) &" does not exist."	
									Reporter.Filter = rfEnableAll
									Reporter.ReportEvent micFail,"Step RADIOSELECT", " The radio button "& chr(34) & strLabel & chr(34) &"  does not exist."
									objEnvironmentVariables.TestCaseStatus=False
									Reporter.Filter = rfDisableAll
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0																
								End If

											  'Click the button
							Case "FIREFOXBUTTONCLICK"
									'Ram July 15th 2010 - Only for firefox

									If UCASE(Environment.Value ("BrowserName"))= "FIREFOX" Then

													If strParent = "DIALOG"  Then
																	set obj = objsub.WinButton(Object_Name)
				
													Else
																	set obj = objsub.WebButton(Object_Name)                                                                                                                                                                         
													End if

													If  UCase ( strTestDataReference) = "OPTIONAL"  Then                                                                                                                                                                                                                                                                          
																	If blnOptional = True and  obj.Exist(1)  Then
																					obj.Click
																					strDesc="FIREFOXBUTTONCLICK: action on " & chr(34) & strLabel & chr(34) &" successfully performed."
																					Reporter.Filter = rfEnableAll
																					Reporter.ReportEvent micdone,"Step FIREFOXBUTTONCLICK", " The button "& chr(34) & strLabel & chr(34) &" has been clicked." 
																					Reporter.Filter = rfDisableAll                                                                                                                                                                                                         
																					clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2
																	End If 
													Else                                                                                                                                                                                        
																	If obj.Exist(5) Then                                                                                                                          
																					obj.Click
																					strDesc="FIREFOXBUTTONCLICK: action on " & chr(34) & strLabel & chr(34) &" successfully performed."
																					Reporter.Filter = rfEnableAll
																					Reporter.ReportEvent micdone,"Step FIREFOXBUTTONCLICK", " The button "& chr(34) & strLabel & chr(34) &" has been clicked." 
																					Reporter.Filter = rfDisableAll                                                                                                                                                                                                         
																					clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2
																	Else
																					strDesc=strpartdesc&" at the row number "& chr(34) & iRowCnt+1 & chr(34) &" the field "& chr(34) &strLabel & chr(34) &" does not exist."             
																					Reporter.Filter = rfEnableAll
																					Reporter.ReportEvent micFail,"Step FIREFOXBUTTONCLICK", " The button "& chr(34) & strLabel & chr(34) &"  does not exist."
																					objEnvironmentVariables.TestCaseStatus=False
																					Reporter.Filter = rfDisableAll
																					clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
																					clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0                                                                                                                                                                                                                                                                                                                                                                                                      
																	End If 
													End If
									 End If


                                'Click the button
								Case "BUTTONCLICK"
										If strParent = "DIALOG"  Then
											set obj = objsub.WinButton(Object_Name)

										Else
											set obj = objsub.WebButton(Object_Name)											
										End if

										If  UCase ( strTestDataReference) = "OPTIONAL"  Then																	
											If blnOptional = True and  obj.Exist(1)  Then
												obj.Click
												strDesc="BUTTONCLICK: action on " & chr(34) & strLabel & chr(34) &" successfully performed."
												Reporter.Filter = rfEnableAll
												Reporter.ReportEvent micdone,"Step BUTTONCLICK", " The button "& chr(34) & strLabel & chr(34) &" has been clicked." 
												Reporter.Filter = rfDisableAll													
												clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2
											End If 
										Else												
											If obj.Exist(5) Then 								
												obj.Click
												strDesc="BUTTONCLICK: action on " & chr(34) & strLabel & chr(34) &" successfully performed."
												Reporter.Filter = rfEnableAll
												Reporter.ReportEvent micdone,"Step BUTTONCLICK", " The button "& chr(34) & strLabel & chr(34) &" has been clicked." 
												Reporter.Filter = rfDisableAll													
												clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2
											Else
												strDesc=strpartdesc&" at the row number "& chr(34) & iRowCnt+1 & chr(34) &" the field "& chr(34) &strLabel & chr(34) &" does not exist."	
												Reporter.Filter = rfEnableAll
												Reporter.ReportEvent micFail,"Step BUTTONCLICK", " The button "& chr(34) & strLabel & chr(34) &"  does not exist."
												objEnvironmentVariables.TestCaseStatus=False
												Reporter.Filter = rfDisableAll
												clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
												clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0																									
											End If 
										End If

						
							Case "VERIFYMULTIPLELINKS"
							'@Created: 23-3-10 
							'@Author: Ram, 
							'@Purpose: Iin order to accomodate various checkpoints when there's a requirement to check multiple links. Not using the VERIFYLINKEXIST as it needs to be revisited inorder accomodate this functionality.
							'@Input: <<TestData>> (i.e: column name in which the links are added. This would be pesent in the Test Data xls file under the correspoding appln sheet name. User can also place the links to be verified
							'in the form of x:y:z: seperated by colons
							'@Where to place: In StrInputDataColumn


	
																							If  Environment.Value("CurrentBrowser")<>"" Then

								If UCASE(Environment.Value("CurrentBrowser"))=UCASE(Environment.Value ("BrowserName")) Then


							Set obj = objsub.Link(Object_Name)
							'Value is coming from Excel sheet in the form of an array, seperated by ":"

							If Trim(strDbValue) <> "" Then 
								
								strArrayInputValue=Split(strDbValue,":")
								For arrCount=0 to UBOUND(strArrayInputValue)
									arrValue=strArrayInputValue(arrCount)

									'Split to get the index of the value
									strArrValue=Split(arrValue,"_")
									'1. Set the text
                                    obj.setTOProperty "text",TRIM(strArrValue(0))
									'2.Check for the index and set the
									If  UBOUND(strArrValue)>0 Then
										obj.setTOProperty "index",TRIM(strArrValue(1))
									Else
    										obj.setTOProperty "index","0"
									End If  

									
									'Check if the obj exists with the properties defined above
									'*8**************************************************************
									blnVerifyRes=False
									If UCase(CStr(obj.Exist(0)))Then
										blnVerifyRes = True 
										obj.Highlight
									Else
										blnVerifyRes = False
									End If


									'Write the results
									'******************
                                    If blnVerifyRes Then
										strDesc ="VERIFYMULTIPLELINKS: Link " & chr(34) & strLabel & chr(34) &" - " & chr(34) & strArrValue(0) & chr(34) & " exists as expected."
										clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
										Reporter.Filter = rfEnableAll 
										Reporter.ReportEvent micPass,"Step VERIFYMULTIPLELINKS", strDesc
										Reporter.Filter = rfDisableAll
									Else
										If UCASE(TRIM(strTestDataReference))<>"OPTIONAL" Then

											strDesc ="VERIFYMULTIPLELINKS: Link " & chr(34) & strLabel & chr(34) &" with the propery - TEXT - " & chr(34) & strArrValue(0) & chr(34) & " doesn't exist as expected."
											clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micFail,"Step VERIFYMULTIPLELINKS", strDesc
											objEnvironmentVariables.TestCaseStatus=False
											Reporter.Filter = rfDisableAll

										End If
									End If
								Next

							'Value is coming from the script itself, seperated by ":"															
							ElseIf strInputValue<>"" Then
								strArrayInputValue=Split(strInputValue,":")
								For arrCount=0 to UBOUND(strArrayInputValue)
									arrValue=strArrayInputValue(arrCount)

									'Split to get the index of the value
									strArrValue=Split(arrValue,"_")
									'1. Set the text
                                    obj.setTOProperty "text",TRIM(strArrValue(0))
									'2.Check for the index and set the
									If  UBOUND(strArrValue)>0 Then
										obj.setTOProperty "index",TRIM(strArrValue(1))
									Else
										obj.setTOProperty "index","0"
									End If		

									'Check if the obj exists with the properties defined above
									'*8**************************************************************
									blnVerifyRes=False
									If UCase(CStr(obj.Exist(0)))Then
										blnVerifyRes = True 
										obj.Highlight
									Else
										blnVerifyRes = False
									End If
		

									'Write the results
									'******************
                                    If blnVerifyRes Then
										strDesc ="VERIFYMULTIPLELINKS: Link " & chr(34) & strLabel & chr(34) &" - " & chr(34) & strArrValue(0) & chr(34) & " exists as expected."
										clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
										Reporter.Filter = rfEnableAll 
										Reporter.ReportEvent micPass,"Step VERIFYMULTIPLELINKS", strDesc
										Reporter.Filter = rfDisableAll
									Else
										If  UCASE(TRIM(strTestDataReference))<>"OPTIONAL" Then 
				
											strDesc ="VERIFYMULTIPLELINKS: Link " & chr(34) & strLabel & chr(34) &" with the propery - TEXT" & chr(34) & strArrValue(0) & chr(34) & " doesn't exist as expected."
											clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micFail,"Step VERIFYMULTIPLELINKS", strDesc
											objEnvironmentVariables.TestCaseStatus=False
											Reporter.Filter = rfDisableAll

										End If
									End If      
								Next
							End If    
						strDbValue=""
						strInputValue=""

						End If
						Else
	
							Set obj = objsub.Link(Object_Name)
							'Value is coming from Excel sheet in the form of an array, seperated by ":"

							If Trim(strDbValue) <> "" Then 

								strArrayInputValue=Split(strDbValue,":")
								For arrCount=0 to UBOUND(strArrayInputValue)
									arrValue=strArrayInputValue(arrCount)

									'Split to get the index of the value
									strArrValue=Split(arrValue,"_")
									'1. Set the text
                                    obj.setTOProperty "text",TRIM(strArrValue(0))
									'2.Check for the index and set the
									If  UBOUND(strArrValue)>0 Then
										obj.setTOProperty "index",TRIM(strArrValue(1))
									Else
    										obj.setTOProperty "index","0"
									End If  

									
									'Check if the obj exists with the properties defined above
									'*8**************************************************************
									blnVerifyRes=False
									If UCase(CStr(obj.Exist(0)))Then
										blnVerifyRes = True 
										obj.Highlight
									Else
										blnVerifyRes = False
									End If
		

									'Write the results
									'******************
                                    If blnVerifyRes Then
										strDesc ="VERIFYMULTIPLELINKS: Link " & chr(34) & strLabel & chr(34) &" - " & chr(34) & strArrValue(0) & chr(34) & " exists as expected."
										clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
										Reporter.Filter = rfEnableAll 
										Reporter.ReportEvent micPass,"Step VERIFYMULTIPLELINKS", strDesc
										Reporter.Filter = rfDisableAll
									Else
										If UCASE(TRIM(strTestDataReference))<>"OPTIONAL" Then

											strDesc ="VERIFYMULTIPLELINKS: Link " & chr(34) & strLabel & chr(34) &" with the propery - TEXT - " & chr(34) & strArrValue(0) & chr(34) & " doesn't exist as expected."
											clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micFail,"Step VERIFYMULTIPLELINKS", strDesc
											objEnvironmentVariables.TestCaseStatus=False
											Reporter.Filter = rfDisableAll

										End If
									End If
								Next

							'Value is coming from the script itself, seperated by ":"															
							ElseIf strInputValue<>"" Then
								strArrayInputValue=Split(strInputValue,":")
								For arrCount=0 to UBOUND(strArrayInputValue)
									arrValue=strArrayInputValue(arrCount)

									'Split to get the index of the value
									strArrValue=Split(arrValue,"_")
									'1. Set the text
                                    obj.setTOProperty "text",TRIM(strArrValue(0))
									'2.Check for the index and set the
									If  UBOUND(strArrValue)>0 Then
										obj.setTOProperty "index",TRIM(strArrValue(1))
									Else
										obj.setTOProperty "index","0"
									End If		

									'Check if the obj exists with the properties defined above
									'*8**************************************************************
									blnVerifyRes=False
									If UCase(CStr(obj.Exist(0)))Then
										blnVerifyRes = True 
										obj.Highlight
									Else
										blnVerifyRes = False
									End If


									'Write the results
									'******************
                                    If blnVerifyRes Then
										strDesc ="VERIFYMULTIPLELINKS: Link " & chr(34) & strLabel & chr(34) &" - " & chr(34) & strArrValue(0) & chr(34) & " exists as expected."
										clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
										Reporter.Filter = rfEnableAll 
										Reporter.ReportEvent micPass,"Step VERIFYMULTIPLELINKS", strDesc
										Reporter.Filter = rfDisableAll
									Else
										If  UCASE(TRIM(strTestDataReference))<>"OPTIONAL" Then 
				
											strDesc ="VERIFYMULTIPLELINKS: Link " & chr(34) & strLabel & chr(34) &" with the propery - TEXT" & chr(34) & strArrValue(0) & chr(34) & " doesn't exist as expected."
											clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micFail,"Step VERIFYMULTIPLELINKS", strDesc
											objEnvironmentVariables.TestCaseStatus=False
											Reporter.Filter = rfDisableAll

										End If
									End If      
								Next
							End If    
						strDbValue=""
						strInputValue=""
						End If
						strDbValue=""
						strInputValue=""
						'Verify that whether link exist
						Case "VERIFYLINKEXIST"



							If  Environment.Value("CurrentBrowser")<>"" Then

								If UCASE(Environment.Value("CurrentBrowser"))=UCASE(Environment.Value ("BrowserName")) Then

							blnOptParam=False
							Set obj = objsub.Link(Object_Name)

							If Trim(strInputValue) <> "" Then 
								'added by Ram' 22-3-10 inorder to define index as well, in case one or more objects of the same name exists, so adding code to change index @ runtime as well
								strArrayInputValue=Split(strInputValue,":")
								If UBOUND(strArrayInputValue)>0 Then
									'Setting the text to the value being specified in array (0)
									If  strArrayInputValue(0)<>"" Then
										obj.setTOProperty "text",strArrayInputValue(0)	
										strLabel = strArrayInputValue(0)
									End If
									'Setting the index to the value being specified in array (1)
									obj.setTOProperty "index",strArrayInputValue(1)	
								
								Else
									obj.setTOProperty "text",strInputValue	
									strLabel = strInputValue
								End If
							End If                           					

												
							blnVerifyRes=False
							If Trim(strExpectedValue)="" OR UCase(strExpectedValue)="TRUE" then
								strExpectedValue= True 
							Else 
								strExpectedValue= False 
							End If


'							If obj.Exist(0) Then
'								blnVerifyRes = True 
'								obj.Highlight
'							Else
'								blnVerifyRes = False
'							End If							

							'added by Ram' 22-3-10 inorder to check for a specific property of a link - This would be passed under the optional parameter field
							'********************************************************************************************************************************************************
							'Eg: Visible:True, href:www.google.com,height:20,etc
							'Note: Incase of you are checking href is blank or . Pass the parameters as href:void
							If Trim(strOptParam)<>"" then
								arrOptParam=Split(strOptParam,":")
                                blnOptParam=True 
								If  arrOptParam(0)<>"ENV"  Then
									'Get the actual propery from the application
									strActualProp=obj.GetROProperty(arrOptParam(0))

									If  UCASE(arrOptParam(0))="HREF" AND UCASE(arrOptParam(1))="VOID" Then
										'Some times href link might be blank or might have the value void
										If  strActualProp="" Then
											blnPass=True
										'In case it has the value as "javascript:void(0);"
										ElseIf (INSTR(strActualProp,arrOptParam(1))>0) Then
											blnPass=True
										'In case there's a real value then, false/fail
										Else
											blnPass=False
										End If
									'In case of some other property 
									Else
										If  strActualProp=arrOptParam(1) Then
											blnPass=True
										Else
											blnPass=False
										End If
									End If
								'Incase the ENV value exists and the link is checked based on that value
								ElseIf arrOptParam(0)="ENV" Then

									strProductName = Environment.Value( Trim( arrOptParam(1) ) )
									'Setting the text to the value being specified in Env Varbl

									strLabel=strProductName
									obj.setTOProperty "text",strProductName		
									blnPass=True
								End If
							End If
'							
'							If UCase(CStr(obj.Exist(0)))Then
'								blnVerifyRes = True 
'							Else
'								blnVerifyRes = False
'							End If	

'							If UCase(obj.Exist(0)) Then
'								blnVerifyRes = True 
'								obj.Highlight
'							Else
'								blnVerifyRes = False
'							End If	

							If obj.Exist(0) Then
								blnVerifyRes = True 
								obj.Highlight
							Else
								blnVerifyRes = False
							End If




							If blnVerifyRes Then

								'Check if the propery exists or not for the link
								'***************************************************
								If strExpectedValue AND blnOptParam Then
									If blnPass Then
							
										strDesc ="VERIFYLINKEXIST: Link " & chr(34) & strLabel & chr(34) &" with the propery " & chr(34) & arrOptParam(0) & chr(34) & " and value " & chr(34) & arrOptParam(1) & chr(34) & " exist as expected."
										clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
										Reporter.Filter = rfEnableAll 
										Reporter.ReportEvent micPass,"Step VERIFYLINKEXIST", strDesc
										Reporter.Filter = rfDisableAll
									Else
										strDesc ="VERIFYLINKEXIST: Link " & chr(34) & strLabel & chr(34) &" with the propery " & chr(34) & arrOptParam(0) & chr(34) & " & value " & chr(34) & arrOptParam(1) & chr(34) & " doesn't exist as expected."
                                        clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
										clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
										Reporter.Filter = rfEnableAll 
										Reporter.ReportEvent micFail,"Step VERIFYLINKEXIST", strDesc
										objEnvironmentVariables.TestCaseStatus=False
										Reporter.Filter = rfDisableAll
									End If
								ElseIf strExpectedValue then  'True Case 
									strDesc ="VERIFYLINKEXIST: Link " & chr(34) & strLabel & chr(34) &" exist as expected."
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micPass,"Step VERIFYLINKEXIST", strDesc
									Reporter.Filter = rfDisableAll


								Else
									If UCASE(TRIM(strTestDataReference))<>"OPTIONAL" Then
																		strDesc =strpartdesc&" at the row number "&iRowCnt+1&" the Link " & chr(34) & strLabel & chr(34) &"  exists, when it is not expected."
																		clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
																		clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
																		Reporter.Filter = rfEnableAll 
																		Reporter.ReportEvent micFail,"Step VERIFYLINKEXIST", strDesc
																		objEnvironmentVariables.TestCaseStatus=False
																		Reporter.Filter = rfDisableAll
									End If
	
								End If
							Else
								If strExpectedValue then	
									If UCASE(TRIM(strTestDataReference))<>"OPTIONAL" Then
												strDesc = strpartdesc&" at the row number "&iRowCnt+1&" the Link "& chr(34) & strLabel & chr(34) &" does not exist, when it is expected"
												Reporter.Filter = rfEnableAll 
												Reporter.ReportEvent micFail,"Step VERIFYLINKEXIST", strDesc
												objEnvironmentVariables.TestCaseStatus=False
												Reporter.Filter = rfDisableAll
												clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
												clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0			
									  End If
																				
								Else
									strDesc = "VERIFYLINKEXIST: The Link "& chr(34) & strLabel & chr(34) &" does not exists as expected."
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micPass,"Step VERIFYLINKEXIST", strDesc
									Reporter.Filter = rfDisableAll
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1									
								End If						 
							End If
						End If
						Else
								blnOptParam=False
							Set obj = objsub.Link(Object_Name)

							If Trim(strInputValue) <> "" Then 
								'added by Ram' 22-3-10 inorder to define index as well, in case one or more objects of the same name exists, so adding code to change index @ runtime as well
								strArrayInputValue=Split(strInputValue,":")
								If UBOUND(strArrayInputValue)>0 Then
									'Setting the text to the value being specified in array (0)
									If  strArrayInputValue(0)<>"" Then
										obj.setTOProperty "text",strArrayInputValue(0)	
										strLabel = strArrayInputValue(0)
									End If
									'Setting the index to the value being specified in array (1)
									obj.setTOProperty "index",strArrayInputValue(1)	
										
								Else
									obj.setTOProperty "text",strInputValue	
									strLabel = strInputValue
								End If
							End If                           					

												
							blnVerifyRes=False
							If Trim(strExpectedValue)="" OR UCase(strExpectedValue)="TRUE" then
								strExpectedValue= True 
							Else 
								strExpectedValue= False 
							End If

'							If obj.Exist(0) Then
'								blnVerifyRes = True 
'								obj.Highlight
'							Else
'								blnVerifyRes = False
'							End If							

							'added by Ram' 22-3-10 inorder to check for a specific property of a link - This would be passed under the optional parameter field
							'********************************************************************************************************************************************************
							'Eg: Visible:True, href:www.google.com,height:20,etc
							'Note: Incase of you are checking href is blank or void. Pass the parameters as href:void
							If Trim(strOptParam)<>"" then
								arrOptParam=Split(strOptParam,":")
                                blnOptParam=True 
								If  arrOptParam(0)<>"ENV"  Then
									'Get the actual propery from the application
									strActualProp=obj.GetROProperty(arrOptParam(0))

									If  UCASE(arrOptParam(0))="HREF" AND UCASE(arrOptParam(1))="VOID" Then
										'Some times href link might be blank or might have the value void
										If  strActualProp="" Then
											blnPass=True
										'In case it has the value as "javascript:void(0);"
										ElseIf (INSTR(strActualProp,arrOptParam(1))>0) Then
											blnPass=True
										'In case there's a real value then, false/fail
										Else
											blnPass=False
										End If
									'In case of some other property 
									Else
										If  strActualProp=arrOptParam(1) Then
											blnPass=True
										Else
											blnPass=False
										End If
									End If
								'Incase the ENV value exists and the link is checked based on that value
								ElseIf arrOptParam(0)="ENV" Then

		
									strProductName = Environment.Value( Trim( arrOptParam(1) ) )
									'Setting the text to the value being specified in Env Varbl
		
									strLabel=strProductName
									obj.setTOProperty "text",strProductName		
									blnPass=True
								End If
							End If
'							
'							If UCase(CStr(obj.Exist(0)))Then
'								blnVerifyRes = True 
'							Else
'								blnVerifyRes = False
'							End If	

'							If UCase(obj.Exist(0)) Then
'								blnVerifyRes = True 
'								obj.Highlight
'							Else
'								blnVerifyRes = False
'							End If	

							If obj.Exist(0) Then
								blnVerifyRes = True 
								obj.Highlight
							Else
								blnVerifyRes = False
							End If




							If blnVerifyRes Then

								'Check if the propery exists or not for the link
								'***************************************************
								If strExpectedValue AND blnOptParam Then
									If blnPass Then

										strDesc ="VERIFYLINKEXIST: Link " & chr(34) & strLabel & chr(34) &" with the propery " & chr(34) & arrOptParam(0) & chr(34) & " and value " & chr(34) & arrOptParam(1) & chr(34) & " exist as expected."
										clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
										Reporter.Filter = rfEnableAll 
										Reporter.ReportEvent micPass,"Step VERIFYLINKEXIST", strDesc
										Reporter.Filter = rfDisableAll
									Else
										strDesc ="VERIFYLINKEXIST: Link " & chr(34) & strLabel & chr(34) &" with the propery " & chr(34) & arrOptParam(0) & chr(34) & " & value " & chr(34) & arrOptParam(1) & chr(34) & " doesn't exist as expected."
                                        clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
										clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
										Reporter.Filter = rfEnableAll 
										Reporter.ReportEvent micFail,"Step VERIFYLINKEXIST", strDesc
										objEnvironmentVariables.TestCaseStatus=False
										Reporter.Filter = rfDisableAll
									End If
								ElseIf strExpectedValue then  'True Case 
									strDesc ="VERIFYLINKEXIST: Link " & chr(34) & strLabel & chr(34) &" exist as expected."
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micPass,"Step VERIFYLINKEXIST", strDesc
									Reporter.Filter = rfDisableAll


								Else
									If UCASE(TRIM(strTestDataReference))<>"OPTIONAL" Then
																		strDesc =strpartdesc&" at the row number "&iRowCnt+1&" the Link " & chr(34) & strLabel & chr(34) &"  exists, when it is not expected."
																		clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
																		clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
																		Reporter.Filter = rfEnableAll 
																		Reporter.ReportEvent micFail,"Step VERIFYLINKEXIST", strDesc
																		objEnvironmentVariables.TestCaseStatus=False
																		Reporter.Filter = rfDisableAll
									End If
	
								End If
							Else
								If strExpectedValue then	
									If UCASE(TRIM(strTestDataReference))<>"OPTIONAL" Then
												strDesc = strpartdesc&" at the row number "&iRowCnt+1&" the Link "& chr(34) & strLabel & chr(34) &" does not exist, when it is expected"
												Reporter.Filter = rfEnableAll 
												Reporter.ReportEvent micFail,"Step VERIFYLINKEXIST", strDesc
												objEnvironmentVariables.TestCaseStatus=False
												Reporter.Filter = rfDisableAll
												clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
												clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0			
									  End If
																				
								Else
									strDesc = "VERIFYLINKEXIST: The Link "& chr(34) & strLabel & chr(34) &" does not exists as expected."
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micPass,"Step VERIFYLINKEXIST", strDesc
									Reporter.Filter = rfDisableAll
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1									
								End If						 
							End If


						End if



						Case "VERIFYMAXLENGTHALLOWED"
								set obj = objsub.WebEdit(Object_Name)	
								obj.set ""		
								set objShell = CreateObject("WScript.Shell")
                                		
								strVal = strInputValue
								strLength = Len(strVal)                    
								obj.Click
		
								For intLoopCnt=0 to strLength-1
									strTemp = Left( Right(strVal , strLength - intLoopCnt ) , 1 )										
									'obj.Click
									'wait 1
									objShell.SendKeys strTemp
								Next

								intMaxLength  = obj.GetROProperty("max length")	
								strSetValue = Left ( strInputValue , len( strInputvalue) -1 )
								strGetValue  = obj.GetROProperty("value")
	
								If CInt( intMaxLength ) = Cint ( strOptParam ) Then ' And  strSetValue = strGetValue Then
									strDesc = "VERIFYMAXLENGTHALLOWED: Maximum length " & chr(34) & intMaxLength & chr(34) & " allowed on text box " & chr(34) & strLabel & chr(34)
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1						
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micPass,"Step VERIFYMAXLENGTHALLOWED", strDesc
									Reporter.Filter = rfDisableAll
								Else
									strDesc = strpartdesc & " at the row number " &iRowCnt+1& " Maximum length is not correct"													
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micFail,"Step VERIFYMAXLENGTHALLOWED", strDesc
									objEnvironmentVariables.TestCaseStatus=False 
									Reporter.Filter = rfDisableAll
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
								End If



						'Verify that whether image exist
						Case "VERIFYIMAGEEXIST"						
blnIsOptional=False
					If  Environment.Value("CurrentBrowser")<>"" Then

						If UCASE(Environment.Value("CurrentBrowser"))=UCASE(Environment.Value ("BrowserName")) Then
							set obj = objsub.Image(Object_Name)


							'Ram (7-4-10) - Added to get the type of property to be set from the testdata ref in case we are using a gen image (eg: Alt or File Name)
							'************************************************************************************************************************************************************
							'Check for OPTIONAL
							If UCASE(TRIM(strOptParam))="OPTIONAL" Then
								blnIsOptional=True
							End If

							If  strTestDataReference<>"" Then '
                                    strTestDataReference=TRIM(strTestDataReference)			
									arrTDR=Split(strTestDataReference,"~")
									If UBOUND(arrTDR)>0 Then
										obj.SetTOProperty TRIM(arrTDR(0)),TRIM(arrTDR(1))
									Else
										strProperty=strTestDataReference		
		
									End If
																					
							Else
									'Nothing done as of now. For future use
							End If

'							If  strTestDataReference<>"" Then '
'                                    strProperty=TRIM(strTestDataReference)									
'							Else
'									'Nothing done as of now. For future use
'							End If

							'Ram (7-4-10) 
							'***************
							'Get the input value which can be either the image alt name or file name, user can either hard code it directly or send it via ENV value for cases like product name (Eg: Checkout Image)
							'Note: Incase the image name or file name is already there in the OR and user just wants to pass the INDEX then in that case he/she has pass the keyword as INDEX:0, INDEX:1 , etc
							'No need to pass the type of property in strTestDataReference, It can be left blank

                            If Trim(strInputValue) <> "" Then 
								'added by Ram' 23-3-10 inorder to define alt propery and index as well, in case one or more iamges of the same name or property exists, 
								'Input: The order of passing the value would be index  - This has to be passed under the strInputValue columnas
								arrInputVal=Split(strInputValue,":")
								Select Case UCASE(arrInputVal(0))
									Case "INDEX"
										obj.setTOProperty "index",TRIM(arrInputVal(1)) 
									Case "ENV" 'Ram 7-4-10
										strPropValue = Environment.Value(Trim( arrInputVal(1)))
										obj.setTOProperty strProperty,strPropValue
										'Incase some other property needs to be passed along with ENV value 
										If UBOUND(arrInputVal)>1 Then
											'In case of index
		
											If  UCASE(TRIM(arrInputVal(2)))="INDEX" Then

												obj.setTOProperty "index",TRIM(arrInputVal(3)) 
											End If
										End If
								End Select								
							End If    

						
							blnverifyRes=False
							If Trim(strExpectedValue)="" OR  UCase(strExpectedValue)="TRUE"  then
								strExpectedValue= True 
							Else
								strExpectedValue= False 
							End If
							
							If UCase(CStr(obj.Exist(5))) Then
								blnVerifyRes = True 
								obj.Highlight
								
							Else
								blnVerifyRes = False 
							End If		
			
							
							If blnVerifyRes Then
								If strExpectedValue Then
									'Added by Ram 23-3-10 - To fetch the file name to make sure it has not changed under this reg, cycle
									strDesc ="VERIFYIMAGEEXIST: Image " & chr(34) & strLabel & chr(34) & " exist. File Value of the image is : " & chr(34) & obj.GetROProperty("file name") & chr(34) & " and " & "Alt value is : " & chr(34) &  obj.GetROProperty("alt") & chr(34)  
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micPass,"Step VERIFYIMAGEEXIST", strDesc
									Reporter.Filter = rfDisableAll
								Else
									strDesc =strpartdesc&" at the row number " & chr(34) &  iRowCnt+1 & chr(34) & " Image " & chr(34) & strLabel & chr(34) & " exists but it is not expected"
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micFail,"Step VERIFYIMAGEEXIST", strDesc
									objEnvironmentVariables.TestCaseStatus=False
									Reporter.Filter = rfDisableAll
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
								End If
							Else
								If strExpectedValue Then	
									If NOT(blnIsOptional) Then
										strDesc = strpartdesc&" at the row number " & chr(34) &  iRowCnt+1 & chr(34) & " the Image "& chr(34) & strLabel & chr(34) &" does not exist exists but it is expected"
										Reporter.Filter = rfEnableAll 
										Reporter.ReportEvent micFail,"Step VERIFYIMAGEEXIST", strDesc
										objEnvironmentVariables.TestCaseStatus=False
										Reporter.Filter = rfDisableAll
										clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
										clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
									End If
												
								Else
									strDesc = "VERIFYIMAGEEXIST: The Image "& chr(34) & strLabel & chr(34) &" does not exists"
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micPass,"Step VERIFYIMAGEEXIST", strDesc
									Reporter.Filter = rfDisableAll
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
								End If
							End If
						End If
					Else
							set obj = objsub.Image(Object_Name)
	

							'Ram (7-4-10) - Added to get the type of property to be set from the testdata ref in case we are using a gen image (eg: Alt or File Name)

                            	'************************************************************************************************************************************************************

							If UCASE(TRIM(strOptParam))="OPTIONAL" Then
								blnIsOptional=True
							End If

							If  strTestDataReference<>"" Then '
                                    strTestDataReference=TRIM(strTestDataReference)			
									arrTDR=Split(strTestDataReference,"~")
									If UBOUND(arrTDR)>0 Then
										obj.SetTOProperty TRIM(arrTDR(0)),TRIM(arrTDR(1))
									Else
										strProperty=strTestDataReference		

									End If
																					
							Else
									'Nothing done as of now. For future use
							End If

'							If  strTestDataReference<>"" Then '
'                                    strProperty=TRIM(strTestDataReference)									
'							Else
'									'Nothing done as of now. For future use
'							End If

							'Ram (7-4-10) 
							'***************
							'Get the input value which can be either the image alt name or file name, user can either hard code it directly or send it via ENV value for cases like product name (Eg: Checkout Image)
							'Note: Incase the image name or file name is already there in the OR and user just wants to pass the INDEX then in that case he/she has pass the keyword as INDEX:0, INDEX:1 , etc
							'No need to pass the type of property in strTestDataReference, It can be left blank

                            If Trim(strInputValue) <> "" Then 
								'added by Ram' 23-3-10 inorder to define alt propery and index as well, in case one or more iamges of the same name or property exists, 
								'Input: The order of passing the value would be index  - This has to be passed under the strInputValue columnas
								arrInputVal=Split(strInputValue,":")
								Select Case UCASE(arrInputVal(0))
									Case "INDEX"
										obj.setTOProperty "index",TRIM(arrInputVal(1)) 
									Case "ENV" 'Ram 7-4-10
										strPropValue = Environment.Value(Trim( arrInputVal(1)))
										obj.setTOProperty strProperty,strPropValue
										'Incase some other property needs to be passed along with ENV value 
										If UBOUND(arrInputVal)>1 Then
											'In case of index

											If  UCASE(TRIM(arrInputVal(2)))="INDEX" Then

												obj.setTOProperty "index",TRIM(arrInputVal(3)) 
											End If
										End If
								End Select								
							End If    
						
							blnverifyRes=False
							If Trim(strExpectedValue)="" OR  UCase(strExpectedValue)="TRUE"  then
								strExpectedValue= True 
							Else
								strExpectedValue= False 
							End If
							
							If UCase(CStr(obj.Exist(5))) Then
								blnVerifyRes = True 
								obj.Highlight
								
							Else
								blnVerifyRes = False 
							End If		
	
							
							If blnVerifyRes Then
								If strExpectedValue Then
									'Added by Ram 23-3-10 - To fetch the file name to make sure it has not changed under this reg, cycle
									strDesc ="VERIFYIMAGEEXIST: Image " & chr(34) & strLabel & chr(34) & " exist. File Value of the image is : " & chr(34) & obj.GetROProperty("file name") & chr(34) & " and " & "Alt value is : " & chr(34) &  obj.GetROProperty("alt") & chr(34)  
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micPass,"Step VERIFYIMAGEEXIST", strDesc
									Reporter.Filter = rfDisableAll
								Else
									strDesc =strpartdesc&" at the row number " & chr(34) &  iRowCnt+1 & chr(34) & " Image " & chr(34) & strLabel & chr(34) & " exists but it is not expected"
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micFail,"Step VERIFYIMAGEEXIST", strDesc
									objEnvironmentVariables.TestCaseStatus=False
									Reporter.Filter = rfDisableAll
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
								End If
							Else
								If strExpectedValue Then	
									If NOT(blnIsOptional) Then
									strDesc = strpartdesc&" at the row number " & chr(34) &  iRowCnt+1 & chr(34) & " the Image "& chr(34) & strLabel & chr(34) &" does not exist exists but it is expected"
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micFail,"Step VERIFYIMAGEEXIST", strDesc
									objEnvironmentVariables.TestCaseStatus=False
									Reporter.Filter = rfDisableAll
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0			
									End If
							
								Else
									strDesc = "VERIFYIMAGEEXIST: The Image "& chr(34) & strLabel & chr(34) &" does not exists"
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micPass,"Step VERIFYIMAGEEXIST", strDesc
									Reporter.Filter = rfDisableAll
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
								End If
							End If

					End If



					'Verify that whether text box exist
						Case "VERIFYTEXTBOXEXIST"
							set obj = objsub.WebEdit(Object_Name)		
							blnverifyRes=False											
							If UCase( CStr (obj.Exist (2) ) ) Then
								blnverifyRes = CBool("TRUE")
								obj.Highlight
							Else
								blnVerifyRes = CBool("FALSE")
							End If

'							If UCase(strExpectedValue)="TRUE" OR Trim(strExpectedValue) ="" Then
'								blnverifyRes = True
'							Else
'								blnVerifyRes = False
'							End If 

							If  strOptParam<>""Then
								'Check whether a specific value is populated in the textbox or not
								Select Case UCASE(TRIM(strOptParam))
									Case "VALUE_EXISTS"
											strActualValue=TRIM(Obj.GetROProperty("value"))
											'A). In case you just want to check if the text box is populated with some value
											If  strInputValue="" Then
												'Check if the strActualValue is not empty
												If  strActualValue<>""Then
													blnConditionMet=True
													strExpValue=strActualValue
												Else
													blnConditionMet=False
												End If
											'B). In case you want to check a specific value in the text box
											ElseIf strInputValue<>"" Then
												arrInpValue=Split(strInputValue,":")
												If  UBOUND(arrInpValue)>0Then
													If  UCASE(TRIM(arrInpValue(0)))="ENV" Then
														strExpValue=TRIM(arrInpValue(1))
													End If
													If  UCASE(TRIM(arrInpValue(0)))="FETCH" Then
														strExpValue=Environment.Value( Trim(arrInpValue(1)))
													End If
												Else
													strExpValue=TRIM(strInputValue)
												End If
												'Checking
												If  strActualValue=strExpValue Then
													blnConditionMet=True
												Else
													blnConditionMet=False
												End If
											End If											

										'1. Check if the textbox exists, then proceed
											If blnverifyRes Then
												obj.HighLight

												'True
												If  blnConditionMet Then
													If UCase(strExpectedValue)="TRUE" or Trim(strExpectedValue) ="" then
														strDesc = "VERIFYTEXTBOXEXIST - VALUE EXIST: Text Box "& chr(34) & strLabel & chr(34) &" exists with the value " & chr(34) & strExpValue & chr(34) & "."
														clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1								
														Reporter.Filter = rfEnableAll 
														Reporter.ReportEvent micPass,"Step VERIFYTEXTBOXEXIST - VALUE EXIST", strDesc							 
														Reporter.Filter = rfDisableAll
													Else							
														strDesc = "VERIFYTEXTBOXEXIST - VALUE EXIST: Text Box "& chr(34) & strLabel & chr(34) &" exists with the value " & chr(34) & strExpValue & chr(34) & ", when it's not expected to be so."
														clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
														clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
														Reporter.Filter = rfEnableAll 
														Reporter.ReportEvent micFail,"Step VERIFYTEXTBOXEXIST", strDesc
														objEnvironmentVariables.TestCaseStatus=False
														Reporter.Filter = rfDisableAll
													End If
												Else ' False
													If UCase(strExpectedValue)="FALSE"  then
														strDesc = "VERIFYTEXTBOXEXIST - VALUE EXIST: Text Box "& chr(34) & strLabel & chr(34) &" doesn't exist  with the value " & chr(34) & strExpValue & chr(34) & ", as expected."
														clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1								
														Reporter.Filter = rfEnableAll 
														Reporter.ReportEvent micPass,"Step VERIFYTEXTBOXEXIST - VALUE EXIST", strDesc							 
														Reporter.Filter = rfDisableAll
													Else							
														strDesc = "VERIFYTEXTBOXEXIST - VALUE EXIST: Text Box "& chr(34) & strLabel & chr(34) &" doesn't exist  with the value " & chr(34) & strExpValue & chr(34) & ", when it's expected to be so. "
														clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
														clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
														Reporter.Filter = rfEnableAll 
														Reporter.ReportEvent micFail,"Step VERIFYTEXTBOXEXIST", strDesc
														objEnvironmentVariables.TestCaseStatus=False
														Reporter.Filter = rfDisableAll
													End If	
												End If
											Else
												strDesc = strpartdesc &" at the row number "&iRowCnt+1&" the Text Box " & chr(34) & strLabel & chr(34) &" does not exist, but it is required"
												Reporter.Filter = rfEnableAll 
												Reporter.ReportEvent micFail,"Step VERIFYTEXTBOXEXIST", strDesc
												objEnvironmentVariables.TestCaseStatus=False 
												Reporter.Filter = rfDisableAll
												clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables				   	
												clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
											End If
								End Select

							Else
							'In normal exists case
							'*************************
								If blnVerifyRes Then
									If UCase(strExpectedValue)="TRUE" or Trim(strExpectedValue) ="" then
										strDesc = "VERIFYTEXTBOXEXIST: Edit Box"& chr(34) & strLabel & chr(34) &" exists"
										clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1								
										Reporter.Filter = rfEnableAll 
										Reporter.ReportEvent micPass,"Step VERIFYTEXTBOXEXIST", strDesc							 
										Reporter.Filter = rfDisableAll
									Else							
										strDesc =strpartdesc&" at the row number "&iRowCnt+1&" the EditBox " & strLabel & chr(34) & " is present but it is not required"
										clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
										clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
										Reporter.Filter = rfEnableAll 
										Reporter.ReportEvent micFail,"Step VERIFYTEXTBOXEXIST", strDesc
										objEnvironmentVariables.TestCaseStatus=False
										Reporter.Filter = rfDisableAll
									End If
								Else
									If UCase(strExpectedValue)="FALSE" then	
										strDesc = "VERIFYTEXTBOXEXIST: The Edit Box "& chr(34) & strLabel & chr(34) & " does not exist as expected "
										Reporter.Filter = rfEnableAll 
										Reporter.ReportEvent micPass,"Step VERIFYTEXTBOXEXIST", strDesc
										Reporter.Filter = rfDisableAll
										clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1														
									Else
										strDesc = strpartdesc&" at the row number "&iRowCnt+1&" the Edit Box " & chr(34) & strLabel & chr(34) &" does not exist but it is required"
										Reporter.Filter = rfEnableAll 
										Reporter.ReportEvent micFail,"Step VERIFYTEXTBOXEXIST", strDesc
										objEnvironmentVariables.TestCaseStatus=False 
										Reporter.Filter = rfDisableAll
										clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables				   	
										clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
									End If
								End If    
							End If

						'Verify that whether radio button exist
						Case "VERIFYRADIOBUTTONEXIST"						    
							set obj = objsub.WebRadioGroup(Object_Name)						
''							If obj.exist(0) Then
''								AllItems = obj.GetROProperty("all items")                                             
''								bItemExists = False
''								arExpectedItems = Split(strInputValue,";")
''							  	For i=0 To UBound(arExpectedItems)
''									myPos = Instr(AllItems,Trim(arExpectedItems(i)))
''									If myPos<>0 Then
''										bItemExists = True
''									Else
''										bItemExists = False
''									End If
''								Next
''                          	End If						        
''
''							If UCase(bItemExists) Then
''								blnVerifyRes = CBool("TRUE")
''							Else
''								blnVerifyRes = CBool("FALSE")
''							End If
							If obj.exist(3) Then
								blnVerifyRes = CBool("TRUE")
								obj.Highlight
							Else
								blnVerifyRes = CBool("FALSE")
							End If

							If blnVerifyRes Then
								If UCase(strExpectedValue)="TRUE" OR UCase(strExpectedValue)=""then
									strDesc ="VERIFYRADIOBUTTONEXIST: Radio button " & chr(34) & strLabel & chr(34) & " exist."
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micPass,"Step VERIFYRADIOBUTTONEXIST", strDesc
									Reporter.Filter = rfDisableAll
								Else
									strDesc =strpartdesc&" at the row number "&iRowCnt+1&" the radio button " & chr(34) & strLabel & chr(34) & " exist when it is not expected."		
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micFail,"Step VERIFYRADIOBUTTONEXIST", strDesc
									objEnvironmentVariables.TestCaseStatus=False
									Reporter.Filter = rfDisableAll
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0																
								End If
							Else
								If UCase(strExpectedValue)="FALSE" then										
									strDesc ="VERIFYRADIOBUTTONEXIST: Radio button " & chr(34) & strLabel & chr(34) & " does not exist as expected."
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micPass,"Step VERIFYRADIOBUTTONEXIST", strDesc									
									Reporter.Filter = rfDisableAll
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1									
								Else
									strDesc = strpartdesc&" at the row number "&iRowCnt+1&" the radio button "& chr(34) & strLabel & chr(34) &" does not exist when it is expected."
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micFail,"Step VERIFYRADIOBUTTONEXIST", strDesc
									objEnvironmentVariables.TestCaseStatus=False
									Reporter.Filter = rfDisableAll
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0										
								End If							 
							End If

						'Verify that whether check box exist
						Case "VERIFYCHECKBOXEXIST"
							set obj = objsub.WebCheckBox(Object_Name)
							
							blnverifyRes=False											
							If UCase(CStr(obj.Exist(2))) Then
								blnverifyRes = CBool("TRUE")
								obj.Highlight
							Else
								blnVerifyRes = CBool("FALSE")
							End If

							If blnVerifyRes Then
								If UCase(strExpectedValue)="TRUE" then
									strDesc = "VERIFYCHECKBOXEXIST: The Checkbox "& chr(34) & strLabel & chr(34) & " exists as expected."
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1							
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micPass,"Step VERIFYCHECKBOXEXIST", strDesc							 
									Reporter.Filter = rfDisableAll
								Else
									strDesc =strpartdesc&" at the row number "& chr(34) & iRowCnt+1&chr(34) & " the CheckBox Box is present but it is not required"
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micFail,"Step VERIFYCHECKBOXEXIST", strDesc
									objEnvironmentVariables.TestCaseStatus=False
									Reporter.Filter = rfDisableAll
								End If
							Else
								If UCase(strExpectedValue)="FALSE" then	
									strDesc = "VERIFYCHECKBOXEXIST: The Checkbox "& chr(34) &strLabel & chr(34) & " does not exist as expected."
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micPass,"Step VERIFYCHECKBOXEXIST", strDesc
									Reporter.Filter = rfDisableAll
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
									strDesc = strpartdesc&" at the row number " & chr(34) & iRowCnt+1& chr(34) & " the CheckBox Box "&strLabel&" does not exists."														
								Else
									strDesc = strpartdesc&" at the row number " & chr(34) & iRowCnt+1& chr(34) & " the CheckBox  "& chr(34) & strLabel & chr(34) & " does not exist but it is required."
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micFail,"Step VERIFYCHECKBOXEXIST", strDesc
									objEnvironmentVariables.TestCaseStatus=False 
									Reporter.Filter = rfDisableAll
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
								End If
							End If  



						'Navigates to the previous page
						'Ram - 23-3-10 - Added code to make the pressing of BACK button irrespective of the object
						Case "BROWSERBACK"

					
							If  objsub.Exist(5) Then
								objsub.Back
							Else
								Browser("name:=.*").Back        
							End If
							strDesc = "BROWSERBACK action performed"
							clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2 								
							Reporter.Filter = rfEnableAll 
							Reporter.ReportEvent micdone,"Step BROWSERBACK", strDesc								 
							Reporter.Filter = rfDisableAll  
		      

						Case "FIREFOXBROWSERBACK"

							If Environment.Value ("BrowserName") = "Firefox" Then

								If  objsub.Exist(5) Then
									objsub.Back
								Else
									Browser("name:=.*").Back        
								End If
								strDesc = "FIREFOXBROWSERBACK action performed on FireFox"
								clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2 								
								Reporter.Filter = rfEnableAll 
								Reporter.ReportEvent micdone,"Step FIREFOXBROWSERBACK", strDesc								 
								Reporter.Filter = rfDisableAll    
						End If         


						'Added Ram 24-3-10 to delete cookies
						Case "DELETECOOKIES"
							WebUtil.deletecookies
							strDesc = "DELETECOOKIES action performed"
							clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2 								
							Reporter.Filter = rfEnableAll 
							Reporter.ReportEvent micdone,"Step DELETECOOKIES", strDesc								 
							Reporter.Filter = rfDisableAll      

							If Environment.Value ("BrowserName") = "Firefox"  Then

								objsub.Highlight
								set WshShell = CreateObject("WScript.Shell")
								Wait 1
								WshShell.SendKeys "^+{DEL}"
								Wait 2
								WshShell.SendKeys "{ENTER}"
								Set WshShell=Nothing
							End If

						Case "CLICKLINKANDVERIFY"

							'Ram  26-3-10 - ECOM ONLY - Added for clicking multiple links and verifying if they lead to the corresponding page or not. Can be used to verify either the breadcrumb or atleast one product
							clsModuleScript.FnClickLinkAndVerify objsub , Object_Name, strInputValue, strDbValue, strOptParam, clsReport, objEnvironmentVariables ,clsScreenShot ,iRowCnt ,Screen_shot_path ,strSheet_Name ,strLabel , strExpectedValue , strTestDataReference, ModuleName 

						Case "CERTIFICATEERROR"
							'Ram - 29-3-10 - To skip off Cerificate error in IE7

						Set FSO = CreateObject("Scripting.FileSystemObject") 
						IEVersion = FSO.GetFileVersion("C:\Program Files\Internet Explorer\iexplore.exe") 
						IEVersion=CInt(Left(IEVersion,1))
						If IEVersion=7 AND Environment.Value ("BrowserName") = "IE" Then
'							If Browser("name:=Certificate.*").Page("title:=Certificate.*").Exist(2) Then
'								Do
'									Browser("name:=Certificate.*").Page("title:=Certificate.*").Link("name:= Continue.*").Click
'								Loop Until Browser("name:=Certificate.*").Page("title:=Certificate.*").Exist(1)=False
'							End If
							If Browser("name:=Certificate.*").Exist(2) Then
								Do
									Browser("name:=Certificate.*").Page("title:=Certificate.*").Link("name:= Continue.*").Click
								Loop Until Browser("name:=Certificate.*").Exist(2)=False
							End If
						End If
						Set FSO=Nothing


						 Case "VERIFYPRODUCTFLAGS" ' Only for ECOM
							 'Ram - 30-3-10 - To verify the flags under the prod page
							 clsModuleScript.FnValidateProductFlags objsub , Object_Name, strInputValue, strDbValue, strOptParam, clsReport, objEnvironmentVariables ,clsScreenShot ,iRowCnt ,Screen_shot_path ,strSheet_Name ,strLabel , strExpectedValue , strTestDataReference 
							 strInputValue=""
							 strDbValue=""

                        Case "REMOVEITEMSFROMBAG" 'Only for ECom
								'Fayis 30-3-10 ' To remove items from bag if any are present after logging in
								clsModuleScript. FnRemoveitemFromBag objsub , Object_Name, strInputValue, strDbValue, strOptParam, clsReport, objEnvironmentVariables ,clsScreenShot ,iRowCnt ,Screen_shot_path ,strSheet_Name ,strLabel , strExpectedValue , strTestDataReference 

						Case "VALIDATEPRODUCTDETAILS" ' Only for ECOM
							'Ram - 31-3-10 - This function is used to validate the certain product details in the product details and add to bag page based on the key words passed
								clsModuleScript.FnValidateProductDetails objsub , Object_Name, strInputValue, strDbValue, strOptParam, clsReport, objEnvironmentVariables ,clsScreenShot ,iRowCnt ,Screen_shot_path ,strSheet_Name ,strLabel , strExpectedValue , strTestDataReference, ModuleName

						Case "ADDSHOPBYSIZE"
									clsModuleScript.FnAddShopBySize objsub , Object_Name, strInputValue, strDbValue, strOptParam, clsReport, objEnvironmentVariables ,clsScreenShot ,iRowCnt ,Screen_shot_path ,strSheet_Name ,strLabel , strExpectedValue , strTestDataReference, ModuleName



						'Added fayis 27-2-10 to select drop down item
	                  Case "SELECTDROPDOWN"
                          	Dim strNewColorSelected
							strNewColorSelected=""
							ItemVerify=False

							'Check if value is comming in as an env value
							
							arrInpValue=Split(strInputValue,":")
							'Is an array ???
							If UBOUND(arrInpValue)>0 Then

								If  TRIM(UCASE(arrInpValue(0)))="ENV"Then
									strInputValue=Environment.Value(Trim( arrInpValue(1)))

								End If
							Else
								'Not an array so input is direct from excel
								strInputValue=strInputValue
							End If
										
							set obj = objsub.WebList(Object_Name)
							If obj.Exist(5) Then
									objVerify = true

									strAllItems=obj.getRoproperty("all items")
									strItemsCount=CINT(obj.getRoproperty("items count")) '' Moved from inside code to here

									If  UCASE(TRIM(strOptParam))="LAST_VALUE" Then
										''strItemsCount=CINT(obj.getRoproperty("items count"))  '' Teekam 6_April
										strInputValue=obj.getItem (strItemsCount)
										obj.Select (strInputValue)									
										ItemVerify = true
										'Can be used later
										Environment.Value("DRP_LAST_VALUE")=strInputValue
									'Ram - 5-4-10 - Added to select a new color from the product
									ElseIf UCASE(TRIM(strOptParam))="RANDOM_VALUE" Then
											strCurrentValue=obj.getRoproperty("value")
											For i=1 to strItemsCount
												strValToSel=RandomNumber(1,strItemsCount)
												strListValue=obj.getItem (strValToSel)
												If  strListValue<>strCurrentValue Then
													obj.Select(strListValue)
													strInputValue=strListValue
													If TRIM(strTestDataReference)<>"" Then
														arrTDR=Split(strTestDataReference,":")
														If  UCASE(TRIM(arrTDR(0)))="ENV" Then
															Environment.Value( Trim(  arrTDR(1) )  ) = strListValue
														End If														
													End If										
													ItemVerify=True
													Exit For
												End If					
											Next

											If NOT(ItemVerify) AND strItemsCount=1 Then
												ItemVerify=True
											End If

									ElseIf UCASE(TRIM(strOptParam))="DIFFERENT_COLOR" OR UCASE(TRIM(strOptParam))="DIFFERENT" OR UCASE(TRIM(strOptParam))="RANDOM" Then
										''strItemsCount=CINT(obj.getRoproperty("items count"))   ''Teekma 6_april
										strCurrentValue=obj.getRoproperty("value")
											For i=1 to strItemsCount
											strListValue=obj.getItem (i)
											If  strListValue<>strCurrentValue Then
												obj.Select(strListValue)
												strInputValue=strListValue

												'Put the selected value in an env value for further use

												If TRIM(strTestDataReference)<>"" Then
													arrTDR=Split(strTestDataReference,":")
                                                    Environment.Value( Trim(  arrTDR(1) )  ) = strListValue
												End If



												If UCASE(TRIM(strOptParam))="DIFFERENT_COLOR" Then
													strNewColorSelected="Yes"
												End If												
												ItemVerify=True
												Exit For
											End If					
										Next

											If NOT(ItemVerify) AND strItemsCount=1 Then
												ItemVerify=True
												strNewColorSelected="Yes"
											End If

										If strNewColorSelected<>"Yes" AND UCASE(TRIM(strOptParam))="DIFFERENT_COLOR" Then
											strDesc="SELECTDROPDOWN: Different colors for this product doesn't exist. So cannot select a different color. Cannot execute further."
											clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micFail,"Step SECTDROPDOWN", strDesc
											objEnvironmentVariables.TestCaseStatus=False
											Reporter.Filter = rfDisableAll  
										End If
									''Fayis (5-4-10) added an optional parameter to handle reg express dropdown box value
									'It will select an item which is having the value inside
									ElseIf UCASE(TRIM(strOptParam)) = "DRP_CONTAINS" Then
											''strItemsCount=CINT(obj.getRoproperty("items count"))  ''Teekam 6_april
                                            For i=1 To strItemsCount
												 fValue = obj.GetItem (i)

												 If INSTR( fValue , strInputValue )>0 then

													 obj.Select (fValue)
													 strInputValue=fValue
													 ItemVerify=True
													 Exit for
												 End if
											 Next
									Else
											If INSTR(strAllItems,strInputValue)>0Then
												''obj.Select TRIM(cstr(strInputValue))   ''Teekam 6_april , falied at selection of Express Delivery ( 3-4   Days) -$8.00
												''ItemVerify = true  '' by Teeka 6_April
												For i=1 To strItemsCount
													 fValue = obj.GetItem (i)
													 If INSTR( fValue , strInputValue )>0 then
														 obj.Select (fValue)
														 strInputValue=fValue
														 ItemVerify=True
														 Exit for
													 End if
												 Next
											Else
												ItemVerify = false
											End If
									End If								 
							Else
                                objVerify = false
							End If

							If objVerify AND ItemVerify Then								
								strDesc="SELECTDROPDOWN: The drop down " & chr(34) & strLabel & chr(34) &  " with value " & chr(34) & strInputValue & chr(34) & " has been selected."
								Reporter.Filter = rfEnableAll
								Reporter.ReportEvent micDone,"Step SECTDROPDOWN",strDesc
								Reporter.Filter = rfDisableAll
								clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2																				
							Elseif  objVerify AND (NOT ItemVerify) Then
								strDesc="SELECTDROPDOWN: The value from drop down " & chr(34) & strLabel & chr(34) &  " is not selected as the value " & chr(34) & strInputValue & chr(34) & "doesn't exist in the dropdown."
								clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
								clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
								Reporter.Filter = rfEnableAll 
								Reporter.ReportEvent micFail,"Step SECTDROPDOWN", strDesc
								objEnvironmentVariables.TestCaseStatus=False
								Reporter.Filter = rfDisableAll  
							Else
								strDesc="SELECTDROPDOWN: The value from the drop down " & chr(34) & strLabel & chr(34) & " has not been selected as the drop drown box does not exist."
								clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
								clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
								Reporter.Filter = rfEnableAll 
								Reporter.ReportEvent micFail,"Step SECTDROPDOWN", strDesc
								objEnvironmentVariables.TestCaseStatus=False
								Reporter.Filter = rfDisableAll  
							End If

					'=================================================
' 					Function to CLICK on a Child Item in a given CELL of a table || Naveen 5/10/2010

				  Case "CHILDITEMCLICK"

					  set obj = objsub.WebTable(Object_Name)
					  set tblobj = objsub.WebTable(Object_Name)
					  isEnv=False
					  If TRIM(strInputValue) <>"" Then

							 strArrInputValue=Split(strInputValue,":")
							intRowNumber = strArrInputValue(0)
							 intColNumber = strArrInputValue(1)
							 strObjectType = strArrInputValue(2)
							 intObjectIndex  = strArrInputValue(3)                    
                                                 
							 Set obj = obj.ChildItem(intRowNumber,intColNumber,strObjectType,intObjectIndex)


							 'Ram 5-26-2010 - Get the value that was clicked on to an env variable
							 If  strOptParam<>"" Then
								 arrOptParam=Split(strOptParam,":")
								 If  UCASE(TRIM(arrOptParam(0)))="ENV" Then
									 isEnv=True
		
								 End If
							 End If
							 '
							  If obj.Exist(3) Then                                                                      
									obj.Highlight
									obj.Click
									If isEnv Then
	
										strCellValue=tblobj.GetCellData(intRowNumber,intColNumber)
										strCellValue=TRIM(strCellValue)

										Environment.Value(Trim( arrOptParam(1)))=strCellValue
									End If
									strDesc = "CHILDITEMCLICK:  " & Chr(34) & strLabel & Chr(34) & " object clicked as expected."
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micPass,"Step CHILDITEMCLICK ", strDesc                                                                                                           
									Reporter.Filter = rfDisableAll                                                                                                                   
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
							  Else
									  strDesc = "CHILDITEMCLICK:  " & Chr(34) & strLabel & Chr(34) & " object not clicked as expected."
									  clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0                                                                                                                             
									  Reporter.Filter = rfEnableAll 
									  Reporter.ReportEvent micFail,"Step CHILDITEMCLICK ", strDesc
									  objEnvironmentVariables.TestCaseStatus=False                        
									  Reporter.Filter = rfDisableAll
									  clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
							  End If                                        
					  End If

					
					Case "VERIFYTABLEVALUE" 
						'Added by Ram 13-4-10 to ve


					Dim strRow,strCol,strRowCnt,strColCnt,strActualCellValue,strExpCellValue
					If  Environment.Value("CurrentBrowser")<>"" Then
							If UCASE(Environment.Value("CurrentBrowser"))=UCASE(Environment.Value ("BrowserName")) Then
							set obj = objsub.WebTable(Object_Name)

						'Check if the user wants the value to be true or false
						blnExpectdVal=False
						If UCase(Trim(strExpectedValue))="TRUE" OR UCase(Trim(strExpectedValue))="" then
							blnExpectdVal=True								
						Else
							blnExpectdVal=False
						End If

						'Check for object existance
						If obj.Exist(5) Then
							obj.Highlight

								
								'Get the I/P value..i.e value thats needs to be checked
								'**************************************************************
									arrInpVal=Split(strInputValue,":")
		
									If  UBOUND(arrInpVal)>0Then
										'Using the I/P from some other ENV value
										If  UCASE(arrInpVal(0))="ENV" Then
											strExpCellValue=Environment.Value( Trim(arrInpVal(1) ))
											If  UBOUND(arrInpVal)>1 Then
												'Set the index of that table if required
												If  UCASE(arrInpVal(2))="INDEX" Then
													obj.SetTOProperty "index", TRIM(arrInpVal(3))
												End If
											End If
											'Incase the user has not used env value, but used the value directly with index
										ElseIf UCASE(arrInpVal(0))<>"ENV" Then
	
											If  UCASE(arrInpVal(1))="INDEX" Then
												obj.SetTOProperty "index", TRIM(arrInpVal(2))
											ElseIf UBOUND(arrInpVal)>1Then
												If  UCASE(TRIM(arrInpVal(2)))="INDEX" Then												
                                                      obj.SetTOProperty "index", TRIM(arrInpVal(3))
												End If
											Else

												'Just a value with colon
												strExpCellValue=TRIM(strInputValue)
											End If
										End If
									Else
										strExpCellValue=TRIM(strInputValue)
									End If
		
		
									'Now check for the value in the table based on the Row/Col value given in the optparam
									'******************************************************************************************************
									If TRIM(strOptParam)<>"" Then
										'Eg: 1:1: - ROW:COL(row # 1: col # 1)
										arrOptParam=Split(strOptParam,":")
										strRow=TRIM(arrOptParam(0))
										strCol=TRIM(arrOptParam(1))
										blnIsError=False
										'Get the actual value from the specfied cell
										strActualCellValue=obj.GetCellData(strRow,strCol)
										If INSTR(UCASE(strActualCellValue),"ERROR")>0 Then
											blnIsError=True
											strErrorValue=strActualCellValue
										End If
		
										blnValueExist=False
										'Check for the value

										If INSTR(strActualCellValue,strExpCellValue)>0 Then
											blnValueExist=True

										Else
											blnValueExist=False

										End If
									Else
										'Get the row and col count
										strRowCnt=obj.GetROProperty("rows")
										strColCnt=obj.GetROProperty("cols")
										For strRow=1 to strRowCnt
											For strCol=1 to strColCnt
												strActualCellValue=obj.GetCellData(strRow,strCol)

												blnValueExist=False
												'Check for the value
												If INSTR(strActualCellValue,strExpCellValue)>0 Then
													blnValueExist=True
													Exit For
												End If
											Next
										Next
										If  blnValueExist=False Then
											strRow="#"
											strCol="#"
										End If
									End If

									''print the result
									'****************
									If blnValueExist Then

										If blnExpectdVal then  'True Case 
											strDesc ="VERIFYTABLEVALUE  : The webtable " & chr(34) & Object_Name & chr(34) & " contains the value " & chr(34) & strExpCellValue & chr(34) & " in row # " & chr(34) & strRow & chr(34) & " / col # " & chr(34) & strCol & chr(34) & "."
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micPass,"Step VERIFYTABLEVALUE", strDesc
											Reporter.Filter = rfDisableAll
										Else
											strDesc ="VERIFYTABLEVALUE  : In the Test Script, at the row number " & chr(34) & iRowCnt+1 & chr(34) & ",the webtable " & chr(34) & Object_Name & chr(34) & " contains the value " & chr(34) & strExpCellValue & chr(34) & " in row # " & chr(34) & strRow & chr(34) & " / col # " & chr(34) & strCol & chr(34) & ", which is not expected."
											
											clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micFail,"Step VERIFYTABLEVALUE", strDesc
											objEnvironmentVariables.TestCaseStatus=False
											Reporter.Filter = rfDisableAll
										End If
									Else

										If blnExpectdVal then	''true
											If blnIsError Then
												strDesc ="<b><i>VERIFYTABLEVALUE  : ERROR - In the Test Script, at the row number " & chr(34) & iRowCnt+1 & chr(34) & ",the webtable " & chr(34) & Object_Name & chr(34) & " doesn't contain the row # " & chr(34) & strRow & chr(34) & " / col # " & chr(34) & strCol & chr(34) & ".</b></i>"
											Else	
												strDesc ="VERIFYTABLEVALUE  : In the Test Script, at the row number " & chr(34) & iRowCnt+1 & chr(34) & ",the webtable " & chr(34) & Object_Name & chr(34) & " doesn't contains the value " & chr(34) & strExpCellValue & chr(34) & " in row # " & chr(34) & strRow & chr(34) & " / col # " & chr(34) & strCol & chr(34) & "."
											End If
											
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micFail,"Step VERIFYTABLEVALUE", strDesc
											objEnvironmentVariables.TestCaseStatus=False
											Reporter.Filter = rfDisableAll
											clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0										
										Else
										If blnIsError Then
												strDesc ="<b><i>VERIFYTABLEVALUE  : ERROR - In the Test Script, at the row number " & chr(34) & iRowCnt+1 & chr(34) & ",the webtable " & chr(34) & Object_Name & chr(34) & " doesn't contain the row # " & chr(34) & strRow & chr(34) & " / col # " & chr(34) & strCol & chr(34) & ".</b></i>" 
										 Else
											strDesc ="VERIFYTABLEVALUE  : The webtable " & chr(34) & Object_Name & chr(34) & " doesn't contains the value " & chr(34) & strExpCellValue & chr(34) & " in row # " & chr(34) & strRow & chr(34) & " / col # " & chr(34) & strCol & chr(34) & ",  as expected."
										End If
											
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micPass,"VERIFYTABLEVALUE", strDesc
											Reporter.Filter = rfDisableAll
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1									
										End If						 
									End If

							Else
									strDesc="VERIFYTABLEVALUE: The web table " & chr(34) & Object_Name & chr(34) & " does not exist."
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micFail,"Step VERIFYTABLEVALUE", strDesc
									objEnvironmentVariables.TestCaseStatus=False
									Reporter.Filter = rfDisableAll  
							End If
						End If
					Else
						set obj = objsub.WebTable(Object_Name)

						'Check if the user wants the value to be true or false
						blnExpectdVal=False
						If UCase(Trim(strExpectedValue))="TRUE" OR UCase(Trim(strExpectedValue))="" then
							blnExpectdVal=True								
						Else
							blnExpectdVal=False
						End If

						'Check for object existance
						If obj.Exist(5) Then
							obj.Highlight

								
								'Get the I/P value..i.e value thats needs to be checked
								'**************************************************************
									arrInpVal=Split(strInputValue,":")
		
									If  UBOUND(arrInpVal)>0Then
										'Using the I/P from some other ENV value
										If  UCASE(arrInpVal(0))="ENV" Then
											strExpCellValue=Environment.Value( Trim(arrInpVal(1) ))
											If  UBOUND(arrInpVal)>1 Then
												'Set the index of that table if required
												If  UCASE(arrInpVal(2))="INDEX" Then
													obj.SetTOProperty "index", TRIM(arrInpVal(3))
												End If
											End If
											'Incase the user has not used env value, but used the value directly with index
										ElseIf UCASE(arrInpVal(0))<>"ENV" Then
						
											If  UCASE(arrInpVal(1))="INDEX" Then
												obj.SetTOProperty "index", TRIM(arrInpVal(2))
											ElseIf UBOUND(arrInpVal)>1Then
												If  UCASE(TRIM(arrInpVal(2)))="INDEX" Then												
                                                      obj.SetTOProperty "index", TRIM(arrInpVal(3))
												End If
											Else

												'Just a value with colon
												strExpCellValue=TRIM(strInputValue)
											End If
										End If
									Else
										strExpCellValue=TRIM(strInputValue)
									End If
		
		
									'Now check for the value in the table based on the Row/Col value given in the optparam
									'******************************************************************************************************
									If TRIM(strOptParam)<>"" Then
										'Eg: 1:1: - ROW:COL(row # 1: col # 1)
										arrOptParam=Split(strOptParam,":")
										strRow=TRIM(arrOptParam(0))
										strCol=TRIM(arrOptParam(1))
		
										blnIsError=False
										'Get the actual value from the specfied cell
										strActualCellValue=obj.GetCellData(strRow,strCol)
										If INSTR(UCASE(strActualCellValue),"ERROR")>0 Then
											blnIsError=True
											strErrorValue=strActualCellValue
										End If
		
										blnValueExist=False
										'Check for the value

										If INSTR(strActualCellValue,strExpCellValue)>0 Then
											blnValueExist=True

										Else
											blnValueExist=False

										End If
									Else
										'Get the row and col count
										strRowCnt=obj.GetROProperty("rows")
										strColCnt=obj.GetROProperty("cols")
										For strRow=1 to strRowCnt
											For strCol=1 to strColCnt
												strActualCellValue=obj.GetCellData(strRow,strCol)

												blnValueExist=False
												'Check for the value
												If INSTR(strActualCellValue,strExpCellValue)>0 Then
													blnValueExist=True
													Exit For
												End If
											Next
										Next
										If  blnValueExist=False Then
											strRow="#"
											strCol="#"
										End If
									End If

									''print the result
									'****************
									If blnValueExist Then

										If blnExpectdVal then  'True Case 
											strDesc ="VERIFYTABLEVALUE  : The webtable " & chr(34) & Object_Name & chr(34) & " contains the value " & chr(34) & strExpCellValue & chr(34) & " in row # " & chr(34) & strRow & chr(34) & " / col # " & chr(34) & strCol & chr(34) & "."
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micPass,"Step VERIFYTABLEVALUE", strDesc
											Reporter.Filter = rfDisableAll
										Else
											strDesc ="VERIFYTABLEVALUE  : The webtable " & chr(34) & Object_Name & chr(34) & " contains the value " & chr(34) & strExpCellValue & chr(34) & " in row # " & chr(34) & strRow & chr(34) & " / col # " & chr(34) & strCol & chr(34) & ", which is not expected."
											clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micFail,"Step VERIFYTABLEVALUE", strDesc
											objEnvironmentVariables.TestCaseStatus=False
											Reporter.Filter = rfDisableAll
										End If
									Else

										If blnExpectdVal then	''true
											If blnIsError Then
												strDesc ="<b><i>VERIFYTABLEVALUE  : ERROR - The webtable " & chr(34) & Object_Name & chr(34) & " doesn't contain the row # " & chr(34) & strRow & chr(34) & " / col # " & chr(34) & strCol & chr(34) & ".</b></i>"
											Else	
												strDesc ="VERIFYTABLEVALUE  : The webtable " & chr(34) & Object_Name & chr(34) & " doesn't contains the value " & chr(34) & strExpCellValue & chr(34) & " in row # " & chr(34) & strRow & chr(34) & " / col # " & chr(34) & strCol & chr(34) & "."
											End If
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micFail,"Step VERIFYTABLEVALUE", strDesc
											objEnvironmentVariables.TestCaseStatus=False
											Reporter.Filter = rfDisableAll
											clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0										
										Else
										If blnIsError Then
												strDesc ="<b><i>VERIFYTABLEVALUE  : ERROR - The webtable " & chr(34) & Object_Name & chr(34) & " doesn't contain the row # " & chr(34) & strRow & chr(34) & " / col # " & chr(34) & strCol & chr(34) & ".</b></i>" 
										 Else
											strDesc ="VERIFYTABLEVALUE  : The webtable " & chr(34) & Object_Name & chr(34) & " doesn't contains the value " & chr(34) & strExpCellValue & chr(34) & " in row # " & chr(34) & strRow & chr(34) & " / col # " & chr(34) & strCol & chr(34) & ",  as expected."
										End If
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micPass,"VERIFYTABLEVALUE", strDesc
											Reporter.Filter = rfDisableAll
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1									
										End If						 
									End If

							Else
									strDesc="VERIFYTABLEVALUE: The web table " & chr(34) & Object_Name & chr(34) & " does not exist."
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micFail,"Step VERIFYTABLEVALUE", strDesc
									objEnvironmentVariables.TestCaseStatus=False
									Reporter.Filter = rfDisableAll  
							End If
							
					End If
							
							strRow=""
							strCol=""
							strRowCnt=""
							strColCnt=""
							strActualCellValue=""
							strExpCellValue=""

					Case "VERIFYOBJECTCOLOR"

				'Ram 24- 4-10- Verify the object color

								If Environment.Value ("BrowserName") <> "Firefox"  Then

									strObjType=Trim(strOptParam)
		
									'1. Set the corresp obj
									Select Case strObjType
										Case "WebElement"
											Set obj = objsub.WebElement(Object_Name)
										Case "WebEdit"
											Set obj = objsub.WebEdit(Object_Name)
										 Case "WebList"
											Set obj = objsub.WebList(Object_Name)
										 Case "Link"
											 Set obj = objsub.Link(Object_Name)
									End Select
									
		
									'2.Set the corresponding property and the expected value for the property i.e needed color
									'e.g: bordercololr~RED
									arrInpValue=Split(strInputValue,"~") 
									strProperty=TRIM(arrInpValue(0))
									strColor=TRIM(arrInpValue(1))
		
									'Assign the property accordingly
									Select Case UCASE(strProperty)
										Case "COLOR"
													strCurrentColor=obj.Object.currentStyle.Color
										Case "BORDERCOLOR"
													strCurrentColor=obj.Object.currentStyle.borderColor
										 Case "BACKGROUNDCOLOR"
													strCurrentColor=obj.Object.currentStyle.backgroundColor
									End Select
		
		
									'3. Check if the expected is true/false
									If UCase(Trim(strExpectedValue))="TRUE" OR UCase(Trim(strExpectedValue))="" then
										blnExpectdVal=True								
									Else
										blnExpectdVal=False
									End If
		
									'4. Get the value that needs to be checked against..i.e expected color
									Select Case UCASE(TRIM(strColor))
										Case "RED"
											strColorSet="#b50831~#b50937~#ba0f0f"
									End Select
		
									'5.Report
									If  obj.Exist(5) Then
										obj.Highlight
										'Check if the color passed and the current color  are the same
										arrColorSet=Split(strColorSet,"~")
										blnColorFound=False
										For i=0 to UBOUND(arrColorSet)
											strColorValue=arrColorSet(i)
											If  TRIM(strCurrentColor)=TRIM(strColorValue) Then
												blnColorFound=True
												Exit For
											End If
										Next
		
										If blnColorFound Then
											If blnExpectdVal then  'True Case 
												strDesc ="VERIFYOBJECTCOLOR : The " & strObjType & " - " & chr(34) & Object_Name & chr(34) & " has the color - " & chr(34) & UCASE(strColor) & chr(34) & " as the " & chr(34) & UCASE(strProperty) & chr(34) & "."
												clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
												Reporter.Filter = rfEnableAll 
												Reporter.ReportEvent micPass,"Step VERIFYOBJECTCOLOR", strDesc
												Reporter.Filter = rfDisableAll
											Else
												strDesc ="VERIFYOBJECTCOLOR : The " & strObjType & " - " & chr(34) & Object_Name & chr(34) & " has the color - " & chr(34) & UCASE(strColor) & chr(34) & " as the " & chr(34) & UCASE(strProperty) & chr(34) & ", which is not expected."
												clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
												clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
												Reporter.Filter = rfEnableAll 
												Reporter.ReportEvent micFail,"Step VERIFYOBJECTCOLOR", strDesc
												objEnvironmentVariables.TestCaseStatus=False
												Reporter.Filter = rfDisableAll
											End If
										Else
											If blnExpectdVal then	''true
												strDesc ="VERIFYOBJECTCOLOR : The " & strObjType & " - " & chr(34) & Object_Name & chr(34) & " doesn't get displayed with the color - " & chr(34) & UCASE(strColor) & chr(34) & " as the " & chr(34) & UCASE(strProperty) & chr(34) & ". Color displayed is - " & chr(34) & strCurrentColor & chr(34) & "." 
												Reporter.Filter = rfEnableAll 
												Reporter.ReportEvent micFail,"Step VERIFYOBJECTCOLOR", strDesc
												objEnvironmentVariables.TestCaseStatus=False
												Reporter.Filter = rfDisableAll
												clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
												clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0										
											Else
												strDesc ="VERIFYOBJECTCOLOR : The " & strObjType & " - " & chr(34) & Object_Name & chr(34) & " doesn't get displayed with the color - " & chr(34) & UCASE(strColor) & chr(34) & " as the " & chr(34) & UCASE(strProperty) & chr(34) & ", as expected."
												Reporter.Filter = rfEnableAll 
												Reporter.ReportEvent micPass,"Step VERIFYOBJECTCOLOR", strDesc
												Reporter.Filter = rfDisableAll
												clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1									
											End If						 
										End If
		
									Else
											strDesc="VERIFYOBJECTCOLOR: The " & strObjType & " - " & chr(34) & Object_Name & chr(34) & " doesn't exist, so cannot proceed with color verfication."
											clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micFail,"Step VERIFYOBJECTCOLOR", strDesc
											objEnvironmentVariables.TestCaseStatus=False
											Reporter.Filter = rfDisableAll 
									End If
								Else
									strDesc ="VERIFYOBJECTCOLOR : Verification for the " & strObjType & " - " & chr(34) & Object_Name & chr(34) & " cannot be done as the current browser " & chr(34) & UCASE(Environment.Value ("BrowserName")) & chr(34) & " will not support this."
									Reporter.Filter = rfEnableAll
									Reporter.ReportEvent micdone,"Step VERIFYOBJECTCOLOR ", strDesc
									Reporter.Filter = rfDisableAll 
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2
								End If


					
					Case "VERIFYDROPDOWN"

							'Added by Ram 1-4-10 - to verify the existence  of a drop down and the values within based on Key Words like LIST_EXIST , CURRENT_VALUE, VALUE_EXIST
							set obj = objsub.WebList(Object_Name)	

							If UCase(Trim(strExpectedValue))="TRUE" OR UCase(Trim(strExpectedValue))="" then
								blnExpectdVal=True								
							Else
								blnExpectdVal=False
							End If
							'Optional Value
							blnOptionalVal="No"
							If UCASE(TRIM(strTestDataReference))="OPTIONAL" Then
								blnOptionalVal="Yes"
							End If
												

							If obj.Exist(5) Then    
								obj.Highlight
								Select Case UCASE(TRIM(strOptParam))

									'Just verify if the list box physically exists or not
									'******************************************************
									Case "LIST_EXIST" ' 
										If blnExpectdVal Then
											strDesc="VERIFYDROPDOWN: The drop down " & chr(34) & strLabel & chr(34) & " exists."
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micPass,"Step VERIFYDROPDOWN", strDesc
											Reporter.Filter = rfDisableAll
										Else
											strDesc="VERIFYDROPDOWN: The drop down " & chr(34) & strLabel & chr(34) & " displayed on the screen, where it's not expected to."
											clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micFail,"Step VERIFYDROPDOWN", strDesc
											objEnvironmentVariables.TestCaseStatus=False
											Reporter.Filter = rfDisableAll  			
										End If

									Case "LIST_STATUS" 'Verufy if the listbox is disabled or enabled

											arrStatus = Split ( strInputValue , ":" , -1, 1) 
											strGetValue = obj.GetROProperty ( arrStatus(0) )						
											strSetValue = arrStatus(1) 
				
											If CStr(strGetValue) = CStr(strSetValue) Then
												blnVerifyRes = True
											Else
												blnVerifyRes = False 
											End If

											If blnVerifyRes Then
												If blnExpectdVal then  'True Case 
													strDesc ="VERIFYDROPDOWN - STATUS : The dropdown named " & chr(34) & strlabel & chr(34) & " gets reflected with property - " & chr(34) & arrStatus(0) & "-" & strSetValue  & chr(34) & "." 
													clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
													Reporter.Filter = rfEnableAll 
													Reporter.ReportEvent micPass,"Step VERIFYDROPDOWN - STATUS", strDesc
													Reporter.Filter = rfDisableAll
												Else
													strDesc ="VERIFYDROPDOWN - STATUS : The dropdown named " & chr(34) & strlabel & chr(34) & " gets reflected with property - " & chr(34) & arrStatus(0) & "-" & strSetValue  & chr(34) & ", which is not expected." 
													clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
													clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
													Reporter.Filter = rfEnableAll 
													Reporter.ReportEvent micFail,"Step VERIFYDROPDOWN - STATUS", strDesc
													objEnvironmentVariables.TestCaseStatus=False
													Reporter.Filter = rfDisableAll
												End If
											Else
												If blnExpectdVal then	''true
													strDesc ="VERIFYDROPDOWN - STATUS : The dropdown named " & chr(34) & strlabel & chr(34) & " doesn't get reflected with property - " & chr(34) & arrStatus(0) & "-" & strSetValue  & chr(34) & "." 
													Reporter.Filter = rfEnableAll 
													Reporter.ReportEvent micFail,"Step VERIFYDROPDOWN - STATUS", strDesc
													objEnvironmentVariables.TestCaseStatus=False
													Reporter.Filter = rfDisableAll
													clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
													clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0										
												Else
													strDesc ="VERIFYDROPDOWN - STATUS : The dropdown named " & chr(34) & strlabel & chr(34) & " doesn't get reflected with property - " & chr(34) & arrStatus(0) & "-" & strSetValue  & chr(34) & ", as expected" 
													Reporter.Filter = rfEnableAll 
													Reporter.ReportEvent micPass,"Step VERIFYDROPDOWN - STATUS", strDesc
													Reporter.Filter = rfDisableAll
													clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1									
												End If						 
											End If
									'
									'Get the value that's displayed currently
									'*********************************************
									Case "CURRENT_VALUE" 

									
										strCurrentValue=TRIM(obj.GetROProperty("value"))

										'Check for Env Var
										arrInpValue=Split(strInputValue,":")
										If UCASE(TRIM(arrInpValue(0)))="ENV" Then
											strExpectedValue=Environment.Value( Trim(arrInpValue(1) ))
										Else
											strExpectedValue=Trim(strInputValue) 
										End If									

										If strCurrentValue=TRIM(strExpectedValue) Then											
											If blnExpectdVal Then											
												strDesc="VERIFYDROPDOWN: The drop down " & chr(34) & strLabel & chr(34) & " is displayed with the current value set as " & chr(34) & strExpectedValue & chr(34) & "."
												clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
												Reporter.Filter = rfEnableAll 
												Reporter.ReportEvent micPass,"Step VERIFYDROPDOWN", strDesc
												Reporter.Filter = rfDisableAll
											Else
												strDesc="VERIFYDROPDOWN: The drop down " & chr(34) & strLabel & chr(34) & " is displayed with the current value set as " & chr(34) & strExpectedValue & chr(34) & ", where it's not expected to be so."
												clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
												clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
												Reporter.Filter = rfEnableAll 
												Reporter.ReportEvent micFail,"Step VERIFYDROPDOWN", strDesc
												objEnvironmentVariables.TestCaseStatus=False
												Reporter.Filter = rfDisableAll  			
											End If
										Else
											If blnExpectdVal Then
												strDesc="VERIFYDROPDOWN: The drop down " & chr(34) & strLabel & chr(34) & " is not displayed with the current value set as " & chr(34) & strExpectedValue & chr(34) & "."
												clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
												clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
												Reporter.Filter = rfEnableAll 
												Reporter.ReportEvent micFail,"Step VERIFYDROPDOWN", strDesc
												objEnvironmentVariables.TestCaseStatus=False
												Reporter.Filter = rfDisableAll 
											Else
												strDesc="VERIFYDROPDOWN: The drop down " & chr(34) & strLabel & chr(34) & " is not displayed with the current value set as " & chr(34) & strExpectedValue & chr(34) & ", as expected."
												clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
												Reporter.Filter = rfEnableAll 
												Reporter.ReportEvent micPass,"Step VERIFYDROPDOWN", strDesc
												Reporter.Filter = rfDisableAll		
											End If
										End If

                                        
							'			Added by Fayis on 04-05-10   'To check the selected value contains the expected value
										Case "CURRENT_VALUE_CONTAINS" 
											strCurrentValue=TRIM(obj.GetROProperty("value"))

											'Check for Env Var
											arrInpValue=Split( strInputValue , ":" )
											If UCASE(TRIM(arrInpValue(0)))="ENV" Then
												strExpectedValue=Environment.Value( Trim(arrInpValue(1) ))
											Else
												''Added Teekam 6 April 
												'---------------------------------- 																
												If INSTR( strCurrentValue  , strInputValue )>0 and Cint(Len( strCurrentValue )) >= Cint( Len ( strInputValue ) ) then  
													strExpectedValue = strCurrentValue								
												Else
													strExpectedValue=Trim(strInputValue)						
												End If 
												'------------------------------------
												''strExpectedValue=Trim(strInputValue)  ''by Teekam 6 April
											End If
	
											If  INSTR(strCurrentValue,TRIM(strExpectedValue)) >0 Then
												If blnExpectdVal Then
													strDesc="VERIFYDROPDOWN: The drop down " & chr(34) & strLabel & chr(34) & " is displayed with the current value set as " & chr(34) & strCurrentValue & chr(34) & "."
													clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
													Reporter.Filter = rfEnableAll 
													Reporter.ReportEvent micPass,"Step VERIFYDROPDOWN", strDesc
													Reporter.Filter = rfDisableAll
												Else
													strDesc="VERIFYDROPDOWN: The drop down " & chr(34) & strLabel & chr(34) & " is displayed with the current value set as " & chr(34) & strCurrentValue & chr(34) & ", where it's not expected to be so."
													clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
													clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
													Reporter.Filter = rfEnableAll 
													Reporter.ReportEvent micFail,"Step VERIFYDROPDOWN", strDesc
													objEnvironmentVariables.TestCaseStatus=False
													Reporter.Filter = rfDisableAll  			
												End If
											Else
												If blnExpectdVal Then
													strDesc="VERIFYDROPDOWN: The drop down " & chr(34) & strLabel & chr(34) & " is not displayed with the current value set as " & chr(34) & strExpectedValue & chr(34) & "."
													clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
													clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
													Reporter.Filter = rfEnableAll 
													Reporter.ReportEvent micFail,"Step VERIFYDROPDOWN", strDesc
													objEnvironmentVariables.TestCaseStatus=False
													Reporter.Filter = rfDisableAll 
												Else
													strDesc="VERIFYDROPDOWN: The drop down " & chr(34) & strLabel & chr(34) & " is not displayed with the current value set as " & chr(34) & strExpectedValue & chr(34) & ", as expected."
													clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
													Reporter.Filter = rfEnableAll 
													Reporter.ReportEvent micPass,"Step VERIFYDROPDOWN", strDesc
													Reporter.Filter = rfDisableAll		
												End If
											End If

									'a.)Check if a single value exists or not 
									'b).Check if a list of values exists or not
									Case "VALUE_EXIST"

										If strDbValue<>"" Then
											vInputValue=strDbValue
										ElseIf strInputValue<>"" Then
											vInputValue=strInputValue
										End If

										'Get All Items
										strAllItems=Obj.GetRoProperty("all items")

										'Check if single value or multiple values
										arrInpValue=Split(vInputValue,":")
                                        If UBOUND(arrInpValue)>0 Then

											'Multiple Values(Except for Env)
											'*************************************
											If UCASE(TRIM(arrInpValue(0)))="ENV" Then
												strExpectedValue=Environment.Value( Trim(arrInpValue(1) ))									

												If INSTR(strAllItems,strExpectedValue)>0 Then
													If blnExpectdVal Then
														strDesc="VERIFYDROPDOWN: The drop down " & chr(34) & strLabel & chr(34) & " contains the value " & chr(34) & strExpectedValue & chr(34) & "."
														clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
														Reporter.Filter = rfEnableAll 
														Reporter.ReportEvent micPass,"Step VERIFYDROPDOWN", strDesc
														Reporter.Filter = rfDisableAll
													Else
														strDesc="VERIFYDROPDOWN: The drop down " & chr(34) & strLabel & chr(34) & " contains the value " & chr(34) & strExpectedValue & chr(34) & ", which is not expected."
														clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
														clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
														Reporter.Filter = rfEnableAll 
														Reporter.ReportEvent micFail,"Step VERIFYDROPDOWN", strDesc
														objEnvironmentVariables.TestCaseStatus=False
														Reporter.Filter = rfDisableAll  			
													End If
												Else
													If blnExpectdVal Then
														strDesc="VERIFYDROPDOWN: The drop down " & chr(34) & strLabel & chr(34) & " doesn't contain the value " & chr(34) & strExpectedValue & chr(34) & ", which is not expected."
														clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
														clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
														Reporter.Filter = rfEnableAll 
														Reporter.ReportEvent micFail,"Step VERIFYDROPDOWN", strDesc
														objEnvironmentVariables.TestCaseStatus=False
														Reporter.Filter = rfDisableAll 
													Else
														strDesc="VERIFYDROPDOWN: The drop down " & chr(34) & strLabel & chr(34) & " doesn't contain the value " & chr(34) & strExpectedValue & chr(34) & ", which is expected."
														clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
														Reporter.Filter = rfEnableAll 
														Reporter.ReportEvent micPass,"Step VERIFYDROPDOWN", strDesc
														Reporter.Filter = rfDisableAll		
													End If
												End If

											Else
												'Multiple Looping
												'********************

												arrActualValues=arrInpValue
												blnAtleastOneVal=False
												For arrCount=0 to UBOUND(arrActualValues)
													strExpectedValue=arrActualValues(arrCount)
													If INSTR(strAllItems,strExpectedValue)>0 Then
		
														strDesc="VERIFYDROPDOWN: The drop down " & chr(34) & strLabel & chr(34) & " contains the value " & chr(34) & strExpectedValue & chr(34) & "."
														clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
														Reporter.Filter = rfEnableAll 
														Reporter.ReportEvent micPass,"Step VERIFYDROPDOWN", strDesc
														Reporter.Filter = rfDisableAll
														blnAtleastOneVal=True
													Else
														'Some times user might want to pass "OPTIONAL" in Test Data, when he's not sure if that value would come again or not
														If blnOptionalVal<>"Yes" Then
															strDesc="VERIFYDROPDOWN: The drop down " & chr(34) & strLabel & chr(34) & " doesn't contain the value " & chr(34) & strExpectedValue & chr(34) & ", which is not expected."
															clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
															clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
															Reporter.Filter = rfEnableAll 
															Reporter.ReportEvent micFail,"Step VERIFYDROPDOWN", strDesc
															objEnvironmentVariables.TestCaseStatus=False
															Reporter.Filter = rfDisableAll 
														End If
													End If
												Next
												'Ram 3-Aug-10 added to check if atleast one value is there in the list
												If NOT(blnAtleastOneVal) AND blnOptionalVal="Yes" Then
													If strAllItems="" or strAllItems=" " or strAllItems=NULL Then
														strAllItems="BLANK"
													End If
													strDesc="VERIFYDROPDOWN: The drop down " & chr(34) & strLabel & chr(34) & " doesn't even contain one value from the list of values specified. The value(s) available are "  & chr(34) & strAllItems & chr(34) & "."
													clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
													clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
													Reporter.Filter = rfEnableAll 
													Reporter.ReportEvent micFail,"Step VERIFYDROPDOWN", strDesc
													objEnvironmentVariables.TestCaseStatus=False
													Reporter.Filter = rfDisableAll 
												End If
											End If
											strAllItems=""
										Else
											'Single Value
											'***************
											strExpectedValue=vInputValue
			
											If INSTR(strAllItems,strExpectedValue)>0 Then
													If blnExpectdVal Then

														strDesc="VERIFYDROPDOWN: The drop down " & chr(34) & strLabel & chr(34) & " contains the value " & chr(34) & strExpectedValue & chr(34) & "."
														clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
														Reporter.Filter = rfEnableAll 
														Reporter.ReportEvent micPass,"Step VERIFYDROPDOWN", strDesc
														Reporter.Filter = rfDisableAll
													Else
														strDesc="VERIFYDROPDOWN: The drop down " & chr(34) & strLabel & chr(34) & " contains the value " & chr(34) & strExpectedValue & chr(34) & ", which is not expected."
														clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
														clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
														Reporter.Filter = rfEnableAll 
														Reporter.ReportEvent micFail,"Step VERIFYDROPDOWN", strDesc
														objEnvironmentVariables.TestCaseStatus=False
														Reporter.Filter = rfDisableAll  			
													End If
												Else
													If blnExpectdVal Then
														strDesc="VERIFYDROPDOWN: The drop down " & chr(34) & strLabel & chr(34) & " doesn't contain the value " & chr(34) & strExpectedValue & chr(34) & ", which is not expected."
														clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
														clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
														Reporter.Filter = rfEnableAll 
														Reporter.ReportEvent micFail,"Step VERIFYDROPDOWN", strDesc
														objEnvironmentVariables.TestCaseStatus=False
														Reporter.Filter = rfDisableAll 
													Else
					
														strDesc="VERIFYDROPDOWN: The drop down " & chr(34) & strLabel & chr(34) & " doesn't contain the value " & chr(34) & strExpectedValue & chr(34) & ", which is expected."
														clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
														Reporter.Filter = rfEnableAll 
														Reporter.ReportEvent micPass,"Step VERIFYDROPDOWN", strDesc
														Reporter.Filter = rfDisableAll		
													End If
												End If
										End If

									Case "ONLY_SPCF_VALUE_EXIST"	
		
										If strDbValue<>"" Then
											vInputValue=strDbValue
										ElseIf strInputValue<>"" Then
											vInputValue=strInputValue
										End If

										arrInpValue=Split(vInputValue,":")
										arrActualValues=arrInpValue

										'Get All Items
										strAllItems=Obj.GetRoProperty("all items")

										'Get the items count also
										strItemsCount=Obj.GetRoProperty("items count")
										strUBOUND=UBOUND(arrActualValues)
										strExpectedItemsCount=strUBOUND+1

										'1. Check if the items count match the # values specified as input. Only then proceed further for the checking of those values
										If  strItemsCount=strExpectedItemsCount Then
											strDesc="VERIFYDROPDOWN: The drop down " & chr(34) & strLabel & chr(34) & " contains " & chr(34) & strItemsCount & chr(34) & "values which is same as the expected value of " & chr(34) & (UBOUND(arrActualValues)+1) & chr(34) & ". They actual values displayed are : " & chr(34) & strAllItems & chr(34) &  "."
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micPass,"Step VERIFYDROPDOWN", strDesc
											Reporter.Filter = rfDisableAll

												'2. Check if the specified values are displayed
											For arrCount=0 to UBOUND(arrActualValues)
												strExpectedValue=arrActualValues(arrCount)
												If INSTR(strAllItems,strExpectedValue)>0 Then
													strDesc="VERIFYDROPDOWN - CHECK FOR FOR SPECIFIC VALUE: The drop down " & chr(34) & strLabel & chr(34) & " contains the value " & chr(34) & strExpectedValue & chr(34) & "."
													clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
													Reporter.Filter = rfEnableAll 
													Reporter.ReportEvent micPass,"Step VERIFYDROPDOWN - CHECK FOR FOR SPECIFIC VALUE", strDesc
													Reporter.Filter = rfDisableAll
												Else
													'Some times user might want to pass "OPTIONAL" in Test Data, when he's not sure if that value would come again or not
														strDesc="VERIFYDROPDOWN - CHECK FOR FOR SPECIFIC VALUE: The drop down " & chr(34) & strLabel & chr(34) & " doesn't contain the value " & chr(34) & strExpectedValue & chr(34) & ", which is not expected."
														clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
														clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
														Reporter.Filter = rfEnableAll 
														Reporter.ReportEvent micFail,"Step VERIFYDROPDOWN - CHECK FOR FOR SPECIFIC VALUE", strDesc
														objEnvironmentVariables.TestCaseStatus=False
														Reporter.Filter = rfDisableAll 
												End If
											Next											
										Else
											strDesc="VERIFYDROPDOWN: The drop down " & chr(34) & strLabel & chr(34) & " contains " & chr(34) & strItemsCount & chr(34) & " values which is more than the expected value of " & chr(34) & (UBOUND(arrActualValues)+1) & chr(34) & ". They actual values displayed are : " & chr(34) & strAllItems & chr(34) &  "."
											clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micFail,"Step VERIFYDROPDOWN", strDesc
											objEnvironmentVariables.TestCaseStatus=False
											Reporter.Filter = rfDisableAll 
										End If		


								End Select						 
							Else
								If blnExpectdVal Then
									strDesc="VERIFYDROPDOWN: The drop down " & chr(34) & strLabel & chr(34) & " does not exist."
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micFail,"Step VERIFYDROPDOWN", strDesc
									objEnvironmentVariables.TestCaseStatus=False
									Reporter.Filter = rfDisableAll  
								Else
									strDesc="VERIFYDROPDOWN: The drop down " & chr(34) & strLabel & chr(34) & " is not displayed on the screen, as expected."
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micPass,"Step VALIDATEPRODUCTDETAILS", strDesc
									Reporter.Filter = rfDisableAll		
								End If

							End If

							
							
							Case "VLDSHOPBYSIZE"
									'Added by Govardhan 12-7-10 to select drop down item and validate the results based on selection
									clsModuleScript.FnvldShopBySize objsub , Object_Name, strInputValue, strDbValue, strOptParam, clsReport, objEnvironmentVariables ,clsScreenShot ,iRowCnt ,Screen_shot_path ,strSheet_Name ,strLabel , strExpectedValue , strTestDataReference, ModuleName									

							Case "VERIFYBULKINSERT" 'only for ECOM
								'Ram 5-4-10 - Added  new function to search all the products and perform bulk insert on the product
								clsModuleScript.FnVerifyBulkInsert objsub , Object_Name, strInputValue, strDbValue, strOptParam, clsReport, objEnvironmentVariables ,clsScreenShot ,iRowCnt ,Screen_shot_path ,strSheet_Name ,strLabel , strExpectedValue , strTestDataReference, ModuleName

							Case "VERIFYCOLORSWATCHES" 'only for ECOM
								'Ram 5-4-10 - Added  new function to search all the products and perform bulk insert on the product
								clsModuleScript.FnVerifyColorSwatches objsub , Object_Name, strInputValue, strDbValue, strOptParam, clsReport, objEnvironmentVariables ,clsScreenShot ,iRowCnt ,Screen_shot_path ,strSheet_Name ,strLabel , strExpectedValue , strTestDataReference, ModuleName

							Case "VERIFYPRODADDNVIEWS" 'only for ECOM
								'
								clsModuleScript.FnVerifyAddnViews objsub , Object_Name, strInputValue, strDbValue, strOptParam, clsReport, objEnvironmentVariables ,clsScreenShot ,iRowCnt ,Screen_shot_path ,strSheet_Name ,strLabel , strExpectedValue , strTestDataReference, ModuleName

							Case "VERIFYYOUMAYALSOLIKE" 'only for ECOM
								'
								clsModuleScript.FnVerifyYouMayAlsoLike objsub , Object_Name, strInputValue, strDbValue, strOptParam, clsReport, objEnvironmentVariables ,clsScreenShot ,iRowCnt ,Screen_shot_path ,strSheet_Name ,strLabel , strExpectedValue , strTestDataReference, ModuleName

                            'Comapres the Values of Two Objects passed as inputs
						 'GOV - 4-5-2010- Added Code to Compare two string objects that are passed  as input
						 Case "COMPARETEXTBOX"
                             arrObjName=Split(Object_Name,":")
							 Set obj1=objsub.WebEdit(TRIM(arrObjName(0)))
							 Set obj2=objsub.WebEdit(TRIM(arrObjName(1)))


							'Check the expected value
							If UCase(strExpectedValue)="TRUE" OR Trim(strExpectedValue) ="" Then
								blnExpVal = True
								obj1.Highlight
								obj2.Highlight
							Else
								blnExpVal = False
							End If 

							 'Verify if the both the object exists
							 If  obj1.Exist(5) And obj2.Exist(5) Then
								 	obj1.Highlight
									obj2.Highlight
								 If TRIM((obj1.GetROProperty("Value"))=TRIM(obj2.GetROProperty("Value"))) Then
										'Check for the expected value
										If  blnExpVal Then 
											strDesc = "COMPARETEXTBOX: The textboxes " & chr(34) & arrObjName(0) & chr(34) &  "/" & arrObjName(1) & chr(34) & " contain the same value " & chr(34) & obj1.GetROProperty("Value") & chr(34) &  " as expected."
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micPass,"Step COMPARETEXTBOX", strDesc
											Reporter.Filter = rfDisableAll
											Set fObjBC=Nothing		
										Else
											strDesc = "COMPARETEXTBOX: The textboxes " & chr(34) & arrObjName(0) & chr(34) &  "/" & arrObjName(1) & chr(34) & " contain the same value " & chr(34) & obj1.GetROProperty("Value") & chr(34) &  " which is not expected."
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micFail,"Step COMPARETEXTBOX", strDesc
											objEnvironmentVariables.TestCaseStatus=False 
											Reporter.Filter = rfDisableAll
											clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0	
										End If
								 Else
										If  blnExpVal Then 
											strDesc = "COMPARETEXTBOX: The textboxes " & chr(34) & arrObjName(0) & chr(34) &  "/" & arrObjName(1) & chr(34) & " doesn't contain the same value " & chr(34) & obj1.GetROProperty("Value") & chr(34) &  " which is not expected."
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micFail,"Step COMPARETEXTBOX", strDesc
											objEnvironmentVariables.TestCaseStatus=False 
											Reporter.Filter = rfDisableAll
											clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0	
										Else
											strDesc = "COMPARETEXTBOX: The textboxes " & chr(34) & arrObjName(0) & chr(34) &  "/" & arrObjName(1) & chr(34) & " doesn't contain the same value " & chr(34) & obj1.GetROProperty("Value") & chr(34) &  " as expected."
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micPass,"Step COMPARETEXTBOX", strDesc
											Reporter.Filter = rfDisableAll
											Set fObjBC=Nothing		
										End If
								 End If
						     Else ' If boxes don't exist
									strDesc = "COMPARETEXTBOX: Either one/both the text boxes " & chr(34) & arrObjName(0) & chr(34) &  "/" & arrObjName(1) & chr(34)  & " doesn't exist."
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micFail,"Step COMPARETEXTBOX", strDesc
									objEnvironmentVariables.TestCaseStatus=False 
									Reporter.Filter = rfDisableAll
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
							 End If


						'Comapres the Values of Two Objects passed as inputs
						 'GOV - 4-5-2010- Added Code to Compare two string objects that are passed  as input to DropDown Boxes
						 Case "COMPAREDROPDOWNBOX"
						'	'''''''''''''''''''''''''''''''''''msgbox "COMPAREDROPDOWNBOX"
                             arrObjName=Split(Object_Name,":")
							 Set obj1=objsub.WebList(TRIM(arrObjName(0)))
							 Set obj2=objsub.WebList(TRIM(arrObjName(1)))
								
							'Check the expected value
							If UCase(strExpectedValue)="TRUE" OR Trim(strExpectedValue) ="" Then
								blnExpVal = True
							Else
								blnExpVal = False
							End If 


							 'Verify if the both the object exists
							 If  obj1.Exist(5) And obj2.Exist(5) Then
								 obj1.Highlight
								 obj2.Highlight
								 If TRIM((obj1.GetROProperty("Value"))=TRIM(obj2.GetROProperty("Value"))) Then
										'Check for the expected value
										If  blnExpVal Then 
											strDesc = "COMPAREDROPDOWNBOX: The  DropDownboxes " & chr(34) & arrObjName(0) & chr(34) &  "/" & arrObjName(1) & chr(34) & " contain the same value " & chr(34) & obj1.GetROProperty("Value") & chr(34) &  " as expected."
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micPass,"Step COMPAREDROPDOWNBOX", strDesc
											Reporter.Filter = rfDisableAll
											Set fObjBC=Nothing		
										Else
											strDesc = "COMPAREDROPDOWNBOX: The  DropDownboxes " & chr(34) & arrObjName(0) & chr(34) &  "/" & arrObjName(1) & chr(34) & " contain the same value " & chr(34) & obj1.GetROProperty("Value") & chr(34) &  " which is not expected."
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micFail,"Step COMPAREDROPDOWNBOX", strDesc
											objEnvironmentVariables.TestCaseStatus=False 
											Reporter.Filter = rfDisableAll
											clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0	
										End If
								 Else
										If  blnExpVal Then 
											strDesc = "COMPAREDROPDOWNBOX: The DropDownboxes " & chr(34) & arrObjName(0) & chr(34) &  "/" & arrObjName(1) & chr(34) & " doesn't contain the same value " & chr(34) & obj1.GetROProperty("Value") & chr(34) &  " which is not expected."
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micFail,"Step COMPAREDROPDOWNBOX", strDesc
											objEnvironmentVariables.TestCaseStatus=False 
											Reporter.Filter = rfDisableAll
											clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0	
										Else
											strDesc = "COMPAREDROPDOWNBOX: The  DropDownboxes " & chr(34) & arrObjName(0) & chr(34) &  "/" & arrObjName(1) & chr(34) & " doesn't contain the same value " & chr(34) & obj1.GetROProperty("Value") & chr(34) &  " as expected."
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micPass,"Step COMPAREDROPDOWNBOX", strDesc
											Reporter.Filter = rfDisableAll
											Set fObjBC=Nothing		
										End If
								 End If
						     Else ' If boxes don't exist
									strDesc = "COMPAREDROPDOWNBOX: Either one/both the text boxes " & chr(34) & arrObjName(0) & chr(34) &  "/" & arrObjName(1) & chr(34)  & " doesn't exist."
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micFail,"Step COMPAREDROPDOWNBOX", strDesc
									objEnvironmentVariables.TestCaseStatus=False 
									Reporter.Filter = rfDisableAll
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
							 End If

'						Case "FILE"

'							strInputValue="sample"
'							strOptParam="C:\PaylessEComm_RegressionAutomation\CRAFT\Framework_Scripts\Module_Script\PAYLESS_ECOMM"
'		
'							filepath1=strOptParam & "\" & strInputValue & ".vbs"

'							ExecuteFile filepath1
'							Set clsName = New OwnScript
'							clsName.OwnScript

						Case "MOUSEOVER"
							'Ram - 7-4-10 - Added to perform mouse over on various objects							

							If Browser("brwMain").Page("pgeGeneral").WebElement("elmThankYou").Exist(1) Then
								Browser("brwMain").Page("pgeGeneral").WebButton("btnNoThanks").Click
							End If

						If  Environment.Value("CurrentBrowser")<>"" Then
							If UCASE(Environment.Value("CurrentBrowser"))=UCASE(Environment.Value ("BrowserName")) Then

								Select Case UCASE(TRIM(strInputValue))
									Case "IMAGE"
										Set obj=objsub.Image(Object_Name)
										obj.highlight									
										Setting.WebPackage("ReplayType") = 2
										obj.FireEvent "onMouseOver"									
										Setting.WebPackage("ReplayType") = 1
									Case "LINK"
										Set obj=objsub.Link(Object_Name)
										obj.highlight									
										Setting.WebPackage("ReplayType") = 2
										obj.FireEvent "onMouseOver"									
										Setting.WebPackage("ReplayType") = 1
	
									Case "WEBELEMENT"
										Set obj=objsub.WebElement(Object_Name)
										obj.highlight									
										Setting.WebPackage("ReplayType") = 2
										obj.FireEvent "onMouseOver"									
										Setting.WebPackage("ReplayType") = 1
								End Select
  							End If
						Else
							Select Case UCASE(TRIM(strInputValue))
								Case "IMAGE"
									Set obj=objsub.Image(Object_Name)
									obj.highlight									
									Setting.WebPackage("ReplayType") = 2
									obj.FireEvent "onMouseOver"									
									Setting.WebPackage("ReplayType") = 1
								Case "LINK"
									Set obj=objsub.Link(Object_Name)
									obj.highlight									
									Setting.WebPackage("ReplayType") = 2
									obj.FireEvent "onMouseOver"									
									Setting.WebPackage("ReplayType") = 1

								Case "WEBELEMENT"
									Set obj=objsub.WebElement(Object_Name)
									obj.highlight									
									Setting.WebPackage("ReplayType") = 2
									obj.FireEvent "onMouseOver"									
									Setting.WebPackage("ReplayType") = 1
							End Select
						End  If		

							Case "CAPTURETOOLTIP"

'							If  strInputValue<>"" Then
'											strInputValue=TRIM(strInputValue)
'							End If
'
'							If Window("nativeclass:=tooltips_class32").Exist(3) Then
'
'								 strActual=Window("nativeclass:=tooltips_class32").GetROProperty("text")
'											 If strInputValue=strActual OR INSTR(strActual,strInputValue)>0 Then
'
'															strDesc = "CAPTURETOOLTIP: Tool tip is displayed with the expected value of -  "& strInputValue & "."
'															clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
'															Reporter.Filter = rfEnableAll 
'															Reporter.ReportEvent micPass,"Step CAPTURETOOLTIP", strDesc
'															Reporter.Filter = rfDisableAll                                                                                                                                                                      
'											 Else   
'															strDesc = "CAPTURETOOLTIP: " & strpartdesc&" at the row number " & iRowCnt+1 & " the Tool tip is not displayed with the expected value of -  "& strInputValue & ", instead it's displayed with - " & strActual &  "."
'															Reporter.Filter = rfEnableAll 
'															Reporter.ReportEvent micFail,"Step CAPTURETOOLTIP ", strDesc
'															objEnvironmentVariables.TestCaseStatus=False 
'															Reporter.Filter = rfDisableAll
'															clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables                                                                                
'															clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0                                                                                                                                                                                      
'											 End If
'							Else
'															strDesc = "CAPTURETOOLTIP: " & strpartdesc&" at the row number " & iRowCnt+1 & " the Tool tip is not displayed."
'															Reporter.Filter = rfEnableAll 
'															Reporter.ReportEvent micFail,"Step CAPTURETOOLTIP ", strDesc
'															objEnvironmentVariables.TestCaseStatus=False 
'															Reporter.Filter = rfDisableAll
'															clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables                                                                                
'															clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0                                                                                                                                      
'							End If




								If Browser("brwMain").Page("pgeGeneral").WebElement("elmThankYou").Exist(1) Then
									Browser("brwMain").Page("pgeGeneral").WebButton("btnNoThanks").Click
								End If

								If  strInputValue<>"" Then
											strInputValue=TRIM(strInputValue)
								End If

								'Tooltip is only for IE

							If  UCASE(Environment.Value ("BrowserName"))="IE" Then

							Select Case UCASE(TRIM(strOptParam))
								Case "IMAGE"
									Set obj=objsub.Image(Object_Name)
									obj.highlight									
									Setting.WebPackage("ReplayType") = 2
									obj.FireEvent "onMouseOver"									
									Setting.WebPackage("ReplayType") = 1
								Case "LINK"
									Set obj=objsub.Link(Object_Name)
									obj.highlight									
									Setting.WebPackage("ReplayType") = 2
									obj.FireEvent "onMouseOver"									
									Setting.WebPackage("ReplayType") = 1

								Case "WEBELEMENT"
									Set obj=objsub.WebElement(Object_Name)
									obj.highlight									
									Setting.WebPackage("ReplayType") = 2
									obj.FireEvent "onMouseOver"									
									Setting.WebPackage("ReplayType") = 1
								End Select

							If Window("nativeclass:=tooltips_class32").Exist(2) Then

								 strActual=Window("nativeclass:=tooltips_class32").GetROProperty("text")
											 If strInputValue=strActual OR INSTR(strActual,strInputValue)>0 Then
															strDesc = "CAPTURETOOLTIP: Tool tip is displayed with the expected value of -  "& strInputValue & "."
															clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
															Reporter.Filter = rfEnableAll 
															Reporter.ReportEvent micPass,"Step CAPTURETOOLTIP", strDesc
															Reporter.Filter = rfDisableAll                                                                                                                                                                      
											 Else   
															strDesc = "CAPTURETOOLTIP: " & strpartdesc&" at the row number " & iRowCnt+1 & " the Tool tip is not displayed with the expected value of -  "& strInputValue & ", instead it's displayed with - " & strActual &  "."
															Reporter.Filter = rfEnableAll 
															Reporter.ReportEvent micFail,"Step CAPTURETOOLTIP ", strDesc
															objEnvironmentVariables.TestCaseStatus=False 
															Reporter.Filter = rfDisableAll
															clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables                                                                                
															clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0                                                                                                                                                                                      
											 End If
							Else  'For other browser
															strDesc = "CAPTURETOOLTIP: " & strpartdesc&" at the row number " & iRowCnt+1 & " the Tool tip is not displayed."
															Reporter.Filter = rfEnableAll 
															Reporter.ReportEvent micFail,"Step CAPTURETOOLTIP ", strDesc
															objEnvironmentVariables.TestCaseStatus=False 
															Reporter.Filter = rfDisableAll
															clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables                                                                                
															clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0                                                                                                                                      
							End If

							Else
								strDesc = "CAPTURETOOLTIP: This feature cannot be checked for other browsers apart from IE."
								Reporter.Filter = rfEnableAll
								Reporter.ReportEvent micdone,"Step CAPTURETOOLTIP ", strDesc
								Reporter.Filter = rfDisableAll 
								clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2
							End If



							Case "ERRORDIALOG"
								'Ram - 8-4-10 - Added to handle error dialog and 'print error
'									If ModuleName="Keds" Then
'											Browser("brwMain").SetTOProperty "name" , ".*Keds.*"
'											Browser("brwMain").Page("pgeGeneral").SetTOProperty "title" , ".*Keds.*"   
'									End If

									If Browser("brwMain").Dialog("dlgError").Exist(3) Then
											strError=Browser("brwMain").Dialog("dlgError").Static("stcMessage").GetROProperty("text")
											Browser("brwMain").Dialog("dlgError").WinButton("btnOk").Click	

											strDesc = "ERRORDIALOG: Error dialog was displayed with the following message during the execution: -  " & strError
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micFail,"Step ERRORDIALOG", strDesc
											objEnvironmentVariables.TestCaseStatus=False 
											Reporter.Filter = rfDisableAll
											clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables

									End If

							   Case "CANNOTFINDPAGE"
								   'Ram - 8-4-10 - Added to handle error page and 'print error
								   	If Browser("brwCannotFindServer").Exist(3) Then
                                            Browser("brwCannotFindServer").Back
											strDesc = "CANNOTFINDPAGE: Cannot Find Page errror is displayed and back was clicked"
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micFail,"Step CANNOTFINDPAGE", strDesc
											objEnvironmentVariables.TestCaseStatus=False 
											Reporter.Filter = rfDisableAll
											clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0    											
									End If

								Case "SWAPBROWSER"
									'Ram - 9-4-10 - Added to handle 2 browsers of the same name and swap between two
									Set obj=Browser(Trim( strObjectName ))
									strInputValue=TRIM(strInputValue)
									obj.SetTOProperty "CreationTime", Cint(strInputValue)
									obj.Highlight


								Case "VERIFYCLOSELINKANDBACK"

									objsub.Highlight
                                    Set obj = objsub.Link(Object_Name)
									obj.highlight

									
									If strOptParam<>"" Then
										If UCASE(TRIM(strOptParam))=UCASE(TRIM(Environment.Value ("BrowserName"))) Then
												obj.Click
												If obj.Exist(5)Then
													If UCASE(TRIM(strTestDataReference))="OPTIONAL" Then
														Reporter.Filter = rfEnableAll 
														Reporter.ReportEvent micdone,"Step VERIFYCLOSELINKANDBACK - The Link "& chr(34) & strLabel & chr(34) &" still exists, which is not expected" 
														objEnvironmentVariables.TestCaseStatus=False 
														Reporter.Filter = rfDisableAll
														clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables				   	
														clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
													End If

													While Obj.Exist(5) 

														Browser("brwGeneral").Back

													Wend
										Else
												strDesc ="VERIFYCLOSELINKANDBACK - The Link "& chr(34) & strLabel & chr(34) & "is not visible, as expected" 
												clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1						
												Reporter.Filter = rfEnableAll 
												Reporter.ReportEvent micPass,"Step VERIFYCLOSELINKANDBACK", strDesc					 
												Reporter.Filter = rfDisableAll											
										End If
											
										End If
									Else
										obj.Click
										If obj.Exist(5)Then
												Reporter.Filter = rfEnableAll 
												Reporter.ReportEvent micdone,"Step VERIFYCLOSELINKANDBACK - The Link "& chr(34) & strLabel & chr(34) &" still exists, which is not expected" 
												objEnvironmentVariables.TestCaseStatus=False 
												Reporter.Filter = rfDisableAll
												clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables				   	
												clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
										Else
												strDesc ="VERIFYCLOSELINKANDBACK -  The Link "& chr(34) & strLabel & chr(34) &"is not visible, as expected" 
												clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1						
												Reporter.Filter = rfEnableAll 
												Reporter.ReportEvent micPass,"Step VERIFYCLOSELINKANDBACK", strDesc					 
												Reporter.Filter = rfDisableAll											
										End If
									End If


								Case "GETORDERNUMBER"
									' Gov -  12-4-10 - Added to get  order number from the Order Confirmation page
									set obj = objsub.WebElement(Object_Name)
									strOrderNum = obj.GetROProperty ( "outertext")
									arrOrderNumber=split(strOrderNum,"Your order number is")
									If UCase ( Left ( Trim ( strOptParam ) , 3 ) )  = "ENV"  Then
											arrOrderNum = Split ( strOptParam , ":" ) 
											Environment.Value( Trim(arrOrderNum(1) )  ) = arrOrderNumber(1)
									End If
			
									strDesc = "GETORDERNUMBER: The Order Number  "& chr(34) & arrOrderNumber(1) & chr(34) &" set with environemnt variable "& chr(34) & arrOrderNum(1) & chr(34) 
									Reporter.Filter = rfEnableAll
									Reporter.ReportEvent micdone,"Step GETORDERNUMBER ", strDesc
									Reporter.Filter = rfDisableAll 
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2

								Case "VERIFYPRODSZ" 'Only for Validating product size
								'Ram 4-6-2010
								clsModuleScript.FnVerifyProductSize objsub , Object_Name, strInputValue, strDbValue, strOptParam, clsReport, objEnvironmentVariables ,clsScreenShot ,iRowCnt ,Screen_shot_path ,strSheet_Name ,strLabel , strExpectedValue , strTestDataReference, ModuleName

								Case "VERIFYRESULTANDPAGINATION" 'Only for pagination and results
								'Ram 28- 6-2010
								clsModuleScript.FnVerifyResultAndPagination objsub , Object_Name, strInputValue, strDbValue, strOptParam, clsReport, objEnvironmentVariables ,clsScreenShot ,iRowCnt ,Screen_shot_path ,strSheet_Name ,strLabel , strExpectedValue , strTestDataReference, ModuleName

								Case "VERIFYSHARETHISLINK" 'Only for share this link
								'Ram 15 7-2010
								clsModuleScript.FnVerifyShareThisLink objsub , Object_Name, strInputValue, strDbValue, strOptParam, clsReport, objEnvironmentVariables ,clsScreenShot ,iRowCnt ,Screen_shot_path ,strSheet_Name ,strLabel , strExpectedValue , strTestDataReference, ModuleName

								Case "VERIFYDYNAMICTABS" 'Only for dynamic tabs
								'Ram 19-7-2010
								clsModuleScript.FnVerifyDymanicTabs objsub , Object_Name, strInputValue, strDbValue, strOptParam, clsReport, objEnvironmentVariables ,clsScreenShot ,iRowCnt ,Screen_shot_path ,strSheet_Name ,strLabel , strExpectedValue , strTestDataReference, ModuleName

								Case "CHK90DAYSEXPIRYMESSAGE" 'Only for DISPLAYPAYMENT --> TC_25_Vef_Pymnt_Disp_ExpiryMsg1
								'Ram 17-5-2010
								clsModuleScript.FnDispPymntExpMsg objsub , Object_Name, strInputValue, strDbValue, strOptParam, clsReport, objEnvironmentVariables ,clsScreenShot ,iRowCnt ,Screen_shot_path ,strSheet_Name ,strLabel , strExpectedValue , strTestDataReference 


								Case "VALIDADDITIONALNOTICES" 'Only for ECom
							  ' Shiva Akula (29-6-10)
								clsModuleScript.FnValidAdditionalNotices objsub , Object_Name, strInputValue, strDbValue, strOptParam, clsReport, objEnvironmentVariables ,clsScreenShot ,iRowCnt ,Screen_shot_path ,strSheet_Name ,strLabel , strExpectedValue , strTestDataReference, ModuleName 

								Case "CHKSHPNGBAGSUMMARY" 'Only for SHOPPINGBAG --> TC_09_Vef_Updt_butn_shpng_bag
								'Ram 28-5-2010
								clsModuleScript.FnChkShpngBagSummary objsub , Object_Name, strInputValue, strDbValue, strOptParam, clsReport, objEnvironmentVariables ,clsScreenShot ,iRowCnt ,Screen_shot_path ,strSheet_Name ,strLabel , strExpectedValue , strTestDataReference, ModuleName

								Case "SHIPPINGMETHODCHARGES" 'Only for SHOPINGBAG
									'Fayis June-07,2010
									clsModuleScript.FnShippingMethodCharges objsub , Object_Name, strInputValue, strDbValue, strOptParam, clsReport, objEnvironmentVariables ,clsScreenShot ,iRowCnt ,Screen_shot_path ,strSheet_Name ,strLabel , strExpectedValue , strTestDataReference, ModuleName


                               Case "SHIPPINGCHARGES" 'Only for HSOPINGBAG
									'Fayis June-15,2010
									clsModuleScript.FnShippingCharges objsub , Object_Name, strInputValue, strDbValue, strOptParam, clsReport, objEnvironmentVariables ,clsScreenShot ,iRowCnt ,Screen_shot_path ,strSheet_Name ,strLabel , strExpectedValue , strTestDataReference, ModuleName

								Case "VERIFYREGCONFPGMEDIASLOT" 'Only for REGISTRATION MODULE
									'Ram Aug 4th 2010
									clsModuleScript.FnVerifyMediaSlotInRegConfPage objsub , Object_Name, strInputValue, strDbValue, strOptParam, clsReport, objEnvironmentVariables ,clsScreenShot ,iRowCnt ,Screen_shot_path ,strSheet_Name ,strLabel , strExpectedValue , strTestDataReference, ModuleName

								Case "REMOVELINKINSHPNGBAG" 'Only for SHOPPINGBAG --> TC_17_Vef_ Rmov_Link_SpngBag
								'Ram 24-5-2010
								clsModuleScript.FnRemoveLinkInShoppingBag objsub , Object_Name, strInputValue, strDbValue, strOptParam, clsReport, objEnvironmentVariables ,clsScreenShot ,iRowCnt ,Screen_shot_path ,strSheet_Name ,strLabel , strExpectedValue , strTestDataReference, ModuleName

								Case "DELETEALLADDRESS" 'Only for ECom
								'Fayis 13-410 ' To DELETE ALL ADDRESS in my account page
								clsModuleScript. FnDeleteAllAddress objsub , Object_Name, strInputValue, strDbValue, strOptParam, clsReport, objEnvironmentVariables ,clsScreenShot ,iRowCnt ,Screen_shot_path ,strSheet_Name ,strLabel , strExpectedValue , strTestDataReference 

								Case "ADDTOSHOPPINGBAG" 'Only for ECom
								'Ram 22-4-10 ' To add a product to shopping bag
								clsModuleScript. FnAddToShoppingBag objsub , Object_Name, strInputValue, strDbValue, strOptParam, clsReport, objEnvironmentVariables ,clsScreenShot ,iRowCnt ,Screen_shot_path ,strSheet_Name ,strLabel , strExpectedValue , strTestDataReference , ModuleName

								Case "ADDPRODUCTTOBAG" 'Only for ECom
								'Ram 22-4-10 ' To add a product to just to the bag
								clsModuleScript. FnAddProductToBag objsub , Object_Name, strInputValue, strDbValue, strOptParam, clsReport, objEnvironmentVariables ,clsScreenShot ,iRowCnt ,Screen_shot_path ,strSheet_Name ,strLabel , strExpectedValue , strTestDataReference , ModuleName

                                Case "DLTALLPYMNTMETHOD" 'Only for ECom
								'Fayis 23-410 ' 
								clsModuleScript. FnDeleteAllAddress objsub , Object_Name, strInputValue, strDbValue, strOptParam, clsReport, objEnvironmentVariables ,clsScreenShot ,iRowCnt ,Screen_shot_path ,strSheet_Name ,strLabel , strExpectedValue , strTestDataReference 								

								Case "VERIFYORDERTOTAL" 'Only for ACCOUNT MANAGEMENT-->DISPLAY ORDER HISTORY --> TC_04 _Verify_Order_History_Price
								'Govardhan 18-6-2010
								clsModuleScript. FnOrderTotal objsub , Object_Name, strInputValue, strDbValue, strOptParam, clsReport, objEnvironmentVariables , clsScreenShot , iRowCnt , Screen_shot_path , strSheet_Name , strLabel ,  strExpectedValue , strTestDataReference, ModuleName

								Case "VLDSEARCHSORTING" 'Only for SEARCH-->TC_05_Verify_Search_Results_Sorting
								'Govardhan 18-6-2010
								clsModuleScript. FnSearchSorting objsub , Object_Name, strInputValue, strDbValue, strOptParam, clsReport, objEnvironmentVariables , clsScreenShot , iRowCnt , Screen_shot_path , strSheet_Name , strLabel ,  strExpectedValue , strTestDataReference, ModuleName

								Case "VLDSEARCHRESULTS" 'Only for SEARCH-->TC_06_Verify_product_display_on_Search_Results_page
								'Govardhan 24-6-2010
								clsModuleScript. FnSearchResults objsub , Object_Name, strInputValue, strDbValue, strOptParam, clsReport, objEnvironmentVariables , clsScreenShot , iRowCnt , Screen_shot_path , strSheet_Name , strLabel ,  strExpectedValue , strTestDataReference, ModuleName

								Case "VERIFYORDERHISTORY" 'Only for	 ACCOUNT MANAGEMENT-->DISPLAY ORDER HISTORY -->TC_02_Verify_Order_History_Order_Dates_1
								'Govardhan 18-6-2010
								clsModuleScript. FnOrderHistory objsub , Object_Name, strInputValue, strDbValue, strOptParam, clsReport, objEnvironmentVariables , clsScreenShot , iRowCnt , Screen_shot_path , strSheet_Name , strLabel ,  strExpectedValue , strTestDataReference, ModuleName

								'Fayis 30-07-10
								Case "PROMONCPNCHECK" 'Only for	 ACCOUNT MANAGEMENT-->DISPLAY ORDER HISTORY -->TC_02_Verify_Order_History_Order_Dates_1
								'Govardhan 18-6-2010
								clsModuleScript. FnPromoNCpnCheck objsub , Object_Name, strInputValue, strDbValue, strOptParam, clsReport, objEnvironmentVariables , clsScreenShot , iRowCnt , Screen_shot_path , strSheet_Name , strLabel ,  strExpectedValue , strTestDataReference, ModuleName

								'Fayis 06-08-2010
								Case "REMOVEALLCPNS"
									clsModuleScript. FnRemoveAllCoupons objsub , Object_Name, strInputValue, strDbValue, strOptParam, clsReport, objEnvironmentVariables , clsScreenShot , iRowCnt , Screen_shot_path , strSheet_Name , strLabel ,  strExpectedValue , strTestDataReference, ModuleName

								Case "CHECKPROMOINPLACEORDER"
								'Fayis
								clsModuleScript. FnCheckPromoInPlaceOrder objsub , Object_Name, strInputValue, strDbValue, strOptParam, clsReport, objEnvironmentVariables , clsScreenShot , iRowCnt , Screen_shot_path , strSheet_Name , strLabel ,  strExpectedValue , strTestDataReference, ModuleName

								Case "CHECKPRICEAFTERCPN"
								'Fayis
								clsModuleScript. FnCheckPriceAfterCpn objsub , Object_Name, strInputValue, strDbValue, strOptParam, clsReport, objEnvironmentVariables , clsScreenShot , iRowCnt , Screen_shot_path , strSheet_Name , strLabel ,  strExpectedValue , strTestDataReference, ModuleName

								Case "VERIFYORDERHISTORYNAVIGATION" 'Only for	 ACCOUNT MANAGEMENT-->DISPLAY ORDER HISTORY -->TC_09-Verify_Order_History_Previous&Next_1 , TC_10_Vfy_OrdHis_Prev_Next_2,  TC_11_Vfy_OrdHis_Pge_Nmbr_1,  TC_12_Vfy_OrdHis_Pge_Nmbr_2
								'Govardhan 14-7-2010
								clsModuleScript. FnOrderNavigation objsub , Object_Name, strInputValue, strDbValue, strOptParam, clsReport, objEnvironmentVariables , clsScreenShot , iRowCnt , Screen_shot_path , strSheet_Name , strLabel ,  strExpectedValue , strTestDataReference, ModuleName

								Case "VLDSHIPPINGANDTAXES" 'Only for	CheckOut  ---> ExpressCheckOut --->TC_76_Vef_GUI_Ordr_Rvw_Pg
								'Govardhan 16-7-2010
								clsModuleScript. FnShippingTaxes objsub , Object_Name, strInputValue, strDbValue, strOptParam, clsReport, objEnvironmentVariables , clsScreenShot , iRowCnt , Screen_shot_path , strSheet_Name , strLabel ,  strExpectedValue , strTestDataReference, ModuleName

                                Case "CHECKPRODLINK"
									'Fayis
								clsModuleScript. FnCheckProductLink objsub , Object_Name, strInputValue, strDbValue, strOptParam, clsReport, objEnvironmentVariables , clsScreenShot , iRowCnt , Screen_shot_path , strSheet_Name , strLabel ,  strExpectedValue , strTestDataReference, ModuleName

                                Case "CHECKPRODIMAGE"
									'Fayis
									clsModuleScript. FnCheckProductImage objsub , Object_Name, strInputValue, strDbValue, strOptParam, clsReport, objEnvironmentVariables , clsScreenShot , iRowCnt , Screen_shot_path , strSheet_Name , strLabel ,  strExpectedValue , strTestDataReference, ModuleName


								Case "GENERATEDATE"
										'Ram 15-4-2010  to Generate different date formats
										
										'Variables related to current date
										'**************************************
										strCurrentDate=Date
										strTemp=Split(strCurrentDate,"/")
										strCrntMM=strTemp(0) 'Month
										strCrntMN=MonthName(strCrntMM) 'Month's Name
										strCrntYYYY=strTemp(2) 'Year YYYY
										strCrntYY=RIGHT(strCrntYYYY,2) 'Year YY
										strCrntDD=strTemp(1) 'Date
										If strCrntDD<10 Then
											strCrntDD="0" & strCrntDD
										End If
										strLngDF=FormatDateTime(Date,1) 'Long Date
										
										
										'Variables related to 2nd date
										'**********************************
										blnNewDate=False
										If strTestDataReference<>"" Then
											arrTDR=split(strTestDataReference,":")
											arrOprn=arrTDR(0)
											arrValue=arrTDR(1)
											'Plus or Minus the current date
											Select Case UCASE(TRIM(arrOprn))
												Case "PLUS"
													StrNewDate=Date+1
													blnNewDate=True
												Case "MINUS"
													StrNewDate=Date-1	
													blnNewDate=True
											End Select
										
											strTemp1=Split(StrNewDate,"/")
											strNwMM=strTemp1(0) 'Month
											strNwMN=MonthName(strNwMM) 'Month's Name
											strNwYYYY=strTemp1(2) 'Year YYYY
											strNwYY=RIGHT(strNwYYYY,2) 'Year YY
											strNwDD=strTemp1(1) 'Date
											If strNwDD<10 Then
												strNwDD="0" & strNwDD
											End If
											strNwDF=FormatDateTime(Date,1) 'Long Date
										End If
										
										
										Select Case strInputValue
											Case "DF1" 'E.g: April 13, 2011		'
												'General System Date
												strDate=strCrntMN & " " & strCrntDD & ", " &  strCrntYYYY

												'Store in one ENV Value
												If  strOptParam<>"" Then
													arrOptParam=Split(strOptParam,":")
													If  UCASE(TRIM(arrOptParam(0)))="ENV" Then
														Environment.Value( Trim(  arrOptParam(1) )  ) = strDate
														'Check if the new date is also needed
														If blnNewDate Then
															strNewDate=strNwMN & " " & strNwDD & ", " &  strNwYYYY
															Environment.Value( Trim(  arrOptParam(3) )  ) = strNewDate
														End If
													End If
												End If
											Case "CURRENTDAY"
													If  strOptParam<>"" Then
														arrOptParam=Split(strOptParam,":")
														If  UCASE(TRIM(arrOptParam(0)))="ENV" Then
															Environment.Value( Trim(  arrOptParam(1) )  ) = strCrntDD
														End If
													End If
											Case "CURRENTMONTH"
													If  strOptParam<>"" Then
														arrOptParam=Split(strOptParam,":")
														If  UCASE(TRIM(arrOptParam(0)))="ENV" Then
															Environment.Value( Trim(  arrOptParam(1) )  ) = strCrntMM
														End If
													End If
											Case "CURRENTYEARYY"
													If  strOptParam<>"" Then
														arrOptParam=Split(strOptParam,":")
														If  UCASE(TRIM(arrOptParam(0)))="ENV" Then
															Environment.Value( Trim(  arrOptParam(1) )  ) = strCrntYY
														End If
													End If

											Case "CURRENTYEARYYYY"
													If  strOptParam<>"" Then
														arrOptParam=Split(strOptParam,":")
														If  UCASE(TRIM(arrOptParam(0)))="ENV" Then
															Environment.Value( Trim(  arrOptParam(1) )  ) = strCrntYYYY
														End If
													End If
											Case "CURRENTMONTHNAME"

													If  strOptParam<>"" Then
														arrOptParam=Split(strOptParam,":")
														If  UCASE(TRIM(arrOptParam(0)))="ENV" Then
															Environment.Value( Trim(  arrOptParam(1) )  ) = strCrntMN

														End If
													End If
											End Select

                                    

								'To 'print a comment in result sheet
								Case "COMMENT"

  '											Fayis added on 04-15-10
										    strDesc=  "</br><b><i>"& strLabel &"</i></b>"
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micDone,"", strDesc
											Reporter.Filter = rfDisableAll

								
                                Case "GETLISTBOXVALUE" 	
									'Govardan - 15-4-10
										set obj = objsub.WebList(Object_Name)
										If obj.Exist (2)  Then
											strListBoxValue = obj.GetROProperty ( "value")
										Else
											strListBoxValue = "Drop Down Box not found"
										End If		
										If  strInputValue<>""Then
											arrStrInput=Split(strInputValue,":")
											'Check whether a specific value is populated in the textbox or not
											Select Case UCASE(TRIM(arrStrInput(0)))
												Case "ADDIN"
													If strListBoxValue <>   "Drop Down Box not found" Then
													   strListBoxValue=strListBoxValue & arrStrInput(1)
													End if
			
												Case "MODIFY"
													If strListBoxValue <>   "Drop Down Box not found" Then
														arrListVal=split(strListBoxValue,arrStrInput(1))
													   strListBoxValue=arrListVal(1)
												End if
											End Select
										End If
			
										If UCase ( Left ( Trim ( strOptParam ) , 3 ) )  = "ENV"  Then
											arrProductValue = Split ( strOptParam , ":" ) 
											Environment.Value( Trim(  arrProductValue(1) )  ) = strListBoxValue
										End If     
										                         
										strDesc = "GETLISTBOXVALUE: The Current Value in Drop Down Box is : "& chr(34) & strListBoxValue & chr(34) 
										Reporter.Filter = rfEnableAll
										Reporter.ReportEvent micdone,"Step GETLISTBOXVALUE ", strDesc
										Reporter.Filter = rfDisableAll 
										clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2

										Set obj=Nothing

                                Case "GETVALUEFROMTEXTBOX"
									'Govardan - 15-4-10
									set obj = objsub.WebEdit(Object_Name)
									If obj.Exist (2)  Then
											strTextValue = obj.GetROProperty ( "value")	
											If UCase ( Left ( Trim ( strOptParam ) , 3 ) )  = "ENV"  Then
												arrOptParam = Split ( strOptParam , ":" ) 
												Environment.Value( Trim(  arrOptParam(1) )  ) = strTextValue
											End If  
	
											If strInputValue <> ""  Then
												arrIndexVal=Split(strInputValue,":")
												If LBOUND(arrInpVal)="INDEX" Then ' To know it's passed as an array
														obj.SetTOProperty("Index") = arrIndexVal(1)		
												End if 
											End if
									strDesc = "GETVALUEFROMTEXTBOX: The Value in text Box "& chr(34) & strProductName & chr(34) &" set with environemnt variable "& chr(34) & arrProductValue(1)  & chr(34) 
									Reporter.Filter = rfEnableAll
									Reporter.ReportEvent micdone,"Step GETVALUEFROMTEXTBOX ", strDesc
									Reporter.Filter = rfDisableAll 
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2
								Else
										strDesc = strpartdesc&" at the row number "&iRowCnt+1&" the page " & chr(34) & strLabel & chr(34) & " does not exists."													
										Reporter.Filter = rfEnableAll 
										Reporter.ReportEvent micFail,"Step GETVALUEFROMTEXTBOX ", strDesc
										objEnvironmentVariables.TestCaseStatus=False 
										Reporter.Filter = rfDisableAll
										clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables				   	
										clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
								End If			

								Case "LOGINTOGMAIL"
									'Ram 16-4-10- Added to login into mail
										WebUtil.deletecookies
										strInputValue=TRIM(strInputValue)
										arrInpVal=Split(strInputValue,"~")
										strMailId=arrInpVal(0)		
										strPwd=arrInpVal(1)										
										
										'Invoke Gmail
										'****************
										strURL ="www.gmail.com"
										
										If Environment.Value ("BrowserName") = "IE"  Then
											SystemUtil.Run "iexplore.exe",strURL ,"" ,"" , 3
											strDesc = "GMAIL opened"
											
										ElseIf Environment.Value ("BrowserName") = "Firefox"  Then	
											SystemUtil.Run "Firefox.exe",strURL ,"" ,"" , 3
											strDesc
										End If
										wait 4														
										clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2
										Reporter.Filter = rfEnableAll 
										Reporter.ReportEvent micdone,"GMAIL", strDesc
										
										'By pass the CTS quota time
										'*I*******************************
										
										If Browser("brwAccessBlocked").Page("brwAccessBlocked").Exist(5) Then
											Browser("brwAccessBlocked").Page("brwAccessBlocked").WebButton("btnUseQuotaTime").Click
											Do 
												Wait 1
											Loop Until Browser("brwGmail").Exist(1)=True
										End If
										
										'Login into Gmail
										'*******************
										Browser("brwGmail").Page("pgeGmail").WebEdit("edtEmail").Set strMailId
										Browser("brwGmail").Page("pgeGmail").WebEdit("edtPassword").Set strPwd
										Browser("brwGmail").Page("pgeGmail").WebButton("btnSignIn").Click
										If Browser("brwGmail").Dialog("dlgAutoCompletePwd").Exist(3) Then
											Browser("brwGmail").Dialog("dlgAutoCompletePwd").WinCheckBox("chkDontOffer").Set "ON"
											Browser("brwGmail").Dialog("dlgAutoCompletePwd").WinButton("btnNo").Click	
										End If
										Do
											Wait 1
										Loop Until Browser("brwGmail").Page("pgeGmail").Link("lnkInbox").Exist(1)=True

									Case "DELETEALLMAILSININBOX"
										''Ram 16-4-10- Added to delete all mails
									'Delete all the mails in the inbox
									'************************************
									Browser("brwGmail").Page("pgeGmail").Link("lnkInbox").Click
									If Browser("brwGmail").Page("pgeGmail").WebElement("elmNoNewMail").Exist(3)Then
										Browser("brwGmail").Page("pgeGmail").Link("lnkSignout").Click
										Browser("brwGmail").Close
										WebUtil.deletecookies
									Else
											Browser("brwGmail").Page("pgeGmail").WebElement("emlSelectAll").Click
											Wait 2
											Do
												Browser("brwGmail").Page("pgeGmail").WebElement("elmDelete").Click
											Loop Until Browser("brwGmail").Page("pgeGmail").WebTable("tblInbox").Exist(2)<>True
											Browser("brwGmail").Close
											WebUtil.deletecookies
											strDesc = "DELETEALLMAILSININBOX - All mails under the inbox are deleted."
											Reporter.Filter = rfEnableAll
											Reporter.ReportEvent micdone,"Step DELETEALLMAILSININBOX ", strDesc
											Reporter.Filter = rfDisableAll 
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2
									End If

									Case "VERIFYORDERCONFIRMATIONMAIL"
									'Ram 16-4-10- Added to verify conf mail
										
										If strInputValue <> ""  Then
												arrInpVal=Split(strInputValue,":")
												If UBOUND(arrInpVal)>0 Then ' To know it's passed as an array
													Select Case UCASE(TRIM(arrInpVal(0)))
														 Case "ENV"
															 'Get the expected value
															 '****************************
															strOrderNo=Environment.Value( Trim(  arrInpVal(1) ))
															strLabel=strOrderNo   
													End Select
													'Noramally passed
												Else
													strOrderNo=TRIM(strInputValue) ' Use what ever the string is passed in the column value
												End If		
										End If		
'									
										Set obj=Browser("brwGmail").Page("pgeGmail")
										obj.Link("lnkInbox").Click
										'2. Check if the inbox grid is empty or not
										If (obj.WebElement("elmNoNewMail").Exist(3)) OR (obj.WebTable("tblInbox").Exist(2)=False)Then
											obj.Link("lnkSignout").Click
											Browser("brwGmail").Close
										
										'3.Write the report
											strDesc = "VERIFYORDERCONFIRMATIONMAIL - No mail received with the subject 'Order Confirmation' under the inbox"								
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micFail,"Step VERIFYORDERCONFIRMATIONMAIL ", strDesc
											objEnvironmentVariables.TestCaseStatus=False 
											Reporter.Filter = rfDisableAll
											clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables				   	
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
										Else
											'In case inbox is not empty
											'1. Check for any mail with the word called order confirmation
											blnMailRcvd=False
											strRows=obj.WebTable("tblInbox").GetROProperty("rows")
											strCols=obj.WebTable("tblInbox").GetROProperty("cols")
											For rwcnt=1 to strRows
												For clcnt=1 to strCols
													strCellValue=obj.WebTable("tblInbox").GetCellData(rwcnt,clcnt)
													If INSTR(strCellValue,"Order Confirmation")>0 OR INSTR(strCellValue,"order confirmation")>0Then
														obj.WebElement("elmOrderConfirmation").SetTOProperty "index",rwcnt
														obj.WebElement("elmOrderConfirmation").Click
														'2. If there's an email with teh word order confirmation, now check for the order number element 
														'a).Expand the mails in case they are clubed to one mail
														If obj.webelement("elmExpandAll").Exist(2) Then
															obj.webelement("elmExpandAll").Click
															Wait 2
														End If
														'b).Check for the order number in the mail, In such a case , it's pass
														Set desc=Description.Create
														desc("micClass").Value="WebElement"
														desc("html tag").value="B"
														desc("innertext").value=".*Order details.*"
														Set elmObj=obj.ChildObjects(desc)
														For i=0 to elmObj.count-1
															strInnerText=elmObj(i).getroproperty("innertext")
															If  INSTR(strInnerText,strOrderNo)>0 Then
																blnMailRcvd=True
																Exit For
															End If				
														Next
														If blnMailRcvd Then
															Exit For
														End If
													End If
												Next
												If blnMailRcvd Then
														Exit For
												End If
											Next
										
											If blnMailRcvd Then
												strDesc ="VERIFYORDERCONFIRMATIONMAIL: Order confirmation mail successfully received for the Order # " & strOrderNo & "."
												clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
												Reporter.Filter = rfEnableAll 
												Reporter.ReportEvent micPass,"Step VERIFYORDERCONFIRMATIONMAIL", strDesc
												Reporter.Filter = rfDisableAll  
											Else
												strDesc ="VERIFYORDERCONFIRMATIONMAIL: Order confirmation mail was not received for the Order # " & strOrderNo & "."
												Reporter.Filter = rfEnableAll 
												Reporter.ReportEvent micFail,"Step VERIFYORDERCONFIRMATIONMAIL ", strDesc
												objEnvironmentVariables.TestCaseStatus=False 
												Reporter.Filter = rfDisableAll
												clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables				   	
												clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0	
											End If
										
												obj.Link("lnkSignout").Click
												Browser("brwGmail").Close
												WebUtil.deletecookies	
										
										End If

										Case "POPUPMESSAGE"
											'Ram 16-4-10- Pop up message
											Set WshShell =CreateObject("WScript.Shell")
											strInputValue=CINT(strInputValue)
											For i=strInputValue-1 to 0 step -1
												WshShell.Popup "Please wait for the popup to close. Popup will close autotomatically in " & i & " sec(s)",1,TRIM(strOptParam)
											Next
											Set WshShell=Nothing



					Case "VERIFYOBJECTPROPERTY"

								'Ram 26- 4-10- Used the verify a specific property of any given object

						If  Environment.Value("CurrentBrowser")<>"" Then
								If UCASE(Environment.Value("CurrentBrowser"))=UCASE(Environment.Value ("BrowserName")) Then

							strObjType=Trim(strOptParam)
							Select Case strObjType
								Case "WebElement"
									Set obj = objsub.WebElement(Object_Name)
								Case "WebEdit"
									Set obj = objsub.WebEdit(Object_Name)
								 Case "WebList"
									Set obj = objsub.WebList(Object_Name)
								 Case "Link"
									 Set obj = objsub.Link(Object_Name)
								 Case "WebCheckBox"
									Set obj = objsub.WebCheckBox(Object_Name)
								Case "WebButton"
									Set obj = objsub.WebButton(Object_Name)
								Case "WebTable"
									Set obj = objsub.WebTable(Object_Name)
								Case "WebRadioGroup"
									Set obj = objsub.WebRadioGroup(Object_Name)
								Case "Image"
									Set obj = objsub.Image(Object_Name)
							End Select

							'2. Check if the expected is true/false - True means FOCUSed ..False - NONFOCUS
							If UCase(Trim(strExpectedValue))="TRUE" OR UCase(Trim(strExpectedValue))="" then
								blnExpectdVal=True								
							Else
								blnExpectdVal=False
							End If

							'5. Incase index or any other property needs to be added like index in order to identify elements of teh same tyoe .
								If strTestDataReference<>"" Then
									If  UCASE(TRIM(strTestDataReference))<>"OPTIONAL"Then
											arrTDR=Split(strTestDataReference,"~")
											strProp=TRIM(arrTDR(0))
											strVal=TRIM(arrTDR(1))
											obj.SetToProperty strProp,strVal
									Else
										'Nothing as of now...!!
									End If
								End If

							'3 Split the proeprty and the expected value
								arrInputVal=Split(strInputValue,"~")
								strProperty=TRIM(arrInputVal(0))
								strExpValue=TRIM(arrInputVal(1))
								IsBlank=False
								IsNotBlank=False
								If UCASE(strExpValue)="BLANK" Then
									strExpValue=""
									IsBlank=True
								ElseIf UCASE(strExpValue)="NOTBLANK" Then
									IsNotBlank=True	
								End If

								'
							'4. Get the current value and compare value
								strCurrentValue=obj.GetROProperty(strProperty)
								blnPropertyMatch=False
								If  IsNotBlank Then
									If  strCurrentValue<>"" OR strCurrentValue=NOT(NULL) Then
										If  UCASE(TRIM(strProperty))="HREF" Then
											If  NOT(INSTR(strCurrentValue,"#")>0) OR NOT(INSTR(strCurrentValue,"void")>0)Then
												blnPropertyMatch=True
											End If
										Else
											'Other than HREF  - NOTBLANK
											blnPropertyMatch=True
										End If
									End If
								Else
									'If the not blank flag is not set, then in general mode
									If  strCurrentValue=strExpValue OR Instr(strCurrentValue,strExpValue)>0Then
										blnPropertyMatch=True
									End If
								End If

							'5.Report
							If  obj.Exist(5) Then
								obj.Highlight		

								If  IsBlank Then
									strExpValue="BLANK"
								End If

								If IsNotBlank Then
									strExpValue=strCurrentValue
								End If

								If blnPropertyMatch Then
									If blnExpectdVal then  'True Case 
										strDesc ="VERIFYOBJECTPROPERTY : The " & strObjType & " - " & chr(34) & Object_Name & chr(34) & " has the property " & chr(34) & UCASE(strProperty) & chr(34) & " as " & chr(34) & strExpValue & chr(34) & "."
										clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
										Reporter.Filter = rfEnableAll 
										Reporter.ReportEvent micPass,"Step VERIFYOBJECTPROPERTY", strDesc
										Reporter.Filter = rfDisableAll
									Else
										strDesc ="VERIFYOBJECTPROPERTY : The " & strObjType & " - " & chr(34) & Object_Name & chr(34) & " has the property " & chr(34) & UCASE(strProperty) & chr(34) & " as " & chr(34) & strExpValue & chr(34) & ", when it's not expected to be having it so."
										clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
										clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
										Reporter.Filter = rfEnableAll 
										Reporter.ReportEvent micFail,"Step VERIFYOBJECTPROPERTY", strDesc
										objEnvironmentVariables.TestCaseStatus=False
										Reporter.Filter = rfDisableAll
									End If
								Else
									If blnExpectdVal then	''true
										strDesc ="VERIFYOBJECTPROPERTY : The " & strObjType & " - " & chr(34) & Object_Name & chr(34) & " does NOT have the property " & chr(34) & UCASE(strProperty) & chr(34) & " as " & chr(34) & strExpValue & chr(34) & ".The actual value is " & chr(34) & strCurrentValue & chr(34) & "."
										Reporter.Filter = rfEnableAll 
										Reporter.ReportEvent micFail,"Step VERIFYOBJECTPROPERTY", strDesc
										objEnvironmentVariables.TestCaseStatus=False
										Reporter.Filter = rfDisableAll
										clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
										clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0										
									Else
										strDesc ="VERIFYOBJECTPROPERTY : The " & strObjType & " - " & chr(34) & Object_Name & chr(34) & " does NOT have the property " & chr(34) & UCASE(strProperty) & chr(34) & " as " & chr(34) & strExpValue & chr(34) & ", as expected."
										Reporter.Filter = rfEnableAll 
										Reporter.ReportEvent micPass,"Step VERIFYOBJECTPROPERTY", strDesc
										Reporter.Filter = rfDisableAll
										clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1									
									End If						 
								End If

							Else
									strDesc="VERIFYOBJECTPROPERTY: The " & strObjType & " - " & chr(34) & Object_Name & chr(34) & " doesn't exist, so cannot proceed with object's property validation."
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micFail,"Step VERIFYOBJECTPROPERTY", strDesc
									objEnvironmentVariables.TestCaseStatus=False
									Reporter.Filter = rfDisableAll 
							End If
						  End If
						  'General Case for all types ..
						  '********************************
						 Else
							strObjType=Trim(strOptParam)
							Select Case strObjType
								Case "WebElement"
									Set obj = objsub.WebElement(Object_Name)
								Case "WebEdit"
									Set obj = objsub.WebEdit(Object_Name)
								 Case "WebList"
									Set obj = objsub.WebList(Object_Name)
								 Case "Link"
									 Set obj = objsub.Link(Object_Name)
								 Case "WebCheckBox"
									Set obj = objsub.WebCheckBox(Object_Name)
								Case "WebButton"
									Set obj = objsub.WebButton(Object_Name)
								Case "WebTable"
									Set obj = objsub.WebTable(Object_Name)
								Case "WebRadioGroup"
									Set obj = objsub.WebRadioGroup(Object_Name)
								Case "Image"
									Set obj = objsub.Image(Object_Name)
							End Select

							'2. Check if the expected is true/false - True means FOCUSed ..False - NONFOCUS
							If UCase(Trim(strExpectedValue))="TRUE" OR UCase(Trim(strExpectedValue))="" then
								blnExpectdVal=True								
							Else
								blnExpectdVal=False
							End If

							'5. Incase index or any other property needs to be added like index in order to identify elements of teh same tyoe .
								If strTestDataReference<>"" Then
									If  UCASE(TRIM(strTestDataReference))<>"OPTIONAL"Then
											arrTDR=Split(strTestDataReference,"~")
											strProp=TRIM(arrTDR(0))
											strVal=TRIM(arrTDR(1))
											obj.SetToProperty strProp,strVal
									Else
										'Nothing as of now...!!
									End If
								End If

							'3 Split the proeprty and the expected value
								arrInputVal=Split(strInputValue,"~")
								strProperty=TRIM(arrInputVal(0))
								strExpValue=TRIM(arrInputVal(1))
								IsBlank=False
								IsNotBlank=False
								If UCASE(strExpValue)="BLANK" Then
									strExpValue=""
									IsBlank=True
								ElseIf UCASE(strExpValue)="NOTBLANK" Then
									IsNotBlank=True	
								End If

							'4. Get the current value and compare value
								strCurrentValue=obj.GetROProperty(strProperty)
								blnPropertyMatch=False
								If  IsNotBlank Then
									If  strCurrentValue<>"" OR strCurrentValue=NOT(NULL) Then
										If  UCASE(TRIM(strProperty))="HREF" Then
											If  NOT(INSTR(strCurrentValue,"#")>0) OR NOT(INSTR(strCurrentValue,"void")>0)Then
												blnPropertyMatch=True
											End If
										Else
											'Other than HREF  - NOTBLANK
											blnPropertyMatch=True
										End If
									End If
								Else
									'If the not blank flag is not set, then in general mode
									If  strCurrentValue=strExpValue OR Instr(strCurrentValue,strExpValue)>0Then
										blnPropertyMatch=True
									End If
								End If




							'5.Report
							If  obj.Exist(5) Then
								obj.Highlight			

								If  IsBlank Then
									strExpValue="BLANK"
								End If			

							If IsNotBlank Then
									strExpValue=strCurrentValue
								End If	

								If blnPropertyMatch Then
									If blnExpectdVal then  'True Case 
										strDesc ="VERIFYOBJECTPROPERTY : The " & strObjType & " - " & chr(34) & Object_Name & chr(34) & " has the property " & chr(34) & UCASE(strProperty) & chr(34) & " as " & chr(34) & strExpValue & chr(34) & "."
										clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
										Reporter.Filter = rfEnableAll 
										Reporter.ReportEvent micPass,"Step VERIFYOBJECTPROPERTY", strDesc
										Reporter.Filter = rfDisableAll
									Else
										strDesc ="VERIFYOBJECTPROPERTY : The " & strObjType & " - " & chr(34) & Object_Name & chr(34) & " has the property " & chr(34) & UCASE(strProperty) & chr(34) & " as " & chr(34) & strExpValue & chr(34) & ", when it's not expected to be having it so."
										clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
										clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
										Reporter.Filter = rfEnableAll 
										Reporter.ReportEvent micFail,"Step VERIFYOBJECTPROPERTY", strDesc
										objEnvironmentVariables.TestCaseStatus=False
										Reporter.Filter = rfDisableAll
									End If
								Else
									If blnExpectdVal then	''true
										strDesc ="VERIFYOBJECTPROPERTY : The " & strObjType & " - " & chr(34) & Object_Name & chr(34) & " does NOT have the property " & chr(34) & UCASE(strProperty) & chr(34) & " as " & chr(34) & strExpValue & chr(34) & ".The actual value is " & chr(34) & strCurrentValue & chr(34) & "."
										Reporter.Filter = rfEnableAll 
										Reporter.ReportEvent micFail,"Step VERIFYOBJECTPROPERTY", strDesc
										objEnvironmentVariables.TestCaseStatus=False
										Reporter.Filter = rfDisableAll
										clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
										clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0										
									Else
										strDesc ="VERIFYOBJECTPROPERTY : The " & strObjType & " - " & chr(34) & Object_Name & chr(34) & " does NOT have the property " & chr(34) & UCASE(strProperty) & chr(34) & " as " & chr(34) & strExpValue & chr(34) & ", as expected."
										Reporter.Filter = rfEnableAll 
										Reporter.ReportEvent micPass,"Step VERIFYOBJECTPROPERTY", strDesc
										Reporter.Filter = rfDisableAll
										clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1									
									End If						 
								End If

							Else
									strDesc="VERIFYOBJECTPROPERTY: The " & strObjType & " - " & chr(34) & Object_Name & chr(34) & " doesn't exist, so cannot proceed with object's property validation."
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micFail,"Step VERIFYOBJECTPROPERTY", strDesc
									objEnvironmentVariables.TestCaseStatus=False
									Reporter.Filter = rfDisableAll 
							End If
						End if


							Case "SETBROWSERVERSION"
								'Ram -5-5-10 - tSet the browser version: as IE or FF
							
								'Set the browser version:
								'FF
								'****
								isSetBrwFlag=False

								If Environment.Value ("BrowserName") = "Firefox" Then
									strVersion=".*Firefox.*"



									If  Object_Name<>"" Then
										'Check for page
										'******************
										arrObj_Name=Split(Object_Name,":")
										strBrwName=Trim(arrObj_Name(0))
										strPgeTitle=Trim(arrObj_Name(1))
										Browser(strBrwName).SetTOProperty "version",strVersion
								
										If  strInputValue<>"" Then
											strInputValue=TRIM(strInputValue)
											Browser(strBrwName).SetTOProperty "name",strInputValue
											Browser(strBrwName).Page(strPgeTitle).SetTOProperty "title",strInputValue
											isSetBrwFlag=True
										Else
											If  UCASE(TRIM(strOptParam))="BLANK" Then
												Browser(strBrwName).SetTOProperty "name",".*"
												Browser(strBrwName).Page(strPgeTitle).SetTOProperty "title",".*"
												isSetBrwFlag=True
											Else
                                                Browser(strBrwName).SetTOProperty "name",strTitle
												Browser(strBrwName).Page(strPgeTitle).SetTOProperty "title",strTitle
											End If											
										End If
										'Browser(strBrwName).Highlight
									'General Browser
									Else
										Browser("brwGeneral").SetTOProperty "version",strVersion
												 ' ' '''''msgbox strInputValue
										If  strInputValue<>"" Then
											strInputValue=TRIM(strInputValue)
											Browser("brwGeneral").SetTOProperty "name",strInputValue
											Browser("brwGeneral").Page("pgeGeneral").SetTOProperty "title",strInputValue
											isSetBrwFlag=True
										Else
											If  UCASE(TRIM(strOptParam))="BLANK" Then
												Browser("brwGeneral").SetTOProperty "name",".*"
												Browser("brwGeneral").Page("pgeGeneral").SetTOProperty "title",".*"
												isSetBrwFlag=True
											Else
												Browser("brwGeneral").SetTOProperty "name",strTitle
												Browser("brwGeneral").Page("pgeGeneral").SetTOProperty "title",strTitle
											End If											
										End If
										'Browser("brwGeneral").Highlight
									End If		

									'End of FF							
								Else	
								'	IE
								'*****
									strVersion=".*internet.*"
'									If  Object_Name<>"" Then
'										Browser(Object_Name).SetTOProperty "version",strVersion
'										If  strInputValue<>"" Then
'											strInputValue=TRIM(strInputValue)
'											Browser(Object_Name).SetTOProperty "name",strInputValue
'										Else
'											If  UCASE(TRIM(strOptParam))="BLANK" Then
'												Browser(Object_Name).SetTOProperty "name",".*"
'											Else
'												Browser(Object_Name).SetTOProperty "name",strTitle
'											End If											
'										End If
'                                        'Browser(Object_Name).Highlight
'									Else
'										Browser("brwGeneral").SetTOProperty "version",strVersion
'										If  strInputValue<>"" Then
'											strInputValue=TRIM(strInputValue)
'											Browser("brwGeneral").SetTOProperty "name",strInputValue
'										Else
'											If  UCASE(TRIM(strTestDataReference))="BLANK" Then
'												Browser("brwGeneral").SetTOProperty "name",".*"
'											Else
'												Browser("brwGeneral").SetTOProperty "name",strTitle
'											End If							
'										End If
'										'Browser("brwGeneral").Highlight
'									End If	



														If  Object_Name<>"" Then
																'Check for page
																'******************
																arrObj_Name=Split(Object_Name,":")
																strBrwName=Trim(arrObj_Name(0))
																strPgeTitle=Trim(arrObj_Name(1))
																Browser(strBrwName).SetTOProperty "version",strVersion
																If  strInputValue<>"" Then
																	strInputValue=TRIM(strInputValue)
																	Browser(strBrwName).SetTOProperty "name",strInputValue
																	Browser(strBrwName).Page(strPgeTitle).SetTOProperty "title",strInputValue
																	isSetBrwFlag=True
																Else
																	If  UCASE(TRIM(strOptParam))="BLANK" Then
																		Browser(strBrwName).SetTOProperty "name",".*"
																		Browser(strBrwName).Page(strPgeTitle).SetTOProperty "title",".*"
																		isSetBrwFlag=True
																	Else
																		Browser(strBrwName).SetTOProperty "name",strTitle
																		Browser(strBrwName).Page(strPgeTitle).SetTOProperty "title",strTitle
																		
																	End If											
																End If
																'Browser(strBrwName).Highlight
															'General Browser
															Else
																Browser("brwGeneral").SetTOProperty "version",strVersion
																If  strInputValue<>"" Then
																	strInputValue=TRIM(strInputValue)
																	Browser("brwGeneral").SetTOProperty "name",strInputValue
																	Browser("brwGeneral").Page("pgeGeneral").SetTOProperty "title",strInputValue
																	isSetBrwFlag=True
																Else
																	If  UCASE(TRIM(strOptParam))="BLANK" Then
																		Browser("brwGeneral").SetTOProperty "name",".*"
																		Browser("brwGeneral").Page("pgeGeneral").SetTOProperty "title",".*"
																		isSetBrwFlag=True
																	Else
																		Browser("brwGeneral").SetTOProperty "name",strTitle
																		Browser("brwGeneral").Page("pgeGeneral").SetTOProperty "title",strTitle
																	End If											
																End If
																'Browser("brwGeneral").Highlight
															End If		
								End If							

								strDesc=  "</br><b><i><font size=2>" & "SETBROWSERVERSION - The browser version is set to " & chr(34) & UCASE(Environment.Value ("BrowserName")) & chr(34) & "." & "</b></i></font>"
								clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
								Reporter.Filter = rfEnableAll 
								Reporter.ReportEvent micDone,"", strDesc
								Reporter.Filter = rfDisableAll   

						 Case "SETBROWSERFLAG"
							 'Ram -5-5-10 - to set the curent browser flag
							strInputValue=TRIM(strInputValue)
							Environment.Value("CurrentBrowser")=TRIM(UCASE(strInputValue))



						Case "VERIFYMULTIPLEELEMENTS"
							'Ram 5-7-10 
							'*************
							'Allows one to verify mutiple elements with same html tag or different html tag. The html tags have to be passed in the corresponding order in which the i/p is passed
							'This can verify values stricly based on the i/p or based on the Testdatareference value passed, Eg: a case called "EITHER" will check if atleast any one among the specified values are present or not
							'Value is coming from Excel sheet in the form of an array, seperated by "~" and Index seperated by "_", corresponfing HTML tag wil come from the optparam seperated by ":"
							'Since we are validating mutiple elements in this case only elmGeneral has to be used.

							strAllElements=""
							If Object_Name<>"elmGeneral" OR Object_Name<>"elmgeneral"Then

'								If ModuleName="Keds" Then
'									Browser("brwMain").SetTOProperty "name" , ".*Keds.*"
'									Browser("brwMain").Page("pgeGeneral").SetTOProperty "title" , ".*Keds.*"   
'								End If
								Set objsub=Browser("brwMain").Page("pgeGeneral")
								Set obj=objsub.WebElement("elmGeneral")
							Else
								Set obj = objsub.WebElement(Object_Name)
							End If		
							

							'1. Get the HTML Tag values from the opt param. There should be same amounf html tag like that of the i/p values
							'***********************************************************************************************************************************
							arrHTMLTags=Split(Trim(strOptParam),"~")

							'2.In case only either of the i/p value exists and it's Ok if any one is pass
							'**********************************************************************************
							blnEither=False
							IsEitherFlag="No"
							If UCASE(TRIM(strTestDataReference))="EITHER" Then
								blnEither=True
							End If
                            
							'3. Get the value from strInputValue and split with "~"
							'************************************************************
							arrInputValue=Split(strInputValue,"~")
							For arrCount=0 to UBOUND(arrInputValue)
								isEnvValue=False
								arrValue=arrInputValue(arrCount)



								'A). Split the value again to get the value and index
								strInpVal=Split(arrValue,"_")
                                
							'A.-1. Get the innertext / index of the element to be searched
								'*******************************************************************
								'### Check if this is coming directly as a blunt value or from some Env value
			
								If  UBOUND(strInpVal)>0 Then

									isEnvValue=Split(strInpVal(0),"ENV:")
									If  UBOUND(isEnvValue)>0 Then
											strElmValue=Environment.Value(Trim(isEnvValue(1)))
		
						
									Else
										strElmValue=Trim(strInpVal(0))
									End If	
									strIndex=TRIM(strInpVal(1))
									
'									If  Environment(Trim(strInpVal(0))).Value<>"" Then
'
'										On Error Resume Next
'										If Err.Number <> 0 Then
'											blnEnvVarExists = False
'										Else
'											blnEnvVarExists = True
'											strEnvVal=Environment.Value(Trim(strInpVal(0)))
'										End If
'										On Error GoTo 0
'										If blnEnvVarExists AND strEnvVal<>"" Then
'											strElmValue=Environment.Value(Trim(strInpVal(0)))
'											isEnvValue=True
'										Else
'											strElmValue=Trim(strInpVal(0))
'										End If
'										Err.Clear()
'									Else
'										strElmValue=Trim(strInpVal(0))
'									End If	
'									strIndex=TRIM(strInpVal(1))
								Else
									'Without the  index being specified
									'***************************************
									 'Checking for env variable
									isEnvValue=Split(arrValue,"ENV:")
									If  UBOUND(isEnvValue)>0 Then
											strElmValue=Environment.Value(Trim(isEnvValue(1)))
			
									Else
											strElmValue=Trim(arrValue)
									End If	
									strIndex="0"
	
'								If  Environment(Trim(arrValue)).Value <>"" Then
'
'										On Error Resume Next
'										If Err.Number <> 0 Then
'											blnEnvVarExists = False
'
'										Else
'											blnEnvVarExists = True
'											strEnvVal=Environment.Value(Trim(arrValue))
'
'										End If
'										On Error GoTo 0
'										If blnEnvVarExists AND strEnvVal<>"" Then
'											strElmValue=Environment.Value(Trim(arrValue))
'											isEnvValue=True
'
'										Else
'											strElmValue=Trim(arrValue)
'											'''''''''''msgbox strElmValue
'										End If
'										Err.Clear()
'									Else
'										strElmValue=Trim(arrValue)
'									End If	
'									strIndex="0"
								End If  

								'A-3. Get the corresponding HTMLTag
								'********************************************
								strHtmlTag=arrHTMLTags(arrCount)
								''''''''''''''''''msgbox strHtmlTag

								'A - 4 - Search for the matching element value in the entire page
								'*************************************************************************

								'*** Set the properties ****
								obj.SetTOProperty "innertext",""
								obj.SetTOProperty "html tag",""
								Set desc=Description.Create
								desc("micClass").Value="WebElement"
								desc("html tag").Value=strHtmlTag

											
								'**** Search for the matching value*****
								Set elmObj=objsub.ChildObjects(desc)
								For i=0 to elmObj.count-1
									strActualElmValue=elmObj(i).getroproperty("innertext")
									

									If INSTR(strActualElmValue,strElmValue) Then
										obj.SetTOProperty "innertext",strActualElmValue
										obj.SetTOProperty "html tag",strHtmlTag
										obj.setTOProperty "index",strIndex

										Exit For													
									End If													
								Next

								'4. Reporting
								'**************
								If obj.Exist(4) Then
									blnVerifyRes = True 
									obj.Highlight		
									If blnEither Then
										IsEitherFlag="Yes"
									End If
								Else
									blnVerifyRes = False 
								End If

								If strExpectedValue = "" OR strExpectedValue = "TRUE" Then
									blnExpectedValue = True 
								Else
									blnExpectedValue = False 
								End If

								If blnVerifyRes Then
									If blnExpectedValue Then ''expected true 	
										strDesc ="VERIFYMULTIPLEELEMENTS: The element " & chr(34) & strActualElmValue & chr(34) & " exists."
										clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
										Reporter.Filter = rfEnableAll 
										Reporter.ReportEvent micPass,"Step VERIFYMULTIPLEELEMENTS", strDesc
										Reporter.Filter = rfDisableAll
									Else  ''expected false	
										strDesc =strpartdesc &" at the row number " & chr(34) & iRowCnt+1 & chr(34) & " the element " & chr(34) & strActualElmValue & chr(34) &" exists, which is not expected."
										Reporter.Filter = rfEnableAll 
										Reporter.ReportEvent micFail,"Step VERIFYMULTIPLEELEMENTS", strDesc
										Reporter.Filter = rfDisableAll
										objEnvironmentVariables.TestCaseStatus=False
										clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1 & strLabel,objEnvironmentVariables
										clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
									End If							
								Else
									If blnExpectedValue then	'expected true 
										If blnEither<>True Then ' In this case , skip the reporting part and go to next element
												strDesc = strpartdesc&" at the row number "& chr(34) & iRowCnt+1& chr(34) & " the element "& chr(34) & strElmValue & chr(34) & " does not exist."
												Reporter.Filter = rfEnableAll 
												Reporter.ReportEvent micFail,"Step VERIFYMULTIPLEELEMENTS", strDesc									
												Reporter.Filter = rfDisableAll		
												objEnvironmentVariables.TestCaseStatus=False
												clsScreenShot.Snap_Shots objsub , Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
												clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0			
										End If
													
									Else  ''expected false 
										strDesc = "VERIFYMULTIPLEELEMENTS: The element "& chr(34) & strElmValue & chr(34) & " does not exist as expected."						
										Reporter.Filter = rfEnableAll 
										Reporter.ReportEvent micPass,"Step VERIFYMULTIPLEELEMENTS", strDesc
										Reporter.Filter = rfDisableAll
										clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1	
									End If							 
								End If

								'A-5 - Collect all the elements
								'*********************************
								strAllElements=strAllElements & " - " & strElmValue
								strAllElements=TRIM(RIGHT(strAllElements,(LEN(strAllElements)-1)))



							Next
							

							'5. Final reporting in case none of the elements appear when the condition is EITHER
							'***************************************************************************************************
							If blnEither AND IsEitherFlag="No" Then
									strDesc = "<b><font size=2 color=RED> VERIFYMULTIPLEELEMENTS - None of the following elements are displayed on the page : " & chr(34) & "<i><font size=2 color=BLACK>" & strAllElements & "</i></font>" & chr(34) & ".</b></font>"
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micFail,"Step VERIFYMULTIPLEELEMENTS", strDesc									
									Reporter.Filter = rfDisableAll		
									objEnvironmentVariables.TestCaseStatus=False
									clsScreenShot.Snap_Shots objsub , Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0			
							End If

						Case "VERIFYDIALOGEXISTS"
							'Ram 5-14-10 - To check for presence of Dialog box
									blnOptn=False
									If  Environment.Value("CurrentBrowser")<>"" Then
											If UCASE(Environment.Value("CurrentBrowser"))=UCASE(Environment.Value ("BrowserName")) Then
													strTitleName= objsub.GetROProperty("regexpwndtitle") 
													If objsub.Exist(5) Then								
															blnVerifyRes = True 
															objsub.Highlight
													Else									
															blnVerifyRes = False 
													End If
													
													If strExpectedValue = "" OR strExpectedValue = "TRUE" Then
														blnExpectedValue = True 
													Else
														blnExpectedValue = False 
													End If 

													
													If blnExpectedValue Then ' when expected is true 
														If blnVerifyRes Then  '' Dialog Exist , Pass 									
															strDesc = "VERIFYDIALOGEXISTS: Dialog with title" & chr(34) & strTitleName & chr(34) & " exists."
															clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1													
															Reporter.Filter = rfEnableAll 
															Reporter.ReportEvent micPass,"Step VERIFYDIALOGEXISTS ", strDesc							 
															Reporter.Filter = rfDisableAll	
															
														Else  '' Dialog not Exist , Fail			
														'	If NOT(blnOptn) Then
																strDesc = strpartdesc&" at the row number "&iRowCnt+1&" the dialog " & chr(34) & strLabel & chr(34) & " does not exists."													
																Reporter.Filter = rfEnableAll 
																Reporter.ReportEvent micFail,"Step VERIFYDIALOGEXISTS ", strDesc
																objEnvironmentVariables.TestCaseStatus=False 
																Reporter.Filter = rfDisableAll
																clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables				   	
																clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
														'	End If

														End If
													Else ''when expected is false 
														If blnVerifyRes Then  '' Dialog Exist , Fail 									
															'objsub.Object.focus  ''Not Required 
														'	If NOT(blnOptn) Then
																strDesc = strpartdesc&" at the row number "&iRowCnt+1&" the dialog " & chr(34) & strLabel & chr(34) & " exists, when it's not expected."													
																Reporter.Filter = rfEnableAll 
																Reporter.ReportEvent micFail,"Step VERIFYDIALOGEXISTS ", strDesc
																objEnvironmentVariables.TestCaseStatus=False 
																Reporter.Filter = rfDisableAll
																clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables				   	
																clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
														'	End If
														Else  '' Page not Exist , Pass 								
															strDesc = "VERIFYDIALOGEXISTS: Dialog " & chr(34) & strLabel & chr(34) & " does not exist as expected."
															clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1													
															Reporter.Filter = rfEnableAll 
															Reporter.ReportEvent micPass,"Step VERIFYDIALOGEXISTS ", strDesc							 
															Reporter.Filter = rfDisableAll
														End If
													End If 
											  End If
										'In normal Case
										Else
												strTitleName= objsub.GetROProperty("regexpwndtitle") 
												If objsub.Exist(5) Then								
														blnVerifyRes = True 
														objsub.Highlight
												Else									
														blnVerifyRes = False 
												End If
												
												If strExpectedValue = "" OR strExpectedValue = "TRUE" Then
													blnExpectedValue = True 
												Else
													blnExpectedValue = False 
												End If 
					
												If blnExpectedValue Then ' when expected is true 
													If blnVerifyRes Then  '' Dialog Exist , Pass 									
														strDesc = "VERIFYDIALOGEXISTS: Dialog with title" & chr(34) & strTitleName & chr(34) & " exists."
														clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1													
														Reporter.Filter = rfEnableAll 
														Reporter.ReportEvent micPass,"Step VERIFYDIALOGEXISTS ", strDesc							 
														Reporter.Filter = rfDisableAll	
														
													Else  '' Dialog not Exist , Fail								
														strDesc = strpartdesc&" at the row number "&iRowCnt+1&" the dialog " & chr(34) & strLabel & chr(34) & " does not exists."													
														Reporter.Filter = rfEnableAll 
														Reporter.ReportEvent micFail,"Step VERIFYDIALOGEXISTS ", strDesc
														objEnvironmentVariables.TestCaseStatus=False 
														Reporter.Filter = rfDisableAll
														clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables				   	
														clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
													End If
												Else ''when expected is false 
													If blnVerifyRes Then  '' Dialog Exist , Fail 									
														'objsub.Object.focus  ''Not Required 
														strDesc = strpartdesc&" at the row number "&iRowCnt+1&" the dialog " & chr(34) & strLabel & chr(34) & " exists, when it's not expected."													
														Reporter.Filter = rfEnableAll 
														Reporter.ReportEvent micFail,"Step VERIFYDIALOGEXISTS ", strDesc
														objEnvironmentVariables.TestCaseStatus=False 
														Reporter.Filter = rfDisableAll
														clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables				   	
														clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
													Else  '' Page not Exist , Pass 								
														strDesc = "VERIFYDIALOGEXISTS: Dialog " & chr(34) & strLabel & chr(34) & " does not exist as expected."
														clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1													
														Reporter.Filter = rfEnableAll 
														Reporter.ReportEvent micPass,"Step VERIFYDIALOGEXISTS ", strDesc							 
														Reporter.Filter = rfDisableAll
													End If
												End If 
							End If

						Case "VERIFYSTATICTEXTEXISTS"
													'Ram 5-14-2010
					If  Environment.Value("CurrentBrowser")<>"" Then
						If UCASE(Environment.Value("CurrentBrowser"))=UCASE(Environment.Value ("BrowserName")) Then

							set obj=objsub.Static(Object_Name)

							'Set the text value incase the object is general
							If strInputValue <> ""  Then
								strInputValue=TRIM(strInputValue)
								obj.SetTOProperty "text",strInputValue
							End If

							If objsub.Exist(5) Then								
									blnVerifyRes = True 
									objsub.Highlight
							Else									
									blnVerifyRes = False 
							End If
							
							If strExpectedValue = "" OR strExpectedValue = "TRUE" Then
								blnExpectedValue = True 
							Else
								blnExpectedValue = False 
							End If 

							If blnExpectedValue Then ' when expected is true 
								If blnVerifyRes Then  '' Dialog Exist , Pass 									
									strDesc = "VERIFYSTATICTEXTEXISTS: Static Text with value" & chr(34) & strInputValue & chr(34) & " exists."
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1													
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micPass,"Step VERIFYSTATICTEXTEXISTS ", strDesc							 
									Reporter.Filter = rfDisableAll	
									
								Else  '' Dialog not Exist , Fail								
									strDesc = strpartdesc&" at the row number "&iRowCnt+1&" the Static Text with value  " & chr(34) & strInputValue & chr(34) & " does not exists."													
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micFail,"Step VERIFYSTATICTEXTEXISTS ", strDesc
									objEnvironmentVariables.TestCaseStatus=False 
									Reporter.Filter = rfDisableAll
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables				   	
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
								End If
							Else ''when expected is false 
								If blnVerifyRes Then  '' Dialog Exist , Fail 									
									'objsub.Object.focus  ''Not Required 
									strDesc = strpartdesc&" at the row number "&iRowCnt+1&" the Static Text with value " & chr(34) & strInputValue & chr(34) & " exists, when it's not expected."													
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micFail,"Step VERIFYSTATICTEXTEXISTS ", strDesc
									objEnvironmentVariables.TestCaseStatus=False 
									Reporter.Filter = rfDisableAll
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables				   	
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
								Else  '' Page not Exist , Pass 								
									strDesc = "VERIFYSTATICTEXTEXISTS: Static Text with value" & chr(34) & strInputValue & chr(34) & " doesn't exists as expected."
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1													
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micPass,"Step VERIFYSTATICTEXTEXISTS ", strDesc							 
									Reporter.Filter = rfDisableAll
								End If
							End If 
						  End if
					Else
						set obj=objsub.Static(Object_Name)

							'Set the text value incase the object is general
							If strInputValue <> ""  Then
								strInputValue=TRIM(strInputValue)
								obj.SetTOProperty "text",strInputValue
							End If

							If objsub.Exist(5) Then								
									blnVerifyRes = True 
									objsub.Highlight
							Else									
									blnVerifyRes = False 
							End If
							
							If strExpectedValue = "" OR strExpectedValue = "TRUE" Then
								blnExpectedValue = True 
							Else
								blnExpectedValue = False 
							End If 

							If blnExpectedValue Then ' when expected is true 
								If blnVerifyRes Then  '' Dialog Exist , Pass 									
									strDesc = "VERIFYSTATICTEXTEXISTS: Static Text with value" & chr(34) & strInputValue & chr(34) & " exists."
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1													
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micPass,"Step VERIFYSTATICTEXTEXISTS ", strDesc							 
									Reporter.Filter = rfDisableAll	
									
								Else  '' Dialog not Exist , Fail								
									strDesc = strpartdesc&" at the row number "&iRowCnt+1&" the Static Text with value  " & chr(34) & strInputValue & chr(34) & " does not exists."													
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micFail,"Step VERIFYSTATICTEXTEXISTS ", strDesc
									objEnvironmentVariables.TestCaseStatus=False 
									Reporter.Filter = rfDisableAll
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables				   	
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
								End If
							Else ''when expected is false 
								If blnVerifyRes Then  '' Dialog Exist , Fail 									
									'objsub.Object.focus  ''Not Required 
									strDesc = strpartdesc&" at the row number "&iRowCnt+1&" the Static Text with value " & chr(34) & strInputValue & chr(34) & " exists, when it's not expected."													
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micFail,"Step VERIFYSTATICTEXTEXISTS ", strDesc
									objEnvironmentVariables.TestCaseStatus=False 
									Reporter.Filter = rfDisableAll
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables				   	
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
								Else  '' Page not Exist , Pass 								
									strDesc = "VERIFYSTATICTEXTEXISTS: Static Text with value" & chr(34) & strInputValue & chr(34) & " doesn't exists as expected."
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1													
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micPass,"Step VERIFYSTATICTEXTEXISTS ", strDesc							 
									Reporter.Filter = rfDisableAll
								End If
							End If 
					End If




				   Case "WEBELEMENTCLICK" 


                                                                   If  Environment.Value("CurrentBrowser")<>"" Then
                                                                                                If UCASE(Environment.Value("CurrentBrowser"))=UCASE(Environment.Value ("BrowserName")) Then
                                                                   Set obj = objsub.WebElement(Object_Name)                                                                                             
                                                                      
                                                                   
                                                                   'Giving the name and index ..!!!
                                                                                                          If Trim(strInputValue) <> "" Then 
                                                                                                                   'added by Gov' 13-5-10 inorder to define index as well, in case one or more objects of the same name exists, so adding code to change index @ runtime as well
                                                                                                                    strArrayInputValue=Split(strInputValue,":")
                                                                                                                   If UBOUND(strArrayInputValue)>0 Then
                                                                                                                   'Setting the text to the value being specified in array (0)
                                                                                                                   If strArrayInputValue(0)<>"" Then
                                                                                                                             obj.setTOProperty "innertext",strArrayInputValue(0)                
                                                                                                                             strLabel = strArrayInputValue(0)
                                                                                                                   End If
                   
                                                                                                          'Setting the index to the value being specified in array (1)
                                                                                                                             obj.setTOProperty "index",strArrayInputValue(1)       
                                                                                                                  
                                                                                                                   Else
                                    
                                                                                                                   obj.setTOProperty "innertext",strInputValue      
                                                                                                                   strLabel = TRIM(strInputValue)
                                                                                                                   End If
                                                                                                          End If

                                                                   If strOptParam<>""  Then
                                                                                      obj.setTOProperty "html tag",TRim(strOptParam)      
                                                                   End If
                                                
                                                                   If  UCase ( strTestDataReference) = "OPTIONAL"  Then             

                                                                                      If blnOptional =CBool("TRUE")  And  obj.Exist(1)  Then
                                                                                                          obj.Highlight
                                                                                                          obj.Click
                                                                                                                  
                                                                                                          strDesc="WEBELEMENTCLICK: action on "& Chr(34) & strLabel & Chr(34) &" successfully performed."
                                                                                                          Reporter.Filter = rfEnableAll
                                                                                                          Reporter.ReportEvent micdone,"Step WEBELEMENTCLICK", " The WebElement "& Chr(34) & strLabel & Chr(34) &" has been clicked." 
                                                                                                          Reporter.Filter = rfDisableAll                                                                                                                             
                                                                                                          clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2
                                                                                      End If
                                                                   Else                                 
                                                                                      If obj.Exist(5) Then   
                                                                                                          obj.Highlight
                                                                                                          obj.Click                  
                                                                                                              
                                                                                                          strDesc="WEBELEMENTCLICK: action on "& Chr(34) & strLabel & Chr(34) &" successfully performed."
                                                                                                          Reporter.Filter = rfEnableAll
                                                                                                          Reporter.ReportEvent micdone,"Step WEBELEMENTCLICK", " The WebElement "& Chr(34) & strLabel & Chr(34) &" has been clicked." 
                                                                                                          Reporter.Filter = rfDisableAll                                                                                                                             
                                                                                                          clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2
                                                                                      Else
                                                     
                                                                                                          strDesc=strpartdesc&" at the row number "& Chr(34) & iRowCnt+1 & Chr(34) &" link "& Chr(34) & strLabel & Chr(34) &" not Exist."
                                                                                                          Reporter.Filter = rfEnableAll
                                                                                                          Reporter.ReportEvent micdone,"Step WEBELEMENTCLICK", " The WebElement "& Chr(34) & strLabel & Chr(34) &" no Exist." 
                                                                                                          Reporter.Filter = rfDisableAll          
                                                                                                          objEnvironmentVariables.TestCaseStatus=False 
                                                                                                          clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
                                                                                                          clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0                                                                                                                                                          
                                                                                      End If                                                            
                                                                   End If
                                                                                                                                                                                                                                End  If
                                                                                                                                                                                                                  Else
                                                                                                                                                                                                                                   Set obj = objsub.WebElement(Object_Name)                                                                                             
                                                                     
                                                                   
                                                                   'Giving the name and index ..!!!
                                                                                                          If Trim(strInputValue) <> "" Then 
                                                                                                                   'added by Gov' 13-5-10 inorder to define index as well, in case one or more objects of the same name exists, so adding code to change index @ runtime as well
                                                                                                                    strArrayInputValue=Split(strInputValue,":")
                                                                                                                   If UBOUND(strArrayInputValue)>0 Then
                                                                                                                   'Setting the text to the value being specified in array (0)
                                                                                                                   If strArrayInputValue(0)<>"" Then
                                                                                                                             obj.setTOProperty "innertext",strArrayInputValue(0)                
                                                                                                                             strLabel = strArrayInputValue(0)
                                                                                                                   End If
                   
                                                                                                          'Setting the index to the value being specified in array (1)
                                                                                                                             obj.setTOProperty "index",strArrayInputValue(1)       
                                                                                                                                                                     
                                                                                                                   Else
                                 
                                                                                                                   obj.setTOProperty "innertext",strInputValue      
                                                                                                                   strLabel = TRIM(strInputValue)
                                                                                                                   End If
                                                                                                          End If

                                                                   If strOptParam<>""  Then
                                                                                      obj.setTOProperty "html tag",TRim(strOptParam)      
                                                                   End If
                                                
                                                                   If  UCase ( strTestDataReference) = "OPTIONAL"  Then             

                                                                                      If blnOptional =CBool("TRUE")  And  obj.Exist(1)  Then
                                                                                                          obj.Highlight
																																						If  UCASE(Environment.Value ("BrowserName"))="IE" Then
obj.Click                  
																																										ElseIf UCASE(Environment.Value ("BrowserName"))="FIREFOX" Then
																																														Set objDeviceReplay = CreateObject ("Mercury.DeviceReplay")
																																														absx = obj.GetROProperty("abs_x")
																																														absy = obj.GetROProperty("abs_y")
																																														objDeviceReplay.MouseMove absx, absy
																																														objDeviceReplay.MouseClick absx, absy,LEFT_MOUSE_BUTTON
																																										End If
                                                                                                                             
                                                                                                          strDesc="WEBELEMENTCLICK: action on "& Chr(34) & strLabel & Chr(34) &" successfully performed."
                                                                                                          Reporter.Filter = rfEnableAll
                                                                                                          Reporter.ReportEvent micdone,"Step WEBELEMENTCLICK", " The WebElement "& Chr(34) & strLabel & Chr(34) &" has been clicked." 
                                                                                                          Reporter.Filter = rfDisableAll                                                                                                                             
                                                                                                          clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2
                                                                                      End If
                                                                   Else                                 
                                                                                      If obj.Exist(5) Then   
														
																									obj.Highlight
																																										If  UCASE(Environment.Value ("BrowserName"))="IE" Then
																																			
																																										obj.Click                  
																																										ElseIf UCASE(Environment.Value ("BrowserName"))="FIREFOX" Then
																																		
																																														Set objDeviceReplay = CreateObject ("Mercury.DeviceReplay")
																																														absx = obj.GetROProperty("abs_x")
																																														absy = obj.GetROProperty("abs_y")
																																														objDeviceReplay.MouseMove absx, absy
																																														objDeviceReplay.MouseClick absx, absy,LEFT_MOUSE_BUTTON
																														
																																										End If

                                                                                                                
                                                                                                          strDesc="WEBELEMENTCLICK: action on "& Chr(34) & strLabel & Chr(34) &" successfully performed."
                                                                                                          Reporter.Filter = rfEnableAll
                                                                                                          Reporter.ReportEvent micdone,"Step WEBELEMENTCLICK", " The WebElement "& Chr(34) & strLabel & Chr(34) &" has been clicked." 
                                                                                                          Reporter.Filter = rfDisableAll                                                                                                                             
                                                                                                          clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2
                                                                                      Else
                                                                
                                                                                                          strDesc=strpartdesc&" at the row number "& Chr(34) & iRowCnt+1 & Chr(34) &" link "& Chr(34) & strLabel & Chr(34) &" not Exist."
                                                                                                          Reporter.Filter = rfEnableAll
                                                                                                          Reporter.ReportEvent micdone,"Step WEBELEMENTCLICK", " The WebElement "& Chr(34) & strLabel & Chr(34) &" no Exist." 
                                                                                                          Reporter.Filter = rfDisableAll          
                                                                                                          objEnvironmentVariables.TestCaseStatus=False 
                                                                                                          clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
                                                                                                          clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0                                                                                                                                                          
                                                                                      End If                                                            
                                                                   End If
                                                                                                                                                                                                                                                                 End If



                                                                 
	'							Verify that whether button exist
						Case "VERIFYBUTTONEXIST"						
							set obj = objsub.WebButton(Object_Name)

							'Ram (7-4-10) - Added to get the type of property to be set from the testdata ref in case we are using a gen image (eg: Alt or File Name)
							'************************************************************************************************************************************************************
							If  strTestDataReference<>"" Then '
                                    strProperty=TRIM(strTestDataReference)									
							Else
									'Nothing done as of now. For future use
							End If

							'Ram (7-4-10) 
							'***************
							'Get the input value which can be either the image alt name or file name, user can either hard code it directly or send it via ENV value for cases like product name (Eg: Checkout Image)
							'Note: Incase the image name or file name is already there in the OR and user just wants to pass the INDEX then in that case he/she has pass the keyword as INDEX:0, INDEX:1 , etc
							'No need to pass the type of property in strTestDataReference, It can be left blank

                            If Trim(strInputValue) <> "" Then 
								'added by Ram' 23-3-10 inorder to define alt propery and index as well, in case one or more images of the same name or property exists, 
								'Input: The order of passing the value would be index  - This has to be passed under the strInputValue columnas
								arrInputVal=Split(strInputValue,":")
								Select Case UCASE(arrInputVal(0))
									Case "INDEX"
										obj.setTOProperty "index",TRIM(arrInputVal(1)) 
									Case "ENV" 'Ram 7-4-10
										strPropValue = Environment.Value(Trim( arrInputVal(1)))
										obj.setTOProperty strProperty,strPropValue
										'Incase some other property needs to be passed along with ENV value 
										If UBOUND(arrInputVal)>1 Then
											'In case of index
											If  UCASE(TRIM(arrInputVal(2)))="INDEX" Then
												obj.setTOProperty "index",TRIM(arrInputVal(3)) 
											End If
										End If
								End Select								
							End If    
														
							blnverifyRes=False
							If Trim(strExpectedValue)="" OR  UCase(strExpectedValue)="TRUE"  then
								strExpectedValue= True 
							Else
								strExpectedValue= False 
							End If
							
							If UCase(CStr(obj.Exist(5))) Then
								blnVerifyRes = True 
								obj.Highlight
								
							Else
								blnVerifyRes = False 
							End If		
							''''''''''''''''''''''''''''''''''''''''msgbox blnVerifyRes					
							
							If blnVerifyRes Then
								If strExpectedValue Then
									'Added by Ram 23-3-10 - To fetch the file name to make sure it has not changed under this reg, cycle
									strDesc ="VERIFYBUTTONEXIST: Button " & chr(34) & strLabel & chr(34) & " exist. "

									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micPass,"Step VERIFYBUTTONEXIST", strDesc
									Reporter.Filter = rfDisableAll
								Else
									strDesc =strpartdesc&" at the row number " & chr(34) &  iRowCnt+1 & chr(34) & " button " & chr(34) & strLabel & chr(34) & " exists but it is not expected"
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micFail,"Step VERIFYBUTTONEXIST", strDesc
									objEnvironmentVariables.TestCaseStatus=False
									Reporter.Filter = rfDisableAll
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
								End If
							Else
								If strExpectedValue Then	
									strDesc = strpartdesc&" at the row number " & chr(34) &  iRowCnt+1 & chr(34) & " the Button "& chr(34) & strLabel & chr(34) &" does not exist exists but it is expected"
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micFail,"Step VERIFYBUTTONEXIST", strDesc
									objEnvironmentVariables.TestCaseStatus=False
									Reporter.Filter = rfDisableAll
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0										
								Else
									strDesc = "VERIFYBUTTONEXIST: The button"& chr(34) & strLabel & chr(34) &" does not exists"
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micPass,"Step VERIFYBUTTONEXIST", strDesc
									Reporter.Filter = rfDisableAll
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
								End If
							End If



					Case "STOREINENVVAR"

						arrInputVal=Split(strInputValue,":")
						'Store a value in env value and use it later
						Environment.Value( Trim(  arrInputVal(1) )  ) = strOptParam


					Case "GOTOURL"
						
							'Fayis (229680) - To navigate to a certain URL
							If Trim(strInputValue) <> "" Then 
								If  objsub.Exist(5) Then
									objsub.Navigate strInputValue
									objsub.Sync
								Else
									Browser("name:=.*").Navigate strInputValue
									Browser("name:=.*").Sync			
								End if

								strPgeURL=TRIM(objsub.GetROProperty("url"))
						
								If  (INSTR(strPgeURL,TRIM(strInputValue))>0) Then
									strDesc ="GOTOURL: Browser navigated to the url " & chr(34) &  strInputValue & chr(34) & " successfully."
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micPass,"Step GOTOURL", strDesc
									Reporter.Filter = rfDisableAll
								Else
									strDesc =strpartdesc&" at the row number " & chr(34) &  iRowCnt+1 & chr(34) & " browser NOT navigated to the url "  & chr(34) &  strInputValue & chr(34)
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micFail,"Step GOTOURL", strDesc
									objEnvironmentVariables.TestCaseStatus=False
									Reporter.Filter = rfDisableAll
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
								End If				
						End if				

					End Select  



					If objEnvironmentVariables.TestCaseStatus = False Then
						CurrentFailureCount = CurrentFailureCount + 1						
					Else
						objEnvironmentVariables.TestCaseStatus = GlobalTestCaseStatus
						'CurrentFailureCount = 0
					End IF

					If CurrentFailureCount = 10 Then 
						Err.Raise 1
						strDesc = strpartdesc&" at the row number "& chr(34) & iRowCnt+1 & chr(34) & " execution had to be aborted because of majority of step in test script get failed."
						objEnvironmentVariables.TestStepCount=objEnvironmentVariables.TestStepCount+1
						clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc , 0						
						Exit Function
					End If					

					If err.number <> 0 and err.number <> 501 and err.number <> 13  and err.number <> 424  and err.number <> -2147220983  	Then 
						Call clsReport.WriteHTMLErrorLog(objEnvironmentVariables, err.Description,strSheet_Name,iRowCnt,strInputValue)
						objEnvironmentVariables.ErrNum = objEnvironmentVariables.ErrNum + 1
						err.Clear
												
						strDesc = strpartdesc& "  " & err.number & " at the row number "&iRowCnt+1&" execution at the field "&strLabel&" "& " had to be aborted because of a show stopper defect. Refer to ErrorLog"						
						clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
						objEnvironmentVariables.TestStepCount=objEnvironmentVariables.TestStepCount+1
						clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc , 0
						objEnvironmentVariables.TestCaseStatus=False
						Exit Function
					End If

				strInputValue=""
				strExpectedValue=""
				strDbValue=""
				If UCASE(TRIM(strAction))<>"SETBROWSERFLAG" Then
					Environment.Value("CurrentBrowser")=""
				End If
				
'				err.Clear

End If
											
			Next    
		'Err.Raise 1  ''Teekam
	End Function		
End Class