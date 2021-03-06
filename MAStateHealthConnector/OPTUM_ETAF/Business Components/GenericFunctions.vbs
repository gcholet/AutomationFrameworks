'##############################################################################################################
'Description      : To set an Object to the Browser and Page
'Input Value      : strProperty for the Browser and Page
'Author           : 
'Create Date      : 05/26/2015
'##############################################################################################################
'
Public gobjPath
Set ObjBrowserPage = Browser("name:=::Individual & Families::Start your appli...").page("title:=::Individual & Families::Start your appli...")

 
'##############################################################################################################
'Function Name       : EnterData
'Description      : To enter value in editbox present in the application
'Input Value      : strProperty,strVal
'Author           : Vandhana Simhadri
'Create Date      : 06/13/2015
'##############################################################################################################
Sub EnterData(strProperty, strVal, strReport)

    On Error Resume Next

    'Declaring variables
    'Dim gobjPath
    Dim objDesc, arrNameValue
    Dim strName,strValue, intCount
    
    'Set browser and page object
    'Set gobjPath = Browser("name:=.*","creationtime:=0").Page("title:=.*")

    'Initializing the variables
    Set objDesc = Description.Create()
    arrNameValue = Split(strProperty, ";") 

    'Fetching the property values for creating the description object
    For intCount = 0 to UBound(arrNameValue)
        strName = Split(arrNameValue(intCount),":=")(0)
        strValue = Split(arrNameValue(intCount),":=")(1)
        objDesc(strName).Value = strValue
    Next

    'Entering value in the text field
    If gobjPath.WebEdit(objDesc).Exist(5) Then
        gobjPath.WebEdit(objDesc).Click
        gobjPath.WebEdit(objDesc).Set strVal
       CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
				"Enter " & strReport & " is entered Successfully", "Pass"
	Else
		CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
				"Enter " & strReport & " is NOT entered", "Fail"
	End If
    
    'De-initializing the variables
    Set objDesc = Nothing

End Sub


'##############################################################################################################
'Function Name    : ClickButton
'Description      : To Click on a WebButton or Link in the application
'Input Value      : strProperty
'Author           : 
'Create Date      : 05/27/2015
'##############################################################################################################

Sub ClickButton(strProperty,strReport)

    On Error Resume Next

    	'Declaring variables
    	'Dim gobjPath
    	Dim objDesc, arrNameValue
    	Dim strName,strValue, intCount
    
    	'Set browser and page object
   	'Set gobjPath = Browser("name:=.*","creationtime:=0").Page("title:=.*")

    	'Initializing the variables
    	Set objDesc = Description.Create()
    	arrNameValue = Split(strProperty, ";") 

    	'Fetching the property values for creating the description object
    	For intCount = 0 to UBound(arrNameValue)
      		strName = Split(arrNameValue(intCount),":=")(0)
        	strValue = Split(arrNameValue(intCount),":=")(1)
        	objDesc(strName).Value = strValue
    	Next

    'Entering value in the text field
    	If gobjPath.WebButton(objDesc).Exist(5) Then
       	gobjPath.WebButton(objDesc).Click
       	gobjPath.Sync
       	CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
				"Click Button " & strReport, strReport & " is Clicked Successfully", "Pass"
	Else
		CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
				"Click Button " & strReport,  strReport & " is NOT Clicked", "Fail"
	End If
    
    'De-initializing the variables
    	Set objDesc = Nothing

End Sub

