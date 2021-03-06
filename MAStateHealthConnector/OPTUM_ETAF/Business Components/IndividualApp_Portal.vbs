'###########################################################################################################################################
'Function Name			:	CreateAccount
'Description			:	To Click on the Create Account then, Register Now and then start create account procedure by giving the details.
'Input Value			:	strProperty,strVal
'Author					:	Cigniti Inc/Vandhana/RamMohan
'Create Date			:	05/27/2015
'###########################################################################################################################################

Sub CreateAccount()

    Dim strStoreVariable
    On Error Resume Next
                
        If Browser("name:=This page can’t be displayed").Page("title:=This page can’t be displayed").Exist(2)Then
            Browser("name:=This page can’t be displayed").Page("title:=This page can’t be displayed").WebButton("name:=Fix connection problems","html tag:=BUTTON").Click
            Wait(5)
            Browser("name:=This page can’t be displayed").Window("text:=Windows Network Diagnostics","regexpwndtitle:=Windows Network Diagnostics").WinButton("regexpwndtitle:=Close","text:=Close").Click    
            Wait(2)
        End If
        
        'Click on Create an Account Button
         If Browser("title:=.*Individual & Families.*").Exist(5) Then
        	'Browser("title:=.*Individual & Families.*").activate
        	Browser("title:=.*Individual & Families.*").Sync
        	
		'To Maximize the Window
		hwnd = Browser("title:=.*Individual & Families.*").Object.HWND
		Window("hwnd:=" & hwnd).Maximize	
        End If
       
        Set gobjPath = Browser("title:=.*Individual & Families.*").page("title:=.*Individual & Families.*")
        If gobjPath.Exist(15) Then
        	Browser("title:=.*Individual & Families.*").Maximize
        	ClickButton "name:=Create an Account;html tag:=INPUT","CreateAccount"
        	SHORTWAIT	
        Else
        	 CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
                        "Portal -->Login Screen", "Browser with Title - 'Individual & Families::' doesn't shown on screen, Not as Expected", "Fail"  
        End If
        'Click on the 'Register Now' Button
        Browser("name:=Optum ID.*").Sync
        Set gobjPath = Browser("title:=Optum ID.*").Page("title:=Optum ID.*")
        'Set gobjPath = Browser("title:=Optum ID - Sign-In").Page("title:=Optum ID - Sign-In")
        ClickButton "name:=Register Now;value:=Register Now","RegisterNow"
        TINYWAIT
        
        'Entering the First Name'
        Browser("title:=Optum ID.*").Sync
        Set gobjPath = Browser("name:=Optum ID - Registration").Page("title:=Optum ID - Registration")
        If gobjPath.Exist(2) Then
        
        	CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
                        "Optum Registration -->Screen", "Optum User Registration Screen is NOT displayed in Browser, as Expected", "Pass"    
            
	        FirstName = CRAFT_GetData ("IndividualApp_Portal_Data","FirstName")
	        EnterData "name:=userRegistrationId:firstName",FirstName, FirstName
	        
	        'Entering the Middle Name'
	        MiddleName = CRAFT_GetData ("IndividualApp_Portal_Data","MiddleName")
	        EnterData "name:=userRegistrationId:middleName",MiddleName, MiddleName
	                
	        'Entering the Last Name'
	        LastName = CRAFT_GetData ("IndividualApp_Portal_Data","LastName")
	        EnterData "name:=userRegistrationId:lastName",LastName, LastName
	
	        'Selecting Suffix'
	        Suffix = CRAFT_GetData ("IndividualApp_Portal_Data","Suffix")
	        EnterData "name:=userRegistrationId:suffix",Suffix, Suffix
	
	        'Entering the Year of Birth'
	        YearofBirth = CRAFT_GetData ("IndividualApp_Portal_Data","YearOfBirth")
	        EnterData "name:=userRegistrationId:yobId",YearofBirth, YearofBirth
	        TINYWAIT
	
	        'Entering the Email ID'
	        EmailID =  CRAFT_GetData ("IndividualApp_Portal_Data","EmailID")
	        EnterData "name:=userRegistrationId:email",EmailID, EmailID
	        
	        'Confirming the Email ID'
	        ConfirmEmailID = CRAFT_GetData ("IndividualApp_Portal_Data","EmailID")
	        EnterData "name:=userRegistrationId:confirmEmail",ConfirmEmailID, ConfirmEmailID
	        TINYWAIT
	                
	        'Entering the UserID'
	        UserName = CRAFT_GetData ("IndividualApp_Portal_Data","UserName")
	        EnterData "name:=userRegistrationId:userNameId",UserName,UserName
	        TINYWAIT
	        
	        'Entering Password'
	        Password = CRAFT_GetData ("IndividualApp_Portal_Data","Password1")
	        EnterData "name:=userRegistrationId:pwd",Password, Password
	        
	        'Confirming the Password'
	        ConfirmPassword = CRAFT_GetData ("IndividualApp_Portal_Data","Password1")
	        EnterData "name:=userRegistrationId:confirmPwd",ConfirmPassword, ConfirmPassword
	        
	        'Entering Mobile Phone Number'        
	        MobilePhone = CRAFT_GetData ("IndividualApp_Portal_Data","MobilePhone")
	        'EnterData "name:=userRegistrationId:mobilePhone",MobilePhone, MobilePhone
	        hwnd_Optum = gobjPath.GetROProperty("hwnd")
	        Window("hwnd:=" & cstr(hwnd_Optum)).Activate
	        gobjPath.WebEdit("name:=userRegistrationId:mobilePhone").Click
	        TINYWAIT
		 CF_sendKeys "METHOD-C", "", MobilePhone
		 TINYWAIT
	        
	        'Selecting Security Question # 1'
	        SecurityQ1 = CRAFT_GetData ("IndividualApp_Portal_Data","SecurityQ1")
	        SelectData "name:=userRegistrationId:securityQuestionOne",SecurityQ1
	        TINYWAIT
	        
	        'Security Answer # 1'
	        SecurityA1 = CRAFT_GetData ("IndividualApp_Portal_Data","SecurityA1")
	        EnterData "name:=userRegistrationId:securityAnswerOne",SecurityA1, SecurityA1
	        TINYWAIT
	                
	        'Selecting Security Question # 2'
	        SecurityQ2 = CRAFT_GetData ("IndividualApp_Portal_Data","SecurityQ2")
	        SelectData "name:=userRegistrationId:securityQuestionTwo",SecurityQ2
	        TINYWAIT
	        
	        'Security Answer # 2'
	        SecurityA2 = CRAFT_GetData ("IndividualApp_Portal_Data","SecurityA2")
	        EnterData "name:=userRegistrationId:securityAnswerTwo",SecurityA2, SecurityA2
	        TINYWAIT
	                
	        'Selecting Security Question # 3'
	        SecurityQ3 = CRAFT_GetData ("IndividualApp_Portal_Data","SecurityQ3")
	        SelectData "name:=userRegistrationId:securityQuestionThree",SecurityQ3
	        TINYWAIT
	        
	        'Security Answer # 3'
	        SecurityA3 = CRAFT_GetData ("IndividualApp_Portal_Data","SecurityA3")
	        EnterData "name:=userRegistrationId:securityAnswerThree",SecurityA3, SecurityA3
	        TINYWAIT	        
	        
	        'Checking the Terms & Conditions box'
	        ClickCheckBox"name:=userRegistrationId\:tcChkBox1"
	        TINYWAIT
	               
	        'Click on the continue button to get navigated to the ConfirmationCode page'
	        ClickButton"html id:=userRegistrationId:registerButton;name:=Continue", "ContinueButton"
	        TINYWAIT
	        Browser("title:=Optum ID.*").Sync
	        
	        'Syncing the ConfirmationCode Browser Page'
	        'Browser("name:=Optum ID - Verify Confirmation Codes").Sync
	        'Set ObjBrowserPage = Browser("name:=Optum ID - Verify Confirmation Codes").Page("title:=Optum ID - Verify Confirmation Codes")
	        ClickLink"name:=Show Confirmation Code field"
	        LONGWAIT
        
        	'Verify if the confirmation mail received in the Mail Box
        	bFetchData = False
        	iLoop = 1
        	Set objTableGuerilla = Browser("title:=.*Guerrilla.*").Page("title:=.*").WebTable("name:=Delete", "html tag:=TABLE")
        	Browser("title:=.*Guerrilla.*").Page("title:=.*").RefreshObject
        	If objTableGuerilla.Exist(10) Then
        		Do
        	 		iRowCnt = Cint(objTableGuerilla.RowCount)			'Total Rows in the Guerrilla Mailbox
        	 	
	        	 	If iRowCnt = 2 Then
	        	 		'Perform click action
	        	 		'strConfirmCode = InputBox("Enter Confirmation Code sent by OPTTUM Team:", "CONFIRMATION CODE !!")
	                		Browser("title:=.*Guerrilla.*").Page("title:=.*").WebElement("innertext:=noreply_healthid@optum.com", "html tag:=TD").Click
	                		TINYWAIT
	                		
	                		'strVisibleText = browser("brwGuerrilla").Page("pgeGuerrilla").WebElement("innertext:=  Hello Erin,Your email confirmation is almost complete. Please click on the link below to verify your email address and continue.Confirm Email Address If you prefer, you can copy and enter the confirmation code in your browser: Confirmation Code: .*", "html tag:= SPAN","visible:=True").GetROProperty("outertext")
			              'strConfirmCode = GetValueMid(strVisibleText, "Code:", "If")
			                
					Set ObjTblGuerilla = Browser("title:=.*Guerrilla.*").Page("title:=.*").WebTable("name:=WebTable", "column names:=Your Account InformationMAHealthConnector", "Index:=0")
					strMailData = ObjTblGuerilla.GetCellData(2, 1)
			             	strConfirmCode = Left(Trim(Split(strMailData, "Confirmation Code:")(1)), 10)
			               
			              'Msgbox "Confirmation Code --> "& strConfirmCode
			 		Set ObjTblGuerilla = Nothing
	                		bFetchData = True
	                	Else
	                		'Perform / Resend Confirmation code once again
	                		Set gobjPath = Browser("title:=.*Individual & Families.*").Page("title:=.*Individual & Families.*")
	                		ClickLink "html id:=verifyCodesId:resendPrimaryEmailCodeButtonId;name:=Resend;html tag:=A"
	                		LONGWAIT
	                		
	                		objTableGuerilla.RefreshObject
	                		iLoop = iLoop + 1
	        	 	End If
        	 	Loop While (Not(bFetchData) AND (iLoop <= 3))
        	 Else
        	 	CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
                        "Guerrilla Screen", "Unable to view Guerilla Mail Box, Check with Object property !!", "Fail"
        	 End If
                
                Call CRAFT_PutData ("IndividualApp_Portal_Data", "ConfirmationCode", strConfirmCode)
'                Browser("brwOptum").Page("pgeOptum").WebEdit("edtPrimaryEmailCode").Set CRAFT_GetData ("IndividualApp_Portal_Data","ConfirmationCode")
'                Wait(2)

        'close gorilla browser
        'browser("brwGuerrilla").Close
        
	        'Entering the Confirmation Code for confirmation'
	        Set gobjPath = Browser("title:=Optum ID.*").Page("title:=Optum ID.*")
	        ConfirmationCode = CRAFT_GetData ("IndividualApp_Portal_Data","ConfirmationCode")
	        EnterData "name:=verifyCodesId:primaryEmailCodeTextId",ConfirmationCode,ConfirmationCode
	        
	        'Clicking on the confirm button to be navigated to the Next Page to Continue
	        ClickButton "name:=Confirm;html tag:=INPUT","ContinueButton"
	        TINYWAIT
	        Browser("title:=Optum ID.*").Sync
	        
	        'Clicking on the Continue button for the account confirmation
	        ClickButton "html id:=congratsForm:submitButton;name:=Continue;html tag:=INPUT","ContinueButton"
	        TINYWAIT
	        Browser("title:=Optum ID.*").Sync
	        
	        'Clicking on the Continue button to be navigated to the Create Profile Page
	        ClickButton "html id:=.*agreeButtonId;name:=Continue;html tag:=INPUT","ContinueButton"
	        SHORTWAIT
        Else
            CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
                        "Optum Registration -->Screen", "Optum User Registration Screen is NOT displayed in Browser, Not as Expected", "Fail"    
        End If

End Sub

'###########################################################################################################################################
'Function Name			:	CreateProfile
'Description			:	Creating the profile by giving all the required inputs
'Input Value			:	Values from Excel
'Author					:	Cigniti Inc/Vandhana/RamMohan
'Create Date			:	05/27/2015
'###########################################################################################################################################

Sub CreateProfile()

	On Error Resume Next
	
	'Syncing the browser and the create profile page
	Set gobjPath = Browser("title:=.*Individual & Families.*").Page("title:=.*Individual & Families.*")
	Browser("title:=.*Individual & Families.*").sync
	TINYWAIT
		
	'Entering the Middle Name
	MiddleName = CRAFT_GetData ("IndividualApp_Portal_Data","MiddleName")	
	EnterData "html id:=userProfile.middleName;html tag:=INPUT",MiddleName, MiddleName
		
	'Selecting the Suffix from the drop down weblist
	Suffix = CRAFT_GetData ("IndividualApp_Portal_Data","Suffix")
	SelectData "html id:=userProfile.suffix;html tag:=SELECT",Suffix
		
	'Entering Date of Birth
	DOB = CRAFT_GetData ("IndividualApp_Portal_Data","DOB")
	EnterData "name:=userProfile.dob;html id:=dob", DOB, DOB
	
'	'Entering data into SSN field 1
'	SSN1 = CRAFT_GetData ("IndividualApp_Portal_Data","SSN1")
'	EnterData "name:=userProfile.ssn_0;html id:=userProfile.ssn_0;html tag:= INPUT",SSN1,SSN1
'	
'	'Entering data into SSN field 2
'	SSN2 = CRAFT_GetData ("IndividualApp_Portal_Data","SSN2")
'	EnterData "name:=userProfile.ssn_1;html id:=userProfile.ssn_1;html tag:=INPUT",SSN2,SSN2
'	
'	'Entering data into SSN field 3
'	SSN3 = CRAFT_GetData ("IndividualApp_Portal_Data","SSN3")
'	EnterData "name:=userProfile.ssn_2;html id:=userProfile.ssn_2;html tag:=INPUT",SSN3,SSN3
	
	'Entering data into Home Address1 field 
	HomeAddress1 = CRAFT_GetData ("IndividualApp_Portal_Data","HomeAddress1")
	EnterData "name:=userProfile.contactInfo.primaryAddress.streetAddress1;html tag:=INPUT",HomeAddress1,HomeAddress1
	
	'Entering data into Home Address2 field 
	HomeAddress2 = CRAFT_GetData ("IndividualApp_Portal_Data","HomeAddress2")
	EnterData "name:=userProfile.contactInfo.primaryAddress.streetAddress2;html tag:=INPUT",HomeAddress2,HomeAddress2
	
	TINYWAIT
	'Entering data into HomeCity field
	HomeCity = CRAFT_GetData ("IndividualApp_Portal_Data","HomeCity")
	EnterData "name:=userProfile.contactInfo.primaryAddress.city;html id:=userProfile.contactInfo.primaryAddress.city",HomeCity, HomeCity
	
	'Entering data into HomeZip field
	HomeZip = Right("000" & CRAFT_GetData ("IndividualApp_Portal_Data","HomeZip"), 5)
	'EnterData "name:=userProfile.contactInfo.primaryAddress.zip;html id:=userProfile.contactInfo.primaryAddress.zip;html tag:=INPUT",HomeZip, HomeZip
	gobjPath.WebEdit("html id:=userProfile.contactInfo.primaryAddress.zip", "html tag:=INPUT").Click
	TINYWAIT
	CF_sendKeys "METHOD-B", "", HomeZip
	TINYWAIT
	
	'Selecting the Home Count from the selectlist
	HomeCounty = CRAFT_GetData ("IndividualApp_Portal_Data","HomeCounty")
	SelectData "html id:=userProfile.contactInfo.primaryAddress.county;html tag:=SELECT",HomeCounty
	TINYWAIT
	
	'Checking the Mailing Address same as the Primary Address
	ClickCheckBox "name:=userProfile.contactInfo.secondaryAddressAsPrimary;html id:=mailing_same_as_resident"
	TINYWAIT
	
	'Entering the Primary Phone Number	
	PrimaryPhone = Trim(CRAFT_GetData ("IndividualApp_Portal_Data","PrimaryPhone"))
	'cint (PrimaryPhone)
	'EnterData "name:=mobilePhonePC_0;html id:=mobilePhonePC_0", PrimaryPhone, PrimaryPhone
	
'	Set myDeviceReplay = CreateObject("Mercury.DeviceReplay")
'	gobjPath.WebEdit("html id:=mobilePhonePC_0").Click
'	myDeviceReplay.PressKey 28                            'here 28 means it will do a key stroke 
'	myDeviceReplay.SendString PrimaryPhone
	gobjPath.WebEdit("html id:=mobilePhonePC_0").Click
	TINYWAIT
	CF_sendKeys "METHOD-B", "", PrimaryPhone
	TINYWAIT
	
	TINYWAIT
	'Entering the extension number
	PrimaryExt = CRAFT_GetData ("IndividualApp_Portal_Data","PrimaryExt")
	EnterData "name:=mobilePhonePC_1;html tag:=INPUT", PrimaryExt, PrimaryExt
	
	TINYWAIT
	'Checking the terms and conditions checkbox
	ClickCheckBox "name:=userProfile.checkTermsService;html id:=check_terms_services"
	
	'Clicking on the Create Profile Button
	ClickButton "html id:=registerSubmit;name:=Create Profile", "CreateProfile"
	
