'**********************************************************
'UtilFunctions.vbs 
'
'Listing of available functions: See function header for usage. 
'Please list in ALPHABETICAL for the added function name with a short description. No username needed!
'**********************************************************
'
'		Activetab
'		Actionbtn_Validation
'		addEncounter     		'Creates Encounter at Coding, CV, QA or CVQA Tabs
'		AssignOrganizationInformation - Mrudula
'		CodeReview_BtnValidations
'		CV_BtnValidations
'		CVQA_BtnValidations
'		CVQA_Review_BtnValidations
'		Click_Project subtabmenuoptions
'		Change_ChartStatus
'		clickCalendarDate - Govardhan
'		columnHeaderCheck - Govardhan
'		DBContentValidation - Govardhan
'		deleteAllEncounters 	' delete all the Encounters
'		dialogWindow
'		EditPage_Validation
'		exportFile - Mrudula/Govardhan
'		ExcelContentValidation - Govardhan
'		Get_ChartId - NO ARGUMENTS TO SEND
'		InActivetab
'		InActionbtn_Validation		'Validate the Inactive Buttons are displayed on screen
'		IntkVal_BtnValidations
'		killProcess
'		Locked_By_Statusvalidation
'		Locked_By_Status
'       lockImageBarcodeSearch		'search a green/red lock image for a barcode specified
'		maintabHeaderNavigate		'Navigate the main tab menu
'       maintabSubHeaderNavigate	'Navigate the main tab submenu
'       maintabHeaderStatus			'verify tab header menu status w/active,inactive,disabled tabs specified
'       maintabSubHeaderStatus      'verify subtab header menu status w/active,inactive,disabled tabs specified
'		Mapping_PageValidation
'		modifyEncounter				'Modifies Encounter at Coding, CV, QA or CVQA Tabs
'		NavigateToEncounterDetails  'If Encounter Date and Position is passes as Input, It will Navigate to Encounter Details Section in any Tab
'		OrgMgmt
'       popupDialogButtonClick      'click a button within a popup dialog window - is a WebTable obj. not Dialog obj
'       popupDialogEnterComments    'enter comments then click Confirm/Cancel
'       popupIntakeReject           'Intake Reject use only - check reason code checkboxes and entering comments in the popup window
'       popupIntakeRotate           'Intake Rotate 
'       popupMenuItemSearch			'search a menu item in the popup window
'       popupMenuItemSelect			'select a menu item in the popup window
'       popupWindowReasonEscalation	'select a reason for escalation, enter note, and click Submit/Cancel
'       popupWindowReasonReject     'check reject reason checkbox(es), enter note, and click Submit/Cancel
'		Profile_BtnValidations
'		pdf2text - Mrudula
'		QA_BtnValidations
'		QAReview_BtnValidations
'       searchEncounter				'search for encounters in the Encounters tab/page
'		SearchBY_ProjAndChartstatus
'		SearchBY_ProjStatus 
'		SearchBY_ProjStatus_Action
'       searchChartID				'search a chart ID w/project status = All Active and return the chart id found
'       searchChartInResearchQueue	'search for chart in the Research queue and or in the Encounters screen
'		SearchFor_ProjStatusandProjId
'		SearchFor_ProjStatusandChartId
'		searchText - Mrudula
'		setDate - Govardhan
'       sortTableColumn				'verify sorting in a webtable
'		Subtab_menu_clicker
'		subtab_menuvalidation
'       tabHeaderStatus           'verify the header tab menu status
'       tabSubHeaderStatus        'verify the sub-header tab menu status
'		ValidatePage_Title
'		Verify_Chartstus
'		VerifyBestEvidenceCheckBox		'Verify Best Evidence Checkboxes are displayed to user under comparison Outcome Section
'		VerifyCVReviewedCheckBox		'Verify CV Reviewed Checkboxes are displayed to user under comparison Outcome Section
'		waitForPageSync - SatyaDev
'		webTableSearch
'		Weblist_validation
'**********************************************************
Option Explicit 
Class utilFunctions

	Public Function Activetab(HTMLID_Property)	
'***************************************************************************************
		'Purpose: Verify whether the tab is active
		'Parameter: stabname - menu tab name
		'Returns: True/False
		'Usage Example: Activetab "j_id29_shifted"  'j_id29_shifted is html id property of the 
		'Author: Sujatha Kandikonda 03/22/2011
'***************************************************************************************
		Services.StartTransaction "Activetab"
		Dim oAppBrowser,Status,Tabname
		
		'verify parameter
		If HTMLID_Property="" Or IsNull(HTMLID_Property) Then
			Reporter.ReportEvent micDone,"Activetab --> Parameter","Parameter cannot be an empty string. Abort."
			Activetab=False
			Services.EndTransaction "Activetab"
			Exit Function
		End If 
		
		'Start navigation
		Set oAppBrowser=Browser(Environment("BROWSER_OBJ"))	'Browser obj.
		If oAppBrowser.WebTable("html tag:=TABLE","html id:=" & HTMLID_Property).Exist(2) Then 
			Reporter.ReportEvent micInfo,"Activetab --> Tab Existence", "Tab with HTML ID property : '"& HTMLID_Property &"' is available"
			Status=oAppBrowser.WebTable("html tag:=TABLE","html id:=" & HTMLID_Property).GetROProperty("innerhtml")
			Tabname = oAppBrowser.WebTable("html tag:=TABLE","html id:=" & HTMLID_Property).GetROProperty("innertext")
			If Instr(1,Status,"rich-tab-active",1) > 0 Then
				Activetab = True
			Elseif Instr(1,Status,"rich-tab-inactive",1) > 0 Then
				Reporter.ReportEvent micPass,"Activetab --> Tab Existence", Tabname &"Tab with HTML ID property : '"& HTMLID_Property &"' is INACTIVE on screen, as Expected"
				Activetab = True
			Elseif Instr(1,Status,"rich-tab-disabled",1) > 0 Then
				Reporter.ReportEvent micFail,"Activetab --> Tab Existence", Tabname &"Tab with HTML ID property : '"& HTMLID_Property &"' is DISABLED on screen, NOT as Expected"
				Activetab = False	
			Else	
				Reporter.ReportEvent micFail,"Activetab --> Tab Existence", Tabname &"Tab with HTML ID property : '"& HTMLID_Property &"' has Status '"& Status &"' on screen, NOT as Expected"
				Activetab = False
			End If 
		Else
			Reporter.ReportEvent micFail,"Activetab --> Tab Existence", Tabname &"Tab with HTML ID property : '"& HTMLID_Property &"' is Not available on screen"
		End If
		
		Set oAppBrowser=Nothing
		Services.EndTransaction "Activetab"	
	End Function
	
	'<@comments>
'********************************************************************************************
		Public Function InActivetab(HTMLID_Property)	
'***************************************************************************************
		'Purpose: Verify whether the tab is disabled
		'Parameter: stabname - menu tab name
		'Returns: True/False
    	'Usage Example: util.InActivetab("j_id289_shifted")	 'j_id289_shifted is html id property of the 
		'Author: Sujatha Kandikonda 05/09/2011
'***************************************************************************************
		Services.StartTransaction "InActivetab"
		Dim oAppBrowser,Status, Tabname
		
		'verify parameter
		If HTMLID_Property="" Then
			Reporter.ReportEvent micDone,"InActivetab --> Parameter","Parameter cannot be an empty string. Abort."
			InActivetab = False
			Services.EndTransaction "InActivetab"
			Exit Function
		End If 
		
		'start navigation
		Set oAppBrowser=Browser(Environment("BROWSER_OBJ"))	'Browser obj.
		If oAppBrowser.WebTable("html tag:=TABLE","html id:=" &HTMLID_Property).Exist(2) Then 
			Reporter.ReportEvent micInfo,"InActivetab --> Tab Existence", "Tab with HTML ID property : '"& HTMLID_Property &"' is available"
			Status=oAppBrowser.WebTable("html tag:=TABLE","html id:=" &HTMLID_Property).GetROProperty("innerhtml")
			Tabname = oAppBrowser.WebTable("html tag:=TABLE","html id:=" &HTMLID_Property).GetROProperty("innertext")
			If Instr(1,Status,"rich-tab-disabled",1) > 0 Then
				InActivetab = True
			Elseif Instr(1,Status,"rich-tab-active",1) > 0 Then
				Reporter.ReportEvent micFail,"InActivetab --> Tab Existence", Tabname &"Tab with HTML ID property : '"& HTMLID_Property &"' is ACTIVE on screen, NOT as Expected"
				InActivetab = False
			Elseif Instr(1,Status,"rich-tab-inactive",1) > 0 Then
				Reporter.ReportEvent micFail,"InActivetab --> Tab Existence", Tabname &"Tab with HTML ID property : '"& HTMLID_Property &"' is INACTIVE on screen, NOT as Expected"
				InActivetab = False	
			Else	
				Reporter.ReportEvent micFail,"InActivetab --> Tab Existence", Tabname &"Tab with HTML ID property : '"& HTMLID_Property &"' has Status '"& Status &"' on screen, NOT as Expected"
				InActivetab = False
			End If 
		Else
			Reporter.ReportEvent micFail,"InActivetab --> Tab Existence", Tabname &"Tab with HTML ID property : '"& HTMLID_Property &"' is Not available on screen"
		End If
		
		Set oAppBrowser= Nothing
		Services.EndTransaction "InActivetab"	
	End Function
	
'<@comments>
'********************************************************************************************
		Public Function Actionbtn_Validation (Byval HTMLPropActionBtn_array )
'**********************************************************************************************************************************
		'Purpose: Verify  whether the web buttons in a page are enabled 
		'  Parameters: HTMLID_Property = Array of HTLML properties of action buttons in a page
		'Returns: True/False
		'Requires: Environment Variable "BROWSER_OBJ" has been initialized/created
		'Usage: btnstatus = util.Actionbtn_Validation (CodRev_array)
		'Created by: Sujatha Kandikonda 03/23 /2011
'*************************************************************************************************************************************
			Services.StartTransaction "Actionbtn_Validation" ' Timer start
			Dim oAppBrowser,iStatus, ActionBtn_cnt, HTMLID_Property, WebButtonStatus,Btn_name, i
			Set oAppBrowser = Browser(Environment("BROWSER_OBJ"))
			ActionBtn_cnt = Ubound(HTMLPropActionBtn_array )
		'Validate whether the action buttons are enabled
				For i = 0 to ActionBtn_cnt 
					HTMLID_Property = HTMLPropActionBtn_array(i)
					If oAppBrowser.WebButton("html id:=" &HTMLID_Property).Exist(2) Then
						Reporter.ReportEvent micPass, "Web Button", "Web button does exist"
						iStatus=oAppBrowser.WebButton("html id:=" &HTMLID_Property).GetROProperty("disabled")
						Btn_name = oAppBrowser.WebButton("html id:=" &HTMLID_Property).GetROProperty("name")
						If CInt(iStatus) = 0 Then
								Actionbtn_Validation = True		'return value
								Reporter.ReportEvent micPass, "Button Property - "& HTMLID_Property, HTMLID_Property &" - disable Property is - "& iStatus &" as Expected"
						Else
								Actionbtn_Validation = False	'return value
								Reporter.ReportEvent micfail, "Button Property - "& HTMLID_Property, HTMLID_Property &" - disable Property is - "& iStatus & ",Not as Expected"
						End If			
					Else
						WebButtonStatus= "not exist"	'return value
						Reporter.ReportEvent micFail, "Web Button", "Web button does not exist"
					End If
				Next
			Set oAppBrowser = Nothing
			Set iStatus = Nothing
			Set WebButtonStatus = Nothing
			Set HTMLID_Property = Nothing
			Set ActionBtn_cnt = Nothing
			Set Btn_name = Nothing
			Set i = Nothing
			Services.EndTransaction "Actionbtn_Validation" ' Timer end
		End Function	
	
	'<@comments>
'********************************************************************************************
		Public Function InActionbtn_Validation (Byval HTMLPropActionBtn_array )
'**********************************************************************************************************************************
		'Purpose: Verify  whether the web buttons in a page are disabled 
		'Parameters: sHTMLID_Property = Array of HTLML properties of action buttons in a page
		'Returns: True/False
		'Requires: Environment Variable "BROWSER_OBJ" has been initialized/created
		'Usage: btnstatus = util.InActionbtn_Validation (CodRev_array)
		'Created by: Govardhan Choletti 12/26/2012
'*************************************************************************************************************************************
			Services.StartTransaction "InActionbtn_Validation" ' Timer start
			Dim oAppBrowser, sHTMLID_Property, sBtn_name, i, iStatus
			Set oAppBrowser = Browser(Environment("BROWSER_OBJ"))
			
			'Verify the Input parameter passed is an Array
			If IsArray(HTMLPropActionBtn_array) Then
				Reporter.ReportEvent micDone, "InPut Parameters", "Input parameters is passed as Array '"& Join(HTMLPropActionBtn_array, ", ")&"', as Expected"
			Else
				Reporter.ReportEvent micFail, "InPut Parameters", "Input parameters passed is NOT an Array, Please check the passed parameters once !!!"
				InActionbtn_Validation = False	'return value
				Exit Function				
			End If
			
		'Validate whether the action buttons are enabled
				For i = 0 to Ubound(HTMLPropActionBtn_array )
					sHTMLID_Property = HTMLPropActionBtn_array(i)
					If oAppBrowser.WebButton("html id:=" & sHTMLID_Property).Exist(2) Then
						Reporter.ReportEvent micPass, "Web Button", "Web button with HTML ID Property - '"& sHTMLID_Property &"' does exist in application"
						iStatus=oAppBrowser.WebButton("html id:=" & sHTMLID_Property).GetROProperty("disabled")
						sBtn_name = oAppBrowser.WebButton("html id:=" & sHTMLID_Property).GetROProperty("name")
						If CInt(iStatus) = 1 Then
								InActionbtn_Validation = True		'return value
								Reporter.ReportEvent micPass, "WebButton - "& sBtn_name, "Button '"& sBtn_name &"' with HTML ID : "& sHTMLID_Property &" has disable Property - "& iStatus &" as Expected"
						Else
								InActionbtn_Validation = False	'return value
								Reporter.ReportEvent micFail, "WebButton - "& sBtn_name, "Button '"& sBtn_name &"' with HTML ID : "& sHTMLID_Property &" has disable Property - "& iStatus & ", instead of '1', Not as Expected"
						End If			
					Else
						Reporter.ReportEvent micFail, "WebButton - "& sBtn_name, "WebButton - '"& sBtn_name &"' does not exist"
					End If
				Next
			Set oAppBrowser = Nothing
			Services.EndTransaction "InActionbtn_Validation" ' Timer end
		End Function	
		
	'<@comments>
	'********************************************************************************************
	Public Function EditPage_Validation (Byval HTMLPropWebEdit_array )
	'**********************************************************************************************************************************
	'Purpose: Verify  whether the page is editable
	'  Parameters: HTMLID_Property = Array of HTLML properties of Web Edit objects in a page
	'Returns: '0' for enabled and '1' for disabled
	'Requires: Environment Variable "BROWSER_OBJ" has been initialized/created
	'Usage: WebEditstatus = util.EditPage_Validation(QAREview_EditFields)
	'Created by: Sujatha Kandikonda 03/23 /2011
	'*************************************************************************************************************************************
	Services.StartTransaction "EditPage_Validation" ' Timer start
		Dim oAppBrowser,HTMLID_Property,Status
		Set oAppBrowser = Browser(Environment("BROWSER_OBJ"))
		cnt = Ubound(HTMLPropWebEdit_array )
	'Validate whether the action buttons are enabled
			For i = 0 to cnt 
				HTMLID_Property = HTMLPropWebEdit_array(i)
				If oAppBrowser.WebEdit("html id:=" &HTMLID_Property).Exist(2) Then
					Reporter.ReportEvent micPass, "Web Edit ", "Field '"&HTMLID_Property&"' does exist"
					Status =oAppBrowser.WebEdit("html id:=" &HTMLID_Property).GetROProperty("disabled")
					If Instr(1,Status,0,1) Then
						EditPage_Validation = "active"		'return value
					Else
						EditPage_Validation = "inactive"	'return value
					End If			
				Else
					EditPage_Validation= "not exist"	'return value
					Reporter.ReportEvent micFail, "Web Edit ", "Field '"&HTMLID_Property&"' does not exist"
				End If
			Next
		Set oAppBrowser = Nothing
		Set Status = Nothing
		Set HTMLID_Property = Nothing
	Services.EndTransaction "EditPage_Validation" ' Timer end
	End Function	
	
	'<@comments>	
	'**********************************************************************************************
		Public Function  SearchBY_ProjAndChartstatus(ProjStatus ,ChartStatus)
	'**********************************************************************************************************************************
	'Purpose: ChartSync > Data Summary table. Search by Project status and chart status
	'Parameters: ProjStatus - Project Status
	'						ChartStatus = Chart Status
	'Returns: True or False
	'Requires: Environment Variable "BROWSER_OBJ" has been initialized/created
	'Usage: WebEditstatus = util.SearchBY_ProjAndChartstatus ("All Active", "Coding")
	'Created by: Sujatha Kandikonda 03/28/2011
	'Modified by: Govardhan Choletti 08/24/2012
	'             Hung Nguyen 3/4/13 Updated - removed unecessary wait time 
	'*************************************************************************************************************************************
		Services.StartTransaction "SearchBY_ProjAndChartstatus" ' Timer start
		SearchBY_ProjAndChartstatus = False	'init
		Dim oAppBrowser,oTable
		Set oAppBrowser = Browser(Environment("BROWSER_OBJ"))
		oAppBrowser.Sync
		
		'Click on Clear Search
		If Not of.webButtonClicker ("commonSearchForm:cancelButton") Then		
			Reporter.ReportEvent micWarning, "Click Clear Search", "Function call failed"		'move on
		Else
			oAppBrowser.Sync
		End If
		
		'Select  project status	
		If of.webListSelect("commonSearchForm:projectStatusSearchValueList",ProjStatus) Then		
			
			'Click on Show 
			If oAppBrowser.WebElement("html tag:=SPAN","html id:=commonSearchForm:detailedSearchTogPanelOpenLabel").Exist(5)  Then		
				 oAppBrowser.WebElement("html tag:=SPAN","html id:=commonSearchForm:detailedSearchTogPanelOpenLabel").Click
				Reporter.ReportEvent micInfo, "Clicked on Show at Detailed Search ", "Object was clicked successful."
				oAppBrowser.Sync

				'Select chart status
				If  of.webListSelect("commonSearchForm:chartStatusSearchValueList",ChartStatus) Then	
					Reporter.ReportEvent micInfo, "Chart Status is selected as  " &ChartStatus, "Passed"
					
					'Click on Search
					If of.webButtonClicker ("commonSearchForm:searchButton") Then		
						Reporter.ReportEvent micPass, "Search", "'Search' button is clicked"
						Call ajaxSync.ajaxSyncRequest("Processing Request",120)	'wait for processing request w/timeout in secs						
						
						
						'making sure the Search Result table is loaded completely regardless of # records return prior to return value
						Set oTable=oAppBrowser.WebTable("html id:=projectForm:projectTable")
						If oTable.WaitProperty("rows",micgreaterthanorequal(4),5000) Or oAppBrowser.WebElement("html id:=projectForm:noRecordValue","innertext:=Please choose the search criteria and click Search.").Exist(5) Then
							reporter.reportevent micInfo,"Search record","The project table is completely loaded."
						End If 'move on 
						
						SearchBY_ProjAndChartstatus = True	'return value
						reporter.reportevent micPass,"SearchByProjAndChartStatus","Search was performed w/options '" &ProjStatus &"' and '" &ChartStatus &"'selected successful."
					Else
						Reporter.ReportEvent micFail, "Search", "'Search' button is clicked"
					End If								 		
				Else
					Reporter.ReportEvent micFail, "Chart Status is selected as  "&ChartStatus, "Failed"
				End If							
			Else
				Reporter.ReportEvent micWarning, "Clicked on Show at Detailed Search ", "The object does not exist. Abort."
			End If				
		Else
			Reporter.ReportEvent micFail, "Project Status is selected as "&ProjStatus, "Function call failed. Abort."
		End If
		Set oTable=Nothing
		Set oAppBrowser = Nothing
	Services.EndTransaction "SearchBY_ProjAndChartstatus" ' Timer end
	End Function
	
	'*******************************************************************************************************************
	'<@comments>	
	'**********************************************************************************************
	Public Function  SearchBY_ProjStatus (ProjStatus)
	'**********************************************************************************************************************************
	'Purpose: Search by Project status 
	'Parameters: ProjStatus - Project Status
	'Returns: True or False
	'Requires: Environment Variable "BROWSER_OBJ" has been initialized/created
	'Usage:  util.SearchBY_ProjStatus ("All Active")
	'Created by: Sujatha Kandikonda 03/28 /2011
	'***********************************************************************************************************************************
		Services.StartTransaction "SearchBY_ProjStatus" ' Timer start
		Dim oAppBrowser,rowscnt
		Set oAppBrowser = Browser(Environment("BROWSER_OBJ"))

		If  of.webButtonClicker ("commonSearchForm:cancelButton") Then		'Click on Clear Search
			Reporter.ReportEvent micPass, "Clear Search", "'Clear Search' button is clicked"
		else
			Reporter.ReportEvent micFail, "Clear Search", "'Clear Search' button is clicked"
		End If

		If of.webListSelect("commonSearchForm:projectStatusSearchValueList",ProjStatus) Then		'Select  project status
			Reporter.ReportEvent micPass, "Project Status is selected as "&ProjStatus, "Passed"
		else
			Reporter.ReportEvent micFail, "Project Status is selected as "&ProjStatus, "Failed"
		End If

		If of.webButtonClicker ("commonSearchForm:searchButton") Then		'Click on Search
				Reporter.ReportEvent micPass, "Search", "'Search' button is clicked"
		Else
			Reporter.ReportEvent micFail, "Search", "'Search' button is clicked"
		End If
		'Verify that the Search Result table is displayed
		If   oAppBrowser.WebTable("html tag:=TABLE", "html id:= projectForm:projectTable").Exist(2)  Then
			oAppBrowser.WebButton("html tag:=INPUT", "html id:= projectForm:projectExportAllButton").WaitProperty "disabled",True, 4000
			wait(4)
			rowscnt= oAppBrowser.WebTable("html tag:=TABLE", "html id:= projectForm:projectTable").GetROProperty("rows") 
			If rowscnt > 4 Then
				SearchBY_ProjStatus = TRUE
				Reporter.ReportEvent micPass, "Search Results", "Search Results for Project status as  '"&ProjStatus&"' and Chart status as '"&ChartStatus&"' is displayed"
			Else
				SearchBY_ProjStatus = FALSE
				Reporter.ReportEvent micFail, "Search Results", "Search Results for Project status as  '"&ProjStatus&"' and Chart status as '"&ChartStatus&"' is displayed"
			End If
		Else
			Reporter.ReportEvent micFail, "Web Table", "Web Table for Search Results does not exist"
		End If
		Set rowscnt = Nothing
		Set oAppBrowser = Nothing
		Services.EndTransaction "SearchBY_ProjStatus"  ' Timer end
	End Function

	'<@comments>	
	'**********************************************************************************************
	Public Function  SearchBy_ProjStatus_Action(ProjStatus , ActionSelection)
	'**********************************************************************************************************************************
	'Purpose: Search by Project status and Action 
	'Parameters: ProjStatus - Project Status
	'						ChartStatus = Action from Detailed search section
	'Returns: True or False
	'Requires: Environment Variable "BROWSER_OBJ" has been initialized/created
	'Usage: util.SearchBy_ProjStatus_Action ("All Active","Locked By")
	'Created by: Sujatha Kandikonda 03/28 /2011
	'*************************************************************************************************************************************
			Services.StartTransaction "SearchBy_ProjStatus_Action" ' Timer start
			
			Dim oAppBrowser,oAppObj,sListVal, rowscnt
			Set oAppBrowser = Browser(Environment("BROWSER_OBJ"))
			
			'Setting the object properties for the Webtable
			Set oAppObj = Description.Create()
			oAppObj("micclass").Value = "WebTable"
			oAppObj("html id").Value = "chartForm:chartTable"

			If  of.webButtonClicker ("commonSearchForm:cancelButton") Then		'Click on Clear Search
				Reporter.ReportEvent micPass, "Clear Search", "'Clear Search' button is clicked"
			Else
				Reporter.ReportEvent micFail, "Clear Search", "'Clear Search' button is clicked"
			End If

			If of.webListSelect("commonSearchForm:projectStatusSearchValueList",ProjStatus) Then		'Select  project status
				Reporter.ReportEvent micPass, "Project Status is selected as "&ProjStatus, "Passed"
			Else
				Reporter.ReportEvent micFail, "Project Status is selected as "&ProjStatus, "Failed"
			End If

			oAppBrowser.Sync
			'Click on Show button at the Detailed Search
			If oAppBrowser.WebElement("html tag:=SPAN","html id:=commonSearchForm:detailedSearchTogPanelOpenLabel").Exist(1)  Then		'Click on Show 
				 oAppBrowser.WebElement("html tag:=SPAN","html id:=commonSearchForm:detailedSearchTogPanelOpenLabel").Click
				Reporter.ReportEvent micPass, "Clicked on Show at Detailed Search ", "Passed"
			Else
				Reporter.ReportEvent micFail, "Clicked on Show at Detailed Search ", "Failed"
			End If

			' Select from Action drop down list
			If oAppBrowser.webList("html tag:=SELECT","html id:=commonSearchForm:retrievedBySearchValueList").Exist(1) Then  ' select from Action drop down list
				oAppBrowser.webList("html tag:=SELECT","html id:=commonSearchForm:retrievedBySearchValueList").Select ActionSelection
				Reporter.ReportEvent micPass, "Action drop down list",  "'"&ActionSelection&"' has been selected from the Action Drop down list"
			Else ' Check Using the Name Property
				Reporter.ReportEvent micFail, "Action drop down list", "'"&ActionSelection&"' has been selected from the Action Drop down list"
			End If
			
			wait(2)
			'Verify the correct drop down option has been selected from Action drop down list
			sListVal = RTrim(LCase(oAppBrowser.webList("html tag:=SELECT","html id:=commonSearchForm:retrievedBySearchValueList").GetROProperty("value")))	
			If StrComp(sListVal, LCase(ActionSelection), 1) = 0 Then 
				Reporter.ReportEvent micPass, "WebList Selection", "The value '" &  ActionSelection & "' was chosen from the Action Web List"
			Else
				Reporter.ReportEvent micFail, "WebList Selection", "The value '" & ActionSelection & "' was chosen from the Action Web List"
			End If
			
			If of.webButtonClicker ("commonSearchForm:searchButton") Then		'Click on Search
				Reporter.ReportEvent micPass, "Search", "'Search' button is clicked"
			Else
				Reporter.ReportEvent micFail, "Search", "'Search' button is clicked"
			End If
			oAppBrowser.sync
			Wait (10)
					
			'click on Chart tab 
			If of.webElementClicker("chartTabTabLabel")= True  Then
				Reporter.ReportEvent micPass,"Chart Tab is clicked","Passed"
			Elseif  of.webElementClicker("chartTabTabLabel") = False  Then
				Reporter.ReportEvent micFail,"Chart Tab is clicked","Failed"
			End If
			
			'Verify that the Search Result table is displayed
			oAppBrowser.sync
			If oAppBrowser.WebTable(oAppObj).Exist(2)  Then
				rowscnt= oAppBrowser.WebTable(oAppObj).GetROProperty("rows") 	
				If rowscnt > 4 Then
					SearchBy_ProjStatus_Action = TRUE
					Reporter.ReportEvent micPass, "Search Results", "Search Results for Project status as  '"&ProjStatus&"' and Action as '"&ActionSelection&"' is displayed"
				Else
					Reporter.ReportEvent micFail, "Search Results", "Search Results for Project status as  '"&ProjStatus&"' and Action as '"&ActionSelection&"' is displayed"
				End If
			Else
				SearchBy_ProjStatus_Action = FALSE
				Reporter.ReportEvent micFail, "Web Table", "Web Table for Search Results does not exist"
			End If
			Set oAppBrowser = Nothing
			Set sListVal = Nothing
			Set rowscnt = Nothing
			Services.EndTransaction "SearchBy_ProjStatus_Action"  ' Timer end
	End Function
	
'<@comments>	
	'**********************************************************************************************	
	Public Function Locked_By_Status(Image_HTMLProperty, HTMLProperty)
 '***********************************************************************************************************
	'Purpose: Verify the Locked by option in the popup window
	'                   Option is disabled when it is grayed-out, otherwise it is enabled.
	'Parameters: Byval Image_HTMLProperty = Image on which the cursor need to be hovered on for the menu to be displayed
	'						Locked BY Webelement Html Property
	'Returns: string: enabled/disabled/unknown
	'Requires: Environment Variable "BROWSER_OBJ" has been initialized/created
	'Usage: sReturnValue=util.Locked_By_Status("chartForm:chartTable:0:chartBarCodeValPic", "chartForm:chartTable:0:lockedByMenuGrp:anchor")
	'                if sReturnValue="enabled" then 
	'                      report pass/fail base on return value
	'               elseif sReturnValue="disabled" then
	'                      report pass/fail base on return value
	'               else	'unknown
	'                      report fail due to: 
	'                              a. unable to get value of the object
	'                              b. Image object not exist
	'                              c. WebElement not exist
	'                end if 
	'Created by: Mrudula Ambavarapu on 08/02/2011
'***********************************************************************************************************
   	Services.StartTransaction "Locked_By_Status" ' Timer Begin
   	Locked_By_Status = "unknown"  'init
   	Dim oAppBrowser, oElement,sObjColor
    Set oAppBrowser = Browser(Environment("BROWSER_OBJ"))
	
	If  oAppBrowser.Image("html id:=" &Image_HTMLProperty).Exist(2) Then
		'Hover over the image
		oAppBrowser.Image("html id:=" &Image_HTMLProperty).FireEvent "onmouseover"
		oAppBrowser.Image("html id:=" &Image_HTMLProperty).FireEvent "click"
		
		Set oElement=oAppBrowser.WebElement("html id:=" & HTMLProperty)
		If oElement.Exist Then
			sObjColor=oElement.Object.CurrentStyle.Color	'get the color value of the option/WebElement object

			If not isempty(sObjColor)  Then	'enabled				
				If sObjColor="#000" Then 	'enabled
					Locked_By_Status= "enabled"	'return value
					Reporter.ReportEvent micInfo, "Locked_By", "Locked_By is enabled and the user can break the lock"
				ElseIf sObjColor = "#b1ada7"  Then	'disable/grayed out
					Locked_By_Status= "disabled"	'return value
					Reporter.ReportEvent micInfo, "Locked_By", "Locked_By is disabled and the user cannot break the lock"
				Else	'unknown
					Reporter.ReportEvent micInfo, "Locked_By", "Unable to get Locked_By status"
				End If
			Else
				Reporter.ReportEvent micFail, "Locked_By", "Fails to get font color of object "
			End If 
		Else
			Reporter.ReportEvent micFail, "Locked_By", "The 'Lock by' option does not exist."
		End If
	Else
		Reporter.ReportEvent micFail, "Locked_By", "The lock image object does not exist."
	End If
	Set oAppBrowser = Nothing
	 Services.EndTransaction "Locked_By_Status" ' Timer end
	End Function
	
	'<@comments>	
'**********************************************************************************************
	Public Function Locked_By_Statusvalidation(Image_HTMLProperty, HTMLProperty)
'***********************************************************************************************************
	'Purpose: Validate that the Locked by status is enabled
	'Parameters: Byval Image_HTMLProperty = Image on which the cursor need to be hovered on for the menu to be displayed
	'						Locked BY Webelement Html Property
	'Returns: string: enabled/disabled
	'Requires: Environment Variable "BROWSER_OBJ" has been initialized/created
	'Usage: util.Locked_By_Statusvalidation("chartForm:chartTable:0:chartBarCodeValPic", "chartForm:chartTable:0:lockedByMenuGrp:anchor")
	'Created by: Sujatha Kandikonda 05/26/2011
'***********************************************************************************************************
   	Services.StartTransaction "Locked_By_Statusvalidation" ' Timer Begin
   	
		Dim oAppBrowser, oAppObj,oAppObj1
		Dim sObjectState
		Set oAppBrowser = Browser(Environment("BROWSER_OBJ"))
		
		' Variable Declaration / Initialization
		Set oAppBrowser = Browser(Environment("BROWSER_OBJ"))' Setting local variable to the function to Use Environment Variable Browser Object Value
		'Setting the object properties for the Image Object
		Set oAppObj = Description.Create()
		oAppObj("micclass").Value = "Image"
		oAppObj("html id").Value = Image_HTMLProperty
		If  oAppBrowser.Image("html id:=" &Image_HTMLProperty).Exist(2) Then
			'Hover over the image
			oAppBrowser.Image("html id:=" &Image_HTMLProperty).FireEvent "onmouseover"
			oAppBrowser.Image("html id:=" &Image_HTMLProperty).FireEvent "click"
			Wait(2)
		End If
		
		'Verify that the Locked by is enabled
		Set oAppObj1= Description.Create()
		oAppObj1("micclass").Value = "WebElement"
		oAppObj1("html id").Value = HTMLProperty
		If oAppBrowser.WebElement(oAppObj1).Exist(5) Then
			sObjectState = oAppBrowser.WebElement(oAppObj1).GetRoProperty("class")
			If Instr(1,sObjectState,"rich-menu-group-enabled", 1) > 0 Then
				Locked_By_Statusvalidation = TRUE
			ElseIf Instr(1,sObjectState,"rich-menu-group-disabled", 1) > 0 Then
				Locked_By_Statusvalidation = FALSE
			Else
				Locked_By_Statusvalidation = FALSE
				Reporter.ReportEvent micFail,"Locked_By_Statusvalidation --> Locked By", "Locked by Barcode has a different class property '"& sObjectState &"', NOT as Expected"
			End If
		Else
			Reporter.ReportEvent micWarning,"Locked_By_Statusvalidation --> Locked By", "Locked by object with HTML property '"& HTMLProperty &"' doesn't available on screen, NOT as Expected"
		End If
		Set oAppBrowser = Nothing
		Set oAppObj = Nothing
		Set oAppObj1 = Nothing
	Services.EndTransaction "Locked_By_Statusvalidation" ' Timer end
	End Function
	
'<@comments>	
	'**********************************************************************************************
	Public Function  SearchFor_ProjStatusandProjId (ProjStatus,ProjId)
	'**********************************************************************************************************************************
	'Purpose:Search by Project status and Project Id
	'Parameters: ProjStatus - Project Status
	'						   ProjId  - Project Id
	'Returns: True or False
	'Requires: Environment Variable "BROWSER_OBJ" has been initialized/created
	'Usage: util.SearchFor_ProjStatusandProjId("All Active",100)
	'Created by: Sujatha Kandikonda 04/07/2011
	'Modified By: Mrudula Ambavarapu 
				  'Commented the section where it verifies if the results are more than 4, because with project ID in search criteria it gives only one record which is already verified
	'Modified by: Govardhan Choletti 03/05/2012
				  ' If Project ID is entered as '100', then select Image Availablity Statas as 'Image Available' <This is to check Mapping Functionality>
	'***********************************************************************************************************************************
		Services.StartTransaction "SearchFor_ProjStatusandProjId" ' Timer start
		Dim oAppBrowser,rowscnt
		Set oAppBrowser = Browser(Environment("BROWSER_OBJ"))

		If of.webButtonClicker ("commonSearchForm:cancelButton") Then		'Click on Clear Search
			Reporter.ReportEvent micPass, "Clear Search", "'Clear Search' button is clicked"
		Else
			Reporter.ReportEvent micFail, "Clear Search", "'Clear Search' button is clicked"
		End If

		If of.webListSelect("commonSearchForm:projectStatusSearchValueList",ProjStatus) Then		'Select  project status
			Reporter.ReportEvent micPass, "Project Status is selected as "&ProjStatus, "Passed"
		Else
			Reporter.ReportEvent micFail, "Project Status is selected as "&ProjStatus, "Failed"
		End If

		If of.webEditEnter("commonSearchForm:projectIdSearchValue",ProjId) Then		''Enter project Id
			Reporter.ReportEvent micPass, "Project Id is selected as "&ProjId, "Passed"
		else
			Reporter.ReportEvent micFail, "Project Id is selected as "&ProjId, "Failed"
		End If
					
	' Select the Availability Status as 'Image Available'
		If ProjId = 100 Then
			If of.webListSelect("commonSearchForm:availabilityStatusSearchValueList", "Image Available") = True Then
				Reporter.ReportEvent micPass,"STEP - Select Availability Status = 'Image Available'","Successfully selected Available Status to 'Image Available' for Project 100 as Expected"
			Else
				Reporter.ReportEvent micFail,"STEP - Select Availability Status = 'Image Available'","Unable to select Available Status to 'Image Available' for Project 100, NOT as Expected"
			End If
		End If

		If of.webButtonClicker ("commonSearchForm:searchButton") Then		'Click on Search
			Reporter.ReportEvent micPass, "Search", "'Search' button is clicked"
		Else
			Reporter.ReportEvent micFail, "Search", "'Search' button is clicked"
		End If
		
	'Verify that the Search Result table is displayed
		If of.webElementFinder("projectForm:projectTable:idHeader")= True  Then
			Reporter.ReportEvent micPass,"Search results are displayed in Project tab","Passed"
		Else
			Reporter.ReportEvent micFail,"Search results are displayed in Project  tab","Failed"
			ExitAction
		End If
		
	'	Wait(4)
	'	rowscnt= oAppBrowser.WebTable("html tag:=TABLE", "html id:= projectForm:projectTable").GetROProperty("rows") 
	'	If rowscnt > 4 Then
	'		SearchFor_ProjStatusandProjId = TRUE
	'		Reporter.ReportEvent micPass, "Search Results", "Search Results for Project status as  '"&ProjStatus&"' and Project Id as '"&ProjId&"' is displayed"
	'	Else
	'		SearchFor_ProjStatusandProjId = FALSE
	'		Reporter.ReportEvent micFail, "Search Results", "Search Results for Project status as  '"&ProjStatus&"' and Project Id as '"&ProjId&"' is displayed"
	'	End If
				
		Set oAppBrowser = Nothing
		Services.EndTransaction "SearchFor_ProjStatusandProjId" ' Timer end
	End Function
		
	'<@comments>	
	'*******************************************************************************************************
	Public Function  SearchFor_ProjStatusandChartId (ProjectStatus,ChartId)
	'**********************************************************************************************************************************
	'Purpose:Search by Project status and Chart Id
	'Parameters: ProjStatus - Project Status
	'						   ChartId - Chart Id
	'Returns: True or False
	'Requires: Environment Variable "BROWSER_OBJ" has been initialized/created
	'Usage: util.SearchFor_ProjStatusandProjId ("All Active", Byval ChartId)
	'Created by: Sujatha Kandikonda 05/18/2011
	'***********************************************************************************************************************************
		Services.StartTransaction "SearchFor_ProjStatusandChartId" ' Timer start
		Dim oAppBrowser,rowscnt
		Set oAppBrowser = Browser(Environment("BROWSER_OBJ"))
		
		'Click on Clear Search
		If  of.webButtonClicker ("commonSearchForm:cancelButton") Then		'Click on Clear Search
			Reporter.ReportEvent micPass, "Clear Search", "'Clear Search' button is clicked"
		Else
			Reporter.ReportEvent micFail, "Clear Search", "'Clear Search' button is clicked"
		End If
		
		'Select the project status
		If of.webListSelect("commonSearchForm:projectStatusSearchValueList",ProjectStatus) Then		'Select  project status
			Reporter.ReportEvent micPass, "Project Status is selected as "&ProjectStatus, "Passed"
		Else
			Reporter.ReportEvent micFail, "Project Status is selected as "&ProjectStatus, "Failed"
		End If
		
		'Click on Show button near Detailed search
		If  of.webElementClicker("commonSearchForm:detailedSearchTogPanelOpenLabel")= True  Then
				Reporter.ReportEvent micPass,"Show button near Detailed search is clicked","Passed"
		Elseif  of.webElementClicker("commonSearchForm:detailedSearchTogPanelOpenLabel")  = False  Then
				Reporter.ReportEvent micFail,"Show button near Detailed search is clicked","Failed"
		End If
		
		'Enter Chart Id
		If of.webEditEnter("commonSearchForm:chartIDSearchValue",ChartId) Then		''Enter chart Id
			Reporter.ReportEvent micPass, "Chart Id is selected as "&ChartId, "Passed"
		Else
			Reporter.ReportEvent micFail, "Chart Id is selected as "&ChartId, "Failed"
		End If
		
		'Click on Search
		If of.webButtonClicker ("commonSearchForm:searchButton") Then		'Click on Search
			Reporter.ReportEvent micPass, "Search", "'Search' button is clicked"
		Else
			Reporter.ReportEvent micFail, "Search", "'Search' button is clicked"
		End If
		
		'Verify that the Search Result table is displayed
		wait(3)
		If of.webElementFinder("projectForm:projectTable:idHeader")= True  Then
					Reporter.ReportEvent micPass,"Search results are displayed in Project tab","Passed"
		elseif of.webElementFinder("projectForm:projectTable:idHeader")= False  Then
					Reporter.ReportEvent micFail,"Search results are displayed in Project  tab","Failed"
					ExitAction
		End If
		
		rowscnt= oAppBrowser.WebTable("html tag:=TABLE", "html id:= projectForm:projectTable").GetROProperty("rows") 
		If rowscnt > 4 Then
			SearchFor_ProjStatusandChartId = TRUE
			Reporter.ReportEvent micPass, "Search Results", "Search Results for Project status as  '"&ProjectStatus&"' and Chart Id as '"&ChartId&"' is displayed"
		else
			SearchFor_ProjStatusandChartId = FALSE
			Reporter.ReportEvent micFail, "Search Results", "Search Results for Project status as  '"&ProjectStatus&"' and Chart Id as '"&ChartId&"' is displayed"
		End If
		Set rowscnt = Nothing
		Set oAppBrowser = Nothing
		Services.EndTransaction "SearchFor_ProjStatusandChartId" ' Timer end
	End Function
	
	'<@comments>	
'*******************************************************************************************************
	Function Change_ChartStatus(Byval Webelement_HTMLID_Property)
'***********************************************************************************************************
	'Purpose: To change the chart staus, for eg from Released to CNA
	'Parameters: Byval Webelement_HTMLID_Property
	'Returns: True or false
	'Requires: Environment Variable "BROWSER_OBJ" has been initialized/created
	'Usage: util.Change_ChartStatus("chartForm:chartTable:0:setCNABarcode")
	'Created by: Sujatha Kandikonda 05/16/2011
'***********************************************************************************************************
   	Services.StartTransaction "Change_ChartStatus" ' Timer Begin
		Reporter.ReportEvent micDone, "Change_ChartStatus", "Function Begin"
		' Variable Declaration / Initialization
		Dim oAppBrowser, oAppObj, Flag
	  	Set oAppBrowser = Browser(Environment("BROWSER_OBJ"))' Setting local variable to the function to Use Environment Variable Browser Object Value

		'Setting the object properties for the Webelement Object
			Set oAppObj = Description.Create()
			oAppObj("micclass").Value = "WebElement"
			oAppObj("html id").Value =  Webelement_HTMLID_Property
			oAppBrowser.sync
			If  oAppBrowser.Image("html id:=chartForm:chartTable:0:barcodeStatusValValPic").Exist(2) Then
				'Hover over the image
                Reporter.ReportEvent micPass, "Link to the dropdown menu exists", "Passed"  
				oAppBrowser.Image("html id:=chartForm:chartTable:0:barcodeStatusValValPic").FireEvent "onmouseover"
				oAppBrowser.Image("html id:=chartForm:chartTable:0:barcodeStatusValValPic").FireEvent "click"
			Else
				Reporter.ReportEvent micFail, "Link to the dropdown menu exists", "Failed"  
			End If
			
            If oAppBrowser.WebElement("html id:=" &Webelement_HTMLID_Property).Exist(2) Then
				Reporter.ReportEvent micPass, "WebElement Exists", "Passed"  
				oAppBrowser.WebElement("html id:=" &Webelement_HTMLID_Property).Click 
				Flag = "Status Changed"
			Else
				Reporter.ReportEvent micFail, "WebElement Exists", "Failed"  
			End If

			If  Flag = "Status Changed" Then
				Change_ChartStatus = TRUE
			Else 
				Change_ChartStatus = FALSE
			End If

		Set oAppBrowser =Nothing
		Set oAppObj = Nothing
		Set Flag = Nothing
		Services.EndTransaction "Change_ChartStatus" ' Timer end
		Reporter.ReportEvent micDone, "Change_ChartStatus", "Function Begin"
	End Function
	
	'<@comments>	
	'*******************************************************************************************************
	Public Function OrgMgmt(ByVal Webtable_htmlprop)
	'*******************************************************************************************************
	'Purpose: Verify Org management tab 
	'Parameters: Nothing
	'Returns: True or False
	'Requires: Environment Variable "BROWSER_OBJ" has been initialized/created
	'Usage: util.OrgMgmt("j_id1582_shifted" )
	'Created by: Sujatha Kandikonda 03/29 /2011
	'*************************************************************************************************************************************
	   Services.StartTransaction "OrgMgmt" ' Timer start
		'Click on Orgnization Management
			If of.webElementClicker ("vendorTabLabel") = True Then
			    Reporter.ReportEvent micPass, "Organization Management Tab is clicked", "Passed"
			Else
				Reporter.ReportEvent micFail, "Organization Management Tab is clicked", "Failed"
			End If
			
		'Click on Organization Information
			If of.webElementClicker  ("vendorForm:vendorTable:0:rpt03") = True Then
				OrgMgmt = TRUE
			    Reporter.ReportEvent micPass, "Organization Management Page is displayed and Org Information link is clicked", "Passed"
			Else
				OrgMgmt = FALSE
				Reporter.ReportEvent micFail, "Organization Management Page is displayed and Org Information link is clicked", "Failed"
			End If
			
		'Click on Cancel button on Organization Information page
			If of.webButtonClicker("editVendorDetailForm:editVendorCancelButton") = True Then
			    Reporter.ReportEvent micPass, "Organization Information Page is displayed and cancel button is clicked", "Passed"
			Else
				Reporter.ReportEvent micFail, "Organization Information Page is displayed and cancel button is clicked", "Failed"
			End If
			
		'Verify that Org Management page is displayed
			Wait(8)
			 If  of.WebTableStatus (Webtable_htmlprop) = "active"	Then
				Reporter.ReportEvent micPass, "Org Management Page is displayed", "Passed"
			 else
				Reporter.ReportEvent micFail, "Org Management Page is not displayed", "Failed"
			 End If
		 Services.EndTransaction "OrgMgmt"  ' Timer end
	End Function
	
	'<@comments>	
	'***************************************************************************************************************************
	Public Function IntkVal_BtnValidations(ByVal Webtable_htmlprop)
	'**********************************************************************************************************************************
	'Purpose: Verify  whether the Itake validations page is displayed and all the buttons are enabled as expected
	'  Parameters: Nothing
	'Returns: True or False
	'Requires: Environment Variable "BROWSER_OBJ" has been initialized/created
	'Usage: util.IntkVal_BtnValidations( )
	'Created by: Sujatha Kandikonda 03/29 /2011
	'*****************************************************************************************************************************************
		Services.StartTransaction "IntkVal_BtnValidations" ' Timer start
		Dim INT_Esc_btn_htmlprop,INT_Rej_btn_htmlprop,INT_Save_btn_htmlprop,INT_SaveExit_btn_htmlprop,INT_Accept_btn_htmlprop,INT_Cancel_btn_htmlprop,Intkval_array
		Dim oAppBrowser
		Set oAppBrowser = Environment("BROWSER_OBJ")
		
	'Click on Intake Validation tab
		If  of.webElementClicker("barCodeTabLabel") = True Then
			Reporter.ReportEvent micPass, "IntkVal_BtnValidations --> Click Intake Tab","Intake Tab is available and Performed Click action"
			Wait(2)
			Call ajaxSync.ajaxSyncRequest("Processing Request",180)
			Browser(oAppBrowser).Sync
		Else
			Reporter.ReportEvent micFail, "IntkVal_BtnValidations --> Click Intake Tab","Unable to perform Click on Intake Tab, Which is Not as Expected"
		End If
			
    'Verify that Intake Validation page is displayed
		 If  util.ValidatePage_Title ("intakeReviewintakeReviewDecisionForm:intakeReviewintakeReviewDecisionLbl","Intake Decisions") = TRUE	Then
			Reporter.ReportEvent micPass, "IntkVal_BtnValidations --> Verify Intake Tab", "Intake Tab is active on screen, as Expected"
		 Else
			Reporter.ReportEvent micFail, "IntkVal_BtnValidations --> Verify Intake Tab", "Intake Tab is Not shown on screen, Which is NOT as Expected"
		 End If
			 
		'Verify that Action buttons are enabled in the Intake validation page
		INT_Esc_btn_htmlprop = "intakeReviewintakeReviewDecisionForm:intReviewEscalateButton"
		INT_Rej_btn_htmlprop = "intakeReviewintakeReviewDecisionForm:intReviewRejectButton"
		INT_Save_btn_htmlprop = "intakeReviewintakeReviewDecisionForm:intReviewPendButton"
		INT_SaveExit_btn_htmlprop ="intakeReviewintakeReviewDecisionForm:intReviewSaveButton"
		INT_Accept_btn_htmlprop =  "intakeReviewintakeReviewDecisionForm:intReviewAcceptButton"
		INT_Cancel_btn_htmlprop = "intakeReviewintakeReviewDecisionForm:intakeReviewintReviewCancelButton"
		Intkval_array = Array(INT_Esc_btn_htmlprop ,INT_Rej_btn_htmlprop,INT_Save_btn_htmlprop,INT_SaveExit_btn_htmlprop,INT_Accept_btn_htmlprop,INT_Cancel_btn_htmlprop)
		If  util.Actionbtn_Validation (Intkval_array) = True Then
			IntkVal_BtnValidations = TRUE
		Else
			IntkVal_BtnValidations = FALSE
		End If
			
		'Click on Cancel button
		If  of.webButtonClicker (INT_Cancel_btn_htmlprop)  = True Then		
			Reporter.ReportEvent micPass, "IntkVal_BtnValidations --> Click Cancel Button","Performed Click on Cancel Button in Intake Tab as Expected"
			Wait(2)
			'Click on Confirm button
			If of.webButtonClicker ("intakeConfirmCancelModalPanelForm:intakeConfirmCancelModalPanelConfirmButton") = TRUE Then
				Reporter.ReportEvent micPass, "IntkVal_BtnValidations --> Click Confirm Button","Performed Click on Cancel --> Confirm Button in Intake Tab as Expected"
			Else
				Reporter.ReportEvent micFail, "IntkVal_BtnValidations --> Click Confirm Button","Unable to perform Click on Cancel --> Confirm Button in Intake Tab, NOT as Expected"
			End If
		Else
			Reporter.ReportEvent micFail, "IntkVal_BtnValidations --> Click Cancel Button","Unable to perform Click on Cancel Button in Intake Tab, NOT as Expected"
		End If
		
		Set oAppBrowser =Nothing
		Services.EndTransaction "IntkVal_BtnValidations"  ' Timer end	
	End Function
	
	'<@comments>	
	'***************************************************************************************************************************
	Public Function CodeReview_BtnValidations(ByVal Webtable_htmlprop)
	'**********************************************************************************************************************************
	'Purpose: Verify  whether the Code Review  page is displayed and all the buttons are enabled as expected
	'Parameters: Nothing
	'Returns: True or False
	'Requires: Environment Variable "BROWSER_OBJ" has been initialized/created
	'Usage: util.CodeReview_BtnValidations ("j_id348_shifted")
	'Created by: Sujatha Kandikonda 03/29 /2011
	'*****************************************************************************************************************************************
		Services.StartTransaction "CodeReview_BtnValidations" ' Timer start		
		Dim CR_Esc_btn_htmlprop, CR_Rej_btn_htmlprop, CR_SaveExit_btn_htmlprop, CR_Accept_btn_htmlprop, CR_Cancel_btn_htmlprop, CodRev_array
		Dim oAppBrowser
		Set oAppBrowser = Environment("BROWSER_OBJ")' Setting local variable to the function to Use Environment Variable Browser Object Value
		
	'Click on Code Review tab
		If  of.webElementClicker ("codeReviewTabLabel") = True Then
			Reporter.ReportEvent micPass, "CodeReview_BtnValidations --> Click Code Review Tab","Code Review Tab is available and Performed Click action"
			Call ajaxSync.ajaxSyncRequest("Processing Request",60)
			Browser(oAppBrowser).Sync
		Else
			Reporter.ReportEvent micFail, "CodeReview_BtnValidations --> Click Code Review Tab","Unable to perform Click on Code Review Tab, Which is Not as Expected"
		End If
		
	'Verify that Code Review page is displayed
		If util.ValidatePage_Title ("codeReviewDecisionForm:codeReviewDecisionLbl","Coding Decisions") = TRUE	Then
			Reporter.ReportEvent micPass, "CodeReview_BtnValidations --> Verify Code Review Tab", "Code Review Tab is active on screen, as Expected"
		Else
			Reporter.ReportEvent micFail, "CodeReview_BtnValidations --> Verify Code Review Tab", "Code Review Tab is Not shown on screen, Which is NOT as Expected"
		End If
		
	'Verify that Action buttons are enabled in the Coding page
		CR_Esc_btn_htmlprop = "codeReviewDecisionForm:codeReviewEscalateButton"
		CR_Rej_btn_htmlprop = "codeReviewDecisionForm:codeReviewRejectButton"
		CR_SaveExit_btn_htmlprop = "codeReviewDecisionForm:codeReviewSaveButton"
		CR_Accept_btn_htmlprop = "codeReviewDecisionForm:codeReviewAcceptButton"
		CR_Cancel_btn_htmlprop = "codeReviewDecisionForm:codeReviewCancelButton"
		CodRev_array = Array(CR_Esc_btn_htmlprop,CR_Rej_btn_htmlprop,CR_SaveExit_btn_htmlprop,CR_Accept_btn_htmlprop)

		If util.Actionbtn_Validation (CodRev_array) = True Then
			CodeReview_BtnValidations = TRUE
		Else
			CodeReview_BtnValidations = FALSE
		End If

	'Click on Cancel button			
		If of.webButtonClicker (CR_Cancel_btn_htmlprop) = True  Then
			Reporter.ReportEvent micPass, "CodeReview_BtnValidations --> Click Cancel Button","Performed Click on Cancel Button in Code Review Tab as Expected"
			Wait(2)
			'Click on Confirm button
			If  of.webButtonClicker ("codeReviewConfirmCancelModalPanelForm:codeReviewConfirmCancelModalPanelConfirmButton")  = True Then		
				Reporter.ReportEvent micPass, "CodeReview_BtnValidations --> Click Confirm Button","Performed Click on Cancel --> Confirm Button in Code Review Tab as Expected"
			Else
				Reporter.ReportEvent micFail, "CodeReview_BtnValidations --> Click Confirm Button","Unable to perform Click on Cancel --> Confirm Button in Code Review Tab, NOT as Expected"
			End If
		Else
			Reporter.ReportEvent micFail, "CodeReview_BtnValidations --> Click Cancel Button","Unable to perform Click on Cancel Button in Code Review Tab, NOT as Expected"
		End If	
		
		Set oAppBrowser =Nothing
		Services.EndTransaction "CodeReview_BtnValidations"  ' Timer end	
	End Function					

	'<@comments>	
	'***************************************************************************************************************************
	Public Function CV_BtnValidations(ByVal Webtable_htmlprop)
	'**********************************************************************************************************************************
	'Purpose: Verify  whether the Claims Verification  page is displayed and all the buttons are enabled as expected
	'  Parameters: Nothing
	'Returns: True or False
	'Requires: Environment Variable "BROWSER_OBJ" has been initialized/created
	'Usage:  Call CV_BtnValidations("j_id597_shifted")
	'Created by: Sujatha Kandikonda 03/29 /2011
	'*****************************************************************************************************************************************
		Services.StartTransaction "CV_BtnValidations" ' Timer start
		Dim CV_Esc_btn_htmlprop, CV_Pend_btn_htmlprop, CV_SaveExit_btn_htmlprop, CV_Accept_btn_htmlprop, CV_Cancel_btn_htmlprop, CV_UnMatch_btn_htmlprop, CV_array
		Dim oAppBrowser
		Set oAppBrowser = Environment("BROWSER_OBJ")' Setting local variable to the function to Use Environment Variable Browser Object Value
		
	'Click on Code Review tab
		If  of.webElementClicker ("claimsVerifyTabLabel") = True Then
			Reporter.ReportEvent micPass, "CV_BtnValidations --> Click Claims Verification Tab","Claims Verification Tab is available and Performed Click action"
			Wait(2)
			Call ajaxSync.ajaxSyncRequest("Processing Request",180)
			Browser(oAppBrowser).Sync
		Else
			Reporter.ReportEvent micFail, "CV_BtnValidations --> Click Claims Verification Tab","Unable to perform Click on Claims Verification Tab, Which is Not as Expected"
		End If
		
	'Verify that Claims Verification page is displayed
		If  Instr(1, of.WebTableStatus (Webtable_htmlprop), "active", 1) > 0 Then
			Reporter.ReportEvent micPass, "CV_BtnValidations --> Tab Status","Claims Verification Tab is 'ACTIVELY' displayed as Expected"
		Else
			Reporter.ReportEvent micFail, "CV_BtnValidations --> Tab Status","Claims Verification Tab status is '"& of.WebTableStatus (Webtable_htmlprop) &"' instead of 'ACTIVE', which is NOT as Expected"
		End If
		
	'Verify that Action buttons are enabled in the Calims Verification page
		CV_UnMatch_btn_htmlprop = "cvMainForm1:CVUnMatchButton"
		CV_Esc_btn_htmlprop = "cvMainForm1:claimVerifyEscalateButton"
		CV_Pend_btn_htmlprop = "cvMainForm1:cvPendConfirmButton"
		CV_SaveExit_btn_htmlprop ="cvMainForm1:claimsVerifySaveButton"
		CV_Accept_btn_htmlprop =  "cvMainForm1:claimVerifyAcceptButton"
		CV_Cancel_btn_htmlprop = "cvMainForm1:cvReviewCancelButton"
		CV_array = Array(CV_Esc_btn_htmlprop ,CV_Pend_btn_htmlprop,CV_SaveExit_btn_htmlprop,CV_Accept_btn_htmlprop,CV_Cancel_btn_htmlprop )
		
		If  util.Actionbtn_Validation (CV_array) = True Then
			CV_BtnValidations = TRUE
		Else
			CV_BtnValidations = FALSE
		End If
		
	'Click on Cancel button
		If of.webButtonClicker (CV_Cancel_btn_htmlprop) = True Then
			Reporter.ReportEvent micPass, "CV_BtnValidations --> Click Cancel Button","Performed Click on Cancel Button in Claims Verification Tab as Expected"
			Wait(2)
		
		'Click on Confirm button
			If of.webButtonClicker ("claimsVerifyConfirmCancelModalPanelForm:claimsVerifyConfirmCancelModalPanelConfirmButton") = True  Then
				Reporter.ReportEvent micPass, "CV_BtnValidations --> Click Confirm Button","Performed Click on Cancel --> Confirm Button in Claims Verification Tab as Expected"
			Else
				Reporter.ReportEvent micFail, "CV_BtnValidations --> Click Confirm Button","Unable to perform Click on Cancel --> Confirm Button in Claims Verification Tab, NOT as Expected"
			End If
		Else
			Reporter.ReportEvent micFail, "CV_BtnValidations --> Click Cancel Button","Unable to perform Click on Cancel Button in Claims Verification Tab, NOT as Expected"
		End If
		
		Set oAppBrowser =Nothing
		Services.EndTransaction "CV_BtnValidations"  ' Timer end	
	End Function
	
	'<@comments>	
	'***************************************************************************************************************************				
	Public Function QA_BtnValidations(ByVal Webtable_htmlprop)
	'**********************************************************************************************************************************
	'Purpose: Verify  whether the QA  page is displayed and all the buttons are enabled as expected
	'  Parameters: Nothing
	'Returns: True or False
	'Requires: Environment Variable "BROWSER_OBJ" has been initialized/created
	'Usage: Call util.QA_BtnValidations("j_id951_shifted")
	'Created by: Sujatha Kandikonda 03/29 /2011
	'*****************************************************************************************************************************************
	Services.StartTransaction "QA_BtnValidations" ' Timer start
		Dim QA_Esc_btn_htmlprop, QA_SaveExit_btn_htmlprop, QA_Pend_btn_htmlprop, QA_Accept_btn_htmlprop, QA_Cancel_btn_htmlprop, QA_array
		Dim oAppBrowser
		Set oAppBrowser = Environment("BROWSER_OBJ")' Setting local variable to the function to Use Environment Variable Browser Object Value
		
	'Click on Quality Assurance tab
		If  of.webElementClicker ("qaReviewTabLabel") = True Then
			Reporter.ReportEvent micPass, "QA_BtnValidations --> Click QA Tab","QA Tab is available and Performed Click action"
			Wait(2)
			Call ajaxSync.ajaxSyncRequest("Processing Request",180)
			Browser(oAppBrowser).Sync
		Else
			Reporter.ReportEvent micFail, "QA_BtnValidations --> Click QA Tab","Unable to perform Click on QA Tab, Which is Not as Expected"
		End If
		
	'Verify that QA page is displayed
		If  Instr(1, of.WebTableStatus (Webtable_htmlprop), "active", 1) > 0 Then
			Reporter.ReportEvent micPass, "QA_BtnValidations --> Tab Status","QA is 'ACTIVELY' displayed as Expected"
		Else
			Reporter.ReportEvent micFail, "QA_BtnValidations --> Tab Status","QA status is '"& of.WebTableStatus (Webtable_htmlprop) &"' instead of 'ACTIVE', which is NOT as Expected"
		End If
		
	'Verify that Action buttons are enabled in the QA  page
		QA_Esc_btn_htmlprop = "qaReviewDecisionForm:qaReviewEscalateButton"
		QA_SaveExit_btn_htmlprop ="qaReviewDecisionForm:qaReviewSaveButton"
		QA_Pend_btn_htmlprop = "qaReviewDecisionForm:qaReviewPendButton"
		QA_Accept_btn_htmlprop =  "qaReviewDecisionForm:qaReviewAcceptButton"
		QA_Cancel_btn_htmlprop = "qaReviewDecisionForm:qaReviewCancelButton"
		QA_array = Array(QA_Esc_btn_htmlprop,QA_SaveExit_btn_htmlprop,QA_Pend_btn_htmlprop ,QA_Accept_btn_htmlprop ,QA_Cancel_btn_htmlprop )
		
		If util.Actionbtn_Validation (QA_array ) = True Then
			QA_BtnValidations = TRUE
		Else
			QA_BtnValidations = FALSE
		End If
			
	'Click on Cancel button
		If  of.webButtonClicker (QA_Cancel_btn_htmlprop) = True Then
			Reporter.ReportEvent micPass, "QA_BtnValidations --> Click Cancel Button","Performed Click on Cancel Button in QA Tab as Expected"
			wait(2)
		
		'Click on Confirm button
			If  of.webButtonClicker ("qaReviewConfirmCancelModalPanelForm:qaReviewConfirmCancelModalPanelConfirmButton") = True Then
				Reporter.ReportEvent micPass, "QA_BtnValidations --> Click Confirm Button","Performed Click on Cancel --> Confirm Button in QA Tab as Expected"
			Else
				Reporter.ReportEvent micFail, "QA_BtnValidations --> Click Confirm Button","Unable to perform Click on Cancel --> Confirm Button in QA Tab, NOT as Expected"
			End If
		Else
			Reporter.ReportEvent micFail, "QA_BtnValidations --> Click Cancel Button","Unable to perform Click on Cancel Button in QA Tab, NOT as Expected"
		End If			
		
		Set oAppBrowser =Nothing
		Services.EndTransaction "QA_BtnValidations"  ' Timer end
	End Function	
	
	'<@comments>	
	'***************************************************************************************************************************	
    Public Function Profile_BtnValidations(ByVal Webtable_htmlprop)
    '**********************************************************************************************************************************
	'Purpose: Verify  whether the Profile is displayed and all the buttons are enabled as expected
	'Parameters: Nothing
	'Returns: True or False
	'Requires: Environment Variable "BROWSER_OBJ" has been initialized/created
	'Usage:  util.Profile_BtnValidations( "j_id1624_shifted")
	'Created by: Sujatha Kandikonda 03/29 /2011
	'*****************************************************************************************************************************************
		Services.StartTransaction "Profile_BtnValidations" ' Timer start
		Dim updateProfileBtn_htmlprop, ChngPWBtn_htmlprop, Ref_htmlprop, Profilebtns_array, cnt
		Dim oAppBrowser
		Set oAppBrowser = Environment("BROWSER_OBJ")' Setting local variable to the function to Use Environment Variable Browser Object Value

	'Click on Profile
		If of.webElementClicker ("profileTabLabel") = True Then
			Reporter.ReportEvent micPass, "Profile_BtnValidations --> Click Profile Tab","Profile Tab is available and Performed Click action"
			Wait(2)
			Call ajaxSync.ajaxSyncRequest("Processing Request",180)
			Browser(oAppBrowser).Sync
		Else
			Reporter.ReportEvent micFail, "Profile_BtnValidations --> Click Profile Tab","Unable to perform Click on Profile Tab, Which is Not as Expected"
		End If
		
    'Verify that Profile page is displayed
		If  Instr(1, of.WebTableStatus (Webtable_htmlprop), "active", 1) > 0 Then
			Reporter.ReportEvent micPass, "Profile_BtnValidations --> Tab Status","Profile Tab is 'ACTIVELY' displayed as Expected"
		Else
			Reporter.ReportEvent micFail, "Profile_BtnValidations --> Tab Status","Profile Tab status is '"& of.WebTableStatus (Webtable_htmlprop) &"' instead of 'ACTIVE', which is NOT as Expected"
		End If
		
	'Verify that Action buttons are enabled in the Profile page
		updateProfileBtn_htmlprop ="epForm:epcmdBtn1"
		ChngPWBtn_htmlprop ="passwdForm:cmdBtn2"
		Ref_htmlprop = "epForm:resetBtn"
		Profilebtns_array = Array(updateProfileBtn_htmlprop,ChngPWBtn_htmlprop,Ref_htmlprop)
		
		If util.Actionbtn_Validation(Profilebtns_array) = True Then
			Profile_BtnValidations = TRUE
		Else
			Profile_BtnValidations = FALSE
		End If
	
	  'Verify the edit fields in Profile page are displayed as expected
		Call of.webEditFinder("epForm:epfirstNameValue")
		Call of.webEditFinder("epForm:eplastNameValue")
		Call of.webEditFinder("epForm:epemailValue")
		Call of.webEditFinder("epForm:epdobValueInputDate")
		Call of.webEditFinder("epForm:epssnValue")
		Call of.webEditFinder("epForm:epsecurityQuestionValue")
		Call of.webEditFinder("epForm:epsecurityAnswerValue")
		Call of.webEditFinder("passwdForm:newPdValue")
		Call of.webEditFinder("passwdForm:confPdValue")
					
		Set oAppBrowser =Nothing
		Services.EndTransaction "Profile_BtnValidations"  ' Timer end	
	End Function
	
	'<@comments>	
'***************************************************************************************************************************	
	Public Function QAReview_BtnValidations(ByVal Webtable_htmlprop)
'**********************************************************************************************************************************
	'Purpose: Verify  whether the QA Review  page is displayed and all the buttons are enabled as expected
	'Parameters: Nothing
	'Returns: True or False
	'Requires: Environment Variable "BROWSER_OBJ" has been initialized/created
	'Usage:  	Call QAReview_BtnValidations("j_id1259_shifted")
	'Created by: Sujatha Kandikonda 03/29/2011
	'Modified by: Govardhan Choletti 03/19/2013
	'			  QA Review Screen got modified with New Look and Cancel Button Changed to Exit Button
'*****************************************************************************************************************************************
		Services.StartTransaction "QAReview_BtnValidations" ' Timer start
		Dim QAREview_EditFields
		Dim oAppBrowser
		Set oAppBrowser = Environment("BROWSER_OBJ")' Setting local variable to the function to Use Environment Variable Browser Object Value
		
    'Click on QA Review tab
		If of.webElementClicker ("qaAuditorTabTabLabel") = True Then
			Reporter.ReportEvent micPass, "QAReview_BtnValidations --> Click QA Review Tab","QA Review Tab is available and Performed Click action"
			Wait(2)
			Call ajaxSync.ajaxSyncRequest("Processing Request",180)
			Browser(oAppBrowser).Sync
		Else
			Reporter.ReportEvent micFail, "QAReview_BtnValidations --> Click QA Review Tab","Unable to perform Click on QA Review Tab, Which is Not as Expected"
		End If
		
	'Verify that QA Review page is displayed
		If  Instr(1, of.WebTableStatus (Webtable_htmlprop), "active", 1) > 0 Then
			Reporter.ReportEvent micPass, "QAReview_BtnValidations --> Tab Status","QA Review Tab is 'ACTIVELY' displayed as Expected"
		Else
			Reporter.ReportEvent micFail, "QAReview_BtnValidations --> Tab Status","QA Review Tab status is '"& of.WebTableStatus (Webtable_htmlprop) &"' instead of 'ACTIVE', which is NOT as Expected"
		End If	
		
	 'Verify  that QA Review page is editable
		QAREview_EditFields =Array ("qaManageReviewForm:qaReviewCoderValueIT", "qaManageReviewForm:qaReviewAuditorValueIT")
		If util.EditPage_Validation(QAREview_EditFields) = "active" Then
			QAReview_BtnValidations = TRUE
		Else 
			QAReview_BtnValidations = FALSE
		End If
	  
	 'Click on Exit button
		If of.webButtonClicker ("qaManageReviewForm:qaReviewCancelButtonId") = True Then
			Reporter.ReportEvent micPass, "QAReview_BtnValidations --> Click Exit Button","Performed Click on Exit Button in QA Review Tab as Expected"
		Else
			Reporter.ReportEvent micFail, "QAReview_BtnValidations --> Click Exit Button","Unable to perform Click on Exit Button in QA Review Tab, NOT as Expected"
		End If
		
	'Verify Home page is displayed
		wait(2)
		If of.webElementFinder("manageHomeTabLabel") = True Then
			Reporter.ReportEvent micPass, "QAReview_BtnValidations --> Verify Home Page","Home page is displayed on screen as Expected"
		Else
			Reporter.ReportEvent micFail, "QAReview_BtnValidations --> Verify Home Page","Home page is NOT displayed on screen, NOT as Expected"
		End If
			
		Set oAppBrowser = Nothing
		Services.EndTransaction "QAReview_BtnValidations"  ' Timer end
	End Function
	
	'<@comments>	
	'***************************************************************************************************************************	
	Public Function CVQA_BtnValidations(ByVal Webtable_htmlprop)
	'**********************************************************************************************************************************
	'Purpose: Verify  whether the QA  page is displayed and all the buttons are enabled as expected
	'  Parameters: Nothing
	'Returns: True or False
	'Requires: Environment Variable "BROWSER_OBJ" has been initialized/created
	'Usage: Call util.QA_BtnValidations("j_id951_shifted")
	'Created by: Sujatha Kandikonda 03/29 /2011
	'*****************************************************************************************************************************************
		Services.StartTransaction "CVQA_BtnValidations" ' Timer start	
		Dim CVQA_Esc_btn_htmlprop, CVQA_SaveExit_btn_htmlprop, CVQA_Pend_btn_htmlprop, CVQA_Accept_btn_htmlprop, CVQA_Cancel_btn_htmlprop, CVQA_array
		Dim oAppBrowser
		Set oAppBrowser = Environment("BROWSER_OBJ")' Setting local variable to the function to Use Environment Variable Browser Object Value

	'Click on CVQA tab
		If  of.webElementClicker ("cvQaTabLabel") = True Then
			Reporter.ReportEvent micPass, "CVQA_BtnValidations --> Click CVQA Tab","CVQA Tab is available and Performed Click action"
			Wait(2)
			Call ajaxSync.ajaxSyncRequest("Processing Request",180)
			Browser(oAppBrowser).Sync
		Else
			Reporter.ReportEvent micFail, "CVQA_BtnValidations --> Click CVQA Tab","Unable to perform Click on CVQA Tab, Which is Not as Expected"
		End If
		
	'Verify that CVQA page is displayed
		If  Instr(1, of.WebTableStatus (Webtable_htmlprop), "active", 1) > 0 Then
			Reporter.ReportEvent micPass, "CVQA_BtnValidations --> Tab Status","CVQA Tab is 'ACTIVELY' displayed as Expected"
		Else
			Reporter.ReportEvent micFail, "CVQA_BtnValidations --> Tab Status","CVQA Tab status is '"& of.WebTableStatus (Webtable_htmlprop) &"' instead of 'ACTIVE', which is NOT as Expected"
		End If
		
	'Verify that Action buttons are enabled in the QA  page
		CVQA_Esc_btn_htmlprop = "cvqaMainForm1:cvqaEscalateButton"
		CVQA_SaveExit_btn_htmlprop = "cvqaMainForm1:cvqaSaveButton"
		CVQA_Pend_btn_htmlprop ="cvqaMainForm1:cvqaPendConfirmButton"
		CVQA_Accept_btn_htmlprop = "cvqaMainForm1:cvqaAcceptButton"
		CVQA_Cancel_btn_htmlprop =  "cvqaMainForm1:cvqaReviewCancelButton"
		CVQA_array = Array(CVQA_Esc_btn_htmlprop,CVQA_SaveExit_btn_htmlprop,CVQA_Pend_btn_htmlprop,CVQA_Accept_btn_htmlprop ,CVQA_Cancel_btn_htmlprop)
		
		If util.Actionbtn_Validation (CVQA_array ) = True Then
			CVQA_BtnValidations = TRUE
		Else
			CVQA_BtnValidations = FALSE
		End If
			
	'Click on Cancel button
		If  of.webButtonClicker (CVQA_Cancel_btn_htmlprop) = True Then
			Reporter.ReportEvent micPass, "CVQA_BtnValidations --> Click Cancel Button","Performed Click on Cancel Button in CVQA Tab as Expected"
			Wait(2)
			
			'Click on Confirm button
			If of.webButtonClicker ("cvqaConfirmCancelModalPanelForm:cvqaConfirmCancelModalPanelConfirmButton") = True Then
				Reporter.ReportEvent micPass, "CVQA_BtnValidations --> Click Confirm Button","Performed Click on Cancel --> Confirm Button in CVQA Tab as Expected"
			Else
				Reporter.ReportEvent micFail, "CVQA_BtnValidations --> Click Confirm Button","Unable to perform Click on Cancel --> Confirm Button in CVQA Tab, NOT as Expected"
			End If
		Else
			Reporter.ReportEvent micFail, "CVQA_BtnValidations --> Click Cancel Button","Unable to perform Click on Cancel Button in CVQA Tab, NOT as Expected"
		End If
		
		Set oAppBrowser = Nothing
		Services.EndTransaction "CVQA_BtnValidations"  ' Timer end
	End Function
	
	'<@comments>	
'***************************************************************************************************************************	
	Public Function CVQA_Review_BtnValidations(ByVal Webtable_htmlprop)
'**********************************************************************************************************************************
	'Purpose: Verify  whether the QA Review  page is displayed and all the buttons are enabled as expected
	' Parameters: Nothing
	'Returns: True or False
	'Requires: Environment Variable "BROWSER_OBJ" has been initialized/created
	'Usage:  	Call util.CVQA_Review_BtnValidations("j_id1508_shifted")
	'Created by: Sujatha Kandikonda 05/20/2011
	'Modified by: Govardhan Choletti 03/19/2013
	'			  CVQA Review Screen got modified with New Look and Cancel Button Changed to Exit Button
'*****************************************************************************************************************************************
		Services.StartTransaction "CVQA_Review_BtnValidations" ' Timer start
		Dim oAppBrowser
		Set oAppBrowser = Environment("BROWSER_OBJ")' Setting local variable to the function to Use Environment Variable Browser Object Value

   'Click on CVQA Review tab
		If of.webElementClicker ("claimsVerifyQARevuewTabLabel") = True Then
			Reporter.ReportEvent micPass, "CVQA_Review_BtnValidations --> Click CVQA Review Tab","CVQA Review Tab is available and Performed Click action"
			Wait(2)
			Call ajaxSync.ajaxSyncRequest("Processing Request",180)
			Browser(oAppBrowser).Sync
		Else
			Reporter.ReportEvent micFail, "CVQA_Review_BtnValidations --> Click CVQA Review Tab","Unable to perform Click on CVQA Review Tab, Which is Not as Expected"
		End If
		
	'Verify that CVQA Review page is displayed
		If  of.WebTableStatus (Webtable_htmlprop) = "active"	Then
			CVQA_Review_BtnValidations = True
		Else
			CVQA_Review_BtnValidations = False
		End If
		
	 'Click on Exit button
		If of.webButtonClicker ("cvqaManageReviewForm:cvqaReviewCancelButtonId") = True Then
			Reporter.ReportEvent micPass, "CVQA_Review_BtnValidations --> Click Cancel Button","Performed Click on Cancel Button in CVQA Review Tab as Expected"
			Wait(2)
		Else
			Reporter.ReportEvent micFail, "CVQA_Review_BtnValidations --> Click Cancel Button","Unable to perform Click on Cancel Button in CVQA Review Tab, NOT as Expected"
		End If
		
	'Verify Home page is displayed
		If  of.webElementFinder("manageHomeTabLabel") = True  Then
			Reporter.ReportEvent micPass, "CVQA_Review_BtnValidations --> Verify Home page","Home page is displayed on screen, as Expected"
		Elseif of.webElementClicker("manageHomeTabLabel") = False  Then
			Reporter.ReportEvent micFail, "CVQA_Review_BtnValidations --> Verify Home page","Home page is NOT displayed on screen, NOT as Expected"
		End If
		
		Set oAppBrowser = Nothing
		Services.EndTransaction "CVQA_Review_BtnValidations"  ' Timer end
	End Function
	
	'<@comments>	
	'***************************************************************************************************************************	
	Public Function WebList_Validation (Byval HTMLID_Property, WeblistItemsArray )
	'**********************************************************************************************************************************
	'Purpose: Verify  whether the web list contains the array of items
	'Parameters: HTMLID_Property =  HTML property of the weblist
	'Web_listItemsArray  = Array of HTLML properties of Web list items							
	'Returns: True/False
	'Requires: Environment Variable "BROWSER_OBJ" has been initialized/created
	'Usage: btnstatus = util. WebList_Validation ("commonSearchForm:projectStatusSearchValueList",WeblistItemsArray)
	'Created by: Sujatha Kandikonda 04/12/2011
	'*************************************************************************************************************************************
	Services.StartTransaction " WebList_Validation" ' Timer start	
		Dim oAppBrowser,oAppObj,WebList_cnt, ValidateArr, WebButtonStatus, allitems, Weblist_ItemsArray, i
		Set oAppBrowser = Browser(Environment("BROWSER_OBJ"))
		'Sets the object for weblist
		Set oAppObj = Description.Create()
		oAppObj("micclass").Value = "WebList"
		oAppObj("html id").Value =  HTMLID_Property
		WebList_cnt = Ubound(WeblistItemsArray)

	'Validate whether the action buttons are enabled
		For i = 0 to WebList_cnt 
			ValidateArr = WeblistItemsArray(i)
			If oAppBrowser.WebList("html id:=" &HTMLID_Property).Exist(2) Then
				WebButtonStatus= "exist"	
				Reporter.ReportEvent micPass, "Web List", "Web List exists"
				allitems=  oAppBrowser.WebList("html id:=" &HTMLID_Property).GetROProperty("all items")
				If Instr(allitems, ValidateArr )>0 Then
				   WebList_Validation = True 'returns the value
				   Reporter.ReportEvent micPass, "WebList_Validation", "Web List contains '"&ValidateArr&"'"
				Else
					WebList_Validation = False 'returns the value
					Reporter.ReportEvent micFail, "WebList_Validation", "Web List does not contain '"&ValidateArr&"'"
				End If			
			Else
				WebButtonStatus= "not exist"	'return value
				Reporter.ReportEvent micFail, "Web List", "Web List does not exist"
			End If
		Next
		
	' Clear Object Variables
		Set oAppBrowser = Nothing
		Set oAppObj = Nothing
		Set WebButtonStatus = Nothing
		Set allitems = Nothing
		Set ValidateArr = Nothing
		Set WebList_cnt = Nothing
		Set Weblist_ItemsArray = Nothing
		Set i = Nothing
	Services.EndTransaction " WebList_Validation" ' Timer end
	End Function		

	'<@comments>	
'***************************************************************************************************************************	
	Public Function Click_Projectsubtabmenuoptions( )
'***********************************************************************************************************
	'Purpose: Click on each Project Id dropdown menu options under Project sub tab and validate the correct page is displayed. Validate for all the dropdown menu
	'					option
	'Parameters: Nothing
	'Returns: Nothing
	'Requires: Environment Variable "BROWSER_OBJ" has been initialized/created
	'Usage: util.Click_Project subtabmenuoptions()
	'Created by: Sujatha Kandikonda 04/22/2011
	'***********************************************************************************************************
	Services.StartTransaction "Click_Projectsubtabmenuoptions" ' Timer start
	
	' Variable Declaration / Initialization
		Dim oAppBrowser, oAppObj,ImageHTMLProperty
		
	'sets the browser object.
	  	Set oAppBrowser = Browser(Environment("BROWSER_OBJ"))' Setting local variable to the function to Use Environment Variable Browser Object Value
        ImageHTMLProperty = "projectForm:projectTable:0:pic1"
		
	'Setting the object properties for the Image Object
		Set oAppObj = Description.Create()
		oAppObj("micclass").Value = "Image"
		oAppObj("html id").Value = ImageHTMLProperty
		
	'Hover on Image
		If  oAppBrowser.Image(oAppObj).Exist(2) Then
			'Hover over the image
			oAppBrowser.Image(oAppObj).FireEvent "onmouseover"
			oAppBrowser.Image(oAppObj).FireEvent "click"
		End If
		
	'Click on project from Project Id menu list
		of.webElementClicker "projectForm:projectTable:0:editProjectDetail"
		wait(2)
	'Validate the Project information page title
		util.ValidatePage_Title "editProjectDetailForm:editProjectHeaderLabel","Project Information"
	'Click on Cancel on Project Information page
		of.webElementClicker "editProjectDetailForm:cancelButton"
	'Click on provider  from Project Id menu list
		of.webElementClicker "projectForm:projectTable:0:findProvider"
	'back to project  sub tab
		of.webElementClicker "activeProjectTabLabel"
		of.webElementClicker "projectForm:projectTable:0:findCharts"
	'back to project  sub tab
		of.webElementClicker "activeProjectTabLabel"
		
	' Clear Object Variables
		Set oAppBrowser = Nothing
		Set oAppObj = Nothing
		Set ImageHTMLProperty = Nothing		
	Services.EndTransaction "Click_Projectsubtabmenuoptions"  ' Timer end
	End Function 
	
	'<@comments>	
	'***************************************************************************************************************************	
	Public Function ValidatePage_Title(sHTMLIDProperty, sInnertext)
	'***********************************************************************************************************
	'Purpose: Validate the Page title 															
	'Parameters: Webelement html Id property where the page title is displayed
	'						Innertext property or the webelement
	'Returns: Nothing
	'Requires: Environment Variable "BROWSER_OBJ" has been initialized/created
	'Usage: util.ValidatePage_Title(sHTMLIDProperty, sInnertext)
	'Created by: Sujatha Kandikonda 04/22/2011
	'***********************************************************************************************************
		Services.StartTransaction "ValidatePage_Title" ' Timer Begin
		Reporter.ReportEvent micDone, "ValidatePage_Title", "Function Begin"
		
		' Variable Declaration / Initialization
		Dim oAppBrowser, oAppObj, iTitle
		
		'object declarations/initializations.
		Set oAppBrowser = Browser(Environment("BROWSER_OBJ")) ' Setting local variable to the function to Use Environment Variable Browser Object Value
		
		Set oAppObj = Description.Create()
		oAppObj("MicClass").Value = "WebElement"
		oAppObj("html id").Value = sHTMLIDProperty
		
		'Verification of the Object 
		If oAppBrowser.WebElement(oAppObj).Exist(1) Then
			Reporter.ReportEvent micPass, "WebElement Exists", "Passed"
			iTitle =  oAppBrowser.WebElement(oAppObj).GetROProperty("innertext")
			If Instr(1, iTitle, sInnertext, 1) > 0 Then
				ValidatePage_Title = True
				Reporter.ReportEvent micPass, "ValidatePage_Title -> Tab Verification","Page with webElement data '"& iTitle &"' is displayed as Expected"
			Else
				ValidatePage_Title = False
				Reporter.ReportEvent micWarning, "ValidatePage_Title -> Tab Verification","Page with webElement data '"& iTitle &"' is different when compared to '"& sInnertext &"', NOT as Expected"
			End If
		Else
			Reporter.ReportEvent micFail, "ValidatePage_Title -> Tab Verification","Page with webElement data '"& sInnertext &"' doesn't Exist in application, NOT as Expected"
		End If
		
	' Clear Object Variables
		Set oAppBrowser = Nothing
		Set oAppObj = Nothing
		
		Reporter.ReportEvent micDone, "ValidatePage_Title", "Function End"
		Services.EndTransaction "ValidatePage_Title" ' Timer End
	End Function
   
	'<@comments>	
	'***************************************************************************************************************************	
	Public Function Subtab_menu_clicker (Image_HTMLProperty, ByVal sInnerTextOrHTMLIDProperty)
	'***********************************************************************************************************
	'Purpose: Click on the option from the sub tab menu list											
	'Parameters: Image html  property,  Html property of the menu option
	'Returns: Nothing
	'Requires: Environment Variable "BROWSER_OBJ" has been initialized/created
	'Usage: util.Subtab_menu_clicker ("projectForm:projectTable:0:pic1", "projectForm:projectTable:0:findCharts")
	'Created by: Sujatha Kandikonda 05/09/2011
	'***********************************************************************************************************
		Services.StartTransaction "Subtab_menu_clicker" ' Timer Begin
		Reporter.ReportEvent micDone, "Subtab_menu_clicker", "Function Begin"
		' Variable Declaration / Initialization
		Dim oAppBrowser, oAppObj
		'sets the browser object.
	  	Set oAppBrowser = Browser(Environment("BROWSER_OBJ"))' Setting local variable to the function to Use Environment Variable Browser Object Value

		'Setting the object properties for the Image Object
		Set oAppObj = Description.Create()
		oAppObj("micclass").Value = "Image"
		oAppObj("html id").Value = Image_HTMLProperty
		If  oAppBrowser.Image(oAppObj).Exist(2) Then
			'Hover over the image
			oAppBrowser.Image(oAppObj).FireEvent "onmouseover"
			oAppBrowser.Image(oAppObj).FireEvent "click"
			Wait (2)
			oAppBrowser.Sync
			Call ajaxSync.ajaxSyncRequest("Processing Request",60)
		End If
			
		'Click on the subtab menu option
		If  of.webElementClicker (sInnerTextOrHTMLIDProperty)= True  Then
			Subtab_menu_clicker = True
		Elseif of.webElementClicker (sInnerTextOrHTMLIDProperty)= False  Then
			Subtab_menu_clicker = False
		End If
		
		' Clear Object Variables
		Set oAppBrowser = Nothing
		Set oAppObj = Nothing
		
		Reporter.ReportEvent micDone, "Subtab_menu_clicker", "Function End"
		Services.EndTransaction "Subtab_menu_clicker" ' Timer End
	End Function
	
	'<@comments>	
	'***************************************************************************************************************************	
   	Public Function subtab_menuvalidation(Byval Image_HTMLProperty,subtabdropdown_menuoptions)
	'***********************************************************************************************************
	'Purpose: Validate whether the subtab menu items are displayed as expected
	'Parameters: Byval Image_HTMLProperty = Image on which the cursor need to be hovered on for the menu to be displayed
	'						subtabdropdown_menuoptions = Array of html properties for all the webelement items in the menu
	'Returns: string: enabled/disabled
	'Requires: Environment Variable "BROWSER_OBJ" has been initialized/created
	'Usage: util.subtab_menuvalidation("projectForm:projectTable:0:pic1",menu_htmlid)
	'Created by: Sujatha Kandikonda 04/12/2011
	'***********************************************************************************************************
   	Services.StartTransaction "subtab_menuvalidation" 	' Timer Begin
	Reporter.ReportEvent micDone, "subtab_menuvalidation", "Function Begin"
   	
	' Variable Declaration / Initialization
		Dim oAppBrowser, oAppObj, status, menuitem, cnt, i, Flag
   	'sets the browser object.ByVal sInnerTextOrHTMLIDPropertyByVal sInnerTextOrHTMLIDProperty
	  	Set oAppBrowser = Browser(Environment("BROWSER_OBJ"))' Setting local variable to the function to Use Environment Variable Browser Object Value

	'Setting the object properties for the Image Object
		Set oAppObj = Description.Create()
		oAppObj("micclass").Value = "Image"
		oAppObj("html id").Value = Image_HTMLProperty

		If oAppBrowser.Image(oAppObj).Exist(2) Then
			'Hover over the image
			oAppBrowser.Image(oAppObj).FireEvent "onmouseover"
			'oAppBrowser.Image(oAppObj).FireEvent "click"
			Wait 1
		End If
			
		cnt = Ubound(subtabdropdown_menuoptions)
		Flag = True
		For i = 0 to cnt
			menuitem = subtabdropdown_menuoptions(i)
			'Setting the object properties
			status = of.webElementStatus (menuitem)
			If Instr(1, status, "enabled", 1) > 0  Then
				Reporter.ReportEvent micDone, "subtab_menuvalidation => Menu validation" , menuitem &", shown on screen is enabled"
				Flag = True
			ElseIf Instr(1, status, "disabled", 1) > 0 Then
				Reporter.ReportEvent micDone, "subtab_menuvalidation => Menu validation" , menuitem &", shown on screen is disabled"
				Flag = False
			Else
				Reporter.ReportEvent micFail, "Menu Item" , menuitem &" is Not displayed on screen"
				Flag = False
			End If
		Next
		
		'report
		If Flag = True Then
			subtab_menuvalidation = True
		Elseif Flag = False Then
			subtab_menuvalidation = False
		End If
		
		' Clear Object Variables
		Set oAppBrowser = Nothing
		Set oAppObj = Nothing
		
		Reporter.ReportEvent micDone, "subtab_menuvalidation", "Function End"
		Services.EndTransaction "subtab_menuvalidation" ' Timer end
	End Function
	
	'<@comments>	
	'***************************************************************************************************************************	
	Public Function Get_ChartId ()
	'***********************************************************************************************************
	'Purpose: Get first chart Id from the search result	in data summary page					
	'Returns: First Chart Id
	'Requires: Environment Variable "BROWSER_OBJ" has been initialized/created
	'Usage: util. Get_ChartId ()
	'Created by: Sujatha Kandikonda 05/18/2011
	'***********************************************************************************************************
	' Variable Declaration / Initialization
		Services.StartTransaction "Get_ChartId" ' Timer Begin
		Reporter.ReportEvent micDone, "Get_ChartId", "Function Begin"

		Dim oAppBrowser, oAppObj, chartid, arr
		Set oAppBrowser = Browser(Environment("BROWSER_OBJ"))' Setting local variable to the function to Use Environment Variable Browser Object Value
		
		'Setting the object properties for the Webelement Object
		Set oAppObj = Description.Create()
		oAppObj("micclass").Value = "WebTable"
		oAppObj("html id").Value =  "chartForm:chartTable"
		If oAppBrowser.WebTable(oAppObj). Exist (1) Then
			Reporter.ReportEvent micPass,"Web Table exists" , "Passed"
			chartid = oAppBrowser.WebTable(oAppObj).GetCellData(2,1)
			arr = Split(chartid, "Chart")
			If  arr(0) <> "" Then
				Reporter.ReportEvent micPass,"Chart Id" , "Chart Id is "& arr (0) 
				Get_ChartId = arr(0)
			Else
				Reporter.ReportEvent micFail,"Chart Id" , "Chart Id id is not displayed. Please check"
				Get_ChartId = NULL
			End If
		Else
			Reporter.ReportEvent micFail,"Web Table does not exists" , "Failed"
		End If
			
		Reporter.ReportEvent micDone, "Get_ChartId", "Function End"
		Services.EndTransaction "Get_ChartId" ' Timer end
	End Function
	
	'<@comments>	
'***************************************************************************************************************************
	Function Mapping_PageValidation ()
'**********************************************************************************************************************************
	'Purpose: Verify  whether the Mapping page is displayed and all the buttons are displayed as expected
	'Parameters: Nothing
	'Returns: True or False
	'Requires: Environment Variable "BROWSER_OBJ" has been initialized/created
	'Usage:  	call util.Mapping_PageValidation()
	'Created by: Sujatha Kandikonda 05/23 /2011
'*****************************************************************************************************************************************
		Services.StartTransaction "Mapping_PageValidation" ' Timer start
		Reporter.ReportEvent micDone, "Mapping_PageValidation", "Function Begin"
  
		Dim oAppBrowser, Status
		Set oAppBrowser = Browser(Environment("BROWSER_OBJ"))
		
	 'Verify that Mapping page is displayed
		Call of.webElementFinder("Chart Mapping")
		
		'Verify  that  Target Chart Request ID is editable field
		Wait(4)
		If oAppBrowser.WebEdit("html id:=chartMappingForm:targetChartReqIdVal").Exist(2) Then
			Reporter.ReportEvent micPass, "WebEdit Exists", "Passed"
            Status=oAppBrowser.WebEdit("html id:=chartMappingForm:targetChartReqIdVal").GetROProperty("disabled")
			If Instr(1,Status,0,1) Then
				Reporter.ReportEvent micPass, "Target Chart Request ID", "Target Chart Request ID is an editable field"
			Else
				Reporter.ReportEvent micPass, "Target Chart Request ID", "Target Chart Request ID is not an editable field"
			End If			
		Else
		   Reporter.ReportEvent micFail, "WebEdit Exists", "Failed"
		End If
		
		'Verify that Reject button is displayed in the Mapping page
		If of.webButtonFinder("chartMappingForm:barcodeRejectButton") = True Then
			Reporter.ReportEvent micPass, "Reject button is displayed in the Mapping page", "Passed"
		Elseif of.webButtonFinder("chartMappingForm:barcodeRejectButton") = False Then
			Reporter.ReportEvent micPass, "Reject button is displayed in the Mapping page", "Failed"
		End If
		
		'Verify that Mapping button is displayed in the Mapping page
		If of.webButtonFinder("chartMappingForm:mapBtn") = True Then
			Reporter.ReportEvent micPass, "'Mapping' button is displayed in the Mapping page", "Passed"
			Mapping_PageValidation = TRUE
		Elseif of.webButtonFinder("chartMappingForm:mapBtn") = False Then
			Reporter.ReportEvent micPass, "'Mapping' button is displayed in the Mapping page", "Failed"
			Mapping_PageValidation = FALSE
		End If		
    
	'Click on Cancel button
		Call  of.webButtonClicker ("chartMappingForm:barcodeCancelButton")
	'Verify user is taken back to the Data Summary  page
		If of.webElementFinder("chartForm:chartTable:barcodeIdHdr")= True  Then
			Reporter.ReportEvent micPass,"Search results are displayed in Chart tab","Passed"
		Elseif of.webElementFinder("chartForm:chartTable:barcodeIdHdr")= False  Then
			Reporter.ReportEvent micFail,"Search results are displayed in Chart tab","Failed"
		End If

		Reporter.ReportEvent micDone, "Mapping_PageValidationd", "Function End"
		Services.EndTransaction "Mapping_PageValidation" ' Timer end
	End Function
	
	'<@comments>	
	'***************************************************************************************************************************	
	Public Function webTableSearch(ByVal oWebTableID) 
	'***************************************************************************************************************************	
	'Purpose: To verify whether the webtable exists
	'Parameters: Nothing
	'Returns: True or False
	'Requires: Environment Variable "BROWSER_OBJ" has been initialized/created
	'Usage:  	call util.webTableSearch(ByVal oWebTableID) 
	'Created by: Sujatha Kandikonda 05/23 /2011
	'***************************************************************************************************************************
		Services.StartTransaction "webTableSearch" 'Timer Begin
		Reporter.ReportEvent micDone, "webTableSearch", "Function Begin"
		
		Dim oAppBrowser, oWebTable, iTotalRows, iTotalCols
		'---verify passed parameters are not empty
		If IsNull(oWebTableID) or oWebTableID = "" Then
			Reporter.ReportEvent micFail, "Invalid Parameters", "Invalid parameters were passed to the webTableSearch function check passed parameters"
			webTableSearch=False
			Services.EndTransaction "webTableSearch" 'Timer End
			Exit function 
		End If
	
		'object declarations/initializations.
		Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
		
		'---webtable obj
		Set oWebTable=description.Create
		oWebTable("micclass").value="WebTable"
		oWebTable("html tag").Value = "TABLE"
		
		' Build oWebTable Object based on oWebTableID parameter	
		If Not IsNumeric(oWebTableID) Then
			oWebTable("html id").value=oWebTableID
		Else
			oWebTable("index").value=oWebTableID
		End If
	
		'---verify if WebTable obj description exists
		If Browser(oAppBrowser).WebTable(oWebTable).Exist(2) Then
			webTableSearch = True 			' Return Value
			iTotalRows=Browser(oAppBrowser).WebTable(oWebTable).RowCount ' Get Total Row Count
			iTotalCols=Browser(oAppBrowser).WebTable(oWebTable).ColumnCount(2) 'Get Total Column Count on row2	
			Reporter.ReportEvent micPass, "WebTable Object", "WebTable ID: " & oWebTableID & vbNewLine & "Total rows: " & iTotalRows & vbNewLine & "Total columns: " & iTotalCols

		Else ' WebTable Not Found
			Reporter.ReportEvent micFail, "WebTable Object", "WebTable ID: " & oWebTableID & " does not exist."
			webTableSearch = False ' Return Value
		End If
		
		' Clear Object Variables
		Set oAppBrowser = Nothing
		Set oWebTable = Nothing
		Set iTotalRows = Nothing
		Set iTotalCols = Nothing
		Reporter.ReportEvent micDone, "webTableSearch", "Function End"
		Services.EndTransaction "webTableSearch" 'Timer End	
	End Function
	
    '<@comments>	
	'***************************************************************************************************************************
		Public Function Verify_Chartstatus(chartstatus) 	
	'***************************************************************************************************************************		
		'Purpose: Verify the chart status is as expected
		'Parameter: chartstatus -  chart status that need to be verified
		'Returns: True/False
		'Usage Example:util.Verify_Chartstatus ("chartForm:chartTable:0:barcodeStatusVal", "RELEASED")
		'Author: Sujatha Kandikonda 06/24/2011
		'******************************************************************************************************************************
		Services.StartTransaction "Verify_Chartstatus" ' Timer Begin
		Reporter.ReportEvent micDone, "Verify_Chartstatus", "Function Begin"
		
		' Variable Declaration / Initialization
		Dim oAppBrowser, oAppObj,Status
		'object declarations/initializations.
		Set oAppBrowser = Browser(Environment("BROWSER_OBJ")) ' Setting local variable to the function to Use Environment Variable Browser Object Value
		Set oAppObj = Description.Create()
		oAppObj("micclass").Value = "WebTable"
		oAppObj("html id").Value =  "chartForm:chartTable"
		
		' Verification of the Object 
		If oAppBrowser.WebTable(oAppObj).Exist(1) Then
			Reporter.ReportEvent micPass, " WebTable", "WebTable Exists"
			Status= oAppBrowser.WebTable("html tag:=TABLE", "html id:= chartForm:chartTable").GetCellData (2,2)
			If Instr(1,Status,chartstatus,1) Then
				Verify_Chartstatus = TRUE
			Else
				Verify_Chartstatus = FALSE
			End If
		Else ' check using the html id property
			Reporter.ReportEvent micFail, " WebElement", "WebElement does not Exist"
		End If
		
		' Clear Object Variables
		Set oAppBrowser = Nothing
		Set oAppObj = Nothing
		Set chartstatus =Nothing
		Set Status = Nothing
		
		Reporter.ReportEvent micDone, "Verify_Chartstatus", "Function End"
		Services.EndTransaction "Verify_Chartstatus" 'Timer End	
	End Function

	'<@comments>	
	'***************************************************************************************************************************
	Public Function Pend_Chkbox_Status(ByVal sHTMLIDProperty) 
	'***************************************************************************************
	'Purpose: Verify that the Pend check box exists and enabled
	'Parameter: ByVal sHTMLIDProperty -  Html Id property of check box
	'Returns: True/False
	'Usage Example:util.Pend_Chkbox_Status("commonSearchForm:searchPendCheckBox")
	'Author: Sujatha Kandikonda 06/28/2011
	'************************************************************************************************************************************************************
		Services.StartTransaction "Pend_Chkbox_Status" ' Timer Begin
		Reporter.ReportEvent micDone, "Pend_Chkbox_Status", "Function Begin"
	
		' Variable Declaration / Initialization
		Dim oAppBrowser, oAppObj, iDisabled
		Dim bFound
	
		'checks to verify that the passed parameters are not null or empty strings.
		'returns false if the parameters are invalid.
		If IsNull(sHTMLIDProperty) Or sHTMLIDProperty= "" Then
			Reporter.ReportEvent micFail, "invalid parameters", "invalid parameters were passed to the Pend_Chkbox_Status."
			Pend_Chkbox_Status = False
			Services.EndTransaction "Pend_Chkbox_Status" ' Timer End
			Exit Function
		End If
		
		'description object 
		Set oAppBrowser = Environment("BROWSER_OBJ") 
		Set oAppObj = Description.Create()
		oAppObj("micclass").Value = "WebCheckBox"
		oAppObj("html id").Value = sHTMLIDProperty
		
		' Verification of Object
		If Browser(oAppBrowser).WebCheckBox(oAppObj).Exist(1) Then
			bFound = True
		Else
			bFound = False
		End If
		
		' Verify the Object is enabled if found
		If bFound Then	
			' Get the disabled property
			iDisabled = Browser(oAppBrowser).WebCheckBox(oAppObj).GetROProperty("disabled")
			If iDisabled = 0 Then
				Pend_Chkbox_Status = TRUE ' Return value
			elseif iDisabled = 1 Then
				Pend_Chkbox_Status =FALSE
			End If	
		End If
		
		' Clear Object Variables
		Set oAppBrowser = Nothing
		Set oAppObj = Nothing
		Set iDisabled = Nothing
		Set bFound = Nothing
		Reporter.ReportEvent micDone, "Pend_Chkbox_Status", "Function End"
		Services.EndTransaction "Pend_Chkbox_Status" ' Timer End
	End Function
	
	'<@comments>	
	'*******************************************************************************************************************************
	Public Function Validate_DetailedSearch_Fields(ByVal FieldName) 
	'*******************************************************************************************************************************
	'Purpose: Verify whether the field exists in the detailed search section of Data summary page
	'Parameter: ByVal FieldName -  ByVal Field Name
	'Returns: True/False
	'Usage Example:util.Validate_DetailedSearch_Fields("Organization Type")
	'Author: Sujatha Kandikonda on 07/08/2011
	'**************************************************************************************************************************************************
		Services.StartTransaction "Validate_DetailedSearch_Fields" ' Timer Begin
		Reporter.ReportEvent micDone, "Validate_DetailedSearch_Fields", "Function Begin"
	
	   ' Variable Declaration / Initialization
		Dim oAppBrowser ' Browser Object
		Dim oWebTable ' WebTable Object
		Dim str
	   
	   'Description Object Declarations/Initializations
		Set oAppBrowser = Environment("BROWSER_OBJ")  ' Setting local variable to the function to Use Environment Variable Browser Object Value
	
	   'create object for the WebTable
		Set oWebTable = Description.Create()
		oWebTable("MicClass").Value = "WebTable"
		oWebTable("html id").Value = "commonSearchForm:commonSearchMainGrid"

	   ' Check for the existence of the webtable
	   	If Browser(oAppBrowser).WebTable(oWebTable).Exist(3) Then
			Reporter.ReportEvent micPass, "WebTable", "WebTable was found"  	
			str = Browser(oAppBrowser).WebTable(oWebTable).GetCellData(1,1)
			If  Instr(str,FieldName ) >0 Then
					 Validate_DetailedSearch_Fields = TRUE
			Elseif Instr(str,FieldName ) = 0 Then
					Validate_DetailedSearch_Fields = FALSE
			End If
		Else 
			Reporter.ReportEvent micPass, "WebTable", "WebTable do not exist"  	
	   	End If
	   
	   'Clear Object Variables
		Set oAppBrowser = Nothing
		Set oWebTable = Nothing
		Set str = Nothing

		Reporter.ReportEvent micDone, "Validate_DetailedSearch_Fields", "Function End"
		Services.EndTransaction "Validate_DetailedSearch_Fields" ' Timer End																					
	End Function
	
	'<@comments>	
	'*******************************************************************************************************************************
	Public Function AssignOrganizationInformation (sTableHTMLID, sRetOrgVal, sCodOrgVal)
	'************************************************************************************************************************************************************
	'Purpose: Assign external/Internal coding vendor to retrieval and Coding organizations for the selected project										
	'Parameters: sTableHTMLID = string -  WebTable HTML Id
	'            sRetOrgVal = string - Value to be selected in the Retrieval Organization DropDown in Project Information Page
	'			sCodOrgVal = string - Value to be selected in the Coding Organization DropDown in Project Information Page
	' Parameter Usage
	'	sHTMLIDProperty = "projectForm:projectTable"
	'	sRetOrgVal = "TCS"
	'	sCodOrgVal = "TCS"
	'Returns: True/False
	'Usage: util.AssignOrganizationInformation("projectForm:projectTable","TCS","TCS") 	' Internal Coding Vendor
	'       util.AssignOrganizationInformation("","EXTNRTVCOD","TCS") ' External Coding Vendor
	'Created by: Mrudula Ambavarapu on 09/23/2011
	'Modified by: Govardhan Choletti 10-12-2011
	'************************************************************************************************************************************************************
		Services.StartTransaction "AssignOrganizationInformation" ' Timer Begin
		Reporter.ReportEvent micDone, "AssignOrganizationInformation", "Function Begin"
		AssignOrganizationInformation= False ' Return Value
		' Variable Declaration / Initialization
		Dim oAppBrowser, oAppObj, sRetrievalVal, sCodingVal, SRetvComp, SCodingComp, bTableVldn

        ' Check to verify passed parameters that they are not null or an empty string
		If IsNull(sRetOrgVal) or sRetOrgVal = "" OR  IsNull(sCodOrgVal) or sCodOrgVal = "" Then
			Reporter.ReportEvent micFail, "Invalid Parameters", "Invalid parameters were passed to the AssignOrganizationInformation function check passed parameters"
			Services.EndTransaction "AssignOrganizationInformation" ' Timer End
			Exit Function
		 End If
		
   	'sets the browser object.
	  	Set oAppBrowser = Browser(Environment("BROWSER_OBJ"))' Setting local variable to the function to Use Environment Variable Browser Object Value

		'Setting the object properties for the Image Object
		Set oAppObj = Description.Create()
		oAppObj("micclass").Value = "WebTable"
		If Not(IsNull(sTableHTMLID) or sTableHTMLID = "") Then
			oAppObj("html id").Value =sTableHTMLID
		Else
			oAppObj("html id").Value ="projectForm:projectTable"
		End If

		bTableVldn = False
		If oAppBrowser.WebTable(oAppObj).Exist(2) Then
			If  (Not(sTableHTMLID = "") Or oAppBrowser.WebTable(oAppObj).RowCount>4 ) Then
				bTableVldn = True
			End If
		End If
		If bTableVldn Then
	'Click on Projects from the drop down menu (Select first Record)
			If  util.Subtab_menu_clicker ("projectForm:projectTable:0:pic1", "projectForm:projectTable:0:editProjectDetail")= True  Then
				Reporter.ReportEvent micPass,"Link - Select Project ID --> Project","Projects from the Project Id submenu options is clicked"
			Else
				Reporter.ReportEvent micFail,"Link - Select Project ID --> Project","Unable to Click Projects from the Project Id submenu options"
			End If

			'Verify that Project Information page is displayed
			wait (4)
			If   of.ObjectFinder("WebElement","html id~html tag","editProjectDetailForm:editProjectHeaderLabel~SPAN","False~False") = True  Then
				Reporter.ReportEvent micPass,"WebElement - Verify Project Information","Project Information page is displayed"
			Else
				Reporter.ReportEvent micFail,"WebElement - Verify Project Information","Project Information page is Not displayed"
			End If

			'select retrieval organization as external coding organization
			If  oAppBrowser.WebList("html id:=editProjectDetailForm:projectRetrievalVendorValueList").Exist(2) Then
				If   of.webListSelect("editProjectDetailForm:projectRetrievalVendorValueList",sRetOrgVal)= True  Then
					Reporter.ReportEvent micPass,"WebList - Retrieval Organization","Retrieval Organization is selected as '"& sRetOrgVal

					'select Coding organization as external coding organization
					If  oAppBrowser.WebList("html id:=editProjectDetailForm:projectCodingVendorValueList").Exist(2) Then
						If   of.webListSelect("editProjectDetailForm:projectCodingVendorValueList",sCodOrgVal)= True  Then
							AssignOrganizationInformation= True
							Reporter.ReportEvent micPass,"WebList - Coding Organization","Coding Organization is selected as '"& sCodOrgVal
						Else
								Reporter.ReportEvent micFail,"WebList - Coding Organization","Coding Organization is Not selected as '"& sCodOrgVal
						End If
					Else  
						Reporter.ReportEvent micDone, "WebList - Coding Organization","Coding Organization Drop Down Box not found"
					End If
				Else
					Reporter.ReportEvent micFail,"WebList - Retrieval Organization","Retrieval Organization is Not selected as '"& sRetOrgVal
				End If
			Else  
				Reporter.ReportEvent micDone, "WebList - Retrieval Organization", "Retrieval Organization Drop Down Box not found"
			End If	

		'Click on Submit
			If   of.webButtonClicker("editProjectDetailForm:projectDetailSubmitButton")= True  Then
				Reporter.ReportEvent micPass,"Webbutton - Submit","Submit button is clicked Successfully"

				'Verify DataSummary Page is displayed)
				If  of.webElementFinder("manageProjectTabLabel") = True  Then
						Reporter.ReportEvent micPass,"Validate Data Summary Page","Data Summary page is displayed"
				Else
						Reporter.ReportEvent micFail,"Validate Data Summary Page","Data Summary page is Not displayed"
				End If
	
				'Fetching the data content 'sRetrievalVal' and 'sCodingVal' from WebTable
				sRetrievalVal= oAppBrowser.WebElement("html id:=projectForm:projectTable:0:projRsltDetlClmn24").GetROProperty("innertext")
				sCodingVal= oAppBrowser.WebElement("html id:=projectForm:projectTable:0:projRsltDetlClmn25").GetROProperty("innertext")
					
				'Verifying that in data summary  the retrieval organization and coding organization for the selected project are same as expected
				SRetvComp= strcomp(Trim(sRetOrgVal), Trim(sRetrievalVal), 1)
				SCodingComp= strcomp(Trim(sCodOrgVal), Trim(sCodingVal), 1)
				If   SRetvComp=0 And SCodingComp = 0 Then
					AssignOrganizationInformation=True
				Else 
					AssignOrganizationInformation=False
				End If
			Else
				Reporter.ReportEvent micFail,"Webbutton - Submit","Unable to click Submit button"
			End If
		Else 
			Reporter.ReportEvent micDone, "Web Table Validation","WebTable with HTML ID '"& sTableHTMLID &"' doesnot contain any Records"
		End If

        ' Clear Object Variables
		Set oAppBrowser = Nothing
		Set oAppObj = Nothing
        		
		Reporter.ReportEvent micDone, "AssignOrganizationInformation", "Function End"
		Services.EndTransaction "AssignOrganizationInformation" ' Timer End
	End Function
	
	Public Function exportFile(sObjType,sObjName,sObjIndex,sSaveFileName,iTimeout)
		'************************************************************************************************************************************************************
		'Purpose: ChartSync - Click the 'Export' Image object or 'Export to PDF' Link object to export and save as an Excel or PDF file type with or without name specify.
		'                    Expect two Dialog windows: 'File Download' and 'Save As'  exist during the process!
		'Parameters: sObjType= string - must be 'Link' or 'Image' or 'Button'  <=the Export link, button or Image to click
		'                         sObjName = If the object to click is the Image object then - specify the property 'file name' of the Image object (e.g., export_image_link.PNG)
		'                                                  If the object to click is the Link or button object then - specify the property 'name' or 'text' or 'innertext' of the object 
		'                         sObjIndex = Index property of the obj (numeric OR Empty string)	
		'                         sSaveFileName = string - file name full path to be saved
		'                                                 Or empty string - if it's an empty string, the function will save w/file name given in the dialog Edit field to C:\
		'            iTimout = in seconds waiting for the dialog window to appear
		'Calls: util and obj functions
		'Returns: True/False
		'Usage: util.exportFile("link","export_image_link.PNG","", "C:\Temp\myExport.xls",120) 	'save the Excel file w/file name full path specified w/120 secs time out 
		'       util.exportFile("link","export_image_link.PNG", "",120) 	'save whatever file name and type given (in the Edit field) to C:\
		'       util.exportFile("link","export_image_link.PNG", 0,"",120) 	'Link obj w/index=0. Save whatever file name and type given (in the Edit field) to C:\
		'		util.exportFile("Export to PDF","", "C:\Temp\myExport.pdf",120) 	'save the pdf file w/file name full path specified w/120 secs time out 
		'       util.exportFile("Export to PDF", "",120) 	'save whatever file name and type given (in the Edit field) to C:\
		'Created by: Hung Nguyen 11-4-10
		'Customized by: Ambavarapu, Mrudula 10/07/2011 for ChartSync
		'Modified: Hn 11-5-10 - Added to delete if file name to be saved exists from previous run.
		'          Hn 11-10-10	- Added ability to export PDF file type in addition to Excel file type.
		'          Hn 1/13/11 - Due to timing issue, added do loop waiting for the SaveAs dialog to be ready
		'          Hn 3/08/11 Modified the set Dialog obj 'Save As' statement to work with both IE6 and IE7
		'		   Gov 10/13/2011 - Customized the Function for ChartSync Usage
		'          Hn 2/12/13 - Added exportFile=False   'init return value and removed all statements elsewhere to reduce the script length 
		'                                   Due to delete file error - Moved the delete existing file section of code to after sSaveFileName is set
		'************************************************************************************************************************************************************
		Services.StartTransaction "exportFile"
		Dim fso,oAppBrowser,sDialogText,sDialogDownload,sDialogSaveAs,sDialogComplete,sGetText,sFileExtension,oDialogSaveAs,oDialogComplete,cnt,iDialog
	
		exportFile=False		'init return value
	
		sDialogText="Do you want to open or save this file?"
		sDialogDownLoad="File Download"
		sDialogSaveAs="Save As"
		sDialogComplete="Download complete"
	
		'verify parameters
		If strcomp(sObjType,"Link",1)<>0 And strcomp(sObjType,"Image",1)<>0  And strcomp(sObjType,"Button",1)<>0 Then
			Reporter.ReportEvent micFail,"Export File", sObjType &" is invalid object type. Valid object types are: Link and Image. Abort."
			Exit Function
		End If
		If sObjName="" Then
			Reporter.ReportEvent micFail,"Export File","Parameter 'sObjName' cannot be empty. Abort."
			Exit Function
		End If
				
		Set oAppBrowser=Browser(Environment("BROWSER_OBJ"))	'Browser obj.
	
		'click Export and verify columns in UI and columns in export are matching...
		If strcomp(sObjType,"Image",1)=0 Then	'Image obj
			If isnumeric(sObjIndex) then 
				If Not of.imageClickerWIndex(sObjName, sObjIndex) Then	'click Export obj w/index
					Reporter.ReportEvent micFail,"Export File","Function call to click the Export Image obj. failed."
					Exit Function
				End If			
			Else
				If Not of.imageClicker(sObjName) Then 'click Export obj.
					Reporter.ReportEvent micFail,"Export File","Function call to click the Export Image obj. failed."
					Exit Function 
				End If  
			End If 
		ElseIf strcomp(sObjType,"Link",1)=0 Then	'Link obj
			If Not of.linkClicker(sObjName) Then 'click 'Export to PDF' link obj.
				Reporter.ReportEvent micFail,"Export File","Function call to click the Export link obj. failed."
				Exit Function 
			End If  		
		Else			'Button Obj
			If Not of.webButtonClicker(sObjName) Then 'click 'Export' WebButton obj.
				Reporter.ReportEvent micFail,"Export File","Function call to click the Export Button obj. failed."
				Exit Function
			End If
		End If
				
		'click File Download - Save
		If util.dialogWindow(sDialogDownload,sDialogText,"&Save",iTimeout) Then	'click Save w/time out 
			'now enter file name and click save on second dialog window
			Set oDialogSaveAs=Dialog("text:=" &sDialogSaveAs,"is owned window:=True","is child window:=False")	'modified to work with both IE6 and IE7 Hn 3/8/11
	
			If oDialogSaveAs.Exist(iTimeout) Then
				oDialogSaveAs.Activate
				oDialogSaveAs.WaitProperty "enabled",true,10000
							
				'get current file name from the Edit field if file name to save is not specified
				If sSaveFileName="" Then	'file name does not specify
					sGetText=trim(oDialogSaveAs.WinEdit("nativeclass:=Edit","attached text:=File &name:").GetROProperty("text"))
					If sGetText<>"" Then
						sSaveFileName="C:\" &sGetText	'construct file name full path locally
					Else
						Reporter.ReportEvent micWarning,"Export File","The Edit field in the Dialog window '" &sDialogSaveAs &"' does not contain any file name by default. A file name is needed for saving. Abort."
						Exit Function
					End If 
				End If 	
	
				'clean up prior to saving same file name
				Set fso = CreateObject("Scripting.Filesystemobject")
				On Error Resume Next 'enable error handling
				fso.DeleteFile sSaveFileName,True
				On Error GoTo 0	'disable error handling
				
				'set save file name full path
				oDialogSaveAs.WinEdit("nativeclass:=Edit","attached text:=File &name:").Set sSaveFileName
				oDialogSaveAs.WinButton("nativeclass:=Button","text:=\&Save").Click	'click Save
	
				'Once Saving is Done close the Dialog Complete Window - IF EXISTS
				Set oDialogComplete=Dialog("text:=" &sDialogComplete,"is owned window:=False","is child window:=False")	'modified to work with both IE6 and IE7 Hn 3/8/11
				If oDialogComplete.Exist(2) Then
					oDialogComplete.Activate
					oDialogComplete.WaitProperty "enabled",true,10000
					oDialogComplete.WinButton("nativeclass:=Button","text:=Close").Click	'click Close
				End If
			
				'verify saving
				Wait(2)	'2 secs allow file saving to sync.
				If fso.FileExists(sSaveFileName) Then 
					Reporter.ReportEvent micDone,"Export File","File '" &sSaveFileName &"' was exported successfully."
					exportFile=True
				Else
					Reporter.ReportEvent micWarning,"Export File","File '" &sSaveFileName &"' was NOT exported successfully."
				End If    
			Else
				Reporter.ReportEvent micWarning,"Export File","Dialog text '" &sDialogText &"' window exists but the dialog '" &sDialogSaveAs &"' does not exist."										
			End If
		Else
			Reporter.ReportEvent micWarning,"Export File","Function call to click Save on the dialog window '" &sDialogText &"' failed."
		End If
	
		Set oDialogSaveAs=Nothing
		Set oDialogComplete=Nothing
		Set fso=Nothing
		Set oAppBrowser=Nothing
		Services.EndTransaction "exportFile"
	End Function

	Public Function pdf2text(pdfFile,textFile,iTimeout)
	'***************************************************************************
	'Purpose: Convert a pdf file to a text file via Adobe Reader v8
	'Requires: Adobe Reader must be installed - tested to work w/version 8
	'Parameters: pdfFile = PDF file full path
	'            textFile = text file to be saved full path
	'            iTimeout = in secs waiting for Adobe to open the pdf file
	'Returns: True/False
	'Usage: util.pdf2text("c:\mypdf.pdf","c:\mytext.txt")
	'Created by: Mrudula Ambavarapu on 10/12/2011
	'***************************************************************************
		Services.StartTransaction "pdf2text"
		Dim fso,cnt,iFound,oAdobe
      
       'clean up prior to saving same file name
		Set fso = CreateObject("Scripting.Filesystemobject")
		On Error Resume Next 'enable error handling
		fso.DeleteFile textFile,True
		On Error GoTo 0	'disable error handling

		If fso.FileExists(pdfFile) Then
			SystemUtil.Run(pdfFile)	'open the PDF file
			'loop waiting for Adobe 8 to open the file
			cnt=0
			iFound=0
			Do While cnt <=iTimeout
				Wait(1)
				cnt=cnt+1
				If Window("regexpwndtitle:=Adobe Reader","regexpwndclass:=AcrobatSDIWindow").Exist Then
					iFound=1
					Exit Do
				End If
			Loop
			
			If iFound=1 Then
				Set oAdobe=Window("regexpwndtitle:=Adobe Reader","regexpwndclass:=AcrobatSDIWindow")
				oAdobe.WaitProperty "enabled",True,20000
				oAdobe.WinMenu("menuobjtype:=2").Select "File;<Item 5>"	'item 5 in Adobe Reader 8 is 'Save as Text..."

				Wait(5)
				If oAdobe.Dialog("text:=Save As").Exist(2) Then	'dialog Save As
					oAdobe.Dialog("text:=Save As").WinEdit("nativeclass:=Edit","attached text:=File &name:").Set textFile
					oAdobe.Dialog("text:=Save As").WinButton("nativeclass:=Button","text:=\&Save").Click	'click Save
					Wait(2) 'let it sync.
					If fso.FileExists(textFile) Then
						Reporter.ReportEvent micPass,"pdf2text","Converted pdf file '" &pdfFile &"' to text file '" &textFile &"' was successful."
						pdf2text=True
					Else
						Reporter.ReportEvent micFail,"pdf2text","Converted pdf file '" &pdfFile &"' to text file '" &textFile &"' was NOT successful."
						pdf2text=False
					End If
				Else
					Reporter.ReportEvent micFail,"pdf2text","Dialog 'Save As' window does not exist."
					pdf2text=False				
				End If
				oAdobe.Close	  	
			Else
				Reporter.ReportEvent micFail,"pdf2text","Adobe Reader 8 does not exist."
				pdf2text=False	
			End If
		Else
			Reporter.ReportEvent micFail,"pdf2text","File '" &pdfFile &"' does not exist."
			pdf2text=False
		End If 
		Set oAdobe=Nothing
		Set fso=Nothing
	Services.EndTransaction "pdf2text"
	End Function	
	
	'<@comments>	
	'*******************************************************************************************************************************
	Public Function searchText(textFile,sText)
	'***************************************************************************************
	'Purpose: Search string of text from a text file
	'Parameter: textFile = the text file name full path where specified text to be searched
	'                       sText = string of text (semicolon separated if more text to be searched)
	'Note: The entire text file is read into memory prior to searching text
	'Returns: True/False
	'Calls: None
	'Usage: util.searchText("C:\myText.txt",ProjectID)
	'Author: Mrudula Ambavarapu on 10/12/2011
	'***************************************************************************************
	Services.StartTransaction "searchText"
		Dim fso,oTextFile,sReadAll,aText,cnt,sTxt,iReady,iAttrib,iTimeout
		iTimeout=180 'secs
		Const ForReading = 1

		Set fso = CreateObject("Scripting.FileSystemObject")
		If fso.FileExists(textFile) Then
		
			'loop til the file attribute is read/write (ready) prior to reading it
			On Error Resume Next 
			cnt=0
			iReady=0
			Do While cnt <= iTimeout
				Err.Clear
				Wait(1)	'1 sec
				cnt=cnt+1
				iAttrib=fso.GetFile(textFile).Attributes	'get file attrib
				'If Err = 0 And iAttrib = 32 Then 
				If Err = 0 Then 
					iReady=1
					Exit Do
				End If 
			Loop
			On Error Goto 0
					
			If iReady=1 Then 
				Set oTextFile = fso.OpenTextFile(textFile, ForReading) 'open text file for reading
				sReadAll=oTextFile.ReadAll	'read contents
				oTextFile.Close	'close the text file
				
				aText=Split(sText,";")	'split to an array regardless
				cnt=0
				For Each sTxt In aText
					If InStr(1,sReadAll,sTxt,1) Then
						cnt = cnt + 1
						Reporter.ReportEvent micDone,"searchText","Text '" &sTxt &"' exists."
					Else
						Reporter.ReportEvent micDone,"searchText","Text '" &sTxt &"' does not exist."
					End If 
				Next 
				'return value
				If cnt = ubound(aText) + 1 Then
					searchText = True
				Else
					searchText = False
				End If
			Else
				reporter.reportEvent micFail,"search Text", "Text '" &sTxt &"' was not ready in " &iTimeout &" time out."
				searchText=False
			End If 
		Else
			Reporter.ReportEvent micFail,"searchText","The text file '" &textFile &"' does not exist. Nothing to do."
			searchText = False
		End If
		Set fso=Nothing
	Services.EndTransaction "searchText"
	End Function
	
	'<@comments>	
	'*******************************************************************************************************************************
	Sub killProcess(processname)
	'*******************************************************************************************************
	'Purpose: Terminate all specified processes
	'Parameters: processname = process name(s) appear in Windows Task Manager (separated by semicolon)
	'Returns: None
	'Usage: util.killProcess("excel.exe,winword.exe,uedit32.exe")
	'       		OR util.killProcess("excel,winword,uedit32")
	'Created by: Hung Nguyen
	'Modified: HN - 6/4/09 Updated to allow terminate more than one process.
	'          Hn - 6/3/11 Added error handler.
	'******************************************************************************************************* 
		Services.StartTransaction "killProcess"
		On Error Resume Next 
		Dim sComputerName, oProcess, colProcessList, aProcesses, p, process   
		sComputerName="."
		Set oProcess = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\" & sComputerName & "\root\cimv2")
		Set colProcessList=oProcess.ExecQuery ("SELECT * FROM Win32_Process")
		
		aProcesses=Split(processname,";")
		For Each p In aProcesses	'specified processes
			For each process in colProcessList	'running processes
				If InStr(1,process.name,p,1) Then	'found
					process.terminate()
					Reporter.ReportEvent micPass,"Terminate Process","Process '" &process.name &"' was found and terminated."
					Exit For 
				End If  	
			Next 
		Next
		Set oProcess = Nothing
		On Error Goto 0 
		Services.EndTransaction "killProcess"	
	End Sub  
	
	'<@comments>	
	'*******************************************************************************************************************************
	Public Function dialogWindow(ByVal sDialogName,ByVal sDialogText, ByVal sButtonClick, ByVal iTimeout)
	'************************************************************************************************************************************************************
	'Purpose: Click a button in the dialog window (in the Browser page) that contains the text message .
	'Parameters: sDialogName= the text property of the dialog window obj.
	'                     sDialogText = The text message within the dialog window in the Browser page
	'                     sButtonClick = The Button name in the dialog window in the Browser page
	'                     iTimeout = in seconds
	'Calls: None
	'Requires: Environment("BROWSER_OBJ")	MUST EXIST
	'Returns: True/False
	'Usage: util.dialogWindow("File Download","Do you want to open or save this file?", "&Save",60) 	'click Save on the dialog window contains message w/time out of 60 secs
	'Created by: Hung Nguyen 11-4-10
	'Customized by: Govardhan Choletti 10/7/2011 for ChartSync
	'Modified:
	'************************************************************************************************************************************************************
		Services.StartTransaction "dialogWindow" 'Timer Begin
		Reporter.ReportEvent micDone, "dialogWindow", "Function Begin"
		
		' Variable Declaration / Initialization
		Dim aArgs,sArg,oAppBrowser,oDialog,cnt,iDialog,oStatic,oChild,iStatic,c,sGetText,WshShell,oDevRep, iPosX, iPosY, iLEFT_MOUSE_BUTTON
		
		' Check to verify passed parameters that they are not null or an empty string
		aArgs = Array(sDialogName, sDialogText, sButtonClick)
		For each sArg in aArgs
			If sArg = "" Then
				Reporter.ReportEvent micFail, "Invalid Parameters", "Invalid parameters were passed to the dialogWindow function check passed parameters"
				dialogWindow = False ' Return Value
				Services.EndTransaction "dialogWindow" 'Timer End
				Exit Function
			End If
		Next
		If Not IsNumeric(iTimeout) Then
			Reporter.ReportEvent micFail, "Invalid Parameters", "Time out must be numeric."
			dialogWindow = False ' Return Value
			Services.EndTransaction "dialogWindow" 'Timer End
			Exit Function
		End If
		
		Set oAppBrowser = Browser(Environment("BROWSER_OBJ"))  ' set Browser obj via global env.
		Set oDialog = oAppBrowser.Dialog("text:=" &sDialogName,"nativeclass:=#32770") 	' Dialog Object in the Browser page
		
		cnt=0
		iDialog=0
		Do While cnt <= iTimeout
			Wait(1)
			cnt=cnt+1
			If oDialog.Exist(2) Then
				oDialog.Activate
				iDialog=1
				Exit Do
			End If 
		Loop
		If iDialog=1 Then
			oDialog.WaitProperty "enabled",true,120000
			
			'Replace characters ( or ) with \( or \) - the need to escape/ignore special characters.
			sDialogText = Replace(Replace(Replace(sDialogText, "(", "\(", 1), ")", "\)", 1),"&","\&")
			
			' Set and search the Static Object
			Set oStatic = Description.Create()
			oStatic("nativeclass").Value = "Static"
			
			Set oChild=oDialog.ChildObjects(oStatic)
			If oChild.Count > 0 Then
				iStatic=0
				For c=0 to oChild.Count-1
					sGetText=trim(oChild(c).GetROProperty("text"))
					If strcomp(sGetText,sDialogText,1)=0 Then
						iStatic=1
						Exit for
					End If 
				Next

				If iStatic=1 Then
					Reporter.ReportEvent micDone,"Static Object","The  text/Static object '" &sDialogText &"' exists in the Dialog window."
					sButtonClick=replace(sButtonClick,"&","\&")
					If oDialog.WinButton("nativeclass:=Button","text:=" &sButtonClick).Exist Then
						oDialog.WinButton("nativeclass:=Button","text:=" &sButtonClick).WaitProperty "enabled",true,10000
						oDialog.WinButton("nativeclass:=Button","text:=" &sButtonClick).Click
						
						'click one more time - if exists
						If oDialog.WinButton("nativeclass:=Button","text:=" &sButtonClick).Exist(4) Then
							oDialog.Activate
							oDialog.WinButton("nativeclass:=Button","text:=" &sButtonClick).Click
						End If
						
						'click one more time - if exists with the Help of Send Keys
					'	If oDialog.WinButton("nativeclass:=Button","text:=" &sButtonClick).Exist(4) Then
					'		oDialog.Activate
					'		set WshShell = CreateObject("WScript.Shell")
					'		WshShell.SendKeys "S"
					'	End If
						
						'click one more time - if exists with the Help of Device Replay
						If oDialog.WinButton("nativeclass:=Button","text:=" &sButtonClick).Exist(4) Then
							oDialog.Highlight
							Set oDevRep=Createobject("mercury.devicereplay")
							iPosX=oDialog.WinButton("nativeclass:=Button","text:=" &sButtonClick).GetRoProperty("abs_x")
							iPosY=oDialog.WinButton("nativeclass:=Button","text:=" &sButtonClick).GetRoProperty("abs_y")
							iLEFT_MOUSE_BUTTON = 0
							oDevRep.MouseClick iPosX,iPosY,iLEFT_MOUSE_BUTTON  'To place mouse the cursor on the Save Dialog Box and Click
							Set oDevRep=Nothing
						End If
						
						' Still If Save Exist Click on Cancel and Proceed Further
						Dim WM_COMMAND, ibuttonCode, Hwnd, result
						If oDialog.WinButton("nativeclass:=Button","text:=" &sButtonClick).Exist(4) Then
							WM_COMMAND=245'Converted to decimal from &H111 to avoid QTP syntax error
							Extern.Declare micLong, "PostMessage", "user32.dll", "PostMessageA", micHwnd, micLong, micLong, micLong
							ibuttonCode = 2 ' 4424,2 Cancel in this dialog. It is "window id" property of the Button that you need to click - use Object Spy
							Hwnd = Window("regexpwndtitle:="&sDialogName).GetRoProperty("hwnd")
							result = extern.PostMessage(Hwnd, WM_COMMAND, ibuttonCode, 0)
							Reporter.ReportEvent micFail,"dialogWindow","Unable to Click on Save Button Hence Click on Cancel and going Further."
						End If
						
						Reporter.ReportEvent micDone,"dialogWindow","The Button ''" &sButtonClick &"' was clicked."
						dialogWindow=True
					Else
						Reporter.ReportEvent micWarning,"dialogWindow","The Button ''" &sButtonClick &"' does not exist in the dialog window."
						dialogWindow=False
					End If
				Else
					Reporter.ReportEvent micWarning,"dialogWindow","The text '" &sDialogText &"' specified does not exist in the dialog window."
					dialogWindow=False				
				End If		
			Else
				Reporter.ReportEvent micWarning,"Static Object","The text message '" &sDialogText &"' does not exist in the Dialog window."
				dialogWindow=False
			End If
		Else
			Reporter.ReportEvent micWarning,"dialogWindow",iTimeout &" secs. timed out waiting for the Dialog window '" &sDialogName &"' to appear."
			dialogWindow=False			
		End If 
		Set oDialog=Nothing
		Set oAppBrowser = Nothing			' Clear Object Variables
		Set WshShell = Nothing
		Services.EndTransaction "dialogWindow" 'Timer End	   
	End Function
	
	'<@comments>	
	'*******************************************************************************************************************************
	Public Function columnHeaderCheck(sExcelFile,sSheetName,iRowRange,sHeaderColumns)
	'************************************************************************************************************************************************************
	'Purpose: InSite - Verify column headers in an Excel file
	'Parameters: sExcelFile = An Excel file name full path
	'                         sSheetName = string - Excel sheet name where column headers will be checked
	'                         iRowRange = string - Specify start row and end row (semicolon separated) in the Excel sheet where column headers will be checked
	'                         sHeaderColumns = expected column name or names semicolon separated tobe checked
	'                                          Or variable is an array
	'Returns: True/False
	'Usage: util.columnHeaderCheck("C:\myfile.xls","Page0","2;2","header1;header2;header3)	'start from row2 to row2 
	'       util.columnHeaderCheck("C:\myfile.xls","Page0","2;5",aHeaders)	'aHeader is an array	'start from row2 to row5
	'       util.columnHeaderCheck("C:\myfile.xls","Page0","2",aHeaders)	'aHeader is an array	'start from row2 to row2
	'Created by: Hung Nguyen 11-4-10
	'Customized by: Govardhan Choletti 10-07-2011
	'Modified: Hn 11-11-10 Added to replace line feed char from the cell value for correct comparison
	'          Hn 11-12-10	Added to close/kill any opened Excel processes.
	'                       Added to reduce spaces between words to one only
	'          Hn 11-16-10 Added row range to loop header rows
	'************************************************************************************************************************************************************
	Services.StartTransaction "columnHeaderCheck"
	
		'close/kill any opened Excel processes
		util.killProcess("excel")
		
		Dim fso,oExcel,oWorkbook,oSheet,rowCnt,colCnt,aColumns,r,c,sCellValue,sColumn,iColFound,iColCnt,aText,i,sFinalValue
		Dim aRows,iStartRow,iEndRow
		Set fso = CreateObject("Scripting.Filesystemobject")
		If fso.FileExists(sExcelFile) Then
			Set oExcel = CreateObject("Excel.Application")
			Set oWorkbook = oExcel.Workbooks.Open(sExcelFile)
			Set oSheet=oExcel.Worksheets(sSheetName)
			rowCnt=oSheet.UsedRange.Rows.Count
			colCnt=oSheet.UsedRange.Columns.Count
			
			If Not IsArray(sHeaderColumns) Then
				aColumns=split(sHeaderColumns,";")	'values must be semicolon separated if more than one column to compare - No Exception!
			Else
				aColumns=sHeaderColumns
			End If
		
			'Loop cols in Excel
			aRows=split(iRowRange,";")	'split the row range to set header rows to loop 
			If ubound(aRows) = 0 Then
				iStartRow = aRows(0)
				iEndRow = aRows(0)
			ElseIf ubound(aRows) = 1 Then
				iStartRow = aRows(0)
				iEndRow = aRows(1)
			Else
				Reporter.ReportEvent micFail,"Column Header Chedk","Expected upper bound of row range within 0 and 1."
				columnHeaderCheck=False
				Services.EndTransaction "columnHeaderCheck"
				Exit Function
			End If 
			
			iColCnt=0
			For each sColumn in aColumns	
				For r=iStartRow to iEndRow
					For c=1 To colCnt
						iColFound=0
						sCellValue=trim(oExcel.Cells(r, c).Value)	'get cell value
						If sCellValue<>"" then 
							sCellValue=replace(sCellValue,vbLf," ")	'replace linefeed w/space
							
							'reduce spaces between words to one space only!
							atext=Split(sCellValue," ")
							For i=0 to ubound(aText)
								If aText(i)<>"" Then
									sFinalValue=sFinalValue &" " &aText(i)
								End If
							Next
							sCellValue=sFinalValue	'final value

							If sCellValue<>"" Then
								If strcomp(trim(sCellValue),sColumn,1)=0 Then	'col matched
									iColFound=1
									iColCnt = iColCnt + 1
									Reporter.ReportEvent micPass,"Column '" &sColumn &"'" ,"Expected column '" &sColumn &"'" &vbnewline &"Actual column in Excel  file '" &sCellValue &"'"
									Exit For 	'exit col
								End If
							End If 
						end if
						sFinalValue=""
					Next	'next column
					If iColFound=1 Then Exit For 	'exit row
				Next 	'next row
				If iColFound=0 Then	'col not matched
					Reporter.ReportEvent micFail,"Column '" &sColumn &"'","Expected column '" &sColumn &"' does not exist."
				End If				
			Next	'next expected column
		
			'return value
			If iColCnt = ubound(aColumns) + 1 Then
				columnHeaderCheck=True
			Else
				columnHeaderCheck=False
			End If

			oWorkbook.Close
			oExcel.Quit
			Set oExcel=Nothing
		Else
			Reporter.ReportEvent micFail,"columnHeaderCheck","File '" &sExcelFile &"' does not exist."
			columnHeaderCheck=False
		End If 
			
		Set fso=Nothing
	Services.EndTransaction "columnHeaderCheck"
	End Function
	
	'<@comments>	
	'*******************************************************************************************************************************
	Public Function ExcelContentValidation(sExcelFile,sSheetName,sColumnPos,sWebTableHTMLID,aColumnHeader)
	'************************************************************************************************************************************************************
	'Purpose: ChartSync - Verify column headers and Data in an Excel file from Application WebTable
	'Parameters: sExcelFile = An Excel file name full path
	'            sSheetName = string - Excel sheet name where column headers will be checked
	'			 sColumnPos = Position of Data to be Validated like 'First','Last','Any','All'
	'            sWebTableHTMLID = WebTable Identifier like htmlId
	'            aColumnHeader = expected column name or names semicolon separated tobe checked
	'                                                                Or variable is an array
	' Parameter Usage
	'	sExcelFile = "C:\Documents and Settings\208002\Desktop\Click Export Button -- Excel Files\MANAGE_PROJECT_REPORT1.Xls"
	'	sSheetName = "Page0"
	'	sColumnPos = "Any"
	'	sWebTableHTMLID ="projectForm:projectTable"
	'	aColumnHeader=Array("Project ID","Project Name","Status","Actual Start Date","Actual End Date","Estimated Start Date","Estimated End Date","Project Type","Project Requestor","Total Member","Total Chart","Chart Complete","Percentage Completed","Total Released","Intake Queue","Coding Queue","Code Complete","Intake Rejected","Coding Rejected","PNP","CNA","CANCELED","Escalated in Intake","Escalated in Coding","Total PNP Release","Total Scheduled","Total Retrieved","Total Sent","Total Received","Retrieval Organization","Coding Organization")
	'Returns: True/False
	'Usage: util.ExcelContentValidation("C:\myfile.xls","Page0","First","projectForm:projectTable",ColHdr1;ColHdr2;ColHdr3)	'Check for First Row in entire WebTable Data
	'       util.ExcelContentValidation("C:\myfile.xls","Page0","Any","projectForm:projectTable",aHeaders)	'aHeader is an array	'Check for Any One Row in entire WebTable Data
	'       util.ExcelContentValidation("C:\myfile.xls","Page0","Last","projectForm:projectTable",aHeaders)	'aHeader is an array	'Check for Last Row in entire WebTable in Data
	'Created by: Govardhan Choletti 10-07-2011
	'Modified by: Govardhan Choletti 11-03-2011 
				'To Identify Empty Used Rows in Excel and find the Exact records which does contains data
				'Validate If records available in only one page
				'03-27-2012 : Added Code - To skip validation of column 'On/Offshore Eligible' in Excel Sheet for Chart Sub Tab
				'06-01-2012 : Modified Code - Provider Tab --> Page Number object got changed, Hence updated along with handling 'Processing Image' Object 
				'06-20-2012 : Modified Code - Updated to New Browser Object from Ingenix Insite ChartSync --> Optum ChartSync
	'************************************************************************************************************************************************************
	Services.StartTransaction "ExcelContentValidation"
	
		'close/kill any opened Excel processes
		util.killProcess("excel")
			
		Dim fso,rowCnt,colCnt,c,cntRow
		Dim oExcel,oWorkbook,oSheet,oAppBrowser,oWebTable
		Dim aColumns,aPageResults,aText
		Dim iTotalRows,iTotalCols,iColFound,iColCnt,i,iLastResult,iPerPageResult,iLastPageNo,iRndRecord,iRndPageNo,iRndRecordinTable,iTableRowStart,iExcelRowStart,iStartRowExcel,iEndRowExcel,iStartRowTable,iEndRowTable, icolCntHdr, iAdditionalCol
		Dim sPageResults,sPageHeader,sExcelCellValue, sTableCellValue,sFinalValue, sTableCellMod, sExcelCellMod, sTableCellHdr, sMsgPagination,sPageHtmlID, sGoBtnHtmlID
		Dim	bTableHeader
		sMsgPagination = "Results.*1to.*([0-9]?[0-9])of.*([0-9]?[0-9]?[0-9]?[0-9])"
		iExcelRowStart = 1
		
		' creating a reference to a File System Object
		Set fso = CreateObject("Scripting.Filesystemobject")
		If fso.FileExists(sExcelFile) Then
			Set oExcel = CreateObject("Excel.Application")
			Set oWorkbook = oExcel.Workbooks.Open(sExcelFile)
			Set oSheet=oExcel.Worksheets(sSheetName)
			rowCnt=oSheet.UsedRange.Rows.Count
			' If the rowCnt fetched contains Empty Rows, get the correct Row Count throw Below snippet
			While ((Trim(oExcel.Cells(rowCnt, 1).Value) = "") AND (Trim(oExcel.Cells(rowCnt, 2).Value) = ""))
				rowCnt = rowCnt -1
			Wend
			colCnt=oSheet.UsedRange.Columns.Count
			
			'object declarations/initializations.
            'Set oAppBrowser = Description.Create()
			'oAppBrowser("MicClass").Value = "Browser"
			'oAppBrowser("title").Value = "Ingenix InSite ChartSync"
			Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
			
			If Not IsArray(aColumnHeader) Then
				aColumns=split(aColumnHeader,";")	'values must be semicolon separated if more than one column to compare - No Exception!
			Else
				aColumns=aColumnHeader
			End If
			
			' Assigning HTMl ID of Page Number Edit Box and Button 'Go'
			If  UCase(aColumns(0)) = "PROJECT ID" Then
				sPageHtmlID = "projectForm:projectPageSelection"
				sGoBtnHtmlID = "projectForm:projectJumpButton"
			ElseIf  UCase(aColumns(0)) = "PROVIDER ID" Then
				'sPageHtmlID = "providerForm:chartPageSelection"
				sPageHtmlID = "providerForm:providerPageSelection"
				sGoBtnHtmlID = "providerForm:projectJumpButton"
			ElseIf  UCase(aColumns(0)) = "CHART REQUEST ID" Then
				sPageHtmlID = "chartForm:chartPageSelection"
				sGoBtnHtmlID = "chartForm:chartJumpButton"
			End If
			
			icolCntHdr = UBound(aColumns)	' Taking reference number 
			
			'Get WebTable Data (If WebTable Exists)	
			Set oWebTable=description.Create
			oWebTable("micclass").value="WebTable"
			oWebTable("html tag").Value = "TABLE"
			
			' Build oWebTable Object based on sWebTableHTMLID parameter	
			If Not IsNumeric(sWebTableHTMLID) Then
				oWebTable("html id").value=sWebTableHTMLID
			Else
				oWebTable("index").value=sWebTableHTMLID
			End If
		
			'verify if WebTable obj description exists
			If Browser(oAppBrowser).WebTable(oWebTable).Exist(2) Then
				iTotalRows=Browser(oAppBrowser).WebTable(oWebTable).RowCount ' Get Total Row Count
				iTotalCols=UBound(aColumns)+1'Browser(oAppBrowser).WebTable(oWebTable).ColumnCount(2) 'Get Total Column Count on row2	
				
				'Fetch the Number of Result Header in WebPage
				sPageHeader = of.objectAction("WebElement","GetRoProperty~innertext", "class~innertext~html tag","availableReportPnlDim~"&sMsgPagination&"~TD", "False~True~False")
				If Not (sPageHeader="" Or sPageHeader=False) Then
					sPageResults = Split(sPageHeader,"to")(1)
					aPageResults = Split(sPageResults,"of")

					' The Below data to select Last Record in WebTable and Excel Sheet
					iLastResult = Cint(Trim(aPageResults(1)))
					iPerPageResult = Cint(Trim(aPageResults(0)))
					iLastPageNo =((iLastResult-1)\iPerPageResult) + 1
					
					' The Below data to select the Random Record in Webtable and Excel Sheet
					iRndRecord = Int((iLastResult - 1 + 1) * Rnd + 1)
					iRndPageNo = ((iRndRecord-1)\iPerPageResult) + 1
					iRndRecordinTable = iRndRecord - ((iRndPageNo-1) * iPerPageResult)
				End If
				
				' Validate WebTable & Excel Header and Get the Row Number of WebTable & Excel Sheet from where the Data starts
				bTableHeader = True
				for cntRow = 1 to 5 Step 1
					' Validating the Header in Webtable
					sTableCellHdr = Trim(Browser(oAppBrowser).WebTable(oWebTable).GetCellData(cntRow,1))
					If (Instr(1,Trim(Join(aColumns," ")),sTableCellHdr, 1)>0 OR Instr(1,sTableCellHdr,Trim(aColumns(0)), 1)>0) AND Not(sTableCellHdr = "") Then
						iTableRowStart = cntRow
'						for i = 1 to UBound(aColumns) 
'							If Not (Browser(oAppBrowser).WebTable(oWebTable).getcelldata(cntRow,i+1) = aColumns(i)) Then
'								bTableHeader = False
'								Exit For
'							End If
'						Next
					End If
					' Validating the Header in Excel Sheet
					If Trim(oExcel.Cells(cntRow, 1).Value) = Trim(aColumns(0)) Then
						iExcelRowStart = cntRow
						' For Charts Sub Tab  - - >  Excel sheet contains additional Column "On/Offshore Eligible" so validate and skip the step
						iAdditionalCol = 0
						for i = 1 to UBound(aColumns) 
							If (UCase(aColumns(0)) = "CHART REQUEST ID") And (Trim(oExcel.Cells(cntRow, i+1).Value = "On/Offshore Eligible"))  Then
								iAdditionalCol = 1 + iAdditionalCol
							End If
							If Not (Trim(oExcel.Cells(cntRow, i+1+iAdditionalCol).Value) = aColumns(i)) Then
								bTableHeader = False
								Exit For
							End If
						Next
					End If
				Next
				
				' Based on the User Selection Validate the records in Excel Sheet
				If bTableHeader Then
					Select Case Ucase(sColumnPos)
						' If User ask to validate the First record alone
						Case "FIRST"
							iStartRowExcel = iExcelRowStart + 1
							iEndRowExcel = iStartRowExcel
							iStartRowTable = iTableRowStart + 1
							iEndRowTable = iStartRowTable
						Case "LAST"
							iStartRowExcel = rowCnt
							iEndRowExcel = iStartRowExcel
							' Navigate to Last Pages based on the results
							If (Cint(Trim(aPageResults(1))) = Cint(Trim(aPageResults(0)))) Then
								iStartRowTable =Browser(oAppBrowser).WebTable(oWebTable).RowCount - 1' Get Total Row Count
								iEndRowTable = iStartRowTable
							Else
								If of.webEditEnter(sPageHtmlID,iLastPageNo) = True Then
									If of.webButtonClicker(sGoBtnHtmlID) = True Then
										wait (2)
										Browser(oAppBrowser).Sync
										Call ajaxSync.ajaxSyncRequest("Processing Request",60)
										iStartRowTable =Browser(oAppBrowser).WebTable(oWebTable).RowCount - 1' Get Total Row Count
										iEndRowTable = iStartRowTable
									End If
								End If
							End If
						Case "ANY"
							iStartRowExcel = iRndRecord + iExcelRowStart
							iEndRowExcel = iStartRowExcel
							' Navigate to Last Page based on the results
							If (Cint(Trim(aPageResults(1))) = Cint(Trim(aPageResults(0)))) Then
								iStartRowTable =iRndRecordinTable + iTableRowStart
								iEndRowTable = iStartRowTable
							Else
								If of.webEditEnter(sPageHtmlID,iRndPageNo) = True Then
									If of.webButtonClicker(sGoBtnHtmlID) = True Then
										wait (2)
										Browser(oAppBrowser).Sync
										Call ajaxSync.ajaxSyncRequest("Processing Request",60)
										iStartRowTable =iRndRecordinTable + iTableRowStart
										iEndRowTable = iStartRowTable
									End If
								End If
							End If
						Case "ALL" ' i.e Validating the records in First Page only
							iStartRowExcel = iExcelRowStart + 1
							iEndRowExcel = iExcelRowStart + iPerPageResult
							iStartRowTable = iTableRowStart + 1
							iEndRowTable = iTableRowStart + iPerPageResult
						Case Else 
							msgbox "Send the Correct Selection in Selecting Record i.e 'First', 'Last', 'All', 'Any'"
					End Select
					
					ExcelContentValidation=True
					Do
					' For Charts Sub Tab  - - >  Excel sheet contains additional Column "On/Offshore Eligible" so validate and skip the step
						iAdditionalCol = 0
						For c=1 To icolCntHdr+1
							If (UCase(aColumns(0)) = "CHART REQUEST ID") And (Trim(oExcel.Cells(iExcelRowStart, c + iAdditionalCol).Value) = "On/Offshore Eligible")  Then
								iAdditionalCol = 1 + iAdditionalCol
							End If
							sExcelCellValue=Trim(oExcel.Cells(iStartRowExcel, c + iAdditionalCol).Value)	'get cell value
							sTableCellValue = Trim(Browser(oAppBrowser).WebTable(oWebTable).getCellData(iStartRowTable,c))
							sTableCellMod=Replace(sTableCellValue," ","")
							sExcelCellMod=Replace(sExcelCellValue," ","")
							If (Instr(1, sTableCellValue, sExcelCellValue, 1) > 0) OR (sExcelCellValue = "" And sTableCellValue="" ) OR (sExcelCellValue = "PAF_HQ" And sTableCellValue="PAF" ) Then
								Reporter.ReportEvent micPass,"ExcelContentValidation", "Data in Excel Sheet '"& sExcelCellValue &"' at Row '"& iStartRowExcel &"' and Column '"& c + iAdditionalCol &"' matches with Data in WebTable '"& sTableCellValue &"' at Row '"& iStartRowTable &"' and Column '"& c &"' under Column Header :"&aColumns(c-1)
							ElseIf (Instr(1, sTableCellMod, sExcelCellMod, 1) > 0) Then 
								Reporter.ReportEvent micWarning,"ExcelContentValidation", "Ignoring Additional Spaces'"& sExcelCellValue &"' at Row '"& iStartRowExcel &"' and Column '"& c + iAdditionalCol &"' matches with Data in WebTable '"& sTableCellValue &"' at Row '"& iStartRowTable &"' and Column '"& c &"' under Column Header :"&aColumns(c-1)
							ElseIf (Instr(1,Replace(sTableCellValue,",",""), Replace(sExcelCellValue,",",""), 1) > 0) Then 
								Reporter.ReportEvent micWarning,"ExcelContentValidation", "Ignoring the Commas'"& sExcelCellValue &"' at Row '"& iStartRowExcel &"' and Column '"& c + iAdditionalCol &"' matches with Data in WebTable '"& sTableCellValue &"' at Row '"& iStartRowTable &"' and Column '"& c &"' under Column Header :"&aColumns(c-1)
							Else
								ExcelContentValidation=False
								Reporter.ReportEvent micFail,"ExcelContentValidation", "Data in Excel Sheet '"& sExcelCellValue &"' at Row '"& iStartRowExcel &"' and Column '"& c + iAdditionalCol &"' does not match with Data in WebTable '"& sTableCellValue &"' at Row '"& iStartRowTable &"' and Column '"& c &"' under Column Header:"&aColumns(c-1)
								'Exit For
							End if
						Next	'next column in the Same Row
						iStartRowTable = iStartRowTable + 1
						iStartRowExcel = iStartRowExcel+ 1
						If Not (ExcelContentValidation) Then
							Exit Do
						End If
					Loop While Not ((iEndRowTable = iStartRowTable-1) And (iEndRowExcel = iStartRowExcel-1))
				End If
			Else
				ExcelContentValidation=False
				Reporter.ReportEvent micFail,"ExcelContentValidation", "WebTable with HTML ID property : "& sWebTableHTMLID &" doesn't Exist under the Object Hierarchy, Check for the Object"
			End If
			oWorkbook.Close
			oExcel.Quit
			Set oExcel=Nothing
		Else
			Reporter.ReportEvent micFail,"ExcelContentValidation","File '" &sExcelFile &"' does not exist."
			ExcelContentValidation=False
		End If 
		Set oAppBrowser=Nothing
		Set oWebTable=Nothing
		Set fso=Nothing
	Services.EndTransaction "ExcelContentValidation"
	End Function
	
	Public Function DBContentValidation(sQuery, sDBColumnNames, sColumnPos, sWebTableHTMLID, sColumnHeader)
	'************************************************************************************************************************************************************
	'Purpose: ChartSync - Verify column headers and Data in an Excel file from Application WebTable
	'Parameters: sQuery = A Query to Fetch the Result from DB
	'            sDBColumnNames = Column Names that are to be validated as per the DB 
	'			 sColumnPos = Position of Data to be Validated like 'First','Last','Any','All'
	'            sWebTableHTMLID = WebTable Identifier like htmlId
	'            sColumnHeader = expected column name or names semicolon separated to be checked
	'                                                                Or variable is an array
	' Parameter Usage
	'	sQuery = "Select proj_key, proj_name, proj_status_cd, proj_actual_start_dt, proj_actual_end_dt, proj_exp_start_dt, proj_exp_end_dt,
	'			proj_review_type, proj_content_mbr_count, proj_content_count, proj_retrieval_vendor, proj_coding_vendor
	'			FROM Rv_project 
	'			WHERE proj_status_cd='VNDACK'
	'			ORDER BY proj_key DESC"
	'	sDBColumnNames = Array("Project ID","Project Name","Status","Actual Start Date","Actual End Date","Estimated Start Date","Estimated End Date","Project Type","Total Member","Total Chart","Retrieval Organization","Coding Organization")
	' 	sColumnPos = 'ALL'
	'	sWebTableHTMLID ="projectForm:projectTable"
	'	sColumnHeader=Array("Project ID","Project Name","Status","Actual Start Date","Actual End Date","Estimated Start Date","Estimated End Date","Project Type","Project Requestor","Total Member","Total Chart","Chart Complete","Percentage Completed","Total Released","Intake Queue","Coding Queue","Code Complete","Intake Rejected","Coding Rejected","PNP","CNA","CANCELED","Escalated in Intake","Escalated in Coding","Total PNP Release","Total Scheduled","Total Retrieved","Total Sent","Total Received","Retrieval Organization","Coding Organization")
	'Returns: True/False
	'Usage: util.DBContentValidation("Select * from Rv_project where proj_status_cd='VNDACK'",sDBColumnNames,"First","projectForm:projectTable",ColHdr1;ColHdr2;ColHdr3)	'Check for First Row in entire WebTable Data
	'Created by: Govardhan Choletti 11-23-2011
	'Modified by: ' Added Code to Navigate Application from Any Page to First page for the results displayed 1-9-2012
				  '06-20-2012 : Modified Code - Updated to New Browser Object from Ingenix Insite ChartSync --> Optum ChartSync
	'************************************************************************************************************************************************************
	Services.StartTransaction "DBContentValidation"
	
        Dim oAppBrowser, oWebTable, oRS
		Dim sMsgPagination, sPageHtmlID, sGoBtnHtmlID, sPageHeader, sPageResults, sTableCellHdr, sDBCellValue, sTableCellValue, sTableCellMod
		Dim aColumns, aDBColumns, aPageResults
		Dim cnt, cntRow, CntDB, CntUI, icolCntHdr, iTotalRows, iTotalCols, iLastResult, iPerPageResult, iLastPageNo, iRndRecord, iRndPageNo, iRndRecordinTable, iTableRowStart, iDBRowStart, iStartRowTable, iEndRowTable, iStartRowDB, iEndRowDB, iRecCnt
		Dim bTableHeader
		sMsgPagination = "Results.*1to.*([0-9]?[0-9])of.*([0-9]?[0-9]?[0-9]?[0-9])"

		'object declarations/initializations.
		'Set oAppBrowser = Description.Create()
		'oAppBrowser("MicClass").Value = "Browser"
		'oAppBrowser("title").Value = "Ingenix InSite ChartSync"
		Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
		
		If Not IsArray(sColumnHeader) And Not IsArray(sDBColumnNames) Then
			aColumns=split(sColumnHeader,";")	'values must be semicolon separated if more than one column to compare - No Exception!
			aDBColumns=split(sDBColumnNames,";")	'values must be semicolon separated if more than one column to compare - No Exception!
		Else
			aColumns=sColumnHeader
			aDBColumns=sDBColumnNames
		End If
		
		' Assigning HTMl ID of Page Number Edit Box and Button 'Go'
		If  UCase(aColumns(0)) = "PROJECT ID" Then
			sPageHtmlID = "projectForm:projectPageSelection"
			sGoBtnHtmlID = "projectForm:projectJumpButton"
		ElseIf  UCase(aColumns(0)) = "PROVIDER ID" Then
			sPageHtmlID = "providerForm:chartPageSelection"
			sGoBtnHtmlID = "providerForm:projectJumpButton"
		ElseIf  UCase(aColumns(0)) = "CHART REQUEST ID" Then
			sPageHtmlID = "chartForm:chartPageSelection"
			sGoBtnHtmlID = "chartForm:chartJumpButton"
		End If
		icolCntHdr = UBound(aColumns)	' Taking reference number 
		
		'Get WebTable Data (If WebTable Exists)	
		Set oWebTable=description.Create
		oWebTable("micclass").value="WebTable"
		oWebTable("html tag").Value = "TABLE"
		
		' Build oWebTable Object based on sWebTableHTMLID parameter	
		If Not IsNumeric(sWebTableHTMLID) Then
			oWebTable("html id").value=sWebTableHTMLID
		Else
			oWebTable("index").value=sWebTableHTMLID
		End If
	
		'verify if WebTable obj description exists
		If Browser(oAppBrowser).WebTable(oWebTable).Exist(2) Then
		' If the Page select is other than 1st Page. Navigate Once again to the First page
			If of.webEditStatus(sPageHtmlID) = True And of.objectAction("WebEdit","GetRoProperty~value","html id",sPageHtmlID,"False")<> "1" Then
				of.webEditEnter sPageHtmlID,1
				of.webButtonClicker sGoBtnHtmlID
				Browser(oAppBrowser).Sync
				Call ajaxSync.ajaxSyncRequest("Processing Request",60)
			End If
			iTotalRows=Browser(oAppBrowser).WebTable(oWebTable).RowCount ' Get Total Row Count
			iTotalCols=UBound(aColumns)+1'Browser(oAppBrowser).WebTable(oWebTable).ColumnCount(2) 'Get Total Column Count on row2	
			
			'Fetch the Number of Result Header in WebPage
			sPageHeader = of.objectAction("WebElement","GetRoProperty~innertext", "class~innertext~html tag","availableReportPnlDim~"&sMsgPagination&"~TD", "False~True~False")
			If Not (sPageHeader="" Or sPageHeader=False) Then
				sPageResults = Split(sPageHeader,"to")(1)
				aPageResults = Split(sPageResults,"of")

				' The Below data to select Last Record in WebTable and in DB
				iLastResult = Cint(Trim(aPageResults(1)))
				iPerPageResult = Cint(Trim(aPageResults(0)))
				iLastPageNo =((iLastResult-1)\iPerPageResult) + 1
				
				' The Below data to select the Random Record in Webtable and in DB
				iRndRecord = Int((iLastResult - 1 + 1) * Rnd + 1)
				iRndPageNo = ((iRndRecord-1)\iPerPageResult) + 1
				iRndRecordinTable = iRndRecord - ((iRndPageNo-1) * iPerPageResult)
			End If
			
			' Validate WebTable and Get the Row Number of WebTable, DB from where the Data starts
			bTableHeader = True
			For cntRow = 1 to 5 Step 1
				' Validating the Header in Webtable
				sTableCellHdr = Trim(Browser(oAppBrowser).WebTable(oWebTable).GetCellData(cntRow,1))
				If (Instr(1,Trim(Join(aColumns," ")),sTableCellHdr, 1)>0 OR Instr(1,sTableCellHdr,Trim(aColumns(0)), 1)>0) AND Not(sTableCellHdr = "") Then
					iTableRowStart = cntRow
				End If
			Next
			
			' Based on the User Selection Validate the records in Excel Sheet
			If bTableHeader Then
				' Execute DB Query and Check If any Results Found
				Set oRS = db.executeDBQuery(sQuery, Environment.Value("DB"))
				If LCase(typeName(oRS)) <> "recordset" Then
					Reporter.ReportEvent micFail, "invalid recordset", "The database connection did not open or invalid parameters were passed."
					Set oRS = Nothing
					Set oAppBrowser=Nothing
					Set oWebTable=Nothing
					DBContentValidation=False
					Exit Function
				ElseIf oRS.bof And oRS.eof Then
					Reporter.ReportEvent micFail, "invalid recordset", "The returned recordset contains no records."
					Set oRS = Nothing
					Set oAppBrowser=Nothing
					Set oWebTable=Nothing
					DBContentValidation=False
					Exit Function
				Else
					iDBRowStart = 0
					iRecCnt = 0
					Reporter.ReportEvent micDone, "valid recordset", "The returned recordset is valid and contains records."
					'Do
					'	iRecCnt = iRecCnt + 1
					'	oRS.MoveNext
					'Loop Until (oRS.bof OR oRS.eof)
					'oRS.MoveFirst
					'If (iLastResult) <> (iRecCnt) Then
					'	Reporter.ReportEvent micFail, "DB,UI Record(s) MisMatch", "Records fetched from DataBase : '" & oRS.RecordCount &"' is different when compared to Records shown in UI : '"& iLastResult &"'"
					'	Set oRS = Nothing
					'	Set oAppBrowser=Nothing
					'	Set oWebTable=Nothing
					'	DBContentValidation=False
					'	Exit Function
					'End If
				End If

				Select Case Ucase(sColumnPos)
					' If User ask to validate the First record alone
					Case "FIRST"
						iStartRowDB = iDBRowStart
						iEndRowDB = iStartRowDB
						iStartRowTable = iTableRowStart + 1
						iEndRowTable = iStartRowTable
					Case "LAST"
						iStartRowDB = iLastResult-1
						iEndRowDB = iStartRowDB
						' Navigate to Last Pages based on the results
						If (Cint(Trim(aPageResults(1))) = Cint(Trim(aPageResults(0)))) Then
							iStartRowTable =Browser(oAppBrowser).WebTable(oWebTable).RowCount - 1' Get Total Row Count
							iEndRowTable = iStartRowTable
						Else
							If of.webEditEnter(sPageHtmlID,iLastPageNo) = True Then
								If of.webButtonClicker(sGoBtnHtmlID) = True Then
									Browser(oAppBrowser).Sync
									Call ajaxSync.ajaxSyncRequest("Processing Request",60)
									iStartRowTable =Browser(oAppBrowser).WebTable(oWebTable).RowCount - 1' Get Total Row Count
									iEndRowTable = iStartRowTable
								End If
							End If
						End If
					Case "ANY"
						iStartRowDB = iRndRecord + iDBRowStart-1
						iEndRowDB = iStartRowDB
						' Navigate to Last Page based on the results
						If (Cint(Trim(aPageResults(1))) = Cint(Trim(aPageResults(0)))) Then
							iStartRowTable =iRndRecordinTable + iTableRowStart
							iEndRowTable = iStartRowTable
						Else
							If of.webEditEnter(sPageHtmlID,iRndPageNo) = True Then
								If of.webButtonClicker(sGoBtnHtmlID) = True Then
									Call ajaxSync.ajaxSyncRequest("Processing Request",60)
									Browser(oAppBrowser).Sync
									iStartRowTable =iRndRecordinTable + iTableRowStart
									iEndRowTable = iStartRowTable
								End If
							End If
						End If
					Case "ALL" ' i.e Validating the records in First Page only
						iStartRowDB = iDBRowStart
						iEndRowDB = iDBRowStart + iPerPageResult-1
						iStartRowTable = iTableRowStart + 1
						iEndRowTable = iTableRowStart + iPerPageResult
					Case Else 
						msgbox "Send the Correct Selection in Selecting Record i.e 'First', 'Last', 'All', 'Any'"
				End Select
				
				DBContentValidation=True			
				Do
					For cnt=1 To iStartRowDB
						oRS.MoveNext
					Next

					' Make Sure the Header in DB is same as that of WebTable
					' If Not allign the DB Header in sequence with that of UI
					CntDB = 0
					For CntUI = 0 To UBound(aColumns)
						If UCase(aColumns(CntUI)) = UCase(aDBColumns(CntDB)) Then
							sDBCellValue= oRS.fields(CntDB).Value
							sTableCellValue = Trim(Browser(oAppBrowser).WebTable(oWebTable).getCellData(iStartRowTable,CntUI+1))
							sTableCellMod=Replace(sTableCellValue," ","")
							If (Instr(1, sTableCellValue, sDBCellValue, 1) > 0) OR (IsNull(sDBCellValue) And sTableCellValue="" ) OR (Instr(1, sTableCellMod, sDBCellValue, 1) > 0) Then 
								Reporter.ReportEvent micPass,"DBContentValidation", "Data in DataBase '"& sDBCellValue &"' at Row '"& iStartRowDB+1 &"' and Column '"& CntDB+1 &"' matches with Data in WebTable '"& sTableCellValue &"' at Row '"& iStartRowTable &"' and Column '"& CntUI+1 &"' under Column Header :"&aColumns(CntUI)
							ElseIf (Instr(1,Replace(sTableCellValue,",",""), sDBCellValue, 1) > 0) Then 
								Reporter.ReportEvent micWarning,"DBContentValidation", "Data in DataBase '"& sDBCellValue &"' at Row '"& iStartRowDB+1 &"' and Column '"& CntDB+1 &"' matches with Data in WebTable '"& sTableCellValue &"' at Row '"& iStartRowTable &"' and Column '"& CntUI+1 &"' under Column Header :"&aColumns(CntUI)
							Else
								DBContentValidation=False
								Reporter.ReportEvent micWarning,"DBContentValidation", "Data in DataBase '"& sDBCellValue &"' at Row '"& iStartRowDB+1 &"' and Column '"& CntDB+1 &"' does not match with Data in WebTable '"& sTableCellValue &"' at Row '"& iStartRowTable &"' and Column '"& CntUI+1 &"' under Column Header:"&aColumns(CntUI)
								'Exit For
							End if
							CntDB = CntDB + 1
						End If
						' If the Columns passed in DB are Completed then Exit the Loop
						If CntDB = UBound(aDBColumns)+1 Then
							Exit For
						End If
					Next	'next column in the Same Row
					iStartRowTable = iStartRowTable + 1
					iStartRowDB = iStartRowDB+ 1
					If Not (DBContentValidation) Then
						Exit Do
					End If
				Loop While Not ((iEndRowTable = iStartRowTable-1) And (iEndRowDB = iStartRowDB-1))
			End If
		Else
			DBContentValidation=False
			Reporter.ReportEvent micFail,"DBContentValidation", "WebTable with HTML ID property : "& sWebTableHTMLID &" doesn't Exist under the Object Hierarchy, Check for the Object"
		End If

		Set oRS = Nothing
		Set oAppBrowser=Nothing
		Set oWebTable=Nothing
	Services.EndTransaction "DBContentValidation"
	End Function
	
	'<@comments>	
	'*******************************************************************************************************************************
	Public Function clickCalendarDate (sCalendarHtmlIDorName, sDate, sMonth, sYear)
	'************************************************************************************************************************************************************
	'Purpose: Click on the Calendar Icon and Select the date passed by User
	'Parameters: sCalendarHtmlIDorName = string -  Calendar Image HTML Id
	'            sDate = string - Date Value that to be selected
	'			 sMonth = string - Month Value that to be selected
	'			 sYear = string - Year Value that to be selected
	' Parameter Usage
	'	sCalendarHtmlIDorName = "commonSearchForm:projectStatusFromDateValuePopupButton"
	'	sDate = "31"
	'	sMonth = "Dec"
	'	sYear = "2010"
	'Returns: True/False
	'Usage: util.clickCalendarDate("commonSearchForm:projectStatusFromDateValuePopupButton","31","Dec","2011") 	' Internal Coding Vendor
	'       util.clickCalendarDate("generalReviewForm:dateTypeFromSearchPopupButton","27","Nov","2009") ' External Coding Vendor
	'Created by: Govardhan Choletti 11-15-2011
	'************************************************************************************************************************************************************
		Services.StartTransaction "clickCalendarDate" ' Timer Begin
		Reporter.ReportEvent micDone, "clickCalendarDate", "Function Begin"
		
		' Variable Declaration / Initialization
		Dim oAppBrowser, sSetDate ,oCalMon,oCalMonthYear, aParams, sParam, sMonthYear ' Browser Object
		Dim sAllMonths,aAllMonths, sCalObjHTML, sCalUniqueHTML,sCalOKHTML, iDayOfWeek, sDateObjHTML, bFound,sCurrMonthYear,sCurrMonth,sCurrYear
		aAllMonths = Array("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
		sAllMonths = Join(aAllMonths,",")
	
	' Check to verify passed parameters that they are not null or an empty string
		aParams = Array(sCalendarHtmlIDorName, sDate, sMonth, sYear)
		For Each sParam In aParams
			If IsNull(sParam) or sParam = "" Then
				Reporter.ReportEvent micFail, "Invalid Parameters", "Invalid parameters were passed to the clickCalendarDate function, Check passed parameters"
				clickCalendarDate = False ' Return Value
				Services.EndTransaction "clickCalendarDate" ' Timer End
				Exit Function
			End If
		Next
	
	   ' Check that the iRowPosition value is Numeric
		If Not isNumeric(aParams(1)) And Not isNumeric(aParams(3)) Then
			Reporter.ReportEvent micFail, "Invalid Parameters", "Date and Year Parameters must be numeric when passed to the clickCalendarDate function check passed parameters"
			clickCalendarDate = False ' Return Value
			Services.EndTransaction "clickCalendarDate" ' Timer End
			Exit Function
		End If
		
		' Check the Month Value when passed as Input
		If Instr(1,sAllMonths,sMonth,1) <= 0 Then
			Reporter.ReportEvent micFail, "Invalid Parameters", "The Month Name passed must be only 3 Characters with First Letter Capital when passed to the clickCalendarDate function, check passed parameters"
			clickCalendarDate = False ' Return Value
			Services.EndTransaction "clickCalendarDate" ' Timer End
			Exit Function
		End If
	   
	   ' Description Object Declarations/Initializations
		Set oAppBrowser = Environment("BROWSER_OBJ") ' Setting local variable to the function to Use Environment Variable Browser Object Value
		sSetDate = "1-"&sMonth&"-"&sYear
		iDayOfWeek = DatePart( "w", sSetDate )
		sCalObjHTML = Replace(sCalendarHtmlIDorName,"PopupButton","",1,1,1)
		sCalUniqueHTML = sCalObjHTML&"DateEditorLayout"
		sCalOKHTML = sCalObjHTML&"DateEditorButtonOk"
		sDateObjHTML = sCalObjHTML&"DayCell"&(iDayOfWeek+sDate-2)

		' Click on the Calendar Image to Open Calendar
		If of.imageClicker(sCalendarHtmlIDorName)= True  Then
			Reporter.ReportEvent micDone,"Click Calendar image","Calendar Image is clicked Succesfully"
		Else
			Reporter.ReportEvent micFail,"Click Calendar image","Unable to perform Click operation on Calendar Image"
		End If

	   ' create object for the WebTable
		Set oCalMonthYear = Description.Create()
		oCalMonthYear("MicClass").Value = "WebElement"
		oCalMonthYear("class").Value = "rich-calendar-tool-btn"
		oCalMonthYear("html tag").Value = "DIV"
	  ' oCalMonthYear("index").Value = 0 ' Using this to find the first instance of the table when there are multiple tables with the same property values

		' Verification of the Object
		bFound = False
		If Browser(oAppBrowser).WebTable("html id:="&sCalObjHTML).Exist(3) Then
			Browser(oAppBrowser).WebTable("html id:="&sCalObjHTML).Highlight
			
			' Any Previous Date got Selected then Clean it First
			If Browser(oAppBrowser).WebTable("html id:="&sCalObjHTML).WebElement("class:=rich-calendar-tool-btn","innertext:=Clean","html tag:=DIV").Exist(4) Then
				Browser(oAppBrowser).WebTable("html id:="&sCalObjHTML).WebElement("class:=rich-calendar-tool-btn","innertext:=Clean","html tag:=DIV").Click
				Reporter.ReportEvent micDone,"Clear Calendar","Calendar is cleared Succesfully"
				Wait (2)
				' Click on the Calendar Image to Open Calendar Once Again
				If of.imageClicker(sCalendarHtmlIDorName)= True  Then
					Reporter.ReportEvent micDone,"Click Calendar image","Calendar Image is clicked Succesfully"
				Else
					Reporter.ReportEvent micFail,"Click Calendar image","Unable to perform Click operation on Calendar Image"
				End If
			End If
			Set oCalMon = Browser(oAppBrowser).WebTable("html id:="&sCalObjHTML).ChildObjects(oCalMonthYear)
			If oCalMon.count >1 Then
				For sMonthYear=0 to oCalMon.Count-1
					sCurrMonthYear = CStr(oCalMon(sMonthYear).GetRoProperty("innertext"))
					If Instr(1,sCurrMonthYear,", 201",1 ) >0 Then
						oCalMon(sMonthYear).Click
						Reporter.ReportEvent micDone,"Click on Calendar ", sCurrMonthYear &"is clicked Succesfully"
						sCurrMonth = Left(sCurrMonthYear,3)
						sCurrYear = Right(sCurrMonthYear,4)
						bFound = True
						Exit For
					End If
				Next
				If bFound Then
					' Click on Month in Calendar table
					If Browser(oAppBrowser).WebTable("html id:="&sCalUniqueHTML).WebElement("class:=rich-calendar-editor-btn","innertext:="&sMonth,"html tag:=DIV").Exist(4) Then
						Browser(oAppBrowser).WebTable("html id:="&sCalUniqueHTML).WebElement("class:=rich-calendar-editor-btn","innertext:="&sMonth,"html tag:=DIV").Click
						Reporter.ReportEvent micDone,"Click Calendar Month","Calendar Month : "& sMonth &" is clicked Succesfully"
					ElseIf Not(sCurrMonth = sMonth) Then
						Reporter.ReportEvent micFail,"Click Calendar Month","Unable to Click on Calendar Month : "& sMonth
						bFound = False
					End If

					' Click on Year in Calendar table
					If Browser(oAppBrowser).WebTable("html id:="&sCalUniqueHTML).WebElement("class:=rich-calendar-editor-btn","innertext:="&sYear,"html tag:=DIV").Exist(4) Then
						Browser(oAppBrowser).WebTable("html id:="&sCalUniqueHTML).WebElement("class:=rich-calendar-editor-btn","innertext:="&sYear,"html tag:=DIV").Click
						Reporter.ReportEvent micDone,"Click Calendar Year","Calendar Year : "& sYear &" is clicked Succesfully"
					ElseIf Not(sCurrYear = sYear) Then
						Reporter.ReportEvent micFail,"Click Calendar Year","Unable to Click on Calendar Year : "& sYear
						bFound = False
					End If
				Else
					Reporter.ReportEvent micFail,"Click Calendar Month - Year","Unable to Click on Calendar Month : "& sMonth &" and  Year : "& sYear
				End If

				'Click on Ok
				If Browser(oAppBrowser).WebElement("html id:="&sCalOKHTML,"class:=rich-calendar-time-btn","innertext:=OK","html tag:=DIV").Exist(4) Then
					Browser(oAppBrowser).WebElement("html id:="&sCalOKHTML,"class:=rich-calendar-time-btn","innertext:=OK","html tag:=DIV").Click
				End If

				' Select the Date in calendar box
				If Browser(oAppBrowser).WebElement("html id:="&sDateObjHTML).Exist(4) Then
					Browser(oAppBrowser).WebElement("html id:="&sDateObjHTML).Click
					Reporter.ReportEvent micDone,"Click Calendar Date","Calendar Date : "& sDate &" is clicked Succesfully"
				Else
					Reporter.ReportEvent micFail,"Click Calendar Date","Unable to Click on Calendar Date : "& sDate
					bFound = False
				End If	
			End If
		End If

	   ' Check for the existence of the sTableName webtable
		If bFound Then			
			clickCalendarDate = True ' Return Value
		Else  ' WebTable Not found
			Reporter.ReportEvent micFail, "WebTable", "The WebTable with HTML ID or NAME : "& sCalendarHtmlIDorName &" was not found in Application"
			clickCalendarDate = False ' Return Value
		End If
	   
	   ' Clear Object Variables
		Set oAppBrowser = Nothing
		Set oCalMonthYear = Nothing
		Set oCalMon = Nothing
		Services.EndTransaction "clickCalendarDate" ' Timer End
	End Function
	
	'<@comments>	
	'*******************************************************************************************************************************
	Public Function setDate (sCalendarHtmlIDorName, sDate)
	'************************************************************************************************************************************************************
	'Purpose: Set the Date to be Previous, Current or Next as required by the User
	'Parameters: sDate = string - Date Type that to be selected
	' Parameter Usage
	'	sCalendarHtmlIDorName string -  Calendar Image HTML Id "commonSearchForm:projectStatusFromDateValuePopupButton"
	'	sDate = "Prev","Curr","Next"
	'Returns: True/False
	'Usage: util.setDate("commonSearchForm:projectStatusFromDateValuePopupButton","Prev")
	'       util.setDate("commonSearchForm:projectStatusFromDateValuePopupButton","Curr")
	'       util.setDate("commonSearchForm:projectStatusFromDateValuePopupButton","Next")
	'Created by: Govardhan Choletti 11-18-2011
	'************************************************************************************************************************************************************
		Services.StartTransaction "setDate" ' Timer Begin
		Reporter.ReportEvent micDone, "setDate", "Function Begin"
		
		If Not(UCase(sDate)="PREV" OR UCase(sDate)="CURR" OR UCase(sDate)="NEXT") Then
				Reporter.ReportEvent micFail, "Invalid Parameters", "Invalid parameters were passed to the setDate function, Check passed parameters"
				setDate = False ' Return Value
				Services.EndTransaction "setDate" ' Timer End
				Exit Function
		End If
		
		' Variable Declaration / Initialization
		Dim aDatetoSelect, sDatetoSelect

		Select Case Ucase(sDate)
				Case "PREV"
					sDatetoSelect = Date - 1
				Case "CURR"
					sDatetoSelect = Date
				Case "NEXT"
					sDatetoSelect = Date + 1
				Case Else 
					' Will Not Come to Else as the input passed will contain any of the above 3 Cases only
					msgbox "Send the Object Property"
		End Select
		
		aDatetoSelect = Split(sDatetoSelect,"/")
		If util.clickCalendarDate(sCalendarHtmlIDorName,aDatetoSelect(1),Left(MonthName(aDatetoSelect(0)),3),aDatetoSelect(2)) Then
				setDate = True
		Else
				setDate = False
		End If
		
		Services.EndTransaction "setDate" ' Timer End
	End Function
	
	'<@comments>	
	'*******************************************************************************************************************************
	Public Function waitForPageSync (sTitle, iMaxTime, iTimeInterval)
	'************************************************************************************************************************************************************
	'Purpose: When a Process Image is getting loaded, Wait till Process Image is removed from page
	'Parameters: sTitle - Title of the Browser to be passed as Input
	'			 iMaxTime - Maximum time to wait for that Object
	' 			 iTimeInterval - Time Interval to Check for the Object
	'Parameter Usage : sTitle - "Ingenix InSite ChartSync"
	'			 	   iMaxTime - 180
	' 			 	   iTimeInterval - 3
	'Returns: True/False
	'Usage: util.waitForPageSync("Ingenix InSite ChartSync", 180, 3)
	'Created by: Marepalli SatyaDev 04-18-2012
	'Customized by: Govardhan Choletti 04-20-2012
	'************************************************************************************************************************************************************
		Services.StartTransaction "waitForPageSync" ' Timer Begin
		Reporter.ReportEvent micDone, "waitForPageSync", "Function Begin"
		
		Dim i,iImageCounter,iElementCount,iLoadTime
		Dim oDesc,objWE
		iImageCounter = 0
		iLoadTime = 0
		
		' Check to verify passed parameters that they are not null or an empty string
		If IsNull(sTitle) Or sTitle = "" Or IsNull(iMaxTime) Or iMaxTime = "" Or IsNull(iTimeInterval) Or iTimeInterval = "" Then
			Reporter.ReportEvent micFail, "Invalid Parameters", "Invalid parameters were passed to the waitForPageSync function check passed parameters"
			waitForPageSync = False ' Return Value
			Services.EndTransaction "waitForPageSync" ' Timer End
			Exit Function
		End If
	  
		' Check that the iMaxTime and iTimeInterval value is Numeric
		If Not isNumeric(Round(iMaxTime)) Or Not isNumeric(Round(iTimeInterval)) Or iMaxTime < 1 Or iTimeInterval < 1 Or iMaxTime < iTimeInterval Then
			Reporter.ReportEvent micFail, "Invalid Parameters", "The iMaxTime and iTimeInterval Parameters must be numeric, greater than 1 and Max Time should be more than Interval Specified when passed to the waitForPageSync function, check passed parameters"
			waitForPageSync = False ' Return Value
			Services.EndTransaction "waitForPageSync" ' Timer End
			Exit Function
		End If
		
		'Frame the Web Element Processing Object
		Do While (Round(iMaxTime) >= iLoadTime)
			iLoadTime = iLoadTime + Round(iTimeInterval)
			Wait(Round(iTimeInterval))
			Set oDesc = Description.Create()
			oDesc("micclass").Value = "WebElement"
			oDesc("innertext").Value = "Processing Request"
			oDesc("class").Value= "rich-mpnl-body"
			Set objWE = Browser("title:="&sTitle).Page("title:="&sTitle).ChildObjects(oDesc)
			iElementCount = objWE.Count()
			
			' If Multiple Objects with similar properties found, Verify Each & every object
			If iElementCount > 0 Then
				iImageCounter = 0
				For i = 0 To iElementCount - 1
					If  Browser("title:="&sTitle).Page("title:="&sTitle).WebElement("innertext:=Processing Request","Class:=rich-mpnl-body","index:="&i).GetROproperty("height") > 0 Then
						iImageCounter =iImageCounter +1
					 End If
				Next
			End If

			' Verify If the Process Image is Still Shown on Screen, If N/A Skip the loop
			If iImageCounter = 0 Then
				Exit Do
			End If
		Loop	

		If Round(iMaxTime) >= iLoadTime Then
			waitForPageSync = True
			Reporter.ReportEvent micInfo, "waitForPageSync", "'Image Processing' Object disappered after waiting for '"& iLoadTime &"' Seconds"
		Else
			waitForPageSync = False
			Reporter.ReportEvent micInfo, "waitForPageSync", "'Image Processing' Object still available even after waiting for '"& iLoadTime &"' Seconds"
		End If 		
		Services.EndTransaction "waitForPageSync" ' Timer End
	End Function
	Function maintabSubHeaderNavigate(sTabName)
		'***********************************************************************************************************
		'Purpose: Navigate the ChartSync subtab header menu. The subtab header is the WebTable obj wihin the web app.
		'Parameters: sTabName= the WebTable innertext obj value
		'NOTE: this function does not check for correct page returns after the tab specified was clicked.
		'Calls: ajaxSync.vbs
		'Returns: True/False
		'Usage: Call util.maintabSubHeaderNavigate("Charts")		'click the subtab 'Chart Details' in Data Summary
		'               Call util.maintabSubHeaderNavigate("Encounters")		'click the subtab 'Encounters' in Code Review
		'
		'Created by: Hung Nguyen 9/6/12
		'Modified: Hung Nguyen 9/10/12 - Added call to count objs before and after for Browser sync.
		'          Hung Nguyen 10/30/12 - Due to failing in clicking the tab, re-referenced the tab table obj 
		'                                                          using wildcard in html id value and (innertect value) tab name. Also added do loop
		'          Hung Nguyen 4/29/13 - Increase time out from 5 to 40 secs calling function to wait for page to sync.
		'***********************************************************************************************************
		services.StartTransaction "maintabSubHeaderNavigate"
		Dim oAppBrowser,iExist,oTab,iClick,cnt,sInnerHtml,iObjCnt
		maintabSubHeaderNavigate=False	'init return value
	
		''verify parameter
		If sTabName="" or isempty(sTabname) Then
			reporter.ReportEvent micFail,"Invalid Parameter","Parameter 'sTabName' must contains a value."
			Exit Function
		End If
	
		'''any browser obj (which contains the child obj
		Set oAppBrowser=Browser(Environment("BROWSER_OBJ"))
		oAppBrowser.Sync
	
		'webtable obj
		iExist=0
		If oAppBrowser.WebTable("html id:=.*TabId_shifted","innertext:=" &sTabName).Exist(3) Then
			Set oTab=oAppBrowser.WebTable("html id:=.*TabId_shifted","innertext:=" &sTabName)
			iExist=1
		ElseIf oAppBrowser.WebTable("html id:=.*Tab_shifted","innertext:=" &sTabName).Exist(3) Then
			Set oTab=oAppBrowser.WebTable("html id:=.*Tab_shifted","innertext:=" &sTabName)
			iExist=1
		End If

		iClick=0
		If iExist=1 Then   

			'wait for the tab status completely updated. Else move on regardless...
			cnt=0
			Do While cnt <=10
				Wait(1)
				cnt=cnt+1
				oTab.RefreshObject
				sInnerHtml=oTab.GetROProperty("innerhtml")
				If instr(1,sInnerHtml,"tab-active",1) > 0 Or  instr(1,sInnerHtml,"tab-inactive",1) > 0 Then Exit Do
			Loop

			If instr(1,sInnerHtml,"tabSubHeader",1) > 0 And instr(1,sInnerHtml,"tab-active",1) > 0 Then 	'tab is main tab and not disabled
				iClick=1
			ElseIf instr(1,sInnerHtml,"tabSubHeader",1) > 0 And instr(1,sInnerHtml,"tab-inactive",1) > 0 Then 	'tab is main tab and not disabled
				iClick=1
			ElseIf instr(1,sInnerHtml,"tabSubHeader",1) > 0 And instr(1,sInnerHtml,"tab-disabled",1) > 0 Then 
				reporter.ReportEvent micFail, "Subtab '" &sTabName &"'","Tab found but was disabled. Unable to click/select."
			Else
				reporter.ReportEvent micFail, "Subtab '" &sTabName &"'","Tab found but status is unknown. Unable to click/select."
			End If
		Else
			reporter.ReportEvent micFail,"Subtab '" &sTabName &"'","Tab specified does not exist."	
		End If

		If iClick=1 Then
			'iObjCnt=ajaxSync.pageObjsCount(Environment("BROWSER_TITLE"))		'call to get obj count before
			oTab.Click			'click the tab
			'Call ajaxSync.ajaxBrowserSync(Environment("BROWSER_TITLE"),iObjCnt,40)		'wait for page to sync
			Call ajaxSync.ajaxSyncRequest("Processing Request",60)
			oAppBrowser.Sync
		
			maintabSubHeaderNavigate=True 	'return value
			reporter.ReportEvent micPass,"Tab '" &sTabName &"'","Tab found and was clicked."
		Else
			reporter.ReportEvent micFail, "Tab '" &sTabName &"'","Tab found but was disabled. Unable to click/select."
		End If

		Set oTab=Nothing
		Set oAppBrowser=Nothing
		services.EndTransaction "maintabSubHeaderNavigate"
	End Function
	
	Function maintabHeaderNavigate(sTabName)
		'***********************************************************************************************************
		'Purpose: Navigate the ChartSync tab header menu. The tab header is the WebTable obj wihin the web app.
		'Parameters: sTabName= the WebTable innertext obj value
		'NOTE: this function does not check for correct page returns after the tab specified was clicked.
		'Calls: ajaxSync.vbs
		'Returns: True/False
		'Usage: If util.maintabHeaderNavigate("Code Review") Then
		'                    msgbox "The tab menu found and selected"
		'               else 
		'                    msgbox "Either the tab menu specified didn't exist or was disabled"
		'               end if 
		'Created by: Hung Nguyen 9/6/12
		'Modified: Hung Nguyen 9/10/12 - Added call to count objs before and after for Browser sync.
		'          Hung Nguyen 10/30/12 - Due to failing in clicking the tab, re-referenced the tab table obj 
		'                                 using wildcard in html id value and (innertext value) tab name. Also added do loop
		'          Hung Nguyen 11/6/12 - Updated to include navigate the Research tab.
		'          Hung Nguyen 4/29/13 - Increase time out from 5 to 40 secs calling function to wait for page to sync.
		'***********************************************************************************************************
		services.StartTransaction "maintabHeaderNavigate"
		Dim oAppBrowser,oTab,iClick,cnt,sInnerHtml,iObjCnt
		maintabHeaderNavigate=False	'init return value
	
		''verify parameter
		If sTabName="" or isempty(sTabname) Then
			reporter.ReportEvent micFail,"Invalid Parameter","Parameter 'sTabName' must contains a value."
			Exit Function
		End If
	
		'''any browser obj (which contains the child obj
		Set oAppBrowser=Browser(Environment("BROWSER_OBJ"))
		oAppBrowser.Sync
	
		'set tab obj html id value per tab name
		If StrComp(sTabName,"Research",1)=0 Then
			Set oTab=oAppBrowser.WebTable("html id:=.*Tab_shifted","innertext:=" &sTabName)
		Else	'Home, Data Summary, Encounters, Intake, Code Review, etc... 
			Set oTab=oAppBrowser.WebTable("html id:=.*TabId_shifted","innertext:=" &sTabName)
		End If 
		       
		iClick=0
		If oTab.Exist(5) Then   

			'wait for the tab status completely updated. Else move on regardless...
			cnt=0
			Do While cnt <=10	'10 secs max. 
				Wait(1)
				cnt=cnt+1
				oTab.RefreshObject
				sInnerHtml=oTab.GetROProperty("innerhtml")
				If instr(1,sInnerHtml,"tab-active",1) > 0 Or  instr(1,sInnerHtml,"tab-inactive",1) > 0 Then Exit Do
			Loop

			If instr(1,sInnerHtml,"maintabHeader",1) > 0 And instr(1,sInnerHtml,"tab-active",1) > 0 Then 	'tab is main tab and not disabled
				iClick=1
			ElseIf instr(1,sInnerHtml,"maintabHeader",1) > 0 And instr(1,sInnerHtml,"tab-inactive",1) > 0 Then 	'tab is main tab and not disabled
				iClick=1
			ElseIf instr(1,sInnerHtml,"maintabHeader",1) > 0 And instr(1,sInnerHtml,"tab-disabled",1) >0 Then 
				reporter.ReportEvent micFail, "Tab '" &sTabName &"'","Tab found but was disabled. Unable to click/select."
			Else
				reporter.ReportEvent micFail, "Tab '" &sTabName &"'","Tab found but status is unknown. Unable to click/select."
			End If
		Else
			reporter.ReportEvent micFail,"Tab '" &sTabName &"'","Tab specified does not exist."	
		End If

		If iClick=1 Then
			'iObjCnt=ajaxSync.pageObjsCount(Environment("BROWSER_TITLE"))		'call to get obj count before
			oTab.Click			'click the tab
			'Call ajaxSync.ajaxBrowserSync(Environment("BROWSER_TITLE"),iObjCnt,40)		'wait for page to sync
			Call ajaxSync.ajaxSyncRequest("Processing Request",60)
			oAppBrowser.Sync
		
			maintabHeaderNavigate=True 	'return value
			reporter.ReportEvent micPass,"Tab '" &sTabName &"'","Tab found and was clicked."
		Else
			reporter.ReportEvent micFail, "Tab '" &sTabName &"'","Tab found but was disabled. Unable to click/select."
		End If

		Set oTab=Nothing
		Set oAppBrowser=Nothing
		services.EndTransaction "maintabHeaderNavigate"
	End Function
	Function tabHeaderStatus(sTabName)
		'***********************************************************************************************************
		'Purpose: Verify the ChartSync tab header menu status (active, inactive, disabled). The tab header is the WebTable obj wihin the web app.
		'Parameters: sTabName= the WebTable innertext obj value
		'Calls: None
		'
		'Returns: string: active, inactive, disabled 
		'                 OR Empty if fails
		'
		'Usage: If strcomp(util.tabHeaderStatus("Code Review"),"active",1) = 0 Then
		'                         msgbox "tab is active"
		'                         do something...
		'                Else
		'                         msgbox "function call returns failed. Tab is not active. Abort."
		'                End If 
		'OR
		'                sRetval = util.tabHeaderStatus("Code Review")
		'                 If instr(1,sReturnValue,"active",1) then 
		'                       msgbox "The tab menu specified is active"
		'                 elseIf instr(1,sReturnValue,"inactive",1) then
		'                       msgbox "The tab menu specified is inactive"
		'                 elseIf instr(1,sReturnValue,"disabled",1) then
		'                       msgbox "The tab menu specified is disabled"
		'                 else 
		'                      msgbox "The tab menu specified does not exist"
		'                 end if 
		'Created by: Hung Nguyen 9/10/12
		'Modified: Hung Nguyen 5/1/13 - Updated using obj property 'column names' to id the tab
		'***********************************************************************************************************
		services.StartTransaction "tabHeaderStatus"
		Dim oAppBrowser,oTab,sInnerHtml
		tabHeaderStatus=Empty	'init return value
	
		''verify parameter
		If sTabName="" or isempty(sTabname) Then
			reporter.ReportEvent micFail,"Invalid Parameter","Parameter 'sTabName' must contains a value."
			Exit Function
		End If
	
		'''any browser obj (which contains the child obj
		Set oAppBrowser=Browser(Environment("BROWSER_OBJ"))
		oAppBrowser.sync
	
		Set oTab=oAppBrowser.WebTable("column names:=" &sTabName,"html tag:=TABLE")
		If oTab.Exist(10) Then
			oTab.highlight

			sInnerHtml=oTab.GetROProperty("innerhtml")
			If instr(1,sInnerHtml,"tab-active",1) > 0 Then
				tabHeaderStatus="active"		'return value
			ElseIf instr(1,sInnerHtml,"tab-inactive",1) > 0 Then
				tabHeaderStatus="inactive"		'return value
			ElseIf instr(1,sInnerHtml,"tab-disabled",1) > 0 Then
				tabHeaderStatus="disabled"		'return value
			End If 
			reporter.ReportEvent micInfo,"tabHeaderStatus","Tab '" &sTabName &"'  is " &tabHeaderStatus
		Else
			reporter.ReportEvent micInfo,"tabHeaderStatus","Tab '" &sTabName &"' does not exist."
		End If

		Set oTab=Nothing
		Set oAppBrowser=Nothing
		services.EndTransaction "tabHeaderStatus"
	End Function	

	Function tabSubHeaderStatus(sTabName)
		'***********************************************************************************************************
		'Purpose: Verify the ChartSync subtab status (active, inactive, disabled). The tab sub-header is the WebTable obj wihin the web app.
		'Parameters: sTabName= the tabname or the WebTable innertext obj value
		'Calls: None
		'
		'Returns: string: active, inactive, disabled 
		'                 OR Empty if fails
		'
		'Usage: If strcomp(util.tabSubHeaderStatus("Code Review"),"active",1) = 0 Then
		'                         msgbox "subtab is active"
		'                         do something...
		'                Else
		'                         msgbox "function call returns failed. The subtab does not exist. Abort."
		'                End If 
		'OR
		'                sRetval = util.tabSubHeaderStatus("Code Review")		'get subtab status
		'                 If strcomp(sRetValue,"active",1)=0 then 
		'                       msgbox "The subtab specified is active"
		'                 elseIf strcomp(sRetValue,"inactive",1)=0 then 
		'                       msgbox "The subtab menu specified is inactive"
		'                 elseIf strcomp(sReturnValue,"disabled",1)=0 then
		'                       msgbox "The subtab menu specified is disabled"
		'                 else  'not exists and or unknown status
		'                      msgbox "The subtab menu specified does not exist"
		'                 end if 
		'
		'SUB TABS TESTED:
		'aTabs=array("Projects","Provider","Charts")   'Data Summary		good
		'aTabs=array("Encounters","Chart Details","Comments")   'Code Review   good
		'aTabs=array("Chart Details","Comments")   'Encounters    good
		'aTabs=array("Encounter Detail","Comments History")   'Research    good
		'aTabs=array("Encounters","Chart Details","Comments")   'Claims Verification      good
		'aTabs=array("Encounters","Chart Details","Comments")   'QA      good
		'aTabs=array("Encounters","Chart Details","Comments")   'CVQA      good
		'aTabs=array("Current Reviews","General Review")   'CVQA Review    GOOD
		'Created by: Hung Nguyen 9/10/12
		'Modified: Hung Nguyen 11/13/12 modified the obj description innertext value to work w/subtab Encounter Detail in the Research tab
		'          Hung Nguyen 12/11/12 added obj desc. to include object innertext value 
		'***********************************************************************************************************
		services.StartTransaction "tabSubHeaderStatus"
		Dim oAppBrowser,oTable,sInnerHtml
		tabSubHeaderStatus=Empty	'init return value
	
		''verify parameter
		If sTabName="" or isempty(sTabname) Then
			reporter.ReportEvent micFail,"Invalid Parameter","Parameter 'sTabName' must contains a value."
			Exit Function
		End If
	
		'''any browser obj (which contains the child obj
		Set oAppBrowser=Browser(Environment("BROWSER_OBJ"))
		oAppBrowser.sync

		'webtable obj
		Set oTable=oAppBrowser.WebTable("column names:=" &sTabName,"innertext:=" &sTabName,"innerhtml:=.*tabSubHeader.*")
     
		If oTable.Exist(5) Then
			reporter.ReportEvent micInfo,"Tab exists",""
			sInnerHtml = oTable.GetROProperty("innerhtml")
			If instr(1,sInnerHtml,"tab-active",1) > 0 Then
				tabSubHeaderStatus="active"		'return value
			ElseIf instr(1,sInnerHtml,"tab-inactive",1) > 0 Then
				tabSubHeaderStatus="inactive"		'return valuel
			ElseIf instr(1,sInnerHtml,"tab-disabled",1) > 0 Then
				tabSubHeaderStatus="disabled"		'return value
			End If 
		Else
			reporter.ReportEvent micInfo,"Tab '" &sTabName &"'","Tab specified does not exist."	'use return value to determine pass/fail
		End If

		Set oTable=NOthing 
		Set oAppBrowser=Nothing
		services.EndTransaction "tabSubHeaderStatus"
	End Function

	Function deleteAllEncounters (sTabName)
   '***********************************************************************************************************
		'Purpose: Removing all the Encounter(s) displayed on Code Review Tab
		'Parameters: sTabName= the Tab Header innertext obj value
		'Calls: util.tabHeaderStatus(sTabName) -- Verify the correct tab is shown
		'Returns: Count of Encounter (0, 5,...), -1 if any error occured during flow.
		'Usage:  Using Child Objects, identifying the list of encounters and then deleting it
		'					iEncounter = util.deleteAllEncounters("Code Review") 
		'					If  iEncounter >  0 Then
		'							Msgbox "All Encounter are deleted on screen"
		'					ElseIf iEncounter =  0 Then
		'							Msgbox "No Encounter are displayed on screen"
		'					Else
		'							Msgbox "Error occured while processing Function"
		'					End If
		'Created by: Govardhan Choletti 09/11/12
		'Modified: Hung Nguyen 10/30/12 - Changed micFail to micWarning to include negative testing. Use return value
		'                                 to determine PASS/FAIL instead. 
		'          Hung Nguyen 11/12/12 - Removed the Webtable waitproperty statement to get rid of the micwarning.
		'***********************************************************************************************************
		Services.StartTransaction "deleteAllEncounters"
		Dim oAppBrowser, oWebTable, oDesc, oDate, oChildEncounters, oChildEncountersDate
		Dim sAutoComments, sEncounterDate
		Dim bEncounterDeleted
		Dim iEncounterCount, i

		'Verify User is woking in Correct tab
		If instr(1, util.tabHeaderStatus(sTabName),"active",1) > 0 Then
			
			'Any browser obj (which contains the child obj
			Set oAppBrowser = Browser(Environment("BROWSER_OBJ")).Page("title:="&Environment("BROWSER_TITLE"))
			sAutoComments = "Deleting Encounter thru Automated Script"
			bEncounterDeleted = True
		
			'webtable obj that contains all the list of Encounters
			Set oWebTable = description.Create
			oWebTable("micclass").value="WebTable"
			oWebTable("html tag").value="TABLE"
			oWebTable("class").value="rich-table dataTableStyle"
			oWebTable("column names").value=".*From;Thru;Service Type;Primary ICD;E&O.*"

			If oAppBrowser.WebTable(oWebTable).Exist(5) Then
				' Get all the Encounter Dates Object
				Set oDesc=description.Create
				oDesc("micclass").value="WebElement"
				oDesc("html tag").value="DIV"
				oDesc("class").value="rich-label-text-decor"
				oDesc("innertext").RegularExpression=True
				oDesc("innertext").value="\d\d/\d\d/[1-2]\d\d\d"
				Set oChildEncounters = oAppBrowser.WebTable(oWebTable).ChildObjects(oDesc)

				'Get all the Delete options available when hovered on Encounter Date
				Set oDate = description.Create
				oDate("micclass").value="WebElement"
				oDate("html tag").value="DIV"
				oDate("innertext").value="Delete"
				Set oChildEncountersDate = oAppBrowser.WebTable(oWebTable).ChildObjects(oDate)

				' If the Count of Encouter Date and Delete objects are matched then go further or Else Exit Funtcion
				If oChildEncounters.Count =0 Then
					Reporter.ReportEvent micPass,"deleteAllEncounters", "No Encouters are displayed on screen"
					deleteAllEncounters = 0
					Exit Function
				ElseIf oChildEncounters.Count = oChildEncountersDate.Count Then
					iEncounterCount = oChildEncountersDate.Count

				'Loop Thru Each Encouter and delete accordingly
					For i=1 to iEncounterCount
						If oChildEncounters(iEncounterCount-i).Exist(3) And oChildEncountersDate(iEncounterCount-i).Exist(3) Then
							sEncounterDate = oChildEncounters(iEncounterCount-i).GetROProperty("innertext")
							oChildEncounters(iEncounterCount-i).FireEvent "onmouseover"
							oChildEncounters(iEncounterCount-i).FireEvent "click"

							' Perform Click on Delete link after performing hover on Encounter date
							oChildEncountersDate(iEncounterCount-i).FireEvent "onmouseover"
							oChildEncountersDate(iEncounterCount-i).FireEvent "click"
		
							'Click on Delete Button available on the Encouter Right top
							Wait(5)
							If of.webButtonClicker("Delete") = True Then
								If oAppBrowser.WebElement("html id:=deleteEncForm:deleteEncPopUpPanel_header").Exist(3) Then
									Reporter.ReportEvent micPass,"deleteAllEncounters --> Delete Entry PopUp","Delete Entry Pop up shown on screen as Expected"
									' Add Comments in the Text Box shown
									If of.webEditEnter("deleteEncForm:deleteEncNotesValue",sAutoComments) = True Then
										Reporter.ReportEvent micPass,"deleteAllEncounters --> Delete Entry PopUp Comments","Comments : "& sAutoComments &" sucessfully entered in 'Delete Entry' Pop up on screen as Expected"
		
										' Perform Click on "YES" Button
										If of.webButtonClicker("deleteEncForm:deleteEncSubmitBtn") = True Then
											Reporter.ReportEvent micPass,"deleteAllEncounters --> Delete Entry PopUp","'YES' Button in Delete Entry Pop up is clicked successfully"
										Else
											Reporter.ReportEvent micFail,"deleteAllEncounters --> Delete Entry PopUp","'YES' Button in Delete Entry Pop up is Not clicked, Not as Expected"
											bEncounterDeleted = false
											Exit for
										End If
									Else
										Reporter.ReportEvent micFail,"deleteAllEncounters --> Delete Entry PopUp Comments","Comments : "& sAutoComments &" are not entered in 'Delete Entry' Pop up on screen, NOT as Expected"
										bEncounterDeleted = false
										Exit for
									End If
								End If
								reporter.ReportEvent micPass,"deleteAllEncounters --> Encounter Section","Encounter : "& sEncounterDate &" deleted successfully"

								' Once the User naviagted back to Encounter detail section get the list of Encounters once again
								If oAppBrowser.WebTable(oWebTable).Exist(3) Then
									Set oDesc=description.Create
									oDesc("micclass").value="WebElement"
									oDesc("html tag").value="DIV"
									oDesc("class").value="rich-label-text-decor"
									oDesc("innertext").RegularExpression=True
									oDesc("innertext").value="\d\d/\d\d/[1-2]\d\d\d"
									Set oChildEncounters = oAppBrowser.WebTable(oWebTable).ChildObjects(oDesc)
						
									Set oDate = description.Create
									oDate("micclass").value="WebElement"
									oDate("html tag").value="DIV"
									oDate("innertext").value="Delete"
									Set oChildEncountersDate = oAppBrowser.WebTable(oWebTable).ChildObjects(oDate)
								End If
							Else
								reporter.ReportEvent micWarning,"deleteAllEncounters --> Encounter Section","Unable to delete Encounter : "& sEncounterDate &" Not as Expected"
								bEncounterDeleted = false
								Exit for
							End If
						End If
					Next
				Else
					reporter.ReportEvent micWarning,"deleteAllEncounters --> Encounter Section","All the available Encounter are not eligible for Delete"
				End If

				If bEncounterDeleted = True Then
					deleteAllEncounters = oChildEncounters.Count
				Else
					deleteAllEncounters = -1
				End If
			Else
				Reporter.ReportEvent micPass,"deleteAllEncounters", "No Encouters are displayed on screen"
				deleteAllEncounters = 0
			End If

			Set oAppBrowser = Nothing
			Set oWebTable = Nothing
			Set oDesc = Nothing
			Set oDate = Nothing
			Set oChildEncounters = Nothing
			Set oChildEncountersDate = Nothing
		Else
			deleteAllEncounters = -1
		End If
		services.EndTransaction "deleteAllEncounters"
	End Function
	
	Sub maintabHeaderStatus(sActiveTab,sInactiveTab,sDisabledTab)
		'***********************************************************************************************************
		'Purpose: Optum ChartSync - Verify active, inactive, and disabled tabs specified
		'                   Example of use case: Verify the Code Review tab is active and the rest are disabled.
		'Parameters: sActiveTab = an active tab name (e.g., "Code Review")
		'                                               OR an empty string means: NO verification
		'                         sInactiveTab = inactive tab name(s) - Use semicolon delimiter 
		'                                               OR an empty string means: NO verification
		'                                               OR 'all' means: verify all for inactive - except the ACTIVE one 
		'                         sDisabledTab = disabled tab name(s) - Use semicolon delimiter 
		'                                               OR an empty string means: NO verification
		'                                               OR 'all' means: verify all for disabled - except the ACTIVE
		'Calls: None
		'Returns: None
		'Usage: Call util.maintabHeaderStatus("Code Review","","")		'verify 'code review' tab is active
		'                Call util.maintabHeaderStatus("Code Review","","all")		'verify 'code review' tab is active and the rest are disabled
		'                Call util.maintabHeaderStatus("Code Review","all","")		'verify 'code review' tab is active and the rest are inactive
		'                Call util.maintabHeaderStatus("Home","Data Summary;Code Review;Profile","Claims Verification;QA,CVQA")		'verify 'Home' tab is active and the specified tabs are inactive and disabled
		'Created by: Hung Nguyen 9/11/12
		'Modified: 
		'***********************************************************************************************************
		services.StartTransaction "maintabHeaderStatus"
		Dim oAppBrowser,oDesc,oChild,iActiveFound,i,sInnerHtml,sInnerText,aInactiveTabs,j,aDisabledTabs,iInactiveFound,iDisabledFound

	
		''verify parameters
		If sActiveTab="" or isempty(sActiveTab) Then
			reporter.ReportEvent micFail,"Invalid Parameter","Parameter 'sActiveTab' must contains a value. There is always an active tab menu by default. Please specify one."
			Exit Sub
		End If

		If lcase(sInactiveTab)="all" And lcase(sDisabledTab)="all" Then
			reporter.ReportEvent micFail,"Invalid Parameter","Either parameter 'sInactiveTab' or 'sDisabledTab' value = 'all' but not both."
			Exit Sub
		ElseIf lcase(sDisabledTab)="all" Then
			If instr(sInactiveTab,";") or sInactiveTab<>"" Then
				reporter.ReportEvent micFail,"Invalid Parameter","When parameter 'sDisabledTab' value = 'all', the parameter 'sInactiveTab' value must be an empty string."
				Exit Sub
			End If 
		ElseIf lcase(sInactiveTab)="all" Then
			If instr(sDisabledTab,";") or sDisabledTab<>"" Then
				reporter.ReportEvent micFail,"Invalid Parameter","When parameter 'sInactiveTab' value = 'all', the parameter 'sDisabledTab' value must be an empty string."
				Exit Sub
			End If 
		End If
	
		'''any browser obj (which contains the child obj
		Set oAppBrowser=Browser(Environment("BROWSER_OBJ"))
	
		'webtable obj
		Set oDesc=description.Create
		oDesc("micclass").value="WebTable"
		oDesc("html tag").value="TABLE"
		oDesc("innerhtml").value=".*rich-tab-header.*"
		
		Set oChild=oAppBrowser.Page("title:=.*").ChildObjects(oDesc)

		'>>>>>active tab
		iActiveFound=0
		For i=0 to oChild.Count-1
			sInnerHtml = trim(oChild(i).GetROProperty("innerhtml"))
	
			If instr(1,sInnerHtml,"tabHeader",1) > 0 Then	'is a tabHeader
				sInnerText =trim(oChild(i).GetROProperty("innertext"))

				If strcomp(sInnerText, trim(sActiveTab),1)=0 Then	'tab name found
					iActiveFound=1
					If instr(1,sInnerHtml,"tab-active",1) > 0 Then		'tab is active
						reporter.ReportEvent micPass,"Tab '" &sActiveTab &"' is active.",""
					Else
						reporter.ReportEvent micFail,"Tab '" &sActiveTab &"' is not active.",""
					End If 
				End If 
			End If	'tabHeader
		Next	'webtable obj

		If iActiveFound=0 Then
			reporter.ReportEvent micFail,"Tab '" &sActiveTab &"' does not exist.",""
		End If

		'>>>>>inactive tab	
		If sInactiveTab<>"" Then
			Select Case lcase(sInactiveTab)
				Case "all"	'verify all except the one matches the active 
					For i=0 to oChild.Count-1
						sInnerHtml = trim(oChild(i).GetROProperty("innerhtml"))
				
						If instr(1,sInnerHtml,"tabHeader",1) > 0 Then	'is a tabHeader
							sInnerText =trim( oChild(i).GetROProperty("innertext"))
							If strcomp(sInnerText,trim(sActiveTab),1)<>0 Then	 'not match w/active tab
								If instr(1,sInnerHtml,"tab-inactive",1) > 0 Then		'tab is inactive
									reporter.ReportEvent micPass,"Tab '" &sInnerText &"' inactive.",""
								Else
									reporter.ReportEvent micFail,"Tab '" &sInnerText &"' is not inactive.",""
								End If 
							End If
						End If	'tabHeader
					Next	'webtable obj
		
				Case Else	'verify tab name(s) - semicolon delimiter
					aInactiveTabs=split(sInactiveTab,";")
					For j=0 to ubound(aInactiveTabs)
						aInactiveTabs(j)=trim(aInactiveTabs(j))
						iInactiveFound=0
						For i=0 to oChild.Count-1
							sInnerHtml = trim(oChild(i).GetROProperty("innerhtml"))
							If instr(1,sInnerHtml,"tabHeader",1) > 0 Then	'is a tabHeader
								sInnerText = trim(oChild(i).GetROProperty("innertext"))
								If strcomp(sInnerText,aInactiveTabs(j),1) =0 Then	'tab found
									iInactiveFound=1
									If instr(1,sInnerHtml,"tab-inactive",1) > 0 Then		'tab is inactive
										reporter.ReportEvent micPass,"Tab '" &sInnerText &"' is inactive.",""
									Else
										reporter.ReportEvent micFail,"Tab '" &sInnerText &"' is not inactive.",""
									End If 		
									Exit For 
								End If 		'tab found
							End If	'tabHeader
						Next	'actual tab
		
						If iInactiveFound=0 Then
							reporter.ReportEvent micFail,"Tab '" &aInactiveTabs(j) &"' does not exist.",""
						End If
					Next 'next expected tab
			End Select
		End If 


		'>>>>>disabled tab	
		If sDisabledTab<>"" Then	
			Select Case lcase(sDisabledTab)
				Case "all"	'verify all except the one matches the active 
					For i=0 to oChild.Count-1
						sInnerHtml = trim(oChild(i).GetROProperty("innerhtml"))
				
						If instr(1,sInnerHtml,"tabHeader",1) > 0 Then	'is a tabHeader
							sInnerText = trim(oChild(i).GetROProperty("innertext"))
							If strcomp(sInnerText,trim(sActiveTab),1)<>0 Then	 'not match w/active tab
								If instr(1,sInnerHtml,"tab-disabled",1) > 0 Then		'tab is disabled
									reporter.ReportEvent micPass,"Tab '" &sInnerText &"' is disabled.",""
								Else
									reporter.ReportEvent micFail,"Tab '" &sInnerText &"' is not disabled.",""
								End If 
							End If
						End If	'tabHeader
					Next	'webtable obj
		
				Case Else	'verify tab name(s) - semicolon delimiter
					aDisabledTabs=split(sDisabledTab,";")
					For j=0 to ubound(aDisabledTabs)
						aDisabledTabs(j)=trim(aDisabledTabs(j))
						iDisabledFound=0
						For i=0 to oChild.Count-1
							sInnerHtml = trim(oChild(i).GetROProperty("innerhtml"))
							If instr(1,sInnerHtml,"tabHeader",1) > 0 Then	'is a tabHeader
								sInnerText = trim(oChild(i).GetROProperty("innertext"))
								If strcomp(sInnerText,aDisabledTabs(j),1) =0 Then	'tab found
									iDisabledFound=1
									If instr(1,sInnerHtml,"tab-disabled",1) > 0 Then		'tab is disabled
										reporter.ReportEvent micPass,"Tab '" &sInnerText &"' is disabled.",""
									Else
										reporter.ReportEvent micFail,"Tab '" &sInnerText &"' is not disabled.",""
									End If 		
									Exit For 
								End If 		'tab found
							End If	'tabHeader
						Next	'actual tab
		
						If iDisabledFound=0 Then
							reporter.ReportEvent micFail,"Tab '" &aDisabledTabs(j) &"' does not exist.",""
						End If
					Next 'next expected tab
			End Select
		End If 
		
		Set oAppBrowser=Nothing
		services.EndTransaction "maintabHeaderStatus"
	End Sub	
	
	Sub maintabSubHeaderStatus(sActiveTab,sInactiveTab,sDisabledTab)
		'***********************************************************************************************************
		'Purpose: Optum ChartSync - Verify active, inactive, and disabled maintabSubHeaders specified
		'                   Example of use case: Verify the maintabSubHeader 'Encounters' is active and 'Chart Details' and 'Comments' are disabled
		'                                                              in the Code Review page by default
		'Parameters: sActiveTab = an active tab name (e.g., "Encounters")
		'                                               OR an empty string means: NO verification
		'                         sInactiveTab = inactive tab name(s) - Use semicolon delimiter 
		'                                               OR an empty string means: NO verification
		'                                               OR 'all' means: verify all for inactive - except the ACTIVE one 
		'                         sDisabledTab = disabled tab name(s) - Use semicolon delimiter 
		'                                               OR an empty string means: NO verification
		'                                               OR 'all' means: verify all for disabled - except the ACTIVE one
		'Calls: None
		'Returns: None
		'Usage: Call util.maintabSubHeaderStatus("Encounters","","")		'verify 'Encounters' tab is active
		'                Call util.maintabSubHeaderStatus("Encounters","","all")		'verify 'Encounters' tab is active and the rest are disabled
		'                Call util.maintabSubHeaderStatus("Encounters","all","")		'verify 'Encounters' tab is active and the rest are inactive
		'Created by: Hung Nguyen 9/12/12
		'Modified: 
		'***********************************************************************************************************
		services.StartTransaction "maintabSubHeaderStatus"
		Dim oAppBrowser,oDesc,oChild,iActiveFound,i,sInnerHtml,sInnerText,aInactiveTabs,j,aDisabledTabs,iInactiveFound,iDisabledFound

	
		''verify parameters
		If sActiveTab="" or isempty(sActiveTab) Then
			reporter.ReportEvent micFail,"Invalid Parameter","Parameter 'sActiveTab' must contains a value. There is always an active subtab menu by default. Please specify one."
			Exit Sub
		End If

		If lcase(sInactiveTab)="all" And lcase(sDisabledTab)="all" Then
			reporter.ReportEvent micFail,"Invalid Parameter","Either parameter 'sInactiveTab' or 'sDisabledTab' value = 'all' but not both."
			Exit Sub
		ElseIf lcase(sDisabledTab)="all" Then
			If instr(sInactiveTab,";") or sInactiveTab<>"" Then
				reporter.ReportEvent micFail,"Invalid Parameter","When parameter 'sDisabledTab' value = 'all', the parameter 'sInactiveTab' value must be an empty string."
				Exit Sub
			End If 
		ElseIf lcase(sInactiveTab)="all" Then
			If instr(sDisabledTab,";") or sDisabledTab<>"" Then
				reporter.ReportEvent micFail,"Invalid Parameter","When parameter 'sInactiveTab' value = 'all', the parameter 'sDisabledTab' value must be an empty string."
				Exit Sub
			End If 
		End If
	
		'''any browser obj (which contains the child obj
		Set oAppBrowser=Browser(Environment("BROWSER_OBJ"))
	
		'webtable obj
		Set oDesc=description.Create
		oDesc("micclass").value="WebTable"
		oDesc("html tag").value="TABLE"
		oDesc("innerhtml").value=".*rich-tab-header.*"
		
		Set oChild=oAppBrowser.Page("title:=.*").ChildObjects(oDesc)

		'>>>>>active tab
		reporter.ReportEvent micInfo,">>>>>active tab...",""
		iActiveFound=0
		For i=0 to oChild.Count-1
			sInnerHtml = trim(oChild(i).GetROProperty("innerhtml"))
	
			If instr(1,sInnerHtml,"tabSubHeader",1) > 0 Then	'is a tabSubHeader
				sInnerText =trim(oChild(i).GetROProperty("innertext"))

				If strcomp(sInnerText, trim(sActiveTab),1)=0 Then	'tab name found
					iActiveFound=1
					If instr(1,sInnerHtml,"tab-active",1) > 0 Then		'tab is active
						reporter.ReportEvent micPass,"Tab '" &sActiveTab &"' is active.",""
					Else
						reporter.ReportEvent micFail,"Tab '" &sActiveTab &"' is not active.",""
					End If 
					Exit For 
				End If 
			End If	'tabSubHeader
		Next	'webtable obj

		If iActiveFound=0 Then
			reporter.ReportEvent micFail,"Tab '" &sActiveTab &"' does not exist.",""
		End If

		'>>>>>inactive tab	
		If sInactiveTab<>"" Then
			reporter.ReportEvent micInfo,">>>>>inactive tab...",""
			Select Case lcase(sInactiveTab)
				Case "all"	'verify all except the one matches the active 
					For i=0 to oChild.Count-1
						sInnerHtml = trim(oChild(i).GetROProperty("innerhtml"))
				
						If instr(1,sInnerHtml,"tabSubHeader",1) > 0 Then	'is a tabSubHeader
							sInnerText =trim( oChild(i).GetROProperty("innertext"))
							If strcomp(sInnerText,trim(sActiveTab),1)<>0 Then	 'not match w/active tab
								If instr(1,sInnerHtml,"tab-inactive",1) > 0 Then		'tab is inactive
									reporter.ReportEvent micPass,"Tab '" &sInnerText &"' inactive.",""
								Else
									reporter.ReportEvent micFail,"Tab '" &sInnerText &"' is not inactive.",""
								End If 
							End If 
						End If	'tabHeader
					Next	'webtable obj
		
				Case Else	'verify tab name(s) - semicolon delimiter
					aInactiveTabs=split(sInactiveTab,";")
					For j=0 to ubound(aInactiveTabs)
						aInactiveTabs(j)=trim(aInactiveTabs(j))
						iInactiveFound=0
						For i=0 to oChild.Count-1
							sInnerHtml = trim(oChild(i).GetROProperty("innerhtml"))
							If instr(1,sInnerHtml,"tabSubHeader",1) > 0 Then	'is a tabSubHeader
								sInnerText = trim(oChild(i).GetROProperty("innertext"))
								If strcomp(sInnerText,aInactiveTabs(j),1) =0 Then	'tab found
									iInactiveFound=1
									If instr(1,sInnerHtml,"tab-inactive",1) > 0 Then		'tab is inactive
										reporter.ReportEvent micPass,"Tab '" &sInnerText &"' is inactive.",""
									Else
										reporter.ReportEvent micFail,"Tab '" &sInnerText &"' is not inactive.",""
									End If 		
									Exit For 
								End If 		'tab found
							End If	'tabSubHeader
						Next	'actual tab
		
						If iInactiveFound=0 Then
							reporter.ReportEvent micFail,"Tab '" &aInactiveTabs(j) &"' does not exist.",""
						End If
					Next 'next expected tab
			End Select
		End If 


		'>>>>>disabled tab	
		If sDisabledTab<>"" Then	
			reporter.ReportEvent micInfo,">>>>>disabled tab...",""
			Select Case lcase(sDisabledTab)
				Case "all"	'verify all except the one matches the active 
					For i=0 to oChild.Count-1
						sInnerHtml = trim(oChild(i).GetROProperty("innerhtml"))
				
						If instr(1,sInnerHtml,"tabSubHeader",1) > 0 Then	'is a tabSubHeader
							sInnerText = trim(oChild(i).GetROProperty("innertext"))
							If strcomp(sInnerText,trim(sActiveTab),1)<>0 Then	 'not match w/active tab
								If instr(1,sInnerHtml,"tab-disabled",1) > 0 Then		'tab is disabled
									reporter.ReportEvent micPass,"Tab '" &sInnerText &"' is disabled.",""
								Else
									reporter.ReportEvent micFail,"Tab '" &sInnerText &"' is not disabled.",""
								End If 
							End If
						End If	'tabSubHeader
					Next	'webtd Ifable obj
		
				Case Else	'verify tab name(s) - semicolon delimiter
					aDisabledTabs=split(sDisabledTab,";")
					For j=0 to ubound(aDisabledTabs)
						aDisabledTabs(j)=trim(aDisabledTabs(j))
						iDisabledFound=0
						For i=0 to oChild.Count-1
							sInnerHtml = trim(oChild(i).GetROProperty("innerhtml"))
							If instr(1,sInnerHtml,"tabSubHeader",1) > 0 Then	'is a tabSubHeader
								sInnerText = trim(oChild(i).GetROProperty("innertext"))
								If strcomp(sInnerText,aDisabledTabs(j),1) =0 Then	'tab found
									iDisabledFound=1
									If instr(1,sInnerHtml,"tab-disabled",1) > 0 Then		'tab is disabled
										reporter.ReportEvent micPass,"Tab '" &sInnerText &"' is disabled.",""
									Else
										reporter.ReportEvent micFail,"Tab '" &sInnerText &"' is not disabled.",""
									End If 		
									Exit For 
								End If 		'tab found
							End If	'tabSubHeader
						Next	'actual tab
		
						If iDisabledFound=0 Then
							reporter.ReportEvent micFail,"Tab '" &aDisabledTabs(j) &"' does not exist.",""
						End If
					Next 'next expected tab
			End Select
		End If 
		
		Set oAppBrowser=Nothing
		services.EndTransaction "maintabSubHeaderStatus"
	End Sub
	
	Function popupDialogButtonClick(sWebtableInnertext,sButtonName)
	   '************************************************************************************************************************************************************************
	   'Purpose: ChartSync - Click a button from a popup dialog window
	   ' Note: the popup dialog window is a WebTable object which contains child objects: WebButton
	   'Parameters: sWebtableInnertext = the WebTable property "innertext" value
	   '            sButtonName = the WebButton obj property 'name' value
	   'Calls: ajaxSync.ajaxSyncRequest("Processing Request",5)
	   'Returns: True/False
	   'Usage: call util.popupDialogButtonClick("All unsaved work will be lost. Are you sure you want to continue?","Confirm") <= click the Confirm button within the popup dialog window
	   'Created by: Hung Nguyen 9/18/12
	   'Modified: Hung Nguyen 10-17-12 modified to drop description.create
	   '          Hung Nguyen 4/12/13 Changed micfail to micWarning for... when the dialog window specified does not exist. This will also be used for negative testing.
	   '************************************************************************************************************************************************************************
	   services.StartTransaction "popupDialogButtonClick"
		Dim oTable
	
		popupDialogButtonClick=False 'init return value
	
		'verify parameters
		If sWebtableInnertext ="" or sButtonName="" Then
			reporter.ReportEvent micFail,"Invalid parameters","Either parameter 'sWebtableInnertext' and or 'sButtonName' does not have a value. Abort."
			ExitAction
		End If
	
		'Set oTable=Browser("title:=.*").WebTable("innertext:=" &sWebtableInnertext &".*")	'use regex
		Set oTable=Browser(Environment("BROWSER_OBJ")).WebTable("innertext:=" &sWebtableInnertext &".*")	'use regex
		If oTable.waitproperty("abs_x",micGreaterThan(0),5000) Then
			If oTable.WebButton("name:=" &sButtonName).Exist(2) Then
				oTable.WebButton("name:=" &sButtonName).Click
				Call ajaxSync.ajaxSyncRequest("Processing Request",5)
				popupDialogButtonClick=True 	'return value	
			End If 
		Else
			reporter.ReportEvent micWarning,"PopupDialogWindow","WebTable obj with property 'class:=rich-mp-content-table' does not exist. Nothing to do."
		End If		
		
		Set oTable=Nothing
		services.EndTransaction "popupDialogButtonClick"
	End Function	
	
	Function popupMenuItemSelect(parentObject,iRow,iCol,sMenuItem)
		'**********************************************************************************************************************************************************	
		'Purpose: ChartSync - Select a menu item in the popup window from a row and column number specified (in a WebTable obj)
		'Notes:     For use in Data Summary
		' Requires: The popup window must be activated/opened
		'                     The parentObject (WebTable) must exist
		' Parameters: parentObject = the WebTable obj which is the parent object of the popup window) 
		'                          iRow = row number
		'                         iCol = column number
		'                         sMenuItem = the menu item in the popup window to select
		'Calls: ajaxSync.ajaxSyncRequest("Processing Request",5)
		'Returns: True/False
		'Usage: Set oChartTable=oBrowser.WebTable("html id:=chartForm:chartTable")
		'				ochartTable.ChildItem(3,1,"WebElement",1).FireEvent "onmouseover"
		'				msgbox util.popupMenuItemSelect(oChartTable,3,1,"Chart Detail")				'<=select 'Chart Detail' from the 2nd barcode in the chart ID table
		'Created by: Hung Nguyen 11/5/10
		'Modified: Hung Nguyen 10/31/12 - Due to error w/selecting option from 1st row in table, updated to add parameters: iRow and iCol 
		'          Hung Nguyen 12/10/12 - Updated to allow select the popup item 'Break Lock'
		'          HUng Nguyen 3/4/13 - increased time out calling ajaxSync to 20 secs max.         
		'************************************************************************************************************************************
		Services.StartTransaction "popupMenuItemSelect"
		popupMenuItemSelect=False	'init return value
		Dim oTable,r,c,iFound,i,sRetVal
		
		'verify parameters
		If Not isnumeric(iRow) or Not isnumeric(iCol) Then
			reporter.ReportEvent micFail,"Invalid parameter","Parameter  'iRow' and 'iCol' must be numeric."
			Exit Function
		End If
		
		If isObject(parentObject) And parentObject.Exist(5) Then	'is an obj and exists
			Set oTable=parentObject
			r=iRow
			c=iCol
			iFound=0
			For i=0 to oTable.ChildItemCount(r,c,"WebElement") -1
				sRetVal=oTable.ChildItem(r,c,"WebElement",i).GetROProperty("innertext")
				If sRetVal<>"" and strcomp(sRetVal,sMenuItem,1)=0 Then
					iFound=1
					oTable.ChildItem(r,c,"WebElement",i).Click
					reporter.ReportEvent micPass,"popupMenuItemSelect","Menu item '" &sRetVal &"' found and clicked. Item index " &i
	
					Call ajaxSync.ajaxSyncRequest("Processing Request",20)
					popupMenuItemSelect=True	'return value
					Exit For 
				End If
			Next 
	
			If iFound=0 Then
				reporter.ReportEvent micWarning,"popupMenuItemSelect","Menu item '" &sMenuItem &"' not found."
			End If
			Set oTable=Nothing
		Else
			Reporter.ReportEvent micFail,"popupMenuItemSelect", "Either the parent object specified is not an object or does not exist."
		End If
		Services.EndTransaction "popupMenuItemSelect"
	End Function
	
	Function addEncounter (sTabName, sRendProv, sPageNumber, sServiceTypeDate, sDosEo, sIcdEo,sComments)
   		'***********************************************************************************************************
		'Purpose: Add a New Encounter in Code Review, CV,QA, CVQA Screens
		'Parameters: sTabName= "claimsVerify"
								'	sRendProv  = "select" OR "Not Listed~4^Trinity~1^Prov NPI~7^asdhjhd~8^12321~9^1241234124~2^qweqw~3^adzsd~1^Done~5^Help"
								'						' First Split thru '~', Which give the data for different options to select Rendering Provider data
								'						'Second Split thru '^' Which specifies the data for Not listed pop up with the data passed at position like @ 1st Edit box data sent is Prov NPI
								'	sPageNumber = "12,3-5"
								'	sServiceTypeDate = "IP~11/11/2011~11/11/2011"  OR "IP~11/11/2011~12/12/2011~A012"
								'	sDosEo = "D02:A012~D04:A012~D08:A012"
								'						' First Split thru '~', Which give the data for E&O Codes with update Reason
								'						'Second Split thru ':' Which separtes data for E&O Codes and update Reason
								'	sIcdEo = "255.0-A007:D02-A013:D04-A013~250.00-A007:::D04-A013~P:194.3-A007::D08-A013:D12-A013"
								'						' First Split thru '~', Which give the entire record for ICD Data
								'						'Second Split thru ':' Which separtes data for E&O Codes with ICD
								'						'Third Split thru '-' which separates E&O Reason Code & Update Reason
								'	sComments = "Encounter Created Automatically Thru Script"
		'NOTE: This function will create encounter at Coding, CV, CVQA or at QA Screens
		'Calls: util.tabHeaderStatus(sTabName)
		'		ajaxSync.ajaxSyncRequest("Processing Request",60)
		'		util.popupDialogButtonClick("Encounter submitted is a duplicate date of service","Confirm")
		'Returns: Encounter created State True ot False
		'Usage:  
		' CODING TAB - util.addEncounter("Code Review", "Select", "12,3-5", "IP~11/11/2011~12/12/2011", "D02~D04~D08", "255.0:D02:D04~250.00:::D04~P:194.3::D08:D12", "Auto Created thru Script)
		' QA TAB - util.addEncounter("qaReview", "Not Listed~1^ProvNPI~7^AB~10^Post", "1,2,3-5", "OP~12/11/2011~12/11/2011", "D02", "255.0-A007:D02-A013:D04-A013", "Auto Created thru Script)
		' CV TAB - util.addEncounter("claimsVerify", "RENDERING = RETRIEVAL~1^ProvNPI~7^AB", "12345", "HOP~10/09/2011~12/11/2011", "D02:A012~D04:A012~D08:A012", "P:255.0-A007:D02-A013:D04-A013", "Auto Created thru Script)
		' CVQA TAB - util.addEncounter("cvQa", "<Rendering LName, Rendering FName>", "125", "SNF~10/01/2011~12/12/2011", "D02:A012~D04~D08:A012", "255.0-A007:D02-A013:D04-A013~250.00-A007:::D04-A013~P:194.3-A007::D08-A013:D12-A013", "Auto Created thru Script)
		'Created by: Govardhan Choletti 09/11/12
		'Modified: Govardhan Choletti 09/20/12  -  Removed Option Explicit & Load Initialize file
		'		   Govardhan Choletti 10/08/12  -  Updated as per the recent change in R=R functionality
		'		   Govardhan Choletti 11/07/12  -  adding Tax ID & converting State from Text box to List box in Pick list Edit
		'***********************************************************************************************************
		Services.StartTransaction "addEncounter"
		Dim oAppBrowser
		Dim sCurrentTab, sRenderingProvider, sRenderingProvID, sRenderingReport, sRendProvAllItems
		Dim aRendProv, aRendProvData, aServiceTypeDate, aDosEo, aEOCode, aEncounterEo, aICDCode, aICDEoReason
		Dim bEncounterDeleted
		Dim i, j, iCnt
		addEncounter = True
		sRendProvAllItems = ""

		'Any browser obj (which contains the child obj
		Set oAppBrowser = Browser(Environment("BROWSER_OBJ")).Page("title:="&Environment("BROWSER_TITLE"))

		'Verify User is woking in Correct tab
		If instr(1, util.tabHeaderStatus(sTabName),"active",1) > 0 Then
			If Instr(1, LCase(sTabName), "code", 1) > 0 Then
				sCurrentTab = "Coding"
			ElseIf Instr(1, sTabName, "claimsVerify", 1) > 0 OR Instr(1, sTabName, "Claims Verification", 1) > 0 Then
				sCurrentTab = "CV"
			ElseIf Instr(1, sTabName, "qaReview", 1) > 0 Then
				sCurrentTab = "QA"
			ElseIf Instr(1, sTabName, "cvQa", 1) > 0 Then
				sCurrentTab = "CVQA"
			End If

		' If detail Encounter Page is Not  Available
			If of.objectFinder("WebList", "html id~html tag", ".*Form:.*[R|r]enderingProvMenu~SELECT", "True~False") = True Then
				' Do Nothing
			Else
				' Click on 'Add Encounter' Button
					If of.webButtonClicker("Add") = True Then
						Reporter.ReportEvent micPass,"Add Encounter","'Mouse Left Click on 'Add Encounter Button in '"& sCurrentTab &"' tab is successful"
						Wait(5)
					Else
						Reporter.ReportEvent micFail,"Add Encounter","'Unable to click on 'Add Encounter Button in '"& sCurrentTab &"' tab, Which is NOT as Expected"
						addEncounter = False
						services.EndTransaction "addEncounter"
						Exit Function
					End If
			End If

			If sRendProv="" or isempty(sRendProv) Then
				Reporter.ReportEvent micFail,"Invalid Parameter","Parameter 'Rendering Provider: ' must contains a value. There is always 'Select' value auto populated in ListBox"
				'Exit Function
			End If

			'Get the Value that to be choosen from List Box
			aRendProv = Split(sRendProv, "~")
			If isnumeric(aRendProv(0)&"e0") Then
				sRenderingProvider = CInt(sRendProv)
			Else
				Select Case Ucase(aRendProv(0))
					Case "SELECT"
						sRenderingProvider = "Select"
					Case "NOT LISTED"
						sRenderingProvider = "Not Listed"
					Case "RENDERING = RETRIEVAL"
						sRenderingProvider = "RENDERING = RETRIEVAL"
					Case Else
						sRendProvAllItems = of.objectAction("WebList","GetRoProperty~all items", "html id~html tag", ".*Form:.*[R|r]enderingProvMenu~SELECT", "True~False")
						If Instr(1, sRendProvAllItems, sRenderingProvider, 1) > 0  Then
							sRenderingProvider = aRendProv(0)
						Else
							Reporter.ReportEvent micFail,"Rendering Provider ListBox","Rendering Provider details ' '"& aRendProv(0) &"' is not available in PickList, Please check the passing parameter - 'sRendProv'"
							addEncounter = False
							services.EndTransaction "addEncounter"
							Exit Function
						End If
				End Select
			End If			
		
		'verify parameters - Rendering Provider List Box and Select the appropriate value as passed by User
			If of.objectAction("WebList","Select~"& sRenderingProvider, "html id~html tag", ".*Form:.*[R|r]enderingProvMenu~SELECT", "True~False") = True Then
				Reporter.ReportEvent micPass,"ListBox - Rendering Provider","Value '"& sRenderingProvider &"' is selected from Rendering Provider ListBox, as Expected"
				If Instr(1, sRenderingProvider, "Not Listed" ,1) > 0 OR Instr(1, sRenderingProvider, "RENDERING = RETRIEVAL" ,1) > 0 Then
					
				' Click on Edit Link to Open the Panel
					If of.linkClickerWIndex("Edit", 0) = True Then
						Reporter.ReportEvent micPass,"Edit PickList","'Clicked on Link 'Edit' to open Rendering Provider Pop-up, as Expected"
						
						' Loop thru each data available as passed by user if Not-Listed/Rendering = Retrieval field is selected
						For i= 1 to UBound(aRendProv) Step 1
							aRendProvData = Split(aRendProv(i), "^")
							sRenderingReport = ""
							Select Case aRendProvData(0)
								Case 1
									sRenderingProvID = ".*[R|r]enderingProvForm:.*[R|r]enderingProvDetVal1"				'	Enter Provider NPI
									sRenderingReport = "Provider NPI"
								Case 2
									sRenderingProvID = ".*[R|r]enderingProvForm:.*[R|r]enderingProvFNVal1"			'Provider First Name:
									sRenderingReport = "Provider First Name"
								Case 3
									sRenderingProvID = ".*[R|r]enderingProvForm:.*[R|r]enderingProvLNVal1"			'Provider Last Name:
									sRenderingReport = "Provider Last Name"
								Case 4
									sRenderingProvID = ".*[R|r]enderingProvForm:.*[R|r]enderingProvAdd1Val1"			'Provider Address 1
									sRenderingReport = "Provider Address 1"
								Case 5
									sRenderingProvID = ".*[R|r]enderingProvForm:.*[R|r]enderingProvAdd2Val1"			'Provider Address 2
									sRenderingReport = "Provider Address 2"
								Case 6
									sRenderingProvID = ".*[R|r]enderingProvForm:.*[R|r]enderingProvCityVal1"			'Provider City:
									sRenderingReport = "Provider City"
								Case 7
									'sRenderingProvID = ".*[R|r]enderingProvForm:.*[R|r]enderingProvStaVal1"			'Provider State:
									sRenderingProvID = ".*[R|r]enderingProvForm:.*[R|r]enderingProvStateValueList1"
									sRenderingReport = "Provider State"
									aRendProvData(1) = UCase(Left(aRendProvData(1), 2))
								Case 8
									sRenderingProvID = ".*[R|r]enderingProvForm:.*[R|r]enderingProvZipVal1"				'Provider Zip:
									sRenderingReport = "Provider Zip"
									aRendProvData(1) = Left(aRendProvData(1), 9)
								Case 9
									sRenderingProvID = ".*[R|r]enderingProvForm:.*[R|r]enderingProvPHVal1"				'Provider Phone No.:
									sRenderingReport = "Provider Phone No"
									aRendProvData(1) = Left(aRendProvData(1), 10)
								Case 10
									sRenderingProvID = ".*[R|r]enderingProvForm:.*[R|r]enderingProvFTVal1"				'Provider Tax ID:
									sRenderingReport = "Provider Tax ID"
								Case Else
									Reporter.ReportEvent micFail,"Rendering Provider Details","Rendering Provider details are not passed correctly, Please check the passing parameter - '"& aRendProvData(0) &"'"
							End Select

							' Verify Rendering Provider Data
							If sRenderingReport <> "" And UBound(aRendProvData)>0 Then
								' Select Rendering Provider State Details
								If CInt(aRendProvData(0)) = 7 Then
									If Instr(1, of.objectAction("WebList","GetRoProperty~all items", "html id~html tag", sRenderingProvID &"~SELECT", "True~False"), aRendProvData(1) , 1) > 0 Then
										If of.objectAction("WebList","Select~"& aRendProvData(1), "html id~html tag", sRenderingProvID &"~SELECT", "True~False") = True Then
											Reporter.ReportEvent micPass,"Rendering Provider --> "& sRenderingReport, "Successfully selected '"& aRendProvData(1) &"' in '"& sRenderingReport &"' List Box, as Expected"
										Else
											Reporter.ReportEvent micFail,"Rendering Provider --> "& sRenderingReport, "Unable to select '"& aRendProvData(1) &"' in '"& sRenderingReport &"' List Box, Which is NOT as Expected"
											Exit Function
										End If
									Else
										Reporter.ReportEvent micFail,"Rendering Provider --> "& sRenderingReport, "Unable to select '"& aRendProvData(1) &"' in '"& sRenderingReport &"' List Box as value passed '"& aRendProvData(1) &"' is Not Present, Which is NOT as Expected"
										Exit Function
									End If
								Else
									' Enter Rendering Provider Info
									If of.objectAction("WebEdit","Set~"& aRendProvData(1), "html id~html tag",sRenderingProvID &"~INPUT", "True~False") = True Then
										Reporter.ReportEvent micPass,"Rendering Provider --> "& sRenderingReport, "Successfully entered '"& aRendProvData(1) &"' in '"& sRenderingReport &"' Text Box, as Expected"
									Else
										Reporter.ReportEvent micFail,"Rendering Provider --> "& sRenderingReport, "Unable to enter '"& aRendProvData(1) &"' in '"& sRenderingReport &"' Text Box, Which is NOT as Expected"
										Exit Function
									End If
								End If
							Else
								Reporter.ReportEvent micFail,"Rendering Provider Details","Rendering Provider details are not passed correctly, Please check the passing parameter - 'sRendProv'"
								addEncounter = False
								services.EndTransaction "addEncounter"
								Exit Function
							End If
						Next

						'Perform Click on Done after entered Data
						If of.objectAction("WebButton","Click", "html id~name~html tag", ".*[r|R]enderingProvForm:j_id\d*~Done~INPUT", "True~False~False") = True Then
							Reporter.ReportEvent micPass,"Rendering Provider --> Click Done","'Mouse Left Click on Done Button"
						Else
							Reporter.ReportEvent micFail,"Rendering Provider --> Click Done","'Unable to click on 'Done' button, Which is NOT as Expected"
						End If
					Else
						addEncounter = False
						Reporter.ReportEvent micWarning,"Edit PickList","'Unable to click on Link 'Edit' to open Rendering Provider Pop-up, as Expected"
						Exit Function
					End If
				End If
			Else
				Reporter.ReportEvent micFail,"ListBox - Rendering Provider","Unable to find the Value '"& sRenderingProvider &"' in Rendering Provider ListBox, NOT as Expected"
				addEncounter = False
				services.EndTransaction "addEncounter"
				Exit Function
			End If

		' Enter page Number
			If of.objectAction("WebEdit","Set~"& sPageNumber, "html id~html tag", " .*Form:.*[R|r]enderingProvPageNoTxtValue~INPUT", "True~False") = True Then
				Reporter.ReportEvent micPass,"Chart Image Page Number","'Successfully entered '"& sPageNumber &"' in Chart Image Page Number Text Box, as Expected"
			Else
				Reporter.ReportEvent micFail,"Chart Image Page Number","'Unable to enter '"& sPageNumber &"' in Chart Image Page Number Text Box, Which is NOT as Expected"
				Exit Function
			End If

		'Fill the Service Type, Service Dates & Update Reason;
			aServiceTypeDate = Split(sServiceTypeDate, "~")

			'Select Service Type
			If Instr(1,"OP~IP~HOP~SNF", UCase(aServiceTypeDate(0)) ,1) > 0 Then
				If of.objectAction("WebElement","Click", "html id~innertext~html tag", "~"& UCase(aServiceTypeDate(0)) &"~LABEL", "False~False~False") = True Then
					Reporter.ReportEvent micPass,"Service Type","'Successfully selected Service Type : '"& UCase(aServiceTypeDate(0)) &"', as Expected"
				Else
					Reporter.ReportEvent micFail,"Service Type","'Unable to select Service type : '"& UCase(aServiceTypeDate(0)) &"', Which is NOT as Expected"
					Exit Function
				End If
			Else
				Reporter.ReportEvent micFail,"Service Type", aServiceTypeDate(0) &"' is invalid service type and it has to be 'OP, IP, HOP', 'SNF', Which is NOT as Expected"
				addEncounter = False
				services.EndTransaction "addEncounter"
				Exit Function
			End If

			'Select 'Service From' date
			If of.objectAction("WebEdit","Set~"& aServiceTypeDate(1), "html id~html tag", ".*Form:.*[a|A]ddEncounterFromDateValue~INPUT", "True~False") = True Then
				Reporter.ReportEvent micPass,"Service From Date","'Successfully entered '"& aServiceTypeDate(1) &"' in Service From date Text Box, as Expected"
			Else
				Reporter.ReportEvent micFail,"Service From Date","'Unable to enter '"& aServiceTypeDate(1) &"' in Service From date Text Box, Which is NOT as Expected"
				addEncounter = False
				services.EndTransaction "addEncounter"
				Exit Function
			End If

			'Select 'Service Thru' date
			If of.objectAction("WebEdit","Set~"& aServiceTypeDate(2), "html id~html tag", ".*Form:.*[a|A]ddEncounterThruDateValue~INPUT", "True~False") = True Then
				Reporter.ReportEvent micPass,"Service Thru Date","'Successfully entered '"& aServiceTypeDate(2) &"' in Service Thru date Text Box, as Expected"
			Else
				Reporter.ReportEvent micFail,"Service Thru Date","'Unable to enter '"& aServiceTypeDate(2) &"' in Service Thru date Text Box, Which is NOT as Expected"
				addEncounter = False
				services.EndTransaction "addEncounter"
				Exit Function
			End If

			'Select Update Reason code for CV,QA, CVQA Tabs
				If Instr(1,"CV~QA~CVQA", sCurrentTab, 1) = 0 Then
					' Do Nothing
				ElseIf Not(aServiceTypeDate(3) = "" Or isempty(aServiceTypeDate(3))) Then
					If Instr(1,"A010~A012", aServiceTypeDate(3), 1) > 0 Then
						If of.objectAction("WebList","Select~"& Ucase(aServiceTypeDate(3)), "html id~html tag", ".*AddEncForm:.*[U|u]pdateReasonCdAdd1~SELECT", "True~False") = True Then
							Reporter.ReportEvent micPass,"DOS Update Reason Code","'Successfully selected update Reason code '"& UCase(aServiceTypeDate(3)) &"' , as Expected"
						Else
							Reporter.ReportEvent micFail,"DOS Update Reason Code","'Unable to select update Reason code '"& UCase(aServiceTypeDate(3)) &"', Which is NOT as Expected"
							Exit Function
						End If
					Else
						Reporter.ReportEvent micFail,"DOS Update Reason Code","'DOS update Reason code '"& UCase(aServiceTypeDate(3)) &"' is NOT Valid and has to be 'A010' or 'A012', Which is NOT as Expected"
						addEncounter = False
						services.EndTransaction "addEncounter"
						Exit Function
					End If
				End If

			' Select DOS Level E&O Codes
			aDosEo = Split(sDosEo, "~")
			For i=0 to UBound(aDosEo) Step 1
				aEOCode = Split(aDosEo(i), ":")

				'Verify the Data passed as Input
				If UBound(aEOCode) >= 0 Then
					' Enter E&O Code
					If aEOCode(0) = "" or isEmpty(aEOCode(0)) Then
						'Do Nothing
					Else
						If of.objectAction("WebEdit","Set~"& UCase(aEOCode(0)), "html id~html tag", ".*Form:.*[a|A]ddEncounterEO"& (i+1) &"~INPUT", "True~False") = True Then
							Reporter.ReportEvent micPass,"ServiceDescription - E&O - "& (i+1),"'Successfully entered '"& aEOCode(0) &"' in Service description E&O - "& (i+1)&" Text Box, as Expected"
						Else
							Reporter.ReportEvent micFail,"ServiceDescription - E&O - "& (i+1),"'Unable to enter '"& aEOCode(0) &"' in Service description E&O - "& (i+1)&" Text Box, Which is NOT as Expected"
							addEncounter = False
							services.EndTransaction "addEncounter"
							Exit Function
						End If
					End If
				End If

				If UBound(aEOCode) > 0 Then
				'Enter Service Description Update Reason
					If aEOCode(1) = "" or isEmpty(aEOCode(1)) Then
						'Do Nothing
					ElseIf Instr(1,"CV~QA~CVQA", sCurrentTab, 1) > 0 Then
						If Instr(1,"A012", aEOCode(1), 1) > 0 Then
							If of.objectAction("WebList","Select~"& Ucase(aEOCode(1)), "html id~html tag", ".*AddEncForm:.*UpdateReasonCdAdd"& (i+2)&"~SELECT", "True~False") = True Then
								Reporter.ReportEvent micPass,"ServiceDescription - E&O Update Reason - "& (i+1),"'Successfully entered '"& aEOCode(1) &"' in Service description E&O Update Reason- "& (i+1)&" Text Box, as Expected"
							Else
								Reporter.ReportEvent micFail,"ServiceDescription -  E&O Update Reason - "& (i+1),"'Unable to enter '"& aEOCode(1) &"' in Service description E&O Update Reason - "& (i+1)&" Text Box, Which is NOT as Expected"
							End If
						Else
							Reporter.ReportEvent micFail,"DOS E&O Update Reason Code","'DOS update Reason code '"& UCase(aEOCode(1)) &"' at position "& (i+1) &" is NOT Valid and has to be 'A012', Which is NOT as Expected"
							addEncounter = False
							services.EndTransaction "addEncounter"
							Exit Function
						End If
					End If
				End If
			Next

			aEncounterEo = Split(sIcdEo, "~")
			If UBound(aEncounterEo) < 10 Then
				For i=0 to UBound(aEncounterEo) Step 1
					aICDCode = Split(aEncounterEo(i), ":")

					' Loop across each value to submit E&O Code and Update Reason
					iCnt = 0
					For j=0 to UBound(aICDCode) Step 1

						' Verify the Encounter provided is Primary
						If Ucase(aICDCode(j)) = "P" Then
							iCnt = iCnt +1
							If of.objectAction("WebCheckBox","Click", "html id~html tag", ".*Form:.*[a|A]ddEncounterDiagnosisTable:"& i &":.*[p|P]rimaryIcd9Value~INPUT", "True~False") = True Then
								Reporter.ReportEvent micPass,"Encounter - CheckBox - "& (i+1),"'Successfully checked primary check box at Row  '"& (i+1) &"' in Encounter Section, as Expected"
							Else
								Reporter.ReportEvent micFail,"Encounter - CheckBox - "& (i+1),"'Unable to check primary check box at Row  '"& (i+1) &"' in Encounter Section, Which is NOT as Expected"
								Exit Function
							End If
						Else
							aICDEoReason = Split(aICDCode(j), "-")
							If j = iCnt Then
								' Enter ICD value in the Field
								If UBound(aICDEoReason) >= 0 Then
									If of.objectAction("WebEdit","Set~"& UCase(aICDEoReason(0)), "html id~html tag", ".*Form:.*[a|A]ddEncounterDiagnosisTable:"& i &":.*[i|I]cd9Value~INPUT", "True~False") = True Then
										Reporter.ReportEvent micPass,"Encounter ICD - "& (i+1),"'Successfully entered '"& aICDEoReason(0) &"' in ICD Text Box at Row - "& (j-iCnt+1)&" Text Box, as Expected"
									Else
										Reporter.ReportEvent micFail,"Encounter ICD - "& (i+1),"'Unable to enter '"& aICDEoReason(0) &"' in ICD Text Box at Row - "& (j-iCnt+1)&" Text Box, Which is NOT as Expected"
										Exit Function
									End If
								End If

							'Select the ICD Field Update Reason
								If UBound(aICDEoReason) > 0 Then
									If aICDEoReason(1) = "" or isEmpty(aICDEoReason(1)) Then
										'Do Nothing
									ElseIf Instr(1,"CV~QA~CVQA", sCurrentTab, 1) > 0 Then
										If Instr(1,"A007", aICDEoReason(1), 1) > 0 Then
											If of.objectAction("WebList","Select~"& Ucase(aICDEoReason(1)), "html id~html tag", ".*Form:.*[a|A]ddEncounterDiagnosisTable:"& i &":.*[a|A]ddEncounterDiagnosisTable1:0:.*DiagUpdateCdAdd1~SELECT", "True~False") = True Then
												Reporter.ReportEvent micPass,"Encounter ICD Update Reason - "& (i+1),"'Successfully selected '"& aICDEoReason(1) &"' in ICD Update Reason - "& (j-iCnt+1)&" List Box, as Expected"
											Else
												Reporter.ReportEvent micFail,"Encounter ICD Update Reason - "& (i+1),"'Unable to select '"& aICDEoReason(1) &"' in ICD Update Reason - "& (j-iCnt+1)&" List Box, Which is NOTas Expected"
												Exit Function
											End If
										Else
											Reporter.ReportEvent micFail,"DX Update Reason Code","'DX update Reason code '"& UCase(aICDEoReason(1)) &"' at position "& (j-iCnt+1) &" is NOT Valid and has to be 'A007', Which is NOT as Expected"
											addEncounter = False
											services.EndTransaction "addEncounter"
											Exit Function
										End If
									End If
								End If
							Else
								' Enter ICD E&Ovalue in the Field
								If UBound(aICDEoReason) >= 0 Then
									If of.objectAction("WebEdit","Set~"& UCase(aICDEoReason(0)), "html id~html tag", ".*Form:.*[a|A]ddEncounterDiagnosisTable:"& i &":.*[e|E]oCode"& (j-iCnt)&"Value~INPUT", "True~False") = True Then
										Reporter.ReportEvent micPass,"Encounter ICD E&O Row - "& (i+1),"'Successfully entered '"& aICDEoReason(0) &"' in ICD E&OText Box at Row - "& (i+1)&" and position "& (j-iCnt)&", as Expected"
									Else
										Reporter.ReportEvent micFail,"Encounter ICD E&O Row - "& (i+1),"'Unable to enter '"& aICDEoReason(0) &"' in ICD E&OText Box at Row - "& (i+1)&" and position "& (j-iCnt)&", Which is NOT as Expected"
										addEncounter = False
										services.EndTransaction "addEncounter"
										Exit Function
									End If
								End If

								'Select the ICD E&O Field Update Reason
								If UBound(aICDEoReason) >0 Then
									If aICDEoReason(1) = "" or isEmpty(aICDEoReason(1)) Then
										'Do Nothing
									ElseIf Instr(1,"CV~QA~CVQA", sCurrentTab, 1) > 0 Then
										If Instr(1,"A013", aICDEoReason(1), 1) > 0 Then
											If of.objectAction("WebList","Select~"& Ucase(aICDEoReason(1)), "html id~html tag", ".*Form:.*[a|A]ddEncounterDiagnosisTable:"& i &":.*[a|A]ddEncounterDiagnosisTable2:0:.*DiagUpdateCdAdd"& (j-iCnt+1)&"~SELECT", "True~False") = True Then
												Reporter.ReportEvent micPass,"Encounter ICD E&O Update Reason - "& (i+1),"'Successfully selected '"& aICDEoReason(1) &"' in ICD E&O Update Reason List Box at Row - "& (i+1)&" and position "& (j-iCnt)&", as Expected"
											Else
												Reporter.ReportEvent micFail,"Encounter ICD E&O Update Reason - "& (i+1),"'Unable to select '"& aICDEoReason(1) &"' in ICD E&O Update Reason List Box at Row - "& (i+1)&" and position "& (j-iCnt)&", Which is NOT as Expected"
												Exit Function
											End If
										Else
											Reporter.ReportEvent micFail,"DX E&O Update Reason Code","'DX E&O update Reason code '"& UCase(aICDEoReason(1)) &"' at position "& (j-iCnt+1) &" is NOT Valid and has to be 'A013', Which is NOT as Expected"
											addEncounter = False
											services.EndTransaction "addEncounter"
											Exit Function
										End If
									End If
								End If
							End If
						End If
					Next		
				Next
			Else
				Reporter.ReportEvent micFail,"add Encounter --> Icd Diagnosis Codes","'add Encounter' Function can able to add only up to 10 Diagnosis code, adjust the input and recall the function"
				addEncounter = False
			End If
		
		'In Coding Tab Click on Link View/Add Comments
			If Instr(1,"Coding", sCurrentTab, 1) > 0 Then
				If of.linkClicker("View/Add Comments") = True Then
					Reporter.ReportEvent micPass,"View/Add Comments","'Clicked on Link 'View/Add Comments' to expand selection Comments Text Box, as Expected"
				Else
					Reporter.ReportEvent micWarning,"View/Add Comments","'Unable to click on Link 'View/Add Comments' to expand selection Comments Text Box, as Expected"
					Exit Function
				End If
			End If

		' Enter Comments <If Any>
			If of.objectAction("WebEdit","Set~"& sComments, "html id~html tag", ".*Form:.*[d|D]iagnosisNewCommentValue~TEXTAREA", "True~False") = True Then
				Reporter.ReportEvent micPass,"Add New Comments:","'Successfully entered '"& sComments &"' in Comments Text Box, as Expected"
			Else
				Reporter.ReportEvent micFail,"Add New Comments:","'Unable to enter '"& sComments &"' in Comments Text Box, Which is NOT as Expected"
				Exit Function
			End If

		'Click on Save Button to save Encounter
			If of.objectAction("WebButton","Click", "html id~html tag~Index", ".*Form:.*[s|S]aveEncounterButton.*~INPUT~0", "True~False~False") = True Then
				Reporter.ReportEvent micPass,"Encounter - Save","'Clicked on Button 'Save' to Save Encounter, as Expected"
			Else
				Reporter.ReportEvent micFail,"Encounter - Save","'Unable to Click on Button 'Save' to Save Encounter, Which is NOT as Expected"
				Exit Function
			End If

			Call ajaxSync.ajaxSyncRequest("Processing Request",60)
			
		'If Duplicate Encounter Exist, Click on 'Confirm' Button
			'If of.objectFinder("WebButton","html id~name~html tag", ".*Form.*:.*[c|C]onfirmDup.*ModalPanelConfirmButton.*~Confirm~INPUT", "True~False~False") = True Then
			'	call util.popupDialogButtonClick("Encounter submitted is a duplicate date of service","Confirm")
			'End If
			If Browser(Environment("BROWSER_OBJ")).WebTable("innertext:=Encounter submitted is a duplicate date of service.*").waitproperty("abs_x",micGreaterThan(0),5000) Then
				'call util.popupDialogButtonClick("Encounter submitted is a duplicate date of service","Confirm")
				If Not util.popupDialogButtonClick("Encounter submitted is a duplicate date of service","Confirm") Then 
					exitaction
				End If 
			End If
			
			Call ajaxSync.ajaxSyncRequest("Processing Request",60)
			
		'Verify If the Encounter added successfully by Verifying Add Button
			If of.objectFinder("WebButton","html id~name~html tag", ".*Form:.*[a|A]ddEncounterBtn~.*Add.*~INPUT", "True~True~False") = True Then
				Reporter.ReportEvent micPass,"add Encounter","'Encounter added succesfully, as Expected"
			Else
				Reporter.ReportEvent micWarning,"add Encounter","'Unable to Add Encounter with the input parameters passed"
				addEncounter = False
			End If
			Set oAppBrowser = Nothing
		Else
			addEncounter = False
		End If
		services.EndTransaction "addEncounter"
	End Function
	
	Function modifyEncounter (sTabName, sRendProv, sPageNumber, sServiceTypeDate, sDosEo, sIcdEo,sComments)
   		'***********************************************************************************************************
		'Purpose: Add a New Encounter in Code Review, CV,QA, CVQA Screens
		'Parameters: sTabName= "claimsVerify"
								'	sRendProv  = "select" OR "Not Listed~4^Trinity~1^Prov NPI~7^asdhjhd~8^12321~9^1241234124~2^qweqw~3^adzsd~1^Done~5^Help"
								'						' First Split thru '~', Which give the data for different options to select Rendering Provider data
								'						'Second Split thru '^' Which specifies the data for Not listed pop up with the data passed at position like @ 1st Edit box data sent is Prov NPI
								'	sPageNumber = "12,3-5"
								'	sServiceTypeDate = "IP~11/11/2011~11/11/2011"  OR "IP~11/11/2011~12/12/2011~A012"
								'	sDosEo = "D02:A012~D04:M012~D08:S012"
								'						' First Split thru '~', Which give the data for E&O Codes with update Reason
								'						'Second Split thru ':' Which separtes data for E&O Codes and update Reason
								'	sIcdEo = "255.0-S004:D02-A013:D04-M013~250.00-S008:::D04-S013~P:194.3-M011::D08-M013:D12-S013"
								'						' First Split thru '~', Which give the entire record for ICD Data
								'						'Second Split thru ':' Which separtes data for E&O Codes with ICD
								'						'Third Split thru '-' which separates E&O Reason Code & Update Reason
								'	sComments = "Encounter Created Automatically Thru Script"
		'NOTE: This function will create encounter at Coding, CV, CVQA or at QA Screens
		'Calls: util.tabHeaderStatus(sTabName)
		'		ajaxSync.ajaxSyncRequest("Processing Request",60)
		'		util.popupDialogButtonClick("Encounter submitted is a duplicate date of service","Confirm")
		'Returns: Encounter created State True ot False
		'Usage:  
		' CODING TAB - util.modifyEncounter("Code Review", "Select", "12,3-5", "IP~11/11/2011~12/12/2011", "D02~D04~D08", "255.0:D02:D04~250.00:::D04~P:194.3::D08:D12", "Auto Created thru Script)
		' QA TAB - util.modifyEncounter("Qa Review", "Not Listed~1^ProvNPI~7^AB~10^Post", "1,2,3-5", "OP~12/11/2011~12/11/2011", "D02", "255.0-A007:D02-S013:D04-M013", "Auto Created thru Script)
		' CV TAB - util.modifyEncounter("Claims Verification", "RENDERING = RETRIEVAL~1^ProvNPI~7^AB", "12345", "HOP~10/09/2011~12/11/2011~M012", "D02:S012~D04:A012~D08:M012", "P:255.0-M011:D02-M013:D04-S013", "Auto Created thru Script)
		' CVQA TAB - util.modifyEncounter("CVQA", "<Rendering LName, Rendering FName>", "125", "SNF~10/01/2011~12/12/2011~M001", "D02:A012~D04:M012~D08:S012", "255.0-S004:D02-A013:D04-M013~250.00-S008:::D04-S013~P:194.3-M011::D08-M013:D12-S013", "Auto Created thru Script)
		'Created by: Govardhan Choletti 01/08/13
		'Modified: 
		'***********************************************************************************************************
		Services.StartTransaction "modifyEncounter"
		Dim oAppBrowser
		Dim sCurrentTab, sRenderingProvider, sRenderingProvID, sRenderingReport, sRendProvAllItems
		Dim aRendProv, aRendProvData, aServiceTypeDate, aDosEo, aEOCode, aEncounterEo, aICDCode, aICDEoReason
		Dim bEncounterDeleted
		Dim i, j, iCnt
		modifyEncounter = True
		sRendProvAllItems = ""

		'Any browser obj (which contains the child obj
		Set oAppBrowser = Browser(Environment("BROWSER_OBJ")).Page("title:="&Environment("BROWSER_TITLE"))
		Browser(Environment("BROWSER_OBJ")).Sync
		
		'Verify User is woking in Correct tab
		If instr(1, util.tabHeaderStatus(sTabName),"active",1) > 0 Then
			If Instr(1, LCase(sTabName), "code", 1) > 0 Then
				sCurrentTab = "Coding"
			ElseIf Instr(1, sTabName, "claimsVerify", 1) > 0 OR Instr(1, sTabName, "Claims Verification", 1) > 0 Then
				sCurrentTab = "CV"
			ElseIf Instr(1, sTabName, "qaReview", 1) > 0 Then
				sCurrentTab = "QA"
			ElseIf Instr(1, sTabName, "cvQa", 1) > 0 Then
				sCurrentTab = "CVQA"
			End If

		' If detail Encounter Page is Not  Available
			If of.objectFinder("WebList", "html id~html tag", ".*Form:.*[R|r]enderingProvMenu~SELECT", "True~False") = True Then
				' Do Nothing
			Else
				Reporter.ReportEvent micFail,"Modify Encounter","'Unable to Modify Encounter in '"& sCurrentTab &"' tab, as Detail Encounter Page is Not displayed, Which is NOT as Expected"
				modifyEncounter = False
				services.EndTransaction "modifyEncounter"
				Exit Function
			End If

			If sRendProv="" or isempty(sRendProv) Then
				Reporter.ReportEvent micFail,"Invalid Parameter","Parameter 'Rendering Provider: ' must contains a value. There is always 'Select' value auto populated in ListBox"
				'Exit Function
			End If

			'Get the Value that to be choosen from List Box
			aRendProv = Split(sRendProv, "~")
			If isnumeric(aRendProv(0)&"e0") Then
				sRenderingProvider = CInt(sRendProv)
			Else
				Select Case Ucase(aRendProv(0))
					Case "SELECT"
						sRenderingProvider = "Select"
					Case "NOT LISTED"
						sRenderingProvider = "Not Listed"
					Case "RENDERING = RETRIEVAL"
						sRenderingProvider = "RENDERING = RETRIEVAL"
					Case Else
						sRendProvAllItems = of.objectAction("WebList","GetRoProperty~all items", "html id~html tag", ".*Form:.*[R|r]enderingProvMenu~SELECT", "True~False")
						If Instr(1, sRendProvAllItems, sRenderingProvider, 1) > 0  Then
							sRenderingProvider = aRendProv(0)
						Else
							Reporter.ReportEvent micFail,"Rendering Provider ListBox","Rendering Provider details ' '"& aRendProv(0) &"' is not available in PickList, Please check the passing parameter - 'sRendProv'"
							modifyEncounter = False
							services.EndTransaction "modifyEncounter"
							Exit Function
						End If
				End Select
			End If			
		
		'verify parameters - Rendering Provider List Box and Select the appropriate value as passed by User
			If of.objectAction("WebList","Select~"& sRenderingProvider, "html id~html tag", ".*Form:.*[R|r]enderingProvMenu~SELECT", "True~False") = True Then
				Reporter.ReportEvent micPass,"ListBox - Rendering Provider","Value '"& sRenderingProvider &"' is selected from Rendering Provider ListBox, as Expected"
				If Instr(1, sRenderingProvider, "Not Listed" ,1) > 0 OR Instr(1, sRenderingProvider, "RENDERING = RETRIEVAL" ,1) > 0 Then
					
				' Click on Edit Link to Open the Panel
					If of.linkClickerWIndex("Edit", 0) = True Then
						Reporter.ReportEvent micPass,"Edit PickList","'Clicked on Link 'Edit' to open Rendering Provider Pop-up, as Expected"
						
						' Loop thru each data available as passed by user if Not-Listed/Rendering = Retrieval field is selected
						For i= 1 to UBound(aRendProv) Step 1
							aRendProvData = Split(aRendProv(i), "^")
							sRenderingReport = ""
							Select Case aRendProvData(0)
								Case 1
									sRenderingProvID = ".*[R|r]enderingProvForm:.*[R|r]enderingProvDetVal1"				'	Enter Provider NPI
									sRenderingReport = "Provider NPI"
								Case 2
									sRenderingProvID = ".*[R|r]enderingProvForm:.*[R|r]enderingProvFNVal1"			'Provider First Name:
									sRenderingReport = "Provider First Name"
								Case 3
									sRenderingProvID = ".*[R|r]enderingProvForm:.*[R|r]enderingProvLNVal1"			'Provider Last Name:
									sRenderingReport = "Provider Last Name"
								Case 4
									sRenderingProvID = ".*[R|r]enderingProvForm:.*[R|r]enderingProvAdd1Val1"			'Provider Address 1
									sRenderingReport = "Provider Address 1"
								Case 5
									sRenderingProvID = ".*[R|r]enderingProvForm:.*[R|r]enderingProvAdd2Val1"			'Provider Address 2
									sRenderingReport = "Provider Address 2"
								Case 6
									sRenderingProvID = ".*[R|r]enderingProvForm:.*[R|r]enderingProvCityVal1"			'Provider City:
									sRenderingReport = "Provider City"
								Case 7
									'sRenderingProvID = ".*[R|r]enderingProvForm:.*[R|r]enderingProvStaVal1"			'Provider State:
									sRenderingProvID = ".*[R|r]enderingProvForm:.*[R|r]enderingProvStateValueList1"
									sRenderingReport = "Provider State"
									aRendProvData(1) = UCase(Left(aRendProvData(1), 2))
								Case 8
									sRenderingProvID = ".*[R|r]enderingProvForm:.*[R|r]enderingProvZipVal1"				'Provider Zip:
									sRenderingReport = "Provider Zip"
									aRendProvData(1) = Left(aRendProvData(1), 9)
								Case 9
									sRenderingProvID = ".*[R|r]enderingProvForm:.*[R|r]enderingProvPHVal1"				'Provider Phone No.:
									sRenderingReport = "Provider Phone No"
									aRendProvData(1) = Left(aRendProvData(1), 10)
								Case 10
									sRenderingProvID = ".*[R|r]enderingProvForm:.*[R|r]enderingProvFTVal1"				'Provider Tax ID:
									sRenderingReport = "Provider Tax ID"
								Case Else
									Reporter.ReportEvent micFail,"Rendering Provider Details","Rendering Provider details are not passed correctly, Please check the passing parameter - '"& aRendProvData(0) &"'"
							End Select

							' Verify Rendering Provider Data
							If sRenderingReport <> "" And UBound(aRendProvData)>0 Then
								' Select Rendering Provider State Details
								If CInt(aRendProvData(0)) = 7 Then
									If Instr(1, of.objectAction("WebList","GetRoProperty~all items", "html id~html tag", sRenderingProvID &"~SELECT", "True~False"), aRendProvData(1) , 1) > 0 Then
										If of.objectAction("WebList","Select~"& aRendProvData(1), "html id~html tag", sRenderingProvID &"~SELECT", "True~False") = True Then
											Reporter.ReportEvent micPass,"Rendering Provider --> "& sRenderingReport, "Successfully selected '"& aRendProvData(1) &"' in '"& sRenderingReport &"' List Box, as Expected"
										Else
											Reporter.ReportEvent micFail,"Rendering Provider --> "& sRenderingReport, "Unable to select '"& aRendProvData(1) &"' in '"& sRenderingReport &"' List Box, Which is NOT as Expected"
										End If
									Else
										Reporter.ReportEvent micFail,"Rendering Provider --> "& sRenderingReport, "Unable to select '"& aRendProvData(1) &"' in '"& sRenderingReport &"' List Box as value passed '"& aRendProvData(1) &"' is Not Present, Which is NOT as Expected"
									End If
								Else
									' Enter Rendering Provider Info
									If of.objectAction("WebEdit","Set~"& aRendProvData(1), "html id~html tag",sRenderingProvID &"~INPUT", "True~False") = True Then
										Reporter.ReportEvent micPass,"Rendering Provider --> "& sRenderingReport, "Successfully entered '"& aRendProvData(1) &"' in '"& sRenderingReport &"' Text Box, as Expected"
									Else
										Reporter.ReportEvent micFail,"Rendering Provider --> "& sRenderingReport, "Unable to enter '"& aRendProvData(1) &"' in '"& sRenderingReport &"' Text Box, Which is NOT as Expected"
									End If
								End If
							Else
								Reporter.ReportEvent micFail,"Rendering Provider Details","Rendering Provider details are not passed correctly, Please check the passing parameter - 'sRendProv'"
								modifyEncounter = False
								services.EndTransaction "modifyEncounter"
								Exit Function
							End If
						Next

						'Perform Click on Done after entered Data
						If of.objectAction("WebButton","Click", "html id~name~html tag", ".*[r|R]enderingProvForm:j_id\d*~Done~INPUT", "True~False~False") = True Then
							Reporter.ReportEvent micPass,"Rendering Provider --> Click Done","'Mouse Left Click on Done Button"
						Else
							Reporter.ReportEvent micFail,"Rendering Provider --> Click Done","'Unable to click on 'Done' button, Which is NOT as Expected"
						End If
					Else
						modifyEncounter = False
						Reporter.ReportEvent micWarning,"Edit PickList","'Unable to click on Link 'Edit' to open Rendering Provider Pop-up, as Expected"
					End If
				End If
			Else
				Reporter.ReportEvent micFail,"ListBox - Rendering Provider","Unable to find the Value '"& sRenderingProvider &"' in Rendering Provider ListBox, NOT as Expected"
				modifyEncounter = False
				services.EndTransaction "modifyEncounter"
				Exit Function
			End If

		' Enter page Number
			If of.objectAction("WebEdit","Set~"& sPageNumber, "html id~html tag", " .*Form:.*[R|r]enderingProvPageNoTxtValue~INPUT", "True~False") = True Then
				Reporter.ReportEvent micPass,"Chart Image Page Number","'Successfully entered '"& sPageNumber &"' in Chart Image Page Number Text Box, as Expected"
			Else
				Reporter.ReportEvent micFail,"Chart Image Page Number","'Unable to enter '"& sPageNumber &"' in Chart Image Page Number Text Box, Which is NOT as Expected"
			End If

		'Fill the Service Type, Service Dates & Update Reason;
			aServiceTypeDate = Split(sServiceTypeDate, "~")

			'Select Service Type
			If Instr(1,"OP~IP~HOP~SNF", UCase(aServiceTypeDate(0)) ,1) > 0 Then
				If of.objectAction("WebElement","Click", "html id~innertext~html tag", "~"& UCase(aServiceTypeDate(0)) &"~LABEL", "False~False~False") = True Then
					Reporter.ReportEvent micPass,"Service Type","'Successfully selected Service Type : '"& UCase(aServiceTypeDate(0)) &"', as Expected"
				Else
					Reporter.ReportEvent micFail,"Service Type","'Unable to select Service type : '"& UCase(aServiceTypeDate(0)) &"', Which is NOT as Expected"
				End If
			Else
				Reporter.ReportEvent micFail,"Service Type", aServiceTypeDate(0) &"' is invalid service type and it has to be 'OP, IP, HOP', 'SNF', Which is NOT as Expected"
				modifyEncounter = False
				services.EndTransaction "modifyEncounter"
				Exit Function
			End If

			'Select 'Service From' date
			If of.objectAction("WebEdit","Set~"& aServiceTypeDate(1), "html id~html tag", ".*Form:.*[a|A]ddEncounterFromDateValue~INPUT", "True~False") = True Then
				Reporter.ReportEvent micPass,"Service From Date","'Successfully entered '"& aServiceTypeDate(1) &"' in Service From date Text Box, as Expected"
			Else
				Reporter.ReportEvent micFail,"Service From Date","'Unable to enter '"& aServiceTypeDate(1) &"' in Service From date Text Box, Which is NOT as Expected"
				modifyEncounter = False
				services.EndTransaction "modifyEncounter"
				Exit Function
			End If

			'Select 'Service Thru' date
			If of.objectAction("WebEdit","Set~"& aServiceTypeDate(2), "html id~html tag", ".*Form:.*[a|A]ddEncounterThruDateValue~INPUT", "True~False") = True Then
				Reporter.ReportEvent micPass,"Service Thru Date","'Successfully entered '"& aServiceTypeDate(2) &"' in Service Thru date Text Box, as Expected"
			Else
				Reporter.ReportEvent micFail,"Service Thru Date","'Unable to enter '"& aServiceTypeDate(2) &"' in Service Thru date Text Box, Which is NOT as Expected"
				modifyEncounter = False
				services.EndTransaction "modifyEncounter"
				Exit Function
			End If

			'Select Update Reason code for CV,QA, CVQA Tabs
				If Instr(1,"CV~QA~CVQA", sCurrentTab, 1) = 0 Then
					' Do Nothing
				ElseIf Not(aServiceTypeDate(3) = "" Or isempty(aServiceTypeDate(3))) Then
					If Instr(1,"M001;S001;S005;M012;S012;M100;", aServiceTypeDate(3)& ";", 1) > 0 Then
						If of.objectAction("WebList","Select~"& Ucase(aServiceTypeDate(3)), "html id~html tag", ".*AddEncForm:.*[U|u]pdateReasonCd(Add1|Modify11)~SELECT", "True~False") = True Then
							Reporter.ReportEvent micPass,"DOS Update Reason Code","'Successfully selected update Reason code '"& UCase(aServiceTypeDate(3)) &"' , as Expected"
						Else
							Reporter.ReportEvent micFail,"DOS Update Reason Code","'Unable to select update Reason code '"& UCase(aServiceTypeDate(3)) &"', Which is NOT as Expected"
						End If
					Else
						Reporter.ReportEvent micFail,"DOS Update Reason Code","'DOS update Reason code '"& UCase(aServiceTypeDate(3)) &"' is NOT Valid and has to be 'M001' Or 'S001' Or 'S005' Or 'M012' Or 'S012' Or 'M100', Which is NOT as Expected"
						modifyEncounter = False
						services.EndTransaction "modifyEncounter"
						Exit Function
					End If
				End If

			' Select DOS Level E&O Codes
			aDosEo = Split(sDosEo, "~")
			For i=0 to UBound(aDosEo) Step 1
				aEOCode = Split(aDosEo(i), ":")

				'Verify the Data passed as Input
				If UBound(aEOCode) >= 0 Then
					' Enter E&O Code
					If aEOCode(0) = "" or isEmpty(aEOCode(0)) Then
						'Do Nothing
					Else
						If of.objectAction("WebEdit","Set~"& UCase(aEOCode(0)), "html id~html tag", ".*Form:.*[a|A]ddEncounterEO"& (i+1) &"~INPUT", "True~False") = True Then
							Reporter.ReportEvent micPass,"ServiceDescription - E&O - "& (i+1),"'Successfully entered '"& aEOCode(0) &"' in Service description E&O - "& (i+1)&" Text Box, as Expected"
						Else
							Reporter.ReportEvent micFail,"ServiceDescription - E&O - "& (i+1),"'Unable to enter '"& aEOCode(0) &"' in Service description E&O - "& (i+1)&" Text Box, Which is NOT as Expected"
							modifyEncounter = False
							services.EndTransaction "modifyEncounter"
							Exit Function
						End If
					End If
				End If

				If UBound(aEOCode) > 0 Then
				'Enter Service Description Update Reason
					If aEOCode(1) = "" or isEmpty(aEOCode(1)) Then
						'Do Nothing
					ElseIf Instr(1,"CV~QA~CVQA", sCurrentTab, 1) > 0 Then
						If Instr(1,"M012;S012;A012;", aEOCode(1) &";", 1) > 0 Then
							If of.objectAction("WebList","Select~"& Ucase(aEOCode(1)), "html id~html tag", ".*AddEncForm:.*UpdateReasonCd(Add|Modify)"& (i+2)&"~SELECT", "True~False") = True Then
								Reporter.ReportEvent micPass,"ServiceDescription - E&O Update Reason - "& (i+1),"'Successfully entered '"& aEOCode(1) &"' in Service description E&O Update Reason- "& (i+1)&" Text Box, as Expected"
							Else
								Reporter.ReportEvent micFail,"ServiceDescription -  E&O Update Reason - "& (i+1),"'Unable to enter '"& aEOCode(1) &"' in Service description E&O Update Reason - "& (i+1)&" Text Box, Which is NOT as Expected"
							End If
						Else
							Reporter.ReportEvent micFail,"DOS E&O Update Reason Code","'DOS update Reason code '"& UCase(aEOCode(1)) &"' at position "& (i+1) &" is NOT Valid and has to be any 'M012' Or 'S012' Or 'A012', Which is NOT as Expected"
							modifyEncounter = False
							services.EndTransaction "modifyEncounter"
							Exit Function
						End If
					End If
				End If
			Next

			aEncounterEo = Split(sIcdEo, "~")
			If UBound(aEncounterEo) < 10 Then
				For i=0 to UBound(aEncounterEo) Step 1
					aICDCode = Split(aEncounterEo(i), ":")

					' Loop across each value to submit E&O Code and Update Reason
					iCnt = 0
					For j=0 to UBound(aICDCode) Step 1

						' Verify the Encounter provided is Primary
						If Ucase(aICDCode(j)) = "P" Then
							iCnt = iCnt +1
							If of.objectAction("WebCheckBox","Click", "html id~html tag", ".*Form:.*[a|A]ddEncounterDiagnosisTable:"& i &":.*[p|P]rimaryIcd9Value~INPUT", "True~False") = True Then
								Reporter.ReportEvent micPass,"Encounter - CheckBox - "& (i+1),"'Successfully checked primary check box at Row  '"& (i+1) &"' in Encounter Section, as Expected"
							Else
								Reporter.ReportEvent micFail,"Encounter - CheckBox - "& (i+1),"'Unable to check primary check box at Row  '"& (i+1) &"' in Encounter Section, Which is NOT as Expected"
							End If
						Else
							aICDEoReason = Split(aICDCode(j), "-")
							If j = iCnt Then
								' Enter ICD value in the Field
								If UBound(aICDEoReason) >= 0 Then
									If of.objectAction("WebEdit","Set~"& UCase(aICDEoReason(0)), "html id~html tag", ".*Form:.*[a|A]ddEncounterDiagnosisTable:"& i &":.*[i|I]cd9Value~INPUT", "True~False") = True Then
										Reporter.ReportEvent micPass,"Encounter ICD - "& (i+1),"'Successfully entered '"& aICDEoReason(0) &"' in ICD Text Box at Row - "& (j-iCnt+1)&" Text Box, as Expected"
									Else
										Reporter.ReportEvent micFail,"Encounter ICD - "& (i+1),"'Unable to enter '"& aICDEoReason(0) &"' in ICD Text Box at Row - "& (j-iCnt+1)&" Text Box, Which is NOT as Expected"
									End If
								End If

							'Select the ICD Field Update Reason
								If UBound(aICDEoReason) > 0 Then
									If aICDEoReason(1) = "" or isEmpty(aICDEoReason(1)) Then
										'Do Nothing
									ElseIf Instr(1,"CV~QA~CVQA", sCurrentTab, 1) > 0 Then
										If Instr(1,"S004;S008;M011;", aICDEoReason(1)& ";", 1) > 0 Then
											If of.objectAction("WebList","Select~"& Ucase(aICDEoReason(1)), "html id~html tag", ".*Form:.*[a|A]ddEncounterDiagnosisTable:"& i &":.*[a|A]ddEncounterDiagnosisTable1:0:.*DiagUpdateCd(Add1|Modify11)~SELECT", "True~False") = True Then
												Reporter.ReportEvent micPass,"Encounter ICD Update Reason - "& (i+1),"'Successfully selected '"& aICDEoReason(1) &"' in ICD Update Reason - "& (j-iCnt+1)&" List Box, as Expected"
											Else
												Reporter.ReportEvent micFail,"Encounter ICD Update Reason - "& (i+1),"'Unable to select '"& aICDEoReason(1) &"' in ICD Update Reason - "& (j-iCnt+1)&" List Box, Which is NOTas Expected"
											End If
										Else
											Reporter.ReportEvent micFail,"DX Update Reason Code","'DX update Reason code '"& UCase(aICDEoReason(1)) &"' at position "& (j-iCnt+1) &" is NOT Valid and has to be any 'S004' Or 'S008' Or 'M011', Which is NOT as Expected"
											modifyEncounter = False
											services.EndTransaction "modifyEncounter"
											Exit Function
										End If
									End If
								End If
							Else
								' Enter ICD E&Ovalue in the Field
								If UBound(aICDEoReason) >= 0 Then
									If of.objectAction("WebEdit","Set~"& UCase(aICDEoReason(0)), "html id~html tag", ".*Form:.*[a|A]ddEncounterDiagnosisTable:"& i &":.*[e|E]oCode"& (j-iCnt)&"Value~INPUT", "True~False") = True Then
										Reporter.ReportEvent micPass,"Encounter ICD E&O Row - "& (i+1),"'Successfully entered '"& aICDEoReason(0) &"' in ICD E&OText Box at Row - "& (i+1)&" and position "& (j-iCnt)&", as Expected"
									Else
										Reporter.ReportEvent micFail,"Encounter ICD E&O Row - "& (i+1),"'Unable to enter '"& aICDEoReason(0) &"' in ICD E&OText Box at Row - "& (i+1)&" and position "& (j-iCnt)&", Which is NOT as Expected"
										modifyEncounter = False
										services.EndTransaction "modifyEncounter"
										Exit Function
									End If
								End If

								'Select the ICD E&O Field Update Reason
								If UBound(aICDEoReason) >0 Then
									If aICDEoReason(1) = "" or isEmpty(aICDEoReason(1)) Then
										'Do Nothing
									ElseIf Instr(1,"CV~QA~CVQA", sCurrentTab, 1) > 0 Then
										If Instr(1,"A013;M013;S013;", aICDEoReason(1)& ";", 1) > 0 Then
											If of.objectAction("WebList","Select~"& Ucase(aICDEoReason(1)), "html id~html tag", ".*Form:.*[a|A]ddEncounterDiagnosisTable:"& i &":.*[a|A]ddEncounterDiagnosisTable2:0:.*DiagUpdateCd(Add|Modify)"& (j-iCnt+1)&"~SELECT", "True~False") = True Then
												Reporter.ReportEvent micPass,"Encounter ICD E&O Update Reason - "& (i+1),"'Successfully selected '"& aICDEoReason(1) &"' in ICD E&O Update Reason List Box at Row - "& (i+1)&" and position "& (j-iCnt)&", as Expected"
											Else
												Reporter.ReportEvent micFail,"Encounter ICD E&O Update Reason - "& (i+1),"'Unable to select '"& aICDEoReason(1) &"' in ICD E&O Update Reason List Box at Row - "& (i+1)&" and position "& (j-iCnt)&", Which is NOT as Expected"
											End If
										Else
											Reporter.ReportEvent micFail,"DX E&O Update Reason Code","'DX E&O update Reason code '"& UCase(aICDEoReason(1)) &"' at position "& (j-iCnt+1) &" is NOT Valid and has to be any 'A013' Or 'M013' Or 'S013', Which is NOT as Expected"
											modifyEncounter = False
											services.EndTransaction "modifyEncounter"
											Exit Function
										End If
									End If
								End If
							End If
						End If
					Next		
				Next
			Else
				Reporter.ReportEvent micFail,"Modify Encounter --> Icd Diagnosis Codes","'Modify Encounter' Function can able to add only up to 10 Diagnosis code, adjust the input and recall the function"
				modifyEncounter = False
			End If
		
		'In Coding Tab Click on Link View/Add Comments
			If Instr(1,"Coding", sCurrentTab, 1) > 0 Then
				If of.linkClicker("View/Add Comments") = True Then
					Reporter.ReportEvent micPass,"View/Add Comments","'Clicked on Link 'View/Add Comments' to expand selection Comments Text Box, as Expected"
				Else
					Reporter.ReportEvent micWarning,"View/Add Comments","'Unable to click on Link 'View/Add Comments' to expand selection Comments Text Box, as Expected"
				End If
			End If

		' Enter Comments <If Any>
			If of.objectAction("WebEdit","Set~"& sComments, "html id~html tag", ".*Form:.*[d|D]iagnosisNewCommentValue~TEXTAREA", "True~False") = True Then
				Reporter.ReportEvent micPass,"Add New Comments:","'Successfully entered '"& sComments &"' in Comments Text Box, as Expected"
			Else
				Reporter.ReportEvent micFail,"Add New Comments:","'Unable to enter '"& sComments &"' in Comments Text Box, Which is NOT as Expected"
			End If

		'Click on Save Button to save Encounter
			If of.objectAction("WebButton","Click", "html id~html tag~Index", ".*Form:.*[s|S]aveEncounterButton.*~INPUT~0", "True~False~False") = True Then
				Reporter.ReportEvent micPass,"Encounter - Save","'Clicked on Button 'Save' to Save Encounter, as Expected"
			Else
				Reporter.ReportEvent micFail,"Encounter - Save","'Unable to Click on Button 'Save' to Save Encounter, Which is NOT as Expected"
			End If

			Call ajaxSync.ajaxSyncRequest("Processing Request",60)
			
		'If Duplicate Encounter Exist, Click on 'Confirm' Button
			'If of.objectFinder("WebButton","html id~name~html tag", ".*Form.*:.*[c|C]onfirmDup.*ModalPanelConfirmButton.*~Confirm~INPUT", "True~False~False") = True Then
			'	call util.popupDialogButtonClick("Encounter submitted is a duplicate date of service","Confirm")
			'End If
			If Browser(Environment("BROWSER_OBJ")).WebTable("innertext:=Encounter submitted is a duplicate date of service.*").waitproperty("abs_x",micGreaterThan(0),5000) Then
				call util.popupDialogButtonClick("Encounter submitted is a duplicate date of service","Confirm")
			End If		
			
			Call ajaxSync.ajaxSyncRequest("Processing Request",60)
			
		'Verify If the Encounter added successfully by Verifying Add Button
			If of.objectFinder("WebButton","html id~name~html tag", ".*Form:.*[a|A]ddEncounterBtn~.*Add.*~INPUT", "True~True~False") = True Then
				Reporter.ReportEvent micPass,"Modify Encounter","'Encounter added succesfully, as Expected"
			Else
				Reporter.ReportEvent micWarning,"Modify Encounter","'Unable to Modify Encounter with the input parameters passed"
				modifyEncounter = False
			End If
			Set oAppBrowser = Nothing
		Else
			modifyEncounter = False
		End If
		services.EndTransaction "modifyEncounter"
	End Function
	
	Function lockImageBarcodeSearch(parentTableObject,sLockColor,sBarcode)
		'********************************************************************************************************************************************************
		'Purpose: ChartSync - Search in the Chart id WebTable for the barcode along with red or green lock image specified
		'Precondition: a. Searching for the barcode (to verify the lock image) must be performed first before calling this function as it will NOT 
		'                           perform the page table navigation!
		'                           b.The parent (WebTable) object must exist and is not empty (must contains row of barcode)
		' Parameters: parentTableObject = the WebTable object (Must be an object)
		'                         sColorLock = Valid values; red or green           
		'                         sBarcode = the barcode/Chart request ID string 
		'Returns: True when barcode with lock image found
		'         False when barcode without lock image found 
		'               or barcode NOT FOUND
		'         
		'Usage:    perform search for barcode to verify the green/red lock image	
		'                  Set oChartTable=Browser("title:=.*").WebTable("html id:=chartForm:chartTable")
		'                   If util.lockImageBarcodeSearch(oChartTable, "green", "5d8e5e13-93cf-49ad-81f2-8876ffbe957d")
		'                        msgbox "barcode w/green lock found"
		'                   end if              
		'          OR
		'                   If util.lockImageBarcodeSearch(oChartTable, "red", "5d8e5e13-93cf-49ad-81f2-8876ffbe957d")
		'                        msgbox "barcode w/red lock found"
		'                   end if  
		'Created by: Hung Nguyen 9/20/12
		'Modified: Hung Nguyen 11/14/12 - Updated to include search for lock image from the Encounters tab/page and use Image obj property 'file name' instead of 'html id'
		'          Hung Nguyen 1/3/13 - Updated to add For loops for webelement and image objects counts
		'          Hung Nguyen 1/4/13 - Due to barcode and lock image are not always on the same cell, updated to search barcode first then lock image start at first cell
		'          Hung Nguyen 4/9/13 - Updated to the comment on return value 
		'********************************************************************************************************************************************************
		Services.StartTransaction "lockImageBarcodeSearch"
		Dim sfilename,oTable,r,iBarcodeFound,iLockFound,c,iWebElementCnt,j,sCurBarcode,imageCnt,i,sImageName,iRowFound
		lockImageBarcodeSearch=False		'init return value
	
		'verify parameters
		If sLockColor="" Then
			reporter.ReportEvent micFail,"Invalid parameter", "Variable 'sLockColor' must contain value"
			Exit Function
		ElseIf LCase(sLockColor)<>"red" And lcase(sLockColor<>"green") Then
			reporter.ReportEvent micFail,"Invalid parameter", "Valid values for variable 'sLockColor' must be 'green' or 'red'. Current invalid parameter value '" &sLockColor &"'"
			Exit Function
		End If 
		If sBarcode="" Or InStr(1,sBarcode,"ERROR",1) > 0 Then		
			reporter.ReportEvent micFail,"Invalid parameter", "Variable 'sBarcode' contains error. Current invalid parameter value '" &sBarcode &"'"
			Exit Function
		End If
	
		'set the Image obj property 'file name' per color
		If lcase(sLockColor)="green" Then
			sfilename="lock_green.gif"
		Else	'red
			sfilename="lock_red.gif"
		End If
	
		Browser(Environment("BROWSER_OBJ")).Sync
		If isobject(parentTableObject) And parentTableObject.Exist(5) Then
			If parentTableObject.GetROProperty("micclass")="WebTable" Then
				Set oTable=parentTableObject

				'Due to barcode and lock image are not on the same cell in table, search barcode first then the lock image 
				'1.search barcode
				iRowFound=""
				For r=2 to oTable.RowCount
					reporter.ReportEvent micInfo,">>>loop webelement row =" &r,""
					iBarcodeFound=0
				
					For c=1 to oTable.ColumnCount(r)
						iWebElementCnt=oTable.ChildItemCount(r,c,"WebElement")	'get obj count
						If iWebElementCnt > 0 Then
							For j=0 to iWebElementCnt - 1
								sCurBarcode=trim(oTable.ChildItem(r,c,"WebElement",j).GetROProperty("innertext"))
								If strcomp(sBarcode,sCurBarcode,1)=0 Then
									iRowFound=r
									iBarcodeFound=1
									reporter.ReportEvent micInfo, "barcode '" &sCurBarcode &"' found on row " &iRowFound ,""
									Exit For
								End If
							Next	'obj index
						End If 
						If iBarcodeFound=1 Then Exit For	'exit col loop
					Next	'column
					If iBarcodeFound=1 Then Exit For	'exit row loop
				Next	'row

				'2. search lock image
				If iBarcodeFound=1 Then
					reporter.ReportEvent micInfo,">>>loop image row =" &r,""
					iLockFound=0

					'loop columns
					For c=1 to oTable.ColumnCount(iRowFound)
						imageCnt=oTable.ChildItemCount(iRowFound,c,"Image")
						If imageCnt > 0 Then
							For i=0 to imageCnt - 1
								sImageName=trim(oTable.ChildItem(iRowFound,c,"Image",i).GetROProperty("file name"))
								If instr(1,sImageName,sLockColor,1) > 0 Then
									iLockFound=1
									lockImageBarcodeSearch=True		'return value
									reporter.ReportEvent micInfo, "barcode '" &sCurBarcode &"' found and contains lock image '" &sImageName &"' on row " &iRowFound,""
									Exit For	'exit obj index
								End If
							Next	'image obj index
						End If 
						If iLockFound=1 Then Exit For	'exit col loop
					Next	'column

					If iLockFound=0 Then
						reporter.ReportEvent micInfo, "barcode '" &sCurBarcode &"' found but contains no lock image",""
					End If
				Else
					reporter.ReportEvent micInfo, "barcode '" &sBarcode &"' NOT found",""
				End If

				Set oTable=Nothing
			Else
				reporter.ReportEvent micFail,"Parent object","The parent object class name must be 'WebTable'"
			End If			
		Else
			reporter.ReportEvent micFail,"Parent object","Either the parent object variable 'parentTableObject' is not an object or object does not exist."
		End If
		Services.EndTransaction "lockImageBarcodeSearch"
	End Function
	
	Function popupWindowReasonEscalation(sTableID,sReason,sNote,sButtonClick)
	   '*************************************************************************************************************************
	   'Purpose: ChartSync: Code Review - Select a reason for escalation, then enter a note and click Submit 
	   '                   Or simply click Cancel from the popup window "Reason for Escalation"
	   '
	   'NOTE: this function does not verify any error messages (if exist).
	   '              The Escalate button must be clicked and the Reason for Escalation popup window must exist prior to calling this function
	   'Calls: 
		'Parameters: sTable = the popup window WebTable obj property "html id " value
		'                         sReason = the WebElement obj property "innertext" value (next to the RadioGroup obj) to select
		'                         sNote: text value to enter in the "Notes:" edit field
		'                        sButtonClick = the WebButton obj property "name" value to click (Submit or Cancel)
		'Returns: True/False
		'Usage: util.popupWindowReasonEscalation("codeReviewEscalatePanelContentTable","Incorrect member","Automation only","Submit")
		'Created by: Hung Nguyen 10-10-12
		'Modified:
		'*************************************************************************************************************************
		services.StartTransaction "popupWindowReasonEscalation"
		Dim iFound,aMenus,sMenu,oTable
		popupWindowReasonEscalation=False	'init return value
	
		''verify parameters
		iFound=0
		aMenus=array("Incorrect member","Multiple members","Other/unassigned","Coding/documentation question","Training")
		For each sMenu in aMenus
			If strcomp(sReason,sMenu,1)=0 Then
				iFound=1
				Exit For
			End If
		Next 
		If iFound=0 Then
			reporter.ReportEvent micFail,"invalid parameter","the parameter '" &sReason &"' is not a valid reason. Please try again."
			Exit Function
		End If
	
		If strcomp(sButtonClick,"Submit",1) <>0 and strcomp(sButtonClick,"Cancel",1) <>0   Then
			reporter.ReportEvent micFail,"invalid parameter","the parameter '" &sButtonClick &"' is not a valid button name or does not exist. Valid buttons are: Submit and Cancel"
			Exit Function
		End If
	
		Browser(Environment("BROWSER_OBJ")).Page("title:=.*").Sync
		Set oTable=Browser(Environment("BROWSER_OBJ")).WebTable("html id:=" &sTableID)
		If oTable.WaitProperty("abs_x",micGreaterThan(0),5000) Then
			'select a reason
			If oTable.WebElement("html tag:=LABEL","innertext:=" &trim(sMenu)).Exist(2) Then
				oTable.WebElement("html tag:=LABEL","innertext:=" &trim(sMenu)).highlight
				oTable.WebElement("html tag:=LABEL","innertext:=" &trim(sMenu)).Click
				reporter.ReportEvent micInfo,"Reason for Escalation","Reason '" &sReason &"' was selected."
	
				''enter note 
				If sNote<>"" Then
					If oTable.WebEdit("html tag:=TEXTAREA","html id:=codeReviewEscalateForm:codeReviewEscalateNotesValue").Exist(2) Then
						oTable.WebEdit("html tag:=TEXTAREA","html id:=codeReviewEscalateForm:codeReviewEscalateNotesValue").Set sNote
						reporter.ReportEvent micInfo,"Reason for Escalation","Note '" &sNote &"' was entered into field."
					Else
						reporter.ReportEvent micFail,"Reason for Escalation","The Note edit field does not exist. Unable to enter note"
						Exit Function
					End If 
				Else
					reporter.ReportEvent micWarning,"Reason for Escalation","Note value '" &sNote &"' is empty. No note to enter into field."
				End If
	
				'click a button
				If strcomp(trim(sButtonClick),"Submit",1) =0 Then	'click Submit
					If oTable.WebButton("html tag:=INPUT","type:=submit","name:=Submit").Exist(2) Then
						oTable.WebButton("html tag:=INPUT","type:=submit","name:=Submit").Click
						popupWindowReasonEscalation=True	'return value
						reporter.ReportEvent micInfo,"The Submit button was clicked",""
	                    Call ajaxSync.ajaxSyncRequest("Processing Request",15)	'wait for processing request w/timeout in secs
					Else
						reporter.ReportEvent micFail,"The Submit button does not exist.","Unable to click the button."
					End If
				Else	'Cancel 
					If oTable.WebButton("html tag:=INPUT","type:=button","name:=Cancel").Exist(2) Then
						oTable.WebButton("html tag:=INPUT","type:=button","name:=Cancel").Click
						popupWindowReasonEscalation=True	'return value
						reporter.ReportEvent micInfo,"The Cancel button was clicked",""
					Else
						reporter.ReportEvent micFail,"The Cancel button does not exist.","Unable to click the button."
					End If
				End If 
			Else
				reporter.ReportEvent micFail,"Select Reason","The WebElement obj w/innertext value '" &sReason &"' does not exist. Unable to select."
			End If 	
		Else
			reporter.ReportEvent micFail,"popupWindowReasonEscalation","The popup window does not exist or the table ID is invalid."
		End If
		Set oTable=Nothing
		services.EndTransaction "popupWindowReasonEscalation"
	End Function
	
	Function searchChartID(sChartID)
		'***************************************************************************************
		'Purpose: ChartSync - Search a chart ID specified with project status = All Active in the Data Summary
		'                   and return the chart id found.
		'Search Steps: 1. if code review tab is active, click Cancel then Confirm
		'              2. click Data Summary tab
		'              3. select project status = All Active, expand the Detailed Search section if not already
		'              4. enter the chart ID into field and click Search
		'                 a. If error message "No records match the criteria entered." exists - invalid chart ID or does not exist
		'                 b. Else, click the subtab 'Charts', get the chartID on row2 to compare
		'                         -if match -> return the chartID value
		'                         -else -> return EMPTY
		'              5. DONE
		'Parameters: sChartID = the chart ID to search
		'Calls: utilFunctions.vbs,objFunctions.vbs,ajaxSync.vbs
		'Returns: Chart ID found or Empty if failed
		'Usage: sReturnValue = util.searchChartID("95d7cc72-4d97-4aeb-96d1-26a1e48b0693")
		'      If not isempty(sReturnValue) Then 
		'         msgbox "chart id found"
		'      else
		'         msgbox "chart id does not exist or is invalid"
		'      end if
		'Created by: Hung Nguyen 10-10-12
		'Modified: Hung Nguyen 4/08/13 - Commented out the IF statement clicking the Cancel and confirm buttons only if 
		'                      the Code Review tab is active And only if the Cancel button exists so function can be used for CV tab.
		'***************************************************************************************             
		services.starttransaction "searchChartID"	
		searchChartID = Empty 	'init return value
		Dim oAppBrowser,iObjCount,oChartTable,sCurChartID
		Set oAppBrowser=Browser(Environment("BROWSER_OBJ"))
		
		''verify parameter
		if sChartID="" then 
			reporter.reportevent micFail,"invalid parameter","Chart ID can't be empty."
			Exit Function
		End If 
		
		'if Code Review tab is active - click Cancel then Confirm
		'If strcomp(util.tabHeaderStatus("Code Review"),"active",1) = 0 Then
			If oAppBrowser.WebButton("html tag:=INPUT","type:=submit","name:=Cancel").Exist(5) Then
				oAppBrowser.WebButton("html tag:=INPUT","type:=submit","name:=Cancel").Click
			
				'then click Confirm
				If util.popupDialogButtonClick("All unsaved work will be lost. Are you sure you want to continue?","Confirm") Then
					reporter.ReportEvent micInfo,"Click Cancel then Confirm","The Cancel and Confirm buttons were clicked successful."
					oAppBrowser.Sync
				Else
					reporter.ReportEvent micFail,"Click The Popup Dialog window Confirm button","Function call to click the Confirm button for cancellation failed. "
					Exit Function
				End If
			'Else
			'	reporter.ReportEvent micFail,"Click The Cancel button","The button does not exist."
			'	Exit Function 
			End If		
		'End If
	
		'Click Data Summary tab and perform search 
		If util.maintabHeaderNavigate("Data Summary") Then
			
			'8b. Select Project Status 'All Active' from drop-down
			If of.webListSelect("commonSearchForm:projectStatusSearchValueList","All Active") Then
				reporter.ReportEvent micPass,"Select project status option 'All Active'","was successful." 
			
				'8c. Expand the Detail Search frame - click Show if exists
				If oAppBrowser.WebElement("html id:=commonSearchForm:detailedSearchTogPanelOpenLabel").Exist(2) Then
					reporter.ReportEvent micInfo,"Expand the 'Detail Search' frame","was successful."
					oAppBrowser.WebElement("html id:=commonSearchForm:detailedSearchTogPanelOpenLabel").Click
				End If
			
				'enter chart ID
				If oAppBrowser.WebEdit("html id:=commonSearchForm:chartIDSearchValue").Exist(2) Then
					oAppBrowser.WebEdit("html id:=commonSearchForm:chartIDSearchValue").Set sChartID
			
					iObjCount=ajaxSync.pageObjsCount(Environment("BROWSER_TITLE"))	'cnt objs before an action
					If of.webButtonClicker("Search") Then	'click Search
	                    Call ajaxSync.ajaxBrowserSync(Environment("BROWSER_TITLE"), iObjCount,10)	'cnt objs changes with time out
	
						''verify
						If oAppBrowser.WebElement("html tag:=SPAN","innertext:=No records match the criteria entered.").Exist(2) Then
							reporter.ReportEvent micWarning,"searchChartID","Chart ID '" &sChartID &"' NOT FOUND."
						Else
							''clich the subtabl 'Charts'
							iObjCount=ajaxSync.pageObjsCount(Environment("BROWSER_TITLE"))	'cnt objs before an action
							Call util.maintabSubHeaderNavigate("Charts")
							Call ajaxSync.ajaxBrowserSync(Environment("BROWSER_TITLE"), iObjCount,10)	'cnt objs changes with time out
	
							'mouseover the chart id and select 'Chart Detail' from the popup window
							Set oChartTable=oAppBrowser.WebTable("html id:=chartForm:chartTable")
							If oChartTable.Exist(10) Then		'data starts from row2 
								If oChartTable.RowCount >=2 Then
									sCurChartID=trim(oChartTable.GetCellData(2,1))
									If instr(1,sCurChartID,sChartID,1) > 0 Then
										reporter.ReportEvent micPass,"Chart ID '" &sChartID &"' found.",""
										searchChartID = sChartID 	'return value
									Else
										reporter.ReportEvent micFail,"Chart ID '" &sChartID &"' Not found. Found chart id '" &sCurChartID,"Not expected."
									End If
								Else
									reporter.ReportEvent micFail,"Chart table contains no data row","Unable to compare Chart ID"
								End If
							Else
								reporter.ReportEvent micFail,"Chart Table","The table does not exist."
							End If
						End If
					Else
						reporter.ReportEvent micFail,"Click Search","Function call to click the 'Search' button after selected project status 'All Active' fails."
					End If 
				Else
					reporter.ReportEvent micFail,"Enter Chart ID","The chart request ID field does not exist."
				End If
			Else
				reporter.ReportEvent micFail,"Select Project Status option","Function call to select the option failed."
			End If 	
		Else 
			Reporter.ReportEvent micFail,"Navigate to Data Summary","Function call was NOT successful."
		End If
		Set oChartTable=Nothing
		Set oAppBrowser=Nothing	
		services.endtransaction "searchChartID"
	End Function
	
	Function popupWindowReasonReject(sTableID,sReason,sNote,sButtonClick)
	   '*************************************************************************************************************************
	   'Purpose: ChartSync: Code Review - Reject popup window
	   '                   Select/check one or more reason checkboxes  for rejecting a chart , then enter a note and click Submit 
	   '                   Or simply click Cancel from the popup window "Reject"
	   '
	   'NOTE: This function does not verify any error messages if exist
	   '              The Reject button must be clicked and the Reject popup window must be activated prior to calling this function
	   'Calls: AjaxSync.vbs
		'Parameters: sTableID = the popup window WebTable obj property "html id " value
		'                         sReason = Reason(s) use semicolon delimiter (if more than one reason to select)
		'                         sNote: text value to enter in the "Notes:" edit field
		'                        sButtonClick = the WebButton obj property "name" value to click (must be Submit or Cancel)
		'Returns: True/False
		'Usage: Call util.popupWindowReasonReject("codeReviewRejectPanelContentTable","Document is illegible;Missing Date Of Service","Automation only","Submit")
		'                Call util.popupWindowReasonReject("codeReviewRejectPanelContentTable","Missing Date Of Service","Automation only","Submit")
		'Created by: Hung Nguyen 10-12-12
		'Modified:
		'*************************************************************************************************************************
		services.StartTransaction "popupWindowReasonReject"
		Dim iFound,aMenus,sMenu,oParentTable,oReasonTable,aReasons,i,r,sCheckboxDesc
		popupWindowReasonReject=False	'init return value
	
		''verify parameters
		If strcomp(sButtonClick,"Submit",1) <>0 and strcomp(sButtonClick,"Cancel",1) <>0   Then
			reporter.ReportEvent micFail,"invalid parameter","the parameter '" &sButtonClick &"' is not a valid button name or does not exist. Valid buttons are: Submit and Cancel"
			Exit Function
		End If

		Browser(Environment("BROWSER_OBJ")).Page("title:=.*").Sync

		'the popup window Reject table
		Set oParentTable=Browser(Environment("BROWSER_OBJ")).WebTable("html id:=" &sTableID)		
		If Not oParentTable.WaitProperty("abs_x",micGreaterThan(0),5000) Then
			reporter.ReportEvent micFail,"popupWindowReasonEscalation","The popup window does not exist or the table ID is invalid."
			Exit Function
		End If

		''the Reason for Rejecting table
		Set oReasonTable=oParentTable.WebTable("html id:=codeReviewRejectForm:codeReviewRejectTable")
		If Not oReasonTable.WaitProperty("abs_x",micGreaterThan(0),5000) Then
			reporter.ReportEvent micFail,"The Reason for Rejecting table in the popupWindow does not exist",""
			Exit Function
		End If

		''check the reason for rejecting checkbox(es)
		aReasons=split(sReason,";")
		For i=0 to ubound(aReasons)
			iFound=0
			For r=2 to oReasonTable.RowCount
				sCheckboxDesc=trim(oReasonTable.GetCellData(r,2))	'get reason description on table
		
				If strcomp(sCheckboxDesc,trim(aReasons(i)),1) = 0 Then
					If oReasonTable.ChildItemCount(r,1,"WebCheckBox") > 0 Then
						oReasonTable.ChildItem(r,1,"WebCheckBox",0).Set "ON"
						Reporter.ReportEvent micInfo, "Reason for rejecting '" &aReasons(i) &"' found and is checked/selected.",""
						iFound=1
						Exit For
					Else
						reporter.ReportEvent micFail, "Reason for rejecting '" &aReasons(i) &"' found but has no checkbox to check/select.","Not expected."
						Exit Function
					End If
				End If
			Next	'next row 
			If iFound=0 Then
				reporter.ReportEvent micWarning, "Reason for rejecting '" &aReasons(i) &"' does not exist in the reject table. Is it a valid reason?",""
				Exit Function
			End If
		Next	'next expect reason 

		''enter note 
		If sNote<>"" Then
			If oParentTable.WebEdit("html tag:=TEXTAREA","html id:=codeReviewRejectForm:codeReviewRejectNotesValue").Exist(2) Then
				oParentTable.WebEdit("html tag:=TEXTAREA","html id:=codeReviewRejectForm:codeReviewRejectNotesValue").Set sNote
				reporter.ReportEvent micInfo,"Reason for Escalation","Note '" &sNote &"' was entered into field."
			Else
				reporter.ReportEvent micFail,"Reason for Escalation","The Note edit field does not exist. Unable to enter note"
				Exit Function
			End If 
		Else
			reporter.ReportEvent micWarning,"Reason for Escalation","Note value '" &sNote &"' is empty. No note to enter into field."
		End If
	
		''click a button
		If strcomp(trim(sButtonClick),"Submit",1) =0 Then	'click Submit
			If oParentTable.WebButton("html tag:=INPUT","type:=submit","name:=Submit").Exist(2) Then

				oParentTable.WebButton("html tag:=INPUT","type:=submit","name:=Submit").Click

				popupWindowReasonReject=True	'return value
				reporter.ReportEvent micInfo,"The Submit button was clicked",""
				Call ajaxSync.ajaxSyncRequest("Processing Request",15)	'wait for processing request w/timeout in secs
			Else
				reporter.ReportEvent micFail,"The Submit button does not exist.","Unable to click the button."
			End If
		Else	'Cancel 
			If oParentTable.WebButton("html tag:=INPUT","type:=button","name:=Cancel").Exist(2) Then
				oParentTable.WebButton("html tag:=INPUT","type:=button","name:=Cancel").Click
				popupWindowReasonReject=True	'return value
				reporter.ReportEvent micInfo,"The Cancel button was clicked",""
			Else
				reporter.ReportEvent micFail,"The Cancel button does not exist.","Unable to click the button."
			End If
		End If 
		Set oReasonTable=Nothing	
		Set oParentTable=Nothing
		services.EndTransaction "popupWindowReasonReject"
	End Function
	Function popupMenuItemSearch(parentObject,sMenuItem)
	'**********************************************************************************************************************************************************	
	'Purpose: ChartSync - Search a menu item in the popup window
	'Notes:     This popup window must be activated/opened after mouseover the link 
	'                  Example: a. From the Data Summary page, select option 'All Active' in the Project Status drop-down
	'                                      b. Click Search, the Projects tab is active by default, the table is populated with Project IDs
	'                                      c. Mouseover a Project ID link for a few seconds - the popup window will appear with items: Project, Provider, and Chart
	'         
    ' Requires: The popup window must opened/exist/activated
	'                     The parentObject (WebTable) must exist
	' Parameters: parentObject = the WebTable obj which is the parent object of the popup window) 
	'                          sMenuItem = the menu item in the popup window to select
	'Calls: None
	'Returns: True/False
	'Usage: Set oTable=Browser("title:=.*").WebTable("html id:=projectForm:projectTable") 	'parent obj - Project ID table
	'            OR
	'                Set oTable=Browser("title:=.*").WebTable("html id:=chartEncPG11Form:encTable") 	'parent obj - Encounter table
	'          OR
	'                Set oTable=Browser("title:=.*").WebTable("html id:=chartForm:chartTable") 	'parent obj - Chart ID table
	'                util.popupMenuItemSearch(oTable,"Chart")         '<=select item'Chart' from the popup window
	'Created by: Hung Nguyen 11/5/10
	'Modified: Hn 10/19/12 - updated for searching
	'************************************************************************************************************************************
		Services.StartTransaction "popupMenuItemSearch"
		Dim oAppBrowser,oElement,oChildren,iFound,i,sChildName
		popupMenuItemSearch=False	'init return value

		If isObject(parentObject) Then	'it's an object		
			If parentObject.Exist Then	'the webtable obj (which the child popup window obj is under)
				Set oAppBrowser=Browser("title:=.*")	'any Browser obj
				
				'webelement objs in the popup window
				Set oElement=description.create
				oElement("micclass").value="WebElement"
				oElement("class").value="rich-menu-item-label"
				oElement("html tag").value="SPAN" 
				
				Set oChildren=oAppBrowser.Page("title:=.*").ChildObjects(oElement)
				iFound=0
				For i=0 to oChildren.Count - 1
					sChildName=trim(oChildren(i).GetROProperty("innertext"))
					If strcomp(sChildName,sMenuItem,1)=0  Then	'the menu item found and will be clicked
						iFound=1
						popupMenuItemSearch=True	'return value
						reporter.ReportEvent micInfo,"popupMenuItemSearch","Menu item '" &sMenuItem &"' found."
						Exit For
					End If
				Next
				If iFound=0 Then
					reporter.ReportEvent micInfo,"popupMenuItemSearch","Menu item '" &sMenuItem &"' not found."	'for negative search
				End If
				Set oElement=Nothing
				Set oChildren=Nothing
				Set oAppBrowser=Nothing
			Else
				Reporter.ReportEvent micFail,"popupMenuItemSearch","The parentObject specified does not exist."
			End If
		Else
			Reporter.ReportEvent micFail,"popupMenuItemSearch", "The parent object specified is not an object."
		End If
		Services.EndTransaction "popupMenuItemSearch"
	End Function	
	
	Function searchEncounter(sSearchValues)
	   '**********************************************************************************************************************************************************************
	   'Purpose: ChartSync - Search Encounters from the Encounters tab/page by entering search field value(s) then click Search
	   '                   It first check if the Encounters tab is active: a. If it's inactive then tab navigation will be performed.
	   '                                                                                                      b. If tab is disabled then return FALSE
	   '
	   '                   NOTE: This function will not verify if search field values are properly formatted or not  - YOU MUST PROVIDE THE PROPER FORMAT FOR EACH SEARCH FIELD!
	   '
		'Parameters: sSearchValues = search field label and value to select or enter into field . Use semicolon delimiter between field label and field value  (e.g., On Hold By;sksysadmin)
		'                                                            If more than one search fields to enter, use vertical bar '|' for field separator/delimiter  (e.g., On Hold By;skcoder2|On Hold Since;07/02/2012)
		'Calls: utilFunctions.vbs and ajaxSync.vbs
		'Returns: True/False
		'Usage: util.searchEncounter("On Hold By;skcoder2|Chart ID;5a876d60-40ba-476a-aa14-2436b1c4c11a")   '<= search encounter that is hold by 'skcoder2' and barcode '5a876d60-40ba-476a-aa14-2436b1c4c11a'
		'              OR
		'               sSearchValues="on hold by;all on hold|on hold since;07/11/2012|status;ready for research|dos start;02/02/2012|dos end;02/02/2012|client;amc|site id;sideid|retrieval provider group id;groupid|retrieval provider group name;groupname|retrieval provider first name;firstname|retrieval provider last name;lastname|chart id;chartid|on/offshore;onshore"
		'               util.searchEncounter(sSearchValues)   '<= enter all possible search fields and values
		'Created by: Hung Nguyen 11/6/2012
		'Modified: Hung Nguyen 11/15/12 Added to select NULL for 'On Hold By' and 'Client' drop-downs
		'          Hung Nguyen 12/11/12 Updated to get record count for the search criteria. And check for msg 'No records match the criteria entered.' to return True/False
		'**********************************************************************************************************************************************************************
		services.StartTransaction "searchEncounter"
		searchEncounter=False	'init return value
	
		'verify parameter
		If sSearchValues="" or isempty(sSearchValues) Then
			reporter.ReportEvent micFail,"Invalid parameter","Parameter 'sSearchValues' can't be empty."
			Exit Function
		End If
	
		Dim oAppBrowser,aFields,i,sFieldName,sFieldValue,aWebLists,aWebListIDs,j,iSelect,isWebListObj,oList,aAllitems
		Dim aWebEdits,aWebEditIDs,m,iSet,isWebEditObj,oEdit,k,sHtmlid,oTable,iCnt
	
		Set oAppBrowser=Browser(Environment("BROWSER_OBJ"))		'any Browser contains the object 
	
		'Precondition: check if tab is active
		If strcomp(util.tabHeaderStatus("Encounters"),"active",1) = 0 Then 
			Reporter.ReportEvent micInfo,"Encounters tab was active.",""
	
			'click Clear Search
			If oAppBrowser.WebButton("html id:=searchForm:cancelButton").Exist(2) Then
				oAppBrowser.WebButton("html id:=searchForm:cancelButton").Click
				oAppBrowser.Sync
			End If
		ElseIf strcomp(util.tabHeaderStatus("Encounters"),"inactive",1) = 0 Then
			Call util.maintabHeaderNavigate("Encounters")
			Call ajaxSync.ajaxSyncRequest("Processing Request",10)
			Reporter.ReportEvent micInfo,"Encounters tab was inactive. Navigate the tab...","Please wait!"
		ElseIf strcomp(util.tabHeaderStatus("Encounters"),"disabled",1) = 0 Then
			reporter.ReportEvent micFail,"Encounters tab is disabled","Abort!"
			Exit Function
		End If 
	
	
		'fields array
		aFields=split(sSearchValues,"|")
		For i=0 to ubound(aFields)
			isWebListObj=0
			isWebEditObj=0
	
			sFieldName=trim(split(aFields(i),";")(0))
			sFieldValue=trim(split(aFields(i),";")(1))
	
			aWebLists=array("On Hold By","Status","Client","On/Offshore")
			aWebListIDs=array("searchForm:onHoldByList","searchForm:statusList","searchForm:clientList","searchForm:userLocationValueList")
			For j=0 to ubound(aWebLists)
				If strcomp(sFieldName,aWebLists(j),1)=0 Then
					isWebListObj=1
					sFieldName=aWebLists(j)
					sHtmlid=aWebListIDs(j)
					Exit For
				End If
			Next
	
			If isWebListObj=0 Then
				aWebEdits=array("On Hold Since","DOS Start","DOS End","Site ID","Retrieval Provider Group ID","Retrieval Provider Group Name","Retrieval Provider First Name","Retrieval Provider Last Name","Chart ID")
				aWebEditIDs=array("onHoldSinceValueInputDate","DOSStartValueInputDate","DOSEndValueInputDate","siteIdValue","retrievalProvGrpIdValue","retrievalProvGrpNameValue","retrievalProviderFNameValue","retrievalProviderLNameValue","chartIdValue")
				For j=0 to ubound(aWebEdits)
					If strcomp(sFieldName,aWebEdits(j),1)=0 Then
						isWebEditObj=1
						sFieldName=aWebEdits(j)
						sHtmlid=aWebEditIDs(j)
						Exit For
					End If
				Next
			End If
	
			If isWebEditObj=0 and isWebListObj=0 Then
				reporter.ReportEvent micFail,"Invalid Search Field Label '" &sFieldName &"'",""
				Exit Function
			End If
	
	
			''>>>select a WebList value
			If isWebListObj=1 Then
				iSelect=0
				Set oList=oAppBrowser.WebList("html id:=" &sHtmlid)
				If oList.Exist(2) Then
					If sFieldValue="NULL" Then 	'set null for On Hold By and Client drop-downs are possible 
						If InStr(1,sFieldName,"on hold by",1) > 0 Or InStr(1,sFieldName,"client",1) > 0 Then 
							oList.Select ""
							iSelect=1
							oList.WaitProperty "disabled","0",3000
							oList.Select ""
						End If 
					Else				
						aAllitems=split(oList.GetROProperty("all items"),";")
						reporter.ReportEvent micinfo,"All Items in drop-down","Items found '" &oList.GetROProperty("all items") &"'"
						For k=0 to ubound(aAllitems)
							If instr(1,trim(aAllitems(k)),sFieldValue,1) > 0 Then
								iSelect=1
								oList.WaitProperty "disabled","0",3000
								oList.Select aAllitems(k)
								reporter.ReportEvent micPass,"The WebList '" &sFieldName &"' field label specified exists and the option '" &aAllitems(k) &"' was selected",""
								Exit For
							End If
						Next	'next obj item 
					End If 
				End If	'weblist obj id exists?
				Set oList=Nothing
	
				If iSelect=0 Then 
					reporter.ReportEvent micFail,"The WebList '" &sFieldName &"' field label specified exists but the option '" &sFieldValue &"' was NOT selected or does not exist - Invalid option?.",""
					Exit Function
				End If
			Else	
		
				''>>>enter a WebEdit value
				iSet=0
				Set oEdit=oAppBrowser.WebEdit("html id:=searchForm:" &sHtmlid)
				If oEdit.Exist(2) Then
					iSet=1
					oEdit.WaitProperty "disabled","0",3000
					oEdit.Set sFieldValue
					reporter.ReportEvent micPass,"The WebEdit '" &sFieldName &"' field label specified exists and value '" &sFieldValue &"' was set",""
				End If	'webedit obj id exists?
				Set oEdit=Nothing
		
				If iSet=0 Then 
					reporter.ReportEvent micFail,"The WebEdit '" &sFieldName &"' field label specified exists but value '" &sFieldValue &"' was NOT set successful.",""
					Exit Function
				End If
			End If
			Wait(1)		'1 sec wait is needed here!
		Next	'next parameter value
	
		''if I get to here then return TRUE
		oAppBrowser.WebButton("html id:=searchForm:searchButton").Click
		oAppBrowser.Sync
		
		Set oTable=oAppBrowser.WebTable("html id:=resultsForm:encounterTable")
		If oTable.Exist(3) Then
			iCnt=oTable.RowCount - 2 'data starts on row 2
		End If 
	
		'check and return True if no error message
		If oAppBrowser.WebTable("html id:=encounterNoRecordValuePG","innertext:=No records match the criteria entered.").Exist(15) Then
	    	reporter.reportevent micInfo,"No records match the criteria entered message exists",iCnt &" record(s) return."
	    Else
			reporter.reportevent micInfo,"Search Encounters",iCnt &" record(s) return."
			searchEncounter=True	'return value	    
		End If 
		
		Set oTable=Nothing 	
		Set oAppBrowser=Nothing
		services.EndTransaction "searchEncounter"
	End Function
	Function searchChartInResearchQueue()
		'******************************************************************************************
		'Purpose: ChartSync - Search for charts in the Research queue. If not then search in the Encounters screen
		'                   NOTE: for use in Encounters search test cases only!
		'Required: 	Must already logged in as a research user
		'Parameters: None
		'Calls: utilFunctions.vbs
		'Returns: a barcode found or Empty if fails
		'Usage: logged in as a research user
		'       if isempty(util.searchChartInResearchQueue) then
		'           msgbox "search returns no chart"
		'       else
		'           'do something
		'       end if 
		'Created by: Hung Nguyen 11/15/12
		'Modified:
		'******************************************************************************************
		services.starttransaction "searchChartInResearchQueue"
		searchChartInResearchQueue=Empty	'init return value
		
		dim oAppBrowser,sTab,iNav,sErrMsg,iBarcodeFound,oEncTable,sBarcode,sCurBarcode
		Set oAppBrowser=Browser(Environment("BROWSER_OBJ"))
	
		'>>>PRECONDITION: Verify there are charts in the Research queue
		reporter.ReportEvent micInfo,">>>Precondition - Verify there are charts in the Research queue",""
		sTab="Research"
		iNav=0
		If util.maintabHeaderNavigate(sTab) Then
			If strcomp(util.tabHeaderStatus(sTab),"active",1) = 0 Then 		'verify if the navigation is successful - the menu tab s/b active...
				Reporter.ReportEvent micInfo,"Navigate to '" &sTab &"' was successful. Tab is active",""
				iNav=1
			Else
				Reporter.ReportEvent micInfo,"Navigate to '" &sTab &"' was successful. But tab is not active",""
			End If
		Else
			Reporter.ReportEvent micInfo,"Function call to navigate to '" &sTab &"' failed.",""
		End If					
	
		If iNav=1 Then
			'>>>a. Is chart in the Research queue?
			reporter.ReportEvent micInfo,"Search for chart in the Research queue...",""
			sErrMsg="No chart is available"
			iBarcodeFound=0
			If oAppBrowser.WebTable("html id:=researchChartErrorMsg","innertext:=" &sErrMsg).Exist(2) Then	'message exists therefore there aren't charts in queue
			
				'return Home to search for charts from the Encounters tab
				If oAppBrowser.WebButton("html tag:=INPUT","type:=button","name:=Return To Home Screen").Exist(2) Then
					oAppBrowser.WebButton("html tag:=INPUT","type:=button","name:=Return To Home Screen").Click
				
					'click Confirm
					Call util.popupDialogButtonClick("All unsaved work will be lost. Are you sure you want to continue?","Confirm")
					reporter.ReportEvent micInfo,"Barcode not found in the Research queue... Will search in the Encounters tab.",""
				Else
					reporter.ReportEvent micFail,"The 'Return To Home Screen' button does not exist. Unable to click",""
					Exit Function
				End If
			Else	'message does not exist therefore there are charts in queue 
				iBarcodeFound=1
			
				' get the displayed barcode
				If oAppBrowser.WebElement("html id:=reasearchQueueDecisionForm:codeReviewchartidvalue").Exist(5) Then
					sBarcode=trim(oAppBrowser.WebElement("html id:=reasearchQueueDecisionForm:codeReviewchartidvalue").GetROProperty("innertext"))	
					If sBarcode<>"" And Not IsEmpty(sBarcode) And InStr(1,sBarcode,"ERROR",1) = 0 Then
						reporter.ReportEvent micPass,"Barcode '" &sBarcode &"' found in the Research queue",""
						searchChartInResearchQueue=sBarcode		'return value
					Else
						reporter.ReportEvent micInfo,"Barcode '" &sBarcode &"' not found in the Research queue. Search in the Encounters screen...",""
					End If
				Else
					reporter.reportevent micInfo,"The WebElement obj contains barcode value in the Research tab does not exist","Unable to retrieve the barcode value."
				End If 'go on to search in Encounters tab 
			End If
	
	
			'>>>b. Is chart in the Encounters search screen?
			reporter.ReportEvent micInfo,"Search for chart in the Encounters screen...",""
			If iBarcodeFound=0 Then
				reporter.ReportEvent micInfo,">>>Precondition - Verify there are charts in the Encounters screen",""
				sTab="Encounters"
				iNav=0
				If util.maintabHeaderNavigate(sTab) Then
					If strcomp(util.tabHeaderStatus(sTab),"active",1) = 0 Then 		'verify if the navigation is successful - the menu tab s/b active...
						Reporter.ReportEvent micInfo,"Navigate to '" &sTab &"' was successful. Tab is active",""
						iNav=1
					Else
						Reporter.ReportEvent micInfo,"Navigate to '" &sTab &"' was successful. But tab is not active",""
					End If
				Else
					Reporter.ReportEvent micInfo,"Function call to navigate to '" &sTab &"' failed.",""
				End If					
			
				If iNav=1 Then
				
					'Search for chart 'All not on hold'
					If util.searchEncounter("On Hold By;All not on hold|Status;All") Then
						Set oEncTable=oAppBrowser.WebTable("html id:=resultsForm:encounterTable")
						If oEncTable.RowCount >= 2 Then	'charts found
				
							'get barcode found from Encounters tab
							sBarcode=trim(oEncTable.GetCellData(2,3))
							reporter.ReportEvent micPass,"Barcode '" &sBarcode &"' found from search results in the Encounters page",""
				
							oEncTable.ChildItem(2,1,"WebElement",1).FireEvent "onmouseover"	
					
							'select Encounter Detail option from popup window to navigate to the Research tab
							If util.popupMenuItemSelect(oEncTable,2,1,"Encounter Detail") Then 
								If strcomp(util.tabSubHeaderStatus("Encounter Detail"),"active",1) =0  Then
								
									'get barcode from the Research tab
									sCurBarcode=trim(oAppBrowser.WebElement("html id:=reasearchQueueDecisionForm:codeReviewchartidvalue").GetROProperty("innertext"))
									If sCurBarcode=sBarcode Then	'same barcode in both screens
										reporter.ReportEvent micPass,"Barcode '" &sBarcode &"' found in the Research page. Barcode displayed '" &sCurBarcode &"'",""
										searchChartInResearchQueue=sBarcode		'return value
									Else
										reporter.ReportEvent micInfo,"Barcode '" &sBarcode &"' not found in the Research queue. Search in the Encounters screen...",""
									End If
								Else
									reporter.ReportEvent micFail,"Navigate 'Encounter Detail' option from popup window","The option was selected but the expected subtab 'Encounter Detail' is not active."
								End If		
							Else
								reporter.ReportEvent micFail,"Select 'Encounter Detail' option in the popup window","Function call to select the option returned fail."
							End If
						Else
							reporter.ReportEvent micFail,"Search Encounters return no records display in the table.","Please load data and rerun."
						End If
						Set oEncTable=Nothing
					Else
						reporter.ReportEvent micFail,"Encounters Search","Function call to search for charts in Encounters screen returned none. Please load data and rerun."
					End If 
				End If
			End If 
		End If
	
		Set oAppBrowser=Nothing
		services.endtransaction "searchChartInResearchQueue"
	End Function
	Function popupDialogEnterComments(parentObject,sCommentsObjName,sComments,sButtonName)
	   '***************************************************************************************************************************************************
		'Purpose: ChartSync - Enter comments and click the Confirm or Cancel button in the popup "Enter Comments" dialog window
		'Parameters: parentObject = the object (must be a WebTable object) that the WebEdit and WebButton objects are under 
		'                         sCommentsObjName= the property 'name' of the WebEdit object 
		'                                       OR an empty string if parameter sComments is an empty string
		'                         sComments= string - any text as comments 
		'                                      OR an empty string if parameter sCommentsObjName is an empty string
		'                         sButtonName=the name of the WebButton to click. (Confirm or Cancel)
		'
		'Returns: True/False
		'Calls: None
		'Usage: Set oTable=Browser("name:=Optum ChartSync").WebTable("html id:=researchEscToCoderConfirmContentTable")
		'                Call popupDialogEnterComments(oTable,"researchEscToCoderForm:researchEscToCoderInput","this is a test","Confirm")  'enter comment and click Confirm
		'     OR
		'                Call popupDialogEnterComments(oTable,"","","Cancel")  'enter nothing and click Cancel
		'     OR
		'              Call popupDialogEnterComments(oTable,"","","Confirm")  'enter nothing and click Confirm
		'Created by: Hung Nguyen 11/16/12
		'Modified: HUng Nguyen 2/15/13 updated the If statement, replaced 'or' to 'and' =>If sCommentsObjName<>"" And Not IsEmpty(sCommentsObjName) Then
		'***************************************************************************************************************************************************
		services.StartTransaction "popupDialogEnterComments"
		popupDialogEnterComments=False	'init return value
		Dim oEdit
	
		'verify parameter
		If sButtonName="" or IsEmpty(sButtonName) Then
			reporter.ReportEvent micFail,"Invalid Parameter","Parameter 'sButtonName' must contain a value."
			Exit Function
		End If
	
		If IsObject(parentObject) or parentObject.Exist(3) Then
			'enter comments
			If sCommentsObjName<>"" And Not IsEmpty(sCommentsObjName) Then
				Set oEdit=parentObject.WebEdit("html tag:=TEXTAREA","type:=textarea","name:=" &sCommentsObjName)
				If oEdit.Exist(2) Then
					If sComments<>"" or Not IsEmpty(sComments) Then
						oEdit.Set sComments
					End If
				Else
					reporter.ReportEvent micFail,"The Comments field object does not exist.",""
					Exit Function
				End If
				Set oEdit=Nothing
			End If
	
			'click the button
			If parentObject.WebButton("html tag:=INPUT","name:=" &sButtonName).Exist(2) Then
				parentObject.WebButton("html tag:=INPUT","name:=" &sButtonName).Click
				Call ajaxSync.ajaxSyncRequest("Processing Request",10)	'wait for processing request
	
				popupDialogEnterComments=True	'return value
			End If
		Else
			reporter.ReportEvent micFail,"Invalid Parameter","Parameter 'parentObject' must be an object and or must exist."
		End If
		services.EndTransaction "popupDialogEnterComments"
	End Function	

	Function ActionPotentialDelete (ByVal iSelection, ByVal sMode, ByVal sCode)
'***************************************************************************************
		'Purpose: Select Disposition Code & Update Reason in CV, CVQA Tab
		'Parameter: iCount  : Count of Disposition Code & Update Reason Code to be updated irrespective of user displayed i.e valid values 1,2,.....
								'sMode : Mode of Selection i.e, Disposition Code or Update Reason with DISPCODE:REASON  or	DISPCODE or REASON
								'sCode : Data to be selected from Disposition code and Update Reason List Boxes i.e CVD01:M201~CVD02:M202~CVD21:M204  or CVD01~CVD03 or M201
		'Returns: True/False
		'Usage Example: util.ActionPotentialDelete(3, "DISPCODE:REASON",  "CVD01:M201~CVD02:M202~CVD21:M204")
											'util.ActionPotentialDelete(2, "DISPCODE",  "CVD01~CVD02")
											'util.ActionPotentialDelete(4, "REASON",  "M201~M203")
		'Author: Govardhan Choletti 01/02/2013
'***************************************************************************************
	'Variable Declaration
		Dim sBrowserTitle, sAllValues, sSelection
		Dim iPos,iCnt, cnt, kCnt
		Dim aModeOperation, aDispCodeVals, aDispCodes, aDispUpdteReasonHTMLID, aDispUpdteReasonNAME
		Dim oTablePotDels, oListPotDels, oDispCodes
		
	'Variable initialisation
		iPos = 0
		sBrowserTitle =  "title:="& Environment("BROWSER_TITLE")

		'Input  First Parameter Validation
		If IsEmpty(iSelection) OR iSelection = "" Then
			iSelection = 100
		ElseIf IsNumeric(iSelection) Then
			' Do Nothing
		Else
			Reporter.ReportEvent micFail, "ActionPotentialDelete --> Disposition Code Field", "First Parameter : '"& iSelection &"' should be a Number or Left Blank, NOT as Expected"
		End If

		'Second Parameter Validation
		If sMode = "" OR IsEmpty(sMode) = "" Then
			Reporter.ReportEvent micFail, "ActionPotentialDelete --> Disposition Code Field", "Second Parameter : '"& sMode &"' cann't be left as blank, NOT as Expected"
			ActionPotentialDelete = False
			Exit Function
		Else
			aModeOperation = Split(sMode, ":") 
			If UBound(aModeOperation) = 1 Then
				If (aModeOperation(0) = "DISPCODE" And aModeOperation(1) = "REASON") OR (aModeOperation(1) = "DISPCODE" And aModeOperation(0) = "REASON") Then
					'Do Nothing
				Else
					Reporter.ReportEvent micFail, "ActionPotentialDelete --> Disposition Code Field", "Second Parameter : '"& sMode &"' should be either passed as DISPCODE:REASON (OR) DISPCODE (OR) REASON, NOT as Expected"
					ActionPotentialDelete = False
					Exit Function
				End If
			ElseIf UBound(aModeOperation) = 0 Then
				If (aModeOperation(0) = "DISPCODE") OR (aModeOperation(0) = "REASON") Then
					Select Case aModeOperation(0)
						Case "DISPCODE"
							iPos = 0
						Case "REASON"
							iPos = 1
					End Select
				Else
					Reporter.ReportEvent micFail, "ActionPotentialDelete --> Disposition Code Field", "Second Parameter : '"& sMode &"' should be either passed as DISPCODE:REASON (OR) DISPCODE (OR) REASON, NOT as Expected"
					ActionPotentialDelete = False
					Exit Function
				End If
			Else
				Reporter.ReportEvent micFail, "ActionPotentialDelete --> Disposition Code Field", "Second Parameter : '"& sMode &"' should be either passed as DISPCODE:REASON (OR) DISPCODE (OR) REASON, NOT as Expected"
				ActionPotentialDelete = False
				Exit Function
			End If
		End If

		'Third Parameter Validation
		If sCode = "" OR IsEmpty(sCode) = "" Then
			Reporter.ReportEvent micFail, "ActionPotentialDelete --> Update Reason Field", "Third Parameter : '"& sCode &"' cann't be left as blank, NOT as Expected"
			ActionPotentialDelete = False
			Exit Function
		Else
			aDispCodeVals = Split(sCode, "~") 
			iCnt = 0
			If UBound(aModeOperation) = 1 Then
				Do
					aDispCodes = Split(aDispCodeVals(iCnt), ":")
					If UBound(aModeOperation) = UBound(aDispCodes) Then
						'Do Nothing
					Else
						Reporter.ReportEvent micFail, "ActionPotentialDelete --> Update Reason Field", "Third Parameter : '"& sCode &"' should be passed as e.g.,1. CD0001:M200~CD0002:M201 , 2. CD0001:M200,, NOT as Expected"
						ActionPotentialDelete = False
						Exit Function
					End If
					iCnt = iCnt + 1
				Loop Until (UBound(aDispCodeVals) = iCnt-1)
			ElseIf UBound(aModeOperation) = 0 Then
				Do
					aDispCodes = Split(aDispCodeVals(iCnt), ":")
					If UBound(aModeOperation) = UBound(aDispCodes) Then
						'Do Nothing
					Else
						Reporter.ReportEvent micFail, "ActionPotentialDelete --> Update Reason Field", "Third Parameter : '"& sCode &"' should be passed as e.g.,1.  CD0001~CD0002, 2. M200~M201, 3. CD01, 4.M200, NOT as Expected"
						ActionPotentialDelete = False
						Exit Function
					End If
					iCnt = iCnt + 1
				Loop Until (UBound(aDispCodeVals) = iCnt-1)
			End If
		End If
	
	' Update All Potential Deletes with Disposition Codes and Update Reason accordingly as below:
		ActionPotentialDelete = True 
		aDispUpdteReasonHTMLID = Array(".*MatchingLogic_Form:.*potentialDelGrid_List:([0-9]?[0-9]):.*dispCode_Del_DropDown", ".*MatchingLogic_Form:.*PotentialDelGrid_List:([0-9]?[0-9]):.*dispCodeDelUpdateReason1")
		aDispUpdteReasonNAME = Array("Disposition Codes", "Update Reason")
		For iCnt = 0 to UBound(aModeOperation)
			Set oTablePotDels = Description.Create()
			oTablePotDels("MicClass").Value = "WebTable"
			oTablePotDels("html id").Value = ".*MatchingLogic_Form:claimDiscrepencies_Panel_Grid"				' Potential Delete Section	
			oTablePotDels("html tag").Value = "TABLE"
		
			If Browser(sBrowserTitle).webtable(oTablePotDels).Exist(3) Then
				' Group All Potential Deletes ==> Disposition Code together
				Set oListPotDels = Description.Create()
				oListPotDels("MicClass").Value = "WebList"
				oListPotDels("html id").Value = aDispUpdteReasonHTMLID(iCnt+iPos)				' Potential Delete Section
				oListPotDels("html id").RegularExpression =True				' Potential Delete Section
				oListPotDels("html tag").Value = "SELECT"
		
				'Perform Action on each List Box as supplied by User
				Set oDispCodes = Browser(sBrowserTitle).webtable(oTablePotDels).ChildObjects(oListPotDels)

				If oDispCodes.count > 0 Then
					' Verify the Count passed is Less or Equal to the Actual fields
					If iSelection >oDispCodes.count Then
						Reporter.ReportEvent micWarning,"ActionPotentialDelete --> List Box Count ","Disposition code List box count passed by user is Higher '"& iSelection &"', when compared to actual List box count  '"& oDispCodes.count &"'"
						iSelection = oDispCodes.count
					End If

					cnt = 0
					For kCnt = 0 to (iSelection-1) Step 1
					' Value Selection in List Boxes Disposition Code and Update Reason as number of different Input passed by User
						If cnt < UBound(aDispCodeVals) And  kCnt<>0 Then
							cnt = cnt +1
						Else
							cnt = 0		
						End If
			
					'Value Selection in CV/CVQA Panel
						If UBound(aModeOperation) = 0 Then
							sSelection = aDispCodeVals(cnt)
						Else
							aDispCodes = Split(aDispCodeVals(cnt), ":")
							Select Case iCnt
								Case 0
									sSelection = aDispCodes(0)
								Case 1
									sSelection = aDispCodes(1)
							End Select
						End If

						' Get all the available List box values from Disposition code and Update Reason boxes and validate accordingly
						sAllValues = oDispCodes(kCnt).GetROProperty("all items")
						If Instr(1, sAllValues &";" , sSelection &";", 1) > 0 Then
							oDispCodes(kCnt).Select sSelection
							Reporter.ReportEvent micPass,"ActionPotentialDelete --> "& aDispUpdteReasonNAME(iCnt+iPos), ""& aDispUpdteReasonNAME(iCnt+iPos) &" : '"& sSelection &"' is selected successfully in potential Delete Section, as Expected"
						Else
							Reporter.ReportEvent micFail, "ActionPotentialDelete --> "& aDispUpdteReasonNAME(iCnt+iPos), ""& aDispUpdteReasonNAME(iCnt+iPos) &" : '"& sSelection &"' is N/A in the List '"& sAllValues &"' for potential delete Section, NOT as Expected"
							ActionPotentialDelete = False
						End If
					Next
				Else
					Reporter.ReportEvent micWarning,"ActionPotentialDelete --> "& aDispUpdteReasonNAME(iCnt), "There are NO CMS, RX-HCCs OR '"& aDispUpdteReasonNAME(iCnt+iPos) &"' are available in Potential Delete Section or Test Object Property might have been modified , NOT as Expected"
				End If
			Else
				Reporter.ReportEvent micFail, "ActionPotentialDelete --> "& aDispUpdteReasonNAME(iCnt), " Potential delete Section is N/A on Screen or Test Object Property might have been modified , NOT as Expected"
				ActionPotentialDelete = False
			End If
			Set oDispCodes = Nothing
			Set oListPotDels = Nothing
			Set oTablePotDels = Nothing
		Next
	End Function
	
	Function ProjectTypeSelection (ByVal sProjectType)
'***************************************************************************************
		'Purpose: Select Project Review Type and Click on Get Charts Button.
		'Parameter: sProjectType : Project Type has to be passed as a parameter here i.e "CHART REVIEW", "COI", "HQPAF", "PAF/CAPE", "ANY"
		'Returns: True/False
		'Usage Example: util.ProjectTypeSelection("CHART REVIEW")		--> To Select Chart Review from the List
						'util.ProjectTypeSelection("ANY")		--> To Select Any Project Type from List Box until Chart's are displayed to user
		'Author: Govardhan Choletti 01/04/2013
'***************************************************************************************
		'Variable Declaration
		Dim sChartAvailable, sAllValues, sBrowserTitle, sProjType
		Dim aProjReviewType
		Dim iCount
		Dim bErrorMessage
		Dim oListProjType

		' Variable Declaration
		aProjReviewType = Array("CHART REVIEW", "COI", "HQPAF", "PAF/CAPE")
		sChartAvailable = "No Chart available"
'		sBrowserTitle = "title:="& Environment("BROWSER_TITLE")
		sBrowserTitle = "title:=Optum ChartSync"
		bErrorMessage = True
		ProjectTypeSelection = False
		iCount = 0
       
		'Parameter Validation
		If sProjectType = "" OR IsEmpty(sProjectType) = "" Then
			Reporter.ReportEvent micFail, "ProjectTypeSelection --> Project Type", "Parameter : '"& sProjType &"' cann't be left as blank, NOT as Expected"
			ProjectTypeSelection = False
		ElseIf UCase(sProjectType) = "CHART REVIEW" OR UCase(sProjectType) = "COI" OR UCase(sProjectType) = "HQPAF" OR UCase(sProjectType) = "PAF/CAPE" OR UCase(sProjectType) = "ANY" Then
			Do
				iCount = iCount +1
				'If User Specifies any Review type to Select, Then Select the Review Type that has Charts displayed on screen
				If UCase(sProjectType) = "ANY" Then
					sProjType = aProjReviewType(RandomNumber(LBound(aProjReviewType), UBound(aProjReviewType)))
				Else
					sProjType = UCase(sProjectType)
				End If
	
				'WebList Chart Review Type Selection
				Set oListProjType = Description.Create()
				oListProjType("MicClass").Value = "WebList"
				oListProjType("html id").Value = ",*(c|C)laim(s|)Button_Form:reviewTypeValue.*"			' Project Type
				oListProjType("html id").RegularExpression =True				' Potential Delete Section
				oListProjType("html tag").Value = "SELECT"
	
				'If Project Review Type List Box Exist(s)
				If Browser(sBrowserTitle).WebList(oListProjType).Exist(3) Then
					sAllValues = Browser(sBrowserTitle).WebList(oListProjType).GetROProperty("all items")
					If Instr(1, sAllValues &";" , sProjType &";", 1) > 0 Then
						Browser(sBrowserTitle).WebList(oListProjType).Select sProjType
						Reporter.ReportEvent micPass,"ProjectTypeSelection --> ", sProjType &"' is selected successfully in Project Type DropDown, as Expected"
					Else
						Reporter.ReportEvent micFail, "ProjectTypeSelection --> ", sProjType &"' is N/A in the List '"& sAllValues &"' for Project Review Type DropDown, NOT as Expected"
						ProjectTypeSelection = False
					End If
				Else
					Reporter.ReportEvent micFail, "ProjectTypeSelection ", "' Project Review Type DropDown is N/A, Check with Object Property, NOT as Expected"
				End If
	
			'Click on Get Charts Button
				If of.webButtonClicker("Get Charts") = True Then
					Reporter.ReportEvent micInfo,"ProjectTypeSelection, Button - GETCHARTS ","'GETCHARTS' button is clicked Succesfully"
					Wait(2)
					Call ajaxSync.ajaxSyncRequest("Processing Request",60)
				Else
					Reporter.ReportEvent micInfo,"ProjectTypeSelection, Button - GETCHARTS ","Unable to perform click on 'GETCHARTS' button, Not as Expected"
				End If
	
				'Verify Message is displayed
				If of.objectFinder("WebElement","html id~innertext~html tag", "cv(Qa|)ReviewNoChartMsg~"& sChartAvailable &"~SPAN","True~False~False") = True Then
					Reporter.ReportEvent micInfo,"ProjectTypeSelection => "& sChartAvailable ,"Message : '"& sChartAvailable &"' is displayed on Screen, NOT as Expected"
				Else
					Reporter.ReportEvent micPass,"ProjectTypeSelection => "& sChartAvailable,"Message : '"& sChartAvailable &"' is NOT displayed on Screen, which is as Expected"
					ProjectTypeSelection = True
					bErrorMessage = False
				End If
			Loop While (sProjectType = "ANY" AND bErrorMessage AND iCount < 6)
		Else
			Reporter.ReportEvent micFail, "ProjectTypeSelection --> Project Type", "Invalid Parameter : '"& sProjType &"' passed, NOT as Expected. Parameter has to be 'CHART REVIEW', 'COI', 'HQPAF', 'PAF/CAPE', 'ANY'"
		End If
		Set oListProjType = Nothing
	End Function
	
	Function VerifyBestEvidenceCheckBox (ByVal sCompOutcome)
'***************************************************************************************
		'Purpose: Verify the Best Evidences Checkboxes are displayed under Potential Delete Section, Adds CV/CVQA, Incomplete-Missing DOS, Adds Original
		'Parameter: Comparison Outcome TYPE : Adds CV/CVQA, Deletes, Matches, Incomplete, Adds Original 
		'Returns: True/False
		'Usage Example: util.VerifyBestEvidenceCheckBox("Matches")		--> To Select Chart Review from the List
		'Author: Govardhan Choletti 01/10/2013
'***************************************************************************************
		'Declare Variable
		Dim sTableHTMLId, sCode, sHCCRx, sInnerTbHTMLId
		Dim iTblCnt, iRowCnt, iBestEvid
		Dim oAppBrowser, oTableObj, oBestEvidTable, oCheckBox

		'Initialise variables
        Set oAppBrowser=Browser(Environment("BROWSER_OBJ"))
'		Set oAppBrowser=Browser("title:=Optum ChartSync")

		'Parameter Validation
		If sCompOutcome = "" OR IsEmpty(sCompOutcome) = "" Then
			Reporter.ReportEvent micFail, "VerifyBestEvidenceCheckBox --> Project Type", "Parameter : '"& sProjType &"' cann't be left as blank, NOT as Expected"
			VerifyBestEvidenceCheckBox = False
		ElseIf Instr(1, "ADDS CV/CVQA:DELETES:MATCHES:INCOMPLETE:ADDS ORIGINAL:", UCase(sCompOutcome) &":", 1 ) > 0 Then
	
			'Select the Table HTML ID accordingly for selection
			Select Case UCase(sCompOutcome)
				Case "DELETES"
					sTableHTMLId = "saveAndRunMatchingLogic_Form:potentialDelGrid_List"
				Case "ADDS CV/CVQA"
					sTableHTMLId = "saveAndRunMatchingLogic_Form:potentialAddGrid_List"
				Case "MATCHES"
					sTableHTMLId = "saveAndRunMatchingLogic_Form:potentialMatch_List"
				Case "INCOMPLETE"
					sTableHTMLId = "saveAndRunMatchingLogic_Form:potentialIncGrid_List"
				Case "ADDS ORIGINAL"
					sTableHTMLId = "saveAndRunMatchingLogic_Form:potentialOriginalAddGrid_List"
			End Select

			If oAppBrowser.WebTable("Html id:="& sTableHTMLId).Exist(3) Then
				Reporter.ReportEvent micPass, "VerifyBestEvidenceCheckBox --> Table - "& UCase(sCompOutcome), UCase(sCompOutcome)  &" Section is shown in application as Expected"

				'Group all WebTables inside this Main Table
				Set oTableObj = Description.Create()
				oTableObj("micclass").Value = "WebTable"
				'oTableObj("column names").Value = "CV Reviewed;Best Evidence;Service Dates;DX"
				oTableObj("column names").Value = "CVReviewed;BestEvidence;Service Dates;DX"
	
				'Identify and Get All Child Objects WebTable
				Set oBestEvidTable = oAppBrowser.WebTable("html id:="& sTableHTMLId).ChildObjects(oTableObj) 

				'Verify If No BEST EVIDENCE CheckBox is displayed to User
				If oBestEvidTable.Count = 0 Then
					Reporter.ReportEvent micWarning, "VerifyBestEvidenceCheckBox --> Table - "& UCase(sCompOutcome), UCase(sCompOutcome)  &" Section doesn't have any Best Evidence CheckBoxes"
				Else

					'Loop across each Table and Verify the BestEvidence Check box Column along with Checkbox is in Editable Mode
					For iTblCnt = 0 to (oBestEvidTable.Count - 1) Step 1
						' Table Data
						sCode = oAppBrowser.WebTable("html id:="& sTableHTMLId).GetCellData(iTblCnt+2, 1)
						sHCCRx = oAppBrowser.WebTable("html id:="& sTableHTMLId).GetCellData(iTblCnt+2, 2)
				
						'Get All the Rows for the Sub WebTable
						iRowCnt = oBestEvidTable(iTblCnt).RowCount
						sInnerTbHTMLId = oBestEvidTable(iTblCnt).GetRoProperty("html id")
	
					'Loop acrorss each Row and Column to Validate the BEST EVIDENCE CheckBox
						For iBestEvid = 2 to iRowCnt Step 1
							Set oCheckBox = oAppBrowser.WebTable("html id:="& sInnerTbHTMLId).ChildItem(iBestEvid, 2, "WebCheckBox", 0)
	
							'Check the Property of CheckBox i.e Checked or Unchecked
							oCheckBox.Highlight
							If oCheckBox.GetRoProperty("checked") = 0  Then
								Reporter.ReportEvent micPass, "VerifyBestEvidenceCheckBox --> Table - "& UCase(sCompOutcome), UCase(sCompOutcome)  &" Section with code - '"& sCode &"' and HCC/RXHCC - '"& sHCCRx &"' has '"& (iRowCnt-1) &"' CheckBoxes with checkbox '"& (iBestEvid-1) &"' is Unchecked, as Expected"
							ElseIf oCheckBox.GetRoProperty("checked") = 1  Then
								Reporter.ReportEvent micPass, "VerifyBestEvidenceCheckBox --> Table - "& UCase(sCompOutcome), UCase(sCompOutcome)  &" Section with code - '"& sCode &"' and HCC/RXHCC - '"& sHCCRx &"' has '"& (iRowCnt-1) &"' CheckBoxes with checkbox '"& (iBestEvid-1) &"' is Checked, as Expected"
							Else
								Reporter.ReportEvent micPass, "VerifyBestEvidenceCheckBox --> Table - "& UCase(sCompOutcome), UCase(sCompOutcome)  &" Section with code - '"& sCode &"' and HCC/RXHCC - '"& sHCCRx &"' has '"& (iRowCnt-1) &"' CheckBoxes with checkbox '"& (iBestEvid-1) &"' is N/A, NOT as Expected"
							End If
						Next
					Next
				End If
			Else
				Reporter.ReportEvent micFail, "VerifyBestEvidenceCheckBox --> Table - "& UCase(sCompOutcome), UCase(sCompOutcome)  &" Section is NOT shown in application OR NO Data is available in this section, NOT as Expected"
			End If
        Else
			Reporter.ReportEvent micFail, "VerifyBestEvidenceCheckBox --> Comparison Outcome", "Invalid Parameter : '"& sCompOutcome &"' passed, NOT as Expected. Parameter has to be 'ADDS CV/CVQA", "DELETES", "MATCHES", "INCOMPLETE", "ADDS ORIGINAL'"
		End If

		'Free Variables
		Set oAppBrowser = Nothing
		Set oTableObj = Nothing
		Set oBestEvidTable = Nothing
		Set oCheckBox = Nothing
	End Function
	
	Function VerifyCVReviewedCheckBox (ByVal sCompOutcome)
'***************************************************************************************
		'Purpose: Verify the CV Reviewed Checkboxes are displayed under Potential Delete Section, Adds CV/CVQA, Incomplete-Missing DOS, Adds Original
		'Parameter: Comparison Outcome TYPE : Adds CV/CVQA, Deletes, Matches, Incomplete, Adds Original 
		'Returns: "10" - CheckBox Shown on UI and No Validation i.e, Ticked or Not Ticked
		'		  "00" - CheckBox doesn't Shown on UI
		'	      "11" - CheckBox Shown on UI and Not Ticked
		'		  "12" - CheckBox Shown on UI and Ticked
		'Usage Example: util.VerifyCVReviewedCheckBox("Matches")		--> To Select Chart Review from the List
		'Author: Govardhan Choletti 01/16/2013
'***************************************************************************************
		'Declare Variable
		Dim sTableHTMLId, sCode, sHCCRx, sInnerTbHTMLId
		Dim iTblCnt, iRowCnt, iCVReview
		Dim oAppBrowser, oTableObj, oCvReviewTable, oCheckBox
		VerifyCVReviewedCheckBox = "00"

		'Initialise variables
        Set oAppBrowser=Browser(Environment("BROWSER_OBJ"))
'		Set oAppBrowser=Browser("title:=Optum ChartSync")

		'Parameter Validation
		If sCompOutcome = "" OR IsEmpty(sCompOutcome) = "" Then
			Reporter.ReportEvent micFail, "VerifyCVReviewedCheckBox --> Project Type", "Parameter : '"& sProjType &"' cann't be left as blank, NOT as Expected"
		ElseIf Instr(1, "ADDS CV/CVQA:DELETES:MATCHES:INCOMPLETE:ADDS ORIGINAL:", UCase(sCompOutcome) &":", 1 ) > 0 Then
	
			'Select the Table HTML ID accordingly for selection
			Select Case UCase(sCompOutcome)
				Case "DELETES"
					sTableHTMLId = "saveAndRunMatchingLogic_Form:potentialDelGrid_List"
				Case "ADDS CV/CVQA"
					sTableHTMLId = "saveAndRunMatchingLogic_Form:potentialAddGrid_List"
				Case "MATCHES"
					sTableHTMLId = "saveAndRunMatchingLogic_Form:potentialMatch_List"
				Case "INCOMPLETE"
					sTableHTMLId = "saveAndRunMatchingLogic_Form:potentialIncGrid_List"
				Case "ADDS ORIGINAL"
					sTableHTMLId = "saveAndRunMatchingLogic_Form:potentialOriginalAddGrid_List"
			End Select

			If oAppBrowser.WebTable("Html id:="& sTableHTMLId).Exist(3) Then
				Reporter.ReportEvent micPass, "VerifyCVReviewedCheckBox --> Table - "& UCase(sCompOutcome), UCase(sCompOutcome)  &" Section is shown in application as Expected"

				'Group all WebTables inside this Main Table
				Set oTableObj = Description.Create()
				oTableObj("micclass").Value = "WebTable"
				oTableObj("column names").Value = "CVReviewed;BestEvidence;Service Dates;DX"
	
				'Identify and Get All Child Objects WebTable
				Set oCvReviewTable = oAppBrowser.WebTable("html id:="& sTableHTMLId).ChildObjects(oTableObj) 

				'Verify If No BEST EVIDENCE CheckBox is displayed to User
				If oCvReviewTable.Count = 0 Then
					Reporter.ReportEvent micWarning, "VerifyCVReviewedCheckBox --> Table - "& UCase(sCompOutcome), UCase(sCompOutcome)  &" Section doesn't have any Best Evidence CheckBoxes"
					VerifyCVReviewedCheckBox = "00"
				Else

					'Loop across each Table and Verify the BestEvidence Check box Column along with Checkbox is in Editable Mode
					For iTblCnt = 0 to (oCvReviewTable.Count - 1) Step 1
						' Table Data
						sCode = oAppBrowser.WebTable("html id:="& sTableHTMLId).GetCellData(iTblCnt+2, 1)
						sHCCRx = oAppBrowser.WebTable("html id:="& sTableHTMLId).GetCellData(iTblCnt+2, 2)
				
						'Get All the Rows for the Sub WebTable
						iRowCnt = oCvReviewTable(iTblCnt).RowCount
						sInnerTbHTMLId = oCvReviewTable(iTblCnt).GetRoProperty("html id")
	
					'Loop acrorss each Row and Column to Validate the BEST EVIDENCE CheckBox
						For iCVReview = 2 to iRowCnt Step 1
							Set oCheckBox = oAppBrowser.WebTable("html id:="& sInnerTbHTMLId).ChildItem(iCVReview, 1, "WebCheckBox", 0)
	
							'Check the Property of CheckBox i.e Checked or Unchecked
							oCheckBox.Highlight
							If oCheckBox.GetRoProperty("checked") = 0  Then
								Reporter.ReportEvent micPass, "VerifyCVReviewedCheckBox --> Table - "& UCase(sCompOutcome), UCase(sCompOutcome)  &" Section with code - '"& sCode &"' and HCC/RXHCC - '"& sHCCRx &"' has '"& (iRowCnt-1) &"' CheckBoxes with checkbox '"& (iCVReview-1) &"' is Unchecked, as Expected"
								VerifyCVReviewedCheckBox = "11"
							ElseIf oCheckBox.GetRoProperty("checked") = 1  Then
								Reporter.ReportEvent micPass, "VerifyCVReviewedCheckBox --> Table - "& UCase(sCompOutcome), UCase(sCompOutcome)  &" Section with code - '"& sCode &"' and HCC/RXHCC - '"& sHCCRx &"' has '"& (iRowCnt-1) &"' CheckBoxes with checkbox '"& (iCVReview-1) &"' is Checked, as Expected"
								VerifyCVReviewedCheckBox = "12"
							Else
								Reporter.ReportEvent micFail, "VerifyCVReviewedCheckBox --> Table - "& UCase(sCompOutcome), UCase(sCompOutcome)  &" Section with code - '"& sCode &"' and HCC/RXHCC - '"& sHCCRx &"' has '"& (iRowCnt-1) &"' CheckBoxes with checkbox '"& (iCVReview-1) &"' is N/A, NOT as Expected"
								VerifyCVReviewedCheckBox = "10"
							End If
						Next
					Next
				End If
			Else
				Reporter.ReportEvent micFail, "VerifyCVReviewedCheckBox --> Table - "& UCase(sCompOutcome), UCase(sCompOutcome)  &" Section is NOT shown in application OR NO Data is available in this section, NOT as Expected"
			End If
        Else
			Reporter.ReportEvent micFail, "VerifyCVReviewedCheckBox --> Comparison Outcome", "Invalid Parameter : '"& sCompOutcome &"' passed, NOT as Expected. Parameter has to be 'ADDS CV/CVQA", "DELETES", "MATCHES", "INCOMPLETE", "ADDS ORIGINAL'"
		End If

		'Free Variables
		Set oAppBrowser = Nothing
		Set oTableObj = Nothing
		Set oCvReviewTable = Nothing
		Set oCheckBox = Nothing
	End Function
	
	Function sortTableColumn(oTable,iCol,sSortDirection)
	   '**********************************************************************************************************************************************************
	   'Purpose: ChartSync - Verify sorting column in the Encounters listing table in the Encounters page ONLY!
	   '                   Loop a webtable object per column # specified to compare each cell value and return True/False per sort direction
	   'NOTE:This custom function was created to verify sorting in the Encounters search result webtable
	   '
	   'Requires: MUST CLICK THE SORT IMAGE OBJ WITHIN THE COLUMN HEADER THEN calling this function TO VERIFY SORT DIRECTION!!!
		'
		'Parameters: oTable = a WebTable object
		'                          iCol = column number to get cell value
		'                          sSortDirection =  two valid values: ascending and descending
		'Calls= None
		'Returns: True/False
		'
		'Usage:  oBrowser.Image("html id:=resultsForm:encounterTable:encDateAscImage","file name:=ascending.gif").Click		'click to sort 
		'                Call ajaxSync.ajaxSyncRequest("Processing Request",10)	'wait for processing request w/timeout in secs
		'                Set oEncTable=oBrowser.WebTable("html id:=resultsForm:encounterTable")
		'                msgbox util.sortTableColumn(oEncTable,1,"ascending")			'verify sorting ascending in column1
		'
		'Created by: Hung Nguyen 2/8/13
		'Modified: Hung Nguyen 4/30/13 - Updated logic to skip columns which contains no values and accounted for the mixed cell with and without value.
		'**********************************************************************************************************************************************************
		services.StartTransaction "sortTableColumn"
	   sortTableColumn=False
	   Dim r,iCntNegative,sValue,sCellValue,iRowCnt,iCntCellValue
	
	   'verify parameters
	   If Not isnumeric(iCol) Then
		   reporter.ReportEvent micFail,"Invalid parameter","Parameter 'iCol' value must be a numeric value"
		   exit function
	   End If
	
		If strcomp(sSortDirection,"ascending",1)<>0 And strcomp(sSortDirection,"descending",1)<>0 Then
			reporter.ReportEvent micFail,"Invalid parameter","Parameter 'sSortDirection' value must be 'ascending' or 'descending'"
			Exit function
		End If
	
		If isobject(oTable) And oTable.GetROProperty("micclass")="WebTable" Then
			iRowCnt=oTable.RowCount
			iCntCellValue=0
			sValue=""
			iCntNegative=0
			For r=2 to oTable.RowCount - 1	'less last empty row
				sCellValue=trim(oTable.GetCellData(r,iCol))

				Select Case sSortDirection
					Case "ascending"	'low to high
						If sValue < sCellValue Then		'positive
							reporter.ReportEvent micInfo,"Sort '" &sSortDirection &"' - low to high","The previous cell value'" &sValue &"' is less than the current cell value '" &sCellValue &"'. Expected"
							sValue=sCellValue		'after the report statement please!
						ElseIf sValue = sCellValue Then		'positive
							reporter.ReportEvent micInfo,"Sort '" &sSortDirection &"' - low to high","The previous cell value'" &sValue &"' is equal to the current cell value '" &sCellValue &"'. Expected"
							sValue=sCellValue		'after the report statement please!
						Else	'negative
							iCntNegative = iCntNegative + 1
							reporter.ReportEvent micFail,"Sort '" &sSortDirection &"' - low to high","The previous cell value'" &sValue &"' is either NOT less than or equal to the current cell value '" &sCellValue &"'. Not expected"
						'	Exit For	'no need to go further
						End If
					Case "descending"	'high to low
						If sValue > sCellValue Then		'positive
							reporter.ReportEvent micInfo,"Sort '" &sSortDirection &"' - high to low","The previous cell value'" &sValue &"' is greater than the current cell value '" &sCellValue &"'. Expected"
							sValue=sCellValue		'after the report statement please!
						ElseIf sValue = sCellValue Then		'positive
							reporter.ReportEvent micInfo,"Sort '" &sSortDirection &"' - high to low","The previous cell value'" &sValue &"' is equal to the current cell value '" &sCellValue &"'. Expected"
							sValue=sCellValue		'after the report statement please!
						Else	'negative
							iCntNegative = iCntNegative + 1
							reporter.ReportEvent micFail,"Sort '" &sSortDirection &"' - high to low","The previous cell value'" &sValue &"' is either NOT greater than or equal to the current cell value '" &sCellValue &"'. Not expected"
							Exit For	'no need to go further
						End If
				End Select
			Next	'row
	
			If iCntNegative=0 And iCntCellValue <> iRowCnt - 2 Then
				reporter.ReportEvent micPass,"Sort '" &sSortDirection &"' was successful.",""
				sortTableColumn=True	'return value
			Else
				reporter.ReportEvent micFail,"Sort '" &sSortDirection &"' was NOT successful. Do ALL cells contain value??? ",""
			End If
		Else
			reporter.ReportEvent micFail,"Sort Table Column","The table object is not an object."
		End If
	
		services.EndTransaction "sortTableColumn"
	End Function
	
	Function popupIntakeReject(sRejectCodes,sComments,sButtonName)
	   '***************************************************************************************************************************************************
		'Purpose: ChartSync > Intake page. Reject a chart w/reason codes and comments provided
		'                   The popup window contains objects: checkboxes for reason codes, comment field, 2 buttons: Submit and Cancel
		'Requires: The popup window 'Reject Intake' must be present prior to calling this function - click the Reject button first
		'Parameters: sRejectCodes = The reason code(s) semicolon separated if more than one to be checked (not required)
		'                                                          or an EMPTY string for an error message returns to be verified.
		'                         sComments = a reject comment  or an EMPTY string (not required)
		'                        sButtonName = the button name to click. Valid button names are: Submit and Cancel (required)
		'Returns: True/False
		'NOTE: The function does not return any error message if one exists. 
		'              An example of triggering an error message is just clicking the Submit button w/o any reason code selected.
		'              You then need to capture the expected error messages after the function is executed.
		'
		'Calls: None
		'Usage: oBrowser.WebButton("html tag:=INPUT","type:=submit","name:=Reject").Click 		'click the Reject button
		'               popupIntakeReject("Document is illegible","my comments","Submit") 'call to reject the chart w/the reason code specified
		'  OR
		'               popupIntakeReject("",","Cancel ") 'call to just click Cancel
		'  OR
		'               Call popupIntakeReject("",","Submit") 'call to click Submit then check for error message
		'               if oBrowser.WebElement("html id:=intakeReviewnoChartMsg").Exist(5) Then
		'                      sErrMsg=oBrowser.WebElement("html id:=intakeReviewnoChartMsg").GetROProperty("innertext")
		'                      reporter.reportevent micPass, "expected error message exists '" &sErrMsg &"'",""
		'                else 
		'                          'expected error message does not exist
		'                end if 
		'Created by: Hung Nguyen 2/21/13
		'Modified: 
		'***************************************************************************************************************************************************
		services.StartTransaction "popupIntakeReject"
		popupIntakeReject=False	'init return value
		Dim oReject,oButton,oEdit,oTable,aRejectCodes,cnt,i,iCheck,r,sActualCode
		
		'verify parameters
		If strcomp(sButtonName,"submit",1)<>0 And strcomp(sButtonName,"cancel",1)<>0 Then
			reporter.ReportEvent micFail,"popupIntakeReject","Value '" &sButtonName &"' is an invalid value for parameter 'sButtonName'. Valid values are 'submit' and 'cancel'. Abort."
			Exit Function
		End If 

		Browser(Environment("BROWSER_OBJ")).Sync
		Set oReject=Browser(Environment("BROWSER_OBJ")).WebTable("html id:=intakeReviewrejectPanelContentTable")		'the popup 'Reject Intake' webtable obj in the Intake page

		If oReject.WaitProperty("height",micgreaterthan(0),5000) Then		'the popup webtable obj exists
			reporter.ReportEvent micInfo,"popupIntakeReject","the popup 'Reject Intake' webtable obj exists."

			'check the reason code checkboxes 
			Set oTable=oReject.WebTable("html id:=intakeReviewrejectForm:intakeReviewintakeTable")
			If Not oTable.Exist(2) Then
				reporter.ReportEvent micFail,"popupIntakeReject","The reason code and checkbox table does not exist within the Reject Intake popup window. Abort."
				Exit Function
			Else
				'aExpectCodes=array("Document is illegible","Missing Date Of Service","Missing patient name","Page missing from document","Other/unassigned","No codeable documentation","Member not found in system")
				aRejectCodes=split(sRejectCodes,";")
				cnt=0	'keep track of reason code to check
				For i=0 to ubound(aRejectCodes)

					'check the code checkbox
					iCheck=0
					For r=2 to oTable.RowCount
						sActualCode=trim(oTable.GetCellData(r,2))
						If strcomp(trim(aRejectCodes(i)),sActualCode,1)=0 Then
							oTable.ChildItem(r,1,"WebCheckBox",0).Set "ON"
							reporter.ReportEvent micInfo,"Check box '" &sActualCode &"'","Checkbox was checked."
							cnt=cnt+1
							iCheck=1
							Exit For
						End If
					Next	'row
					If iCheck=0 Then
						reporter.ReportEvent micFail,"popupIntakeReject","Reason code '" &aRejectCodes(i) &"' does not exist or not a valid reason code."
						Exit For
					End If
				Next	'code to check			

				'comments field
				Set oEdit=oReject.WebEdit("html id:=intakeReviewrejectForm:intakeReviewrejectnotesValue")
				If Not oEdit.Exist(2) Then
					reporter.ReportEvent micFail,"Comment field","The Comments field does not exist  within the REject Intake popup window. Abort."
					Exit Function
				Else
					oEdit.Set sComments		'set value regardless
					reporter.ReportEvent micInfo,"Comment field","Comment '" &sComments &"' was entered into field."
				End If

				'click the button
				Select Case lcase(sButtonName)
					Case "submit" Set oButton=oReject.WebButton("html tag:=INPUT","type:=submit","name:=Submit")	'the Submit button
					Case "cancel" Set oButton=oReject.WebButton("html tag:=INPUT","type:=button","name:=Cancel")		'the Cancel button
				End Select
				
				If Not oButton.WaitProperty("disabled","0",10000) Then	
					reporter.ReportEvent micFail,"Button '" &sButtonName &"'","Button does not exist within the Reject Intake popup window. Abort."
					Exit Function
				Else
					oButton.Click
					reporter.ReportEvent micInfo,"Button '" &sButtonName &"'","Button was clicked."
				End If 

				'report 
				If cnt = ubound(aRejectCodes) + 1 Then
					reporter.ReportEvent micInfo,"popupIntakeReject",cnt &" reason codes were checked."
					popupIntakeReject=True	'return value
				Else
					reporter.ReportEvent micFail,"popupIntakeReject", "Only " &cnt &" reason code(s) out of " &ubound(aRejectCodes) + 1 &" were checked."
				End If
			End If
		Else
			reporter.ReportEvent micFail,"popupIntakeReject","the popup 'Reject Intake' webtable obj does not exist in the current page (current page = Intake page). Please click the Reject button prior to calling function."
		End If

		Set oReject=Nothing
		services.EndTransaction "popupIntakeReject"
	End Function
	
	Function NavigateToEncounterDetails (ByVal sServiceFromDate, ByVal iPosition)
	'***************************************************************************************
		'Purpose: Navigate to Encounter Details via Hovering on From Date
		'Parameter: sServiceFromDate :Service From Date to be passed as Input parameter with Format MM/DD/YYYY
		'						 iPosition : Passed Encounter Position in UI panel if it repeats multiple times
		'Returns: True/False
		'Usage Example: util.NavigateToEncounterDetails("08/23/2011", 2)		--> To Select Chart Review from the List
		'Author: Govardhan Choletti 01/16/2013
		'Modified: Hung Nguyen 4/20/13 Due to dev change adding column for +icon, red and green check icon, updated the From date link column from 1 to 2
	'***************************************************************************************
		'Variable Declaration 
		Dim sDOSFromDate
		Dim iCurrPosition, iLoop
		Dim bEncounterSection
		Dim oAppBrowser, objRegEx, oMatchMet, oEncTable, oEncNavigate
		 
		'Initialise variables
		Set oAppBrowser = Browser(Environment("BROWSER_OBJ"))
		iCurrPosition = 1
		Set objRegEx = New RegExp 
		objRegEx.Pattern  = "\d\d\/\d\d\/\d\d\d\d"
		
		'Create Collection
		Set oMatchMet = objRegEx.Execute(sServiceFromDate)
		NavigateToEncounterDetails = False
	   'Parameter Validation
		If sServiceFromDate = "" OR IsEmpty(sServiceFromDate) Then
			Reporter.ReportEvent micFail, "NavigateToEncounterDetails --> Service From Date", "Parameter : '"& sServiceFromDate &"' cann't be left as blank, NOT as Expected"
		ElseIf Len(sServiceFromDate) <> 10 Or oMatchMet.Count = 0 Then
			Reporter.ReportEvent micFail, "NavigateToEncounterDetails --> Service From Date", "Parameter : '"& sServiceFromDate &"' should be in format MM/DD/YYYY, Which is NOT as Expected"
		Else
			If iPosition = "" OR IsEmpty(iPosition) Then
				iPosition = 1
			End If

			If IsNumeric(iPosition) Then
				'From WebTable Object to get All Encounter Details
				Set oEncTable = Description.Create()
				oEncTable("MicClass").Value = "WebTable"
				oEncTable("html id").Value = "(.*ChartEnc(PG11|)Form:.*[E|e]ncTable|researchEncDetForm:researchEncTable)"
				oEncTable("html id").RegularExpression = True
				Set oEncNavigate=Browser(oAppBrowser).WebTable(oEncTable)

				'Verify WebTable Exist 
				If oEncNavigate.Exist(5) And oEncNavigate.RowCount >=2 Then
					bEncounterSection = False
					For iLoop = 2 to oEncNavigate.RowCount Step 1
						sDOSFromDate = oEncNavigate.GetCellData(iLoop, 2)		'Hn changed col1=2	

						'Get the Current Service From Date and verify, If available Navigate to Encounter detail Screen
						If Instr(1, sDOSFromDate, sServiceFromDate, 1) > 0 Then
							If iCurrPosition = iPosition Then
								oEncNavigate.ChildItem(iLoop,2,"WebElement",1).FireEvent "onmouseover"	'Hn 4/20/13 change col1=2
							
								'Select Encounter Detail option from popup window to navigate to the Research tab
								If util.popupMenuItemSelect(oEncNavigate, iLoop, 2,"Review Encounter") Then 	'Hn changed col1=2
									If strcomp(util.tabSubHeaderStatus("Encounters"),"active",1) =0  Then
										Reporter.ReportEvent micInfo,"NavigateToEncounterDetails --> Navigate 'Encounter Detail' option from popup window","The option was selected and subtab 'Encounter' is active on screen, as Expected"
										bEncounterSection = True
										Exit For
									Else
										Reporter.ReportEvent micFail,"NavigateToEncounterDetails -->Navigate 'Encounter Detail' option from popup window","The option was selected but the expected subtab 'Encounter' is not active. Not as Expected"
									End If		
								Else
									Reporter.ReportEvent micFail,"NavigateToEncounterDetails --> Select 'Encounter Detail' option in the popup window","Function call to select the option returned fail."
								End If
							Else
								iCurrPosition = iCurrPosition + 1
							End If
						Else
							' Do Nothing Go for Other Encounter
						End If
					Next

					If bEncounterSection Then
						Reporter.ReportEvent micPass,"NavigateToEncounterDetails --> Encounter Navigation", "Succesfully navigated by hovering on From Service Date : '"& sServiceFromDate &"', was found at position '"& iPosition &"' as Expected"
						NavigateToEncounterDetails = True
					Else
						Reporter.ReportEvent micFail,"NavigateToEncounterDetails --> Encounter Navigation", "Unable to navigate by hovering on From Service Date : '"& sServiceFromDate &"', and at position '"& iPosition &"', NOT as Expected"
					End If
				Else
					Reporter.ReportEvent micFail,"NavigateToEncounterDetails --> WebTable HTML ID","WebTable with HTML Property - '"& oEncTable("html id").Value &"' was not Found, NOT as Expected"
				End If
			Else
				Reporter.ReportEvent micFail, "NavigateToEncounterDetails --> Position", "Parameter : '"& iPosition &"' should be a Non Zero Number, Which is NOT as Expected"
			End If
		End If

		'Free Variables
		Set oAppBrowser = Nothing
		Set objRegEx = Nothing
		Set oMatchMet = Nothing
		Set oEncTable = Nothing
		Set oEncNavigate = Nothing
	End Function
	
	Function popupIntakeRotate(sRotatePages,sRotateDirection,sButtonName)
	   '***************************************************************************************************************************************************
		'Purpose: ChartSync > Intake page. Rotate the chart image number(s) to a direction specified
		'                   The popup window contains objects: edit field, rotate direction drop-down list, and 2 buttons: Ok and Cancel
		'Requires: The popup window 'Rotate Pages' must be present prior to calling this function - click the Rotate button first
		'Parameters: sRotatePages = STRING - the page number(s) to rotate. For example: 1 or 1,2 or 1-3.
		'                                                          or an EMPTY string for an error message returns to be verified.
		'                         sRotateDirection = STRING - direction to rotate. Valid values are: Left 90, Right 90, 180
		'                                                         or an EMPTY string for the default value 'Left 90'
		'                        sButtonName = the button name to click. Valid button names are: Ok and Cancel (required)
		'Returns: True/False
		'NOTE: The function does not return any error message if one exists. 
		'              An example of triggering an error message is just clicking the Ok button w/o enter any page number Or enter an invalid page number or value
		'              You then need to capture the expected error messages after the function is executed.
		'
		'Calls: None
		'Usage: oBrowser.Image("file name:=rotate.gif").Click 		'click the Rotate image/button
		'               popupIntakeRotate("1","Left 90","Ok") 'call to rotate image page 1 to the left 90 degree
		'  OR     popupIntakeRotate("1,2","Right 90","Ok") 'call to rotate image pages 1 and 2 to the right 90 degree
		' OR       popupIntakeRotate("1-3","180","Ok") 'call to rotate image pages from 1 to 3 to the right 90 degree
		'  OR
		'               Call popupRotate("","","Ok") 'call to just click Ok w/o entering a page number then check for error message
		'               if oBrowser.WebElement("html id:=intakeReviewnoChartMsg").Exist(5) Then
		'                      sErrMsg=oBrowser.WebElement("html id:=intakeReviewnoChartMsg").GetROProperty("innertext")	'retrieve error mesg
		'                      reporter.reportevent micPass, "expected error message exists '" &sErrMsg &"'",""
		'                else 
		'                          'expected error message does not exist
		'                end if 
		'Created by: Hung Nguyen 3/01/13
		'Modified: 
		'***************************************************************************************************************************************************
		services.StartTransaction "popupIntakeRotate"
		popupIntakeRotate=False	'init return value
		Dim oAppBrowser,oRotate,oList,aAllitems,sItem,iSelect,oButton
		
		'verify parameters
		If strcomp(sButtonName,"ok",1)<>0 And strcomp(sButtonName,"cancel",1)<>0 Then
			reporter.ReportEvent micFail,"popupIntakeRotate","Value '" &sButtonName &"' is an invalid value for parameter 'sButtonName'. Valid values are 'ok' and 'cancel'. Abort."
			Exit Function
		End If 

		If sRotateDirection<>"" Then
			If instr(1,"Left 90;Right 90;180",sRotateDirection,1) =0 Then
				reporter.ReportEvent micFail,"popupIntakeRotate","Value '" &sRotateDirection &"' is an invalid value for parameter 'sRotateDirection'. Valid values are 'Left 90', 'Right 90', and '180'. Abort."
				Exit Function
			End If 
		End If 

		Set oAppBrowser=Browser(Environment("BROWSER_OBJ"))
		oAppBrowser.Sync
		Set oRotate=oAppBrowser.WebTable("html id:=intakeReviewrotatePanelContentTable")		'the popup 'Rotate Pages' webtable obj in the Intake page

		'click Rotate image/button if the popup window does not already open
		If Not oRotate.exist(2) Then
			reporter.ReportEvent micFail,"popupIntakeRotate","The popup window 'Rotate Page' does not exist. Nothing to do."
			ExitAction
		ElseIf oRotate.GetROProperty("height")=0 Then
			oAppBrowser.Image("file name:=rotate.gif").Click
			oAppBrowser.Sync
		End If
		
		If oRotate.WaitProperty("height",micgreaterthan(0),5000) Then		'the popup webtable obj exists
			reporter.ReportEvent micInfo,"popupIntakeRotate","the popup 'Rotate Pages' webtable obj exists."

			'enter page num
			If sRotatePages<>"" Then
				If oAppBrowser.WebEdit("html id:=intakeReviewrotateForm:intakeReviewrotatePg").Exist(5) Then
					oAppBrowser.WebEdit("html id:=intakeReviewrotateForm:intakeReviewrotatePg").WaitProperty "disabled",0,5000		'5 secs for obj enables
					oAppBrowser.WebEdit("html id:=intakeReviewrotateForm:intakeReviewrotatePg").Set sRotatePages
					reporter.ReportEvent micInfo,"popupIntakeRotate","Enter page number(s) '" &sRotatePages &"' into field."
				Else
					reporter.ReportEvent micFail,"popupIntakeRotate","The rotate page text field does not exist. Unable to enter page number. Abort."
					Exit Function
				End If 	
			End If 

			'select rotate direction
			If sRotateDirection<>"" Then
				Set oList=oAppBrowser.WebList("html id:=intakeReviewrotateForm:intakeReviewrotateDegree")  'the Rotation direction drop-down obj
				If oList.Exist(5) Then
					aAllitems=split(oList.GetROProperty("all items"),";")

					iSelect=0
					For each sItem in aAllitems
						If strcomp(trim(sItem),sRotateDirection,1) = 0 Then
							oList.Select sItem
							reporter.ReportEvent micInfo,"popupIntakeRotate","Rotate direction '" &sItem &"' in drop-down list was selected."
							iSelect=1
							Exit For
						End If
					Next	'item
					If iSelect=0 Then
						reporter.ReportEvent micFail,"popupIntakeRotate","Rotate direction '" &sRotateDirection &"' is not a valid item or does not exist. Abort."
						Exit Function
					End If
				Else
					reporter.ReportEvent micFail,"popupIntakeRotate","Rotate direction drop-down list does not exist. Unable to select an option. Abort."
					Exit Function
				End If 				
			End If 

			'click the button
			Select Case lcase(sButtonName)
				Case "ok" Set oButton=oRotate.WebButton("html tag:=INPUT","type:=submit","name:=Ok")	'the Ok button
				Case "cancel" Set oButton=oRotate.WebButton("html tag:=INPUT","type:=button","name:=Cancel")		'the Cancel button
			End Select
			
			If Not oButton.Exist(5) And Not oButton.WaitProperty("disabled","0",5000) Then	'does not exist or not enabled
				reporter.ReportEvent micFail,"Button '" &sButtonName &"'","Button does not exist or not enabled. Abort."
				Exit Function
			Else
				oButton.Click
				oAppBrowser.Sync
				reporter.ReportEvent micInfo,"Button '" &sButtonName &"'","Button was clicked."
				popupIntakeRotate=True	'return value


				'clean up - close the popup window if there were errors
				If lcase(sButtonName)="cancel" And oRotate.GetROProperty("height") <> 0 Then 
					oRotate.WebButton("html tag:=INPUT","type:=button","name:=Cancel").Click 
				End If
			End If 	
		Else
			reporter.ReportEvent micFail,"popupIntakeRotate","the popup 'Rotate Pages' webtable obj does not exist in the current page (current page = Intake page). Please click the Rotate image/button prior to calling function."
		End If

		Set oRotate=Nothing
		Set oAppBrowser=Nothing
		services.EndTransaction "popupIntakeRotate"
	End Function	
End Class 

	''***********Class instantiation************
Dim util
Set util= New utilFunctions
''******************************************