'##############################################################################################################
'Function Name       : ClickLink
'Description      : To enter value in editbox present in the application
'Input Value      : strProperty,strVal
'Author           : Vandhana Simhadri
'Create Date      : 06/13/2015
'##############################################################################################################
Sub ClickLink(strProperty)

    On Error Resume Next

    'Declaring variables
    'Dim gobjPath
    Dim objDesc, arrNameValue
    Dim strName,strValue, intCount
    
    'Set browser and page object
    'Set gobjPath = Browser("name:=.*","creationtime:=0").Page("title:=.*")

    'Initializing the variables
    Set objDesc = Description.Create()
    arrNameValue = Split(strProperty, ";") 

    'Fetching the property values for creating the description object
    For intCount = 0 to UBound(arrNameValue)
        strName = Split(arrNameValue(intCount),":=")(0)
        strValue = Split(arrNameValue(intCount),":=")(1)
        objDesc(strName).Value = strValue
    Next

    'Entering value in the text field
    If gobjPath.Link(objDesc).Exist(5) Then
        gobjPath.Link(objDesc).Click
        gobjPath.Sync
        CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
				"Click Link ", "Link with Property --> " & strProperty & " is Clicked Successfully", "Pass"
        'Reporter.ReportEvent micPass, "Click Link","Link clicked successfully"
    Else
    	CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
				"Click Link ", "Unable to click on Link with Property --> " & strProperty & " , Not as Expected", "Fail"
        'Reporter.ReportEvent micFail, "Click Link", "Link is NOT availble"
    End If
    
    'De-initializing the variables
    Set objDesc = Nothing

End Sub

'##############################################################################################################
'Function Name    : ClickElement
'Description      : To Click on a WebButton or Link in the application
'Input Value      : strProperty
'Author           : 
'Create Date      : 05/27/2015
'##############################################################################################################

Sub ClickElement(strProperty,strReport)

    On Error Resume Next

    	'Declaring variables
    	'Dim gobjPath
    	Dim objDesc, arrNameValue
    	Dim strName,strValue, intCount
    
    	'Set browser and page object
   	'Set gobjPath = Browser("name:=.*","creationtime:=0").Page("title:=.*")

    	'Initializing the variables
    	Set objDesc = Description.Create()
    	arrNameValue = Split(strProperty, ";") 

    	'Fetching the property values for creating the description object
    	For intCount = 0 to UBound(arrNameValue)
      		strName = Split(arrNameValue(intCount),":=")(0)
        	strValue = Split(arrNameValue(intCount),":=")(1)
        	objDesc(strName).Value = strValue
    	Next

    'Entering value in the text field
    	If gobjPath.WebElement(objDesc).Exist(5) Then
       	gobjPath.WebElement(objDesc).Click
       	gobjPath.Sync
       	CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
				"Click Element " & strReport, strReport & " is Clicked Successfully", "Pass"
	Else
		CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
				"Click Element " & strReport,  strReport & " is NOT Clicked", "Fail"
	End If
    
    'De-initializing the variables
    	Set objDesc = Nothing

End Sub

'##############################################################################################################
'Function Name       : GetText
'Description      : 
'Input Value      : strProperty,strVal
'Author           : Vandhana Simhadri
'Create Date      : 06/13/2015
'##############################################################################################################
Function GetText(strProperty)

    On Error Resume Next

    'Declaring variables
    'Dim gobjPath
    Dim objDesc, arrNameValue
    Dim strName,strValue, intCount
    
    'Set browser and page object
   'Set gobjPath = Browser("name:=.*","creationtime:=0").Page("title:=.*")

    'Initializing the variables
    Set objDesc = Description.Create()
    arrNameValue = Split(strProperty, ";") 

    'Fetching the property values for creating the description object
    For intCount = 0 to UBound(arrNameValue)
        strName = Split(arrNameValue(intCount),":=")(0)
        strValue = Split(arrNameValue(intCount),":=")(1)
        objDesc(strName).Value = strValue
    Next

    'Entering value in the text field
    If gobjPath.WebElement(objDesc).Exist(5) Then
        GetText = gobjPath.WebElement(objDesc).GetROProperty("outertext")
        CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
				"Get value ", "Object with Property --> " & strProperty & " is fetched Successfully an value is : "& GetText , "Pass"
        'Reporter.ReportEvent micPass, "Get value","The value has been extracted successfully"
    Else
    	CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
				"Get value ", "Object with Property --> " & strProperty & " doesn't Exist on screen" , "Fail"
        'Reporter.ReportEvent micFail, "Get value", "Web Element is NOT availble"
    End If
    
    'De-initializing the variables
    Set objDesc = Nothing