End Sub

'###########################################################################################################################################
'Function Name			:	GetValueMid
'Description			:	To extract the mid value of the confirmation code
'Input Value			:	None
'Author					:	Cigniti Inc/Vandhana/RamMohan
'Create Date			:	05/27/2015
'###########################################################################################################################################

 Function GetValueMid( strVisibleText,  strValue,  strValueEND)
 
 	On Error Resume Next
 

	intStartPosition = 1

	rcValue = Len(strValue) +1

	intFoundPosition  = INSTR(intStartPosition, strVisibleText, strValue)
	
	If intFoundPosition <> 0 Then
		intFinalPostion = intFoundPosition
	End If
	
	intStartPosition  = intFinalPostion + 1		

	intFinalPostion = intFinalPostion + rcValue
	rcEndValue = INSTR(intFinalPostion, strVisibleText, strValueEND)
	rcEndValue = (rcEndValue - intFinalPostion)
	If rcEndValue > 0 Then																																																'omanchala       03/24/2014
		rcRetValue = MID(strVisibleText, intFinalPostion, rcEndValue)	
		rcRetValue = Trim(rcRetValue)
		Reporter.ReportEvent micDone, "Value Searching for " & strValue & ": Value Found >>>" & rcRetValue & "<<<", ""
		GetValueMid = rcRetValue
	End If
    
End Function

'###########################################################################################################################################
'Function Name			:	GetValueMid2
'Description			:	Another method to extract the confirmation code 
'Input Value			:	None
'Author					:	Cigniti Inc/Vandhana/RamMohan
'Create Date			:	05/27/2015
'###########################################################################################################################################

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

'###########################################################################################################################################
'Function Name			:	IdentityVerification
'Description			:	Validating the identity verification
'Input Value			:	None
'Author					:	Cigniti Inc/Vandhana/RamMohan
'Create Date			:	05/27/2015
'###########################################################################################################################################

Sub IDProofing_Verification()

	On Error Resume Next
    	Set gobjPath = Browser("title:=.*Individual & Families.*").Page("title:=.*Individual & Families.*")
    	Browser("title:=.*Individual & Families.*").sync
    
    	ClickButton    "name:=Save and Continue;html id:=nextPage", SaveandContinue
    	Browser("title:=.*Individual & Families.*").sync
    	TINYWAIT
    
   	Identity_QueAnswer1 = (CRAFT_GetData ("IndividualApp_Portal_Data","Identity_QueAnswer1"))
    	SelectRadioButton "name:=question\[1\]\.selectedAnswer;html tag:=INPUT;visible:=True", Identity_QueAnswer1
        
    	Identity_QueAnswer2 = (CRAFT_GetData ("IndividualApp_Portal_Data","Identity_QueAnswer2"))
    	SelectRadioButton "name:=question\[2\]\.selectedAnswer;html tag:=INPUT;visible:=True", Identity_QueAnswer2
        
    	Identity_QueAnswer3 = (CRAFT_GetData ("IndividualApp_Portal_Data","Identity_QueAnswer3"))
   	SelectRadioButton "name:=question\[3\]\.selectedAnswer;html tag:=INPUT;visible:=True",Identity_QueAnswer3
        
    	Identity_QueAnswer4 = (CRAFT_GetData ("IndividualApp_Portal_Data","Identity_QueAnswer4"))
    	SelectRadioButton "name:=question\[4\]\.selectedAnswer;html tag:=INPUT;visible:=True", Identity_QueAnswer4
    	
    	
    	   		
'    	If gobjPath.WebRadioGroup("name:=question\[5\].selectedAnswer").Exist Then
'    	   	
'    	Identity_QueAnswer5 = (CRAFT_GetData ("IndividualApp_Portal_Data","Identity_QueAnswer5"))
'    	SelectRadioButton "name:=question\[5\].selectedAnswer;html tag:=INPUT", Identity_QueAnswer5
'    	
'        End If
    	ClickButton "name:=Save and Continue;html id:=nextPage","Save and Continue"
    	SHORTWAIT
    	Browser("title:=.*Individual & Families.*").sync
        
End Sub

'###########################################################################################################################################
'Function Name			:	EligibilityApplication
'Description			:	Intiating to start filling the application with the required details
'Input Value			:	None
'Author					:	Cigniti Inc/Vandhana/RamMohan
'Create Date			:	05/27/2015
'###########################################################################################################################################
Sub EligibilityApplication()

	On Error Resume Next
	Set gobjPath = Browser(".*Individual & Families.*").Page("title:=.*Individual & Families.*")
    	Browser("title:=.*Individual & Families.*").sync

	With Browser("brwStateHealthConnector").page("pgeEligibilityApplication")
		'Verify Page "Eligibility Application"
		Set Obj = .WebElement("innertext:=Eligibility Application", "index:=0")
		If Obj.Exist(5) Then
			
			'Click on START APPLICATION
			.WebElement("elmStartApplication").Click
			Wait(1)
		Else
			CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"), "Sub --> HC_EligibilityApplication", "Page 'Eligibility Application' doesn't shown on screen, Not as Expected", "Fail"
		End If
	End With
End Sub

'###########################################################################################################################################
'Function Name			:	StartYourApplication
'Description			:	Continue with the initiation of application
'Input Value			:	None
'Author					:	Cigniti Inc/Vandhana/RamMohan
'Create Date			:	05/27/2015
'###########################################################################################################################################

Sub StartApplication
    	On Error Resume Next
	
		Set gobjPath = Browser("title:=.*Individual & Families.*").Page("title:=.*Individual & Families.*")
		Browser("title:=.*Individual & Families.*").sync
	
    	'ClickElement "html id:=CREATE_;innertext:=START APPLICATION;html tag:=A","Eligibility Application --> START APPLICATION"
    	ClickButton "name:=Create Application;html id:=CREATE__2015", "Eligibility Application --> CREATE APPLICATION"
    	Browser("title:=.*Individual & Families.*").sync
    
    	'Start Your Application: Begin Process
    	ClickCheckBox "name:=checkPrivacyTermsService;html id:=checkPrivacyTermsService"  
		TINYWAIT    	
    	
    	ClickButton "name:=Save and Continue;html id:=nextPage", "Begin Process --> Save and Continue"
    	SHORTWAIT
    	Browser("title:=.*Individual & Families.*").sync
    
    	ClickButton "name:=Continue;html id:=nextPage", "Begin Process --> Continue"
    	SHORTWAIT
    	Browser("title:=.*Individual & Families.*").sync
    
End Sub

'###########################################################################################################################################
'Function Name			:	EditApplication
'Description			:	To click on the edit application link to proceed filling the application details
'Input Value			:	None
'Author					:	Cigniti Inc/Vandhana/RamMohan
'Create Date			:	05/27/2015
'###########################################################################################################################################

Sub EditApplication()
    	On Error Resume Next
	
		Set gobjPath = Browser("title:=.*Individual & Families.*").Page("title:=.*Individual & Families.*")
		Browser("title:=.*Individual & Families.*").sync
		SHORTWAIT
		
    	ClickElement "html id:=EDIT-IN-PROGRESS.*;innertext:=EDIT ;html tag:=A", "Eligibility Application --> EDIT APPLICATION"
    	SHORTWAIT
    	Browser("title:=.*Individual & Families.*").sync
End Sub

'###########################################################################################################################################
'Function Name			:	HouseHoldContactInfo
'Description			:	GIving the details of the applicants to apply for...
'Input Value			:	Values gievn from excel
'Author					:	Cigniti Inc/Vandhana/RamMohan
'Create Date			:	05/27/2015
'###########################################################################################################################################

Sub HouseHoldContactInfo()

	On Error Resume Next
	
	Set gobjPath = Browser("title:=.*Individual & Families.*").Page("title:=.*Individual & Families.*")
	Browser("title:=.*Individual & Families.*").sync
	
	If gobjPath.Exist(10) Then
	
		'CheckBox for Household Contact Info
		'ClickCheckBox "html id:=eligibilityMember[0].checkAccountHolder;html tag:=INPUT"
		'ClickElement "class:=checkbox;innertext:= Check here if you are the account holder.*;html tag:=LABEL", "House Hold Contact Info --> CheckBox"
		
		strHouseHoldFirstName = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant1_FirstName")
		EnterData "html id:=eligibilityMember0.name.firstName", strHouseHoldFirstName, "HouseHold First Name"

		strHouseHoldMidName = (CRAFT_GetData ("IndividualApp_Portal_Data","Applicant1_MiddleName"))
		EnterData "html id:=eligibilityMember0.name.middleName", strHouseHoldMidName, "HouseHold Middle Name"

		strHouseHoldLastName = (CRAFT_GetData ("IndividualApp_Portal_Data","Applicant1_LastName"))
		EnterData "html id:=eligibilityMember0.name.lastName", strHouseHoldLastName, "HouseHold Last Name"

		'strHouseHoldSuffix = (CRAFT_GetData ("IndividualApp_Portal_Data","Suffix"))		'Yet to update....
		'SelectData "name:=eligibilityMember\[0\].name.suffix;innertext:=SuffixJr.Sr.IIIIV", strHouseHoldSuffix

		'Entering Date of Birth
		strHouseHoldDOB = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant1_DOB")
		EnterData "html id:=eligibilityMember0.dateOfBirth", strHouseHoldDOB, "HouseHold DOB"
		
		'Entering data into Home Address1 field 
		strHouseHoldAddress1 = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant1_HomeAddress1")
		EnterData "html id:=eligibilityMember\[0\].contactInfo.primaryAddress.streetAddress1",strHouseHoldAddress1,"House Hold Address - 1"
	
		'Entering data into Home Address2 field 
		strHouseHoldAddress2 = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant1_HomeAddress2")
		EnterData "html id:=eligibilityMember\[0\].contactInfo.primaryAddress.streetAddress2",strHouseHoldAddress2,"House Hold Address - 2"
	
		TINYWAIT
		'Entering data into HomeCity field
		strHouseHoldCity = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant1_HomeCity")
		EnterData "html id:=eligibilityMember\[0\].contactInfo.primaryAddress.city", strHouseHoldCity, "House Hold City"
	
		'Entering data into HomeZip field
		strHouseHoldZip = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant1_HomeZip")
		'EnterData "name:=userProfile.contactInfo.primaryAddress.zip;html id:=userProfile.contactInfo.primaryAddress.zip;html tag:=INPUT",HomeZip, HomeZip
		gobjPath.WebEdit("html id:=eligibilityMember\[0\].contactInfo.primaryAddress.zip").Click
		TINYWAIT
		CF_sendKeys "METHOD-B", "", strHouseHoldZip
		TINYWAIT
	
		'Selecting the Home Count from the selectlist
		strHouseHoldCounty = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant1_HomeCounty")
		SelectData "html id:=eligibilityMember\[0\].contactInfo.primaryAddress.county",strHouseHoldCounty
		TINYWAIT
	
		'Checking the Mailing Address same as the Contact Mail Address
		ClickCheckBox "name:=eligibilityMember\[0\].contactInfo.secondaryAddressAsPrimary;html id:=mailing_same_as_resident"
		TINYWAIT
	
		'Entering the Primary Phone Number	
		strHouseHoldPrimaryPhone = Trim(CRAFT_GetData ("IndividualApp_Portal_Data","Applicant1_PrimaryPhone"))
		'cint (PrimaryPhone)
		'EnterData "name:=mobilePhonePC_0;html id:=mobilePhonePC_0", PrimaryPhone, PrimaryPhone
		
'		Set myDeviceReplay = CreateObject("Mercury.DeviceReplay")
'		gobjPath.WebEdit("html id:=mobilePhonePC_0").Click
'		myDeviceReplay.PressKey 28                            'here 28 means it will do a key stroke 
'		myDeviceReplay.SendString PrimaryPhone
		gobjPath.WebEdit("html id:=eligibilityMember0.contactInfo.primaryPhoneNumber_0").Click
		TINYWAIT
		CF_sendKeys "METHOD-B", "", strHouseHoldPrimaryPhone
		TINYWAIT
	
		'Entering the extension number
		strHouseHoldPrimaryExt = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant1_PrimaryPhoneExt")
		EnterData "html id:=eligibilityMember0.contactInfo.primaryPhoneNumber_1", strHouseHoldPrimaryExt, "House Hold Primary Phone Ext"
		
		'Click Save and Continue
		ClickButton "name:=Save and Continue","Continue"
		SHORTWAIT
		Browser("title:=.*Individual & Families.*").sync
		
		CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
			"Head of Household Contact Information", "'HouseHold Contact Information' Screen is displayed in Browser, as Expected", "Pass"	
	Else
		CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
			"Head of Household Contact Information", "'Household Contact Information' Screen is not displayed in Browser, Not as Expected", "Fail"	
	End If	
		
End Sub

'###########################################################################################################################################
'Function Name			:	SomeOneHelp
'Description			:	confirming on, if any help is taken in filling the application
'Input Value			:	None
'Author					:	Cigniti Inc
'Create Date			:	05/27/2015
'###########################################################################################################################################

Sub SomeOneHelp()

	On Error Resume Next
	
	Set gobjPath = Browser("title:=.*Individual & Families.*").Page("title:=.*Individual & Families.*")
	Browser("title:=.*Individual & Families.*").sync
	
	If gobjPath.Exist(2) Then
	
		'Select Whether Getting Help or Not
		EnrollmentAssitance = CRAFT_GetData ("IndividualApp_Portal_Data","EnrollmentAssitance")
	    	SelectRadioButton "name:=haveRepresentative;html tag:=INPUT", EnrollmentAssitance
		
		'Click Save and Continue
		ClickButton "name:=Save and Continue", "Enrollment Assister --> Save and Continue"
		SHORTWAIT
		Browser("title:=.*Individual & Families.*").sync		
		
		CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
			"Is someone helping you?", "Is someone helping you? Screen is displayed in Browser, as Expected", "Pass"	
	Else
		CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
			"Is someone helping you?", "Is someone helping you? Screen is not displayed in Browser, NOT as Expected", "Fail"	
	End If	
End Sub

'###########################################################################################################################################
'Function Name			:	HealthCoverageCosts
'Description			:	Continuing to the next pages with the continue buttons
'Input Value			:	None
'Author					:	Cigniti Inc/Vandhana/RamMohan
'Create Date			:	06/15/2015
'###########################################################################################################################################

Sub HealthCoverageCosts()

	On Error Resume Next
	
	Set gobjPath = Browser("title:=.*Individual & Families.*").Page("title:=.*Individual & Families.*")
	Browser("title:=.*Individual & Families.*").sync
	
	If gobjPath.Exist(2) Then
	
		'Select Who needs Insurance
		CoverageNeeded = CRAFT_GetData ("IndividualApp_Portal_Data","CoverageNeeded")
	    	SelectRadioButton "name:=applyingFor", CoverageNeeded
		
		'Select Who needs Insurance
		HelpNeeded = CRAFT_GetData ("IndividualApp_Portal_Data","HelpNeeded")
	    	SelectRadioButton "name:=get_financial_assistance", HelpNeeded
		
		'Click Save and Continue
		ClickButton "name:=Save and Continue", SaveAndContinue
		SHORTWAIT
		Browser("title:=.*Individual & Families.*").sync
		
		CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
			"Do you want help paying for health coverage costs?", "Do you want help paying for health coverage costs? Screen is displayed in Browser, as Expected", "Pass"	
	Else
		CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
			"Do you want help paying for health coverage costs?", "Do you want help paying for health coverage costs? Screen is not displayed in Browser, as Expected", "Fail"	
	End If
End Sub

'###########################################################################################################################################
'Function Name			:	UpdateMemberCount
'Description			:	Member Count to be Incremented/Decremented
'Input Value			:	None
'Author					:	Cigniti Inc/Vandhana/RamMohan
'Create Date			:	06/15/2015
'###########################################################################################################################################