End Function


'##############################################################################################################
'Function Name    : SelectData(OLD)
'Description      : To select the data 
'Input Value      : strProperty,strVal
'Author           : 
'Create Date      : 05/27/2015
'##############################################################################################################
'
'*********BELOW SELECT DATA FUNCTION IS REPLACED********
'sub SelectData(ByVal strProperty, ByVal strVal)
'
'    If ObjBrowserPage.WebList(strProperty).Exist(2) Then
'        ObjBrowserPage.WebList(strProperty).Select strVal
'        strtemp=split(strproperty,":=")
'        
'       	CRAFT_ReportEvent Environment.Value ("strReportedEventSheet"),strtemp(1), "Data is Selected", "Pass"
'	Else
'		CRAFT_ReportEvent Environment.Value ("strReportedEventSheet"),strtemp(1), "Data is Selected", "Fail"
'	End If
'
'End sub
Sub SelectData(strProperty, strVal)

    On Error Resume Next

    'Declaring variables
    'Dim gobjPath
    Dim objDesc, arrNameValue
    Dim strName,strValue, intCount
    
    'Set browser and page object
    'Set gobjPath = Browser("name:=.*","creationtime:=0").Page("title:=.*")

    'Initializing the variables
    Set objDesc = Description.Create()
    arrNameValue = Split(strProperty, ";") 

    'Fetching the property values for creating the description object
    For intCount = 0 to UBound(arrNameValue)
        strName = Split(arrNameValue(intCount),":=")(0)
        strValue = Split(arrNameValue(intCount),":=")(1)
        objDesc("Micclass").Value = "WebList"
        objDesc(strName).Value = strValue
    Next

    'Entering value in the text field
    If gobjPath.WebList(objDesc).Exist(5) Then
        gobjPath.WebList(objDesc).Click
        gobjPath.WebList(objDesc).Select strVal
        CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
				"Select Data ", "Object with Property --> " & strProperty & " has successfully selected a value is : "& strVal , "Pass"
        'Reporter.ReportEvent micPass, "Setting Text Box To value: "& strVal,"The value has been set successfully"
    Else
    	CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
				"Select Data ", "Object with Property --> " & strProperty & " couldn't select a value : "& strVal & ",  not as expected", "Fail"
        'Reporter.ReportEvent micFail, "Setting Text Box To value: "& strVal, "Web Edit box is NOT availble"
    End If
    
    'De-initializing the variables
    Set objDesc = Nothing

End Sub

'##############################################################################################################
'Function Name       : 
'SelectRadioButton
'Description      : 
'Input Value      : strProperty,strVal
'Author           : Vandhana Simhadri
'Create Date      : 06/13/2015
'##############################################################################################################
Sub SelectRadioButton(strProperty, strVal)

    On Error Resume Next

    'Declaring variables
    'Dim gobjPath
    Dim objDesc, arrNameValue
    Dim strName,strValue, intCount
    
    'Set browser and page object
    'Set gobjPath = Browser("name:=.*","creationtime:=0").Page("title:=.*")

    'Initializing the variables
    Set objDesc = Description.Create()
    arrNameValue = Split(strProperty, ";") 

    'Fetching the property values for creating the description object
    For intCount = 0 to UBound(arrNameValue)
        strName = Split(arrNameValue(intCount),":=")(0)
        strValue = Split(arrNameValue(intCount),":=")(1)
        objDesc(strName).Value = strValue
    Next

    'Entering value in the text field
    If gobjPath.WebRadioGroup(objDesc).Exist(5) Then
        gobjPath.WebRadioGroup(objDesc).Select strVal
        CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
				"Select Radio Button ", "Object with Property --> " & strProperty & " has successfully selected a value is : "& strVal , "Pass"
        'Reporter.ReportEvent micPass, "Select Radio button","Radio button selected successfully"
    Else
    	CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
				"Select Radio Button ", "Object with Property --> " & strProperty & " couldn't select a value : "& strVal &" Not as Expected", "Fail"
        'Reporter.ReportEvent micFail, "Select Radio button", "Web Radio Gropu is NOT availble"
    End If
    
    'De-initializing the variables
    Set objDesc = Nothing