Sub UpdateMemberCount()

	On Error Resume Next
	
	Set gobjPath = Browser("title:=.*Individual & Families.*").page("title:=.*Individual & Families.*")
	Browser("title:=.*Individual & Families.*").sync
	SHORTWAIT
	
	'Get the Member Count from DataSheet
	iMemberCountNeeded = Cint(CRAFT_GetData ("IndividualApp_Portal_Data","MemberCount"))
	
	'Get the Member Count from the Portal
	If gobjPath.WebElement("html id:=memberCount").Exist(5) Then
		iMemberCountUI = Cint(Left(gobjPath.WebElement("html id:=memberCount").GetROProperty("innertext"), 1))
		CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
				"Applying for Health Insurance ?", "Total Members shown on portal is = "& iMemberCountUI , "Pass"	
		
		'Increment / Decrement the Member count based on Input Needed
		If iMemberCountNeeded < iMemberCountUI Then
			For iLoop = iMemberCountNeeded To iMemberCountUI - 1 Step 1
				'Call Click Function those many Number of Time
				ClickLink ("name:=Remove Member;innertext:=Remove Member;html tag:=A")
				TINYWAIT
			Next
			
			'Verify the Final Value
			gobjPath.WebElement("html id:=memberCount").RefreshObject
			iNewMemberCountUI = Cint(Left(gobjPath.WebElement("html id:=memberCount").GetROProperty("innertext"), 1))
			If iNewMemberCountUI = iMemberCountNeeded Then
				CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
					"Applying for Health Insurance ?", "Now Decremented Total Members count from = "& iMemberCountUI &" To = "& iMemberCountNeeded & " is same", "Pass"
			Else
				CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
					"Applying for Health Insurance ?", "Now Decremented Total Members count from = "& iMemberCountUI &" To = "& iMemberCountNeeded & " is different" , "Fail"
			End If
				
		ElseIf iMemberCountNeeded > iMemberCountUI Then
			For iLoop = iMemberCountNeeded To iMemberCountUI + 1 Step -1
				'Call Click Function those many Number of Time
				ClickLink ("name:=Add Member;innertext:=Add Member;html tag:=A")
				TINYWAIT
			Next
			
			'Verify the Final Value
			gobjPath.WebElement("html id:=memberCount").RefreshObject
			iNewMemberCountUI = Cint(Left(gobjPath.WebElement("html id:=memberCount").GetROProperty("innertext"), 1))
			If iNewMemberCountUI = iMemberCountNeeded Then
				CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
					"Applying for Health Insurance ?", "Now incremented Total Members count from = "& iMemberCountUI &" To = "& iMemberCountNeeded & " is same", "Pass"
			Else
				CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
					"Applying for Health Insurance ?", "Now incremented Total Members count from = "&  iMemberCountUI &" To = "& iMemberCountNeeded & " is different" , "Fail"
			End If
		Else
			
			'No Changes Needed
			CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
					"Applying for Health Insurance ?", "Total Members count Needed = "& iMemberCountUI &" on UI = "& iMemberCountNeeded & " is same, No action needed !!", "Completed"
		End If
		
		'Perform Save & Continue
		ClickButton "class:=primaryButton nextButton;html id:=nextPage;name:=Save and Continue", "Applying for Health Insurance ? -->Save and Continue"
		TINYWAIT
		Browser("title:=.*Individual & Families.*").sync
		
	Else
		CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
			"Applying for Health Insurance ?", "Total Member(s) in Family is not shown on screen" , "Fail"
	End If
	
End Sub

'###############################################################################################################
'Sub Name       : HouseHoldMembers --> Who is Applying for Health Insurance
'Description      : Enter the Basic Applicant Details and proceed further as needed.
'Input Value      : Entering values from the excel
'Author           : Cigniti Inc/Vandhana/RamMohan
'Create Date      : 06/15/2015
'##############################################################################################################
Sub EnterApplicantDetails()
	On Error Resume Next
	
	Set gobjPath = Browser("title:=.*Individual & Families.*").page("title:=.*Individual & Families.*")
	Browser("title:=.*Individual & Families.*").sync
	
	'Get the Total Members for the Plan
	iApplicants = Cint(CRAFT_GetData ("IndividualApp_Portal_Data","MemberCount"))
	
	'Loop to enter the details ignoring the Applicant 1
	For iLoop = 1 To iApplicants Step 1
		'Perform below task from second applicant only
		If iLoop <> 1 Then
			sApplicantFirstName = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant"& iLoop &"_FirstName")
			EnterData "html id:=eligibilityMember"& (iLoop-1) &".name.firstName", sApplicantFirstName, "Applicant -" & iLoop &" First Name"
			TINYWAIT
			
			sApplicantMiddleName = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant"& iLoop &"_MiddleName")
			EnterData "html id:=eligibilityMember"& (iLoop-1) &".name.middleName", sApplicantMiddleName, "Applicant -" & iLoop &" Middle Name"
			TINYWAIT
			
			sApplicantLastName = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant"& iLoop &"_LastName")
			EnterData "html id:=eligibilityMember"& (iLoop-1) &".name.lastName", sApplicantLastName, "Applicant -" & iLoop &" Last Name"
			TINYWAIT
			
			'Weblist SUFFIX Property "html id:=eligibilityMember1.name.suffix-clone"
			sApplicantDOB = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant"& iLoop &"_DOB")
			EnterData "html id:=eligibilityMember"& (iLoop-1) &".dateOfBirth", sApplicantDOB, "Applicant -" & iLoop &" Date Of Birth"
			TINYWAIT
			
			'Select the Relationship only if supplied
			sApplicantRelation = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant"& iLoop &"_RelationShip")
			If sApplicantRelation <> "" Then
				EnterData "html id:=eligibilityMember"& (iLoop-1) &".memberRelationships0.relationship", sApplicantRelation
				TINYWAIT	
			End If
		End If
		
'		'Perform below task for all applicants
'		sApplicantStatus = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant"& iLoop &"_Status")
'		SelectRadioButton "html id:=eligibilityMember"& (iLoop-1) &".isSmoker1", sApplicantStatus
'		TINYWAIT
	Next
	
	'Perform Save & Continue
	ClickButton "class:=primaryButton nextButton;html id:=nextPage;name:=Save and Continue", "Save And Continue"
	TINYWAIT
	Browser("title:=.*Individual & Families.*").sync
	
	'Perform Save & Continue
	ClickButton "class:=primaryButton nextButton;html id:=nextPage;name:=Save and Continue", "Save And Continue"
	TINYWAIT
	Browser("title:=.*Individual & Families.*").sync
	
	'Perform Continue
	ClickButton "class:=primaryButton nextButton;html id:=nextPage;name:=Continue", "Continue"
	TINYWAIT
	Browser("title:=.*Individual & Families.*").sync
End Sub

'##############################################################################################################
'Sub Name       : HealthInsuranceSummary --> Who is Applying for Health Insurance
'Description      : Summary page to cross check the info we provided...
'Input Value      : None
'Author           : Cigniti Inc/Vandhana/RamMohan
'Create Date      : 06/15/2015
'##############################################################################################################
Sub HealthInsuranceSummary()
	On Error Resume Next
	
	Set gobjPath = Browser("title:=.*Individual & Families.*").page("title:=.*Individual & Families.*")
	Browser("title:=.*Individual & Families.*").sync
	
	'Get the Total Members for the Plan
	iApplicants = Cint(CRAFT_GetData ("IndividualApp_Portal_Data","MemberCount"))
	
	'Verify the details Provided
	'Loop to enter the details ignoring the Applicant 1
	For iLoop = 1 To iApplicants Step 1
		sApplicantFirstName = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant"& iLoop &"_FirstName")
		sApplicantMiddleName = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant"& iLoop &"_MiddleName")
		sApplicantLastName = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant"& iLoop &"_LastName")
		sApplicantDOB = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant"& iLoop &"_DOB")

		'Lin Mony Date of Birth 08/16/1972 
		sSummary = sApplicantFirstName &" "& sApplicantMiddleName & " " & sApplicantLastName & " Date of Birth " & sApplicantDOB

		If gobjPath.WebElement("innertext:="& sSummary, "html tag:=FIELDSET").Exist(10) Then
			CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
				"Applying for Health Insurance ?", "Summary Details "& sSummary & " Exist(s) on screen, as Expected", "Pass"
		Else
			CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
				"Applying for Health Insurance ?", "Summary Details "& sSummary & " doesn't Exist(s) on screen, NOT as Expected", "Fail"
		End If
	Next
	
	'Perform Save & Continue
	ClickButton "class:=primaryButton nextButton;html id:=nextPage;name:=Save and Continue", SaveAndContinue
	TINYWAIT
	Browser("title:=.*Individual & Families.*").sync
	
	'Then Click on Continue
	ClickButton "class:=primaryButton nextButton;html id:=nextPage;name:=Continue", Continue
	TINYWAIT
	Browser("title:=.*Individual & Families.*").sync
End Sub

'##############################################################################################################
'Sub Name       : HouseHoldMemberInfo --> Tell Us About Your Household
'Description      : Enter More Info about the applicants and HouseHold Head
'Input Value      : None
'Author           : Cigniti Inc/Vandhana/RamMohan
'Create Date      : 06/15/2015
'##############################################################################################################
Sub HouseHoldMemberInfo()
	
 
	On Error Resume Next
	
	Set gobjPath = Browser("title:=.*Individual & Families.*").page("title:=.*Individual & Families.*")
	Browser("title:=.*Individual & Families.*").sync
	
	sHouseHoldInfo = CRAFT_GetData ("IndividualApp_Portal_Data","HouseHoldInfo")	
	aHouseHoldInfo = Split(sHouseHoldInfo, "~")
	
	iLoop = 0
	Do
		'Repeat for all Pages until the Radio Button Questions are Exhaused
		Set objDescRadio = Description.Create()
		objDescRadio("micclass").value = "WebRadioGroup"
		objDescRadio("class").value = "(_toggle _toggleSubQuestion required _vRequiredRadio|_toggle _members _vMembersRadiosPanel)"
		objDescRadio("class").regularexpression = True
								
		'Get the Child Objects for the above 
		Set objChild = gobjPath.ChildObjects(objDescRadio)
		iRadioGroupCnt = objChild.Count
		
		'Loop across each Radio Button Object and perform the selection as needed
		If iRadioGroupCnt > 0 Then
			'Split with : to get the other inputs...
			aHouseHoldQue = Split(aHouseHoldInfo(iLoop), ":")
			
			'Get the property 'all items to peform a Random Selection to proceed further'
			For jLoop = iRadioGroupCnt To 1 Step -1
				sAllItems = objChild(jLoop - 1).GetRoProperty("all items")				'iRadioGroupCnt - 1
				sHTMLIdRadio = objChild(jLoop - 1).GetRoProperty("html id")			'iRadioGroupCnt - 1
				If Instr(1, sAllItems, aHouseHoldQue(0), 1) >0  Then
					Exit For
					'Required Value is Acheived Hence Terminating the Loop..
				End If
			Next
			
			aListItems = Split(sAllItems, ";")
			
'			Randomize
'			iRandomSelection = 1		'False	'Int(((UBound(aListItems) - LBound(aListItems)) * Rnd) + LBound(aListItems))

			Select Case UCase(aHouseHoldQue(0))
				Case UCase(aListItems(0))
					iRandomSelection = 0
				Case UCase(aListItems(1))
					iRandomSelection = 1
				Case Else
					iRandomSelection = 0
			End Select
			
			SelectRadioButton "html id:="& sHTMLIdRadio, aListItems(iRandomSelection)
			TINYWAIT
			
						
			'Select the other Input, if provided
			For xloop = 1 To UBound (aHouseHoldQue) Step 1
				
			'If UBound(aHouseHoldQue) > 0 Then
				aParameters = Split(aHouseHoldQue(xloop), "-")
				
				Set objectDescription = Description.Create()
				Select Case UCase(aParameters(0))
					Case "CHECKBOX"
						objectDescription("micclass").value = "WebCheckBox"
						objectDescription("class").value = "_toggle.*_vMembersCheckboxesPanel.*"
						objectDescription("class").regularexpression = True
						
						'Get the Child Objects for the above 
						Set objChildDesc = gobjPath.ChildObjects(objectDescription)
						iObjGroupCnt = objChildDesc.Count
						
						'Loop across each Radio Button Object and perform the selection as needed
						If iObjGroupCnt > 0 Then
							objChildDesc(aParameters(1)).SET "ON"
						End If
									
					Case "RADIOGROUP"
						objectDescription("micclass").value = "WebRadioGroup"
						objectDescription("class").value = "_toggle.* _members _vMembersRadiosPanel.*"
						objectDescription("class").regularexpression = True
						
						'Get the Child Objects for the above 
						Set objChildDesc = gobjPath.ChildObjects(objectDescription)
						iObjGroupCnt = objChildDesc.Count
						
						'Loop across each Radio Button Object and perform the selection as needed
						If iObjGroupCnt > 0 Then
							objChildDesc(iObjGroupCnt - 1).Select aParameters(1)
						End If


					Case "TEXTBOX"
						aNameDOBSelection = Split(aParameters(1), "#")
						oDescription("micclass").value = "WebEdit"
						oDescription("class").value = "(form-control  trimmedName.*|input-large watermark.*)"
						oDescription("class").regularexpression = True
						oDescription("disabled").value = 0
						
						'Get the Child Objects for the above 
						Set objChildDesc = gobjPath.ChildObjects(oDescription)
						iObjGroupCnt = objChildDesc.Count
						
						'Loop across each Radio Button Object and perform the selection as needed
						If iObjGroupCnt > 0 Then
							For kLoop = 0 To iObjGroupCnt -1 Step 1
								objChildDesc(kLoop).Set Cstr(aNameDOBSelection(kLoop))
								TINYWAIT
							Next
							
					End If
					
					
				End Select
			'End If
			Next
		Else
			aParameter = Split(aHouseHoldInfo(iLoop), "-")
			Set oDescription = Description.Create()
			Select Case UCase(aParameter(0))
				Case "CHECKBOX"
					oDescription("micclass").value = "WebCheckBox"
					oDescription("class").value = "_toggle _vMembersCheckboxesPanel.*"
					oDescription("class").regularexpression = True
					
					'Get the Child Objects for the above 
					Set objChildDesc = gobjPath.ChildObjects(oDescription)
					iObjGroupCnt = objChildDesc.Count
					
					'Loop across each Radio Button Object and perform the selection as needed
					If iObjGroupCnt > 0 Then
						objChildDesc(aParameter(1)).SET "ON"
					End If
					
				Case "LISTBOX"
					aRelationship = Split(aParameter(1), ":")
					oDescription("micclass").value = "WebList"
					oDescription("class").value = "_dependentSelection _vDependentSelection.*"
					oDescription("class").regularexpression = True
					
					'Get the Child Objects for the above 
					Set objChildDesc = gobjPath.ChildObjects(oDescription)
					iObjGroupCnt = objChildDesc.Count
					
					'Loop across each Radio Button Object and perform the selection as needed
					If iObjGroupCnt > 0 Then
						For kLoop = 0 To iObjGroupCnt -1 Step 1
							objChildDesc(kLoop).Select aRelationship(kLoop)
						Next
					End If
					
				Case "TEXTBOX"
					aNameDOBSelection = Split(aParameter(1), ":")
					oDescription("micclass").value = "WebEdit"
					oDescription("class").value = "(form-control  trimmedName.*|input-large watermark.*)"
					oDescription("class").regularexpression = True
					
					'Get the Child Objects for the above 
					Set objChildDesc = gobjPath.ChildObjects(oDescription)
					iObjGroupCnt = objChildDesc.Count
					
					'Loop across each Radio Button Object and perform the selection as needed
					If iObjGroupCnt > 0 Then
						For kLoop = 0 To iObjGroupCnt -1 Step 1
							objChildDesc(kLoop).Set Cstr(aNameDOBSelection(kLoop))
						Next
					End If
				
					
'									
			End Select
'			'Select the ListBox
'			If gobjPath.WebList("innertext:= Select Relationship.*", "html tag:=SELECT", "index:=0").Exist(5) Then
'				sValue = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant2_RelationShips")
'				SelectData "innertext:= Select Relationship.*;html tag:=SELECT;index:=0", sValue
'				TINYWAIT
'			Else
'				CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
'	                        	"HouseHold Screen", "Screen 'Tell Us About Your Household' doesn't contains Weblist 'Select Relationships' on screen, Not as Expected", "Fail" 
'			End If
'			
'			'Select Radio Button
'			SelectRadioButton "class:=_toggle required", "false"
'			TINYWAIT
		End If
		Set objDescRadio = Nothing
		Set objChild = Nothing
		
		'Perform Save & Continue
		If strcomp("other", aHouseHoldInfo(iLoop), 1) <> 0 Then       
			ClickButton "class:=primaryButton nextButton;html id:=nextPage;name:=Save and Continue", "Save And Continue"
			TINYWAIT
			Browser("title:=.*Individual & Families.*").sync
		End If
		iLoop = iLoop + 1
	Loop While (gobjPath.WebElement("innertext:=Tell Us About Your Household", "html tag:=H1").Exist(5))
	End Sub
	

'##############################################################################################################
'Sub Name       : PersonalInformation --> Tell Us About Your Household
'Description      : Enter More Info about the applicants and HouseHold Head
'Input Value      : None
'Author           : Cigniti Inc/Vandhana/RamMohan
'Create Date      : 06/15/2015
'##############################################################################################################
Sub PersonalInformation()
	On Error Resume Next
	
	Set gobjPath = Browser("title:=.*Individual & Families.*").page("title:=.*Individual & Families.*")
	Browser("title:=.*Individual & Families.*").sync
	
	'Get the Total Members for the Plan
	iApplicants = Cint(CRAFT_GetData ("IndividualApp_Portal_Data","MemberCount"))
	
	'Loop to enter the details ignoring the Applicant 1
	For iLoop = 1 To iApplicants Step 1
		'Select the Gender Type
		sApplicantGender = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant"& iLoop &"_Gender")
		SelectRadioButton "html id:=eligibilityMember"& (iLoop-1) &".gender1", sApplicantGender
		TINYWAIT
		
		'Does Applicant have SSN ??
		sApplicantDoesHaveSSN = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant"& iLoop &"_DoesHaveSSN")
		SelectRadioButton "html id:=eligibilityMember"& (iLoop-1) &".socialSecurityCard.hasSsn1", sApplicantDoesHaveSSN
		TINYWAIT
		
		If CBool(sApplicantDoesHaveSSN) Then
			sApplicantProvideSSN = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant"& iLoop &"_ProvideSSN")
			SelectRadioButton "html id:=eligibilityMember"& (iLoop-1) &".socialSecurityCard.isSSNProvided2", sApplicantProvideSSN
			TINYWAIT
			
			If CBool(sApplicantProvideSSN) Then
				'Enter SSN Number
				sApplicantSSN = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant"& iLoop &"_SSN")
				sSSNPart1 = Mid(sApplicantSSN, 1, 3)
				sSSNPart2 = Mid(sApplicantSSN, 4, 2)
				sSSNPart3 = Mid(sApplicantSSN, 6, 4)
				
				'Enter Complete SSN Value
				EnterData "html id:=ssn_0", sSSNPart1, "SSN Starting 3 Chartacters"
				EnterData "html id:=ssn_1", sSSNPart2, "SSN Middle 2 Chartacters"
				EnterData "html id:=ssn_2", sSSNPart3, "SSN Last 4 Chartacters"
				
				'Provided SAME SSN
				sSameSSN = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant"& iLoop &"_SameSSN")
				SelectRadioButton "html id:=eligibilityMember"& (iLoop-1) &".socialSecurityCard.nameSameOnSsnCard1", sSameSSN
				TINYWAIT
			End If
		Else
			'Perform the Option Selection from ListBox
			sApplicantExplanation = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant"& iLoop &"_Explanation")
			SelectData "html id:=eligibilityMember"& (iLoop-1) &".socialSecurityCard.noSsnExplanation", sApplicantExplanation		'-clone
			TINYWAIT
		End If
		
		'Perform Save & Continue
		ClickButton "class:=primaryButton nextButton;html id:=nextPage;name:=Save and Continue", "Save And Continue"
		TINYWAIT
		Browser("title:=.*Individual & Families.*").sync
	Next
	