End Sub

'##############################################################################################################
'Function Name    : CheckBox
'Description      : To select or unselect the required checkbox
'Input Value      : strProperty
'Author           : 
'Create Date      : 05/27/2015
'##############################################################################################################


sub ClickCheckBox(ByVal strProperty)

     On Error Resume Next

    'Declaring variables
    'Dim gobjPath
    Dim objDesc, arrNameValue
    Dim strName,strValue, intCount
    
    'Set browser and page object
    'Set gobjPath = Browser("name:=.*","creationtime:=0").Page("title:=.*")

    'Initializing the variables
    Set objDesc = Description.Create()
    arrNameValue = Split(strProperty, ";") 

    'Fetching the property values for creating the description object
    For intCount = 0 to UBound(arrNameValue)
        strName = Split(arrNameValue(intCount),":=")(0)
        strValue = Split(arrNameValue(intCount),":=")(1)
        objDesc(strName).Value = strValue
    Next

    'Entering value in the text field
    If gobjPath.WebCheckBox(objDesc).Exist(5) Then
        gobjPath.WebCheckBox(objDesc).Set "ON"
        CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
				"Select Check Box ", "Object with Property --> " & strProperty & " has checked successfully", "Pass"
        'Reporter.ReportEvent micPass, "Select Check Box","Check Box selected successfully"
    Else
    	CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
				"Select Check Box ", "Object with Property --> " & strProperty & " couldn't checked successfully, Not as Expected", "Fail"
        'Reporter.ReportEvent micFail, "Select Check Box", "Check Box ISNOT selected successfully"
    End If
    
    'De-initializing the variables
    Set objDesc = Nothing
End sub

Sub StoreCommonData()
	Dim strStoreVariable, strCDField,  strCDHeader, strCDData
	Dim arrStoreVariable, arrCDValues
	Dim iLoop
	
	'Fetch The field Name with 'StoreData'
	strStoreVariable =  CRAFT_GetData ("IndividualApp_Portal_Data","StoreCommonData")
	arrStoreVariable = Split(strStoreVariable, "~")
	
	If UBound(arrStoreVariable) = 1 Then
		strCDField = arrStoreVariable(0)
		arrCDValues = Split(arrStoreVariable(1), ":")
		
		For iLoop = LBound(arrCDValues) To UBound(arrCDValues) Step 1
			strCDHeader = arrCDValues(iLoop)
			strCDData = CRAFT_GetData ("IndividualApp_Portal_Data", strCDHeader)			'Get the Data from the required Sheet
			Call CRAFT_PutCommonData (strCDField, strCDHeader, strCDData)
		Next
	Else
	
	End If
	
	
End Sub


Sub TINYWAIT
	
	Wait (2)
	
End Sub

Sub SHORTWAIT
	
	Wait (5)
	
End Sub

Sub  MEDWAIT
	
	Wait (10)
	
End Sub

Sub MEDLWAIT
	
	Wait(20)
	
End Sub

Sub LONGWAIT

	Wait(30)
	
End Sub

Function GetValueMid2( strVisibleText,  strValueStart,  strValueEND)

	rcValue = Len(strValueStart) +1

	intStartPostion  = INSTR(strVisibleText, strValueStart) + rcValue	

	rcEndValue = INSTR( strVisibleText, strValueEND) - intStartPostion
	
	If rcEndValue > 0 Then																																																'omanchala       03/24/2014
		rcRetValue = MID(strVisibleText, intStartPostion, rcEndValue)	
		rcRetValue = Trim(rcRetValue)
		GetValueMid2 = rcRetValue
	End If
	
End Function