End Sub


'##############################################################################################################
'Sub Name       : ImmigrationStatus --> **** * ****** - Citizenship/Immigration Status 
'Description      : Enter the Applicant Immigration Details
'Input Value      : Values taken from excel
'Author           : Cigniti Inc/Vandhana/RamMohan
'Create Date      : 06/15/2015
'#INPUT# 	--> sApplicantCitizen = "false~CHECKBOX:Tick~DOCUMENT_TYPE:3#ALIEN_NUMBER:984567321#DOCUMENT_EXPIRATION:02/02/2017~DOCUMENT_NAME:true~US_ARRIVAL:true~VETERAN:true"
'##############################################################################################################
Sub ImmigrationStatus()
	On Error Resume Next
	
	Set gobjPath = Browser("title:=.*Individual & Families.*").page("title:=.*Individual & Families.*")
	Browser("title:=.*Individual & Families.*").sync
	
	'Get the Total Members for the Plan
	iApplicants = Cint(CRAFT_GetData ("IndividualApp_Portal_Data","MemberCount"))
	
	'Loop to enter the details for all the Applicant 1
	For iLoop = 1 To iApplicants Step 1
		'Select the Applicant Citizenship
		sApplicantCitizen = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant"& iLoop &"_Citizenship")
		
		'Perform a Split with 'Tilda' to perform the task(s)
		aApplicantCitizen = Split(sApplicantCitizen, "~")
		For jLoop = LBound(aApplicantCitizen) To UBound(aApplicantCitizen) Step 1
			aInternalSelection = Split(aApplicantCitizen(jLoop), "#")
			
			'Perform a Split with Colon and perform the task..
			For kLoop = LBound(aInternalSelection) To UBound(aInternalSelection) Step 1
				'Enter Data as per the input supplied
				aFields = Split(aInternalSelection(kLoop), ":")
				Select Case UCase(aFields(0))
					Case "TRUE", "FALSE"
						SelectRadioButton "html id:=eligibilityMember"& (iLoop-1) &".citizenship.isUSCitizen1", aFields(0)
						TINYWAIT
						
					Case "CHECKBOX"
						ClickCheckBox "html id:=checkImmigrationStatus;html tag:=INPUT"
						TINYWAIT
					
					'Radio Button Selection for "Document Type (Select One)"
					Case "DOCUMENT_TYPE"
						SelectRadioButton "name:=eligibilityMember\["& (iLoop-1) &"\].memberDocuments\[1\].documentType.id", aFields(1)
						TINYWAIT
						
					Case "ALIEN_NUMBER"
						EnterData "html id:=memberDocuments"& (iLoop) &".attributes"& (kLoop-1) &";html tag:=INPUT;index:=1", aFields(1), "Alien Number "
						TINYWAIT
						
					Case "RECEIPT_NUMBER"
						EnterData "html id:=memberDocuments"& (iLoop) &".attributes"& (kLoop-1) &";html tag:=INPUT", aFields(1), "Receipt / Card Number"
						TINYWAIT	
						
					Case "DOCUMENT_EXPIRATION"
						EnterData "html id:=memberDocuments"& (iLoop) &".attributes"& (kLoop-1) &";html tag:=INPUT;index:=1", aFields(1), "Document Expiration Date "
						TINYWAIT
					
					Case "PASSPORT_NUMBER"
						EnterData "html id:=memberDocuments"& (iLoop-1) &".attributes"& (kLoop-1) &";html tag:=INPUT", aFields(1), "PassPort Number "
						TINYWAIT
						
					Case "VISA_NUMBER"
						EnterData "html id:=memberDocuments"& (iLoop-1) &".attributes"& (kLoop-1) &";html tag:=INPUT", aFields(1), "Visa Number "
						TINYWAIT
						
					Case "OTHER_DOCUMENTION"
						SelectData "class:=otherDocumentSelect form-control.*;html tag:=SELECT", aFields(1)
						TINYWAIT
						
					Case "COUNTRY_ISSUANCE"
						SelectData "class:=form-control;all items:=Country.*;html tag:=SELECT", aFields(1)
						TINYWAIT
						
					'Radio Button Selection for "same name that appears on his/her document?"
					Case "DOCUMENT_NAME"
						SelectRadioButton "html id:=eligibilityMember"& (iLoop-1) &".memberDocuments1.nameMatches.*", aFields(1)
						TINYWAIT
						
					Case "FIRST_NAME"
						EnterData "html id:=eligibilityMember"& (iLoop-1) &".memberDocuments1.nameOnDocument.firstName", aFields(1), "First Name "
						TINYWAIT
					
					Case "MIDDLE_NAME"
						EnterData "html id:=eligibilityMember"& (iLoop-1) &".memberDocuments1.nameOnDocument.middleName", aFields(1), "Middle Name "
						TINYWAIT
					
					Case "LAST_NAME"
						EnterData "html id:=eligibilityMember"& (iLoop-1) &".memberDocuments1.nameOnDocument.lastName", aFields(1), "Last Name "
						TINYWAIT
						
					Case "SUFFIX"
						SelectData "html id:=eligibilityMember0.memberDocuments1.nameOnDocument.*;html tag:=SELECT", aFields(1)
						TINYWAIT
										
					'Radio Button Selection for "arrive in the U.S. after August 22, 1996? "
					Case "US_ARRIVAL"
						SelectRadioButton "html id:=eligibilityMember"& (iLoop-1) &".citizenship.isLivedInUS.*", aFields(1)
						TINYWAIT
						
					'Radio Button Selection for "honorably discharged veteran or active duty member of the military"
					Case "VETERAN"
						SelectRadioButton "html id:=eligibilityMember"& (iLoop-1) &".isVeteran.*", aFields(1)
						TINYWAIT
				End Select
			Next
		Next
		
		'Select the Applicant Naturalized
		sApplicantNaturalized = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant"& iLoop &"_Naturalized")
		If sApplicantNaturalized <> "" Then
			SelectRadioButton "html id:=eligibilityMember"& (iLoop-1) &".citizenship.isNaturializedCitizen1", sApplicantNaturalized
			TINYWAIT
		End If
		
'		'Select the Applicant Are you or your spouse or parent an honorably discharged veteran or an active-duty member of the U.S. military
'		sApplicantMilitary = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant"& iLoop &"_Military")
'		SelectRadioButton "html id:=eligibilityMember"& (iLoop-1) &".isVeteran1", sApplicantMilitary
'		TINYWAIT
		
		'Perform Save & Continue
		ClickButton "class:=primaryButton nextButton;html id:=nextPage;name:=Save and Continue", "Save And Continue"
		TINYWAIT
		Browser("title:=.*Individual & Families.*").sync
	Next
End Sub

'##############################################################################################################
'Sub Name       : ParentCaretakers --> **** * ****** - Citizenship/Immigration Status 
'Description      : Enter the Applicant Parent/Caretaker Relatives
'Input Value      : Values taken from Excel
'Author           : Cigniti Inc/Vandhana/RamMohan
'Create Date      : 06/15/2015
'##############################################################################################################
Sub ParentCaretakers()
	On Error Resume Next
	
	Set gobjPath = Browser("title:=.*Individual & Families.*").page("title:=.*Individual & Families.*")
	Browser("title:=.*Individual & Families.*").sync
	
	'Get the Total Members for the Plan
	iApplicants = Cint(CRAFT_GetData ("IndividualApp_Portal_Data","MemberCount"))
	
	'Loop to enter the details for all the Applicant 1, 2
	For iLoop = 1 To iApplicants Step 1
		'Select the Applicant Citizenship
		sApplicantRelations = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant"& iLoop &"_Relations")
		SelectRadioButton "html id:=CT1_"& (iLoop-1) &"_1", sApplicantRelations
		TINYWAIT
		
		'Perform Save & Continue
		ClickButton "class:=primaryButton nextButton;html id:=nextPage;name:=Save and Continue", "Save And Continue"
		TINYWAIT
		Browser("title:=.*Individual & Families.*").sync
	Next
End Sub

'##############################################################################################################
'Sub Name       : EthnicityRace --> **** * ****** - Ethnicity & Race (optional) 
'Description      : Enter the Ethnicity/Race Operations
'Input Value      : None
'Author           : Cigniti Inc/Vandhana/RamMohan
'Create Date      : 06/15/2015
'##############################################################################################################
Sub EthnicityRace()
	On Error Resume Next
	
	Set gobjPath = Browser("title:=.*Individual & Families.*").page("title:=.*Individual & Families.*")
	Browser("title:=.*Individual & Families.*").sync
	
	'Get the Total Members for the Plan
	iApplicants = Cint(CRAFT_GetData ("IndividualApp_Portal_Data","MemberCount"))
	
	'Loop to enter the details for all the Applicant 1, 2
	For iLoop = 1 To iApplicants Step 1
		'Perform Save & Continue
		ClickButton "class:=primaryButton nextButton;html id:=nextPage;name:=Save and Continue", "Save And Continue"
		TINYWAIT
		Browser("title:=.*Individual & Families.*").sync
	Next
End Sub

'##############################################################################################################
'Sub Name       : OtherAddresses -->
'Description      : Enter the OtherAddresses Info
'Input Value      : None
'Author           : Cigniti Inc/Vandhana/RamMohan
'Create Date      : 06/15/2015
'Test data Input : "0:1~24 Main St:Boston:02110:SUFFOLK~36 Main st:Boston:02110:SUFFOLK"
'##############################################################################################################
Sub OtherAddresses()
	On Error Resume Next
	
	
	Set gobjPath = Browser("title:=.*Individual & Families.*").page("title:=.*Individual & Families.*")
	Browser("title:=.*Individual & Families.*").sync
	TINYWAIT
	
	'Get the data from Test data sheets
	Otheraddress = (CRAFT_GetData ("IndividualApp_Portal_Data","Applicant1_OtherAddress"))
	If Otheraddress <> "" Then
		aOtheraddress = Split(Otheraddress,"~")
		
		For iLoop = LBound(aOtheraddress) To UBound(aOtheraddress) Step 1
			aChoice = Split(aOtheraddress(iLoop),":")
		
			Select Case(iLoop + 1) 
				'To Select the choice of applicants to enter the Other Address
				Case 1
					For jLoop = LBound(aChoice) To UBound(aChoice) Step 1
						ClickCheckBox "class:=isOtherAddressCB.*;index:="& aChoice(jLoop)
						TINYWAIT
					Next
				
				Case 2			
					EnterData "html id:=eligibilityMember\[1\].contactInfo.primaryAddress.streetAddress1.*", aChoice(0), "Address Line 1 Entered"
					TINYWAIT
					
					EnterData "html id:=eligibilityMember\[1\].contactInfo.primaryAddress.city.*", aChoice(1), "City Entered"
					TINYWAIT
					
					gobjPath.WebEdit("html id:=eligibilityMember\[1\].contactInfo.primaryAddress.zip.*", "html tag:=INPUT").Click
					CF_sendKeys "METHOD-B", "", aChoice(2)
					TINYWAIT
					
					SelectData "html id:=eligibilityMember\[1\].contactInfo.primaryAddress.county.*", aChoice(3)
					TINYWAIT
					
				Case 3
					EnterData "html id:=eligibilityMember\[2\].contactInfo.primaryAddress.streetAddress1.*", aChoice(0), "Address Line 1 Entered"
					TINYWAIT				
					
					EnterData "html id:=eligibilityMember\[2\].contactInfo.primaryAddress.city.*", aChoice(1), "City Entered"
					TINYWAIT
					
					gobjPath.WebEdit("html id:=eligibilityMember\[2\].contactInfo.primaryAddress.zip.*", "html tag:=INPUT").Click
					TINYWAIT
					CF_sendKeys "METHOD-B", "", aChoice(2)
					TINYWAIT
					
					SelectData "html id:=eligibilityMember\[2\].contactInfo.primaryAddress.county.*", aChoice(3)
					TINYWAIT
				
			End Select
		Next
	End If
			
	'Perform Save & Continue
	ClickButton "html id:=otherAddressNextPage;name:=Save and Continue", "Save And Continue"
	TINYWAIT
	Browser("title:=.*Individual & Families.*").Sync
	
'	
'	'Perform Save & Continue
'	ClickButton "html id:=otherAddressNextPage;name:=Save and Continue", "Save And Continue"
'	TINYWAIT
'	Browser("title:=.*Individual & Families.*").Sync
End Sub

'##############################################################################################################
'Sub Name       : MoreAboutHouseHold --> 
'Description      : Enter the OtherAddresses Info
'Input Value      : NOne
'Author           : Cigniti Inc/Vandhana/RamMohan
'Create Date      : 06/15/2015
'##############################################################################################################
Sub MoreAboutHouseHold()
	On Error Resume Next
	
	Set gobjPath = Browser("title:=.*Individual & Families.*").page("title:=.*Individual & Families.*")
	Browser("title:=.*Individual & Families.*").sync
	
	'Get the Total Members for the Plan
	iApplicants = Cint(CRAFT_GetData ("IndividualApp_Portal_Data","MemberCount"))
	
	MoreHouseHold = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant1_MoreHouseHold")

	If iApplicants <> 0 Then
        aMoreHousehold = Split(MoreHouseHold, "~")
        For iLoop = LBound(aMoreHousehold) To UBound(aMoreHousehold) Step 1
            'Looping across each Question
            aParameter = Split(aMoreHousehold(iLoop), ":")
            
            'Looping across each Answer for a Question
            For jLoop = LBound(aParameter) + 1 To UBound(aParameter) Step 1
                aInputs = Split(aParameter(jLoop), "#")
                
                If LBound(aInputs) = 0 Then
                    Clickcheckbox "class:="& aParameter(0) &".*;html tag:=INPUT;index:="& aInputs(0)
                    TINYWAIT    
                End If
                    
                If UBound(aInputs) >= 1 Then                    
                    SelectData "class:=numberOfBabies.*;html tag:=SELECT", aInputs(1)   
                    TINYWAIT    
                End If
                    
                If UBound(aInputs) >= 2 Then                    
                    EnterData "html id:=due_date_member1.*;html tag:=INPUT", aInputs(2), "Pregnancy : Due Date"
                    TINYWAIT    
                End If
            Next
        Next
    End If


	
	
	'Perform Save & Continue
	ClickButton "class:=primaryButton nextButton;html id:=nextPage;name:=Save and Continue", "Save And Continue"
	TINYWAIT
	Browser("title:=.*Individual & Families.*").sync
	
	If Browser("title:=.*").Page("name:=.*").Webbutton("html id:=nextPage").Exist Then
		ClickButton "html id:=nextPage;name:=Save and Continue", "Save and Continue Button Clicked"
	End If
	
End Sub

'##############################################################################################################
'Sub Name       : HouseHoldRelationships --> Enter Household Members Relationships  
'Description      : Explain how the household members below relate to  *******
'Input Value      : None
'Author           : Cigniti Inc/Vandhana/RamMohan
'Create Date      : 06/15/2015
'##############################################################################################################
Sub HouseHoldRelationships()
	
'Lin ----> Spouse ----> Mike 
'Tim ------> Brother in law ----> Mike
'
'
'Mike ----> Spouse(already selected) ----> Lin
'Tim -----> Sibling -----> Lin

'Applicant_1_2_RelationShips = "Spouse"
'Applicant_1_3_RelationShips = "Brother-in-law/Sister-in-Law"
'Applicant_2_3_RelationShips = "Sibling/stepsibling"

On Error Resume Next
	
	Set gobjPath = Browser("title:=.*Individual & Families.*").page("title:=.*Individual & Families.*")
	Browser("title:=.*Individual & Families.*").sync
	
	'Get the Total Members for the Plan
	iApplicants = Cint(CRAFT_GetData ("IndividualApp_Portal_Data","MemberCount"))			'3
	
	'Loop to enter the details for all the Applicant 1, 2
	For iLoop = 2 To iApplicants Step 1
		'Select the Applicant Citizenship
		
		For jLoop = 1 To iApplicants - iLoop + 1 Step 1
			sApplicantRelationShips = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant_"& (iLoop - 1) &"_"& (jLoop + iLoop - 1) &"_RelationShips")			'Eval("Applicant_" & (iLoop - 1) &"_"& (jLoop + iLoop - 1) & "_RelationShips")
			SelectData "name:=eligibilityMember\["& (iLoop-2) &"\].medicaidMemberRelationships\["& (jLoop + iLoop - 2) &"\].medicaidRelationship", sApplicantRelationShips
			TINYWAIT
		Next
	
		'Perform Save & Continue
		ClickButton "class:=primaryButton nextButton;html id:=nextPage;name:=Save and Continue", "Save And Continue"
		TINYWAIT
		Browser("title:=.*Individual & Families.*").sync 
	Next
	
	'Family & Household Summary Page Validation do it, if needed...
	'Perform Save & Continue
	ClickButton "class:=primaryButton nextButton;html id:=nextPage;name:=Save and Continue", "Save And Continue"
	TINYWAIT
	Browser("title:=.*Individual & Families.*").sync

End Sub


'##############################################################################################################
'Sub Name       : HouseHoldSummary --> Family & Household Summary
'Description      : Enter the OtherAddresses Info
'Input Value      : None
'Author           : Cigniti Inc/Vandhana/RamMohan
'Create Date      : 06/15/2015
'##############################################################################################################
Sub HouseHoldSummary()
	On Error Resume Next
	
	Set gobjPath = Browser("title:=.*Individual & Families.*").page("title:=.*Individual & Families.*")
	Browser("title:=.*Individual & Families.*").sync
	TINYWAIT
	
	'Perform Save & Continue
	ClickButton "class:=primaryButton nextButton;html id:=nextPage;name:=Continue", "Continue"
	TINYWAIT
	Browser("title:=.*Individual & Families.*").sync
End Sub

'##############################################################################################################
'Sub Name       : VerifyIncomeScreen -->
'Description      : To Enter the Income Details (Estimated time for this section:: 10 Minutes - 15 Minutes)
'Input Value      : None
'Author           : Cigniti Inc/Vandhana/RamMohan
'Create Date      : 06/15/2015
'##############################################################################################################
Sub VerifyIncomeScreen()
	On Error Resume Next
	
	Set gobjPath = Browser("title:=.*Individual & Families.*").page("title:=.*Individual & Families.*")
	Browser("title:=.*Individual & Families.*").sync
	
	'Verify the INCOME Header is displayed
	If gobjPath.WebElement("innertext:=Income", "html tag:=H1").Exist(5) Then
		CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
               	"VerifyIncomeScreen", "Validate Header --> INCOME, is shown on screen as Expected", "Pass"
       Else
       	CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
               	"VerifyIncomeScreen", "Validate Header --> INCOME, is NOT shown on screen, NOT as Expected", "Fail"
	End If
	
	'Perform Continue
	'ClickButton "class:=primaryButton nextButton;html id:=nextPage;name:=Save and Continue", "Save And Continue"
	ClickButton"name:=Continue", "ContinueButton"
	TINYWAIT
	Browser("title:=.*Individual & Families.*").sync
End Sub

'##############################################################################################################
'Sub Name       : AnnualIncome --> Expected Annual Income for ***
'Description      : To Enter the Income Details (Estimated time for this section:: 10 Minutes - 15 Minutes)
'Input Value      : None
'Author           : Cigniti Inc/Vandhana/RamMohan
'Create Date      : 06/15/2015
'##############################################################################################################
Sub AnnualIncome()
	On Error Resume Next
	
	Set gobjPath = Browser("title:=.*Individual & Families.*").page("title:=.*Individual & Families.*")
	Browser("title:=.*Individual & Families.*").sync
	
	'Verify the INCOME Header is displayed
	If gobjPath.WebElement("class:=headTxt","innertext:=Annual Income", "html tag:=H2").Exist(5) Then
		CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
               	"VerifyIncomeScreen", "Validate Header --> ANNUAL INCOME, is shown on screen as Expected", "Pass"
       Else
       	CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
               	"VerifyIncomeScreen", "Validate Header --> ANNUAL INCOME, is NOT shown on screen, NOT as Expected", "Fail"
	End If
	
	'Enter the Dollar Amount
	sYearlyIncome = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant1_ExpectIncome")
	EnterData "html id:=your_expected_income;html tag:=INPUT", sYearlyIncome, "Enter Dollar Amount"
	TINYWAIT
	Browser("title:=.*Individual & Families.*").sync
	
	'Perform Save & Continue
	ClickButton "class:=primaryButton nextButton;html id:=nextPage;name:=Save and Continue", "Save And Continue"
	TINYWAIT
	Browser("title:=.*Individual & Families.*").sync
End Sub

'##############################################################################################################
'Sub Name       : ApplicantIncome --> From Current Income Screen to CurrentIncomeDetails Screen including the SelfAttestedIncome
'Description      : To Enter the Income Details 
'Input Value      : Calling the respective funtions to execute this funtion
'Author           : Munagala Ram Mohan / Vandhana
'Create Date      : 07/02/2015
'##############################################################################################################
Sub ApplicantIncome()
	On Error Resume Next
	
	Set gobjPath = Browser("title:=.*Individual & Families.*").page("title:=.*Individual & Families.*")
	Browser("title:=.*Individual & Families.*").sync
	
	'Get the Total Members for the Plan
	iApplicants = Cint(CRAFT_GetData ("IndividualApp_Portal_Data","MemberCount"))
	
	'Loop to enter the details for all the Applicant 1, 2
	For iLoop = 1 To iApplicants Step 1
		'Select the Screen  "CurrentIncome"
		Call CurrentIncome(iLoop)
		TINYWAIT
		
		'If iLoop = 1 Then		'Only Enter the details for applicant ONE
			'Select the Screen  "SelfAttestedIncome"
			Call SelfAttestedIncome(iLoop)
			TINYWAIT	
		'End If
		
		Call CurrentIncomeDetails(iLoop)
		TINYWAIT
	Next
End Sub

'##############################################################################################################
'Sub Name       : CurrentIncome --> ** Current Income
'Description      : To Enter the Income Details 
'Input Value      : Values taken from Excel
'Author           : Munagala Ram Mohan / Vandhana
'Create Date      : 06/30/2015
'##############################################################################################################
Sub CurrentIncome(Byval iApplicant)
	On Error Resume Next
	
	Set gobjPath = Browser("title:=.*Individual & Families.*").page("title:=.*Individual & Families.*")
	Browser("title:=.*Individual & Families.*").sync
	
	'Get Income Sources
	strIncomeSource = (CRAFT_GetData ("IndividualApp_Portal_Data","Applicant"& iApplicant &"_IncomeSource"))
	arrIncomeSource = Split(strIncomeSource, "~")
	
	'Select Income Sources
	SelectRadioButton "html id:=hasIncome1;html tag:=INPUT;visible:=True", arrIncomeSource(0)	
	TINYWAIT
	
	'Make Use of the selection of Jobs if there
	If UBound(arrIncomeSource) > 0 Then
		For iLoop = 1 To Ubound(arrIncomeSource) Step 1
			ClickElement "innertext:="& arrIncomeSource(iLoop) &";html tag:=LABEL", arrIncomeSource(iLoop)
			TINYWAIT
		Next
	End If
	
	'Perform Save & Continue
	ClickButton "class:=primaryButton nextButton;html id:=nextPage;name:=Save and Continue", "Save And Continue"
	TINYWAIT
	Browser("title:=.*Individual & Families.*").sync
End Sub


'##############################################################################################################
'Sub Name       : SelfAttestedIncome -->*** Self-Attested Income
'Description      : To Enter the Job Income Details 
'Input Value      : Values taken from excel
'Author           : Cigniti Inc/Vandhana/RamMohan
'Create Date      : 06/15/2015
'##############################################################################################################
Sub SelfAttestedIncome(Byval iApplicant)
	On Error Resume Next
	
	Set gobjPath = Browser("title:=.*Individual & Families.*").page("title:=.*Individual & Families.*")
	Browser("title:=.*Individual & Families.*").sync
	
	strIncomeSource = (CRAFT_GetData ("IndividualApp_Portal_Data","Applicant"& iApplicant &"_IncomeSource"))
	If Instr(1, strIncomeSource, "Job", 1) > 0 Then
		'Enter the Name of the Employer
		sEmployer = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant"& iApplicant &"_Employer")
		'msgbox (sEmployer)
		'EnterData "html id:=eligibilityMember\[0\].eligibilityMemberIncome.eligibilityMemberIncomeSources\[0\].employerName;html tag:=INPUT", sEmployer, "Applicant Employer"
		Browser("name:=.*").Page("title:=.*").WebEdit("html id:=eligibilityMember\["& (iApplicant - 1) &"\].eligibilityMemberIncome.eligibilityMemberIncomeSources\[0\].employerName").set sEmployer
		TINYWAIT
		
		'Entering data into Employer Address1 field 
		sEmployerAddress1 = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant1_EmployerAddress1")
		EnterData "html id:=eligibilityMember\["& (iApplicant - 1) &"\].eligibilityMemberIncome.eligibilityMemberIncomeSources\[0\].address.streetAddress1;html tag:=INPUT",sEmployerAddress1, "Employer Address-1"
		
		'Entering data into Employer Address2 field 
		sEmployerAddress2 = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant1_EmployerAddress2")
		EnterData "html id:=eligibilityMember\["& (iApplicant - 1) &"\].eligibilityMemberIncome.eligibilityMemberIncomeSources\[0\].address.streetAddress2;html tag:=INPUT",sEmployerAddress2, "Employer Address-2"
		
		TINYWAIT
		'Entering data into Employer City field
		sEmployerCity = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant1_EmployerCity")
		EnterData "html id:=eligibilityMember\["& (iApplicant - 1) &"\].eligibilityMemberIncome.eligibilityMemberIncomeSources\[0\].address.city;html tag:=INPUT",sEmployerCity, "Employer City"
		
		'Entering data into Employer Zip field
		sEmployerZip = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant1_EmployerZipCode")
		'EnterData "name:=userProfile.contactInfo.primaryAddress.zip;html id:=userProfile.contactInfo.primaryAddress.zip;html tag:=INPUT",HomeZip, HomeZip
		gobjPath.WebEdit("html id:=eligibilityMember\["& (iApplicant - 1) &"\].eligibilityMemberIncome.eligibilityMemberIncomeSources\[0\].address.zip", "html tag:=INPUT").Click
		TINYWAIT
		CF_sendKeys "METHOD-B", "", sEmployerZip
		SHORTWAIT
		
		'Selecting the Employer Count from the selectlist
		sEmployerCounty = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant1_EmployerCounty")
		SelectData "html id:=eligibilityMember\["& (iApplicant - 1) &"\].eligibilityMemberIncome.eligibilityMemberIncomeSources\[0\].address.county;html tag:=SELECT", sEmployerCounty
		TINYWAIT
		
		'Entering data into Employer Dollar Amount field
		sEmployerDollarVal = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant1_EmployerDollars")
		EnterData "html id:=eligibilityMember\["& (iApplicant - 1) &"\].eligibilityMemberIncome.eligibilityMemberIncomeSources\[0\].amount;html tag:=INPUT",sEmployerDollarVal, "Employer Dollar Value"
			
		'Selecting the Employer agreement on Payment Mode
		sEmployeerIncome = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant1_SeasonalIncome")
		SelectData "html id:=eligibilityMember\["& (iApplicant - 1) &"\].eligibilityMemberIncome.eligibilityMemberIncomeSources\[0\].frequency;html tag:=SELECT", sEmployeerIncome
		TINYWAIT
		
		'Selecting the Hours does Employee spend work per week
		sEmployeeHoursWeek = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant1_HoursPerWeek")
		EnterData "html id:=eligibilityMember\["& (iApplicant - 1) &"\].eligibilityMemberIncome.eligibilityMemberIncomeSources\[0\].hoursPerWeek;html tag:=INPUT", sEmployeeHoursWeek, "Employee Hours per Week"
		TINYWAIT
		
		'Type of Employer workshop
		sEmployerWorkShop = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant1_EmployerWorkShop")
		SelectRadioButton "html id:=eligibilityMember\["& (iApplicant - 1) &"\].eligibilityMemberIncome.eligibilityMemberIncomeSources\[0\].hasIncomeFromSheltJobs_1;html tag:=INPUT;", sEmployerWorkShop
		TINYWAIT
		
'		'Selecting the Employer Month, income earn 
'		sEmployeeMonth = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant1_IncomeMonth")
'		SelectData "html id:=get_lumpSumMonthIncome", sEmployeeMonth
'		TINYWAIT
		ElseIf Instr(1, strIncomeSource, "Self-Employment", 1) > 0 Then
		'Enter the Name of the Employer
		sTypeOfWork = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant1_TypeOfWork")
		EnterData "html id:=work_type;html tag:=INPUT", sTypeOfWork, "Type Of Work"
		TINYWAIT
		
		'Entering data into Employer Dollar Amount field
		sEmployerDollarVal = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant1_EmployerDollars")
		EnterData "html id:=self_employment_amount;html tag:=INPUT",sEmployerDollarVal, "Employer Dollar Value"
		
		'Entering data into No of Hours per week
		sEmployeeWeekHrs = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant1_EmployeeHours")
		EnterData "html id:=eligibilityMember\["& (iApplicant - 1) &"\].eligibilityMemberIncome.eligibilityMemberIncomeSources\[0\].hoursPerWeek;html tag:=INPUT",sEmployeeWeekHrs, "Employee Week Hours"
	
		ElseIf Instr(1, strIncomeSource, "Unemployment", 1) > 0 Then
		
		'Entering data into Employer Dollar Amount field
		sExpectedAmount = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant1_ExpectIncome")
		EnterData "html id:=unemployed_amount;html tag:=INPUT",sExpectedAmount, "Expected Income Amount Entered"
		
		sHowOften = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant1_SeasonalIncome")
		SelectData "html id:=unemployed_amount_frequency;html tag:=SELECT", sHowOften
		
	End If
	
	'Perform Save & Continue
	ClickButton "class:=primaryButton nextButton;html id:=nextPage;name:=Save and Continue", "Save And Continue"
	TINYWAIT
	Browser("title:=.*Individual & Families.*").sync
	
	'Perform Save & Continue
	ClickButton "class:=primaryButton nextButton;html id:=nextPage;name:=Save and Continue", "Save And Continue"
	TINYWAIT
	Browser("title:=.*Individual & Families.*").sync
End Sub


'##############################################################################################################
'Sub Name       : CurrentIncomeDetails --> ** Current Income Details
'Description      : To Enter the Current Income Details  that are needed additionally
'Input Value      : Values taken from excel
'Author           : Munagala Ram Mohan / Vandhana
'Create Date      : 07/01/2015
'##############################################################################################################
Sub CurrentIncomeDetails(Byval iApplicant)
	On Error Resume Next
	
	Set gobjPath = Browser("title:=.*Individual & Families.*").page("title:=.*Individual & Families.*")
	Browser("title:=.*Individual & Families.*").sync
	
	'Get Income Deductions
	strIncomeDeduction = (CRAFT_GetData ("IndividualApp_Portal_Data","Applicant"& iApplicant &"_IncomeDeductions"))
	arrIncomeDeduction = Split(strIncomeDeduction, "~")
	
	For iLoop = LBound(arrIncomeDeduction) To UBound(arrIncomeDeduction) Step 1
		aLoopValues = Split (arrIncomeDeduction(iLoop), ":")
		Select Case (UCase(aLoopValues(0)))
			Case "CHECKBOX"
				For jLoop = 1 To UBound(aLoopValues) Step 1
					'Perform Check Box Selection
					ClickElement "innertext:="& aLoopValues(jLoop) &";html tag:=LABEL","Check Box --> "& aLoopValues(jLoop)
					TINYWAIT
				Next
				
			Case "AMOUNT"
				EnterData "html id:=eligibilityMember"& (iApplicant - 1) &".eligibilityMemberIncome.amount;html tag:=INPUT", aLoopValues(1), "Amount $"& aLoopValues(1)
				TINYWAIT
				
			Case "HOWOFTEN"
				SelectData "html id:=eligibilityMember"& (iApplicant - 1) &".eligibilityMemberIncome.frequency", aLoopValues(1)
				TINYWAIT
			
			Case "INCOMESTEADY"
				SelectRadioButton "html id:=eligibilityMember"& (iApplicant - 1) &".eligibilityMemberIncome.confirmAmountForCoverageYear1;html tag:=INPUT;visible:=True", aLoopValues(1)
				TINYWAIT
			
			Case "AVERAGEINCOME"
				EnterData "html id:=eligibilityMember"& (iApplicant - 1) &".eligibilityMemberIncome.avgIncome;html tag:=INPUT", aLoopValues(1), "Average Monthly Income $"& aLoopValues(1)
				TINYWAIT
				
			Case Else
				CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
					"Invalid TestData", "Only Valid Inputs are : CHECKBOX ~ AMOUNT ~ HOWOFTEN ~ INCOMESTEADY ~ AVERAGEINCOME", "Fail"
		End Select
	Next
	
	'Perform Save & Continue
	ClickButton "class:=primaryButton nextButton;html id:=nextPage;name:=Save and Continue", "Save And Continue"
	TINYWAIT
	Browser("title:=.*Individual & Families.*").sync
End Sub

'###########################################################################################################################################
'Function Name			:	IncomeDiscrepancies --> Income Discrepancies - Additional Income Questions
'Description			:		Enter Income Discrepancies (Additional Income Questions)
'Input Value			:	None
'Author					:	Cigniti Inc
'Create Date			:	06/15/2015
'###########################################################################################################################################

Sub IncomeDiscrepancies()
	On Error Resume Next
	
	Set gobjPath = Browser("title:=.*Individual & Families.*").page("title:=.*Individual & Families.*")
	Browser("title:=.*Individual & Families.*").sync
	TINYWAIT
	
	'Get the Total Members for the Plan
	iApplicants = Cint(CRAFT_GetData ("IndividualApp_Portal_Data","MemberCount"))
	
	'Loop to enter the details for all the Applicant 1, 2
	For iLoop = 1 To iApplicants Step 1
	
		'Get Income Deductions
		strIncomeDiscrepancy = (CRAFT_GetData ("IndividualApp_Portal_Data","Applicant"& iLoop &"_IncomeDiscrepancy"))
		arrIncomeDiscrepancy = Split(strIncomeDiscrepancy, "~")
		
		For jLoop = LBound(arrIncomeDiscrepancy) To UBound(arrIncomeDiscrepancy) Step 1
			aLoopValues = Split (arrIncomeDiscrepancy(jLoop), ":")
			Select Case (UCase(aLoopValues(0)))
				Case "CHECKBOX"
					For kLoop = 1 To UBound(aLoopValues) Step 1
						'Perform Check Box Selection
						If aLoopValues(kLoop) <> "" Then
							ClickElement "innertext:="& aLoopValues(kLoop) &";html tag:=LABEL","Check Box --> "& aLoopValues(kLoop)
							TINYWAIT	
						End If
					Next
					
				Case "EXPLANATION"
					EnterData "html id:=eligibilityMember\["& (iLoop - 1) &"\].eligibilityMemberIncome.eligibilityMemberIncomeDiscrepancies.lowIncomeExplanation", aLoopValues(1), "Explanation Lower Amount --> "& aLoopValues(1)
					TINYWAIT
					
'				Case "SEASONALWORKER"
'					SelectRadioButton "html id:=eligibilityMember"& (iLoop - 1) &".eligibilityMemberIncome.eligibilityMemberIncomeDiscrepancies.seasonalWorker1;html tag:=INPUT;visible:=True", aLoopValues(1)
'					TINYWAIT
				
'				Case Else
'					CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
'						"Invalid TestData", "Only Valid Inputs are : CHECKBOX ~ EXPLANATION ~ SEASONALWORKER", "Fail"
			End Select
		Next
		
		'Perform Continue with Manual Verification
		ClickButton "class:=primaryButton nextButton;html id:=isVerifyManuallyDecision;name:=Continue with manual Verification", "Continue with manual Verification"
		TINYWAIT
		Browser("title:=.*Individual & Families.*").sync
	Next
	
End Sub


'###############################################################################################################
'Sub Name       : AnnualIncomeFinal --> Annual Income 
'Description      : Enter the Radio Questions for all Applicants
'Input Value      : None
'Author           : Ram / Vandhana
'Create Date      : 06/15/2015
'##############################################################################################################
Sub AnnualIncomeFinal()
	On Error Resume Next
	
	Set gobjPath = Browser("title:=.*Individual & Families.*").page("title:=.*Individual & Families.*")
	Browser("title:=.*Individual & Families.*").sync
	
	'Get the Total Members for the Plan
	iApplicants = Cint(CRAFT_GetData ("IndividualApp_Portal_Data","MemberCount"))
	
	'Loop to enter the details ignoring the Applicant 1
	For iLoop = 1 To iApplicants Step 1
		
		'Perform Radio Selection from Annual Income
		sIncomeStatus = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant"& iLoop &"_AnnualIncome")
		SelectRadioButton "html id:=eligibilityMember\["& (iLoop-1) &"\].eligibilityMemberIncome.sameAsCurrentIncome1", sIncomeStatus
		TINYWAIT
		
		'Perform Save & Continue
		ClickButton "class:=primaryButton nextButton;html id:=nextPage;name:=Save and Continue", "Save And Continue"
		TINYWAIT
		Browser("title:=.*Individual & Families.*").sync
	Next
End Sub

'##############################################################################################################
'Sub Name       : IncomeSummary --> Income Summary enter all the applicants details...
'Description      : Enter the OtherAddresses Info
'Input Value      : None
'Author           : Cigniti Inc/Vandhana/RamMohan
'Create Date      : 06/15/2015
'##############################################################################################################
Sub IncomeSummary()
	On Error Resume Next
	
	Set gobjPath = Browser("title:=.*Individual & Families.*").page("title:=.*Individual & Families.*")
	Browser("title:=.*Individual & Families.*").sync
	TINYWAIT
	
	'Perform Save & Continue
	ClickButton "class:=primaryButton nextButton;html id:=nextPage;name:=Save and Continue", "Save and Continue"
	TINYWAIT
	Browser("title:=.*Individual & Families.*").sync
End Sub


'##############################################################################################################
'Sub Name       : VerifyAdditionalQuestions -->
'Description      : To Enter the Additional Questions (Estimated time for this section:: 5 Minutes - 10 Minutes)
'Input Value      : None
'Author           : Munagala Ram Mohan / Vandhana
'Create Date      : 06/15/2015
'##############################################################################################################
Sub VerifyAdditionalQuestions()
	On Error Resume Next
	
	Set gobjPath = Browser("title:=.*Individual & Families.*").page("title:=.*Individual & Families.*")
	Browser("title:=.*Individual & Families.*").sync
	
	'Verify the INCOME Header is displayed
	If gobjPath.WebElement("innertext:=Additional Questions", "html tag:=H1").Exist(5) Then
		CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
               	"VerifyIncomeScreen", "Validate Header --> Additional Questions, is shown on screen as Expected", "Pass"
       Else
       	CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
               	"VerifyIncomeScreen", "Validate Header --> Additional Questions, is NOT shown on screen, NOT as Expected", "Fail"
	End If
	
	'Perform Save & Continue
	'ClickButton "class:=primaryButton nextButton;html id:=nextPage;name:=Save and Continue", "Save And Continue"
	ClickButton"name:=Continue", "ContinueButton"
	TINYWAIT
	Browser("title:=.*Individual & Families.*").sync
End Sub


'##############################################################################################################
'Sub Name       : ApplicantAdditionalQuestions --> From Health Insurance Information Screen to MassHealth Specific Screen including the OtherInsurance
'Description      : To Enter the Additional Questions Details 
'Input Value      : Empty
'Author           : Munagala Ram Mohan / Vandhana
'Create Date      : 07/05/2015
'##############################################################################################################
Sub ApplicantAdditionalQuestions()
	On Error Resume Next
	
	Set gobjPath = Browser("title:=.*Individual & Families.*").page("title:=.*Individual & Families.*")
	Browser("title:=.*Individual & Families.*").sync
	
	'Get the Total Members for the Plan
	iApplicants = Cint(CRAFT_GetData ("IndividualApp_Portal_Data","MemberCount"))
	
	'Loop to enter the details for all the Applicant 1, 2
	For iLoop = 1 To iApplicants Step 1
		'Select the Screen  "CurrentIncome"
		Call HealthInsuranceInfo (iLoop)
		TINYWAIT
		
		Call OtherInsuranceInfo (iLoop)
		TINYWAIT	
		
		Call MassHealthSpecific (iLoop)
		TINYWAIT
	Next
End Sub

'##############################################################################################################
'Sub Name       : HealthInsuranceInfo --> Health Insurance Information for ***
'Description      : Enter Health Insurance Information for Primary Health Person..
'Input Value      : Noe
'Author           :  Ram / Vandhana
'Create Date      : 07/02/2015
'##############################################################################################################
Sub HealthInsuranceInfo (Byval iApplicant)
	On Error Resume Next
	
	Set gobjPath = Browser("title:=.*Individual & Families.*").page("title:=.*Individual & Families.*")
	Browser("title:=.*Individual & Families.*").sync
	
	sHealthInsurance = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant"& iApplicant &"_HealthInsurance")
	'True / False as per the Insurance Selection
	SelectRadioButton "html id:=eligibilityMember"& (iApplicant - 1) &".eligibilityMemberHealthCoverage.jobCoverageInCoverageYear1",sHealthInsurance
	TINYWAIT
	
'	If UCase(sHealthInsurance) = "TRUE" Then
'	'Will add code soon..
'		
'	ElseIf UCase(sHealthInsurance) = "FALSE" Then	
	sHealthAdditionalInfo = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant"& iApplicant &"_HealthInsuranceInfo")
	SelectRadioButton "html id:=eligibilityMember"& (iApplicant - 1) &".eligibilityMemberHealthCoverage.retirementPlanInCoverageYear1",sHealthAdditionalInfo
		TINYWAIT
'	Else
'		Msgbox "Invalid Entry"
'	End If
	
	'Perform Save & Continue
	ClickButton "class:=primaryButton nextButton;html id:=nextPage;name:=Save and Continue", "Save And Continue"
	SHORTWAIT
	Browser("title:=.*Individual & Families.*").sync
End Sub


'##############################################################################################################
'Sub Name       : OtherInsuranceInfo --> Other Insurance for ***
'Description      : Enter Other Insurance Information for the applicant
'Input Value      : None
'Author           :  Ram / Vandhana
'Create Date      : 07/05/2015
'##############################################################################################################
Sub OtherInsuranceInfo (Byval iApplicant)
	On Error Resume Next
	
	Set gobjPath = Browser("title:=.*Individual & Families.*").page("title:=.*Individual & Families.*")
	Browser("title:=.*Individual & Families.*").sync
	
	sOtherInsurance = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant"& iApplicant &"_OtherInsurance")
	aOtherInsurance = Split(sOtherInsurance, "~")
	
	For iLoop = LBound(aOtherInsurance) To UBound(aOtherInsurance) Step 1
		aCurrentOperation = Split(aOtherInsurance(iLoop), ":")
		
		Select Case (UCase(aCurrentOperation(0)))
			Case "CHECKBOX"
				'Valid Selection
				ClickElement "innertext:="& aCurrentOperation(1) &";html tag:=LABEL","Check Box --> "& aCurrentOperation(1)
				sValueClicked = aCurrentOperation(1)
				TINYWAIT				
				
			Case "COVERAGESTARTDATE"
				'Get the Current Value for Selection
				If Instr(1, sValueClicked, "Medicare", 1) > 0 Then
					sSelectValue = 0
				ElseIf Instr(1, sValueClicked, "Peace Corps", 1) > 0 Then
					sSelectValue = 1
				ElseIf Instr(1, sValueClicked, "VA Healthcare Program", 1) > 0 Then
					sSelectValue = 2
				Else
					'Do Nothing
				End If
				
				'Enter Coverage Start Date
				EnterData "html id:=coverageStartDateTitle_"& iApplicant &"_"& sSelectValue, aCurrentOperation(1), "Other Insurance --> Coverage Start Date"
				TINYWAIT
			
			Case "COVERAGEENDDATE"		
				'Get the Current Value for Selection
				If Instr(1, sValueClicked, "Medicare", 1) > 0 Then
					sSelectValue = 0
				ElseIf Instr(1, sValueClicked, "Peace Corps", 1) > 0 Then
					sSelectValue = 1
				ElseIf Instr(1, sValueClicked, "VA Healthcare Program", 1) > 0 Then
					sSelectValue = 2
				Else
					'Do Nothing
				End If
				
				'Enter Coverage End Date
				EnterData "html id:=coverageEndDateTitle_"& iApplicant &"_"& sSelectValue, aCurrentOperation(1), "Other Insurance --> Coverage End Date"
				TINYWAIT
				
			Case Else
				Msgbox "Invalid Input to function --> 'OtherInsuranceInfo' with Data - '"& sOtherInsurance &"', Not as Expected"
		End Select
	Next
	
	'Perform Save & Continue
	ClickButton "class:=primaryButton nextButton;html id:=nextPage;name:=Save and Continue", "Save And Continue"
	SHORTWAIT
	Browser("title:=.*Individual & Families.*").sync
	
'
'	Set gobjPath = Browser("title:=.*Individual & Families.*").page("title:=.*Individual & Families.*")
'	Browser("title:=.*Individual & Families.*").sync

	If gobjPath.WebElement("innertext:=Tax Filer & Other Additional Questions.*","html tag:=H1").Exist(2) Then
		
		'Get the Total Members for the Plan
'		iApplicants = iApplicants = Cint(CRAFT_GetData ("IndividualApp_Portal_Data","MemberCount"))
'	
'		'Loop to enter the details for all the Applicant 1, 2
'		For iLoop = 1 To iApplicants Step 1
'		'Select if the applicant want to change mind to file joint tax
		sApplicantJointTax = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant1_JointTax")			
			'eligibilityMember1.changeAnswer1
		SelectRadioButton "html id:=eligibilityMember0.changeAnswer1", sApplicantJointTax
							
		ClickButton "class:=primaryButton nextButton;html id:=nextPage", "Save and continue"
		TINYWAIT
		Browser("title:=.*Individual & Families.*").sync
			
		'Next
		
	End If


	
End Sub


'##############################################################################################################
'Sub Name       : MassHealthSpecific --> MassHealth Specific Questions 
'Description      : Enter More Info about the applicants and HouseHold Head
'Input Value      : Empty
'Author           : Cigniti Inc/Vandhana/RamMohan
'Create Date      : 06/15/2015
'Input Data		  : true~InsuranceThroughEmployer:BCBS:098909876~false

'##############################################################################################################
Sub MassHealthSpecific (Byval iApplicant)
	On Error Resume Next
	
	Set gobjPath = Browser("title:=.*Individual & Families.*").page("title:=.*Individual & Families.*")
	Browser("title:=.*Individual & Families.*").sync
	
	sSpecificQuestion = (CRAFT_GetData ("IndividualApp_Portal_Data","Applicant1_SpecificQuestions"))
	aSpecificQuestion = Split(sSpecificQuestion, "~")
	
	iApplicants = Cint(CRAFT_GetData ("IndividualApp_Portal_Data","MemberCount"))
	For iLoop = LBound(aSpecificQuestion) To UBound(aSpecificQuestion) Step 1
		'Perform Separation with :, if any additional Inputs found
		aAdditionalQue = Split(aSpecificQuestion(iLoop) , ":")
		'Select the Radio Button for Health Insuance now !!
		Select Case (iLoop + 1)
			Case 1
				If aSpecificQuestion(iLoop) <> "" Then
					SelectRadioButton "html id:=eligibilityMember"& (iApplicant - 1) &".eligibilityMemberCoverage.haveInsurance.*" , aAdditionalQue(0)
					TINYWAIT
				End If
				
			Case 2
				If aSpecificQuestion(iLoop) <> "" Then
					SelectRadioButton "html id:=eligibilityMember"& (iApplicant - 1) &".eligibilityMemberCoverage.insuranceProgram.*", aAdditionalQue(0)
					TINYWAIT
				End If
				
				If UBound(aAdditionalQue) >= 1 Then
					If aAdditionalQue(1) <> "" Then
						EnterData "html id:=planName;html tag:=INPUT",aAdditionalQue(1), "Enter the Plan Name"
						TINYWAIT
					End If
					
				End If
				
				If UBound(aAdditionalQue) = 2 Then
						EnterData "html id:=policyNumber;html tag:=INPUT", aAdditionalQue(2), " Enter the Policy Number"
					
				End If
			Case 3
				If aSpecificQuestion(iLoop) <> "" Then
					SelectRadioButton "html id:=eligibilityMember"& (iApplicant - 1) &".eligibilityMemberCoverage.stateHealthBenefit.*", aAdditionalQue(0)
					TINYWAIT
				End If
		End Select
	Next
	
	'Perform Save & Continue
	ClickButton "class:=primaryButton nextButton;html id:=nextPage;name:=Save and Continue", "Save And Continue"
	SHORTWAIT
	Browser("title:=.*Individual & Families.*").sync
End Sub


'##############################################################################################################
'Sub Name       : AdditionalQueSummary --> Additional Questions Summary enter all the applicants details...
'Description      : Enter the Additional Questions Details
'Input Value      : Empty
'Author           : Munagala Ram Mohan / Vandhana
'Create Date      : 07/05/2015
'##############################################################################################################
Sub AdditionalQueSummary()
	On Error Resume Next
	
	Set gobjPath = Browser("title:=.*Individual & Families.*").page("title:=.*Individual & Families.*")
	Browser("title:=.*Individual & Families.*").sync
	TINYWAIT
	
	'Perform Save & Continue
	ClickButton "class:=primaryButton nextButton;html id:=nextPage;name:=Continue", "Continue"
	TINYWAIT
	Browser("title:=.*Individual & Families.*").sync
End Sub


'##############################################################################################################
'Sub Name       : VerifyReviewSign  --> Check with Page Review & Sign
'Description      : To Enter the Review & Sign Questions (Estimated time for this section:: 5 Minutes - 10 Minutes)
'Input Value      : Empty
'Author           : Munagala Ram Mohan / Vandhana
'Create Date      : 07/05/2015
'##############################################################################################################
Sub VerifyReviewSign()
	On Error Resume Next
	
	Set gobjPath = Browser("title:=.*Individual & Families.*").page("title:=.*Individual & Families.*")
	Browser("title:=.*Individual & Families.*").sync
	
	'Verify the INCOME Header is displayed
	If gobjPath.WebElement("innertext:=Review & Sign", "html tag:=H1").Exist(5) Then
		CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
               	"VerifyIncomeScreen", "Validate Header --> Review & Sign, is shown on screen as Expected", "Pass"
       Else
       	CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
               	"VerifyIncomeScreen", "Validate Header --> Review & Sign, is NOT shown on screen, NOT as Expected", "Fail"
	End If
	
	'Perform Save & Continue
	'ClickButton "class:=primaryButton nextButton;html id:=nextPage;name:=Save and Continue", "Save And Continue"
	ClickButton"name:=Continue", "ContinueButton"
	TINYWAIT
	Browser("title:=.*Individual & Families.*").sync
End Sub


'##############################################################################################################
'Sub Name       : ReviewApplication --> Review Application Summary enter all the applicants details...
'Description      : Enter the Review Additional Details
'Input Value      : Empty
'Author           : Munagala Ram Mohan / Vandhana
'Create Date      : 07/05/2015
'##############################################################################################################
Sub ReviewApplication()
	On Error Resume Next
	
	Set gobjPath = Browser("title:=.*Individual & Families.*").page("title:=.*Individual & Families.*")
	Browser("title:=.*Individual & Families.*").sync
	TINYWAIT
	
	'Perform Save & Continue on Review Application
	'ClickButton "class:=primaryButton nextButton;html id:=nextPage;name:=Save and Continue", "Save And Continue"
	ClickButton"name:=Continue", "ContinueButton"
	TINYWAIT
	Browser("title:=.*Individual & Families.*").sync
	
	'Perform First Check Box Selection
	ClickCheckBox "html id:=agreement.isSigningUnderPenaltyOfPerjury"
	TINYWAIT
	
	'Perform Second Check Box Selection
	ClickCheckBox "html id:=agreement.isUseTaxReturnDataForRenewal5Year"
	TINYWAIT
	
	'Perform Third Check Box Selection
	ClickCheckBox "html id:=hasMemberIncarcerated"
	TINYWAIT
	
	'Perform Fourth Check Box Selection
	ClickCheckBox "html id:=agreement.isAgreeStatements"
	TINYWAIT
	
	sConsent = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant1_ElectronicSignature")
	aConsent = Split(sConsent, "~")
	For iLoop = LBound(aConsent) To UBound(aConsent) Step 1
		aActualData = Split(aConsent(iLoop), ":")
		
		Select Case (UCase(aActualData(0)))
		
			'Enter the Electronic Signature
			Case "ELECTRONICSIGN"
				EnterData "html id:=eligibilityMember0.signature", aActualData(1), "Review & Sign --> Electronic Signature"
				TINYWAIT
				
			'Select the Radio Group Voter Registration
			Case "VOTERREGISTRATION"
				SelectRadioButton "html id:=agreement.isWillingToRegisterToVote1",aActualData(1)
				TINYWAIT
		End Select
	Next

	'Perform Submit
	ClickButton "class:=primaryButton nextButton;html id:=nextPage;name:=Submit", "Submit"
	SHORTWAIT
	Browser("title:=.*Individual & Families.*").sync
	
	
	Set gobjPath = Browser("title:=.*Individual & Families.*").page("title:=.*Individual & Families.*")

	If gobjPath.WebElement("innertext:=Household.*Application Result.*").Exist(2)	 Then

		Set objDescFPL = Description.Create()
			objDescFPL("micclass").value = "WebElement"
			objDescFPL("innertext").value = "Household.*Application Result.*FPL.*"
			objDescFPL("innertext").regularexpression = True
			objDescFPL("html tag").value = "H3"
									
			'Get the Child Objects for the above 
			Set objChild = gobjPath.ChildObjects(objDescFPL)
			iWebElementCnt = objChild.Count
			If iWebElementCnt > 0 Then  
			strFPL = Trim(Split(objchild(0).GetRoProperty("innertext"), ":")(1))
			End If
		'msgbox strFPL
		Call CRAFT_PutData ("IndividualApp_Portal_Data", "FPL", strFPL)
	End If
	
	
	If gobjPath.WebElement("class:=premiumInt").Exist(2)	 Then
	
	Set objDescAPTC = Description.Create()
		objDescAPTC("micclass").value = "WebElement"
		objDescAPTC("class").value = "premiumInt"
		objDescAPTC("html tag").value = "SPAN"
								
		'Get the Child Objects for the above 
		Set objChild = gobjPath.ChildObjects(objDescAPTC)
		iWebElementCnt = objChild.Count
		If iWebElementCnt > 0 Then  
		strAPTC = Trim(objchild(0).GetRoProperty("innertext"))
		End If
		'msgbox strAPTC
		Call CRAFT_PutData ("IndividualApp_Portal_Data", "APTC", strAPTC)
	End If
	
	'Comtinue by clicking on Popup OK Button..
	If gobjPath.Webbutton("html id:=popup_ok").Exist(1) Then
	ClickButton "html id:=popup_ok;thml tag:=INPUT", "2015 Applcation Changes"
	TINYWAIT
	Browser("title:=.*Individual & Families.*").sync
	End If
	
	'This find a plan will be clicked only when this funtion is used for single applicant, if used for multiple applicants the find a plan will not clicked.
	If gobjPath.Webbutton("name:=Find a Plan").Exist (2) Then
		ClickButton "class:=primaryButton;name:=Find a Plan", "Find a Plan"
		TINYWAIT
		Browser("title:=.*Individual & Families.*").sync
	
	'Getting Started
		ClickButton "class:=primaryButton nextButton;html id:=findPlan;name:=Continue", "Getting Started --> Continue"
		TINYWAIT
		Browser("title:=.*Individual & Families.*").sync
	
	End If
	
	
End Sub

'##############################################################################################################
'Sub Name       : QualifyLifeEvents --> QualifyLifeEvents Summary enter all the applicants details...
'Description      : Enter the Review Additional Details
'Input Value      : Empty
'Author           : Munagala Ram Mohan / Vandhana
'Create Date      : 07/05/2015
'##############################################################################################################
Sub QualifyLifeEvents()
	On Error Resume Next
	
	Set gobjPath = Browser("title:=.*Individual & Families.*").page("title:=.*Individual & Families.*")
	Browser("title:=.*Individual & Families.*").sync
	TINYWAIT
	
	If gobjPath.WebElement("innertext:= Qualifying Life Events").Exist(2)Then
	
	sLifeEvents = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant1_LifeEvents")
	aLifeEvents = Split(sLifeEvents, "~")
	
	For iLoop = LBound(aLifeEvents) To UBound(aLifeEvents) Step 1
		aItemSelect = Split(aLifeEvents(iLoop),":")
		Select Case (iLoop + 1)
			Case 1
				'Perform First Radio Box Selection
				SelectRadioButton "html id:=elgModification.heathCovChangeInHh.*",aItemSelect(0)
				TINYWAIT
				
			Case 2
				'Perform Second Radio Box Selection
				SelectRadioButton "html id:=elgModification.dependentChangeInHh.*",aItemSelect(0)
				TINYWAIT
				
			Case 3
				'Perform Third Radio Box Selection
				SelectRadioButton "html id:=elgModification.immigrationChangeInHh.*",aItemSelect(0)
				TINYWAIT
				
			Case 4
				'Perform Fourth Radio Box Selection
				SelectRadioButton "html id:=elgModification.addressChangeInHh.*",aItemSelect(0)
				TINYWAIT
				
				If strcomp(1, aLifeEvents(iLoop), "TRUE") = 0 AND UBOUND(aItemSelect) > 0 Then
					
					iApplicants = Cint(CRAFT_GetData ("IndividualApp_Portal_Data","MemberCount"))
	
				    	'Loop to enter the details for all the Applicant 1, 2
				    	For jLoop = 1 To iApplicants Step 1
				    		If aItemSelect(jLoop) <> "" Then
				    			ClickCheckBox "name:=elgModification.elgMemberModifications\["& (jLoop -1) &"\].memberMovedMA"
					        	TINYWAIT
					    
					        	If UBound(aItemSelect) <= iLoop Then
   						    		'Enter the Data
   						          	EnterData "html id:=elgModification.elgMemberModifications"& (jLoop - 1) &".moveToMaDt", aItemSelect(jLoop), "Qualifying Life Events --> HouseHold Status"
				                  		TINYWAIT
					        	End If
				    		End If
				    	Next
				End If
			Case Else
				Msgbox "Code Handled only for Radio Box Selection till - 4 in Function : --> "& QualifyLifeEvents
		End Select
	Next

	'Perform Save and Continue
	ClickButton "class:=primaryButton nextButton;html id:=nextPage;name:=Save and Continue", "Save And Continue"
	SHORTWAIT
	Browser("title:=.*Individual & Families.*").sync
	
	End If 
	
	'Comtinue by clicking on Popup OK Button..
	If gobjPath.Webbutton("html id:=popup_ok").Exist(1) Then
	ClickButton "html id:=popup_ok;html tag:=INPUT", "2015 Applcation Changes"
	TINYWAIT
	Browser("title:=.*Individual & Families.*").sync
	End If
	
	
	Set gobjPath = Browser("title:=.*Individual & Families.*").page("title:=.*Individual & Families.*")

	If gobjPath.WebElement("innertext:=Household.*Application Result.*").Exist(2)	 Then

		Set objDescFPL = Description.Create()
			objDescFPL("micclass").value = "WebElement"
			objDescFPL("innertext").value = "Household.*Application Result.*FPL.*"
			objDescFPL("innertext").regularexpression = True
			objDescFPL("html tag").value = "H3"
									
			'Get the Child Objects for the above 
			Set objChild = gobjPath.ChildObjects(objDescFPL)
			iWebElementCnt = objChild.Count
			If iWebElementCnt > 0 Then  
			strFPL = Trim(Split(objchild(0).GetRoProperty("innertext"), ":")(1))
			End If
		'msgbox strFPL
		Call CRAFT_PutData ("IndividualApp_Portal_Data", "FPL", strFPL)
	End If
	
	
	If gobjPath.WebElement("class:=premiumInt").Exist(2)	 Then
	
	Set objDescAPTC = Description.Create()
		objDescAPTC("micclass").value = "WebElement"
		objDescAPTC("class").value = "premiumInt"
		objDescAPTC("html tag").value = "SPAN"
								
		'Get the Child Objects for the above 
		Set objChild = gobjPath.ChildObjects(objDescAPTC)
		iWebElementCnt = objChild.Count
		If iWebElementCnt > 0 Then  
		strAPTC = Trim(objchild(0).GetRoProperty("innertext"))
		End If
		'msgbox strAPTC
		Call CRAFT_PutData ("IndividualApp_Portal_Data", "APTC", strAPTC)
	End If
	
	'Comtinue by clicking on Find a Plan Button
	
	If gobjPath.Webbutton("name:=Find a Plan").Exist (2) Then
		ClickButton "class:=primaryButton;name:=Find a Plan", "Find a Plan"
		TINYWAIT
		Browser("title:=.*Individual & Families.*").sync
	
	'Getting Started
		ClickButton "class:=primaryButton nextButton;html id:=findPlan;name:=Continue", "Getting Started --> Continue"
		TINYWAIT
		Browser("title:=.*Individual & Families.*").sync
	
	End If
	
	
	'Health Plan Shopping
	'ClickButton "class:=primaryButton nextButton;html id:=planSelectionContinue;name:=Continue", "Health Plan Shopping --> Continue"
	'TINYWAIT
	'Browser("title:=.*Individual & Families.*").sync
	
	'Dental Plan Shopping
	'ClickButton "class:=primaryButton nextButton;html id:=planSelectionContinue;name:=Continue", "Dental Plan Shopping --> Continue"
	'TINYWAIT
	'Browser("title:=.*Individual & Families.*").sync
End Sub

'###########################################################################################################################################
'Function Name		:	SignIn
'Description		:	Sign in to the application to edit the application
'Input Value		:	email/User ID and Password, taken from the excel
'Author				:	Cigniti Inc/Vandhana/RamMohan
'Create Date		:	06/15/2015
'###########################################################################################################################################
Sub SignIn()

	On Error Resume Next
	
	'Syncing the browser and the create profile page
	Set gobjPath = Browser("title:=.*Individual & Families.*").Page("title:=.*Individual & Families.*")
	Browser("title:=.*Individual & Families.*").sync
	
	'To Maximize the Window
	hwnd = Browser("title:=.*Individual & Families.*").Object.HWND
	Window("hwnd:=" & hwnd).Maximize	
	
	'Click on Sign In Button
	ClickButton "name:=Sign In;type:=submit", "Sign In"
	SHORTWAIT
	'Browser("title:=.*Individual & Families.*").sync
	
	'Enter the Login Details in OPTUM ID Screen
	Set gobjPath = Browser("title:=Optum ID.*").Page("title:=Optum ID.*")
	Browser("title:=Optum ID.*").Sync

	'Enter User ID
	UserLogin = CRAFT_GetData ("IndividualApp_Portal_Data","UserName")	
	EnterData "html id:=EMAIL;html tag:=INPUT",UserLogin, "Optum Sign In --> User Name"
	
	'Enter Password
	UserPassword = CRAFT_GetData ("IndividualApp_Portal_Data","Password1")	
	EnterData "html id:=PASSWORD;html tag:=INPUT",UserPassword, "Optum Sign In --> Password"
	
	'Click on Optum Sign IN Button
	ClickButton "html id:=submitButton;name:=Sign In","Optum SignIn --> Sign In"
	SHORTWAIT
	Browser("title:=Optum ID.*").Sync
	
	'Now Answer the Security Questions
	Set gobjPath = Browser("name:=(Authentication|Security Questions).*").Page("title:=(Authentication|Security Questions).*")	
	If gobjPath.WebElement("class:=authQuestionTitle", "innertext:=Online Security", "html tag:=DIV").Exist(10) Then
		
		'Frame Security Questions Object
		Set objDescQuest = Description.Create
		objDescQuest("innertext").Value = "Question: .*"
		objDescQuest("innertext").regularexpression = True
		objDescQuest("class").Value = "challengeSecurityQuestions"
		objDescQuest("html tag").Value = "DIV"

		'Get the Actual Question from UI
		sActualQuestion = gobjPath.WebElement(objDescQuest).GetRoProperty ("innertext")
				
		'Get the Answer for Actual Question by Looping
		For iLoop = 1 To 3 Step 1
			sSecurityQuestion = CRAFT_GetData ("IndividualApp_Portal_Data","SecurityQ"& iLoop)
			If Instr(1, sActualQuestion, sSecurityQuestion,1) > 0 Then
				sSecurityAnswer = CRAFT_GetData ("IndividualApp_Portal_Data","SecurityA"& iLoop)

				'Verify the Questions listed are being currently populated with set of Questions that we received as part of Function Input. If so Capture Answer and Submit
				If  sSecurityAnswer <> "" Then
					'Enter the answer in WebPage and Validate the answer supplied
					EnterData "class:=challengeSecurityUserAnswerInput;html tag:=INPUT", sSecurityAnswer, "Optum Security --> Answer"
					
					'Click on Submit Button
					ClickButton "html id:=authQuestionSubmitButton;html tag:=INPUT", "Optum Security --> Submit"
					gobjPath.Sync	
				Else
					CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
						"Blank Security Answer -  '"& sSecurityAnswer &"' for Question -  '"& sSecurityQuestion &"' was passed as Input, NOT as expected", "Fail"
				End If
				Exit For
			Else
				'Do Nothing Just 
			End If
		Next
	Else
		CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
			"Invalid Security Question(s) or Invalid Security Answer(s) was passed as Input to function , NOT as expected", "Fail"	 
	End If
End Sub

'###########################################################################################################################################
'Function Name			:	SignOut
'Description			:	Sign out of the application
'Input Value			:	None
'Author					:	Cigniti Inc/Vandhana/RamMohan
'Create Date			:	06/15/2015
'###########################################################################################################################################

Sub SignOut()

	On Error Resume Next
	
	Set gobjPath = Browser("title:=.*Individual & Families.*").page("title:=.*Individual & Families.*")
	Browser("title:=.*Individual & Families.*").sync
	
	'Click Sign Out
	ClickButton "html id:=logout;html tag:=INPUT","Sign Out"
	
End Sub

'###########################################################################################################################################
'Function Name			:	Guerrilla_StoreMailID
'Description			:	To store the temporary email annd user id in excel for the creation of the application
'Input Value			:	None
'Author					:	Cigniti Inc
'Create Date			:	06/15/2015
'###########################################################################################################################################

Sub Guerrilla_StoreMailID ()

	On Error Resume Next
	Browser("title:=.*Guerrilla.*").Sync
	Set Obj = Browser("title:=.*Guerrilla.*").Page("title:=Notification: Policy Acknowledgement")
	If Obj.Link("text:=I AGREE", "html tag:=A").Exist(5) Then
		Obj.activate
		Browser("title:=.*Guerrilla.*").Maximize
		Obj.Link("text:=I AGREE", "html tag:=A").Click
		CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
			"Browser --> Guerrilla", "Click action on 'I Agreee' Link is performed successfully", "Pass"
		Browser("brwStateHealthConnector").Sync
		Wait(3)
	ElseIf Obj.Link("text:=Click here to accept this statement and access the Internet.", "html tag:=A").Exist(5) Then
		Obj.Link("text:=Click here to accept this statement and access the Internet.", "html tag:=A").Click
		CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
			"Browser --> Guerrilla", "Click action on 'Click here to accept this statement and access the Internet.' Link is performed successfully", "Pass"
		Browser("brwStateHealthConnector").Sync
		Wait(3)
	Else
		CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
			"Create Account Button", "'I Agree' OR 'Click here to accept this statement and access the Internet.' Link is not displayed on Screen, Proceeding Further", "Completed"
	End If
		
'	If Browser("brwGuerrilla").Page("pgeUHG").Link("lnkAgree").Exist(5) Then
'		Browser("brwGuerrilla").Page("pgeUHG").Link("lnkAgree").Click
'	ElseIf Browser("brwGuerrilla").Page("pgeUHG").Link("lnkClickAcceptThis").Exist(5) then
'		Browser("brwGuerrilla").Page("pgeUHG").Link("lnkClickAcceptThis").Click
'	End If
		
	Browser("brwGuerrilla").Sync
	Wait(2)
	
	With Browser("title:=.*Guerrilla.*").Page("title:=.*")
		.Link("text:=Email", "html tag:=A").Click
		strMockID = .WebElement("class:=editable button", "html tag:=SPAN").GetROProperty ("innertext")
		strMailDomain = .WebList("html id:=gm-host-select", "html tag:=SELECT").GetROProperty ("value")
		
		strCompleteMailId = strMockID & "@" & strMailDomain
		Call CRAFT_PutData ("IndividualApp_Portal_Data", "EmailID", strCompleteMailId)
		
		strUserId = "Auto" & RandomNumber(7, 24) & strMockID
		Call CRAFT_PutData ("IndividualApp_Portal_Data", "UserName", strUserId)
	End With
	
	'Verify for the Error in Function
	If Err.Number <> 0 Then
		CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
			"Component --> Guerrilla_StoreMailID", "Error Occured while processing the Business Component with Description ==> "& Err.Description, "Warning"
		Err.Clear
	End If
End Sub

'###########################################################################################################################################
'Function Name			:	LaunchGuerrilla
'Description			:	Launching the Guerrillamail application to create the temporary email ID to the applicant
'Input Value			:	None
'Author					:	Cigniti Inc
'Create Date			:	06/15/2015
'###########################################################################################################################################

Sub LaunchGuerrilla() 
	On Error Resume Next
	SystemUtil.Run "iexplore.exe", CRAFT_GetData("General_Data","MockMail_Path")
	Wait(14)
	
		If Browser("name:=This page can’t be displayed").Page("title:=This page can’t be displayed").Exist(2)Then
            Browser("name:=This page can’t be displayed").Page("title:=This page can’t be displayed").WebButton("name:=Fix connection problems","html tag:=BUTTON").Click
            Wait(5)
            Browser("name:=This page can’t be displayed").Window("text:=Windows Network Diagnostics","regexpwndtitle:=Windows Network Diagnostics").WinButton("regexpwndtitle:=Close","text:=Close").Click    
            Wait(2)
        End If
	
	Set Obj = Browser("title:=.*Guerrilla.*")
	If Obj.Exist(5) Then
		'Obj.Maximize
		CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
			"Browser -> Guerilla", "Browser successfullly launched and navigated to URL -> "& CRAFT_GetData("General_Data","MockMail_Path"), "Pass"
	Else
		CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
			"Browser -> Guerilla", "Unable to launch Browser to navigate URL -> "& CRAFT_GetData("General_Data","MockMail_Path") &" ,Not as Expected", "Fail"
	End If
	
	'Verify for the Error in Function
	If Err.Number <> 0 Then
		CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
			"Component --> LaunchGuerrilla", "Error Occured while processing the Business Component with Description ==> "& Err.Description, "Warning"
		Err.Clear
	End If
	
	Set Obj = Nothing
End Sub

'###########################################################################################################################################
'Function Name			:	CloseApplications
'Description			:	Closing all the applications
'Input Value			:	None
'Author					:	Cigniti Inc
'Create Date			:	06/15/2015
'###########################################################################################################################################

Sub CloseApplications()

	On Error Resume Next
	If Browser("title:=.*Individual & Families.*").Exist(5) Then
		Browser("title:=.*Individual & Families.*").close
		CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"), "CloseApplications", "Applications - 'Health Connector' closed successfully, as expected", "Pass"	
		Wait(1)	
	End If
	
	'Close Guerilla Application
	If Browser("title:=.*Guerrilla.*").Exist(5) Then
		Browser("title:=.*Guerrilla.*").Close
		CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"), "CloseApplications", "Applications - 'Guerilla' closed successfully, as expected", "Pass"	
	End If
End Sub


'##############################################################################################################
'Sub Name       	: MoreAboutHouseHoldSingle --> 
'Description      : Enter the OtherAddresses Info
'Input Value      : Empty
'Author           : 
'Create Date      : 06/15/2015
'##############################################################################################################

Sub MoreAboutHouseHoldSingle()
On Error Resume Next

	Set gobjPath = Browser("title:=.*Individual & Families.*").page("title:=.*Individual & Families.*")
	Browser("title:=.*Individual & Families.*").sync
	
	'Get the Total Members for the Plan
	iApplicants = Cint(CRAFT_GetData ("IndividualApp_Portal_Data","MemberCount"))
	
	'Loop to enter the details for all the Applicant 1, 2
	If iApplicants = 1 Then
		aMoreHousehold = Split(CRAFT_GetData ("IndividualApp_Portal_Data","Applicant1_MoreHouseHold"), "~")
		
		'Select the Radio Button for Disability, Illness & Injury
		If Instr(1, "True-false", aMoreHousehold(0), 1) > 0 AND aMoreHousehold(0) <>"" Then
			SelectRadioButton "html id:=eligibilityMember0.eligibilityMemberAdditionalInfo.isDisabled1",aMoreHousehold(0)
			TINYWAIT			
		End If
		
		'Select the Radio Button for Indian/Alaska Native
		If Instr(1, "True-false", aMoreHousehold(1), 1) > 0 AND aMoreHousehold(1) <>"" Then
			SelectRadioButton "html id:=eligibilityMember0.eligibilityMemberAdditionalInfo.isAmericanIndian2",aMoreHousehold(1)
			TINYWAIT			
		End If
		
		'Select the Radio Button for treatment for breast or cervical cancer
		If Instr(1, "True-false", aMoreHousehold(2), 1) > 0 AND aMoreHousehold(2) <>"" Then
			SelectRadioButton "html id:=eligibilityMember0.eligibilityMemberAdditionalInfo.isHavingBreastOrCervicalCancer1",aMoreHousehold(2)
			TINYWAIT			
		End If
		
		'Select the Radio Button for HIV positive
		If Instr(1, "True-false", aMoreHousehold(3), 1) > 0 AND aMoreHousehold(3) <>"" Then
			SelectRadioButton "html id:=eligibilityMember0.eligibilityMemberAdditionalInfo.isHIVPositive1",aMoreHousehold(3)
			TINYWAIT			
		End If

		If Ubound(aMoreHousehold)=4 Then
			aPregnantData = Split(aMoreHousehold(4), ":")
			'Select the Radio Button if Pregnant
			If Instr(1, "True-false", aPregnantData(0), 1) > 0 AND aMoreHousehold(1) <>"" Then
				SelectRadioButton "html id:=eligibilityMember0.eligibilityMemberAdditionalInfo.isPregnant.*",aPregnantData(0)
				TINYWAIT	

				If gobjPath.Weblist("class:=numberOfBabies").Exist(2) Then
			
					SelectData "class:=numberOfBabies",aPregnantData(1)
						
					Enterdata "html id:=due_date_member.*",aPregnantData(2), "Due Date Entered"
				
				End If
			End If
		End If		
	End If


	'Perform Save & Continue
	ClickButton "class:=primaryButton nextButton;html id:=nextPage;name:=Save and Continue", "Save And Continue"
	TINYWAIT
	Browser("title:=.*Individual & Families.*").sync
	
	ClickButton "class:=primaryButton nextButton;html id:=nextPage;name:=Save and Continue", "Continue"
	TINYWAIT
	Browser("title:=.*Individual & Families.*").sync
End Sub
	
	
'###########################################################################################################################################
'Function Name			:	HouseHoldContactInfoCheckbox
'Description			:	Checking the checkbox for the household address same as the Create Profile contact details
'Input Value			:	None
'Author					:	Cigniti Inc
'Create Date			:	07/07/2015
'###########################################################################################################################################

Sub HouseHoldContactInfoCheckbox()

    On Error Resume Next
    
    Set gobjPath = Browser("title:=.*Individual & Families.*").Page("title:=.*Individual & Families.*")
    Browser("title:=.*Individual & Families.*").sync
    
    If gobjPath.Exist(10) Then
    
       ' CheckBox for Household Contact Info
        ClickCheckBox "html id:=eligibilityMember\[0\].checkAccountHolder;html tag:=INPUT;name:=eligibilityMember\[0\].checkAccountHolder"
        'ClickElement "class:=checkbox;innertext:= Check here if you are the account holder.*;html tag:=LABEL", "House Hold Contact Info --> CheckBox"
        
    
        
        'Click Save and Continue
        ClickButton "name:=Save and Continue","Continue"
        SHORTWAIT
        Browser("title:=.*Individual & Families.*").sync
        
        CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
            "Head of Household Contact Information", "'HouseHold Contact Information' Screen is displayed in Browser, as Expected", "Pass"    
    Else
        CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
            "Head of Household Contact Information", "'Household Contact Information' Screen is not displayed in Browser, Not as Expected", "Fail"    
    End If    
    
    
End Sub 


Sub CreateAccount_OR
	
'This Function is to enter the incorrect inputs and check if the application is reverting an error to enter the appropriate details or corrections.
	

'Initiating for the creation of the application
Browser("Start your Application").Page("Start your Application").WebButton("Create an Account").Click

'Starting to create the Optum ID Process
Browser("Start your Application").Page("Optum ID - Sign-In").WebButton("Don't have an Optum ID?").Click

'Entering the First Name
FirstName = CRAFT_GetData ("IndividualApp_Portal_Data","FirstName")
Browser("Start your Application").Page("Optum ID - Registration").WebEdit("userRegistrationId:firstName").Set FirstName

'Entering the Middle Name'
MiddleName = CRAFT_GetData ("IndividualApp_Portal_Data","MiddleName")
Browser("Start your Application").Page("Optum ID - Registration").WebEdit("userRegistrationId:middleName").Set MiddleName


'Entering the Last Name'
LastName = CRAFT_GetData ("IndividualApp_Portal_Data","LastName")
Browser("Start your Application").Page("Optum ID - Registration").WebEdit("userRegistrationId:lastName").Set LastName

'Selecting Suffix'
Suffix = CRAFT_GetData ("IndividualApp_Portal_Data","Suffix")
Browser("Start your Application").Page("Optum ID - Registration").WebEdit("userRegistrationId:suffix").Set Suffix


'Entering the Year of Birth'
YearofBirth = CRAFT_GetData ("IndividualApp_Portal_Data","YearOfBirth")
Browser("Start your Application").Page("Optum ID - Registration").WebEdit("userRegistrationId:yobId").Set YearofBirth


'Entering the Email ID'
EmailID =  CRAFT_GetData ("IndividualApp_Portal_Data","EmailID")
Browser("Start your Application").Page("Optum ID - Registration").WebEdit("userRegistrationId:email").Set EmailID


'Confirming the Email ID'
ConfirmEmailID = CRAFT_GetData ("IndividualApp_Portal_Data","EmailID")
Browser("Start your Application").Page("Optum ID - Registration").WebEdit("userRegistrationId:confirmEmai").Set ConfirmEmailID


'Entering the UserID'
UserName = CRAFT_GetData ("IndividualApp_Portal_Data","UserName")
Browser("Start your Application").Page("Optum ID - Registration").WebEdit("userRegistrationId:userNameId").Set UserName


'Entering Password'
Password = CRAFT_GetData ("IndividualApp_Portal_Data","Password1")
Browser("Start your Application").Page("Optum ID - Registration").WebEdit("userRegistrationId:pwd").Set Password


'Entering Password'
ConfirmPassword = CRAFT_GetData ("IndividualApp_Portal_Data","Password1")
Browser("Start your Application").Page("Optum ID - Registration").WebEdit("userRegistrationId:confirmPwd").Set ConfirmPassword

'Entering Mobile Phone Number
MobilePhone = CRAFT_GetData ("IndividualApp_Portal_Data","MobilePhone")
Browser("Start your Application").Page("Optum ID - Registration").WebEdit("userRegistrationId:mobilePhone").Set MobilePhone

'Selecting the Security Question 1
SecurityQ1 = CRAFT_GetData ("IndividualApp_Portal_Data","SecurityQ1")
Browser("Start your Application").Page("Optum ID - Registration").WebList("userRegistrationId:securityQue").Select SecurityQ1

'Entering the Answer for the Security Question 1
SecurityA1 = CRAFT_GetData ("IndividualApp_Portal_Data","SecurityA1")
Browser("Start your Application").Page("Optum ID - Registration").WebEdit("userRegistrationId:securityAns").Set SecurityA1


'Selecting the Security Question 2
SecurityQ2 = CRAFT_GetData ("IndividualApp_Portal_Data","SecurityQ2")
Browser("Start your Application").Page("Optum ID - Registration").WebList("userRegistrationId:securityQue_2").Select SecurityQ2

'Entering the Answer for the Security Question 2
SecurityA2 = CRAFT_GetData ("IndividualApp_Portal_Data","SecurityA2")
Browser("Start your Application").Page("Optum ID - Registration").WebEdit("userRegistrationId:securityAns_2").Set SecurityA2

'Selecting the Security Question 3
SecurityQ3 = CRAFT_GetData ("IndividualApp_Portal_Data","SecurityQ3")
Browser("Start your Application").Page("Optum ID - Registration").WebList("userRegistrationId:securityQue_3").Select SecurityQ3

'Entering the Answer for the Security Question 2
SecurityA3 = CRAFT_GetData ("IndividualApp_Portal_Data","SecurityA3")
Browser("Start your Application").Page("Optum ID - Registration").WebEdit("userRegistrationId:securityAns_3").Set SecurityA3

'Clicking on the checkbox to agree to the terms & conditions
Browser("Start your Application").Page("Optum ID - Registration").WebCheckBox("userRegistrationId:tcChkBox1").Set "ON"

'Clicking on the continue button to be navigated to the account Confirmation code page.
Browser("Start your Application").Page("Optum ID - Registration").WebButton("Continue").Click

End Sub


'###########################################################################################################################################
'Function Name			:	CreateProfileIntendedtomoveMA
'Description			:	To Create a profile who want to move to MA in near future
'Input Value			:	None
'Author					:	Cigniti Inc
'Create Date			:	07/21/2015
'###########################################################################################################################################

Sub HouseHoldContactInfomovetoMA()

	On Error Resume Next
	
	Set gobjPath = Browser("title:=.*Individual & Families.*").Page("title:=.*Individual & Families.*")
	Browser("title:=.*Individual & Families.*").sync
	
	If gobjPath.Exist(5) Then
	
		strHouseHoldFirstName = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant1_FirstName")
		EnterData "html id:=eligibilityMember0.name.firstName", strHouseHoldFirstName, "HouseHold First Name"

		strHouseHoldMidName = (CRAFT_GetData ("IndividualApp_Portal_Data","Applicant1_MiddleName"))
		EnterData "html id:=eligibilityMember0.name.middleName", strHouseHoldMidName, "HouseHold Middle Name"

		strHouseHoldLastName = (CRAFT_GetData ("IndividualApp_Portal_Data","Applicant1_LastName"))
		EnterData "html id:=eligibilityMember0.name.lastName", strHouseHoldLastName, "HouseHold Last Name"

		'strHouseHoldSuffix = (CRAFT_GetData ("IndividualApp_Portal_Data","Suffix"))		'Yet to update....
		'SelectData "name:=eligibilityMember\[0\].name.suffix;innertext:=SuffixJr.Sr.IIIIV", strHouseHoldSuffix

		'Entering Date of Birth
		strHouseHoldDOB = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant1_DOB")
		EnterData "html id:=eligibilityMember0.dateOfBirth", strHouseHoldDOB, "HouseHold DOB"
		
		ClickCheckBox "html id:=no_primary_address"
		
		CliclCheckBox "html id:=intendToReside"
		
		
		'Entering data into Home Address1 field 
		strHouseHoldAddress1 = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant1_HomeAddress1")
		EnterData "html id:=eligibilityMember\[0\].contactInfo.secondaryAddress.streetAddress1",strHouseHoldAddress1,"House Hold Address - 1"
	
		TINYWAIT
		'Entering data into HomeCity field
		strHouseHoldCity = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant1_HomeCity")
		EnterData "html id:=eligibilityMember\[0\].contactInfo.secondaryAddress.city", strHouseHoldCity, "House Hold City"
	
		'Entering data into HomeZip field
		strHouseHoldZip = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant1_HomeZip")
		'EnterData "name:=userProfile.contactInfo.primaryAddress.zip;html id:=userProfile.contactInfo.primaryAddress.zip;html tag:=INPUT",HomeZip, HomeZip
		gobjPath.WebEdit("html id:=eligibilityMember\[0\].contactInfo.secondaryAddress.zip").Click
		TINYWAIT
		CF_sendKeys "METHOD-B", "", strHouseHoldZip
		TINYWAIT
	
		'Selecting the Home Count from the selectlist
		strHouseHoldCounty = CRAFT_GetData ("IndividualApp_Portal_Data","Applicant1_HomeCounty")
		SelectData "html id:=eligibilityMember\[0\].contactInfo.secondaryAddress.county",strHouseHoldCounty
		TINYWAIT
	
		'Entering the Primary Phone Number	
		strHouseHoldPrimaryPhone = Trim(CRAFT_GetData ("IndividualApp_Portal_Data","Applicant1_PrimaryPhone"))
		myDeviceReplay.SendString PrimaryPhone
		gobjPath.WebEdit("html id:=eligibilityMember0.contactInfo.primaryPhoneNumber_0").Click
		TINYWAIT
		CF_sendKeys "METHOD-B", "", strHouseHoldPrimaryPhone
		TINYWAIT
	
		'Click Save and Continue
		ClickButton "name:=Save and Continue","Continue"
		SHORTWAIT
		Browser("title:=.*Individual & Families.*").sync
		
		CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
			"Head of Household Contact Information", "'HouseHold Intended Contact Details' Screen is displayed in Browser, as Expected", "Pass"	
	Else
		CRAFT_ReportEvent Environment.Value ("ReportedEventSheet"),_
			"Head of Household Contact Information", "'Household Intended Contact Details' Screen is not displayed in Browser, Not as Expected", "Fail"	
	End If	

End Sub