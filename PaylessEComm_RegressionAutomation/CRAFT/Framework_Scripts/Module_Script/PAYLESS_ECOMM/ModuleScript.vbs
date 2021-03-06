Class ModuleScript

'********************************************************************************************************************************************************
'FUNCTION HEADER
'********************************************************************************************************************************************************
'Name: FnClickLinkAndVerify
'Description: This function is used to click on a set of links passed from the excel as inpu and check if they lead to a page containing products. 
'Verification can be in the form of checking a Web Element with the clicked link's name or the display of atleast a product. This is passed as a Parameter
'Input: Obj, Object Name, strInputValue, strOpt_Param, strOpt_Param, clsReport, objEnvironmentVariables, clsScreenShot, iRowCnt, Screen_shot_path, strSheet_Name, strLabel, strExpectedValue, strTestDataReference
'The type of checking would be passed under the strOptParam Eg: Just to check if the link has gone to the correct page (i.e. Bread Crumb) pass the value as BREADCRUMB
'If the type of checking is Product, pass the value as PRODUCT
'Creation Date : 26-Mar-2010
'Created By: Ramgopal Narayanan (229673)
'Application: PAYLESS ECOM
'Output: Returns nothing
'Note: If strTestDataReference=OPTIONAL, report wil throw an error saying link doesn't exist
'********************************************************************************************************************************************************
	Function FnClickLinkAndVerify(ByRef objsub , ByVal Object_Name, ByVal strInputValue, ByVal strDbValue, ByVal strOptParam, ByRef clsReport, ByRef objEnvironmentVariables ,	ByRef clsScreenShot ,ByVal iRowCnt ,ByVal Screen_shot_path ,ByVal strSheet_Name ,ByVal strLabel , ByVal strExpectedValue , ByVal strTestDataReference, ByVal ModuleName) 


								
	   							Set obj = objsub.Link(Object_Name)	

								strTempDR=Split(strTestDataReference,":")
								strLnkRef=Trim(strTempDR(1))
								If UCASE(strLnkRef)="MEN" Then
									strLink="lnkMen"
								ElseIF UCASE(strLnkRef)="WOM" Then
									strLink="lnkWomen"
								ElseIF UCASE(strLnkRef)="KID" Then
									strLink="lnkKids"	
								ElseIF UCASE(strLnkRef)="APP" Then
									strLink="lnkApparel"
								ElseIF UCASE(strLnkRef	)="PRO" Then ' For prokeds Ram - 28-May-2010
									strLink="lnkProKedsProducts_Main"

								'Ram  Aug-2-2010 - The following 4 categories are for Grasshoppers
								'*****************************************************************************
								ElseIF UCASE(strLnkRef)="ACTIVE" Then
												strLink="lnkActive"    
								ElseIF UCASE(strLnkRef)="CASUALS" Then
												strLink="lnkCasuals"    
								ElseIF UCASE(strLnkRef)="PUREFIT" Then
												strLink="lnkPureFit"    
								ElseIF UCASE(strLnkRef)="LASTCHANCE" Then
												strLink="lnkLastChance"    
								 '*****************************************************************************

								ElseIF UCASE(strLnkRef)="NONE" Then
									strLink="None"
								End If
								fProdStatus=""
								
								If strDbValue<>"" Then
									fInputValue=strDbValue
 								ElseIf strInputValue<>"" Then
									fInputValue=strInputValue
								End If

                                                	
								fArrayInputValue=Split(fInputValue,":")
								For arrCount=0 to UBOUND(fArrayInputValue)
									arrValue=fArrayInputValue(arrCount)

									'Split to get the index of the value
									fArrValue=Split(arrValue,"_")
									If ModuleName<>"Grasshoppers" Then
											'1. Set the text
										obj.setTOProperty "text",TRIM(fArrValue(0))
	
										'2.Check for the index and set the
										If  UBOUND(fArrValue)>0 Then
											obj.setTOProperty "index",TRIM(fArrValue(1)	)
										Else
											obj.setTOProperty "index","0"
										End If 
									End If
									
									'Check if the obj exists with the properties defined above
									'*8**************************************************************

									If UCase(CStr(obj.Exist(0))) OR UCase(obj.Exist(0))Then
										obj.Click


										'Check if the validation based on the product
										'****************************************************
					
										If  UCASE(TRIM(strOptParam))="PRODUCT" Then

											'Check for atleast one product

											Set fObjProd=Browser("brwMain").Page("pgeProductList").WebElement("elmProductList")
											
											If fObjProd.Exist(5)  Then

												fProductList = fObjProd.GetROProperty ("outertext")
												arrProduct = Split (fProductList , "$", -1, 1)
												fProductName = arrProduct (0)

												'Write the result if atleast one product exists
												'************************************************
												strDesc ="CLICKLINKANDVERIFY: Link " & chr(34) &  TRIM(fArrValue(0)) & chr(34) & " is clicked and correspoding page is displayed with atleast one product of  value : " & chr(34) & fProductName & chr(34) & "."
												clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
												Reporter.Filter = rfEnableAll 
												Reporter.ReportEvent micPass,"Step CLICKLINKANDVERIFY", strDesc
												Reporter.Filter = rfDisableAll
												Set fObjProd=Nothing


											'Added to handle if the Thank You Dialog gets displayed at random

												If Browser("brwMain").Page("pgeGeneral").WebElement("elmThankYou").Exist(1) Then
													Browser("brwMain").Page("pgeGeneral").WebButton("btnNoThanks").Click
												End If
												If strLink<>"None" Then
													Browser("brwMain").Back		
													Browser("brwMain").Page("pgeMain").Link(strLink).Click		
												End If							

'												Browser("brwMain").Sync
												Wait 5
											Else
		
												'In case no product gets displayed, check for the bread crumbs
												fProdStatus = "Yes"
												Set fObjBC=Browser("brwMain").Page("pgeProductList").WebElement("elmCategoryName")
												If INSTR(fArrValue(0),"View All ")>0 Then
													fTemp=Split(fArrValue(0),"View All")
													fArrValue(0)=Trim(fTemp(1))
	
													'Split again with space
													fTempValue=Split(fArrValue(0)," ")
		
													If UBOUND(fTempValue)>0 Then
													fObjBC.SetTOProperty "innertext",TRIM(fTempValue(0)) & ".*"
													Else
														fObjBC.SetTOProperty "innertext",TRIM(fArrValue(0)) & ".*"

													End If

												Else
													fObjBC.SetTOProperty "innertext",TRIM(fArrValue(0)) & ".*"

												End If
												
												If  fObjBC.Exist(5) Then

													If fProdStatus<>"" Then
														strDesc ="CLICKLINKANDVERIFY: Link " & chr(34) &  TRIM(fArrValue(0)) & chr(34) &" is clicked and the <b><Font color=RED>corresponding page is displayed, but without any products</b></Font>"
													Else
														strDesc ="CLICKLINKANDVERIFY: Link " & chr(34) &  TRIM(fArrValue(0)) & chr(34) &" is clicked and the corresponding page is displayed."
													End If
													
													clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
													Reporter.Filter = rfEnableAll 
													Reporter.ReportEvent micPass,"Step CLICKLINKANDVERIFY", strDesc
													Reporter.Filter = rfDisableAll
													Set fObjBC=Nothing

													'Added to handle if the Thank You Dialog gets displayed at random
													If Browser("brwMain").Exist(0) Then '
														If Browser("brwMain").Page("pgeGeneral").WebElement("elmThankYou").Exist(1) Then
															Browser("brwMain").Page("pgeGeneral").WebButton("btnNoThanks").Click
														End If
													End If 
													If strLink<>"None" Then
														Browser("brwMain").Back		
														Browser("brwMain").Page("pgeMain").Link(strLink).Click		
													End If
'													Browser("brwMain").Sync
													Wait 5
												Else

													If fProdStatus<>"" Then
														strDesc ="CLICKLINKANDVERIFY: Link " & chr(34) &  TRIM(fArrValue(0)) & chr(34) &" is clicked and no products are displayed."
													Else
														strDesc ="CLICKLINKANDVERIFY: Link " & chr(34) &  TRIM(fArrValue(0)) & chr(34) &" is clicked and the corresponding page is not displayed."
													End If
                                                    clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
													clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
													Reporter.Filter = rfEnableAll 
													Reporter.ReportEvent micFail,"Step CLICKLINKANDVERIFY", strDesc
													objEnvironmentVariables.TestCaseStatus=False
													Reporter.Filter = rfDisableAll
													Set fObjBC=Nothing
													

													'Added to handle if the Thank You Dialog gets displayed at random
													If Browser("brwMain").Exist(0) Then '
														If Browser("brwMain").Page("pgeGeneral").WebElement("elmThankYou").Exist(1) Then
															Browser("brwMain").Page("pgeGeneral").WebButton("btnNoThanks").Click
														End If
													End If 
													If strLink<>"None" Then
														Browser("brwMain").Back		
														Browser("brwMain").Page("pgeMain").Link(strLink).Click		
													End If
'													Browser("brwMain").Sync
													Wait 5
												End If
											End If
										ElseIf UCASE(TRIM(strOptParam))="BREADCRUMB" Then

											Set fObjBC=Browser("brwMain").Page("pgeProductList").WebElement("elmCategoryName")

											If INSTR(fArrValue(0),"View All ")>0 Then
												fTemp=Split(fArrValue(0),"View All")
												fArrValue(0)=Trim(fTemp(1))

												'Split again with space
												fTempValue=Split(fArrValue(0)," ")

					If UBOUND(fTempValue)>0 Then
							
												fObjBC.SetTOProperty "innertext",TRIM(fTempValue(0)) & ".*"
												Else
													fObjBC.SetTOProperty "innertext",TRIM(fArrValue(0)) & ".*"
			
				End If

						

											Else
												fObjBC.SetTOProperty "innertext",TRIM(fArrValue(0)) & ".*"

											End If

											If  fObjBC.Exist(3) Then
							
												strDesc ="CLICKLINKANDVERIFY: Link " & chr(34) &  fArrValue(0) & chr(34) &" is clicked and the corresponding page is displayed."
												clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
												Reporter.Filter = rfEnableAll 
												Reporter.ReportEvent micPass,"Step CLICKLINKANDVERIFY", strDesc
												Reporter.Filter = rfDisableAll
												Set fObjBC=Nothing												

												'Added to handle if the Thank You Dialog gets displayed at random
												If Browser("brwMain").Exist(0) Then '
													If Browser("brwMain").Page("pgeGeneral").WebElement("elmThankYou").Exist(1) Then
														Browser("brwMain").Page("pgeGeneral").WebButton("btnNoThanks").Click
													End If
												End If 
												If strLink<>"None" Then
													Browser("brwMain").Back		
													Browser("brwMain").Page("pgeMain").Link(strLink).Click		
												End If
'												Browser("brwMain").Sync
												Wait 5
											Else
												strDesc ="CLICKLINKANDVERIFY: Link " & chr(34) & fArrValue(0) & chr(34) &" is clicked and the corresponding page is not displayed."
												clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
												clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
												Reporter.Filter = rfEnableAll 
												Reporter.ReportEvent micFail,"Step CLICKLINKANDVERIFY", strDesc
												objEnvironmentVariables.TestCaseStatus=False
												Reporter.Filter = rfDisableAll
												Set fObjBC=Nothing

													'Added to handle if the Thank You Dialog gets displayed at random
												If Browser("brwMain").Exist(0) Then '
													If Browser("brwMain").Page("pgeGeneral").WebElement("elmThankYou").Exist(1) Then
														Browser("brwMain").Page("pgeGeneral").WebButton("btnNoThanks").Click
													End If
												End If 
												If strLink<>"None" Then
													Browser("brwMain").Back		
													Browser("brwMain").Page("pgeMain").Link(strLink).Click		
												End If
'												Browser("brwMain").Sync
												Wait 5
											End If
										End If				
									Else

										If  UCASE(TRIM(strTempDR(0)))<>"OPTIONAL" Then
											strDesc ="CLICKLINKANDVERIFY: Link " & chr(34) & fArrValue(0) & chr(34) &" doesn't exist as expected. So CLICK action is not performed on that."
											clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1 & fArrValue(0),objEnvironmentVariables
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micFail,"Step CLICKLINKANDVERIFY", strDesc
											objEnvironmentVariables.TestCaseStatus=False
											Reporter.Filter = rfDisableAll
										End If
									End If

										'Added to handle if the Thank You Dialog gets displayed at random
									If Browser("brwMain").Exist(0) Then '
										If Browser("brwMain").Page("pgeGeneral").WebElement("elmThankYou").Exist(1) Then
											Browser("brwMain").Page("pgeGeneral").WebButton("btnNoThanks").Click
										End If
									End If 
								Next														
                                Set obj = Nothing
                                strDbValue=""
								strInputValue=""
		End Function
'========================================================================================================================================================
''********************************************************************************************************************************************************
'FUNCTION HEADER
'********************************************************************************************************************************************************
'Name: FnRemoveitemFromBag
'Description: This function is used to remove all the items from the shopping bag
'Input: Obj, Object Name, strInputValue, strOpt_Param, strOpt_Param, clsReport, objEnvironmentVariables, clsScreenShot, iRowCnt, Screen_shot_path, strSheet_Name, strLabel, strExpectedValue, strTestDataReference
'Creation Date : 30-Mar-2010
'Created By: Fayis.K (229680)
'Application: PAYLESS ECOM
'Output: Returns nothing
'********************************************************************************************************************************************************

                                Function FnRemoveitemFromBag(ByRef objsub , ByVal Object_Name, ByVal strInputValue, ByVal strDbValue, ByVal strOptParam, ByRef clsReport, ByRef objEnvironmentVariables ,         ByRef clsScreenShot ,ByVal iRowCnt ,ByVal Screen_shot_path ,ByVal strSheet_Name ,ByVal strLabel , ByVal strExpectedValue , ByVal strTestDataReference) 

												
												Set obj = Browser("brwMain").Page("pgeMain")
												'Set obj = objsub
												errFlg = false
												removeAction = false

												'To remove some items

												If  obj.Image("imgViewBag").Exist(3) Then  'For Saucony
													obj.Image("imgViewBag").Click
													removeAction = true
												Elseif obj.Link("lnkitem").Exist(3) Then 'For sperry
													obj.Link("lnkItem").Click
													removeAction = true
												End if

					
															If removeAction Then
																	 If UCASE(TRIM(strInputValue)) = "" OR UCASE(TRIM(strInputValue)) ="ALL" Then
																		itemCnt=0
					
																		Do 
																						If  obj.Link("lnkRemove").Exist(3) Then
'																							Browser("brwMain").Sync
																							Wait 5
																							obj.Link("lnkRemove").Click
'																							Browser("brwMain").Sync
																							Wait 5
																							itemCnt = itemCnt + 1
																							If obj.WebElement ("elmErrorRemovingItem").Exist(3) Then
																								'strError=obj.WebElement ("elmErrorRemovingItem").GetROProperty("outertest")
									
																								errFlg = true
																								Exit Do
																							End If
																						End If	''  if error occurred while removing item
					
																		Loop While obj.Link("lnkRemove").Exist(3)
					
														
														Else 'Remove n items 
			
																	While (strInputValue AND obj.Link("lnkRemove").Exist(3) )
                                                                        		obj.Link("lnkRemove").Click
																				itemCnt = itemCnt + 1
																				If obj.WebElement ("elmErrorRemovingItem").Exist(3) Then
																								'strError=obj.WebElement ("elmErrorRemovingItem").GetROProperty("outertest")
									
																				               errFlg = true
																								'Wend
																					End If
																					strInputValue=strInputValue-1

																	Wend
														End If
													End If 


                                                'report
											If  NOT(errFlg) Then
										
                                                If removeAction Then
                                                                'Added by Fayis  30-3-10 - 
                                                                strDesc ="REMOVEITEMS: " & chr(34) & itemCnt & chr(34) & " item(s) are removed from the shoping bag."
                                                                clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
                                                                Reporter.Filter = rfEnableAll 
                                                                Reporter.ReportEvent micPass,"Step REMOVEITEMS", strDesc
                                                                Reporter.Filter = rfDisableAll
                                                Else
                                                   strDesc ="REMOVEITEMS: No item found in the shoping bag."
                                                                clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
                                                                Reporter.Filter = rfEnableAll 
                                                                Reporter.ReportEvent micPass,"Step REMOVEITEMS", strDesc
                                                                Reporter.Filter = rfDisableAll
                                                End if
											Else 
														'if error occurred while removing

														strDesc = "<b><Font color=RED size=2> REMOVEITEMS: at the row number "&iRowCnt+1&" cannot be performed. Error occured whilst removing.</b></Font>"
														Err.Raise 1
														Reporter.Filter = rfEnableAll 
														Reporter.ReportEvent micFail,"Step REMOVEITEMS ", strDesc
														objEnvironmentVariables.TestCaseStatus=False 
														Reporter.Filter = rfDisableAll
														clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables				   	
														clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
														Browser("brwMain").Close 'Close the browser
												
											End if

                                                Set obj=Nothing
                                End Function
'========================================================================================================================================================
'
'********************************************************************************************************************************************************
'FUNCTION HEADER
'********************************************************************************************************************************************************
'Name: FnValidateProductFlags
'Description: This function is used to validate the flags displayed in the product page from a list of flags
'Input: Obj, Object Name, strInputValue, strOpt_Param, strOpt_Param, clsReport, objEnvironmentVariables, clsScreenShot, iRowCnt, Screen_shot_path, strSheet_Name, strLabel, strExpectedValue, strTestDataReference
'Input : List of Flags from the data excel
'Creation Date : 30-Mar-2010
'Created By: Ramgopal Narayanan (229673)
'Application: PAYLESS ECOM
'Output: Returns nothing
'********************************************************************************************************************************************************

		Function FnValidateProductFlags(ByRef objsub , ByVal Object_Name, ByVal strInputValue, ByVal strDbValue, ByVal strOptParam, ByRef clsReport, ByRef objEnvironmentVariables ,	ByRef clsScreenShot ,ByVal iRowCnt ,ByVal Screen_shot_path ,ByVal strSheet_Name ,ByVal strLabel , ByVal strExpectedValue , ByVal strTestDataReference) 

				If objsub.Link("lnkViewAll").Exist(3) Then
					objsub.Link("lnkViewAll").Click
'					Browser("brwMain").Sync
					Wait 10
				End If

				Set obj = objsub.WebElement(Object_Name)	

				If strDbValue<>"" Then
					fInputValue=strDbValue
				ElseIf strInputValue<>"" Then
					fInputValue=strInputValue
				End If

				arrInputValue=Split(fInputValue,":")
				For arrCount=0 to UBOUND(arrInputValue)
					arrValue=Trim(arrInputValue(arrCount))
					obj.SetTOProperty "innertext",arrValue
					If obj.Exist(5) Then
						obj.Highlight
						strDesc ="VERIFYPRODUCTFLAGS: The Product Flag - " & chr(34) & arrValue & chr(34) & " is available under the Products page."
						clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
						Reporter.Filter = rfEnableAll 
						Reporter.ReportEvent micPass,"Step VERIFYPRODUCTFLAGS", strDesc
						Reporter.Filter = rfDisableAll
					End If
				Next
					strDbValue=""
					strInputValue=""
		End Function
'========================================================================================================================================================
'********************************************************************************************************************************************************
'FUNCTION HEADER
'********************************************************************************************************************************************************
'Name: FnValidateProductDetails
'Description: This function is used to validate the certain product details in the product details and add to bag page based on the key words passed
'Input: Obj, Object Name, strInputValue, strOpt_Param, strOpt_Param, clsReport, objEnvironmentVariables, clsScreenShot, iRowCnt, Screen_shot_path, strSheet_Name, strLabel, strExpectedValue, strTestDataReference
'Input : Object Name, Detail that needs to be verified, TRUE/FALSE
'Creation Date : 31-Mar-2010
'Created By: Ramgopal Narayanan (229673)
'Application: PAYLESS ECOM
'Output: Returns nothing
'********************************************************************************************************************************************************

	Function FnValidateProductDetails(ByRef objsub , ByVal Object_Name, ByVal strInputValue, ByVal strDbValue, ByVal strOptParam, ByRef clsReport, ByRef objEnvironmentVariables ,         ByRef clsScreenShot ,ByVal iRowCnt ,ByVal Screen_shot_path ,ByVal strSheet_Name ,ByVal strLabel , ByVal strExpectedValue , ByVal strTestDataReference, ByVal ModuleName)

                                                'Get the Test Data Reference
                                                fTDRef=Trim(strTestDataReference)
                                                isFirefox=False
                                                'Get the appropriate input value and split it accordingly
                                                '***************************************************************
                                                fArrInputValue=Split(strInputValue,":")
                                                If UBOUND(fArrInputValue)>0 Then
                                                                'Check for the ENV Value
                                                                If  UCASE(TRIM(fArrInputValue(0)))="ENV" Then
                                                                                fInputValue=Environment.Value( Trim( fArrInputValue(1) ) )
                                                                End If
                                                Else
                                                                'If not in array then assign direcly
                                                                fInputValue=Trim(strInputValue)
                                                End If
                                                
                                                'Get what needs to be checked
                                                '********************************
                                                Select Case UCASE(TRIM(strOptParam))
                                                                Case "REG_PRICE"
                                                                                Set obj=objsub.WebElement(Object_Name)
                                                                                obj.SetTOProperty "innertext","Reg.$" & fInputValue
                                                                                If  fTDRef<>"" Then
                                                                                                obj.SetTOProperty "html tag",TRIM(fTDRef)
                                                                                End If
                                                                                fObjType="Web Element"

                                                                Case "SALE_PRICE"
                                                                                Set obj=objsub.WebElement(Object_Name)
                                                                                obj.SetTOProperty "innertext","$" & fInputValue
                                                                                fObjType="Web Element"

                                                                 Case "PRODUCT_PRICE"
                                                                                                                                                                                                                                                                                                                   
                                                                                 Set obj=objsub.WebElement(Object_Name)
																				 If  LEFT(fInputValue,1)="$" Then
																												obj.SetTOProperty "innertext",fInputValue
																				 Else
																								obj.SetTOProperty "innertext","$" & fInputValue
																				 End If

                                                                                fObjType="Web Element"
                                                                                If  fTDRef<>"" Then
                                                                                                obj.SetTOProperty "html tag",TRIM(fTDRef)
                                                                                End If
                                                                                                                                                                                                                                                                                                                                '''
                                                                                                                                                                                                                                                                                                                                ''

                                                                 Case "STOCK_NUMBER"
                                                                                 Set obj=objsub.WebElement(Object_Name)
                                                                                 obj.SetTOProperty "innertext","Stock#:" & fInputValue
                                                                                 fObjType="Web Element"

                                                                 Case "ELEMENT_COLOR"
																		If Environment.Value ("BrowserName")="Firefox" Then
																						isFirefox=True
											
																		Else
																						 Set obj=objsub.WebElement(Object_Name)
																		fActualColorValue=TRIM(obj.Object.currentStyle.color)
																		fObjType="Web Element"
																		fVerifyColor="Yes"
																		End If

                                                                  Case "VERIFY_ITEMS_TOTAL"

																	Set obj=objsub.WebElement(Object_Name)
																	fTDRef=CSTR(fTDRef)                    
																	If ModuleName="Sperry" OR ModuleName = "Grasshoppers" Then
																	fInnerText="Items in your shopping cart (" & fTDRef & ")"
																	Else
																	fInnerText="Items in your shopping bag (" & fTDRef & ")"
																	End If
																	
																	obj.SetTOProperty "html tag","H2"
																	obj.SetTOProperty "innertext",fInnerText
																	fInputValue=fInnerText
                                                                  Case "VERIFY_TOTAL"
                                                                                                                                                                                                                                                                                  '
												fTotal=CINT(fTDRef)*CDBL(fInputValue)               
							
																			fFinalTotal=fTotal
                                                                                                                                                                                                                                                                                                                                                                                                

																			arrTemp=Split(fFinalTotal,".")
																			If UBOUND(arrTemp)>0 Then
																			'With decimal but multiples of 10
																			If  LEN(arrTemp(1))=1Then
																			fFinalTotal=arrTemp(0) &"." & arrTemp(1) &"0"
																			End If
																			Else 'whole number
																			fFinalTotal=arrTemp(0) & ".00"
																			End If
                                                                                  Set obj=objsub.WebElement(Object_Name)


                                                                                'Main Total
                                                                                '************
																					obj.SetTOProperty "html tag","TD"
																					obj.SetTOProperty "index","0"
																					fInnerText="$" & fFinalTotal
													
																					obj.SetTOProperty "innertext", fInnerText
         
         
                                                                                                                                                                                                                                                                                                '
                                                                                                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                                
                                                                                  If Obj.Exist(5) Then                                                                                       
                                                                                                                                strDesc ="VALIDATEPRODUCTDETAILS: The main total for the product is displayed as " & chr(34) & fInnerText & chr(34) & "."
                                                                                                                                clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
                                                                                                                                Reporter.Filter = rfEnableAll 
                                                                                                                                Reporter.ReportEvent micPass,"Step VALIDATEPRODUCTDETAILS", strDesc
                                                                                                                                Reporter.Filter = rfDisableAll
                                                                                                Else
                                                                                                                strDesc ="VALIDATEPRODUCTDETAILS: The main total for the product is not displayed as " & chr(34) & fInnerText & chr(34) & "."
                                                                                                                clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
                                                                                                                clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
                                                                                                                Reporter.Filter = rfEnableAll 
                                                                                                                Reporter.ReportEvent micFail,"Step VALIDATEPRODUCTDETAILS", strDesc
                                                                                                                objEnvironmentVariables.TestCaseStatus=False
                                                                                                                Reporter.Filter = rfDisableAll  
                                                                                  End If

                                                                                  'Items Sub Total
                                                                                '********************
																				 obj.SetTOProperty "html tag","TD"
                                                                                  obj.SetTOProperty "index","1"
                                                                                  fInnerText="$" & fFinalTotal
                                                                                    obj.SetTOProperty "innertext", fInnerText
                                                                                  If Obj.Exist(5) Then                                                                                       
                                                                                                                                strDesc ="VALIDATEPRODUCTDETAILS: The sub total for the product is displayed as " & chr(34) & fInnerText & chr(34) & "."
                                                                                                                                clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
                                                                                                                                Reporter.Filter = rfEnableAll 
                                                                                                                                Reporter.ReportEvent micPass,"Step VALIDATEPRODUCTDETAILS", strDesc
                                                                                                                                Reporter.Filter = rfDisableAll
                                                                                                Else
                                                                                                                strDesc ="VALIDATEPRODUCTDETAILS: The sub total for the product is not displayed as " & chr(34) & fInnerText & chr(34) & "."
                                                                                                                clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
                                                                                                                clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
                                                                                                                Reporter.Filter = rfEnableAll 
                                                                                                                Reporter.ReportEvent micFail,"Step VALIDATEPRODUCTDETAILS", strDesc
                                                                                                                objEnvironmentVariables.TestCaseStatus=False
                                                                                                                Reporter.Filter = rfDisableAll  
                                                                                  End If

                                                                                 'Bag Summary
                                                                                '********************
                                                                                'Get the shipping order value
'                                                                                                                                                                                                                                                                                                                               Object_Name1="lstShippingMethod"
'                                                                                                                                                                                                                                                                                                                               Set objsub1=Browser("brwMain").Page("pgeShoppingBag")
'                                                                                Set obj1=objsub1.WebList(Object_Name1)

																				 Set obj1 = Browser("brwMain").Page("pgeShoppingBag").WebList("lstShippingMethod")
                                                                                fValue=obj1.GetRoProperty("value")
                                                                                fArrVal=Split(fValue,"$")
                                                                                fTempValue=Split(fArrVal(1),".")
                                                                                fShippingCharge=CINT(TRIM(fTempValue(0)))
                                                                                fFinalValue=CINT(fTotal)+Cint(fShippingCharge)
                                                                                fFinalValue=fFinalValue &".00"
																				 Set obj1=nothing

                                                                                obj.SetTOProperty "html tag","TD"
                                                                                  obj.SetTOProperty "index","2"
                                                                                  fInnerText="$" & fFinalTotal
                                                                                obj.SetTOProperty "innertext", fInnerText
                                                                                  If Obj.Exist(5) Then                                                                                       
                                                                                                                                strDesc ="VALIDATEPRODUCTDETAILS: The bag summary  for the product is displayed as " & chr(34) & fInnerText & chr(34) & "."
                                                                                                                                clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
                                                                                                                                Reporter.Filter = rfEnableAll 
                                                                                                                                Reporter.ReportEvent micPass,"Step VALIDATEPRODUCTDETAILS", strDesc
                                                                                                                                Reporter.Filter = rfDisableAll
                                                                                                Else
                                                                                                                strDesc ="VALIDATEPRODUCTDETAILS: The bag summary for the product is not displayed as " & chr(34) & fInnerText & chr(34) & "."
                                                                                                                clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
                                                                                                                clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
                                                                                                                Reporter.Filter = rfEnableAll 
                                                                                                                Reporter.ReportEvent micFail,"Step VALIDATEPRODUCTDETAILS", strDesc
                                                                                                                objEnvironmentVariables.TestCaseStatus=False
                                                                                                                Reporter.Filter = rfDisableAll  
                                                                                  End If

                                                End Select


                                                                If UCASE(TRIM(strOptParam))<>"VERIFY_TOTAL" Then

                                                                                                                'Get the color code
                                                                                                                '*********************
                                                                                                                If  UCASE(TRIM(strOptParam))="ELEMENT_COLOR" Then
																
																												If isFirefox<>True Then
											
																												Select Case UCASE(strInputValue)
																												Case "RED"
																												fExpectedColorValue="#ba0f0f~#c30505~#b50937"
																												fExpectedColorValue1="#c30505"
																												fExpectedColorValue2="#b50937"
																												
																												Case "GREY"
																												fExpectedColorValue="#666"
																												fExpectedColorValue1="#666"
																												fExpectedColorValue2="#333"
																												End Select
																												End If

                                                                                                                End If
                                                                
                                                                                                                'Get the value of strExpectedValue
                                                                                                                '****************************************
                                                                                                                If UCASE(TRIM(strExpectedValue))="" OR "TRUE" Then
                                                                                                                                fExpectedValue=True
                                                                                                                Else
                                                                                                                                fExpectedValue=False
                                                                                                                End If
                                                                
                                                                                                                'Check for the existance of the object
                                                                                                                '******************************************
                                                                                                                fColorMatched=False
                                                                                                                                                                                                                                                                                                                                                                                                                                                                
																												If Obj.Exist(5) Then
																
																												Obj.Highlight
																												
																												fObjectExist=True
																												
																												If  UCASE(TRIM(strOptParam))="ELEMENT_COLOR" AND isFirefox=False Then
																												If INSTR(TRIM(fExpectedColorValue),TRIM(fActualColorValue))>0 OR INSTR(TRIM(fExpectedColorValue1),TRIM(fActualColorValue))>0 OR INSTR(TRIM(fExpectedColorValue2),TRIM(fActualColorValue))>0 Then
																												fColorMatched=True
																												Else
																												fColorMatched=False
																												End If
																												End If
                                                                                                                Else
                                                                                                                                fObjectExist=False
                                                                                                                End If
                                                                
                                                                                                                'Print the report
                                                                                                                '*****************
                                                     
                                                                                                                                If fObjectExist Then ' Object TRUE
                                                                
                                                                                                                                                                If strExpectedValue then  ''TRUE CASE                   
                                                                
                                                                                                                                                                                                'Based on Color validation
                                                                                                                                                                                                If  fVerifyColor="Yes" AND isFirefox=False Then
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                If  fColorMatched=True Then
                                                                                                                                                                                                                                strDesc ="VALIDATEPRODUCTDETAILS: The product detail - " & chr(34) & strOptParam & chr(34) & " exists with the color value " & chr(34) & fInputValue & chr(34) & " for the corresponding product."
                                                                                                                                                                                                                                clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
                                                                                                                                                                                                                                Reporter.Filter = rfEnableAll 
                                                                                                                                                                                                                                Reporter.ReportEvent micPass,"Step VALIDATEPRODUCTDETAILS", strDesc
                                                                                                                                                                                                                                Reporter.Filter = rfDisableAll
                                                                                                                                                                                                                Else
                                                                                                                                                                                                                                strDesc ="VALIDATEPRODUCTDETAILS: The product detail - " & chr(34) & strOptParam & chr(34) & " doesn't exist with the color value " & chr(34) & fInputValue & chr(34) & " for the corresponding product, as expected"
                                                                                                                                                                                                                                clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
                                                                                                                                                                                                                                clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
                                                                                                                                                                                                                                Reporter.Filter = rfEnableAll 
                                                                                                                                                                                                                                Reporter.ReportEvent micFail,"Step VALIDATEPRODUCTDETAILS", strDesc
                                                                                                                                                                                                                                objEnvironmentVariables.TestCaseStatus=False
                                                                                                                                                                                                                                Reporter.Filter = rfDisableAll
                                                                                                                                                                                                                End If
																																																				Else
																																																				'General Report
																																																						If  isFirefox=False Then
																																																						
																																																				strDesc ="VALIDATEPRODUCTDETAILS: The product detail - " & chr(34) & strOptParam & chr(34) & " exists with the value " & chr(34) & fInputValue & chr(34) & " for the corresponding product."
																																																				clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
																																																				Reporter.Filter = rfEnableAll 
																																																				Reporter.ReportEvent micPass,"Step VALIDATEPRODUCTDETAILS", strDesc
																																																				Reporter.Filter = rfDisableAll
																																																						End If
                                                                                                                                                                                                End If
                                                                
                                                                                                                                                                Else 'FALSE CASE                               
                                                                                                                                                                                                                                                
                                                                                                                                                                                                If  fVerifyColor="Yes" AND isFirefox=False Then
                                                                                                                                                                                                                If  fColorMatched=True Then
                                                                                                                                                                                                                                strDesc ="VALIDATEPRODUCTDETAILS: The product detail - " & chr(34) & strOptParam & chr(34) & " exists with the color value " & chr(34) & fInputValue & chr(34) & " for the corresponding product, where it's not expected."
                                                                                                                                                                                                                                clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
                                                                                                                                                                                                                                clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
                                                                                                                                                                                                                                Reporter.Filter = rfEnableAll 
                                                                                                                                                                                                                                Reporter.ReportEvent micFail,"Step VALIDATEPRODUCTDETAILS", strDesc
                                                                                                                                                                                                                                objEnvironmentVariables.TestCaseStatus=False
                                                                                                                                                                                                                                Reporter.Filter = rfDisableAll
                                                                                                                                                                                                                Else
                                                                                                                                                                                                                                strDesc ="VALIDATEPRODUCTDETAILS: The product detail - " & chr(34) & strOptParam & chr(34) & " doesn't exist with the color value " & chr(34) & fInputValue & chr(34) & " for the corresponding product, as expected."
                                                                                                                                                                                                                                clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
                                                                                                                                                                                                                                Reporter.Filter = rfEnableAll 
                                                                                                                                                                                                                                Reporter.ReportEvent micPass,"Step VALIDATEPRODUCTDETAILS", strDesc
                                                                                                                                                                                                                                Reporter.Filter = rfDisableAll
                                                                                                                                                                                                                End If
                                                                                                                                                                                                Else
                                                                                                                                                                                                                strDesc ="VALIDATEPRODUCTDETAILS: The product detail - " & chr(34) & strOptParam & chr(34) & " exist with the value " & chr(34) & fInputValue & chr(34) & " for the corresponding product, when it's not expected."                                                                                                                      
                                                                                                                                                                                                                clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
                                                                                                                                                                                                                clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
                                                                                                                                                                                                                Reporter.Filter = rfEnableAll 
                                                                                                                                                                                                                Reporter.ReportEvent micFail,"Step VALIDATEPRODUCTDETAILS", strDesc
                                                                                                                                                                                                                objEnvironmentVariables.TestCaseStatus=False
                                                                                                                                                                                                                Reporter.Filter = rfDisableAll
                                                                                                                                                                                                End If
                                                                                                                                                                                End If
                                                                                                                Else ' Object exists = FALSE 
                                                                                                                                If strExpectedValue then             'But its expected there
                                                                                                                                                                
                                                                                                                                                                strDesc ="VALIDATEPRODUCTDETAILS: The product detail - " & chr(34) & strOptParam & chr(34) & " doesn't exist with the value " & chr(34) & fInputValue & chr(34) & " for the corresponding product, where it's expected to be with the mentioned properties.."                                                                                                                        
                                                                                                                                                                clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
                                                                                                                                                                clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
                                                                                                                                                                Reporter.Filter = rfEnableAll 
                                                                                                                                                                Reporter.ReportEvent micFail,"Step VALIDATEPRODUCTDETAILS", strDesc
                                                                                                                                                                objEnvironmentVariables.TestCaseStatus=False
                                                                                                                                                                Reporter.Filter = rfDisableAll                                                                                      
                                                                                                                                Else
                                                                                                                                                                strDesc ="VALIDATEPRODUCTDETAILS: The product detail - " & chr(34) & strOptParam & chr(34) & " doesn't exists with the value " & chr(34) & fInputValue & chr(34) & " for the corresponding product, as expected"
                                                                                                                                                                clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
                                                                                                                                                                Reporter.Filter = rfEnableAll 
                                                                                                                                                                Reporter.ReportEvent micPass,"Step VALIDATEPRODUCTDETAILS", strDesc
                                                                                                                                                                Reporter.Filter = rfDisableAll                                                                                                                      
                                                                                                                                End If                                                                                    
                                                                                                                End If    
                                                                                End If    

                                                                                                                                                                                'For firefox 
                                                                                                                                                                                If isFirefox<>False Then
                                                                                                                                                                           
                                                                                                                                                                                                strDesc=  "</br><b><i><font size=3 color=red>" & "VALIDATEPRODUCTDETAILS - The property : " & chr(34) & strOptParam & chr(34) & " for the value " & chr(34) & fInputValue & chr(34) & " cannot be checked in FireFox, due to incompatibility."  &"</i></b></font>"
                                                                                                                                                                                                clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
                                                                                                                                                                                                Reporter.Filter = rfEnableAll 
                                                                                                                                                                                                Reporter.ReportEvent micDone,"", strDesc
                                                                                                                                                                                                Reporter.Filter = rfDisableAll         
                                                                                                                                                                                End If
       

                                End Function


'========================================================================================================================================================
'********************************************************************************************************************************************************
'FUNCTION HEADER
'********************************************************************************************************************************************************
'Name: FnVerifyBulkInsert
'Description: This function is used to perform bulk insert and check if the error message is displayed. If so take the next product and so on till bulk insert becomes successful
'Input: Obj, Object Name, strInputValue, strOpt_Param, strOpt_Param, clsReport, objEnvironmentVariables, clsScreenShot, iRowCnt, Screen_shot_path, strSheet_Name, strLabel, strExpectedValue, strTestDataReference
'Input : Value for Bulk Insert in inputvalue . If you want to skip the checking of inserted value then use OPTIONAL in testdata reference column
'Creation Date : 5-Apr-2010
'Created By: Ramgopal Narayanan (229673)
'Application: PAYLESS ECOM
'Output: Returns nothing

	Function FnVerifyBulkInsert(ByRef objsub , ByVal Object_Name, ByVal strInputValue, ByVal strDbValue, ByVal strOptParam, ByRef clsReport, ByRef objEnvironmentVariables ,         ByRef clsScreenShot ,ByVal iRowCnt ,ByVal Screen_shot_path ,ByVal strSheet_Name ,ByVal strLabel , ByVal strExpectedValue , ByVal strTestDataReference, ByVal ModuleName)			


			
			fQuantity=strInputValue
			If strOptParam<>"" AND UCASE(TRIM(strOptParam))="PROKEDS" Then
				Browser("brwMain").Page("pgeMain").Link("lnkProKedsProducts_Main").Click
			ElseIf strOptParam="GRASSHOPPERS" Then
				Browser("brwMain").Page("pgeMain").Link("lnkActive").Click
			Else
				Browser("brwMain").Page("pgeMain").Link("lnkWomen").Click
			End If		
			
			If ModuleName="Original" OR ModuleName="Performance" Then
				Browser("brwMain").Page("pgeMain").Link("lnkFootwear").Click
			ElseIf ModuleName="Sperry" Then
				Browser("brwMain").Page("pgeMain").Link("lnkShoes").Click
			ElseIf ModuleName="Keds" Then 'KEDS - Ram 28-5-10
				If strOptParam<>"" AND UCASE(TRIM(strOptParam))="PROKEDS" Then 'For Prokeds
					Browser("brwMain").Page("pgeMain").Link("lnkProKedsProducts_Category").Click
				Else
					Browser("brwMain").Page("pgeMain").Link("lnkProducts").Click 'if not prokeds just ordinary keds
				End If
			ElseIf ModuleName="Grasshoppers" Then
				'Do nothing as there's no sub category
			End If
			
			If  Browser("brwMain").Page("pgeProductList").Link("lnkViewAll").Exist(3) Then
				Browser("brwMain").Page("pgeProductList").Link("lnkViewAll").Click
			End If
			
			
			'Get the product list
			
			Set lnkObj = Description.Create()
			lnkObj("micclass").Value = "Link"
			lnkObj("html tag").Value = "A"
			strProducts=""
			Set obj=Browser("brwMain").Page("pgeProductList").WebElement("elmProductList").ChildObjects(lnkObj)
			For objCount=0 to obj.count-1
				strProdName=obj(objCount).getRoproperty("text")
				strProdHref=obj(objCount).getRoproperty("href")
				strProdProp=strProdName & "|" & strProdHref
				strProducts=strProducts & "~" & strProdProp
			Next
			
			'Iterate thru the products and check if theres any prod with excess value
			strProducts=RIGHT(strProducts,(LEN(strProducts)-1))
			arrProdValue=Split(strProducts,"~")
			Dim fBulkInsertDone:fBulkInsertDone=""
			For arrCount=0 to UBOUND(arrProdValue)
				fCount=arrCount
				arrProdProp=arrProdValue(arrCount)
					'Split the prop again
					arrIndivProp=Split(arrProdProp,"|")
				'1.Click on the product
				Set objGeneral=Browser("brwMain").Page("pgeProductList").Link("lnkProduct")
				objGeneral.SetTOProperty "text",arrIndivProp(0)
				objGeneral.SetTOProperty "href",arrIndivProp(1)
				objGeneral.Click
				Browser("brwMain").Sync
				Wait 5
			
				'2. Set the values for the size, width, more than 10 and bulk value as 11
				strShoeSize="5.0,5.5,6.0,6.5,7.0,7.5,8.0,8.5,9.0,9.5,10.0"
				arrShoeSz=Split(strShoeSize,",")
				For arrShoeSzCount=0 to UBOUND(arrShoeSz)
					If Browser("brwMain").Dialog("dlgError").Exist(3) Then
						Browser("brwMain").Dialog("dlgError").WinButton("btnOk").Click	
					End If
					fAllItems=Browser("brwMain").Page("pgeAddtoBag").WebList("lstSize").GetROProperty("all items")
					If INSTR(fAllItems,arrShoeSz(arrShoeSzCount))>0 Then
						Browser("brwMain").Page("pgeAddtoBag").WebList("lstSize").Select arrShoeSz(arrShoeSzCount)
						Wait 5
						strWdValues=TRIM(Browser("brwMain").Page("pgeAddtoBag").WebList("lstWidth").GetROProperty("all items"))
						strWdValues=REPLACE(strWdValues,";",":")
						arrWidVal=Split(strWdValues,"Width:")
						strWdValues=TRIM(arrWidVal(1))
						arrWidth=Split(strWdValues,":")

						Browser("brwMain").Page("pgeAddtoBag").WebList("lstWidth").Select arrWidth(0)
						Wait 5
						Browser("brwMain").Page("pgeAddtoBag").WebList("lstQuantity").Select "More than 10"		
						Wait 5
						Browser("brwMain").Page("pgeAddtoBag").WebEdit("edtMorethan10").Set fQuantity
'						Browser("brwMain").Sync
						Wait 5
						Browser("brwMain").Page("pgeAddtoBag").Image("imgAddtobag").Click
						If Browser("brwMain").Dialog("dlgError").Exist(3) Then
							Browser("brwMain").Dialog("dlgError").WinButton("btnOk").Click	
						End If
						''Check for the excess qty error - If so repleat the loop
						If Browser("brwMain").Page("pgeAddtoBag").WebElement("elmExceedsQuantityError").Exist(5)=FALSE Then
							If Browser("brwMain").Page("pgeShoppingBag").WebElement("elmYourShoppingBag").Exist(5) Then
								fBulkInsertDone="Yes"
								'Verify If the inserted quantity is being displayed under the shoping bag page
								fActual=Browser("brwMain").Page("pgeShoppingBag").WebElement("elmshoppingItems").GetROProperty("outertext")
								If ModuleName="Original" OR ModuleName="Performance" OR ModuleName="Keds" Then
									fExpected="Items in your shopping bag (" & fQuantity & ")"
								ElseIf ModuleName="Sperry" OR ModuleName="Grasshoppers" Then
									fExpected="Items in your shopping cart (" & fQuantity & ")"
								End If
								If strTestDataReference<>"OPTIONAL" Then
									If  TRIM(fActual)=TRIM(fExpected) Then
										strDesc ="VERIFYBULKINSERT: WebElement " & chr(34) & strLabel & chr(34) & " is displayed with the expected value : " & chr(34) & fExpected & chr(34) & "."
										clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
										Reporter.Filter = rfEnableAll 
										Reporter.ReportEvent micPass,"Step VERIFYBULKINSERT", strDesc
										Reporter.Filter = rfDisableAll
										Set fObjProd=Nothing
									Else
										strDesc ="VERIFYBULKINSERT: WebElement " & chr(34) & strLabel & chr(34) & " is displayed with the expected value : " & chr(34) & fExpected & chr(34) & ". Actual value that's displayed is " & chr(34)  & fActual & chr(34) & "."
										clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
										clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
										Reporter.Filter = rfEnableAll 
										Reporter.ReportEvent micFail,"Step VERIFYBULKINSERT", strDesc
										objEnvironmentVariables.TestCaseStatus=False
										Reporter.Filter = rfDisableAll
										Set fObjBC=Nothing	
									End If
								End If
								Exit For
							End If
						End iF
					End If
				Next	
				If fBulkInsertDone="Yes" Then
					Exit For
				Else
						If strOptParam<>"" AND UCASE(TRIM(strOptParam))="PROKEDS" Then
							Browser("brwMain").Page("pgeMain").Link("lnkProKedsProducts_Main").Click
						ElseIf strOptParam="GRASSHOPPERS" Then
							Browser("brwMain").Page("pgeMain").Link("lnkActive").Click
						Else
							Browser("brwMain").Page("pgeMain").Link("lnkWomen").Click
						End If		
						If ModuleName="Original" OR ModuleName="Performance" Then
							Browser("brwMain").Page("pgeMain").Link("lnkFootwear").Click
						ElseIf ModuleName="Sperry" Then
							Browser("brwMain").Page("pgeMain").Link("lnkShoes").Click
						ElseIf ModuleName="Keds" Then 'KEDS - Ram 28-5-10
							If strOptParam<>"" AND UCASE(TRIM(strOptParam))="PROKEDS" Then 'For Prokeds
								Browser("brwMain").Page("pgeMain").Link("lnkProKedsProducts_Category").Click
							Else
								Browser("brwMain").Page("pgeMain").Link("lnkProducts").Click 'if not prokeds just ordinary keds
							End If
						ElseIf ModuleName="Grasshoppers" Then
							'Do nothing as there's no subcategory
						End If
						
						If  Browser("brwMain").Page("pgeProductList").Link("lnkViewAll").Exist(3) Then
							Browser("brwMain").Page("pgeProductList").Link("lnkViewAll").Click
						End If
				End If
			
			Next
			
				If  fCount=UBOUND(arrProdValue) Then
					strDesc ="VERIFYBULKINSERT: Cannot proceed further, since there are no products with value > 10."
					clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
					clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
					Reporter.Filter = rfEnableAll 
					Reporter.ReportEvent micFail,"Step VERIFYBULKINSERT", strDesc
					objEnvironmentVariables.TestCaseStatus=False
					Reporter.Filter = rfDisableAll
					Set fObjBC=Nothing  
				End If

	End Function 
'========================================================================================================================================================
'********************************************************************************************************************************************************
'FUNCTION HEADER
'********************************************************************************************************************************************************
'Name: FnVerifyColorSwatches
'Description: This function is verify the color swatches inside a product, perform click action on them and then verify the images & list value bases on the color selected
'Input: Obj, Object Name, strInputValue, strOpt_Param, strOpt_Param, clsReport, objEnvironmentVariables, clsScreenShot, iRowCnt, Screen_shot_path, strSheet_Name, strLabel, strExpectedValue, strTestDataReference
'Input : 
'Creation Date : 5-Apr-2010
'Created By: Ramgopal Narayanan (229673)
'Application: PAYLESS ECOM
'Output: Returns nothing

	Function FnVerifyColorSwatches(ByRef objsub , ByVal Object_Name, ByVal strInputValue, ByVal strDbValue, ByVal strOptParam, ByRef clsReport, ByRef objEnvironmentVariables ,         ByRef clsScreenShot ,ByVal iRowCnt ,ByVal Screen_shot_path ,ByVal strSheet_Name ,ByVal strLabel , ByVal strExpectedValue , ByVal strTestDataReference, ByVal ModuleName)			


'	Browser("brwMain").SetTOProperty "name" , ".*Keds.*"
'	Browser("brwMain").Page("pgeAddtoBag").SetTOProperty "title" , ".*Keds.*" 
	Set objsub=Browser("brwMain").Page("pgeAddtoBag")
	
	If ModuleName="Keds"  Then
		If strOptParam<>"" AND  strOptParam="PROKEDS" Then
			Browser("brwMain").Page("pgeAddtoBag").Image("imgProduct").SetTOProperty "alt","P.*"
		Else
			Browser("brwMain").Page("pgeAddtoBag").Image("imgProduct").SetTOProperty "alt","K.*"
		End If
	ElseIf ModuleName="Grasshoppers" Then
		Browser("brwMain").Page("pgeAddtoBag").Image("imgProduct").SetTOProperty "alt","G.*"
	End If

	fColorValues=objsub.WebList("lstColor").GetROProperty("all items")
		arrColorValues=Split(fColorValues,";")
		'Change the color value from what's being displayed there.
			fItemsCount=CINT(objsub.WebList("lstColor").getRoproperty("items count")) '
			fCurrentValue=objsub.WebList("lstColor").GetROProperty("value")
			If Browser("brwMain").Dialog("dlgError").Exist(3) Then
				Browser("brwMain").Dialog("dlgError").WinButton("btnOk").Click	
			End If

			For i=1 to fItemsCount
				fListValue=objsub.WebList("lstColor").getItem (i)

				If  fListValue<>vCurrentValue AND fItemsCount<>1Then
					objsub.WebList("lstColor").Select(fListValue)
					If Browser("brwMain").Dialog("dlgError").Exist(3) Then
						Browser("brwMain").Dialog("dlgError").WinButton("btnOk").Click	
					End If
					Exit For
				End If					
			Next

		'With Color Images
		'***************
		For arrColorCount=UBOUND(arrColorValues) to 0 Step -1
			If Browser("brwMain").Dialog("dlgError").Exist(3) Then
				Browser("brwMain").Dialog("dlgError").WinButton("btnOk").Click	
			End If
			arrColValue=TRIM(arrColorValues(arrColorCount))
		
			'image object
			Set imgObj=Browser("brwMain").Page("pgeAddtoBag").Image("imgColor")
			imgObj.SetTOProperty "alt",arrColValue
			If  imgObj.Exist(2) Then
		
				strDesc ="VERIFYCOLORSWATCHES: Color swatch with color " & chr(34) & arrColValue & chr(34) & " is displayed corresponding the color value in the color list box."
				clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
				Reporter.Filter = rfEnableAll 
				Reporter.ReportEvent micPass,"Step VERIFYCOLORSWATCHES", strDesc
				Reporter.Filter = rfDisableAll
				Set fObjProd=Nothing

                'Click on the color and check if the color dropdown has the corresponding value displayed and the image also gets changed
				'1. Get the file name of the current image being displayed
				fCurrentImageFileName=TRIM(Browser("brwMain").Page("pgeAddtoBag").Image("imgProduct").GetROProperty("file name"))
				'2. Click on the corresponding color
				imgObj.Click
				If Browser("brwMain").Dialog("dlgError").Exist(3) Then
					Browser("brwMain").Dialog("dlgError").WinButton("btnOk").Click	
				End If

				Browser("brwMain").Sync

				'3. Check if the Product has changed
				fNewImageFileName=TRIM(Browser("brwMain").Page("pgeAddtoBag").Image("imgProduct").GetROProperty("file name"))
				If fNewImageFileName<> fCurrentImageFileName Then
					strDesc ="VERIFYCOLORSWATCHES: Product image is changed to " & chr(34) & fNewImageFileName & chr(34) & " from " & chr(34) & fCurrentImageFileName & chr(34) & "based on the color " & chr(34) & arrColValue & chr(34) & " selected."
					clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
					Reporter.Filter = rfEnableAll 
					Reporter.ReportEvent micPass,"Step VERIFYCOLORSWATCHES", strDesc
					Reporter.Filter = rfDisableAll
					Set fObjProd=Nothing
				ElseIf fNewImageFileName= fCurrentImageFileName AND fItemsCount=1Then
					strDesc ="VERIFYCOLORSWATCHES: Product image is changed to " & chr(34) & fNewImageFileName & chr(34) & " from " & chr(34) & fCurrentImageFileName & chr(34) & "based on the color " & chr(34) & arrColValue & chr(34) & " selected."
					clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
					Reporter.Filter = rfEnableAll 
					Reporter.ReportEvent micPass,"Step VERIFYCOLORSWATCHES", strDesc
					Reporter.Filter = rfDisableAll
					Set fObjProd=Nothing
				Else
					strDesc ="VERIFYCOLORSWATCHES: Product image is not changed from " & chr(34) & fCurrentImageFileName & chr(34) & "based on the color " & chr(34) & arrColValue & chr(34) & " selected, as expected."
					clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
					clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
					Reporter.Filter = rfEnableAll 
					Reporter.ReportEvent micFail,"Step VERIFYCOLORSWATCHES", strDesc
					objEnvironmentVariables.TestCaseStatus=False
					Reporter.Filter = rfDisableAll
					Set fObjBC=Nothing	
		
				End If
		
				'4. Verify if the color list box value is changed based on the color selected.
				fCurrentValueDisplayed=objsub.WebList("lstColor").GetROProperty("value")
				If arrColValue= fCurrentValueDisplayed Then
					strDesc ="VERIFYCOLORSWATCHES: Color ListBox's value is changed to " & chr(34) & arrColValue & chr(34) & " based on the color swatch selected."
					clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
					Reporter.Filter = rfEnableAll 
					Reporter.ReportEvent micPass,"Step VERIFYCOLORSWATCHES", strDesc
					Reporter.Filter = rfDisableAll
					Set fObjProd=Nothing
				Else
					strDesc ="VERIFYCOLORSWATCHES: Color ListBox's value is not changed to " & chr(34) & arrColValue & chr(34) & " based on the color swatch selected. The current value displayed is " & chr(34) & fCurrentValueDisplayed & chr(34) & "."
					clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
					clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
					Reporter.Filter = rfEnableAll 
					Reporter.ReportEvent micFail,"Step VERIFYCOLORSWATCHES", strDesc
					objEnvironmentVariables.TestCaseStatus=False
					Reporter.Filter = rfDisableAll
					Set fObjBC=Nothing	
				End If
		
			Else
				strDesc ="VERIFYCOLORSWATCHES: Color swatch with color " & chr(34) & arrColValue & chr(34) & " is not displayed corresponding the color value in the color list box."
				clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
				clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
				Reporter.Filter = rfEnableAll 
				Reporter.ReportEvent micFail,"Step VERIFYCOLORSWATCHES", strDesc
				objEnvironmentVariables.TestCaseStatus=False
				Reporter.Filter = rfDisableAll
				Set fObjBC=Nothing	
			
			End If		
		Next

		'With Color in ListBox
		'***************
		For arrColorCount=UBOUND(arrColorValues) to 0 Step -1
			If Browser("brwMain").Dialog("dlgError").Exist(3) Then
				Browser("brwMain").Dialog("dlgError").WinButton("btnOk").Click	
			End If
			arrColValue=TRIM(arrColorValues(arrColorCount))

			Browser("brwMain").Sync
'			Wait 5
			fCurrentImageFileName=TRIM(Browser("brwMain").Page("pgeAddtoBag").Image("imgProduct").GetROProperty("file name"))
			'1 Select on the corresponding color
			objsub.WebList("lstColor").Select arrColValue
			If Browser("brwMain").Dialog("dlgError").Exist(3) Then
				Browser("brwMain").Dialog("dlgError").WinButton("btnOk").Click	
			End If
			Browser("brwMain").Sync

			'2. Check if the Product has changed
			Browser("brwMain").Sync
			fNewImageFileName=TRIM(Browser("brwMain").Page("pgeAddtoBag").Image("imgProduct").GetROProperty("file name"))
			If fNewImageFileName<> fCurrentImageFileName Then
				strDesc ="VERIFYCOLORSWATCHES: Product image is changed to " & chr(34) & fNewImageFileName & chr(34) & " from " & chr(34) & fCurrentImageFileName & chr(34) & "based on the color " & chr(34) & arrColValue & chr(34) & " selected in the listbox."
				clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
				Reporter.Filter = rfEnableAll 
				Reporter.ReportEvent micPass,"Step VERIFYCOLORSWATCHES", strDesc
				Reporter.Filter = rfDisableAll
				Set fObjProd=Nothing
			ElseIf fNewImageFileName= fCurrentImageFileName AND fItemsCount=1Then
				strDesc ="VERIFYCOLORSWATCHES: Product image is changed to " & chr(34) & fNewImageFileName & chr(34) & " from " & chr(34) & fCurrentImageFileName & chr(34) & "based on the color " & chr(34) & arrColValue & chr(34) & " selected in the listbox."
				clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
				Reporter.Filter = rfEnableAll 
				Reporter.ReportEvent micPass,"Step VERIFYCOLORSWATCHES", strDesc
				Reporter.Filter = rfDisableAll
				Set fObjProd=Nothing
			Else
				strDesc ="VERIFYCOLORSWATCHES: Product image is not changed from " & chr(34) & fCurrentImageFileName & chr(34) & "based on the color " & chr(34) & arrColValue & chr(34) & " selected in the listbox, as expected."
				clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
				clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
				Reporter.Filter = rfEnableAll 
				Reporter.ReportEvent micFail,"Step VERIFYCOLORSWATCHES", strDesc
				objEnvironmentVariables.TestCaseStatus=False
				Reporter.Filter = rfDisableAll
				Set fObjBC=Nothing	
			End If
		
        Next


	End Function 
'========================================================================================================================================================
'********************************************************************************************************************************************************
'FUNCTION HEADER
'********************************************************************************************************************************************************
'Name: FnDeleteAllAddress
'Description: This function is used to remove all the iaddress
'Input: Obj, Object Name, strInputValue, strOpt_Param, strOpt_Param, clsReport, objEnvironmentVariables, clsScreenShot, iRowCnt, Screen_shot_path, strSheet_Name, strLabel, strExpectedValue, strTestDataReference
'Creation Date : 13-Apr-2010
'Created By: Fayis.K (229680)
'Application: PAYLESS ECOM
'Output: Returns nothing
'********************************************************************************************************************************************************

							  Function FnDeleteAllAddress(ByRef objsub , ByVal Object_Name, ByVal strInputValue, ByVal strDbValue, ByVal strOptParam, ByRef clsReport, ByRef objEnvironmentVariables ,         ByRef clsScreenShot ,ByVal iRowCnt ,ByVal Screen_shot_path ,ByVal strSheet_Name ,ByVal strLabel , ByVal strExpectedValue , ByVal strTestDataReference) 

												Set obj = objsub
												itemCnt=0

												If strInputValue="" OR UCASE(TRIM(strInputValue))="ALL" Then
                        											
													While obj.Link("lnkDelete").Exist(5)
														obj.Link("lnkDelete").Click
														If  Environment.Value ("BrowserName") = "Firefox" Then
															If  Browser("brwMain").Dialog("dlgFireFoxDialog").Exist(5) Then
																 Browser("brwMain").Dialog("dlgFireFoxDialog").Page("pgeFireFoxDialog").WebButton("btnOk").Click
															End If
														Else
															If  Browser("brwMain").Dialog("dlgError").Exist(5) Then
																 Browser("brwMain").Dialog("dlgError").WinButton("btnOk").Click
															End If
														End If
'														Browser("brwMain").Sync
														Wait 5
														itemCnt = itemCnt + 1

													Wend
												 ElseIf strInputValue<>"" AND strInputValue<>"ALL" Then
													'Index would be passed as i/p
														strInputValue=TRIM(strInputValue)
														obj.Link("lnkDelete").SetTOProperty "index",strInputValue
														obj.Link("lnkDelete").Click
														If  Environment.Value ("BrowserName") = "Firefox" Then
															If  Browser("brwMain").Dialog("dlgFireFoxDialog").Exist(5) Then
																 Browser("brwMain").Dialog("dlgFireFoxDialog").Page("pgeFireFoxDialog").WebButton("btnOk").Click
															End If
														Else
															If  Browser("brwMain").Dialog("dlgError").Exist(5) Then
																 Browser("brwMain").Dialog("dlgError").WinButton("btnOk").Click
															End If
														End If
												 End If


												If  strInputValue="" OR UCASE(TRIM(strInputValue))="ALL"  Then
															'report
														  If itemCnt  Then
																		'Added by Fayis  30-3-10 - 
																		strDesc =oprName & chr(34) & itemCnt & chr(34) & " item(s) found. Deleted all item(s).."
																		clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
																		Reporter.Filter = rfEnableAll 
																		Reporter.ReportEvent micPass,"Step DELETE ITEMS:", strDesc
																		Reporter.Filter = rfDisableAll
														Else
																		strDesc =oprName &"No address present."
																		clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
																		Reporter.Filter = rfEnableAll 
																		Reporter.ReportEvent micPass,"Step DELETE ITEMS", strDesc
																		Reporter.Filter = rfDisableAll
														End if
												Else
																		strDesc ="DELETE ITEMS : Delete opertation successfully performed."
																		clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
																		Reporter.Filter = rfEnableAll 
																		Reporter.ReportEvent micPass,"Step DELETE ITEMS:", strDesc
																		Reporter.Filter = rfDisableAll
												End If

                                                'Set obj=Nothing
                                End Function

'========================================================================================================================================================

'========================================================================================================================================================

'********************************************************************************************************************************************************
'FUNCTION HEADER
'********************************************************************************************************************************************************
'Name: FnAddToShoppingBag
'Description: This function is add a product to shopping bag
'Input: Obj, Object Name, strInputValue, strOpt_Param, strOpt_Param, clsReport, objEnvironmentVariables, clsScreenShot, iRowCnt, Screen_shot_path, strSheet_Name, strLabel, strExpectedValue, strTestDataReference
'Input : Categoty as "MEN/WOMEN/KIDS" , Test Data Ref- OPTIONAL (if you don't wan the the function to chk for the object, strOptParam - ENV:ProdName:ENV:ProdPrice
'Creation Date : 22-Apr-2010
'Created By: Ramgopal Narayanan (229673)
'Application: PAYLESS ECOM
'Output: Returns nothing (returns the prod name / price internally)

                Function FnAddToShoppingBag(ByRef objsub , ByVal Object_Name, ByVal strInputValue, ByVal strDbValue, ByVal strOptParam, ByRef clsReport, ByRef objEnvironmentVariables , ByRef clsScreenShot ,ByVal iRowCnt ,ByVal Screen_shot_path ,ByVal strSheet_Name ,ByVal strLabel , ByVal strExpectedValue , ByVal strTestDataReference, ByVal ModuleName)                                  

'                                               If ModuleName="Keds" Then
'                                                                                               Browser("brwMain").SetTOProperty "name" , ".*Keds.*"
'                                                                                               Browser("brwMain").Page("pgeMain").SetTOProperty "title" , ".*Keds.*"   
'                                                                                               Browser("brwMain").Page("pgeProductList").SetTOProperty "title" , ".*Keds.*"   
'                                                                                               Browser("brwMain").Page("pgeGeneral").SetTOProperty "title" , ".*Keds.*" 
'                                                                                               Browser("brwMain").Page("pgeAddtoBag").SetTOProperty "title" , ".*Keds.*" 
'                                                                                               Browser("brwMain").Page("pgeShoppingBag").SetTOProperty "title" , ".*Keds.*" 
'                                               End If
                                                
                                                isAddnLink=False
                                                '1.Category to be selected
                                                '*******************************
												strLink=""
                                                strInputVal=Trim(strInputValue)
                                                If UCASE(strInputVal)="MEN" Then
                                                                strLink="lnkMen"
                                                ElseIF UCASE(strInputVal)="WOMEN" Then
                                                                strLink="lnkWomen"
                                                ElseIF UCASE(strInputVal)="KIDS" Then
                                                                strLink="lnkKids"              
                                                ElseIF UCASE(strInputVal)="PRO" Then 'Just for the sake of Pro Keds
                                                                strLink="lnkProKedsProducts_Main"
												'Ram  Aug-2-2010 - The following 4 categories are for Grasshoppers
												'*****************************************************************************
												ElseIF UCASE(strInputVal)="ACTIVE" Then
                                                                strLink="lnkActive"    
												ElseIF UCASE(strInputVal)="CASUALS" Then
                                                                strLink="lnkCasuals"    
												ElseIF UCASE(strInputVal)="PUREFIT" Then
                                                                strLink="lnkPureFit"    
												ElseIF UCASE(strInputVal)="LASTCHANCE" Then
                                                                strLink="lnkLastChance"    
												 '*****************************************************************************
                                                ElseIF strInputVal="" AND ModuleName<> "Grasshoppers" Then
                                                                'By Default clickin on Women
                                                                strLink="lnkWomen"
                                                End If

											If strLink<>"" Then
												
                                                '2. Click on the link initially to select the category
                                                '********************************************************
                                                Browser("brwMain").Page("pgeMain").Link(strLink).Click

                                                Wait 5

                                                '3. Select the product based the application
                                                '**************************************************
                                                If ModuleName="Original" OR ModuleName="Performance" Then
                                                                If  UCASE(strInputVal)="MEN" OR UCASE(strInputVal)="WOMEN" Then
                                                                                Browser("brwMain").Page("pgeMain").Link("lnkFootwear").Click
                                                                ElseIf UCASE(strInputVal)="KIDS" Then
                                                                                Browser("brwMain").Page("pgeMain").Link("lnkBoys").Click
                                                                End If
                                                ElseIf ModuleName="Sperry" Then
                                                                Browser("brwMain").Page("pgeMain").Link("lnkShoes").Click
                                                ElseIf ModuleName="Keds" Then
                                                                If strExpectedValue<>"" AND UCASE(TRIM(strExpectedValue))="PROKEDS" Then 'For Prokeds
                                                                                Browser("brwMain").Page("pgeMain").Link("lnkProKedsProducts_Category").Click
                                                                Else
                                                                                Browser("brwMain").Page("pgeMain").Link("lnkProducts").Click 'if not prokeds just ordinary keds
                                                                End If
												ElseIf ModuleName="Grasshoppers" Then
													'DO NOTHING AS GH HAS NO SUB CAT
                                                End If


                                                
                                                Wait 5
                                                '4'View all the prods'
                                                '***********************
                                                If  Browser("brwMain").Page("pgeProductList").Link("lnkViewAll").Exist(3) Then
                                                                Browser("brwMain").Page("pgeProductList").Link("lnkViewAll").Click
                                                End If
                                                
                                                Wait 5

                                                'To click links like Highest Price and Lowest Price etc under the product list page
                                                If strTestDataReference<>"" Then
                                                                lnkToClick=TRIM(strTestDataReference)
                                                                isAddnLink=True
                                                End If

                                                If  isAddnLink Then
                                                                Browser("brwMain").Page("pgeProductList").Link(lnkToClick).Click
                                                End If
                                                Wait 5
                                                
                                                
                                                
                                                '5. Get the product list
                                                '**************************                                          
                                                Set lnkObj = Description.Create()
                                                lnkObj("micclass").Value = "Link"
                                                lnkObj("html tag").Value = "A"
                                                strProducts=""
                                                Set obj=Browser("brwMain").Page("pgeProductList").WebElement("elmProductList").ChildObjects(lnkObj)
                                                For objCount=0 to obj.count-1
                                                                strProdName=obj(objCount).getRoproperty("text")
                                                                strProdHref=obj(objCount).getRoproperty("href")
                                                                strProdProp=strProdName & "|" & strProdHref
                                                                strProducts=strProducts & "~" & strProdProp
                                                Next
                                                
                                                '6.Iterate thru the products and check if it can be added
                                                '****************************************************************
                                                strProducts=RIGHT(strProducts,(LEN(strProducts)-1))
                                                arrProdValue=Split(strProducts,"~")
                                                For arrCount=0 to UBOUND(arrProdValue)
																
                                                                fCount=arrCount
                                                                arrProdProp=arrProdValue(arrCount)
                                                                'Split the prop again
                                                                arrIndivProp=Split(arrProdProp,"|")

                                                                'A.Click on the product
                                                                '**************************
                                                                Set objGeneral=Browser("brwMain").Page("pgeProductList").Link("lnkProduct")
                                                                objGeneral.SetTOProperty "text",arrIndivProp(0) 'Text Prop
                                                                objGeneral.SetTOProperty "href",arrIndivProp(1) 'href link
                                                                objGeneral.Click

                                                                'A.1. Get the product price
                                                                '*****************************
                                                
                                                                '**** Check if no inventory found error is displayed or not, if select the next product
                                                                If NOT(Browser("brwMain").Page("pgeAddtoBag").WebElement("elmNoInventoryAvailable").Exist(3)) Then
                                                                                                strProdPrc=Browser("brwMain").Page("pgeAddtoBag").WebElement("elmPriceValue").GetROProperty("innertext")
                                                                                                'strProdPrc=TRIM(Replace(strProdPrc,"Reg.",""))
                                                                                                strTemp=Split(strProdPrc,"Reg.")
                                                                                                strProdPrc=TRIM(strTemp(1))
                                
                                                                                                isSalePrice=False
                                                                                                If  Browser("brwMain").Page("pgeAddtoBag").WebElement("elmSalePrice").Exist(3) Then
                                                                                                                strSalePrc=Browser("brwMain").Page("pgeAddtoBag").WebElement("elmSalePrice").GetROProperty("innertext")
                                                                                                                strSalePrc=TRIM(strSalePrc)
                                                                                                                isSalePrice=True
                                                                                                End If
                                
                                                                                                If  isSalePrice Then
                                                                                                                strFinalPrice=strSalePrc
                                                                                                Else
                                                                                                                strFinalPrice=strProdPrc               
                                                                                                End If
                                
                                                                                                'B. Iterate thru different sizes and widths to make sure the product gets added
                                                                                                '*****************************************************************************************
                                                                                                'Size 
                                                                                                strShoeSize=Browser("brwMain").Page("pgeAddtoBag").WebList("lstSize").GetROProperty("all items")
                                                                                                'Width
                                                                                                strShoeWidth=Browser("brwMain").Page("pgeAddtoBag").WebList("lstWidth").GetROProperty("all items")
                                
                                                                                                arrShoeSz=Split(strShoeSize,";")
                                                                                                If TRIM(arrShoeSz(0))="Size" Then
                                                                                                                i=1
                                                                                                Else
                                                                                                                i=0
                                                                                                End If
                                
                                                                                                arrShoeWd=Split(strShoeWidth,";")
                                                                                                If TRIM(arrShoeWd(0))="Width" Then
                                                                                                                j=1
                                                                                                Else
                                                                                                                j=0
                                                                                                End If
                                
                                                                                                'C. Iterate thru different sizes and widths till the product gets added on to the bag
                                                                                                '********************************************************************************************
                                                                                                For arrShoeSzCount=i to UBOUND(arrShoeSz) ' First level iteration from shoe size
                                                                                                                'Check for any error dialog esp in IE6/7
                                                                                                                If Browser("brwMain").Dialog("dlgError").Exist(2) Then
                                                                                                                                Browser("brwMain").Dialog("dlgError").WinButton("btnOk").Click           
                                                                                                                End If
                                
                                                                                                                'Select the shoe
                                                                                                                Browser("brwMain").Page("pgeAddtoBag").WebList("lstSize").Select arrShoeSz(arrShoeSzCount)
                                
                                                                                                                For arrShoeWdCount=j to UBOUND(arrShoeWd) '2nd level width
                                                                                                                                'Select the width
                                                                                                                                Browser("brwMain").Page("pgeAddtoBag").WebList("lstWidth").Select arrShoeWd(arrShoeWdCount)
                                                                                                                                Wait 2
                                                                                                                                'Add the product the bag
                                                                                                                                Browser("brwMain").Page("pgeAddtoBag").Image("imgAddtobag").Click
                                                                                                                                'Check for error.only for IE6/7
                                                                                                                                If Browser("brwMain").Dialog("dlgError").Exist(2) Then
                                                                                                                                                Browser("brwMain").Dialog("dlgError").WinButton("btnOk").Click           
                                                                                                                                End If
                                
                                                                                                                                ''Check for the excess qty error - If so repleat the loop
                                                                                                                                '*************************************************************
                                                                                                                                If Browser("brwMain").Page("pgeAddtoBag").WebElement("elmExceedsQuantityError").Exist(5)=FALSE Then
                                                                                                                                                'Check for the shopping bag
                                                                                                                                                If Browser("brwMain").Page("pgeShoppingBag").WebElement("elmYourShoppingBag").Exist(3) Then
                                                                                                                                                                Browser("brwMain").Page("pgeShoppingBag").WebElement("elmYourShoppingBag").Highlight
                                                                                                                                                                'Place the prod name and price onto env var if needed
                                                                                                                                                                '***************************************************************
                                                                                                                                                                If strOptParam<>"" Then
                                                                                                                                                                                arrOptParam=Split(strOptParam,":")
                                                                                                                                                                                If  UBOUND(arrOptParam)>0Then
                                                                                                                                                                                                If  UCASE(TRIM(arrOptParam(0)))="ENV" Then
                                                                                                                                                                                                                Environment.Value(Trim(arrOptParam(1)) ) = arrIndivProp(0) 'PRODUCT NAME
                                                                                                                                                                                                                'Check if there's one more env value, if so set the prod price for that
                                                                                                                                                                                                                If  UBOUND(arrOptParam)>1 Then
                                                                                                                                                                                                                                If UCASE(TRIM(arrOptParam(2)))="ENV" Then
                                                                                                                                                                                                                                                Environment.Value(Trim(arrOptParam(3)) ) = strFinalPrice 'PRODUCT PRICE (Eg: $60.00)
                                                                                                                                                                                                                                End If
                                                                                                                                                                                                                End If
                                                                                                                                                                                                End If
                                                                                                                                                                                End If
                                                                                                                                                                End If
                                
                                                                                                                                                                fIsProdAddedToBag="No"
                                                                                                                                                                'Check if the product gets added to the shopping bag successfully, it might be a link or an element
                                                                                                                                                                Set lnkObj=Browser("brwMain").Page("pgeShoppingBag").Link("LnkGeneral")
                                                                                                                                                                lnkObj.SetTOProperty "text", arrIndivProp(0)
                                
                                                                                                                                                                Set elmObj=Browser("brwMain").Page("pgeShoppingBag").WebElement("elmGeneral")
                                                                                                                                                                elmObj.SetTOProperty "innertext",arrIndivProp(0)
                                                                                                                                                                elmObj.SetTOProperty "html tag","DIV"
                                                                                                                                                
                                                                                                                                                                If lnkObj.Exist(2) Then 
                                                                                                                                                                                fIsProdAddedToBag="Yes"
                                                                                                                                                                                lnkObj.Highlight
                                                                                                                                                                ElseIf     elmObj.Exist(2) Then
                                                                                                                                                                                fIsProdAddedToBag="Yes"
                                                                                                                                                                                elmObj.Highlight
                                                                                                                                                                Else
                                                                                                                                                                                fIsProdAddedToBag="No"
                                                                                                                                                                End If
                                '                                                                                                                               If strTestDataReference<>"OPTIONAL" Then
                                                                                                                                                                                If  fIsProdAddedToBag="Yes" Then
                                                                                                                                                                                                strDesc ="ADDTOSHOPPINGBAG: The product " & chr(34) & arrIndivProp(0) & chr(34) & " is added to the shopping bag."
                                                                                                                                                                                                clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
                                                                                                                                                                                                Reporter.Filter = rfEnableAll 
                                                                                                                                                                                                Reporter.ReportEvent micPass,"Step ADDTOSHOPPINGBAG", strDesc
                                                                                                                                                                                                Reporter.Filter = rfDisableAll
                                                                                                                                                                                Else
                                                                                                                                                                                                strDesc ="ADDTOSHOPPINGBAG: The product " & chr(34) & arrIndivProp(0) & chr(34) & " is not added to the shopping bag. One of the reasons might be that the product name is not being displayed. Please refer screenshot for the detailed error."
                                                                                                                                                                                                clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
                                                                                                                                                                                                clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
                                                                                                                                                                                                Reporter.Filter = rfEnableAll 
                                                                                                                                                                                                Reporter.ReportEvent micFail,"Step ADDTOSHOPPINGBAG", strDesc
                                                                                                                                                                                                objEnvironmentVariables.TestCaseStatus=False
                                                                                                                                                                                                Reporter.Filter = rfDisableAll
                                                                                                                                                                                End If
                                '                                                                                                                               End If
                                                                                                                                                                Exit For ' Exit the width for loop
                                                                                                                                                End If                                                                                    
                                                                                                                                End If
                                                                                                                Next 'End of width for loop
                                
                                                                                                                If fIsProdAddedToBag="Yes" OR fIsProdAddedToBag="No" Then
                                                                                                                                Exit For 'Exit the size loop as well
                                                                                                                End If                                                                    
                                
                                                                                                Next      'End of size for loop


                                                                If fIsProdAddedToBag="Yes" Then
                                                                                Exit For 'Exit the product selection loop as well
                                                                Else
                                                                                'Loop again for different product to see it can be added
                                                                                Browser("brwMain").Page("pgeMain").Link(strLink).Click
                                                                                
                                                                                If ModuleName="Original" OR ModuleName="Performance" Then
                                                                                                If  UCASE(strInputVal)="MEN" OR UCASE(strInputVal)="WOMEN" Then
                                                                                                                Browser("brwMain").Page("pgeMain").Link("lnkFootwear").Click
                                                                                                ElseIf UCASE(strInputVal)="KIDS" Then
                                                                                                                Browser("brwMain").Page("pgeMain").Link("lnkBoys").Click
                                                                                                End If
                                                                                ElseIf ModuleName="Sperry" Then
                                                                                                Browser("brwMain").Page("pgeMain").Link("lnkShoes").Click
                                                                                ElseIf ModuleName="Keds" Then
                                                                                                If strExpectedValue<>"" AND UCASE(TRIM(strExpectedValue))="PROKEDS" Then 'For Prokeds
                                                                                                                Browser("brwMain").Page("pgeMain").Link("lnkProKedsProducts_Category").Click
                                                                                                Else
                                                                                                                Browser("brwMain").Page("pgeMain").Link("lnkProducts").Click 'if not prokeds just ordinary keds
                                                                                                End If
																				ElseIf ModuleName="Grasshoppers" Then
																								'DO NOTHING AS GH HAS NO SUB CAT
                                                                                End If

                                                                                If  isAddnLink Then
                                                                                                Browser("brwMain").Page("pgeProductList").Link(lnkToClick).Click
                                                                                End If
                                                                End If    

                                                Else
                                                                                                                                                'Loop again for different product to see it can be added
                                                                                Browser("brwMain").Page("pgeMain").Link(strLink).Click
                                                                                
                                                                                If ModuleName="Original" OR ModuleName="Performance" Then
                                                                                                If  UCASE(strInputVal)="MEN" OR UCASE(strInputVal)="WOMEN" Then
                                                                                                                Browser("brwMain").Page("pgeMain").Link("lnkFootwear").Click
                                                                                                ElseIf UCASE(strInputVal)="KIDS" Then
                                                                                                                Browser("brwMain").Page("pgeMain").Link("lnkBoys").Click
                                                                                                End If
                                                                                ElseIf ModuleName="Sperry" Then
                                                                                                Browser("brwMain").Page("pgeMain").Link("lnkShoes").Click
                                                                                ElseIf ModuleName="Keds" Then
                                                                                                If strExpectedValue<>"" AND UCASE(TRIM(strExpectedValue))="PROKEDS" Then 'For Prokeds
                                                                                                                Browser("brwMain").Page("pgeMain").Link("lnkProKedsProducts_Category").Click
                                                                                                Else
                                                                                                                Browser("brwMain").Page("pgeMain").Link("lnkProducts").Click 'if not prokeds just ordinary keds
                                                                                                End If
																				ElseIf ModuleName="Grasshoppers" Then
																								'DO NOTHING AS GH HAS NO SUB CAT
                                                                                End If

                                                                                If  isAddnLink Then
                                                                                                Browser("brwMain").Page("pgeProductList").Link(lnkToClick).Click
                                                                                End If    
                                                End If                                                    
                                                Next 'End of Product for loop
                                                
                                                If  fCount=UBOUND(arrProdValue) Then
                                                                strDesc ="ADDTOSHOPPINGBAG: Cannot proceed further, since there are no products exists with a quantity of atleast 1"
                                                                clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
                                                                clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
                                                                Reporter.Filter = rfEnableAll 
                                                                Reporter.ReportEvent micFail,"Step ADDTOSHOPPINGBAG", strDesc
                                                                objEnvironmentVariables.TestCaseStatus=False
                                                                Reporter.Filter = rfDisableAll
                                                End If
										   Else	
												                strDesc ="ADDTOSHOPPINGBAG: Cannot proceed further, since the category specified does not exist in the application"
                                                                clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
                                                                clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
                                                                Reporter.Filter = rfEnableAll 
                                                                Reporter.ReportEvent micFail,"Step ADDTOSHOPPINGBAG", strDesc
                                                                objEnvironmentVariables.TestCaseStatus=False
                                                                Reporter.Filter = rfDisableAll
										   End If
                End Function

'========================================================================================================================================================
'********************************************************************************************************************************************************
'FUNCTION HEADER
'********************************************************************************************************************************************************
'Name: FnDisplayPaymentExpiryErrorMessage
'Description: This function is to check for an error message if the credit card expiry date is less than  <=90days. Speific for case TC_25_Vef_Pymnt_Disp_ExpiryMsg1
'Creation Date : 17-May-2010
'Created By: Ramgopal Narayanan (229673)
'Application: PAYLESS ECOM
'Output: Returns nothing (returns the prod name / price internally)

	Function FnDispPymntExpMsg(ByRef objsub , ByVal Object_Name, ByVal strInputValue, ByVal strDbValue, ByVal strOptParam, ByRef clsReport, ByRef objEnvironmentVariables , ByRef clsScreenShot ,ByVal iRowCnt ,ByVal Screen_shot_path ,ByVal strSheet_Name ,ByVal strLabel , ByVal strExpectedValue , ByVal strTestDataReference)			

	   'Get the current moth
		strCurrentDate=Date
		strTemp=Split(strCurrentDate,"/")
		strCrntMM=CINT(strTemp(0)) 'Month
		If strCrntMM<10 Then
			strCrntMM="0" & strCrntMM
		End If
		'Get the year
		strCrntYYYY=TRIM(strTemp(2))
		strCrntYY=RIGHT(strCrntYYYY,2) 

		'Warning Message
		strWarngMsg="This payment method will expire on " & strCrntMM & "/" & strCrntYY

		'Set the value as innertext on the General Web Element
		Set obj=objsub.WebElement("elmGeneralRegEx")
		obj.SetToProperty "innertext", ".*" & strWarngMsg & ".*"
		obj.SetToProperty "html tag", "DIV"

		If  obj.Exist(5) Then

			obj.Highlight
			strDesc ="CHK90DAYSEXPIRYMESSAGE: The message " & chr(34) & strWarngMsg & chr(34) & " is displayed."
			clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
			Reporter.Filter = rfEnableAll 
			Reporter.ReportEvent micPass,"Step CHK90DAYSEXPIRYMESSAGE", strDesc
			Reporter.Filter = rfDisableAll
			Set fObjBC=Nothing          
		Else	
			strDesc ="CHK90DAYSEXPIRYMESSAGE: The message " & chr(34) & strWarngMsg & chr(34) & " is not displayed."
			clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
			clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
			Reporter.Filter = rfEnableAll 
			Reporter.ReportEvent micFail,"Step CHK90DAYSEXPIRYMESSAGE", strDesc
			objEnvironmentVariables.TestCaseStatus=False
			Reporter.Filter = rfDisableAll
		End If


	End Function

'========================================================================================================================================================
'********************************************************************************************************************************************************
'FUNCTION HEADER
'********************************************************************************************************************************************************
'Name: FnRemoveLinkInShoppingBag
'Description: This function is used to remove one of those products added under the shopping bag, check if it's still available , recalculate the total.Speific for case TC_17_Vef_ Rmov_Link_SpngBag
'Creation Date : 24-May-2010
'Created By: Ramgopal Narayanan (229673)
'Application: PAYLESS ECOM
'Output: Returns nothing (returns the prod name / price internally)

	Function FnRemoveLinkInShoppingBag(ByRef objsub , ByVal Object_Name, ByVal strInputValue, ByVal strDbValue, ByVal strOptParam, ByRef clsReport, ByRef objEnvironmentVariables , ByRef clsScreenShot ,ByVal iRowCnt ,ByVal Screen_shot_path ,ByVal strSheet_Name ,ByVal strLabel , ByVal strExpectedValue , ByVal strTestDataReference, ByVal ModuleName)			

'			If ModuleName="Keds" Then
'						Browser("brwMain").SetTOProperty "name" , ".*Keds.*"
'						Browser("brwMain").Page("pgeMain").SetTOProperty "title" , ".*Keds.*"   
'						Browser("brwMain").Page("pgeProductList").SetTOProperty "title" , ".*Keds.*"   
'						Browser("brwMain").Page("pgeGeneral").SetTOProperty "title" , ".*Keds.*" 
'						Browser("brwMain").Page("pgeAddtoBag").SetTOProperty "title" , ".*Keds.*" 
'						Browser("brwMain").Page("pgeShoppingBag").SetTOProperty "title" , ".*Keds.*" 
'			End If

				'1. Object Defenition
				Set objsub=Browser("brwMain").Page("pgeShoppingBag")
				Set tblObj=objsub.WebTable("tblItems")
				strLinkToRemove=RandomNumber(0,1)
				Set lnkObj=objsub.Link("lnkRemove")
				
				'2. Get the product name, price and sub total of the products
					'a). Product 1
						strProd1Name=Environment.Value("ProdName1")
						strProd1Price=tblObj.GetCellData(2,4)
				
					 'b). Product 2
						strProd2Name=Environment.Value("ProdName2")
						strProd2Price=tblObj.GetCellData(3,4)
				
					'c). Get the sub total
						strSubTotal=CDBL(strProd1Price)+CDBL(strProd2Price)
				
				'3. Remove one of those links
						lnkObj.SetTOProperty "index",strLinkToRemove
						lnkObj.Click
'						Browser("brwMain").Sync
						Wait 7
				
						If  strLinkToRemove=0 Then
							strProdRemName=strProd1Name
							strProdRemPrice=strProd1Price
							strNewSubTot=CDBL(strSubTotal)-CDBL(strProdRemPrice)
						Else
							strProdRemName=strProd2Name
							strProdRemPrice=strProd2Price
							strNewSubTot=CDBL(strSubTotal)-CDBL(strProdRemPrice)
						End If

				'4. Verify if the product is removed and the subtotal is adjusted accordingly
				
						'a. Verify if the product is removed
						strRowCnt=Browser("brwMain").Page("pgeShoppingBag").WebTable("tblItems").GetROProperty("rows")
						blnIsProdFound=False
						For i=0 to strRowCnt
							strCellValue=tblObj.GetCellData(i,1)
							If INSTR(strCellValue,strProdRemName)>0 Then
								'Product not removed
								blnIsProdFound=True
								strDesc ="REMOVELINKINSHPNGBAG: The product " & chr(34) & strProdRemName & chr(34) & " is not removed from the shopping bag."
								clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1 & strLabel , objEnvironmentVariables
								clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
								Reporter.Filter = rfEnableAll 
								Reporter.ReportEvent micFail,"Step REMOVELINKINSHPNGBAG", strDesc
								objEnvironmentVariables.TestCaseStatus=False
								Reporter.Filter = rfDisableAll
								Exit For 
							End If
						Next
				
						If  NOT(blnIsProdFound) Then
							'Product removed
							strDesc ="REMOVELINKINSHPNGBAG: The product " & chr(34) & strProdRemName & chr(34) & " is removed from the shopping bag."
							clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
							Reporter.Filter = rfEnableAll 
							Reporter.ReportEvent micPass,"Step REMOVELINKINSHPNGBAG", strDesc
							Reporter.Filter = rfDisableAll
							Set fObjBC=Nothing       
						End If
				
						'b. Check if the sub total is adjusted properly
							blnIsTotalCorrect=False
							For i=0 to strRowCnt
								strCellValue=tblObj.GetCellData(i,1)
								If INSTR(strCellValue,"subtotal")>0 Then
									strSubTotalVal=tblObj.GetCellData(i,2)
									If  INSTR(strSubTotalVal,strNewSubTot)>0 Then
										blnIsTotalCorrect=True
										strDesc ="REMOVELINKINSHPNGBAG: The sub-total is adjusted correctly as " & chr(34) & "$" & TRIM(strNewSubTot) & chr(34) & " after removing the value of " & strProdRemPrice & " from the original total of $" & strSubTotal &  "."
										clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
										Reporter.Filter = rfEnableAll 
										Reporter.ReportEvent micPass,"Step REMOVELINKINSHPNGBAG", strDesc
										Reporter.Filter = rfDisableAll
										Set fObjBC=Nothing    
										Exit For
									End If
								End If
							Next
				
						If  NOT(blnIsTotalCorrect) Then
							'Product removed
							strDesc ="REMOVELINKINSHPNGBAG: The sub-total is not adjusted correctly as " & chr(34) & TRIM(strNewSubTot) & chr(34) & " after removing the value of " & strProdRemPrice & " from the original total of " & strSubTotal &  ".Sub Total that is displayed is " & strSubTotalVal & "."
							clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1 & strLabel , objEnvironmentVariables
							clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
							Reporter.Filter = rfEnableAll 
							Reporter.ReportEvent micFail,"Step REMOVELINKINSHPNGBAG", strDesc
							objEnvironmentVariables.TestCaseStatus=False
							Reporter.Filter = rfDisableAll
						End If
		

	End Function

'
'********************************************************************************************************************************************************
'FUNCTION HEADER
'********************************************************************************************************************************************************
'Name: FnChkShpngBagSummary
'Description: This function is used to remove one of those products added under the shopping bag, check if it's still available , recalculate the total. Specific for shopping bag case TC_09_Vef_Updt_butn_shpng_bag
'Creation Date : 27-May-2010
'Created By: Ramgopal Narayanan (229673)
'Application: PAYLESS ECOM
'Output: Returns nothing (returns the prod name / price internally)

	Function FnChkShpngBagSummary(ByRef objsub , ByVal Object_Name, ByVal strInputValue, ByVal strDbValue, ByVal strOptParam, ByRef clsReport, ByRef objEnvironmentVariables , ByRef clsScreenShot ,ByVal iRowCnt ,ByVal Screen_shot_path ,ByVal strSheet_Name ,ByVal strLabel , ByVal strExpectedValue , ByVal strTestDataReference, ByVal ModuleName)			


'				If ModuleName="Keds" Then
'							Browser("brwMain").SetTOProperty "name" , ".*Keds.*"
'							Browser("brwMain").Page("pgeMain").SetTOProperty "title" , ".*Keds.*"   
'							Browser("brwMain").Page("pgeProductList").SetTOProperty "title" , ".*Keds.*"   
'							Browser("brwMain").Page("pgeGeneral").SetTOProperty "title" , ".*Keds.*" 
'							Browser("brwMain").Page("pgeAddtoBag").SetTOProperty "title" , ".*Keds.*" 
'							Browser("brwMain").Page("pgeShoppingBag").SetTOProperty "title" , ".*Keds.*" 
'				End If

				strInputValue=TRIM(strInputValue)
				arrInpuValue=Split(strInputValue,":")
			
				'1. Object Defenition
				Set objsub=Browser("brwMain").Page("pgeShoppingBag")
				Set tblObj=objsub.WebTable("tblItems")
			
				'2. Get the quantity and price value
				strItemQuantity=TRIM(objsub.WebList("lstQty").GetROProperty("value"))
				strPriceValue=Environment.Value(TRIM(arrInpuValue(1)))
			
				'3. Check fhe Total for the item
				strTotal=CINT(strItemQuantity)*CDBL(strPriceValue)
				strRowCnt=Browser("brwMain").Page("pgeShoppingBag").WebTable("tblItems").GetROProperty("rows")
				strCellValue=tblObj.GetCellData(2,4)
			
				If INSTR(CDBL(strCellValue),strTotal)>0 Then
			
					strDesc ="CHKSHPNGBAGSUMMARY: The 'Total' value for the product is displayed correctly as " & strCellValue &"."
					clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
					Reporter.Filter = rfEnableAll 
					Reporter.ReportEvent micPass,"Step CHKSHPNGBAGSUMMARY", strDesc
					Reporter.Filter = rfDisableAll
					Set fObjBC=Nothing       
				Else
					strDesc ="CHKSHPNGBAGSUMMARY: The 'Total' value for the product is displayed wrongly as " & strCellValue & ", where as the expected value is $" & strTotal & "."
					clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1 & strLabel , objEnvironmentVariables
					clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
					Reporter.Filter = rfEnableAll 
					Reporter.ReportEvent micFail,"Step CHKSHPNGBAGSUMMARY", strDesc
					objEnvironmentVariables.TestCaseStatus=False
					Reporter.Filter = rfDisableAll
				End If
			
				'4. Check for the Item Sub Total
					blnIsSubTotalCorrect=False
					For i=0 to strRowCnt
						strCellValue=tblObj.GetCellData(i,1)
						If INSTR(strCellValue,"subtotal")>0 Then
							strSubTotalVal=tblObj.GetCellData(i,2)
							If  INSTR(CDBL(strSubTotalVal),strTotal)>0 Then
								blnIsSubTotalCorrect=True
								strDesc ="CHKSHPNGBAGSUMMARY: The sub-total is displayed correctly as " & chr(34) & TRIM(strSubTotalVal) & chr(34) & "."
								clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
								Reporter.Filter = rfEnableAll 
								Reporter.ReportEvent micPass,"Step CHKSHPNGBAGSUMMARY", strDesc
								Reporter.Filter = rfDisableAll
								Set fObjBC=Nothing    
								Exit For
							End If
						End If
					Next
			
				If  NOT(blnIsSubTotalCorrect) Then
					strDesc ="CHKSHPNGBAGSUMMARY: The sub-total is wrongly displayed as " & chr(34) & TRIM(strSubTotalVal) & chr(34) & ", where as the expected value is $" & strTotal & "."
					clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1 & strLabel , objEnvironmentVariables
					clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
					Reporter.Filter = rfEnableAll 
					Reporter.ReportEvent micFail,"Step CHKSHPNGBAGSUMMARY", strDesc
					objEnvironmentVariables.TestCaseStatus=False
					Reporter.Filter = rfDisableAll
				End If
			
				'5. Bag/Cart Summary
				'*************************
				blnEstTotalCorrect=False
				For i=0 to strRowCnt
						strCellValue=tblObj.GetCellData(i,1) ' Loop until the text called summary comes
						If INSTR(strCellValue,"summary")>0 OR INSTR(strCellValue,"Summary" )>0 Then  'In GH its displayed as Summary
							'a. Get the value for Items Sub Total - 
								strItemSubTotalVal=tblObj.GetCellData(i,3)
							'b. Check for the Promotions or else assign that value to shipping price
								strCellValue1=tblObj.GetCellData(i+1,1)
								isPromotions=False
								If INSTR(strCellValue1,"coupons")>0 Then
									strPromotionValue=tblObj.GetCellData(i+1,2)
									isPromotions=True
								ElseIf INSTR(strCellValue,"Shipping")>0 Then
									strShippingValue=tblObj.GetCellData(i+1,2)
									strPromotionValue=0
									strEstRowValue=i+2
								End If
							'c. Change the values when the promotions are there
								If isPromotions Then
									strCellValue2=tblObj.GetCellData(i+2,1)
									If INSTR(strCellValue2,"Shipping")>0 Then
										strShippingValue=tblObj.GetCellData(i+2,2)
										strEstRowValue=i+3
									 End If
								End If
					
							'd.Calculate the Estimated Total Value
								strEstTotalValue=CDBL(strItemSubTotalVal)+CDBL(strPromotionValue)+CDBL(strShippingValue)
								strActualETVal=tblObj.GetCellData(strEstRowValue,2)
						
								If  INSTR(CDBL(strActualETVal),strEstTotalValue)>0 Then
									blnEstTotalCorrect=True
									strDesc ="CHKSHPNGBAGSUMMARY: The Estimated Total is displayed correctly as " & chr(34) & TRIM(strActualETVal) & chr(34) & "."
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micPass,"Step CHKSHPNGBAGSUMMARY", strDesc
									Reporter.Filter = rfDisableAll
									Set fObjBC=Nothing    
									Exit For
								End If
						End If
					Next
			
				If  NOT(blnEstTotalCorrect) Then
					strDesc ="CHKSHPNGBAGSUMMARY: The Estimated Total is wrongly displayed as " & chr(34) & TRIM(strActualETVal) & chr(34) & ", where as the expected value is $" & strEstTotalValue & "."
					clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1 & strLabel , objEnvironmentVariables
					clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
					Reporter.Filter = rfEnableAll 
					Reporter.ReportEvent micFail,"Step CHKSHPNGBAGSUMMARY", strDesc
					objEnvironmentVariables.TestCaseStatus=False
					Reporter.Filter = rfDisableAll
				End If

	End Function
'========================================================================================================================================================

'********************************************************************************************************************************************************
'FUNCTION HEADER
'********************************************************************************************************************************************************
'Name: FnVerifyProductSize
'Description: This function is used to verify if a certain size is available after exausting a size for product/out of stock scenario
'Creation Date : 4-June-2010
'Created By: Ramgopal Narayanan (229673)
'Application: PAYLESS ECOM
'Output: Returns nothing (returns the prod name / price internally)

	Function FnVerifyProductSize(ByRef objsub , ByVal Object_Name, ByVal strInputValue, ByVal strDbValue, ByVal strOptParam, ByRef clsReport, ByRef objEnvironmentVariables , ByRef clsScreenShot ,ByVal iRowCnt ,ByVal Screen_shot_path ,ByVal strSheet_Name ,ByVal strLabel , ByVal strExpectedValue , ByVal strTestDataReference, ByVal ModuleName)			



						'1. Get the product name via the ENV value
						
						Wait 5
                        strProductName=Environment.Value("ProdName")
						
						'3. Get the 1st color , 1st size and width and exaust them via bulk insert
						strColor=Browser("brwMain").Page("pgeAddtoBag").WebList("lstColor").GetItem(1)
						Browser("brwMain").Page("pgeAddtoBag").WebList("lstColor").Select strColor
						Wait 5
'						Wait 5
						strAllSz1=TRIM(Browser("brwMain").Page("pgeAddtoBag").WebList("lstSize").GetROProperty("all items"))
						strSzValue=Browser("brwMain").Page("pgeAddtoBag").WebList("lstSize").GetItem(1)
						If strSzValue="Size" Then
							strSzValue=Browser("brwMain").Page("pgeAddtoBag").WebList("lstSize").GetItem(2)
						End If
						'strWdValue=Browser("brwMain").Page("pgeAddtoBag").WebList("lstWidth").GetItem(1)
						'If strWdValue="Width" Then
						'	strWdValue=Browser("brwMain").Page("pgeAddtoBag").WebList("lstWidth").GetItem(2)
						'End If
						
						strWdValues=TRIM(Browser("brwMain").Page("pgeAddtoBag").WebList("lstWidth").GetROProperty("all items"))
						strWdValues=REPLACE(strWdValues,";",":")
						arrWidVal=Split(strWdValues,"Width:")
						strWdValues=TRIM(arrWidVal(1))
						arrWidth=Split(strWdValues,":")


						For wdCount=0 to UBOUND(arrWidth)
									strWdValue=arrWidth(wdCount)
									Browser("brwMain").Page("pgeAddtoBag").WebList("lstColor").Select strColor
									Wait 5
									Browser("brwMain").Page("pgeAddtoBag").WebList("lstSize").Select strSzValue
									Wait 5
									Browser("brwMain").Page("pgeAddtoBag").WebList("lstWidth").Select strWdValue
									Wait 5
									Browser("brwMain").Page("pgeAddtoBag").WebList("lstQuantity").Select "More than 10"

									If Browser("brwMain").Dialog("dlgError").Exist(3) Then
									Browser("brwMain").Dialog("dlgError").WinButton("btnOk").Click	
									End If
									Browser("brwMain").Page("pgeAddtoBag").WebEdit("edtMorethan10").Set "99999"
									If Browser("brwMain").Dialog("dlgError").Exist(3) Then
									Browser("brwMain").Dialog("dlgError").WinButton("btnOk").Click	
									End If
									Browser("brwMain").Page("pgeAddtoBag").Image("imgAddtobag").Click
									If Browser("brwMain").Dialog("dlgError").Exist(3) Then
									Browser("brwMain").Dialog("dlgError").WinButton("btnOk").Click	
									End If
									Browser("brwMain").Sync
									strAvailQty=TRIM(Browser("brwMain").Page("pgeAddtoBag").WebEdit("edtMorethan10").GetROProperty("value"))
									Wait 1
									Browser("brwMain").Page("pgeAddtoBag").WebEdit("edtMorethan10").Set strAvailQty
									Wait 2
									Browser("brwMain").Page("pgeAddtoBag").Image("imgAddtobag").Click
									Browser("brwMain").Sync
									Browser("brwMain").Page("pgeShoppingBag").Image("ImgCheckout").Click
									Browser("brwMain").Sync
									Browser("brwMain").Page("pgeReviewOrder").WebEdit("edtCVVNumber").Set "123"
									Wait 3
									Browser("brwMain").Page("pgeReviewOrder").Image("imgPlaceOrder").Click

									Wait 5

									If Dialog("dlgSecurityInformation").Exist(3) Then
										Dialog("dlgSecurityInformation").WinButton("btnYes").Click
										Wait 5
									End If						

															
									If Browser("brwMain").Dialog("dlgError").Exist(3) Then
										Browser("brwMain").Dialog("dlgError").WinButton("btnYes").Click
										Wait 5
									End If

									Browser("brwMain").Sync
									
									'4. Go back to the same product
									
									If strOptParam="KEDS" Then
										Browser("brwMain").Page("pgeMain").Link("lnkWomen").Click
										Browser("brwMain").Sync
										Browser("brwMain").Page("pgeMain").Link("lnkProducts").Click
										Browser("brwMain").Sync
										If Browser("brwMain").Page("pgeProductList").Link("lnkHighestPricedFirst").Exist(2) Then
											Browser("brwMain").Page("pgeProductList").Link("lnkHighestPricedFirst").Click
										End If
										Browser("brwMain").Sync
										Browser("brwMain").Page("pgeProductList").Link("lnkGeneral").SetTOProperty "text",strProductName
										Browser("brwMain").Page("pgeProductList").Link("lnkGeneral").Click
										Browser("brwMain").Sync
									ElseIf strOptParam="PROKEDS" Then

										Browser("brwMain").Page("pgeMain").Link("lnkProKedsProducts_Main").Click
										Browser("brwMain").Sync
	
										Browser("brwMain").Page("pgeMain").Link("lnkProKedsProducts_Category").Click
										Browser("brwMain").Sync
										If Browser("brwMain").Page("pgeProductList").Link("lnkHighestPricedFirst").Exist(2) Then
											Browser("brwMain").Page("pgeProductList").Link("lnkHighestPricedFirst").Click
										End If
										Browser("brwMain").Sync
										Browser("brwMain").Page("pgeProductList").Link("lnkGeneral").SetTOProperty "text",strProductName
										Browser("brwMain").Page("pgeProductList").Link("lnkGeneral").Click
										Browser("brwMain").Sync
									ElseIf strOptParam="ORIGINAL" OR strOptParam="PERFORMANCE" Then

										Browser("brwMain").Page("pgeMain").Link("lnkWomen").Click
										Browser("brwMain").Sync
										Browser("brwMain").Page("pgeMain").Link("lnkViewAllFootwear").Click
										Browser("brwMain").Sync
										If Browser("brwMain").Page("pgeProductList").Link("lnkHighestPricedFirst").Exist(2) Then
											Browser("brwMain").Page("pgeProductList").Link("lnkHighestPricedFirst").Click
										End If
										Browser("brwMain").Sync
										Browser("brwMain").Page("pgeProductList").Link("lnkGeneral").SetTOProperty "text",strProductName
										Browser("brwMain").Page("pgeProductList").Link("lnkGeneral").Click
										Browser("brwMain").Sync

									ElseIf strOptParam="SPERRY" Then

										Browser("brwMain").Page("pgeMain").Link("lnkWomen").Click
										Browser("brwMain").Sync
										Browser("brwMain").Page("pgeMain").Link("lnkViewAllShoes").Click
										Browser("brwMain").Sync
										If Browser("brwMain").Page("pgeProductList").Link("lnkHighestPricedFirst").Exist(2) Then
											Browser("brwMain").Page("pgeProductList").Link("lnkHighestPricedFirst").Click
										End If
										Browser("brwMain").Sync
										Browser("brwMain").Page("pgeProductList").Link("lnkGeneral").SetTOProperty "text",strProductName
										Browser("brwMain").Page("pgeProductList").Link("lnkGeneral").Click

										Browser("brwMain").Sync
									End If
						Next

						If Dialog("dlgSecurityInformation").Exist(3) Then
							Dialog("dlgSecurityInformation").WinButton("btnYes").Click
						End If


						Browser("brwMain").Sync 

						Set objShell = CreateObject("WScript.Shell")
						For i=120 to 1 Step -1
							objShell.Popup "Wait for the product details to get updated. Pop-up will close automatically in " & i & " sec(s).",1,"Product Update"
						Next
						Set objShell=Nothing
			
						If Dialog("dlgSecurityInformation").Exist(3) Then
							Dialog("dlgSecurityInformation").WinButton("btnYes").Click
						End If
						Wait 3

						If strOptParam="KEDS" Then
							Browser("brwMain").Page("pgeMain").Link("lnkWomen").Click
							Browser("brwMain").Sync
							Browser("brwMain").Page("pgeMain").Link("lnkProducts").Click
							Browser("brwMain").Sync
							If Browser("brwMain").Page("pgeProductList").Link("lnkHighestPricedFirst").Exist(2) Then
								Browser("brwMain").Page("pgeProductList").Link("lnkHighestPricedFirst").Click
							End If
							Browser("brwMain").Sync
							Browser("brwMain").Page("pgeProductList").Link("lnkGeneral").SetTOProperty "text",strProductName
							Browser("brwMain").Page("pgeProductList").Link("lnkGeneral").Click
							Browser("brwMain").Sync
						ElseIf strOptParam="PROKEDS" Then
							Browser("brwMain").Page("pgeMain").Link("lnkProKedsProducts_Main").Click
							Browser("brwMain").Sync

							Browser("brwMain").Page("pgeMain").Link("lnkProKedsProducts_Category").Click
							Browser("brwMain").Sync
							If Browser("brwMain").Page("pgeProductList").Link("lnkHighestPricedFirst").Exist(2) Then
									Browser("brwMain").Page("pgeProductList").Link("lnkHighestPricedFirst").Click
							End If
							Browser("brwMain").Sync
							Browser("brwMain").Page("pgeProductList").Link("lnkGeneral").SetTOProperty "text",strProductName
							Browser("brwMain").Page("pgeProductList").Link("lnkGeneral").Click
							Browser("brwMain").Sync

						ElseIf strOptParam="ORIGINAL" OR strOptParam="PERFORMANCE" Then

							Browser("brwMain").Page("pgeMain").Link("lnkWomen").Click
							Browser("brwMain").Sync
							Browser("brwMain").Page("pgeMain").Link("lnkViewAllFootwear").Click
							Browser("brwMain").Sync
							If Browser("brwMain").Page("pgeProductList").Link("lnkHighestPricedFirst").Exist(2) Then
								Browser("brwMain").Page("pgeProductList").Link("lnkHighestPricedFirst").Click
							End If
							Browser("brwMain").Sync
							Browser("brwMain").Page("pgeProductList").Link("lnkGeneral").SetTOProperty "text",strProductName
							Browser("brwMain").Page("pgeProductList").Link("lnkGeneral").Click
							Browser("brwMain").Sync

						ElseIf strOptParam="SPERRY" Then

							Browser("brwMain").Page("pgeMain").Link("lnkWomen").Click
							Browser("brwMain").Sync
							Browser("brwMain").Page("pgeMain").Link("lnkViewAllShoes").Click
							Browser("brwMain").Sync
							If Browser("brwMain").Page("pgeProductList").Link("lnkHighestPricedFirst").Exist(2) Then
								Browser("brwMain").Page("pgeProductList").Link("lnkHighestPricedFirst").Click
							End If
							Browser("brwMain").Sync
							Browser("brwMain").Page("pgeProductList").Link("lnkGeneral").SetTOProperty "text",strProductName
							Browser("brwMain").Page("pgeProductList").Link("lnkGeneral").Click
							Browser("brwMain").Sync
						End If
						
						'5. Verify if the out of stock quantity is displayed or not

							Browser("brwMain").Page("pgeAddtoBag").WebList("lstColor").Select strColor
							Wait 7
						
							strCurrentAllSz2=TRIM(Browser("brwMain").Page("pgeAddtoBag").WebList("lstSize").GetROProperty("all items"))
							strCurrentAllSz2=Replace(strCurrentAllSz2,";","~")
							If  NOT(INSTR(strCurrentAllSz2,strSzValue)>0)Then

									strDesc ="VERIFYPRODSZ: The size " & strSzValue & " is not available for the product " & strProductName &" as it's out of stock. The sizes available are - " & strCurrentAllSz2 &  "."
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micPass,"Step VERIFYPRODSZ", strDesc
									Reporter.Filter = rfDisableAll      
							Else
									strDesc = strpartdesc & " at the row number " &iRowCnt+1& ". The size " & strSzValue & " is still available for the product " & strProductName & " inspite of being made out of stock."													
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micFail,"Step VERIFYPRODSZ", strDesc
									objEnvironmentVariables.TestCaseStatus=False 
									Reporter.Filter = rfDisableAll
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0	
							End If
			End Function
'=======================================================================================================================================================================
'********************************************************************************************************************************************************
'FUNCTION HEADER
'********************************************************************************************************************************************************
'Name: FnAddShopBySize
'Description: This function adds a size and checks it the result is displayed based on the size /category selected
'Creation Date : 7-June-2010
'Created By: Fayis.K (229680)
'Application: PAYLESS ECOM


	Function FnAddShopBySize (ByRef objsub , ByVal Object_Name, ByVal strInputValue, ByVal strDbValue, ByVal strOptParam, ByRef clsReport, ByRef objEnvironmentVariables , ByRef clsScreenShot ,ByVal iRowCnt ,ByVal Screen_shot_path ,ByVal strSheet_Name ,ByVal strLabel , ByVal strExpectedValue , ByVal strTestDataReference, ByVal ModuleName)			

			'1 Mouse over the shop by size link
			Set obj=Browser("brwMain").Page("pgeMain").Link("lnkShopBySize")
			obj.highlight									
			Setting.WebPackage("ReplayType") = 2
			obj.FireEvent "onMouseOver"									
			Setting.WebPackage("ReplayType") = 1
									

			'2. Select the size and category based on KEDS/PROKEDS and spli the values accordingly.
			'2.a. A size would be selected @ random
			If UCASE(strInputValue)="KEDS" Then
					strAllCat=TRIM(Browser("brwMain").Page("pgeMain").WebList("lstSelectedCat").GetROProperty("all items"))	
					strAllCat=Replace(strAllCat,";",":")					
					
					strAllCat1=Split(strAllCat,":")
					If  strAllCat1(0)="Choose Category" Then
						  arrCFinalList=Split(strAllCat,"Choose Category")
						  arrCFinal=arrCFinalList(1)
						  arrCFinal1=Split(arrCFinal,":")
						  strCFinalCount=UBOUND(arrCFinal1)+1
						  valuetoselcC=RandomNumber(2,strCFinalCount)
				
					Else
							strCFinalCount=UBOUND(strAllCat1)+1
							valuetoselcC=RandomNumber(1,strCFinalCount)+1
					
					End If

					strCatValue=Browser("brwMain").Page("pgeMain").WebList("lstSelectedCat").GetItem(valuetoselcC)					
					Browser("brwMain").Page("pgeMain").WebList("lstSelectedCat").Select(strCatValue)
'					Browser("brwMain").Sync
					Wait 5
				End if

					strAllSz1=TRIM(Browser("brwMain").Page("pgeMain").WebList("lstSelectedSize").GetROProperty("all items"))					    				
					strAllSz1=Replace(strAllSz1,";",":")					
					
					arrAllSz=Split(strAllSz1,":")
					If  arrAllSz(0)="Size/Width" Then
						  arrFinalList=Split(strAllSz1,"Size/Width")
						  strFinal=arrFinalList(1)
						  strFinal1=Split(strFinal,":")
						  strFinalCount=UBOUND(strFinal1)+1
						  valuetoselc=RandomNumber(2,strFinalCount)
			
					Else
							strFinalCount=UBOUND(arrAllSz)+1
							valuetoselc=RandomNumber(1,strFinalCount)+1
					
					End If
					
					
					strSzValue=Browser("brwMain").Page("pgeMain").WebList("lstSelectedSize").GetItem(valuetoselc)					
					Browser("brwMain").Page("pgeMain").WebList("lstSelectedSize").Select(strSzValue)    
'					Browser("brwMain").Sync
					Wait 3
					Browser("brwMain").Page("pgeMain").WebButton("btnShopBySizeGO").Click
'					Browser("brwMain").Sync
					Wait 5

					arrSzValue = Split (strSzValue,".")
					arrSzValue1 = split (arrSzValue(1),"/")
					
					If arrSzValue1(0) = "0" then
							 strSzValue = arrSzValue(0) & "/" & arrSzValue1(1)
					End if		

					'3. Check if the search result is displayed based on the category/size selected.
					If  UCASE(strInputValue)="KEDS" Then
						resultText = "There were .* results for " & strCatValue & " and " & strSzValue
					Else
							resultText = "There were .* results for Products and " & strSzValue
					End If			
					
					Set obj=Browser("brwMain").Page("pgeMain").WebElement("elmGeneralRegEx")					
					obj.SetTOProperty "html tag","P"
					obj.SetTOProperty "innertext",resultText
					obj.Highlight			

					If obj.Exist(3) Then
							If UCASE(strInputValue)="KEDS" Then
									strDesc ="SHOPEBYSIZE have taken the Category value "&strCatValue& " and Size "  &strSzValue& " displayed correclty."
							Else
									strDesc ="SHOPEBYSIZE have taken the Size "  &strSzValue& " displayed correclty."
							End if
							clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
							Reporter.Filter = rfEnableAll 
							Reporter.ReportEvent micPass,"Step SHOPEBYSIZE", strDesc
							Reporter.Filter = rfDisableAll
						Else  ''expected false	
							strDesc =strpartdesc&" at the row number " & chr(34) & iRowCnt+1 & chr(34) & " is not selected properly."
							Reporter.Filter = rfEnableAll 
							Reporter.ReportEvent micFail,"Step SHOPEBYSIZE", strDesc
							Reporter.Filter = rfDisableAll
							objEnvironmentVariables.TestCaseStatus=False
							clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
							clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
						End If							

End Function
'=======================================================================================================================================================================
''********************************************************************************************************************************************************
'FUNCTION HEADER
'********************************************************************************************************************************************************
'Name: FnShippingMethodCharges
'Description: This function removes an item from the shopping bag and checks if the shipping charges are adjusted accordingly
'Creation Date : 7-June-2010
'Created By: Fayis.K (229680)
'Application: PAYLESS ECOM


							Function FnShippingMethodCharges(ByRef objsub , ByVal Object_Name, ByVal strInputValue, ByVal strDbValue, ByVal strOptParam, ByRef clsReport, ByRef objEnvironmentVariables , ByRef clsScreenShot ,ByVal iRowCnt ,ByVal Screen_shot_path ,ByVal strSheet_Name ,ByVal strLabel , ByVal strExpectedValue , ByVal strTestDataReference, ByVal ModuleName)			

											'1. It will remove each item one by one and check the shipping method charge

											Do
								
													Set objsub=Browser("brwMain").Page("pgeShoppingBag")
													strRowCnt=Browser("brwMain").Page("pgeShoppingBag").WebTable("tblItems").GetROProperty("rows")
													Set tblObj=objsub.WebTable("tblItems")
													Set elmObj=objsub.WebElement("elmGeneral")
								
													'Taking the sub total
													For i=0 to strRowCnt
														strCellValue=tblObj.GetCellData(i,1)
														If INSTR(strCellValue,"subtotal")>0 Then
															'Get the subtotal value
															strSubTotalVal=tblObj.GetCellData(i,2)
															strSubTotalVal=CDBL(strSubTotalVal)
														End if
													Next
								
													'2. Check the shipping charge based on the total $
													If(strSubTotalVal) >= 100 then								
														strStdShp="$12.50"
														strExpShp="$20.50"
														totalOrderRange = "more than $99.95"
														 
													Elseif (strSubTotalVal<100 AND strSubTotalVal>=50) Then
														strStdShp="$10.50"
														strExpShp="$18.50"
														totalOrderRange = "between $100.00 and $49.95"
													Elseif (strSubTotalVal < 50 AND strSubTotalVal >= 9) Then
														strStdShp="$8.50"
														strExpShp="$16.50"
														totalOrderRange = "between $50.00 and $8.95"
													Else
														strStdShp="$2.50"
														strExpShp="$6.50"
														totalOrderRange = "less than $9.00"
													End If
	
													'Element name
													strStdShpVal="Standard delivery - " &  strStdShp
													strExpShpVal="Express delivery - " &  strExpShp

													'Standard shipping method
													objsub.WebList("lstShippingMethod").Select 0
													Browser("brwMain").Sync
													
													elmObj.SetTOProperty "innertext", strStdShpVal
													elmObj.SetTOProperty "html tag", "P"
	
													If elmObj.Exist (3) Then
														elmObj.Highlight
														stdDelevery = TRUE
													Else
														stdDelevery = FALSE
													End If

													'Express shipping method
													objsub.WebList("lstShippingMethod").Select 1
													Browser("brwMain").Sync
													elmObj.SetTOProperty "innertext", strExpShpVal
													elmObj.SetTOProperty "html tag", "P"

													If elmObj.Exist (3) Then
														elmObj.Highlight
														expDelevery = TRUE
													Else
														expDelevery = FALSE
													End If

													'Results
													'For standard delivery


													If   stdDelevery Then
															strDesc ="SHIPPINGMETHODCHARGES: Shipping method Standard delivery is displyed as " & chr(34) & strStdShp & chr(34) & " for the total amount $" & strSubTotalVal & " which is in the rage " & totalOrderRange
															clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
															Reporter.Filter = rfEnableAll 
															Reporter.ReportEvent micPass,"Step SHIPPINGMETHODCHARGES", strDesc
															Reporter.Filter = rfDisableAll
														Else
															strDesc ="SHIPPINGMETHODCHARGES: Shipping method charge NOT displyed as expected " & strStdShpVal & ", which is in the rage " & totalOrderRange
															clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1 & strLabel , objEnvironmentVariables
															clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
															Reporter.Filter = rfEnableAll 
															Reporter.ReportEvent micFail,"Step SHIPPINGMETHODCHARGES", strDesc
															objEnvironmentVariables.TestCaseStatus=False
															Reporter.Filter = rfDisableAll
														End If

													'For standard delivery
													If   expDelevery Then
															strDesc ="SHIPPINGMETHODCHARGES: Shipping method Express delivery is displyed as " & chr(34) & strExpShp & chr(34) & " for the total amount $" & strSubTotalVal & " which is in the rage " & totalOrderRange
															clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
															Reporter.Filter = rfEnableAll 
															Reporter.ReportEvent micPass,"Step SHIPPINGMETHODCHARGES", strDesc
															Reporter.Filter = rfDisableAll
														Else
															strDesc ="SHIPPINGMETHODCHARGES: Shipping method charge NOT displyed as expected " & strExpShp & ", which is in the rage " & totalOrderRange
															clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1 & strLabel , objEnvironmentVariables
															clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
															Reporter.Filter = rfEnableAll 
															Reporter.ReportEvent micFail,"Step SHIPPINGMETHODCHARGES", strDesc
															objEnvironmentVariables.TestCaseStatus=False
															Reporter.Filter = rfDisableAll
														End If
								
													objsub.Link("lnkRemove").Click								
								Loop While objsub.Link("lnkRemove").Exist(3)

					END Function

'=======================================================================================================================================================================
'=======================================================================================================================================================================
'********************************************************************************************************************************************************
'FUNCTION HEADER
'********************************************************************************************************************************************************
'Name: FnShippingCharges
'Description: This function  checks if the shipping charges for both standard and express delivery
'Creation Date : 15June-2010
'Created By: Fayis.K (229680)
'Application: PAYLESS ECOM

							Function FnShippingCharges(ByRef objsub , ByVal Object_Name, ByVal strInputValue, ByVal strDbValue, ByVal strOptParam, ByRef clsReport, ByRef objEnvironmentVariables , ByRef clsScreenShot ,ByVal iRowCnt ,ByVal Screen_shot_path ,ByVal strSheet_Name ,ByVal strLabel , ByVal strExpectedValue , ByVal strTestDataReference, ByVal ModuleName)			

								Set objsub=Browser("brwMain").Page("pgeShoppingBag")
								strRowCnt=Browser("brwMain").Page("pgeShoppingBag").WebTable("tblItems").GetROProperty("rows")
								Set tblObj=objsub.WebTable("tblItems")
								Set elmObj=objsub.WebElement("elmGeneral")
			
								'Taking the sub total
								For i=0 to strRowCnt
									strCellValue=tblObj.GetCellData(i,1)
									If INSTR(strCellValue,"subtotal")>0 Then
										'Get the subtotal value
										strSubTotalVal=tblObj.GetCellData(i,2)
										strSubTotalVal=CDBL(strSubTotalVal)
									End if
								Next
								'2. Check the shipping charge based on the total $ 
								'Shipping charge for Keds

								If ModuleName="Keds" Then							
												If(strSubTotalVal) < 10 then								
														strStdShp="$2.50"
														strExpShp="$6.50"
														totalOrderRange = "<= $10.00"
													Elseif (strSubTotalVal >= 10 AND strSubTotalVal < 50) Then
														strStdShp="$5.00"
														strExpShp="$16.50"
														totalOrderRange = ">= $10.00 and < $50.00"
													Elseif (strSubTotalVal >= 50 AND strSubTotalVal < 100) Then
														strStdShp="$5.00"
														strExpShp="$18.50"
														totalOrderRange = ">= $50.00 and < $100.00"
													Elseif (strSubTotalVal >=100) Then
													   strStdShp="$5.00"
														strExpShp="$20.50"
														totalOrderRange = ">= $100.00"
													End If
								'Shipping charge for Sperry
								Elseif ModuleName="Sperry" Then
													If(strSubTotalVal) <= 24 then								
														strStdShp="$2.00"
														strExpShp="$15.00"
														totalOrderRange = "<= $24.00"
													Elseif (strSubTotalVal > 24 AND strSubTotalVal < 150) Then
														strStdShp="$6.95"
														strExpShp="$15.00"
														totalOrderRange = "> $24.00 and < $150.00"
													Elseif (strSubTotalVal >=150) Then
													   strStdShp="$0.00"
														strExpShp="$15.00"
														totalOrderRange = ">= $150.00"
													End If
								End If

							strStdShpVal="Standard delivery - " &  strStdShp
							strExpShpVal="Express delivery - " &  strExpShp

							'Standard shipping method
							objsub.WebList("lstShippingMethod").Select 0
							Browser("brwMain").Sync
							elmObj.SetTOProperty "innertext", strStdShpVal
							elmObj.SetTOProperty "html tag", "P"

							If elmObj.Exist (3) Then
								elmObj.Highlight
								stdDelevery = true
							Else
								stdDelevery = false
							End If

							'Express shipping method
							objsub.WebList("lstShippingMethod").Select 1
							Browser("brwMain").Sync
							elmObj.SetTOProperty "innertext", strExpShpVal
							elmObj.SetTOProperty "html tag", "P"

							If elmObj.Exist (3) Then
								elmObj.Highlight
								expDelevery = true
							Else
								expDelevery = false
							End If

							'Results
							'For standard delivery

							If   stdDelevery Then
									strDesc ="SHIPPINGCHARGES: Shipping method Standard delivery is displyed as " & chr(34) & strStdShp & chr(34) & " for the total amount $" & strSubTotalVal & " which is in the rage " & totalOrderRange
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micPass,"Step SHIPPINGCHARGES", strDesc
									Reporter.Filter = rfDisableAll
								Else
									strDesc ="SHIPPINGCHARGES: Shipping method charge not displyed as expected " & strStdShpVal & " which is in the rage " & totalOrderRange
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1 & strLabel , objEnvironmentVariables
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micFail,"Step SHIPPINGCHARGES", strDesc
									objEnvironmentVariables.TestCaseStatus=False
									Reporter.Filter = rfDisableAll
								End If

							'For Express delivery
							If   expDelevery Then
									strDesc ="SHIPPINGCHARGES: Shipping method Express delivery is displyed as " & chr(34) & strExpShp & chr(34) & " for the total amount $" & strSubTotalVal & ", which is in the rage " & totalOrderRange
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micPass,"Step SHIPPINGCHARGES", strDesc
									Reporter.Filter = rfDisableAll
								Else
									strDesc ="SHIPPINGCHARGES: Shipping method charge not displyed as expected " & strExpShp & ", which is in the rage " & totalOrderRange
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1 & strLabel , objEnvironmentVariables
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micFail,"Step SHIPPINGCHARGES", strDesc
									objEnvironmentVariables.TestCaseStatus=False
									Reporter.Filter = rfDisableAll
								End If

					END Function


'=======================================================================================================================================================================

'********************************************************************************************************************************************************
'FUNCTION HEADER
'********************************************************************************************************************************************************
'Name: FnVerifyAddnViews
'Description: This function is used to verify the additional views in the add to shopping bag
'Creation Date : 23-June-2010
'Created By: Ramgopal Narayanan (229673)
'Application: PAYLESS ECOM
'Output: Returns nothing 

Function FnVerifyAddnViews(ByRef objsub , ByVal Object_Name, ByVal strInputValue, ByVal strDbValue, ByVal strOptParam, ByRef clsReport, ByRef objEnvironmentVariables , ByRef clsScreenShot ,ByVal iRowCnt ,ByVal Screen_shot_path ,ByVal strSheet_Name ,ByVal strLabel , ByVal strExpectedValue , ByVal strTestDataReference, ByVal ModuleName)			

				strProductName=Environment.Value("ProdName")


				Set objsub=Browser("brwMain").Page("pgeAddtoBag")
				Set objContainer=objsub.WebElement("elmAdditionalViewsContainer")
			
				If ModuleName="Keds"  Then
					If strOptParam<>"" AND  strOptParam="PROKEDS" Then
						objsub.Image("imgProduct").SetTOProperty "alt","P.*"
					Else
						objsub.Image("imgProduct").SetTOProperty "alt","K.*"
					End If
				End If
			
			'1. Set the description for the additional views image
				Set imgObj = Description.Create()
				imgObj("micclass").Value = "Image"
				imgObj("html tag").Value = "IMG"
				imgObj("html id").Value = "additionalImage"
				Set imgAddVwObj=objContainer.ChildObjects(imgObj)
				Set objAdView=objsub.Image("imgAdditionalViews")
			
			'2. Check if the additional views section is available or not
				If objsub.WebElement("elmAdditionalViews").Exist(2) AND objsub.Image("imgAdditionalViews").Exist(2) Then
					For  objCount=imgAddVwObj.count-1To 0 Step -1
			'3. Choose an additional view and check if the corresponding image is displayed @ the top

						objAdView.SetTOProperty "index",objCount
						strAdnViewFileName=objAdView.GetROProperty("file name")
						objAdView.Click
						Wait 5
						'A.)Get the file name of the addn view
                        strTemp=Split(strAdnViewFileName,"x")
						strTemp1=Split(strTemp(0),"_")
						strPart1=strTemp1(0) 'Part1
						strTemp2=Split(strTemp1(1),"_")
						strPart2=strTemp2(0) 'Part2
						strAdnViewFileName=strPart1 &"_" & strPart2
			
						'B.)Get the file name of the product image
						If Environment.Value ("BrowserName")="Firefox" Then
								strProductImgFileName=Browser("brwGeneral_FireFox").Page("pgeGeneral_FireFox").Image("imgGeneral_Plain").GetROProperty("file name")
						Else
								strProductImgFileName=objsub.Image("imgProduct").GetROProperty("file name")
						End If

						If Environment.Value ("BrowserName")="Firefox" Then
							Browser("brwGeneral_FireFox").Back
							Wait 10
						End If

						If INSTR(strProductImgFileName,strAdnViewFileName)>0 Then
							strDesc ="VERIFYPRODADDNVIEWS: The corresponding product image with value " & chr(34) & strProductImgFileName & chr(34) & " is displayed correctly, when the additional view image - " & chr(34) & strAdnViewFileName & chr(34) & " is clicked."
							clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
							Reporter.Filter = rfEnableAll 
							Reporter.ReportEvent micPass,"Step VERIFYPRODADDNVIEWS", strDesc
							Reporter.Filter = rfDisableAll
						Else
							strDesc ="VERIFYPRODADDNVIEWS: The corresponding product image is displayed incorrecly with value " & chr(34) & strProductImgFileName & chr(34) & ", when the additional view image - " & chr(34) & strAdnViewFileName & chr(34) & " is clicked."
							clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
							clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
							Reporter.Filter = rfEnableAll 
							Reporter.ReportEvent micFail,"Step VERIFYPRODADDNVIEWS", strDesc
							objEnvironmentVariables.TestCaseStatus=False
							Reporter.Filter = rfDisableAll
						End If
					Next	
				Else			
			'2.A. No additional views
					strDesc = "<B><I>VERIFYPRODADDNVIEWS: There are no additional views available for the product " & chr(34) & strProductName & chr(34) &".</B></I>" 
					Reporter.Filter = rfEnableAll
					Reporter.ReportEvent micdone,"Step VERIFYPRODADDNVIEWS ", strDesc
					Reporter.Filter = rfDisableAll 
					clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2	
				End If
			
				Set imgAddVwObj=Nothing


		End Function
'==========================================================================================================================================================================
'********************************************************************************************************************************************************
'FUNCTION HEADER
'********************************************************************************************************************************************************
'Name: FnVerifyYouMayAlsoLike
'Description: This function is used to verify the YouMayAlsoLike section under the add to shopping bag page
'Creation Date : 23-June-2010
'Created By: Ramgopal Narayanan (229673)
'Application: PAYLESS ECOM
'Output: Returns nothing 

Function FnVerifyYouMayAlsoLike(ByRef objsub , ByVal Object_Name, ByVal strInputValue, ByVal strDbValue, ByVal strOptParam, ByRef clsReport, ByRef objEnvironmentVariables , ByRef clsScreenShot ,ByVal iRowCnt ,ByVal Screen_shot_path ,ByVal strSheet_Name ,ByVal strLabel , ByVal strExpectedValue , ByVal strTestDataReference, ByVal ModuleName)			


				strProductName=Environment.Value("ProdName")

'				Set objsub=Browser("brwMain").Page("pgeAddtoBag")
'			
'				If ModuleName="Keds"  Then
'					If strOptParam<>"" AND  strOptParam="PROKEDS" Then
'						objsub.Image("imgProduct").SetTOProperty "alt","P.*"
'					Else
'						objsub.Image("imgProduct").SetTOProperty "alt","K.*"
'					End If
'				End If
'
''1. Get all the "you may also like" images 
'				Set objContainer=objsub.WebElement("elmYouMightAlsoLikeSection")
'				Set imgObj = Description.Create()
'				imgObj("micclass").Value = "Image"
'				imgObj("html tag").Value = "IMG"
'				imgObj("class").Value = "thumb"
'				Set imgYMALObj=objContainer.ChildObjects(imgObj)
'				Set objYMAL=objsub.Image("imgYouMayAlsoLike")
'				
''2. Check if the you may also like section is available or not
'				If objsub.WebElement("elmYouMightAlsoLike").Exist(2) Then
'					
''3. Check if the You might Also like' section displays a maximum of 4 up sell products					
'					If  imgYMALObj.count>0 AND imgYMALObj.count <=4 Then
'						strDesc ="VERIFYYOUMAYALSOLIKE: The total number of products displayed under the 'You May Also Like Section' is " & imgYMALObj.count & "."
'						clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
'						Reporter.Filter = rfEnableAll 
'						Reporter.ReportEvent micPass,"Step VERIFYYOUMAYALSOLIKE", strDesc
'						Reporter.Filter = rfDisableAll
'					ElseIf imgYMALObj.count>4 Then
'						strDesc ="VERIFYYOUMAYALSOLIKE: The total number of products displayed under the 'You May Also Like Section' is " & imgYMALObj.count & ", which is more than the expected value of 4."
'						clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
'						clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
'						Reporter.Filter = rfEnableAll 
'						Reporter.ReportEvent micFail,"Step VERIFYYOUMAYALSOLIKE", strDesc
'						objEnvironmentVariables.TestCaseStatus=False
'						Reporter.Filter = rfDisableAll
'					Else
'						strDesc ="VERIFYYOUMAYALSOLIKE: The total number of products displayed under the 'You May Also Like Section' is " & imgYMALObj.count & ". No products images are displayed inspite of the section being available."
'						clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
'						clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
'						Reporter.Filter = rfEnableAll 
'						Reporter.ReportEvent micFail,"Step VERIFYYOUMAYALSOLIKE", strDesc
'						objEnvironmentVariables.TestCaseStatus=False
'						Reporter.Filter = rfDisableAll
'					End If
''4. Click on any of the products displayed in 'You might also like' section'.
'					If  imgYMALObj.count>0Then ' Proceed if atleast one prod is displayed
'
'                    	For objCount=0 to imgYMALObj.count-1
'
''							strYMALProdName=imgYMALObj(objCount).GetROProperty("alt")'Get the name of the prod
''
''							imgYMALObj(objCount).Click
''							Wait 10
'
'							Browser("brwMain").Sync
'							objYMAL.SetTOProperty "index",objCount
'							strYMALProdName=objYMAL.GetROProperty("alt")
'
'							objYMAL.Click
'							 Browser("brwMain").Sync
'
'							'Check if the user is taken to corresponding prod page 
'							Set elmObj=objsub.Image("imgProduct")
'							elmObj.SetTOProperty "alt",strYMALProdName
'
'							If elmObj.Exist(15) Then
'									elmObj.Highlight
'									strDesc ="VERIFYYOUMAYALSOLIKE: User is directed the product details page of the product " & chr(34) & strYMALProdName & chr(34) & " on clicking on the thumbnail of the product " & chr(34) & strYMALProdName & chr(34) & ", as expected."
'									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
'									Reporter.Filter = rfEnableAll 
'									Reporter.ReportEvent micPass,"Step VERIFYYOUMAYALSOLIKE", strDesc
'									Reporter.Filter = rfDisableAll
'							Else
'									strDesc ="VERIFYYOUMAYALSOLIKE: User is not directed the correct product details page on clicking on the thumbnail of the product " & chr(34) & strYMALProdName & chr(34) & "."
'									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
'									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
'									Reporter.Filter = rfEnableAll 
'									Reporter.ReportEvent micFail,"Step VERIFYYOUMAYALSOLIKE", strDesc
'									objEnvironmentVariables.TestCaseStatus=False
'									Reporter.Filter = rfDisableAll	
'							End If
'							Browser("brwMain").Back
'							Wait 10	
'	
'						Next
'
'					Else
'						strDesc ="VERIFYYOUMAYALSOLIKE: No product images are displayed under the 'You May Also Like' section in-order to proceed further."
'						clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
'						clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
'						Reporter.Filter = rfEnableAll 
'						Reporter.ReportEvent micFail,"Step VERIFYYOUMAYALSOLIKE", strDesc
'						objEnvironmentVariables.TestCaseStatus=False
'						Reporter.Filter = rfDisableAll
'					End If
'				Else			
'			'2.A. No YOUMAYALSOLIKE sections
'					strDesc = "<B><I>VERIFYYOUMAYALSOLIKE: You may also like section isn't available for the product " & chr(34) & strProductName & chr(34) &".</B></I>" 
'					Reporter.Filter = rfEnableAll
'					Reporter.ReportEvent micdone,"Step VERIFYYOUMAYALSOLIKE ", strDesc
'					Reporter.Filter = rfDisableAll 
'					clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2	
'				End If
'			
'				Set imgYMALObj=Nothing
'				Set objContainer=Nothing
'				Set elmobj=Nothing

	Set objsub=Browser("brwMain").Page("pgeAddtoBag")
			
				If ModuleName="Keds"  Then
					If strOptParam<>"" AND  strOptParam="PROKEDS" Then
						objsub.Image("imgProduct").SetTOProperty "alt","P.*"
					Else
						objsub.Image("imgProduct").SetTOProperty "alt","K.*"
					End If
				End If

'1. Get all the "you may also like" images 
				Set objContainer=objsub.WebElement("elmYouMightAlsoLikeSection")
				Set imgObj = Description.Create()
				imgObj("micclass").Value = "Image"
				imgObj("html tag").Value = "IMG"
				imgObj("class").Value = "thumb"
				Set imgYMALObj=objContainer.ChildObjects(imgObj)

				'Get the product links under the you may like section
				Set prodLnkObj = Description.Create()
				prodLnkObj("micclass").Value = "Link"
				prodLnkObj("html tag").Value = "A"
				Set imgYMALProdLnkObj=objContainer.ChildObjects(prodLnkObj)

				Set objYMAL=objsub.Image("imgYouMayAlsoLike")
				
'2. Check if the you may also like section is available or not
				If objsub.WebElement("elmYouMightAlsoLike").Exist(2) Then
					
'3. Check if the You might Also like' section displays a maximum of 4 up sell products					
					If  imgYMALObj.count>0 AND imgYMALObj.count <=4 Then
						strDesc ="VERIFYYOUMAYALSOLIKE: The total number of products displayed under the 'You May Also Like Section' is " & imgYMALObj.count & "."
						clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
						Reporter.Filter = rfEnableAll 
						Reporter.ReportEvent micPass,"Step VERIFYYOUMAYALSOLIKE", strDesc
						Reporter.Filter = rfDisableAll
					ElseIf imgYMALObj.count>4 Then
						strDesc ="VERIFYYOUMAYALSOLIKE: The total number of products displayed under the 'You May Also Like Section' is " & imgYMALObj.count & ", which is more than the expected value of 4."
						clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
						clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
						Reporter.Filter = rfEnableAll 
						Reporter.ReportEvent micFail,"Step VERIFYYOUMAYALSOLIKE", strDesc
						objEnvironmentVariables.TestCaseStatus=False
						Reporter.Filter = rfDisableAll
					Else
						strDesc ="VERIFYYOUMAYALSOLIKE: The total number of products displayed under the 'You May Also Like Section' is " & imgYMALObj.count & ". No products images are displayed inspite of the section being available."
						clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
						clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
						Reporter.Filter = rfEnableAll 
						Reporter.ReportEvent micFail,"Step VERIFYYOUMAYALSOLIKE", strDesc
						objEnvironmentVariables.TestCaseStatus=False
						Reporter.Filter = rfDisableAll
					End If
'4. Click on any of the products displayed in 'You might also like' section'.
					If  imgYMALObj.count>0Then ' Proceed if atleast one prod is displayed

                    	For objCount=0 to imgYMALObj.count-1

'							strYMALProdName=imgYMALObj(objCount).GetROProperty("alt")'Get the name of the prod
'
'							imgYMALObj(objCount).Click
'							Wait 10


							Browser("brwMain").Sync
							objYMAL.SetTOProperty "index",objCount
							strYMALProdName=objYMAL.GetROProperty("alt")
							'Get the last name of the product
							strTempVar=Split(strYMALProdName," ")
							strYMLProdName=TRIM(strTempVar(UBOUND(strTempVar)-1) & " " & strTempVar(UBOUND(strTempVar)))
							

							objYMAL.Click
							Browser("brwMain").Sync

							'Check if the user is taken to corresponding prod page 
'							Set elmObj=objsub.Image("imgProduct")
'							elmObj.SetTOProperty "alt",strYMALProdName
							Set expProdName=Browser("brwMain").Page("pgeAddtoBag").WebElement("elmGeneralRegEx")
							expProdName.SetTOProperty "html tag","STRONG"
							expProdName.SetTOProperty "innertext",".*" & strYMLProdName & ".*"
							

							If expProdName.Exist(10) Then

									expProdName.Highlight
									strDesc ="VERIFYYOUMAYALSOLIKE: User is directed the product details page of the product " & chr(34) & strYMALProdName & chr(34) & " on clicking on the thumbnail of the product " & chr(34) & strYMALProdName & chr(34) & ", as expected."
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micPass,"Step VERIFYYOUMAYALSOLIKE", strDesc
									Reporter.Filter = rfDisableAll
							Else

									strDesc ="VERIFYYOUMAYALSOLIKE: User is not directed the correct product details page on clicking on the thumbnail of the product " & chr(34) & strYMALProdName & chr(34) & "."
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micFail,"Step VERIFYYOUMAYALSOLIKE", strDesc
									objEnvironmentVariables.TestCaseStatus=False
									Reporter.Filter = rfDisableAll	
							End If

							Browser("brwMain").Back
							Browser("brwMain").Sync
	
						Next

					Else
						strDesc ="VERIFYYOUMAYALSOLIKE: No product images are displayed under the 'You May Also Like' section in-order to proceed further."
						clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
						clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
						Reporter.Filter = rfEnableAll 
						Reporter.ReportEvent micFail,"Step VERIFYYOUMAYALSOLIKE", strDesc
						objEnvironmentVariables.TestCaseStatus=False
						Reporter.Filter = rfDisableAll
					End If
				Else			
			'2.A. No YOUMAYALSOLIKE sections
					strDesc = "<B><I>VERIFYYOUMAYALSOLIKE: You may also like section isn't available for the product " & chr(34) & strProductName & chr(34) &".</B></I>" 
					Reporter.Filter = rfEnableAll
					Reporter.ReportEvent micdone,"Step VERIFYYOUMAYALSOLIKE ", strDesc
					Reporter.Filter = rfDisableAll 
					clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2	
				End If
			
				Set imgYMALObj=Nothing
				Set objContainer=Nothing
				Set elmobj=Nothing


		End Function
'==========================================================================================================================================================================
'==========================================================================================================================================================================
'********************************************************************************************************************************************************
'FUNCTION HEADER
'********************************************************************************************************************************************************
'Name: FnVerifyResultAndPagination
'Description: This function is used to verify the results displayed section and pagination
'Creation Date : 28-June-2010
'Created By: Ramgopal Narayanan (229673)
'Application: PAYLESS ECOM
'Output: Returns nothing 

Function FnVerifyResultAndPagination(ByRef objsub , ByVal Object_Name, ByVal strInputValue, ByVal strDbValue, ByVal strOptParam, ByRef clsReport, ByRef objEnvironmentVariables , ByRef clsScreenShot ,ByVal iRowCnt ,ByVal Screen_shot_path ,ByVal strSheet_Name ,ByVal strLabel , ByVal strExpectedValue , ByVal strTestDataReference, ByVal ModuleName)			

																Set objsub=Browser("brwMain").Page("pgeProductList")
																Set lnkGenObj=Browser("brwMain").Page("pgeProductList").Link("lnkGeneral")
																Set lnkPaginationObj=Browser("brwMain").Page("pgeProductList").Link("lnkPagination")

																'1. Check if the 'Displaying 1-20 of n results' is displayed
                                                                If objsub.WebElement("elmResultsDisplayed").Exist(2) Then
                                                                    elmResfnd=objsub.WebElement("elmResultsDisplayed").GetROProperty("innertext")            
																	objsub.WebElement("elmResultsDisplayed").Highlight
																	strDesc ="VERIFYRESULTANDPAGINATION: The results displayed section is displayed. The value displayed is " &chr(34) & elmResfnd & chr(34) & "."
																	clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
																	Reporter.Filter = rfEnableAll 
																	Reporter.ReportEvent micPass,"Step VERIFYRESULTANDPAGINATION", strDesc
																	Reporter.Filter = rfDisableAll																		
																Else
																	strDesc ="VERIFYRESULTANDPAGINATION: The results displayed section is not displayed."
																	clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
																	clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
																	Reporter.Filter = rfEnableAll 
																	Reporter.ReportEvent micFail,"Step VERIFYRESULTANDPAGINATION", strDesc
																	objEnvironmentVariables.TestCaseStatus=False
																	Reporter.Filter = rfDisableAll	
                                                                End If

																'2. Check for the previous , next , paginations, view all links based on number of shoes/pages available available
																If  elmResfnd<>""Then
																	arrTemp=split(elmResfnd,"of")
																	arrTemp1=split(arrTemp(1),"results")
																	strProdDisp=CINT(TRIM(arrTemp1(0)))
																	strInputValue=CINT(strInputValue)
																	strNoOfPages=(strProdDisp\strInputValue)+1
                
                                                                    'A. ** When the results displayed >  20
																	If strProdDisp>strInputValue Then
																		strLnkToCheck="Previous~Next~View All"
																		arrLnkToCheck=Split(strLnkToCheck,"~")
																		
																		'NEXT, PREVIOUS and VIEWALL Links at the top and bottom part of the product page
																		For indexCnt=0 to 1
																			For i=0 to UBOUND(arrLnkToCheck)
																					lnkPaginationObj.SetTOProperty "text",arrLnkToCheck(i)
																					lnkPaginationObj.SetTOProperty "index",indexCnt
																					If  indexCnt=0 Then
																						strPos="TOP"
																					Else
																						strPos="BOTTOM"
																					End If
																					If  lnkPaginationObj.Exist(2) Then
																						lnkPaginationObj.Highlight
																						strDesc ="VERIFYRESULTANDPAGINATION: The " & UCASE(arrLnkToCheck(i)) & " link at the " & strPos &  " of the productlist is displayed."
																						clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
																						Reporter.Filter = rfEnableAll 
																						Reporter.ReportEvent micPass,"Step VERIFYRESULTANDPAGINATION", strDesc
																						Reporter.Filter = rfDisableAll		
																					Else
																						strDesc ="VERIFYRESULTANDPAGINATION: The " & UCASE(arrLnkToCheck(i)) & " link at the " & strPos &  " of the productlist is NOT displayed."
																						clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
																						clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
																						Reporter.Filter = rfEnableAll 
																						Reporter.ReportEvent micFail,"Step VERIFYRESULTANDPAGINATION", strDesc
																						objEnvironmentVariables.TestCaseStatus=False
																						Reporter.Filter = rfDisableAll	
																					End If																		
																			Next
																		Next

																		'Check for PAGINATION
																		For indexCnt=0 to 1
																			If strNoOfPages>5 Then
																				strNoOfPages=5
																			End If
																			If  indexCnt=0 Then
																					strPos="TOP"
																			Else
																					strPos="BOTTOM"
																			End If
																			For i=1 to strNoOfPages
																			         lnkGenObj.SetTOProperty "text",CSTR(i)
																					 lnkGenObj.SetTOProperty "innerhtml",CSTR(i)
                                                                                     lnkGenObj.SetTOProperty "Index",indexCnt
                                                                                     If  lnkGenObj.Exist(2) Then
																						lnkGenObj.Highlight
																						strDesc ="VERIFYRESULTANDPAGINATION: The pagination link " & i & " at the " & strPos &  " of the productlist is displayed."
																						clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
																						Reporter.Filter = rfEnableAll 
																						Reporter.ReportEvent micPass,"Step VERIFYRESULTANDPAGINATION", strDesc
																						Reporter.Filter = rfDisableAll		
																					Else
																						strDesc ="VERIFYRESULTANDPAGINATION: The pagination link " & i & " at the " & strPos &  " of the productlist is NOT displayed."
																						clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
																						clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
																						Reporter.Filter = rfEnableAll 
																						Reporter.ReportEvent micFail,"Step VERIFYRESULTANDPAGINATION", strDesc
																						objEnvironmentVariables.TestCaseStatus=False
																						Reporter.Filter = rfDisableAll	
																					End If  
																			Next
																		Next				

																	Else
																		'***** B. LESS than the 20 results per page
																		strLnkToCheck="Previous~Next"
																		arrLnkToCheck=Split(strLnkToCheck,"~")
																		
																		'NEXT, PREVIOUS Links at the top and bottom part of the product page
																		For indexCnt=0 to 1
																			For i=0 to UBOUND(arrLnkToCheck)
																					lnkPaginationObj.SetTOProperty "text",arrLnkToCheck(i)
																					lnkPaginationObj.SetTOProperty "index",indexCnt
																					If  indexCnt=0 Then
																						strPos="TOP"
																					Else
																						strPos="BOTTOM"
																					End If
																					If  lnkPaginationObj.Exist(2) Then
																						lnkGenObj.Highlight
																						strDesc ="VERIFYRESULTANDPAGINATION: The " & UCASE(arrLnkToCheck(i)) & " link at the " & strPos &  " of the productlist is displayed."
																						clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
																						Reporter.Filter = rfEnableAll 
																						Reporter.ReportEvent micPass,"Step VERIFYRESULTANDPAGINATION", strDesc
																						Reporter.Filter = rfDisableAll		
																					Else
																						strDesc ="VERIFYRESULTANDPAGINATION: The " & UCASE(arrLnkToCheck(i)) & " link at the " & strPos &  " of the productlist is NOT displayed."
																						clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
																						clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
																						Reporter.Filter = rfEnableAll 
																						Reporter.ReportEvent micFail,"Step VERIFYRESULTANDPAGINATION", strDesc
																						objEnvironmentVariables.TestCaseStatus=False
																						Reporter.Filter = rfDisableAll	
																					End If																		
																			Next
																		Next

																		'Check for PAGINATION
																		For indexCnt=0 to 1
																			If  indexCnt=0 Then
																					strPos="TOP"
																			Else
																					strPos="BOTTOM"
																			End If
																			For i=1 to strNoOfPages
																			         lnkGenObj.SetTOProperty "text",CSTR(i)
																					 lnkGenObj.SetTOProperty "innerhtml",CSTR(i)
                                                                                     lnkGenObj.SetTOProperty "Index",indexCnt
                                                                                     If  lnkGenObj.Exist(2) Then
																						lnkGenObj.Highlight
																						strDesc ="VERIFYRESULTANDPAGINATION: The pagination link " & i & " at the " & strPos &  " of the productlist is displayed."
																						clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
																						Reporter.Filter = rfEnableAll 
																						Reporter.ReportEvent micPass,"Step VERIFYRESULTANDPAGINATION", strDesc
																						Reporter.Filter = rfDisableAll		
																					Else
																						strDesc ="VERIFYRESULTANDPAGINATION: The pagination link " & i & " at the " & strPos &  " of the productlist is NOT displayed."
																						clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
																						clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
																						Reporter.Filter = rfEnableAll 
																						Reporter.ReportEvent micFail,"Step VERIFYRESULTANDPAGINATION", strDesc
																						objEnvironmentVariables.TestCaseStatus=False
																						Reporter.Filter = rfDisableAll	
																					End If  
																			Next
																		Next
																	End If                  																	
																Else
																	strDesc ="VERIFYRESULTANDPAGINATION: The results displayed section is not displayed. So cannot proceed with the pagination calculation as it is dependant on the result displayed"
																	clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
																	clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
																	Reporter.Filter = rfEnableAll 
																	Reporter.ReportEvent micFail,"Step VERIFYRESULTANDPAGINATION", strDesc
																	objEnvironmentVariables.TestCaseStatus=False
																	Reporter.Filter = rfDisableAll	
																End If
																lnkGenObj.SetTOProperty "text",""
																lnkPaginationObj.SetTOProperty "text",""
																Set lnkGenObj=Nothing
																Set lnkPaginationObj=Nothing
																Set objsub=Nothing


		End Function
'==========================================================================================================================================================================

'=======================================================================================================================================================================

'********************************************************************************************************************************************************
'FUNCTION HEADER
'********************************************************************************************************************************************************
'Name: FnOrderTotal
'Description: In order to verify the Total Order Price in Order History Page which should be Prefixxed with $ and Suffixed with 2 digits after decimals
'Creation Date : 18-June-2010
'Created By: Govardhan
'Application: PAYLESS ECOM
'Output: Returns nothing 
'
Function FnOrderTotal(ByRef objsub , ByVal Object_Name, ByVal strInputValue, ByVal strDbValue, ByVal strOptParam, ByRef clsReport, ByRef objEnvironmentVariables ,	ByRef clsScreenShot ,ByVal iRowCnt ,ByVal Screen_shot_path ,ByVal strSheet_Name ,ByVal strLabel , ByVal strExpectedValue , ByVal strTestDataReference, ByVal ModuleName) 
			Set obj = Browser("brwMain").Page("pgeMyAccount").WebTable("tblOrderSummary")	
					Rcnt=obj.RowCount
					obj.highlight
					For i=2 to Rcnt
						Tagexpected=FALSE
						PriceExpected=FALSE
						OrdPrice=TRIM(obj.GetCellData(i,3))
						OrdNum=TRIM(obj.GetCellData(i,2))
						PriceTag=Left(OrdPrice,1)
						If PriceTag="$" Then
							Tagexpected=TRUE
						End If
						ArrPrice=split(OrdPrice,".")
						If len(ArrPrice(1))=2 Then
							PriceExpected=TRUE
						End If
						If UCase(PriceExpected)="TRUE" and UCase(Tagexpected)="TRUE" Then
							strDesc = "VERIFYORDERTOTAL: Order Price "& chr(34) & OrdPrice & chr(34) &" for Order Number "& chr(34) & OrdNum & chr(34) &" is Preffixed with $ and Suffixed with "& chr(34) & ArrPrice(1) & chr(34) &" after Decimal as Expected."
							clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1								
							Reporter.Filter = rfEnableAll 
							Reporter.ReportEvent micPass,"Step VERIFYORDERTOTAL", strDesc							 
							Reporter.Filter = rfDisableAll
						Else							
							strDesc = "VERIFYORDERTOTAL: Order Price "& chr(34) & OrdPrice & chr(34) &" for Order Number "& chr(34) & OrdNum & chr(34) &" is  Preffixed with " & chr(34) & PriceTag & chr(34) &"and Suffixed with " & chr(34) & PriceTag & chr(34) &" after Decimal, when it's not expected to be so."
							clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
							clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
							Reporter.Filter = rfEnableAll 
							Reporter.ReportEvent micFail,"Step VERIFYORDERTOTAL", strDesc
							objEnvironmentVariables.TestCaseStatus=False
							Reporter.Filter = rfDisableAll
						End If
					Next

			END Function


'=======================================================================================================================================================================

'********************************************************************************************************************************************************
'FUNCTION HEADER
'********************************************************************************************************************************************************
'Name: FnSearchSorting
'Description: In order to verify the Search Results Soring in Search Page based on Relevance,highest Price first and lowest Pricewhich should be Prefixxed with $ and Suffixed with 2 digits after decimals
'Creation Date : 18-June-2010
'Created By: Govardhan
'Application: PAYLESS ECOM
'Output: Returns nothing 
'
					Function FnSearchSorting(ByRef objsub , ByVal Object_Name, ByVal strInputValue, ByVal strDbValue, ByVal strOptParam, ByRef clsReport, ByRef objEnvironmentVariables ,	ByRef clsScreenShot ,ByVal iRowCnt ,ByVal Screen_shot_path ,ByVal strSheet_Name ,ByVal strLabel , ByVal strExpectedValue , ByVal strTestDataReference, ByVal ModuleName) 
                
								Select Case strOptParam
								Case "RELEVANCE"
									blnkeyWord=FALSE
									arrVal=strInputValue
									Set lnkObj = Description.Create()
									lnkObj("micclass").Value = "Link"
									lnkObj("html tag").Value = "A"
									Set obj=Browser("brwMain").Page("pgeProductList").WebElement("elmProductList").ChildObjects(lnkObj)
									For i=0 to obj.count-1
										strActual=	Obj(i).getroproperty("innertext")
										If INSTR(strActual,strInputValue)>=0 Then
											blnkeyWord=TRUE
											Exit For													
										End If													
									Next
									If UCase(blnkeyWord)="TRUE" Then
									strDesc = "VLDSEARCHSORTING: Search results are sorted by "& chr(34) & strOptParam & chr(34) &" and contain(s) Keyword "& chr(34) & arrVal & chr(34) &" as Expected."
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1								
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micPass,"Step VLDSEARCHSORTING", strDesc							 
									Reporter.Filter = rfDisableAll
								Else							
									strDesc = "VLDSEARCHSORTING: Search results are sorted by "& chr(34) & strOptParam & chr(34) &" and doesn't contain Keyword "& chr(34) & arrVal & chr(34) &"which is not as Expected."
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micFail,"Step VLDSEARCHSORTING", strDesc
									objEnvironmentVariables.TestCaseStatus=False
									Reporter.Filter = rfDisableAll
							End If

								Case "HIGHESTPRICE"
									blnExpected=TRUE
									arrVal=""
									Set elmObj = Description.Create()
									elmObj("micclass").Value = "WebElement"
									elmObj("html tag").Value = "DIV"
									elmObj("class").value="price"
									Set obj=Browser("brwMain").Page("pgeProductList").WebElement("elmProductList").ChildObjects(elmObj)
									For i=0 to obj.count-1
										' Get price from each product for each iteration
										FirstVal=SecVal
										ArrSPrice=split(TRIM(obj(i).getroproperty("innertext"))," ")
										If UBOUND(ArrSPrice)>0 Then
											If ModuleName="Original" OR ModuleName="Performance" Then
												SecVal=ArrSPrice(UBOUND(ArrSPrice))
											ElseIf ModuleName="Sperry" OR ModuleName="Keds" Then
												SecVal=ArrSPrice(0)
											End If
										Else
										   SecVal=ArrSPrice(0)
										End If
										'Passing the set of Price tags to a variable to generate Report
										arrVal=arrVal & ":" & SecVal
										If CDBL(FirstVal)<CDBL(SecVal) AND i<>0 Then
											blnExpected=FALSE
											Exit For
										End If
									Next
									If UCase(blnExpected)="TRUE"  Then
										strDesc = "VLDSEARCHSORTING: Search results are sorted by "& chr(34) & strOptParam & chr(34) &" and displayed with the values "& chr(34) & arrVal & chr(34) &" as Expected."
										clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1								
										Reporter.Filter = rfEnableAll 
										Reporter.ReportEvent micPass,"Step VLDSEARCHSORTING", strDesc							 
										Reporter.Filter = rfDisableAll
									Else							
										strDesc = "VLDSEARCHSORTING: Search results are sorted by "& chr(34) & strOptParam & chr(34) &" and displayed with the values "& chr(34) & arrVal & chr(34) &"which is not as Expected."
										clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
										clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
										Reporter.Filter = rfEnableAll 
										Reporter.ReportEvent micFail,"Step VLDSEARCHSORTING", strDesc
										objEnvironmentVariables.TestCaseStatus=False
										Reporter.Filter = rfDisableAll
									End If
								

								Case "LOWESTPRICE"
									blnExpected=TRUE
									arrVal=""
									Set elmObj = Description.Create()
									elmObj("micclass").Value = "WebElement"
									elmObj("html tag").Value = "DIV"
									elmObj("class").value="price"
									Set obj=Browser("brwMain").Page("pgeProductList").WebElement("elmProductList").ChildObjects(elmObj)
									 For i=0 to obj.count-1
										' Get price from each product for each iteration
										FirstVal=SecVal
										ArrSPrice=split(TRIM(obj(i).getroproperty("innertext"))," ")
										If UBOUND(ArrSPrice)>0 Then
											If ModuleName="Original" OR ModuleName="Performance" Then
												SecVal=ArrSPrice(UBOUND(ArrSPrice))
											ElseIf ModuleName="Sperry" OR ModuleName="Keds" Then
												SecVal=ArrSPrice(0)
											End If
										Else
										   SecVal=ArrSPrice(0)
										End If
										'Passing the set of Price tags to a variable to generate Report
										arrVal=arrVal & ":" & SecVal
										If CDBL(FirstVal)>CDBL(SecVal) AND i<>0 Then
											blnExpected=FALSE
											Exit For
										End If
									Next
									If UCase(blnExpected)="TRUE"  Then
										strDesc = "VLDSEARCHSORTING: Search results are sorted by "& chr(34) & strOptParam & chr(34) &" and displayed with the values "& chr(34) & arrVal & chr(34) &" as Expected."
										clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1								
										Reporter.Filter = rfEnableAll 
										Reporter.ReportEvent micPass,"Step VLDSEARCHSORTING", strDesc							 
										Reporter.Filter = rfDisableAll
									Else							
										strDesc = "VLDSEARCHSORTING: Search results are sorted by "& chr(34) & strOptParam & chr(34) &" and displayed with the values "& chr(34) & arrVal & chr(34) &"which is not as Expected."
										clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
										clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
										Reporter.Filter = rfEnableAll 
										Reporter.ReportEvent micFail,"Step VLDSEARCHSORTING", strDesc
										objEnvironmentVariables.TestCaseStatus=False
										Reporter.Filter = rfDisableAll
									End If
								End Select
			END Function

'======================================================================================================================================================================
'********************************************************************************************************************************************************
'FUNCTION HEADER
'********************************************************************************************************************************************************
'Name: FnSearchResults
'Description: In order to validate  the Search results page,Verify Links (Previous and Next) are in Disable/Enable Mode and page numbers are being Displayed as per Results 
'Creation Date : 18-June-2010
'Created By: Govardhan
'Application: PAYLESS ECOM
'Output: Returns nothing 
'

			Function FnSearchResults(ByRef objsub , ByVal Object_Name, ByVal strInputValue, ByVal strDbValue, ByVal strOptParam, ByRef clsReport, ByRef objEnvironmentVariables ,	ByRef clsScreenShot ,ByVal iRowCnt ,ByVal Screen_shot_path ,ByVal strSheet_Name ,ByVal strLabel , ByVal strExpectedValue , ByVal strTestDataReference, ByVal ModuleName) 
					strInputValue=cInt(strInputValue)
					Dim arrLinkExist(20)
					If  strTestDataReference="" Then
							If browser("brwMain").Page("pgeMain").WebElement("elmResultsMatching").Exist(2) Then
									elmResfnd=(browser("brwMain").Page("pgeMain").WebElement("elmResultsMatching").GetROProperty("innertext"))
							Else
									browser("brwMain").Page("pgeMain").WebElement("elmResultsMatching").SetTOProperty "html tag","SPAN"
									elmResfnd=(browser("brwMain").Page("pgeMain").WebElement("elmResultsMatching").GetROProperty("innertext"))
							End If
							arrResfnd=split(elmResfnd," ")
			'To Get the Number of Results Displayed on search page from text (WE found xxx results for Particular product)
							If UBOUND(arrResfnd)>0 Then
									elmResNo=cdbl(arrResfnd(2))
							End If

		' Getting total Number of product results from text  (Displaying 1-20 of xxx results)
					ElseIf 	TRIM(UCASE(strTestDataReference))="DISPLAYRESULTS" Then
							If Browser("brwMain").Page("pgeProductList").WebElement("elmResultsDisplayed").Exist(2) Then
									elmResfnd=Browser("brwMain").Page("pgeProductList").WebElement("elmResultsDisplayed").GetROProperty("innertext")
							End If
							If  elmResfnd<>""Then
									arrTemp=split(elmResfnd,"of")
									arrTemp1=split(arrTemp(1),"results")
									elmResNo=CINT(TRIM(arrTemp1(0)))
							End If
							set lnkGen=Browser("brwMain").Page("pgeGeneral").Link("lnkGeneral")
							lnkGen.SetTOProperty "text","1"
							lnkGen.SetTOProperty "Index","0"
							lnkGen.SetTOProperty "innerhtml","1"
							If lnkGen.Exist(2) Then
									lnkGen.Click
									Browser("brwMain").Sync
							End If 
					Else
					      ' As of Now Nothing goes Here		
					End If

			' getting Child Object to identify total number of products per page
					If  elmResNo>0 Then
							Set imgObj = Description.Create()
							imgObj("micclass").Value = "Image"
							imgObj("image type").Value = "Image Link"
							imgObj("html tag").Value = "IMG"
							imgObj("class").value="thumb"
							Set obj=Browser("brwMain").Page("pgeProductList").WebElement("elmProductList").ChildObjects(imgObj)
					End If
	
		'If Results Found contains more than 20 results
					If elmResNo>strInputValue Then
							prodPages=(elmResNo\strInputValue)+1
							prodLstPage=elmResNo mod strInputValue
							If obj.count=strInputValue Then
									strDesc = "VLDSEARCHRESULTS: Search results are being displayed "& chr(34) & strInputValue & chr(34) &"Products per Page as Expected."
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1								
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micPass,"Step VLDSEARCHRESULTS", strDesc							 
									Reporter.Filter = rfDisableAll
		'Validating the Message Displayed as "Displaying 1-20 of xxx results"
									ResDis="Displaying 1-" & strInputValue & " of " &elmResNo&" results"
									Set objDisp=Browser("brwMain").Page("pgeGeneral").WebElement("elmGeneral")
									objDisp.SetTOProperty "innertext",ResDis
									objDisp.SetTOProperty "html tag","DIV"
									If objDisp.Exist(2) Then
											objDisp.highlight
											strDesc = "VLDSEARCHRESULTS: Search results are categorized and  "& chr(34) & ResDis & chr(34) &" in First Page as Expected."
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1								
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micPass,"Step VLDSEARCHRESULTS", strDesc							 
											Reporter.Filter = rfDisableAll
									Else							
											strDesc = "VLDSEARCHRESULTS: Search results are not categorized and NOT  "& chr(34) & ResDis & chr(34) &" in First Page, which is not as Expected."
											clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micFail,"Step VLDSEARCHRESULTS", strDesc
											objEnvironmentVariables.TestCaseStatus=False
											Reporter.Filter = rfDisableAll
									End If
				
									genLinks="Previous_0:Next_0:Previous_1:Next_1"
									For i=1 to prodPages
											If i<6 Then
													genLinks=genLinks &":"& i&"_0:"&i&"_1"
											Else
													Exit for
											End If
									Next
									arrLinks=split(genLinks,":")
									set lnkGen=Browser("brwMain").Page("pgeGeneral").Link("lnkGeneral")
		' To verify the links on TOP and BOTTOM of page are present 
									For i=0 to UBOUND(arrLinks)
											arrTBlnk=split(arrLinks(i),"_")
											lnkGen.SetTOProperty "text",arrTBlnk(0)
											lnkGen.SetTOProperty "Index",arrTBlnk(1)
											lnkGen.SetTOProperty "innerhtml",arrTBlnk(0)
											If lnkGen.Exist(2) Then
													lnkGen.highlight
													strDesc = "VLDSEARCHRESULTS: Link " & chr(34) & arrTBlnk(0) & chr(34) &" with the Index value: " & chr(34) & arrTBlnk(1) & chr(34) &  " exist as expected."
													clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1								
													Reporter.Filter = rfEnableAll 
													Reporter.ReportEvent micPass,"Step VLDSEARCHRESULTS", strDesc							 
													Reporter.Filter = rfDisableAll
													arrLinkExist(i)=TRUE
											Else							
													strDesc = "VLDSEARCHRESULTS: Link " & chr(34) & arrTBlnk(0) & chr(34) &" with the Index value: " & chr(34) & arrTBlnk(1) & chr(34) &  " doesn't exist as expected."
													clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
													clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
													Reporter.Filter = rfEnableAll 
													Reporter.ReportEvent micFail,"Step VLDSEARCHRESULTS", strDesc
													objEnvironmentVariables.TestCaseStatus=False
													Reporter.ilter = rfDisableAll
													arrLinkExist(i)=FALSE
											End If
									Next
				
		'To verify the Link "Previous" is in Disabled Mode
									set lnkGen=Browser("brwMain").Page("pgeGeneral").Link("lnkGeneral")
									For index=0 to 1
											If arrLinkExist(0)=TRUE Then
													lnkGen.SetTOProperty "text","Previous"
													lnkGen.SetTOProperty "Index",index
													lnkGen.SetTOProperty "innerhtml","Previous"
													lnkPrevSts=lnkGen.GetROProperty("class")
													If lnkPrevSts="disable" Then
															lnkGen.highlight
															strDesc = "VLDSEARCHRESULTS: Link  " & chr(34) &"Previous " & chr(34) &" with the Property :DISABLE  exist as expected."
															clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1								
															Reporter.Filter = rfEnableAll 
															Reporter.ReportEvent micPass,"Step VLDSEARCHRESULTS", strDesc							 
															Reporter.Filter = rfDisableAll
													Else							
															strDesc = "VLDSEARCHRESULTS: Link  " & chr(34) &"Previous " & chr(34) &" with the Property :DISABLE doesn't exist as expected."
															clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
															clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
															Reporter.Filter = rfEnableAll 
															Reporter.ReportEvent micFail,"Step VLDSEARCHRESULTS", strDesc
															objEnvironmentVariables.TestCaseStatus=False
															Reporter.Filter = rfDisableAll
													End If
											End If
									Next
				
		'To verify the Links other than Previous is in Enable Mode (TOP and BOTTOM)
									For i=0 to UBOUND(arrLinks)
											arrTBlnk=split(arrLinks(i),"_")
											If  arrTBlnk(0)<>"Previous" AND arrTBlnk(0)<>"1" AND arrLinkExist(i)=TRUE Then
													lnkGen.SetTOProperty "text",arrTBlnk(0)
													lnkGen.SetTOProperty "Index",arrTBlnk(1)
													lnkGen.SetTOProperty "innerhtml",arrTBlnk(0)
													lnkPrevSts=lnkGen.GetROProperty("class")
													If lnkPrevSts="active" OR lnkPrevSts="" Then
															lnkGen.highlight
															strDesc = "VLDSEARCHRESULTS: Link  " & chr(34) & arrTBlnk(0) & chr(34) &" with Index:" & arrTBlnk(1) &"has  the Property :ENABLE, exist as expected."
															clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1								
															Reporter.Filter = rfEnableAll 
															Reporter.ReportEvent micPass,"Step VLDSEARCHRESULTS", strDesc							 
															Reporter.Filter = rfDisableAll
													Else							
															strDesc = "VLDSEARCHRESULTS: Link  " & chr(34) & arrTBlnk(0) & chr(34) &" with Index:" & arrTBlnk(1) &"doesn't has  the Property :ENABLE, Which is Not as expected."
															clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
															clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
															Reporter.Filter = rfEnableAll 
															Reporter.ReportEvent micFail,"Step VLDSEARCHRESULTS", strDesc
															objEnvironmentVariables.TestCaseStatus=False
															Reporter.Filter = rfDisableAll
													End If
											End If
									Next
				
		' To perfrom Link click on "Next"
									lnkGen.SetTOProperty "text","Next"
									lnkGen.SetTOProperty "Index","0"
									lnkGen.SetTOProperty "innerhtml","Next"
									If  lnkGen.Exist(2) Then
											lnkGen.Click
											Browser("brwMain").Sync
											strDesc="VLDSEARCHRESULTS:LinkClick action on "& chr(34) & "Next" & chr(34) &" successfully performed."
											Reporter.Filter = rfEnableAll
											Reporter.ReportEvent micdone,"Step VLDSEARCHRESULTS", " The Link "& chr(34) & "Next" & chr(34) &" has been clicked." 
											Reporter.Filter = rfDisableAll													
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2
											Input1=strInputValue+1
											If  elmResNo>=(2*strInputValue)Then
													Input2=strInputValue*2
											Else
													Input2=elmResNo
											End If
				
		'Validate the results In Next page By means of Element "Displaying of 21-40 of results"
											ResDis="Displaying "& Input1 &"-" & Input2 & " of " &elmResNo&" results"
											Set objDisp=Browser("brwMain").Page("pgeGeneral").WebElement("elmGeneral")
											objDisp.SetTOProperty "innertext",ResDis
											objDisp.SetTOProperty "html tag","DIV"
											If objDisp.Exist(2) Then
													objDisp.highlight
													strDesc = "VLDSEARCHRESULTS: Search results are categorized and  "& chr(34) & ResDis & chr(34) &" in Second Page as Expected."
													clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1								
													Reporter.Filter = rfEnableAll 
													Reporter.ReportEvent micPass,"Step VLDSEARCHRESULTS", strDesc							 
													Reporter.Filter = rfDisableAll
											Else							
													strDesc = "VLDSEARCHRESULTS: Search results are not categorized and NOT  "& chr(34) & ResDis & chr(34) &" in Second Page, which is not as Expected."
													clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
													clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
													Reporter.Filter = rfEnableAll 
													Reporter.ReportEvent micFail,"Step VLDSEARCHRESULTS", strDesc
													objEnvironmentVariables.TestCaseStatus=False
													Reporter.Filter = rfDisableAll		End If
				
		'To verify the Links  Previous and  Next (Based on results Available) are in Active Mode (TOP and BOTTOM)
											For i=0 to UBOUND(arrLinks)
													arrTBlnk=split(arrLinks(i),"_")
													If  arrTBlnk(0)<>"Next" OR elmResNo>=2*(strInputValue) Then
															lnkGen.SetTOProperty "text",arrTBlnk(0)
															lnkGen.SetTOProperty "Index",arrTBlnk(1)
															lnkGen.SetTOProperty "innerhtml",arrTBlnk(0)
															lnkPrevSts=lnkGen.GetROProperty("class")
															If lnkPrevSts="active" OR lnkPrevSts=""Then
																	lnkGen.highlight
																	strDesc = "VLDSEARCHRESULTS: Link  " & chr(34) & arrTBlnk(0) & chr(34) &" with  Index:" & arrTBlnk(1) &"has  the Property :ENABLE, exist as expected."
																	clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1								
																	Reporter.Filter = rfEnableAll 
																	Reporter.ReportEvent micPass,"Step VLDSEARCHRESULTS", strDesc							 
																	Reporter.Filter = rfDisableAll
															Else							
																	strDesc = "VLDSEARCHRESULTS: Link  " & chr(34) & arrTBlnk(0) & chr(34) &" withIndex:" & arrTBlnk(1) &"doesn't has  the Property :ENABLE as expected."
																	clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
																	clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
																	Reporter.Filter = rfEnableAll 
																	Reporter.ReportEvent micFail,"Step VLDSEARCHRESULTS", strDesc
																	objEnvironmentVariables.TestCaseStatus=False
																	Reporter.Filter = rfDisableAll	
															End If
													End If
											Next
									End If
				
		' To perfrom Link click on "Previous"
									lnkGen.SetTOProperty "text","Previous"
									lnkGen.SetTOProperty "Index","0"
									lnkGen.SetTOProperty "innerhtml","Previous"
									If  lnkGen.Exist(2) Then
											lnkGen.Click
											Browser("brwMain").Sync
											strDesc="VLDSEARCHRESULTS:LinkClick action on "& chr(34) & "Previous" & chr(34) &" successfully performed."
											Reporter.Filter = rfEnableAll
											Reporter.ReportEvent micdone,"Step VLDSEARCHRESULTS", " The Link "& chr(34) & "Previous" & chr(34) &" has been clicked." 
											Reporter.Filter = rfDisableAll													
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2
					
		'Validate the results In Previous page By means of Element "Displaying of 1-20 of results"
											ResDis="Displaying 1-" & strInputValue & " of " &elmResNo&" results"
											Set objDisp=Browser("brwMain").Page("pgeGeneral").WebElement("elmGeneral")
											objDisp.SetTOProperty "innertext",ResDis
											objDisp.SetTOProperty "html tag","DIV"
											If objDisp.Exist(2) Then
													objDisp.highlight
													strDesc = "VLDSEARCHRESULTS: Search results are categorized and  "& chr(34) & ResDis & chr(34) &" in First Page as Expected."
													clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1								
													Reporter.Filter = rfEnableAll 
													Reporter.ReportEvent micPass,"Step VLDSEARCHRESULTS", strDesc							 
													Reporter.Filter = rfDisableAll
											Else							
													strDesc = "VLDSEARCHRESULTS: Search results are not categorized and NOT  "& chr(34) & ResDis & chr(34) &" in First Page, which is not as Expected."
													clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
													clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
													Reporter.Filter = rfEnableAll 
													Reporter.ReportEvent micFail,"Step VLDSEARCHRESULTS", strDesc
													objEnvironmentVariables.TestCaseStatus=False
													Reporter.Filter = rfDisableAll
											End If
									End If
				
		'To perform a Click Action on page number depends on the Results Available
									If prodPages>5 Then
											pgeclick=4
											FstPage=pgeclick-2
											LstPage=pgeclick+2
		'Validating the Available page numbers after performing above action
									Elseif prodPages<>2 then
											pgeclick=prodPages-1
											FstPage=1
											LstPage=prodPages
									Else
											pgeclick=2
											FstPage=1
											LstPage=prodPages
									End If
									lnkGen.SetTOProperty "text",CStr(pgeclick)
									lnkGen.SetTOProperty "Index","0"
									lnkGen.SetTOProperty "innerhtml",CStr(pgeclick)
									lnkGen.Click
									Browser("brwMain").Sync
									If  lnkGen.Exist(2) Then
											strDesc="VLDSEARCHRESULTS:LinkClick action on Page:"& chr(34) & pgeclick & chr(34) &" successfully performed."
											Reporter.Filter = rfEnableAll
											Reporter.ReportEvent micdone,"Step VLDSEARCHRESULTS", " The Link "& chr(34) & pgeclick & chr(34) &" has been clicked." 
											Reporter.Filter = rfDisableAll													
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2
									End If		
				
		'Validating the Available page numbers after performing above action
									For i=FstPage to LstPage
											For j=0 to 1
													lnkGen.SetTOProperty "text",CStr(i)
													lnkGen.SetTOProperty "Index",Cstr(j)
													lnkGen.SetTOProperty "innerhtml",CStr(i)
													If lnkGen.Exist(2) then
															lnkGen.highlight
															strDesc = "VLDSEARCHRESULTS: Link " & chr(34) & i & chr(34) &" with the Index value:" & chr(34) & j & chr(34) &  " exist as expected."
															clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1								
															Reporter.Filter = rfEnableAll 
															Reporter.ReportEvent micPass,"Step VLDSEARCHRESULTS", strDesc							 
															Reporter.Filter = rfDisableAll
													Else							
															strDesc = "VLDSEARCHRESULTS: Link " & chr(34) & i & chr(34) &" with the Index value:" & chr(34) & j & chr(34) &  " doesn't exist as expected."
															clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
															clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
															Reporter.Filter = rfEnableAll 
															Reporter.ReportEvent micFail,"Step VLDSEARCHRESULTS", strDesc
															objEnvironmentVariables.TestCaseStatus=False
															Reporter.Filter = rfDisableAll
													End If
											Next
									Next	
									
		'Validating the Results page till End by clicking on each Page 
									For i=2 to prodPages
											lnkGen.SetTOProperty "text",CStr(i)
											lnkGen.SetTOProperty "Index","0"
											lnkGen.SetTOProperty "innerhtml",CStr(i)
											If lnkGen.Exist(2) then
													lnkGen.Click
													Browser("brwMain").Sync
													strDesc="VLDSEARCHRESULTS:LinkClick action on Page "& chr(34) & i & chr(34) &" successfully performed."
													Reporter.Filter = rfEnableAll
													Reporter.ReportEvent micdone,"Step VLDSEARCHRESULTS", " The Link "& chr(34) & i & chr(34) &" has been clicked." 
													Reporter.Filter = rfDisableAll													
													clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2
													resStart=(strInputValue*(i-1))+1
													resEnd=strInputValue*i
													If resEnd > elmResNo Then
															resEnd=elmResNo		
													End If
													ResDis="Displaying "& resStart & "-" & resEnd & " of " &elmResNo&" results"
													Set objDisp=Browser("brwMain").Page("pgeGeneral").WebElement("elmGeneral")
													objDisp.SetTOProperty "innertext",ResDis
													objDisp.SetTOProperty "html tag","DIV"
													If objDisp.Exist(2) Then
															objDisp.Highlight
															strDesc = "VLDSEARCHRESULTS: Search results are categorized and  "& chr(34) & ResDis & chr(34) &" in Page:" & i & " as Expected."
															clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1								
															Reporter.Filter = rfEnableAll 
															Reporter.ReportEvent micPass,"Step VLDSEARCHRESULTS", strDesc							 
															Reporter.Filter = rfDisableAll
													Else							
														strDesc = "VLDSEARCHRESULTS: Search results are not categorized and NOT  "& chr(34) & ResDis & chr(34) &" in page:" & i & " , which is not as Expected."
														clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
														clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
														Reporter.Filter = rfEnableAll 
														Reporter.ReportEvent micFail,"Step VLDSEARCHRESULTS", strDesc
														objEnvironmentVariables.TestCaseStatus=False
														Reporter.Filter = rfDisableAll
													End If
											End If
									Next
		'If obj.count not matches with actual results that are being displayed (20 results)
							Else							
									strDesc = "VLDSEARCHRESULTS: Search results are displayed "& chr(34) & obj.count & chr(34) &"Products per Page which is different from actual products - "& chr(34) & strInputValue & chr(34) & " per page, which is not as Expected."
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micFail,"Step VLDSEARCHRESULTS", strDesc
									objEnvironmentVariables.TestCaseStatus=False
									Reporter.Filter = rfDisableAll
							End If							
							If TRIM(UCASE(strOptParam))="VIEW ALL" Then
									lnkGen.SetTOProperty "text","View All"
									lnkGen.SetTOProperty "Index","0"
									lnkGen.SetTOProperty "innerhtml","View All"
									If  lnkGen.Exist(2) Then
											lnkGen.Click
											Browser("brwMain").Sync
											Set obj=Browser("brwMain").Page("pgeProductList").WebElement("elmProductList").ChildObjects(imgObj)
											If obj.count=elmResNo Then
													strDesc = "VLDSEARCHRESULTS:All the available Search results : "& chr(34) & elmResNo & chr(34) &" are displayed in a Single page, as Expected."
													clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1								
													Reporter.Filter = rfEnableAll 
													Reporter.ReportEvent micPass,"Step VLDSEARCHRESULTS", strDesc							 
													Reporter.Filter = rfDisableAll
											Else
													strDesc = "VLDSEARCHRESULTS: All the available Search results : "& chr(34) & elmResNo & chr(34) &" are NOT displayed in a Single page,Which is NOT as Expected."
													clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
													clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
													Reporter.Filter = rfEnableAll 
													Reporter.ReportEvent micFail,"Step VLDSEARCHRESULTS", strDesc
													objEnvironmentVariables.TestCaseStatus=False
													Reporter.Filter = rfDisableAll
											End If
									Else
											strDesc = "VLDSEARCHRESULTS: Link 'View All'  doesn't exist as expected."
											clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micFail,"Step VLDSEARCHRESULTS", strDesc
											objEnvironmentVariables.TestCaseStatus=False
											Reporter.Filter = rfDisableAll
									End If
							End If
			
			
					
		'If Results Found  contains Less than 20 Results and Not Zero
					ElseIf elmResNo<>0 Then
							prodLstPage=elmResNo mod strInputValue
							If obj.count=prodLstPage Then
									strDesc = "VLDSEARCHRESULTS:All the available Search results : "& chr(34) & prodLstPage & chr(34) &" are displayed in a page, as Expected."
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1								
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micPass,"Step VLDSEARCHRESULTS", strDesc							 
									Reporter.Filter = rfDisableAll
		'Validating the Message Displayed as "Displaying 1-20 of xxx results"
									ResDis="Displaying 1-" & elmResNo & " of " &elmResNo&" results"
									Set objDisp=Browser("brwMain").Page("pgeGeneral").WebElement("elmGeneralRegEx")
									objDisp.SetTOProperty "innertext",ResDis
									objDisp.SetTOProperty "html tag","DIV"
									If objDisp.Exist(2) Then
											objDisp.Highlight
											strDesc = "VLDSEARCHRESULTS: Search results are categorized and  "& chr(34) & ResDis & chr(34) &" in First Page as Expected."
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1								
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micPass,"Step VLDSEARCHRESULTS", strDesc							 
											Reporter.Filter = rfDisableAll
									Else							
											strDesc = "VLDSEARCHRESULTS: Search results are not categorized and NOT  "& chr(34) & ResDis & chr(34) &" in First Page, which is not as Expected."
											clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micFail,"Step VLDSEARCHRESULTS", strDesc
											objEnvironmentVariables.TestCaseStatus=False
											Reporter.Filter = rfDisableAll
									End If
							Else
									strDesc = "VLDSEARCHRESULTS:All the available Search results : "& chr(34) & prodLstPage & chr(34) &" are NOT displayed in a page,which is not as Expected."
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micFail,"Step VLDSEARCHRESULTS", strDesc
									objEnvironmentVariables.TestCaseStatus=False
									Reporter.Filter = rfDisableAll
							End If
			
		'To verify the links on TOP and BOTTOM of page are present 
							genLinks="Previous_0:Next_0:Previous_1:Next_1:1_0:1_1"
							arrLinks=split(genLinks,":")
							set lnkGen=Browser("brwMain").Page("pgeGeneral").Link("lnkGeneral")
							For i=0 to UBOUND(arrLinks)
									arrTBlnk=split(arrLinks(i),"_")
									lnkGen.SetTOProperty "text",arrTBlnk(0)
									lnkGen.SetTOProperty "Index",arrTBlnk(1)
									lnkGen.SetTOProperty "innertext",arrTBlnk(0)
									If lnkGen.Exist(2) then
											lnkGen.highlight
											strDesc = "VLDSEARCHRESULTS: Link " & chr(34) & arrTBlnk(0) & chr(34) &" with the Index value: " & chr(34) & arrTBlnk(1) & chr(34) &  " exist as expected."
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1								
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micPass,"Step VLDSEARCHRESULTS", strDesc							 
											Reporter.Filter = rfDisableAll
											arrLinkExist(i)=TRUE
									Else							
											strDesc = "VLDSEARCHRESULTS: Link " & chr(34) & arrTBlnk(0) & chr(34) &" with the Index value: " & chr(34) & arrTBlnk(1) & chr(34) &  " doesn't exist as expected."
											clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micFail,"Step VLDSEARCHRESULTS", strDesc
											objEnvironmentVariables.TestCaseStatus=False
											Reporter.Filter = rfDisableAll
											arrLinkExist(i)=FALSE
									End If
					Next
			
		'To verify the Link "Previous" and Next are in Disabled Mode
					genLinks="Previous_0:Next_0:Previous_1:Next_1"
					arrLinks=split(genLinks,":")
					For  i=0 to UBOUND(arrLinks)
							If arrLinkExist(i)=TRUE  Then
									arrTBlnk=split(arrLinks(i),"_")
									lnkGen.SetTOProperty "text",arrTBlnk(0)
									lnkGen.SetTOProperty "Index",arrTBlnk(1)
									lnkGen.SetTOProperty "innertext",arrTBlnk(0)
									lnkPrevSts=lnkGen.GetROProperty("class")
									If lnkPrevSts="disable" Then
											lnkGen.Highlight
											strDesc = "VLDSEARCHRESULTS: Link  " & chr(34) & arrTBlnk(0) & chr(34) &" with  Index:" & arrTBlnk(1) &"has  the Property :DISABLE, exist as expected."
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1								
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micPass,"Step VLDSEARCHRESULTS", strDesc							 
											Reporter.Filter = rfDisableAll
									Else							
											strDesc = "VLDSEARCHRESULTS: Link  " & chr(34) & arrTBlnk(0) & chr(34) &" withIndex:" & arrTBlnk(1) &"doesn't has  the Property :DISABLE as expected."
											clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micFail,"Step VLDSEARCHRESULTS", strDesc
											objEnvironmentVariables.TestCaseStatus=False
											Reporter.Filter = rfDisableAll
									End If
							End If
					Next
			
		'To verify the Links other than Previous is in ENABLE Mode (TOP and BOTTOM)
					genLinks="1_0:1_1"
					arrLinks=split(genLinks,":")
					For i=0 to UBOUND(arrLinks)
							If arrLinkExist(i+4)=TRUE  Then
									arrTBlnk=split(arrLinks(i),"_")
									lnkGen.SetTOProperty "text",arrTBlnk(0)
									lnkGen.SetTOProperty "Index",arrTBlnk(1)
									lnkGen.SetTOProperty "innertext",arrTBlnk(0)
									lnkPrevSts=lnkGen.GetROProperty("class")
									If lnkPrevSts="active" OR lnkPrevSts=""  Then
											lnkGen.highlight
											strDesc = "VLDSEARCHRESULTS: Link  " & chr(34) & arrTBlnk(0) & chr(34) &" with  Index:" & arrTBlnk(1) &"has  the Property :ENABLE, exist as expected."
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1								
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micPass,"Step VLDSEARCHRESULTS", strDesc							 
											Reporter.Filter = rfDisableAll
									Else							
											strDesc = "VLDSEARCHRESULTS: Link  " & chr(34) & arrTBlnk(0) & chr(34) &" withIndex:" & arrTBlnk(1) &"doesn't has  the Property :ENABLE as expected."
											clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micFail,"Step VLDSEARCHRESULTS", strDesc
											objEnvironmentVariables.TestCaseStatus=False
											Reporter.Filter = rfDisableAll
									End If
							End If
					Next
					
		'If page Contains 0 results
					Else
		'As of Now Results Page Will contain Atleast one product (Key word is defined only for Search)
		' Can be Modifed in Future
			
					End If
	END Function


'========================================================================================================================================================
'********************************************************************************************************************************************************
'FUNCTION HEADER
'********************************************************************************************************************************************************
'Name: FnOrderHistory
'Description: This function is to verify the order History  page in which the most recent order that are placed should be Dispalyed First and Order Date Format should be of mm/dd/yyyy
'Input: Obj, Object Name, strInputValue, strOpt_Param, strOpt_Param, clsReport, objEnvironmentVariables, clsScreenShot, iRowCnt, Screen_shot_path, strSheet_Name, strLabel, strExpectedValue, strTestDataReference
'Creation Date : 25-June-2010
'Created By: Govardhan Choletti (208002)
'Application: PAYLESS ECOM
'Output: Returns nothing

	Function FnOrderHistory (ByRef objsub , ByVal Object_Name, ByVal strInputValue, ByVal strDbValue, ByVal strOptParam, ByRef clsReport, ByRef objEnvironmentVariables ,  ByRef clsScreenShot ,ByVal iRowCnt ,ByVal Screen_shot_path ,ByVal strSheet_Name ,ByVal strLabel , ByVal strExpectedValue , ByVal strTestDataReference, ByVal ModuleName)			
			rCnt=Browser("brwMain").Page("pgeMyAccount").WebTable("tblOrderSummary").RowCount
			cCnt=Browser("brwMain").Page("pgeMyAccount").WebTable("tblOrderSummary").ColumnCount(1)
			arrColName=split(strInputValue,":")
			'arrColName(0)="Order date"
			'arrColName(1)="Order #"
			colNum1=""
			colNum2=""
			For j=1 to cCnt 
				If arrColName(0)=Browser("brwMain").Page("pgeMyAccount").WebTable("tblOrderSummary").GetCellData(1,j) Then
					colNum1=j
				ElseIf arrColName(1)=Browser("brwMain").Page("pgeMyAccount").WebTable("tblOrderSummary").GetCellData(1,j) Then
					colNum2=j
				End If
			Next
			For i=2 to RCnt
				'To get the "Date" Value from WEB Table
				If  colNum1<>"" AND colNum2<>""Then
					DateVal=Browser("brwMain").Page("pgeMyAccount").WebTable("tblOrderSummary").GetCellData(i,colNum1)
					OrderVal=Browser("brwMain").Page("pgeMyAccount").WebTable("tblOrderSummary").GetCellData(i,colNum2)
					arrDate=split(DateVal,"/")
						' To verify Date is in Format mm/dd/yyyy
						If Len(arrDate(0))=2 AND Len(arrDate(1))=2	AND Len(arrDate(2))=4 AND CDbl(arrDate(0))<=12 AND CDbl(arrDate(1))<=31 Then
							strDesc ="VERIFYORDERHISTORY: Order Number : " & chr(34) & OrderVal & chr(34) &" placed on Date : " & chr(34) & DateVal & chr(34) & " is in the Format (mm/dd/yyyy) in Order Table, exists as expected."
							clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
							Reporter.Filter = rfEnableAll 
							Reporter.ReportEvent micPass,"Step VERIFYORDERHISTORY", strDesc
							Reporter.Filter = rfDisableAll
							strDate=arrDate(2)+arrDate(0)+arrDate(1)
							' Stores the Current date value in a variable
							If i=2 Then
								numCurrDate=Cdbl(strDate)
								DateValCurr=DateVal
								OrderValCurr=OrderVal
							' Stores the Next date value in a variable
							Else
								numNxtDate=Cdbl(strDate)
								If numCurrDate>=numNxtDate Then
									strDesc ="VERIFYORDERHISTORY: Order Number : " & chr(34) & OrderValCurr & chr(34) &" placed on Date : " & chr(34) & DateValCurr & chr(34) & " is at Row Number : " & chr(34) & (i-2) & chr(34) & "in Order Table, exists as expected."
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micPass,"Step VERIFYORDERHISTORY", strDesc
									Reporter.Filter = rfDisableAll
								 Else
									strDesc ="VERIFYORDERHISTORY: Order Number : " & chr(34) & OrderValCurr & chr(34) &" placed on Date : " & chr(34) & DateValCurr & chr(34) & " is at Row Number : " & chr(34) & (i-2) & chr(34) & "in Order Table, doesn't exists as expected."
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micFail,"Step VERIFYORDERHISTORY", strDesc
									objEnvironmentVariables.TestCaseStatus=False
									Reporter.Filter = rfDisableAll
								End If
								DateValCurr=DateVal
								OrderValCurr=OrderVal
								numCurrDate=numNxtDate
							End If
						Else
							strDesc ="VERIFYORDERHISTORY: Order Number : " & chr(34) & OrderVal & chr(34) &" placed on Date : " & chr(34) & DateVal & chr(34) & " is in the Format (mm/dd/yyyy) in Order Table, doesn't exists as expected."
							clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
							clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
							Reporter.Filter = rfEnableAll 
							Reporter.ReportEvent micFail,"Step VERIFYORDERHISTORY", strDesc
							objEnvironmentVariables.TestCaseStatus=False
							Reporter.Filter = rfDisableAll
						End If
				End If
			Next

	END Function
	
'======================================================================================================================================================================
'FUNCTION HEADER'
'Name: FnValidAdditionalNotices
'Description: This function will identify the Image name, Product name, Price, noitices and the total number noitces of displayed products.
'Creation Date : 29-June-2010
'Created By: Shiva Akula (231837)
'Application: PAYLESS ECOM


Function FnValidAdditionalNotices (ByRef objsub , ByVal Object_Name, ByVal strInputValue, ByVal strDbValue, ByVal strOptParam, ByRef clsReport, ByRef objEnvironmentVariables , ByRef clsScreenShot ,ByVal iRowCnt ,ByVal Screen_shot_path ,ByVal strSheet_Name ,ByVal strLabel , ByVal strExpectedValue , ByVal strTestDataReference, ByVal ModuleName)			


Dim arrNotic(200), arrNot(200)
Set elmObjPro=Description.Create()
elmObjPro("micclass").Value = "WebElement"
elmObjPro("html tag").value="LI"
elmObjPro("innertext").value=".*$.*"

Set obj=Browser("brwMain").Page("pgeProductList").WebElement("elmProductList").ChildObjects(elmObjPro)


	For i =0 to obj.count-1

				 strProPrice=obj(i).getRoproperty("Innertext")
				 'It will fetch the product name
				 strPro=Mid(strProPrice,1,Instr(1, strProPrice,"$")-1)
				 'It will fetch the Price of Product.
				 arrPro=split(strProPrice,strPro)
				Set objImgPro= Browser("brwMain").Page("pgeProductList").Image("imgProdCount")
			'	 objImgPro.SetTOProperty "alt",strPro 
				 objImgPro.SetTOProperty "index",i
				 'it will fetch the image name of  product.
				 If objImgPro.Exist(2) Then
					strImgProd= objImgPro.GetROProperty("file name")
			'		strPro=objImgPro.GetROProperty("alt")
				 End If
	   If Ubound (arrPro) >0 Then
		   ' It will display the Image Name
							If strImgProd<>"" Then
									strDesc ="VLDADDITIONALNOTICES: The"& chr(34)&i+1& chr(34)&" Product with Image :"& chr(34)&strImgProd& chr(34)&"  Exist, Which is as Expected ."
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micPass,"Step VLDADDITIONALNOTICES", strDesc
									Reporter.Filter = rfDisableAll
							Else
									strDesc ="VLDADDITIONALNOTICES: The"& chr(34)&i+1& chr(34)&" Product with Image :"& chr(34)&strImgProd& chr(34)&" doesn't Exist,  Which is Not as Expected ."
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micFail,"Step VLDADDITIONALNOTICES", strDesc
									objEnvironmentVariables.TestCaseStatus=False
									Reporter.Filter = rfDisableAll
							End If
							' It will display the Product Name
							If strPro<>""  Then
									strDesc ="VLDADDITIONALNOTICES: The"& chr(34)&i+1& chr(34)&" Product  with Product Name : " & chr(34) & strPro & chr(34) & " Exist, Which is as Expected ."
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micPass,"Step VLDADDITIONALNOTICES", strDesc
									Reporter.Filter = rfDisableAll
							Else
									strDesc ="VLDADDITIONALNOTICES: The"& chr(34)&i+1& chr(34)&" Product  with Product Name : " & chr(34) & strPro & chr(34) & " doesn't Exist,  Which is Not as Expected ."
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micFail,"Step VLDADDITIONALNOTICES", strDesc
									objEnvironmentVariables.TestCaseStatus=False
									Reporter.Filter = rfDisableAll
							End If
							'It will display the Price of the Product
							If arrPro(1)<>"" Then
									strDesc ="VLDADDITIONALNOTICES: The"& chr(34)&i+1& chr(34)&" Product With Price : "&chr(34) & arrPro(1) & chr(34) &" Exist, Which is as Expected ."
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micPass,"Step VLDADDITIONALNOTICES", strDesc
									Reporter.Filter = rfDisableAll
							Else
									strDesc ="VLDADDITIONALNOTICES: The"& chr(34)&i+1& chr(34)&" Product With Price : "&chr(34) & arrPro(1) & chr(34) &" doesn't Exist,  Which is Not as Expected ."
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micFail,"Step VLDADDITIONALNOTICES", strDesc
									objEnvironmentVariables.TestCaseStatus=False
									Reporter.Filter = rfDisableAll
							End If
            	
		Else
				strDesc ="VLDADDITIONALNOTICES: The"& chr(34)&i+1&chr(34)&" product with Product Name  and With Price does not Exist,  Which is Not as Expected ."
				clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
				clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
				Reporter.Filter = rfEnableAll 
				Reporter.ReportEvent micFail,"Step VLDADDITIONALNOTICES", strDesc
				objEnvironmentVariables.TestCaseStatus=False
				Reporter.Filter = rfDisableAll							
	  End If
	Next



'It will fetch the Original Price and Offer Price of a Product
		Set elmObj = Description.Create()
		elmObj("micclass").Value = "WebElement"
		elmObj("html tag").Value = "DIV"
		elmObj("class").value="price"
		Set obj=Browser("brwMain").Page("pgeProductList").WebElement("elmProductList").ChildObjects(elmObj)
				For i=0 to obj.count-1
							' Get price from each product for each iteration
							arrSprice=split(TRIM(obj(i).getroproperty("innertext"))," ")
									If UBOUND(arrSprice)>0 Then
										'It will fetch the Offer price and regular Price of Product .
													If ModuleName="Original" OR ModuleName="Performance" Then
															SecVal=arrSprice(UBOUND(arrSprice))
															FrstPrice=arrSprice(0)
													ElseIf ModuleName="Sperry" OR ModuleName="Keds" Then
															SecVal=arrSprice(0)
															frstVal=arrSprice(UBOUND(arrSprice))
													End If
'											It will print the Offer price and regular Price of Product .
											strDesc = "VLDADDITIONALNOTICES: Original Value is "& chr(34) & frstVal & chr(34) &" and Offer value is "& chr(34) & SecVal & chr(34) &" as Expected."
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1								
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micPass,"Step VLDADDITIONALNOTICES", strDesc							 
											Reporter.Filter = rfDisableAll
									Else
									'		It will Print the Original Price of Product. 
											frstVal=arrSprice(0)
											strDesc = "VLDADDITIONALNOTICES: Original Value is "& chr(34) & frstVal & chr(34) &" as Expected."
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1								
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micPass,"Step VLDADDITIONALNOTICES", strDesc
											Reporter.Filter = rfDisableAll							 
									End If
				Next

End Function

'=======================================================================================================================================================================
'********************************************************************************************************************************************************
'FUNCTION HEADER
'********************************************************************************************************************************************************
'Name: FnPromoNCpnCheck
'Description: This functiom will check the coupon applied either $OFF or %OFF
'Input: Obj, Object Name, strInputValue, strOpt_Param, strOpt_Param, clsReport, objEnvironmentVariables, clsScreenShot, iRowCnt, Screen_shot_path, strSheet_Name, strLabel, strExpectedValue, strTestDataReference
'Creation Date : 01-July-2010
'Created By: Fayis K(229680)
'Application: PAYLESS ECOM
'Output: Returns nothing

Function FnPromoNCpnCheck (ByRef objsub , ByVal Object_Name, ByVal strInputValue, ByVal strDbValue, ByVal strOptParam, ByRef clsReport, ByRef objEnvironmentVariables ,  ByRef clsScreenShot ,ByVal iRowCnt ,ByVal Screen_shot_path ,ByVal strSheet_Name ,ByVal strLabel , ByVal strExpectedValue , ByVal strTestDataReference, ByVal ModuleName)			

				Set objsub=Browser("brwMain").Page("pgeShoppingBag")
                Set tblObj=objsub.WebTable("tblItems")
				Set elmObj=objsub.WebElement("elmGeneral")

				If UCASE(TRIM(strOptParam)) = "ITEM"  Then  'Item level Coupon

					'Taking the  total befor applting the Coupon
					strRowCnt=objsub.WebTable("tblItems").GetROProperty("rows")
					For i=0 to strRowCnt
						strCellValue=tblObj.GetCellData(i,1)
						If INSTR(strCellValue,"subtotal")>0 Then
									'Get the subtotal value
									strItemPrice=tblObj.GetCellData(i,2)
									strItemPrice=CDBL(strItemPrice)
						End if
					Next
               
					strCpnCode = CSTR( TRIM(strInputValue))
				    objsub.WebEdit("edtCoupons").Set(strCpnCode)
					objsub.Image("imgApply").Click(3)

					Browser("brwMain").Sync

					'Coupon message
					elmObj.SetTOProperty "innertext",  "Coupon "&chr(34) & strCpnCode &chr(34)&" Applied"
					elmObj.SetTOProperty "html tag", "LI"

					If elmObj.Exist (3) Then
							elmObj.Highlight
					End If

					'Taking the  price after discount
					strRowCnt=objsub.WebTable("tblItems").GetROProperty("rows")
					For i=0 to strRowCnt
						strCellValue=tblObj.GetCellData(i,1)
						If INSTR(strCellValue,"subtotal")>0 Then
									strCurrAmt1=tblObj.GetCellData(i,2)
									strCurrAmt=CDBL(strCurrAmt1)
						End if
					Next

					'Takinf the  the discount   either in the form $xx.xx or %xx.xx
					If strExpectedValue <> "" Then
							If INSTR(strExpectedValue,"$") Then  'IF$
									strDiscountAmt1 = SPLIT(strExpectedValue,"$")
									strDiscountAmt  = strDiscountAmt1(1)

						Elseif INSTR(strExpectedValue,"%") Then  'If %
								strDiscountAmt1 = SPLIT(strExpectedValue,"%")
								strDiscountAmt =  (CINT(strItemPrice) *CINT(strDiscountAmt1(1)) /100)

						End If 						
					End If 'Discount



					'Calculating the discount from the input
					strExptotalVal = strItemPrice - strDiscountAmt



					'Report
							If elmObj.Exist (3) Then
									If   strExptotalVal = strCurrAmt Then
												strDesc ="PROMONCPNCHECK: Item level coupon is applied correctly. Actual item price: " & strItemPrice &"; Discount applied: " &strExpectedValue & "; Price after discount: " &strCurrAmt
												clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
												Reporter.Filter = rfEnableAll 
												Reporter.ReportEvent micPass,"Step PROMONCPNCHECK", strDesc
												Reporter.Filter = rfDisableAll
											Else
												strDesc ="PROMONCPNCHECK Discount value " & chr(34) &strFinalAmt & " is NOT applied correctly. It is displayed  as follows." &" Actual item price: " & strItemPrice &"; Discount applied: " &strExpectedValue & "; Price after discount: " &strCurrAmt
												clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1 & strLabel , objEnvironmentVariables
												clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
												Reporter.Filter = rfEnableAll 
												Reporter.ReportEvent micFail,"Step PROMONCPNCHECK", strDesc
												objEnvironmentVariables.TestCaseStatus=False
												Reporter.Filter = rfDisableAll
											End If
								Else
										strDesc ="PROMONCPNCHECK:Coupon code is not applied."
										clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1 & strLabel , objEnvironmentVariables
										clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
										Reporter.Filter = rfEnableAll 
										Reporter.ReportEvent micFail,"Step PROMONCPNCHECK", strDesc
										objEnvironmentVariables.TestCaseStatus=False
										Reporter.Filter = rfDisableAll
								End If

					'taking order total

					'Taking the  price after discount
					strRowCnt=objsub.WebTable("tblItems").GetROProperty("rows")
					For i=0 to strRowCnt
						strCellValue=tblObj.GetCellData(i,1)
						If INSTR(strCellValue,"Estimated order total:")>0 Then
									strSubTotal=tblObj.GetCellData(i,2)
									strSubTotal=CDBL(strSubTotal)
						End if
					Next

				'Returning the parameter (Subtotal )

					If strTestDataReference<>"" Then
									arrOptParam=Split(strTestDataReference,":")
									If  UBOUND(arrOptParam)>0Then
										If  UCASE(TRIM(arrOptParam(0)))="ENV" Then

											Environment.Value(Trim(arrOptParam(1)) ) = strSubTotal 'item price
									    '2nd object
										End If
									End If
						End If

				Elseif UCASE(TRIM(strOptParam)) = "ORDER"  Then

				'	Applying coupon
					strCpnCode = CSTR( TRIM(strInputValue))
					objsub.WebEdit("edtCoupons").Set(strCpnCode)
					objsub.Image("imgApply").Click(3)
                
					Browser("brwMain").Sync
            					
					 elmObj.SetTOProperty "innertext",  "Coupon "&chr(34) & strCpnCode &chr(34)&" Applied"
					elmObj.SetTOProperty "html tag", "LI"

					If elmObj.Exist (3) Then
						elmObj.Highlight
					End If

							'Get Subtotal
							strRowCnt=objsub.WebTable("tblItems").GetROProperty("rows")
								For i=0 to strRowCnt
								strCellValue=tblObj.GetCellData(i,1)
								If INSTR(strCellValue,"subtotal")>0 Then
									'Get the subtotal value
									strCurrSubTotal=tblObj.GetCellData(i,2)
									strCurrSubTotal=CDBL(strCurrSubTotal)
								End if
							Next



							'Get promotion
							strRowCnt=objsub.WebTable("tblItems").GetROProperty("rows")
						For i=0 to strRowCnt
								strCellValue=tblObj.GetCellData(i,1)
								If INSTR(strCellValue,"Promotions & coupons")>0 Then
									'Get the subtotal value
									strPromoAmt=tblObj.GetCellData(i,2)
									strPromoAmt=ABS(CDBL(strPromoAmt))
								End if
							Next



							'Shipping amnt
							strRowCnt=objsub.WebTable("tblItems").GetROProperty("rows")

							For i=0 to strRowCnt
								strCellValue=tblObj.GetCellData(i,1)
								If INSTR(strCellValue,"Promotions & coupons")>0 Then
									'Get the subtotal value
									strShippingAmt=tblObj.GetCellData(i+1,2)
									strShippingAmt=CDBL(strShippingAmt)
								End if
							Next



							'Estimated total
							strRowCnt=objsub.WebTable("tblItems").GetROProperty("rows")
								
						For i=0 to strRowCnt
								strCellValue=tblObj.GetCellData(i,1)
								If INSTR(strCellValue,"Estimated order total")>0 Then
									'Get the subtotal value
									strEstTotal=tblObj.GetCellData(i,2)
									strEstTotal=CDBL(strEstTotal)
								End if
							Next




								'Take the discount
											If strExpectedValue <> "" Then
												If INSTR(strExpectedValue,"$") Then
														strDiscountAmt1 = SPLIT(strExpectedValue,"$")
														strDiscountAmt = strDiscountAmt1(1)

												Elseif INSTR(strExpectedValue,"%") Then
													strDiscountAmt1 = SPLIT(strExpectedValue,"%")
													strDiscountAmt = CINT(strCurrSubTotal)  * CINT(strDiscountAmt1(1))/100
												
												End If 
										End if

	

			strExpTotal = strCurrSubTotal + strShippingAmt - strDiscountAmt



			'Report
				If elmObj.Exist (3) Then
								If   strExpTotal = strEstTotal Then
												strDesc ="PROMONCPNCHECK: Order level coupon discount: " & chr(34) & strExpectedValue & chr(34) &"Sub total: "& chr(34)& strCurrSubTotal & chr(34) &" displyed correcly."
												clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
												Reporter.Filter = rfEnableAll 
												Reporter.ReportEvent micPass,"Step PROMONCPNCHECK", strDesc
												Reporter.Filter = rfDisableAll
								Else
												strDesc ="PROMONCPNCHECK Discount value " & chr(34) & strDiscountAmt &  chr(34) & " NOT applied correctly. "
												clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1 & strLabel , objEnvironmentVariables
												clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
												Reporter.Filter = rfEnableAll 
												Reporter.ReportEvent micFail,"Step PROMONCPNCHECK", strDesc
												objEnvironmentVariables.TestCaseStatus=False
												Reporter.Filter = rfDisableAll
								End If
					Else
								strDesc ="PROMONCPNCHECK:Coupon code is not applied."
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1 & strLabel , objEnvironmentVariables
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micFail,"Step PROMONCPNCHECK", strDesc
									objEnvironmentVariables.TestCaseStatus=False
									Reporter.Filter = rfDisableAll
					End If

					'taking parameters

					If strTestDataReference<>"" Then
									arrOptParam=Split(strTestDataReference,":")
									If  UBOUND(arrOptParam)>0Then
										If  UCASE(TRIM(arrOptParam(0)))="ENV" Then
											Environment.Value(Trim(arrOptParam(1)) ) = strDiscountAmt 'item price
										End If
									End If
								End If

					Elseif UCASE(TRIM(strOptParam)) = "SHIPPING"  Then

							'Take the shipping charge b4 apply coupon
							'Shipping amnt
							strRowCnt=objsub.WebTable("tblItems").GetROProperty("rows")
							For i=0 to strRowCnt
								strCellValue=tblObj.GetCellData(i,1)
								If INSTR(strCellValue,"Shipping:")>0 Then
									'Get the subtotal value
									strShippingAmt=tblObj.GetCellData(i,2)
									strShippingAmt=CDBL(strShippingAmt)
								End if
							Next



							' Apply coupon
                          strCpnCode = CSTR( TRIM(strInputValue))
				     	objsub.WebEdit("edtCoupons").Set(strCpnCode)
						objsub.Image("imgApply").Click(3)

					Browser("brwMain").Sync

					elmObj.SetTOProperty "innertext",  "Coupon "&chr(34) & strCpnCode &chr(34)&" Applied"
					elmObj.SetTOProperty "html tag", "LI"

					If elmObj.Exist (3) Then
						elmObj.Highlight
					End If
					'Shipping cost after dicount
					strRowCnt=objsub.WebTable("tblItems").GetROProperty("rows")

					For i=0 to strRowCnt
						strCellValue=tblObj.GetCellData(i,1)
						If INSTR(strCellValue,"Shipping:")>0 Then
							strShippingAmtDisc1=tblObj.GetCellData(i,2)
							strShippingAmtDisc=CDBL(strShippingAmtDisc1)
						End if
					Next



											If strExpectedValue <> "" Then

												If INSTR(strExpectedValue,"$") Then
														strDiscountAmt1 = SPLIT(strExpectedValue,"$")
														strDiscountAmt = strDiscountAmt1(1)
												Elseif INSTR(strExpectedValue,"%") Then
													strDiscountAmt1 = SPLIT(strExpectedValue,"%")
													strDiscountAmt = CINT(strShippingAmt)  * CINT(strDiscountAmt1(1))/100
												End If 
										End if



						'Calculated shipping amount

				expShipAmt =strShippingAmt - strDiscountAmt 

				If  expShipAmt < 0 Then
						expShipAmt = 0
				End If



			If elmObj.Exist (3) Then

								If  expShipAmt = strShippingAmtDisc Then
												strDesc ="PROMONCPNCHECK: Actual shipping value: " & chr(34) & strShippingAmt & chr(34) & ". Shipping level coupon discount: " & chr(34) & strDiscountAmt & chr(34) &" applied correcly."
												clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
												Reporter.Filter = rfEnableAll 
												Reporter.ReportEvent micPass,"Step PROMONCPNCHECK", strDesc
												Reporter.Filter = rfDisableAll
								Else
												strDesc ="PROMONCPNCHECK:Actual shipping value: " & chr(34) & strShippingAmt &chr(34) & ". Discount value " & chr(34) & strDiscountAmt  & chr(34)  & " NOT applied correctly."
												clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1 & strLabel , objEnvironmentVariables
												clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
												Reporter.Filter = rfEnableAll 
												Reporter.ReportEvent micFail,"Step PROMONCPNCHECK", strDesc
												objEnvironmentVariables.TestCaseStatus=False
												Reporter.Filter = rfDisableAll
								End If
			Else
							strDesc ="PROMONCPNCHECK:Coupon code is not applied."
								clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1 & strLabel , objEnvironmentVariables
								clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
								Reporter.Filter = rfEnableAll 
								Reporter.ReportEvent micFail,"Step PROMONCPNCHECK", strDesc
								objEnvironmentVariables.TestCaseStatus=False
								Reporter.Filter = rfDisableAll
				End If

						If strTestDataReference<>"" Then
									arrOptParam=Split(strTestDataReference,":")
									If  UBOUND(arrOptParam)>0Then
										If  UCASE(TRIM(arrOptParam(0)))="ENV" Then
											Environment.Value(Trim(arrOptParam(1)) ) = strShippingAmtDisc 'item price
									    '2nd object
											
										End If
									End If
								End If

			End If  'For item


								
	END Function
'=====================================================================================================================================================================
'********************************************************************************************************************************************************
'FUNCTION HEADER
'********************************************************************************************************************************************************

'Name: FnRemoveAllCoupons
'Description: This functiom will remove the coupons which are already updated
'Input: Obj, Object Name, strInputValue, strOpt_Param, strOpt_Param, clsReport, objEnvironmentVariables, clsScreenShot, iRowCnt, Screen_shot_path, strSheet_Name, strLabel, strExpectedValue, strTestDataReference
'Creation Date : 06-July-2010
'Created By: Fayis K(229680)/Ram  (229673)
'Application: PAYLESS ECOM
'Output: Will return parameters according the coupon level
				'For ITEM  returns total amount
				'For  ORDER returns discount 
				'For SHIPPING return shipping amount after discount

Function FnRemoveAllCoupons (ByRef objsub , ByVal Object_Name, ByVal strInputValue, ByVal strDbValue, ByVal strOptParam, ByRef clsReport, ByRef objEnvironmentVariables ,  ByRef clsScreenShot ,ByVal iRowCnt ,ByVal Screen_shot_path ,ByVal strSheet_Name ,ByVal strLabel , ByVal strExpectedValue , ByVal strTestDataReference, ByVal ModuleName)			

	'Click on shoping bag
		Set obj1 = Browser("brwMain").Page("pgeMain")
					'Set obj = objsub
					errFlg = false
					removeAction = false
					
					'To remove some items
					
					If  obj1.Image("imgViewBag").Exist(3) Then  'For Saucony
					obj1.Image("imgViewBag").Click
					removeAction = true
					Elseif obj1.Link("lnkitem").Exist(3) Then 'For sperry
					obj1.Link("lnkItem").Click
					removeAction = true
					End if

					If removeAction Then

									Set objsub= Browser("brwMain").Page("pgeShoppingBag")
										Set tblobj=objsub.WebTable("tblItems")
										strRows=tblobj.GetROProperty("rows")
										Set lnkObj = Description.Create()
										lnkObj("micclass").Value = "Link"
										lnkObj("html tag").Value = "A"
										lnkObj("text").Value = "Remove"
										
										Set lnkRemoveObj=tblobj.ChildObjects(lnkObj)

										strRmvLnkCounter=0
										For i=0 to  strRows
											'Get the count of remove links above the coupons section
											strRemoveValue=tblobj.GetCellData(i,5)
											If INSTR(strRemoveValue,"Remove")>0 AND INSTR(tblobj.GetCellData(i+1,1),"Coupons & promotions")<1Then
												strRmvLnkCounter=strRmvLnkCounter+1
											End If
										Next
							
										'Remove the Promotions
				
										lnkIndex=strRmvLnkCounter
										For i=lnkIndex to lnkRemoveObj.count-1
											objsub.Link("lnkRemove").SetTOProperty "index",lnkIndex
															
											If  objsub.Link("lnkRemove").Exist(2) Then
												'objsub.Link("lnkRemove").Highlight
												objsub.Link("lnkRemove").Click
												Browser("brwMain").Sync
											End If
										Next
							End if

							  If removeAction Then
                                                                
											strDesc ="REMOVECOUPONS: Coupon(s) are removed from the shoping bag."
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micPass,"Step REMOVEITEMS", strDesc
											Reporter.Filter = rfDisableAll
							Else
										   strDesc ="REMOVEITEMS: No products found in the shoping bag."
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micPass,"Step REMOVEITEMS", strDesc
											Reporter.Filter = rfDisableAll
							End if


END Function
'=====================================================================================================================================================================
'********************************************************************************************************************************************************
'FUNCTION HEADER
'********************************************************************************************************************************************************

'Name:FnCheckPromoInPlaceOrder
'Description: This functiom will check the coupon discount in Place order page
'Input: Obj, Object Name, strInputValue, strOpt_Param, strOpt_Param, clsReport, objEnvironmentVariables, clsScreenShot, iRowCnt, Screen_shot_path, strSheet_Name, strLabel, strExpectedValue, strTestDataReference
'Creation Date : 06-July-2010
'Created By: Fayis K(229680)
'Application: PAYLESS ECOM
'Output: Returns nothing

Function FnCheckPromoInPlaceOrder (ByRef objsub , ByVal Object_Name, ByVal strInputValue, ByVal strDbValue, ByVal strOptParam, ByRef clsReport, ByRef objEnvironmentVariables ,  ByRef clsScreenShot ,ByVal iRowCnt ,ByVal Screen_shot_path ,ByVal strSheet_Name ,ByVal strLabel , ByVal strExpectedValue , ByVal strTestDataReference, ByVal ModuleName)			

			Set objsub= Browser("brwMain").Page("pgeReviewOrder")
			Set tblObj = objsub.WebTable("tblCreditCard")

			Set elmObj=objsub.WebElement("elmGeneral")

			arrInpValue=Split(strInputValue,":")
						
			If UCASE(TRIM(arrInpValue(0)))="ENV" Then
					strParm=Environment.Value( Trim(arrInpValue(1) ))
			End If
	
			If UCASE(TRIM(strOptParam)) = "ITEM"  Then  'Item level Coupon

							'Take item subtotal 
							strRows=tblObj.GetROProperty("rows")

							For i=0 to strRows
								strCellValue=tblObj.GetCellData(i,1)

								If INSTR(strCellValue,"Balance due:")>0 Then
									strItemSubTotal=tblObj.GetCellData(i,2)

									strItemSubTotal=CDBL(strItemSubTotal)

								End if
							Next

							'Result
							If strItemSubTotal =  strParm Then
									strDesc ="CHECKPROMOINPLACEORDER: Total order amount is under Shopping Bag and Place order is displayed correctly as " & chr(34) & strItemSubTotal & chr(34) & " "
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micPass,"Step CHECKPROMOINPLACEORDER", strDesc
									Reporter.Filter = rfDisableAll
							Else
									Desc ="CHECKPROMOINPLACEORDER: Estimated total amount in Shopping Bag is displayed as  " & chr(34) & strParm & chr(34) &", but in Place Order is displ;ayed as " & chr(34) & strItemSubTotal & chr(34) 
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1 & strLabel , objEnvironmentVariables
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micFail,"Step CHECKPROMOINPLACEORDER", strDesc
									objEnvironmentVariables.TestCaseStatus=False
									Reporter.Filter = rfDisableAll
							End If
	      
					Elseif UCASE(TRIM(strOptParam)) = "ORDER"  Then

												temp=split(strParm,".")
												If  UBOUND(temp)>0Then
																'Decimal after the passed value
																'1. Just one digit after decimal
																If len(temp(1))=1 Then
																				strParm="$" & strParm & "0"
																ElseIf len(temp(1))=2 Then 'In case value has two digits after decimal e.g. 4.56
																			   strParm="$" & strParm
																End If
												Else 'Whole Number
																strParm="$" & strParm & ".00"
												End If


					elmObj.SetTOProperty "innertext",  "-"&strParm
					elmObj.SetTOProperty "html tag", "TD"
					If elmObj.Exist (3) Then
						elmObj.Highlight
					End if

					'take order and promotion 
					strRows=tblObj.GetROProperty("rows")
							For i=0 to strRows
								strCellValue=tblObj.GetCellData(i,1)

								If INSTR(strCellValue,"Promotions & coupons:")>0 Then
									'Get the subtotal value
									strPromo=tblObj.GetCellData(i,2)

									strPromo=CDBL(strPromo)

								End if
							Next

					If ABS(strPromo) = ABS(strParm) Then

									strDesc ="CHECKPROMOINPLACEORDER: Promotion & Coupons for Shopping Bag and Place order is displayed as " & chr(34) & strParm & chr(34) & ", correcly."
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micPass,"Step CHECKPROMOINPLACEORDER", strDesc
									Reporter.Filter = rfDisableAll
							Else
									Desc ="CHECKPROMOINPLACEORDER: Promotion & Coupons in shopping bag is displayed as  " & chr(34) & strParm & chr(34) &", but in Place order is displayed as " & chr(34) & strPromo & chr(34) 
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1 & strLabel , objEnvironmentVariables
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micFail,"Step CHECKPROMOINPLACEORDER", strDesc
									objEnvironmentVariables.TestCaseStatus=False
									Reporter.Filter = rfDisableAll
					End If
'
								Elseif UCASE(TRIM(strOptParam)) = "SHIPPING"  Then

								'take shipping charge
								
								strRows=tblObj.GetROProperty("rows")
								For i=0 to strRows
								strCellValue=tblObj.GetCellData(i,1)

								If INSTR(strCellValue,"Shipping:")>0 Then
									'Get the subtotal value
									strShipCharge=tblObj.GetCellData(i,2)
	
									strShipCharge=CDBL(strShipCharge)
		
								End if
							Next

							If strParm=strShipCharge Then

									strDesc ="CHECKPROMOINPLACEORDER: Shipping amount in both shopping bag and Place order displayed as " & chr(34) & strParm & chr(34) & " correcly."
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micPass,"Step CHECKPROMOINPLACEORDER", strDesc
									Reporter.Filter = rfDisableAll
							Else
									Desc ="CHECKPROMOINPLACEORDER: Shipping amount in shopping bag is displayed as  " & chr(34) & strParm & chr(34) &", but in Place order is displayed as " & chr(34) & strShipCharge & chr(34) 
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1 & strLabel , objEnvironmentVariables
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micFail,"Step CHECKPROMOINPLACEORDER", strDesc
									objEnvironmentVariables.TestCaseStatus=False
									Reporter.Filter = rfDisableAll
					End If					
			End If

	END Function


    
'=======================================================================================================================================================================
''********************************************************************************************************************************************************
'FUNCTION HEADER
'********************************************************************************************************************************************************
'Name: FnvldShopBySize
'Description: This function adds a size and checks it the result is displayed based on the size /category selected
'Creation Date : 12-July-2010
'Created By: Govardhan.C (208002)
'Application: PAYLESS ECOM


			Function FnvldShopBySize (ByRef objsub , ByVal Object_Name, ByVal strInputValue, ByVal strDbValue, ByVal strOptParam, ByRef clsReport, ByRef objEnvironmentVariables , ByRef clsScreenShot ,ByVal iRowCnt ,ByVal Screen_shot_path ,ByVal strSheet_Name ,ByVal strLabel , ByVal strExpectedValue , ByVal strTestDataReference, ByVal ModuleName)			
		
					'1 Mouse over the shop by size link
										'Environment.Value ("BrowserName") ="Firefox"
					'ModuleName ="Grasshoppers"
					If ModuleName ="Grasshoppers" AND Environment.Value ("BrowserName") = "Firefox"  Then
						Set obj=Browser("brwMain").Page("pgeMain").Link("lnkShopBySize_FF")
					ElseIf ModuleName ="Grasshoppers" AND Environment.Value ("BrowserName") = "IE"  Then
						Set obj=Browser("brwMain").Page("pgeMain").WebElement("elmShopBySize")
					Else 
						Set obj=Browser("brwMain").Page("pgeMain").Link("lnkShopBySize")
					End If
					obj.highlight									
					Setting.WebPackage("ReplayType") = 2
					obj.FireEvent "onMouseOver"									
					Setting.WebPackage("ReplayType") = 1
											
		
					'2. Select the size and category based on Application and split the values accordingly.
					'2.a. A size would be selected @ random
									If Not  ModuleName ="Grasshoppers"  Then
											strAllCat=TRIM(Browser("brwMain").Page("pgeMain").WebList("lstSelectedCat").GetROProperty("all items"))	
											strAllCat=Replace(strAllCat,";",":")					
											
											strAllCat1=Split(strAllCat,":")
											If  strAllCat1(0)="Choose Category" Then
												  arrCFinalList=Split(strAllCat,"Choose Category")
												  arrCFinal=arrCFinalList(1)
												  arrCFinal1=Split(arrCFinal,":")
												  strCFinalCount=UBOUND(arrCFinal1)+1
												  valuetoselcC=RandomNumber(2,strCFinalCount)
											Else
													strCFinalCount=UBOUND(strAllCat1)+1
													valuetoselcC=RandomNumber(1,strCFinalCount)+1
											End If
						
											strCatValue=Browser("brwMain").Page("pgeMain").WebList("lstSelectedCat").GetItem(valuetoselcC)					
											Browser("brwMain").Page("pgeMain").WebList("lstSelectedCat").Select(strCatValue)
											Browser("brwMain").Sync
									End If
					
									strAllSz1=TRIM(Browser("brwMain").Page("pgeMain").WebList("lstSelectedSize").GetROProperty("all items"))					    				
									strAllSz1=Replace(strAllSz1,";",":")					
									
									arrAllSz=Split(strAllSz1,":")
									If  arrAllSz(0)="Size/Width" Then
										  arrFinalList=Split(strAllSz1,"Size/Width")
										  strFinal=arrFinalList(1)
										  strFinal1=Split(strFinal,":")
										  strFinalCount=UBOUND(strFinal1)+1
										  valuetoselc=RandomNumber(2,strFinalCount)
									Else
											strFinalCount=UBOUND(arrAllSz)+1
											valuetoselc=RandomNumber(1,strFinalCount)+1
									End If					
									strSzValue=Browser("brwMain").Page("pgeMain").WebList("lstSelectedSize").GetItem(valuetoselc)					
									Browser("brwMain").Page("pgeMain").WebList("lstSelectedSize").Select(strSzValue)    
									Browser("brwMain").Sync

									If Not  ModuleName ="Grasshoppers"  Then
												Browser("brwMain").Page("pgeMain").Image("imgSizeGo").Click
												Browser("brwMain").Sync
									End if
				
									arrSzValue = Split (strSzValue,".")
									arrSzValue1 = split (arrSzValue(1),"/")
									
									If arrSzValue1(0) = "0" then
											 strSzValue = arrSzValue(0) & "/" & arrSzValue1(1)
									End if		

									If Not  ModuleName ="Grasshoppers"  Then
									'3. Check if the search result is displayed based on the category/size selected.
											Select Case Left(strCatValue,3)
													 Case "Men"
														strCatValue="MEN"
													 Case "Wom"
														 strCatValue="WOMEN"
													 Case "Kid"
														 strCatValue="KIDS"
											End Select
												resultText =  "There were .* results for " & strCatValue & " and " & strSzValue
									 Else
												strCatValue=strSzValue
												Browser("brwMain").Page("pgeMain").WebButton("btnGo_ShopBySize").Click
												Browser("brwMain").Sync
												resultText =  ".*There were .* results for  " & strCatValue 
									End If

							Set obj=Browser("brwMain").Page("pgeMain").WebElement("elmGeneralRegEx")					
							obj.SetTOProperty "html tag","P"
							obj.SetTOProperty "innertext",resultText
							obj.Highlight			
		
							If obj.Exist(3) Then
								If Not  ModuleName ="Grasshoppers"  Then 
										strDesc ="SHOPEBYSIZE have taken the Category value "&strCatValue& " and Size "  &strSzValue& " displayed correclty."
								Else
										strDesc ="SHOPEBYSIZE have taken the Category value "&strCatValue& " and displayed correclty."
								End If
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micPass,"Step SHOPBYSIZE", strDesc
									Reporter.Filter = rfDisableAll
							Else  ''expected false	
									strDesc =strpartdesc&" at the row number " & chr(34) & iRowCnt+1 & chr(34) & " is not selected properly."
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micFail,"Step SHOPBYSIZE", strDesc
									Reporter.Filter = rfDisableAll
									objEnvironmentVariables.TestCaseStatus=False
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
							End If	

				End Function

'=====================================================================================================================================================================

'********************************************************************************************************************************************************
'FUNCTION HEADER
'********************************************************************************************************************************************************
'Name: FnVerifyShareThisLink
'Description: This function is used to verify the share this link and it's contents
'Creation Date : 15-July-2010
'Created By: Ramgopal Narayanan (229673)
'Application: PAYLESS ECOM
'Output: Returns nothing 

Function FnVerifyShareThisLink(ByRef objsub , ByVal Object_Name, ByVal strInputValue, ByVal strDbValue, ByVal strOptParam, ByRef clsReport, ByRef objEnvironmentVariables , ByRef clsScreenShot ,ByVal iRowCnt ,ByVal Screen_shot_path ,ByVal strSheet_Name ,ByVal strLabel , ByVal strExpectedValue , ByVal strTestDataReference, ByVal ModuleName)			


			Set objsub=Browser("brwMain").Page("pgeAddtoBag")
			Set obj=Browser("brwMain").Page("pgeAddtoBag").Link("lnkShareThis")
			Set objShareThis=Browser("brwMain").Page("pgeAddtoBag").WebElement("elmShareThis")
			Set objFrameShareThis=Browser("brwMain").Page("pgeAddtoBag").Frame("frmShareThis")
            		
			
			'1. Check if the Share this link exists or not
			If obj.Exist(2) Then
					strDesc ="VERIFYSHARETHISLINK: Share this link exists as expected."
					clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
					Reporter.Filter = rfEnableAll 
					Reporter.ReportEvent micPass,"Step VERIFYSHARETHISLINK", strDesc
					Reporter.Filter = rfDisableAll
			
			'2. Check for the element that contains the links when mouse hovering on it
					obj.highlight									
					Setting.WebPackage("ReplayType") = 2
					obj.FireEvent "onMouseOver"									
					Setting.WebPackage("ReplayType") = 1
			
					If objShareThis.Exist(2) Then
						objShareThis.highlight	
						strDesc ="VERIFYSHARETHISLINK: The fly out 'Share With Friends' is  displayed as expected."
						clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
						Reporter.Filter = rfEnableAll 
						Reporter.ReportEvent micPass,"Step VERIFYSHARETHISLINK", strDesc
						Reporter.Filter = rfDisableAll
			
			'3. Check for the social site links within the flyout
						Setting.WebPackage("ReplayType") = 2
						obj.FireEvent "onMouseOver"									
						Setting.WebPackage("ReplayType") = 1
						Wait 2
						Set objlnkObj = Description.Create()
						objlnkObj("micclass").Value = "Link"
						objlnkObj("html tag").Value = "A"
						Set objSocialSites=objFrameShareThis.ChildObjects(objlnkObj)
						arrSSLinks=Split(strInputValue,"~")
						IsSocialSiteFound=False
						For i=0 to objSocialSites.count-1
							strLinkVal=objSocialSites(i).GetROProperty("text")
							For j=0 to UBOUND(arrSSLinks)
								If INSTR(strLinkVal,arrSSLinks(j))>0 Then
'									Setting.WebPackage("ReplayType") = 2
'									obj.FireEvent "onMouseOver"									
'									Setting.WebPackage("ReplayType") = 1
									IsSocialSiteFound=True
'									objsub.Link("lnkGeneral").SetTOProperty "text",strLinkVal
'									objsub.Link("lnkGeneral").Highlight
									strDesc ="VERIFYSHARETHISLINK: The social networking site " & chr(34) & arrSSLinks(j) & chr(34) & " is available under the 'Share This' section."
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micPass,"Step VERIFYSHARETHISLINK", strDesc
									Reporter.Filter = rfDisableAll
								End If
							Next
						Next
						'** Fail if not even one site found **
						If  NOT(IsSocialSiteFound)Then
							strDesc ="VERIFYSHARETHISLINK: The fly out 'Share With Friends' is not displayed, so cannot proceed further on the social n/w sites verification."
							clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
							clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
							Reporter.Filter = rfEnableAll 
							Reporter.ReportEvent micFail,"Step VERIFYSHARETHISLINK", strDesc
							objEnvironmentVariables.TestCaseStatus=False
							Reporter.Filter = rfDisableAll
						End If
			
					Else
						strDesc ="VERIFYSHARETHISLINK: The fly out 'Share With Friends' is not displayed, so cannot proceed further on the social n/w sites verification."
						clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
						clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
						Reporter.Filter = rfEnableAll 
						Reporter.ReportEvent micFail,"Step VERIFYSHARETHISLINK", strDesc
						objEnvironmentVariables.TestCaseStatus=False
						Reporter.Filter = rfDisableAll
					End If
			Else
					 strDesc ="VERIFYSHARETHISLINK: Share this link doesn't exists as expected, cannot proceed further on the social n/w sites verification."
					clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
					clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
					Reporter.Filter = rfEnableAll 
					Reporter.ReportEvent micFail,"Step VERIFYSHARETHISLINK", strDesc
					objEnvironmentVariables.TestCaseStatus=False
					Reporter.Filter = rfDisableAll
			End If
			
			
			Set objsub=Nothing
			Set obj=Nothing
			Set objShareThis=Nothing
			Set objlnkObj=Nothing
			Set objSocialSites=Nothing
			Browser("brwMain").Refresh


End Function


'=====================================================================================================================================================================

'********************************************************************************************************************************************************
'FUNCTION HEADER
'********************************************************************************************************************************************************
'Name: FnVerifyDymanicTabs
'Description: This function is used to verify the dymanic tabs under the add to bag page n its contents
'Creation Date : 19-July-2010
'Created By: Ramgopal Narayanan (229673)
'Application: PAYLESS ECOM
'Output: Returns nothing 

Function FnVerifyDymanicTabs(ByRef objsub , ByVal Object_Name, ByVal strInputValue, ByVal strDbValue, ByVal strOptParam, ByRef clsReport, ByRef objEnvironmentVariables , ByRef clsScreenShot ,ByVal iRowCnt ,ByVal Screen_shot_path ,ByVal strSheet_Name ,ByVal strLabel , ByVal strExpectedValue , ByVal strTestDataReference, ByVal ModuleName)			



			Set objsub=Browser("brwMain").Page("pgeAddtoBag")
			Set objDynamicTab=objsub.WebElement("elmDynamicTabs")
			Set objDynamicTabContent=objsub.WebElement("elmDynamicTabsContent")
            		
			
			'1. Check if the Dynamic Tabs are displayed or not
			If objDynamicTab.Exist(2) Then
'					strDesc ="VERIFYDYNAMICTABS: Dynamic Tabs are displayed."
'					clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
'					Reporter.Filter = rfEnableAll 
'					Reporter.ReportEvent micPass,"Step VERIFYDYNAMICTABS", strDesc
'					Reporter.Filter = rfDisableAll
                    
			'2. Check if some tab headers/links are displayed or its just the blank content tab place holder

					Set objlnkObj = Description.Create()
					objlnkObj("micclass").Value = "Link"
					objlnkObj("html tag").Value = "A"
					Set objDynamicTabLinks=objDynamicTab.ChildObjects(objlnkObj)					
			
					If objDynamicTabLinks.Count>0 Then
						objDynamicTab.Highlight
						strDesc ="VERIFYDYNAMICTABS: Dynamic Tabs are displayed with actual tabs rather than just palce holders."
						clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
						Reporter.Filter = rfEnableAll 
						Reporter.ReportEvent micPass,"Step VERIFYDYNAMICTABS", strDesc
						Reporter.Filter = rfDisableAll

				'3. Click thru' each of them and check if they have content in them, if not fail it
						For i=0 to objDynamicTabLinks.count-1
							strLinkVal=objDynamicTabLinks(i).GetROProperty("text")
                    		objsub.Link("lnkGeneral").SetTOProperty "text",strLinkVal
							objsub.Link("lnkGeneral").Highlight
							objsub.Link("lnkGeneral").Click
							Wait 1
							'3.a. Check if the content place holder is available or not, if so print the text in that, else fail it
							objDynamicTabContent.SetTOProperty "html id","tab-" & i+1
							If objDynamicTabContent.Exist(2) Then
								strDesc ="VERIFYDYNAMICTABS: The content for the tab " & chr(34) & strLinkVal & chr(34) & " is displayed."
								clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
								Reporter.Filter = rfEnableAll 
								Reporter.ReportEvent micPass,"Step VERIFYDYNAMICTABS", strDesc
								Reporter.Filter = rfDisableAll
						   Else
								strTabCont=objDynamicTabContent.GetROProperty("innertext")
								If strTabCont="" or strTabCont=" " Then
									strTabCont="BLANK"
								End If
								strDesc ="VERIFYDYNAMICTABS: The content for the tab " & chr(34) & strLinkVal & chr(34) & " is not displayed. The content displayed is " & strTabCont  &"."
								clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
								clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
								Reporter.Filter = rfEnableAll 
								Reporter.ReportEvent micFail,"Step VERIFYDYNAMICTABS", strDesc
								objEnvironmentVariables.TestCaseStatus=False
								Reporter.Filter = rfDisableAll
							End If
						Next
					Else
						strDesc ="VERIFYDYNAMICTABS: Dynamic Tabs are not available for this product."
						Reporter.Filter = rfEnableAll
						Reporter.ReportEvent micdone,"Step VERIFYDYNAMICTABS ", strDesc
						Reporter.Filter = rfDisableAll 
						clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2
					End If
			Else
				'Dynamic Tabs are not available for this product
				strDesc ="VERIFYDYNAMICTABS: Dynamic Tabs are not available for this product."
				Reporter.Filter = rfEnableAll
				Reporter.ReportEvent micdone,"Step VERIFYDYNAMICTABS ", strDesc
				Reporter.Filter = rfDisableAll 
				clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2
			End If
			
			
			Set objsub=Nothing
			Set obj=Nothing
			Set objDynamicTab=Nothing
			Set objlnkObj=Nothing
			Set objDynamicTabContent=Nothing

End Function
'============================================================================================================================================================================
		

	'=======================================================================================================================================================================
'********************************************************************************************************************************************************
'FUNCTION HEADER
'********************************************************************************************************************************************************
'Name: FnCheckPriceAfterCpn
'Description: This function Check the price after applying invalid coupons
'Creation Date : 16-July-2010
'Created By: fayis k (229680)
'Application: PAYLESS ECOM



Function FnCheckPriceAfterCpn (ByRef objsub , ByVal Object_Name, ByVal strInputValue, ByVal strDbValue, ByVal strOptParam, ByRef clsReport, ByRef objEnvironmentVariables ,  ByRef clsScreenShot ,ByVal iRowCnt ,ByVal Screen_shot_path ,ByVal strSheet_Name ,ByVal strLabel , ByVal strExpectedValue , ByVal strTestDataReference, ByVal ModuleName)			

'Apply coupon
				Set objsub=Browser("brwMain").Page("pgeShoppingBag")
                Set tblObj=objsub.WebTable("tblItems")
				Set elmObj=objsub.WebElement("elmGeneral")

'Take the order total befor applying coupon
					strRowCnt=objsub.WebTable("tblItems").GetROProperty("rows")
					For i=0 to strRowCnt
						strCellValue=tblObj.GetCellData(i,1)
						If INSTR(strCellValue,"Item subtotal:")>0 Then
'Get the subtotal value
									strItemSubTotal=tblObj.GetCellData(i,2)
									strItemSubTotal=CDBL(strItemSubTotal)
						End if
					Next

'Take Order total befor applying coupon

					strRowCnt=objsub.WebTable("tblItems").GetROProperty("rows")
					For i=0 to strRowCnt
						strCellValue=tblObj.GetCellData(i,1)
						If INSTR(strCellValue,"Estimated order total:")>0 Then
'Get the subtotal value
									strOrderTotal=tblObj.GetCellData(i,2)
									strOrderTotal=CDBL(strOrderTotal)
						End if
					Next

'Apply coupon

					strCpnCode = CSTR( TRIM(strInputValue))
				    objsub.WebEdit("edtCoupons").Set(strCpnCode)
					objsub.Image("imgApply").Click(3)

					Browser("brwMain").Sync

'Coupon message
'VALID
'INVALID
'EXPIRED
'REDEEMED
					strCpn =FALSE
'strCpnValid =FALSE
'					If  strExpectedValue =   UCASE(TRIM ("VALID")) Then
'                			
'									elmObj.SetTOProperty "innertext",  "Coupon "&chr(34) & strCpnCode &chr(34)&" Applied"
'									elmObj.SetTOProperty "html tag", "LI"
'				
'									If elmObj.Exist (3) Then
'											elmObj.Highlight
'											strCpnValid = TRUE
'											strCpnMsg = "Valid coupon applied as expected."
'									Else
'											strCpnMsg = "Entered coupon is not  valid."
'											strCpnValid = FALSE
'
'									End If
					If strExpectedValue =   UCASE(TRIM ("INVALID")) Then
								elmObj.SetTOProperty "innertext",  "You entered an invalid coupon code."
									elmObj.SetTOProperty "html tag", "STRONG"
				
									If elmObj.Exist (3) Then
											elmObj.Highlight
											strCpn = TRUE
											strCpnMsg = "Coupon is invalid as expected."
									Else
											strCpnMsg = "Entered coupon is NOT invalid as expected."
											strCpn = FALSE
									End If

					Elseif strExpectedValue =   UCASE(TRIM ("EXPIRED")) Then
								elmObj.SetTOProperty "innertext",  "The coupon code you entered has expired."
									elmObj.SetTOProperty "html tag", "STRONG"
									If elmObj.Exist (3) Then
											elmObj.Highlight
											strCpn = TRUE
											strCpnMsg = "Coupon has expired as expected."
									Else
											strCpnMsg = "Entered coupon is NOT an Expired  Coupon as expected." 
											strCpn = FALSE
									End If

					Elseif strExpectedValue =   UCASE(TRIM ("REDEEMED")) Then

								elmObj.SetTOProperty "innertext",  "This single-use coupon code has already been redeemed."
									elmObj.SetTOProperty "html tag", "STRONG"
				
									If elmObj.Exist (3) Then
											elmObj.Highlight
											strCpn = TRUE
											strCpnMsg = "Coupon has alread redeemed as expected."
									Else
											strCpnMsg = "Entered coupon is NOT Redeemed  Coupon as expected." 
											strCpn = FALSE
									End If
					End If


'Take the order total after cpn

					strRowCnt=objsub.WebTable("tblItems").GetROProperty("rows")
					For i=0 to strRowCnt
						strCellValue=tblObj.GetCellData(i,1)
						If INSTR(strCellValue,"Item subtotal:")>0 Then
'Get the subtotal value
									strCpnItemSubTotal=tblObj.GetCellData(i,2)
									strCpnItemSubTotal=CDBL(strCpnItemSubTotal)
						End if
					Next


'Take Order total after coupon;


					strRowCnt=objsub.WebTable("tblItems").GetROProperty("rows")
					For i=0 to strRowCnt
						strCellValue=tblObj.GetCellData(i,1)
						If INSTR(strCellValue,"Estimated order total:")>0 Then
'Get the subtotal value
									strCpnOrderTotal=tblObj.GetCellData(i,2)
									strCpnOrderTotal=CDBL(strCpnOrderTotal)
						End if
					Next

'					If  strCpn Then
'									If (strItemSubTotal = strCpnItemSubTotal) AND (strOrderTotal = strCpnOrderTotal) Then
'											strDesc ="CHECKPRICEAFTERCPN: " & strCpnMsg & " Sub total and Item total remains same after coupon apllied."
'											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
'											Reporter.Filter = rfEnableAll 
'											Reporter.ReportEvent micPass,"Step CHECKPRICEAFTERCPN", strDesc
'											Reporter.Filter = rfDisableAll
'									Else
'											Desc ="CHECKPRICEAFTERCPN: "&strCpnMsg &  " But item total  or Order total has been changed"
'											clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1 & strLabel , objEnvironmentVariables
'											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
'											Reporter.Filter = rfEnableAll 
'											Reporter.ReportEvent micFail,"Step CHECKPRICEAFTERCPN", strDesc
'											objEnvironmentVariables.TestCaseStatus=False
'											Reporter.Filter = rfDisableAll
'				Else
'
'
'
'					End If



				If ( strCpn  AND (strItemSubTotal = strCpnItemSubTotal) AND (strOrderTotal = strCpnOrderTotal)) Then

									strDesc ="CHECKPRICEAFTERCPN: " & strCpnMsg & " Sub total and Item total remains same after coupon apllied."
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micPass,"Step CHECKPRICEAFTERCPN", strDesc
									Reporter.Filter = rfDisableAll

				ElseIf  (strCpnValid AND ((strItemSubTotal <> strCpnItemSubTotal) OR (strOrderTotal <>strCpnOrderTotal))) Then

									strDesc ="CHECKPRICEAFTERCPN: " & strCpnMsg & " Sub total and Item total have been changed after coupon apllied."
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micPass,"Step CHECKPRICEAFTERCPN", strDesc
									Reporter.Filter = rfDisableAll
				Else

									Desc ="CHECKPRICEAFTERCPN: "&strCpnMsg
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1 & strLabel , objEnvironmentVariables
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micFail,"Step CHECKPRICEAFTERCPN", strDesc
									objEnvironmentVariables.TestCaseStatus=False
									Reporter.Filter = rfDisableAll
								
				End If

END Function
'========================================================================================================================================================================


'======================================================================================================================================================================
'********************************************************************************************************************************************************
'FUNCTION HEADER
'********************************************************************************************************************************************************
'Name: FnOrderNavigation
'Description: In order to validate  the Display order History results page,Verify Links (Previous and Next) are in Disable/Enable Mode and page numbers are being Displayed as per Results 
'Creation Date : 14-July-2010
'Created By: Govardhan
'Application: PAYLESS ECOM
'Output: Returns nothing 
' Input  strInputValue (Number of Results Per Page) and strOptParam (To verify either page links or Links Previous and Next

Function FnOrderNavigation(ByRef objsub , ByVal Object_Name, ByVal strInputValue, ByVal strDbValue, ByVal strOptParam, ByRef clsReport, ByRef objEnvironmentVariables ,	ByRef clsScreenShot ,ByVal iRowCnt ,ByVal Screen_shot_path ,ByVal strSheet_Name ,ByVal strLabel , ByVal strExpectedValue , ByVal strTestDataReference, ByVal ModuleName) 

'		strInputValue=10
'		strOptParam= "PAGELINKS"

		strInputValue=cInt(strInputValue)
' getting the total number of orders placed from MESSAGE "Displaying of 1-10 of 34 results"
		If Browser("brwMain").Page("pgeProductList").WebElement("elmResultsDisplayed").Exist(2) Then
				elmResfnd=Browser("brwMain").Page("pgeProductList").WebElement("elmResultsDisplayed").GetROProperty("innertext")
		End If
		If  elmResfnd<>""Then
				arrTemp=split(elmResfnd,"of")
				arrTemp1=split(arrTemp(1),"results")
				elmResNo=CINT(TRIM(arrTemp1(0)))
		End If

		Select Case strOptParam
		Case "PAGINATION"
'Validating the Pagination Links PREVIOUS and NEXT
			genLinks="Previous_0:Next_0:Previous_1:Next_1"
			arrLinks=split(genLinks,":")
			set lnkGen=Browser("brwMain").Page("pgeGeneral").Link("lnkGeneral")
'Order Results Found are less than or equal to 10 per page
			If elmResNo<=strInputValue Then
				For i=0 to UBOUND(arrLinks)
					arrTBlnk=split(arrLinks(i),"_")
					lnkGen.SetTOProperty "text",arrTBlnk(0)
					lnkGen.SetTOProperty "Index",arrTBlnk(1)
					lnkGen.SetTOProperty "innerhtml",arrTBlnk(0)
					If arrTBlnk(1)="0"then
						position="TOP"
					ElseIf	arrTBlnk(1)="1" then
						position="BOTTOM"
					End If
					If lnkGen.Exist(2) Then
'If links PREVIOUS and NEXT exist 
						strDesc = "VERIFYORDERHISTORYNAVIGATION: Link " & chr(34) & arrTBlnk(0) & chr(34) &" with the Index value: " & chr(34) & arrTBlnk(1) & chr(34) &  " at the "& chr(34) & position & chr(34) & " exists, Which is not as expected."
						clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
						clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
						Reporter.Filter = rfEnableAll 
						Reporter.ReportEvent micFail,"Step VERIFYORDERHISTORYNAVIGATION", strDesc
						objEnvironmentVariables.TestCaseStatus=False
						Reporter.Filter = rfDisableAll
					Else
						strDesc = "VERIFYORDERHISTORYNAVIGATION: Link " & chr(34) & arrTBlnk(0) & chr(34) &" with the Index value: " & chr(34) & arrTBlnk(1) & chr(34) &  " at the "& chr(34) & position & chr(34) & " doesn't exist as expected."
						clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1								
						Reporter.Filter = rfEnableAll 
						Reporter.ReportEvent micPass,"Step VERIFYORDERHISTORYNAVIGATION", strDesc							 
						Reporter.Filter = rfDisableAll
					End If
				Next
	
'Order Results Found are More than 10 per page
			Else
				For i=0 to UBOUND(arrLinks)
					arrTBlnk=split(arrLinks(i),"_")
					lnkGen.SetTOProperty "text",arrTBlnk(0)
					lnkGen.SetTOProperty "Index",arrTBlnk(1)
					lnkGen.SetTOProperty "innerhtml",arrTBlnk(0)
'If links PREVIOUS and NEXT exist 
					If lnkGen.Exist(2) Then
						lnkPvNxSts=lnkGen.GetROProperty("class")
						If 	lnkPvNxSts=""  Then
							lnkPvNxSts="active"
						End If
' To verfiy the Status of PREVIOUS and NEXT Links (Active or Disable)
						If (lnkPvNxSts="active"  AND arrTBlnk(0)="Next") OR (lnkPvNxSts="disable" AND arrTBlnk(0)="Previous") Then
							strDesc = "VERIFYORDERHISTORYNAVIGATION: Link  " & chr(34) & arrTBlnk(0) & chr(34) &" with the Property :" & chr(34) & lnkPvNxSts & chr(34) &" exist as expected."
							clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1								
							Reporter.Filter = rfEnableAll 
							Reporter.ReportEvent micPass,"Step VERIFYORDERHISTORYNAVIGATION", strDesc							 
							Reporter.Filter = rfDisableAll
						Else
							strDesc = "VERIFYORDERHISTORYNAVIGATION: Link  " & chr(34) & arrTBlnk(0) & chr(34) &" with the Property :" & chr(34) & lnkPvNxSts & chr(34) &" doesn't exist as expected."
							clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
							clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
							Reporter.Filter = rfEnableAll 
							Reporter.ReportEvent micFail,"Step VERIFYORDERHISTORYNAVIGATION", strDesc
							objEnvironmentVariables.TestCaseStatus=False
							Reporter.Filter = rfDisableAll
						End If

						If i=UBOUND(arrLinks) Then
'Link Click on NEXT is Performed
							lnkGen.Click
							Browser("brwMain").Sync
							strDesc="VERIFYORDERHISTORYNAVIGATION:LinkClick action on "& chr(34) & "Next" & chr(34) &" successfully performed."
							Reporter.Filter = rfEnableAll
							Reporter.ReportEvent micdone,"Step VERIFYORDERHISTORYNAVIGATION", " The Link "& chr(34) & "Next" & chr(34) &" has been clicked." 
							Reporter.Filter = rfDisableAll													
							clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2

							Input1=strInputValue+1
							If  elmResNo>=(2*strInputValue)Then
									Input2=strInputValue*2
							Else
									Input2=elmResNo
							End If
	
'Validate the results In Next page By means of Element "Displaying of 11-20 of results"
							ResDis="Displaying "& Input1 &"- " & Input2 & " of " &elmResNo&" results"
							Set objDisp=Browser("brwMain").Page("pgeGeneral").WebElement("elmGeneral")
							objDisp.SetTOProperty "innertext",ResDis
                            objDisp.SetTOProperty "html tag","DIV"
							If objDisp.Exist(2) Then
								objDisp.highlight
								strDesc = "VERIFYORDERHISTORYNAVIGATION: Order results Message "& chr(34) & ResDis & chr(34) &" in Second Page as Expected."
								clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1								
								Reporter.Filter = rfEnableAll 
								Reporter.ReportEvent micPass,"Step VERIFYORDERHISTORYNAVIGATION", strDesc							 
								Reporter.Filter = rfDisableAll
							Else							
								strDesc = "VERIFYORDERHISTORYNAVIGATION: Order results Message "& chr(34) & ResDis & chr(34) &" in Second Page, doesn't Exist as Expected."
								clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
								clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
								Reporter.Filter = rfEnableAll 
								Reporter.ReportEvent micFail,"Step VERIFYORDERHISTORYNAVIGATION", strDesc
								objEnvironmentVariables.TestCaseStatus=False
								Reporter.Filter = rfDisableAll		
							End If

							lnkPvNxSts=lnkGen.GetROProperty("class")
							If 	lnkPvNxSts=""  Then
								lnkPvNxSts="active"
							End If
							If lnkPvNxSts="active" Then
								strDesc = "VERIFYORDERHISTORYNAVIGATION: Link  " & chr(34) & arrTBlnk(0) & chr(34) &" with the Property :" & chr(34) & lnkPvNxSts & chr(34) &" exist as expected."
								clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1								
								Reporter.Filter = rfEnableAll 
								Reporter.ReportEvent micPass,"Step VERIFYORDERHISTORYNAVIGATION", strDesc							 
								Reporter.Filter = rfDisableAll
							Else
								strDesc = "VERIFYORDERHISTORYNAVIGATION: Link  " & chr(34) & arrTBlnk(0) & chr(34) &" with the Property :" & chr(34) & lnkPvNxSts & chr(34) &" doesn't exist as expected."
								clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
								clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
								Reporter.Filter = rfEnableAll 
								Reporter.ReportEvent micFail,"Step VERIFYORDERHISTORYNAVIGATION", strDesc
								objEnvironmentVariables.TestCaseStatus=False
								Reporter.Filter = rfDisableAll
							End If
                        End If
					Else
						strDesc = "VERIFYORDERHISTORYNAVIGATION: Link " & chr(34) & arrTBlnk(0) & chr(34) &" with the Index value: " & chr(34) & arrTBlnk(1) & chr(34) &  " at the "& chr(34) & position & chr(34) & " doesn't exist as expected."
						clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1								
						Reporter.Filter = rfEnableAll 
						Reporter.ReportEvent micPass,"Step VERIFYORDERHISTORYNAVIGATION", strDesc							 
						Reporter.Filter = rfDisableAll
						arrLinkExist(i)=TRUE
					End If
				Next
			End If
	
		Case "PAGELINKS"
'Order Results Found are less than or equal to 10 per page so No Page Numbers Should be dispalyed
			If elmResNo<=strInputValue Then
'Validating the Pagination Links "1"and "2"
			genLinks="1_0:2_0:1_1:1_1"
			arrLinks=split(genLinks,":")
			set lnkGen=Browser("brwMain").Page("pgeGeneral").Link("lnkGeneral")
				For i=0 to UBOUND(arrLinks)
					arrTBlnk=split(arrLinks(i),"_")
					lnkGen.SetTOProperty "text",arrTBlnk(0)
					lnkGen.SetTOProperty "Index",arrTBlnk(1)
					lnkGen.SetTOProperty "innerhtml",arrTBlnk(0)
					If arrTBlnk(1)="0"then
						position="TOP"
					ElseIf	arrTBlnk(1)="1" then
						position="BOTTOM"
					End If
					If lnkGen.Exist(2) Then
'If links PREVIOUS and NEXT exist 
						strDesc = "VERIFYORDERHISTORYNAVIGATION: Link " & chr(34) & arrTBlnk(0) & chr(34) &" with the Index value: " & chr(34) & arrTBlnk(1) & chr(34) &  " at the "& chr(34) & position & chr(34) & " exists, Which is not as expected."
						clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
						clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
						Reporter.Filter = rfEnableAll 
						Reporter.ReportEvent micFail,"Step VERIFYORDERHISTORYNAVIGATION", strDesc
						objEnvironmentVariables.TestCaseStatus=False
						Reporter.Filter = rfDisableAll
					Else
						strDesc = "VERIFYORDERHISTORYNAVIGATION: Link " & chr(34) & arrTBlnk(0) & chr(34) &" with the Index value: " & chr(34) & arrTBlnk(1) & chr(34) &  " at the "& chr(34) & position & chr(34) & " doesn't exist as expected."
						clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1								
						Reporter.Filter = rfEnableAll 
						Reporter.ReportEvent micPass,"Step VERIFYORDERHISTORYNAVIGATION", strDesc							 
						Reporter.Filter = rfDisableAll
					End If
				Next
	
'Order Results Found are More than 10 per page
			Else
'Validating the Pagination Links "1","2"and "3"
				genLinks="1_0:1_1"
				ordPages=(elmResNo\strInputValue)+1
				ordLstPage=elmResNo mod strInputValue
				For i=2 to ordPages
					If i<4 Then
							genLinks=genLinks &":"& i&"_0:"&i&"_1"
					Else
							Exit for
					End If
				Next
				arrLinks=split(genLinks,":")
				set lnkGen=Browser("brwMain").Page("pgeGeneral").Link("lnkGeneral")
				For i=0 to UBOUND(arrLinks)
					arrTBlnk=split(arrLinks(i),"_")
					lnkGen.SetTOProperty "text",arrTBlnk(0)
					lnkGen.SetTOProperty "Index",arrTBlnk(1)
					lnkGen.SetTOProperty "innerhtml",arrTBlnk(0)
					If arrTBlnk(1)="0"then
						position="TOP"
					ElseIf	arrTBlnk(1)="1" then
						position="BOTTOM"
					End If
					If lnkGen.Exist(2) Then
'Validating Page Numbers "1",2" and "3" exist 
						strDesc = "VERIFYORDERHISTORYNAVIGATION: Link " & chr(34) & arrTBlnk(0) & chr(34) &" with the Index value: " & chr(34) & arrTBlnk(1) & chr(34) &  " at the "& chr(34) & position & chr(34) & " exist as expected."
						clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1								
						Reporter.Filter = rfEnableAll 
						Reporter.ReportEvent micPass,"Step VERIFYORDERHISTORYNAVIGATION", strDesc							 
						Reporter.Filter = rfDisableAll
					Else
						strDesc = "VERIFYORDERHISTORYNAVIGATION: Link " & chr(34) & arrTBlnk(0) & chr(34) &" with the Index value: " & chr(34) & arrTBlnk(1) & chr(34) &  " at the "& chr(34) & position & chr(34) & " doesn't exists as expected."
						clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
						clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
						Reporter.Filter = rfEnableAll 
						Reporter.ReportEvent micFail,"Step VERIFYORDERHISTORYNAVIGATION", strDesc
						objEnvironmentVariables.TestCaseStatus=False
						Reporter.Filter = rfDisableAll
					End If
				Next

'To perform a Click Action on page number depends on the Results Available
				If ordPages>4 Then
					pgeclick=3
'Validating the Available page numbers after performing above action
				Else
					pgeclick=2
				End If
				lnkGen.SetTOProperty "text",CStr(pgeclick)
				lnkGen.SetTOProperty "Index","0"
				lnkGen.SetTOProperty "innerhtml",CStr(pgeclick)

				If  lnkGen.Exist(2) Then
					lnkGen.Click
					Browser("brwMain").Sync
					strDesc="VERIFYORDERHISTORYNAVIGATION:LinkClick action on Page:"& chr(34) & pgeclick & chr(34) &" successfully performed."
					Reporter.Filter = rfEnableAll
					Reporter.ReportEvent micdone,"Step VERIFYORDERHISTORYNAVIGATION", " The Link "& chr(34) & pgeclick & chr(34) &" has been clicked." 
					Reporter.Filter = rfDisableAll													
					clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2
				End If	

'Validate the results In clicked page By means of Element "Displaying of 11-20 of results"
				resStart=(strInputValue*(pgeclick-1))+1
				resEnd=strInputValue*pgeclick
				If resEnd > elmResNo Then
						resEnd=elmResNo		
				End If
				ResDis="Displaying "& resStart & "- " & resEnd & " of " &elmResNo&" results"
				Set objDisp=Browser("brwMain").Page("pgeGeneral").WebElement("elmGeneral")
				objDisp.SetTOProperty "innertext",ResDis
				objDisp.SetTOProperty "html tag","DIV"
				If objDisp.Exist(2) Then
					objDisp.highlight
					strDesc = "VERIFYORDERHISTORYNAVIGATION: Order results Message "& chr(34) & ResDis & chr(34) &" in "& chr(34) & pgeclick & chr(34) &" Page as Expected."
					clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1								
					Reporter.Filter = rfEnableAll 
					Reporter.ReportEvent micPass,"Step VERIFYORDERHISTORYNAVIGATION", strDesc							 
					Reporter.Filter = rfDisableAll
				Else							
					strDesc = "VERIFYORDERHISTORYNAVIGATION: Order results Message "& chr(34) & ResDis & chr(34) &" in Second Page, doesn't Exist as Expected."
					clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
					clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
					Reporter.Filter = rfEnableAll 
					Reporter.ReportEvent micFail,"Step VERIFYORDERHISTORYNAVIGATION", strDesc
					objEnvironmentVariables.TestCaseStatus=False
					Reporter.Filter = rfDisableAll		
				End If					
			End If			
		End Select

End Function		

'======================================================================================================================================================================
'
'********************************************************************************************************************************************************
'FUNCTION HEADER
'********************************************************************************************************************************************************
'Name: FnShippingTaxes
'Description: In order to validate  the Shipping Charges and Taxes in Review and Order Payment page are Categorised accordingly with States and ZipCode
'Creation Date : 16-July-2010
'Created By: Govardhan
'Application: PAYLESS ECOM
'Output: Returns nothing 
' Input  Nothing

Function FnShippingTaxes(ByRef objsub , ByVal Object_Name, ByVal strInputValue, ByVal strDbValue, ByVal strOptParam, ByRef clsReport, ByRef objEnvironmentVariables ,	ByRef clsScreenShot ,ByVal iRowCnt ,ByVal Screen_shot_path ,ByVal strSheet_Name ,ByVal strLabel , ByVal strExpectedValue , ByVal strTestDataReference, ByVal ModuleName) 	
	
'strInputValue="$5.00:$75.00~$0.00:"     'For Saucony Original and performance
'strInputValue="$2.00:$24.00~$6.95:$150.00~$0.00:"   ' for Sperry Top Sider
'ModuleName="Sperry"
			Dim arrTax(6),arrProdChrg(6)
'Forming an Array that Contains State Name as wall as It's Zip code
			strStateZip="AA-Armed Forces America:34002~Wisconsin:53227~AE-Armed Forces (General):09496~Washington:98851~AE-Armed Forces Europe:09494~Vermont:05452~Alabama:35004~Texas:78230~Alaska:99501~South Dakota:57775~AP-Armed Forces Pacific:96541~Rhode Island:02903~Arizona:85296~Pennsylvania:19426~Arkansas:72032~Oklahoma:74135~California:91301~North Dakota:58424~Colorado:80918~Connecticut:06870~New Mexico:87110~Nevada:89704~Delaware:19807~New Hampshire:03104~District of Columbia:20009~Montana:59102~Florida:32701~Hawaii:96816~Missouri:63119~Idaho:83702~Minnesota:55802~Iowa:52803~Mississippi:39119~Kansas:66044~Louisiana:70808~Maryland:21220~Maine:04101~Michigan:48103~Nebraska:68727~New York:12910~North Carolina:27215~Ohio:44878~Massachusetts:01810~Oregon:97520~Puerto Rico:00611~South Carolina:29464~Kentucky:42202~New Jersey:07702~Tennessee:37027~Indiana:46259~Utah:84084~Virginia:20186~Illinois:60188~West Virginia:26036~Georgia:30324~Wyoming:83128"
			'Provide Shipping charges from Excel Sheet to change Dynamically FORMAT:  "Shipping Charges:MaxLimit~Shipping Charges:MaxLimit...."   e.g..., $5.00:$75.00~$0.00:"  
			j=0
			' If Strinputvalue is not NULL
			If strInputValue<>"" Then
				arrChrg=Split(strInputValue,"~")
				For i=0 to UBOUND(arrChrg)
			'splitting by shipping charges for different Subtotals
					arrShipChrg=Split(arrChrg(i),":")
			 'Splitting and storing Shipping Charges and Item Subtotals in 2 different Arrays
					arrTax(j)=arrShipChrg(0)
					arrProdChrg(j)=arrShipChrg(1)
					j=j+1
				Next
			 End If
			arrStateZip=Split(strStateZip,"~")
			'Modifying the Drop down State and Zip code in Shipping Address Section For each iteration
			For i=0 to UBOUND(arrStateZip)
				Set objLnk=Browser("brwMain").Page("pgeMyAccount").Link("lnkGeneral")
					objLnk.SetTOProperty "text","Edit"
					objLnk.SetTOProperty "Index","1"
					objLnk.Highlight
					If objLnk.Exist(2) Then
						objLnk.Click		
			'Handling the Dialog Box
						Browser("brwMain").Sync

						Set FSO = CreateObject("Scripting.FileSystemObject") 
						IEVersion = FSO.GetFileVersion("C:\Program Files\Internet Explorer\iexplore.exe") 
						IEVersion=CInt(Left(IEVersion,1))
						If IEVersion=6 AND Environment.Value ("BrowserName") = "IE" Then
							Counter=0
							Do
								Counter=Counter+1
								If Counter>10 Then
									Exit Do
								End If
							Loop Until Dialog("dlgSecurityInformation").Exist(2)
							
							If Dialog("dlgSecurityInformation").Exist(2) then
								Dialog("dlgSecurityInformation").WinButton("btnYes").Click
							Else
							' Do Nothing
							End If
						End If
						Set FSO=Nothing

						arrStZp=split(arrStateZip(i),":")
						Browser("brwMain").Page("pgeShipBillAddress").WebList("lstShipState").Select(arrStZp(0))
						Wait 2
						Browser("brwMain").Page("pgeShipBillAddress").WebEdit("edtShipZipCode").Set(arrStZp(1))
						Wait 2
						Browser("brwMain").Page("pgeShipBillAddress").Image("imgSaveChanges").Click
						If  Browser("brwMain").Page("pgeShipBillAddress").Image("imgSaveChanges").Exist(2)Then
							Browser("brwMain").Page("pgeShipBillAddress").Image("imgSaveChanges").Click
						End If
						Wait 2
						Browser("brwMain").Sync
			'Getting the Shipping charges and Taxes from Order Review & Payment Page
						For j=7 to 12
							If  Browser("brwMain").Page("pgeMyAccount").WebTable("tblCreditCardOrder").GetCellData(j,2)= "Item subtotal:" Then
								strSubTotal=Browser("brwMain").Page("pgeMyAccount").WebTable("tblCreditCardOrder").GetCellData(j,3)
							End If
							If  Browser("brwMain").Page("pgeMyAccount").WebTable("tblCreditCardOrder").GetCellData(j,1)= "Shipping:" Then
								strShipChrg=Browser("brwMain").Page("pgeMyAccount").WebTable("tblCreditCardOrder").GetCellData(j,2)
							End If
							If  Browser("brwMain").Page("pgeMyAccount").WebTable("tblCreditCardOrder").GetCellData(j,1)= "Taxes:" Then
								strTaxChrg=Browser("brwMain").Page("pgeMyAccount").WebTable("tblCreditCardOrder").GetCellData(j,2)
							End If
						Next
			'Validating the Taxes for all the States which exist(s) as Expected or NOT
						If  arrStZp(0)="Alaska" OR arrStZp(0)="Hawaii" OR arrStZp(0)="Puerto Rico" Then
							For x=0 to UBOUND(arrChrg)
			 'For the States mentioned adding an  Extra SUB-Charge of 10.00$ to Shipping Charges and verifying in the application
								If arrProdChrg(x)<>"" Then
									If CDBL(strSubTotal)<CDBL(arrProdChrg(x))  Then
										temp="$"+CSTR(CDBL(arrTax(x))+10.001)
										ExpShipChrg=Left(temp,len(temp)-1)
									End If
			'If Shipping Charges are more than some 150$ i.e the final value in array it directly takes the Shipping Charges as 0.00$ and adds the corresponding Extar Amount
								Else
									temp="$"+CSTR(CDBL(arrTax(x))+10.001)
									ExpShipChrg=Left(temp,len(temp)-1)
								End If
							Next

							If strShipChrg=ExpShipChrg then
								strDesc = "VLDSHIPPINGANDTAXES :Shipping charges for State  " & chr(34) & arrStZp(0) & chr(34) &"is : " & chr(34) & ExpShipChrg & chr(34) &" exist as expected.."
								clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1								
								Reporter.Filter = rfEnableAll 
								Reporter.ReportEvent micPass,"Step VLDSHIPPINGANDTAXES", strDesc							 
								Reporter.Filter = rfDisableAll	
							Else
								strDesc = "VLDSHIPPINGANDTAXES: Shipping charges for State  " & chr(34) & arrStZp(0) & chr(34) &"is : " & chr(34) & strShipChrg & chr(34) &" exist, Which is NOT as expected.."
								clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
								clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
								Reporter.Filter = rfEnableAll 
								Reporter.ReportEvent micFail,"Step VLDSHIPPINGANDTAXES", strDesc
								objEnvironmentVariables.TestCaseStatus=False
								Reporter.Filter = rfDisableAll
							End If
						Else
							For y=0 to UBOUND(arrChrg)
			 'For the States mentioned  Calculating Shipping Charges and verifying in the application
				   				If arrProdChrg(y)<>"" Then
									If CDBL(strSubTotal)<CDBL(arrProdChrg(y))  Then
										ExpShipChrg=arrTax(y)
									End If
								Else
									ExpShipChrg=arrTax(y)
								End If
							Next
							If strShipChrg=ExpShipChrg then
								strDesc = "VLDSHIPPINGANDTAXES :Shipping charges for State  " & chr(34) & arrStZp(0) & chr(34) &"is : " & chr(34) & ExpShipChrg & chr(34) &" exist as expected.."
								clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1								
								Reporter.Filter = rfEnableAll 
								Reporter.ReportEvent micPass,"Step VLDSHIPPINGANDTAXES", strDesc							 
								Reporter.Filter = rfDisableAll	
							Else
								strDesc = "VLDSHIPPINGANDTAXES: Shipping charges for State  " & chr(34) & arrStZp(0) & chr(34) &"is : " & chr(34) & strShipChrg & chr(34) &" exist, Which is NOT as expected.."
								clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
								clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
								Reporter.Filter = rfEnableAll 
								Reporter.ReportEvent micFail,"Step VLDSHIPPINGANDTAXES", strDesc
								objEnvironmentVariables.TestCaseStatus=False
								Reporter.Filter = rfDisableAll
							End If
						End If
			
						If arrStZp(0)="Alabama" OR arrStZp(0)="Connecticut" OR arrStZp(0)="Indiana" OR arrStZp(0)="Kentucky" OR arrStZp(0)="Nevada" OR arrStZp(0)="New York" OR arrStZp(0)="Ohio" OR arrStZp(0)="Virginia" OR arrStZp(0)="Washington" OR (ModuleName="Sperry" AND arrStZp(0)="Kansas") OR (CDBL(strSubTotal)>175 AND arrStZp(0)="Massachusetts") Then
							If strTaxChrg<>"$0.00" Then
								strDesc = "VLDSHIPPINGANDTAXES :Taxes for State  " & chr(34) & arrStZp(0) & chr(34) &"is : " & chr(34) & strTaxChrg & chr(34) &" exist as expected.."
								clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1								
								Reporter.Filter = rfEnableAll 
								Reporter.ReportEvent micPass,"Step VLDSHIPPINGANDTAXES", strDesc							 
								Reporter.Filter = rfDisableAll	
							Else
								strDesc = "VLDSHIPPINGANDTAXES: Taxes for State  " & chr(34) & arrStZp(0) & chr(34) &"is : $0.00 exist, Which is NOT as expected.."
								clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
								clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
								Reporter.Filter = rfEnableAll 
								Reporter.ReportEvent micFail,"Step VLDSHIPPINGANDTAXES", strDesc
								objEnvironmentVariables.TestCaseStatus=False
								Reporter.Filter = rfDisableAll
							End If
						Else
							If strTaxChrg="$0.00" Then
								strDesc = "VLDSHIPPINGANDTAXES :Taxes for State  " & chr(34) & arrStZp(0) & chr(34) &"is : $0.00 exist(s) as expected.."
								clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1								
								Reporter.Filter = rfEnableAll 
								Reporter.ReportEvent micPass,"Step VLDSHIPPINGANDTAXES", strDesc							 
								Reporter.Filter = rfDisableAll	
							Else
								strDesc = "VLDSHIPPINGANDTAXES: Taxes for State  " & chr(34) & arrStZp(0) & chr(34) &"is : " & chr(34) & strTaxChrg & chr(34) &" exist, Which is NOT as expected.."
								clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
								clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
								Reporter.Filter = rfEnableAll 
								Reporter.ReportEvent micFail,"Step VLDSHIPPINGANDTAXES", strDesc
								objEnvironmentVariables.TestCaseStatus=False
								Reporter.Filter = rfDisableAll
							End If
						End If
					Else
					  'Object Not Found
					End If
			Next
			Set objLnk=NOthing
	End Function
'=====================================================================================================================================================================


'========================================================================================================================================================

'********************************************************************************************************************************************************
'FUNCTION HEADER
'********************************************************************************************************************************************************
'Name: FnAddProductToBag
'Description: This function is selecf a product and to the add to bag page.
'Input: Obj, Object Name, strInputValue, strOpt_Param, strOpt_Param, clsReport, objEnvironmentVariables, clsScreenShot, iRowCnt, Screen_shot_path, strSheet_Name, strLabel, strExpectedValue, strTestDataReference
'Input : Categoty as "MEN/WOMEN/KIDS" , Test Data Ref- OPTIONAL (if you don't wan the the function to chk for the object, strOptParam - ENV:ProdName:ENV:ProdPrice
'Creation Date : 23-July-2010
'Created By: Ramgopal Narayanan (229673)
'Application: PAYLESS ECOM
'Output: Returns nothing (returns the prod name / price internally)

            Function FnAddProductToBag(ByRef objsub , ByVal Object_Name, ByVal strInputValue, ByVal strDbValue, ByVal strOptParam, ByRef clsReport, ByRef objEnvironmentVariables , ByRef clsScreenShot ,ByVal iRowCnt ,ByVal Screen_shot_path ,ByVal strSheet_Name ,ByVal strLabel , ByVal strExpectedValue , ByVal strTestDataReference, ByVal ModuleName)                                  

						isAddnLink=False
						'1.Category to be selected
						'*******************************
		
						strInputVal=Trim(strInputValue)
						If UCASE(strInputVal)="MEN" Then
										strLink="lnkMen"
						ElseIF UCASE(strInputVal)="WOMEN" Then
										strLink="lnkWomen"
						ElseIF UCASE(strInputVal)="KIDS" Then
										strLink="lnkKids"              
						ElseIF UCASE(strInputVal)="PRO" Then 'Just for the sake of Pro Keds
										strLink="lnkProKedsProducts_Main"
'Ram  Aug-2-2010 - The following 4 categories are for Grasshoppers
						'*****************************************************************************
						ElseIF UCASE(strInputVal)="ACTIVE" Then
										strLink="lnkActive"    
						ElseIF UCASE(strInputVal)="CASUALS" Then
										strLink="lnkCasuals"    
						ElseIF UCASE(strInputVal)="PUREFIT" Then
										strLink="lnkPureFit"    
						ElseIF UCASE(strInputVal)="LASTCHANCE" Then
										strLink="lnkLastChance"    
						 '*****************************************************************************
						ElseIF strInputVal="" AND ModuleName<> "Grasshoppers" Then
										'By Default clickin on Women
										strLink="lnkWomen"
						End If

		
						'2. Click on the link initially to select the category
						'********************************************************
						Browser("brwMain").Page("pgeMain").Link(strLink).Click
		
						Wait 5
		
						'3. Select the product based the application
						'**************************************************
						If ModuleName="Original" OR ModuleName="Performance" Then
										If  UCASE(strInputVal)="MEN" OR UCASE(strInputVal)="WOMEN" Then
														Browser("brwMain").Page("pgeMain").Link("lnkFootwear").Click
										ElseIf UCASE(strInputVal)="KIDS" Then
														Browser("brwMain").Page("pgeMain").Link("lnkBoys").Click
										End If
						ElseIf ModuleName="Sperry" Then
										Browser("brwMain").Page("pgeMain").Link("lnkShoes").Click
						ElseIf ModuleName="Keds" Then
										If strExpectedValue<>"" AND UCASE(TRIM(strExpectedValue))="PROKEDS" Then 'For Prokeds
														Browser("brwMain").Page("pgeMain").Link("lnkProKedsProducts_Category").Click
										Else
														Browser("brwMain").Page("pgeMain").Link("lnkProducts").Click 'if not prokeds just ordinary keds
										End If
						ElseIf ModuleName="Grasshoppers" Then
													'DO NOTHING AS GH HAS NO SUB CAT
						End If
		
						
						Wait 5
						'4'View all the prods'
						'***********************
						If  Browser("brwMain").Page("pgeProductList").Link("lnkViewAll").Exist(3) Then
										Browser("brwMain").Page("pgeProductList").Link("lnkViewAll").Click
						End If
						
						Wait 5
		
						'To click links like Highest Price and Lowest Price etc under the product list page
						If strTestDataReference<>"" Then
										lnkToClick=TRIM(strTestDataReference)
										isAddnLink=True
						End If
		
						If  isAddnLink Then
										Browser("brwMain").Page("pgeProductList").Link(lnkToClick).Click
						End If
						Wait 5
						
						
						
						'5. Get the product list
						'**************************                                          
						Set lnkObj = Description.Create()
						lnkObj("micclass").Value = "Link"
						lnkObj("html tag").Value = "A"
						strProducts=""
						Set obj=Browser("brwMain").Page("pgeProductList").WebElement("elmProductList").ChildObjects(lnkObj)
						For objCount=0 to obj.count-1
							strProdName=obj(objCount).getRoproperty("text")
							strProdHref=obj(objCount).getRoproperty("href")
							strProdProp=strProdName & "|" & strProdHref
							strProducts=strProducts & "~" & strProdProp
						Next
						
						'6.Iterate thru the products and check if it can be added
						'****************************************************************
						strProducts=RIGHT(strProducts,(LEN(strProducts)-1))
						arrProdValue=Split(strProducts,"~")
						For arrCount=0 to UBOUND(arrProdValue)
							fCount=arrCount
							arrProdProp=arrProdValue(arrCount)
							'Split the prop again
							arrIndivProp=Split(arrProdProp,"|")
		
							'A.Click on the product
							'**************************
							Set objGeneral=Browser("brwMain").Page("pgeProductList").Link("lnkProduct")
							objGeneral.SetTOProperty "text",arrIndivProp(0) 'Text Prop
							objGeneral.SetTOProperty "href",arrIndivProp(1) 'href link
							objGeneral.Click
	
							'A.1. Get the product price
							'*****************************
			
							'**** Check if no inventory found error is displayed or not, if select the next product
							If NOT(Browser("brwMain").Page("pgeAddtoBag").WebElement("elmNoInventoryAvailable").Exist(3)) Then
									strProdPrc=Browser("brwMain").Page("pgeAddtoBag").WebElement("elmPriceValue").GetROProperty("innertext")
									strTemp=Split(strProdPrc,"Reg.")
									strProdPrc=TRIM(strTemp(1))
		
									isSalePrice=False
									If  Browser("brwMain").Page("pgeAddtoBag").WebElement("elmSalePrice").Exist(3) Then
										strSalePrc=Browser("brwMain").Page("pgeAddtoBag").WebElement("elmSalePrice").GetROProperty("innertext")
										strSalePrc=TRIM(strSalePrc)
										isSalePrice=True
									End If
		
									If  isSalePrice Then
										strFinalPrice=strSalePrc
									Else
										strFinalPrice=strProdPrc               
									End If
		
									fIsProdAddedToBag="No"
		
									'*****Check if the product gets added to the bag successfully*****											   
		
									Set elmObj=Browser("brwMain").Page("pgeAddtoBag").WebElement("elmGeneral")
									elmObj.SetTOProperty "innertext",arrIndivProp(0)
									elmObj.SetTOProperty "html tag","STRONG"
					
									If   elmObj.Exist(2) Then
													fIsProdAddedToBag="Yes"
													elmObj.Highlight
									Else
													fIsProdAddedToBag="No"
									End If
'                                                                                                                               If strTestDataReference<>"OPTIONAL" Then
									If  fIsProdAddedToBag="Yes" Then
											strDesc ="ADDPRODUCTTOBAG: The product " & chr(34) & arrIndivProp(0) & chr(34) & " is selected from the product list and added to bag."
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 1
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micPass,"Step ADDPRODUCTTOBAG", strDesc
											Reporter.Filter = rfDisableAll
		
											If strOptParam<>"" Then
												arrOptParam=Split(strOptParam,":")
												If  UBOUND(arrOptParam)>0Then
													If  UCASE(TRIM(arrOptParam(0)))="ENV" Then
														Environment.Value(Trim(arrOptParam(1)) ) = arrIndivProp(0) 'PRODUCT NAME
														'Check if there's one more env value, if so set the prod price for that
														If  UBOUND(arrOptParam)>1 Then
															If UCASE(TRIM(arrOptParam(2)))="ENV" Then
																Environment.Value(Trim(arrOptParam(3)) ) = strFinalPrice 'PRODUCT PRICE (Eg: $60.00)
															End If
														End If
													End If
												End If
											End If
									Else
											strDesc ="ADDPRODUCTTOBAG: The product " & chr(34) & arrIndivProp(0) & chr(34) & " is selected from the product list and added to the bag. Cannot proceed further with the other steps."
											clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
											clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
											Reporter.Filter = rfEnableAll 
											Reporter.ReportEvent micFail,"Step ADDPRODUCTTOBAG", strDesc
											objEnvironmentVariables.TestCaseStatus=False
											Reporter.Filter = rfDisableAll
									End If'                           
								 
									If fIsProdAddedToBag="Yes" Then
										Exit For 'Exit the loop
									Else
										'Loop again for different product to see it can be added, when something went wrong and procut is not added to the bag
										Browser("brwMain").Page("pgeMain").Link(strLink).Click
										
										If ModuleName="Original" OR ModuleName="Performance" Then
														If  UCASE(strInputVal)="MEN" OR UCASE(strInputVal)="WOMEN" Then
																		Browser("brwMain").Page("pgeMain").Link("lnkFootwear").Click
														ElseIf UCASE(strInputVal)="KIDS" Then
																		Browser("brwMain").Page("pgeMain").Link("lnkBoys").Click
														End If
										ElseIf ModuleName="Sperry" Then
														Browser("brwMain").Page("pgeMain").Link("lnkShoes").Click
										ElseIf ModuleName="Keds" Then
														If strExpectedValue<>"" AND UCASE(TRIM(strExpectedValue))="PROKEDS" Then 'For Prokeds
																		Browser("brwMain").Page("pgeMain").Link("lnkProKedsProducts_Category").Click
														Else
																		Browser("brwMain").Page("pgeMain").Link("lnkProducts").Click 'if not prokeds just ordinary keds
														End If
										ElseIf ModuleName="Grasshoppers" Then
													'DO NOTHING AS GH HAS NO SUB CAT
										End If
		
										If  isAddnLink Then
														Browser("brwMain").Page("pgeProductList").Link(lnkToClick).Click
										End If
									End If    
								Else
								   'Loop again for different product to see it can be added, when no inventory is found
									Browser("brwMain").Page("pgeMain").Link(strLink).Click
									
									If ModuleName="Original" OR ModuleName="Performance" Then
													If  UCASE(strInputVal)="MEN" OR UCASE(strInputVal)="WOMEN" Then
																	Browser("brwMain").Page("pgeMain").Link("lnkFootwear").Click
													ElseIf UCASE(strInputVal)="KIDS" Then
																	Browser("brwMain").Page("pgeMain").Link("lnkBoys").Click
													End If
									ElseIf ModuleName="Sperry" Then
													Browser("brwMain").Page("pgeMain").Link("lnkShoes").Click
									ElseIf ModuleName="Keds" Then
													If strExpectedValue<>"" AND UCASE(TRIM(strExpectedValue))="PROKEDS" Then 'For Prokeds
																	Browser("brwMain").Page("pgeMain").Link("lnkProKedsProducts_Category").Click
													Else
																	Browser("brwMain").Page("pgeMain").Link("lnkProducts").Click 'if not prokeds just ordinary keds
													End If
									ElseIf ModuleName="Grasshoppers" Then
													'DO NOTHING AS GH HAS NO SUB CAT
									End If
		
									If  isAddnLink Then
													Browser("brwMain").Page("pgeProductList").Link(lnkToClick).Click
									End If    
						End If                                                    
						Next 'End of Product for loop
						
						If  fCount=UBOUND(arrProdValue) Then
										strDesc ="ADDPRODUCTTOBAG: Cannot proceed further, since there are no products exists with a quantity of atleast 1"
										clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables
										clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
										Reporter.Filter = rfEnableAll 
										Reporter.ReportEvent micFail,"Step ADDPRODUCTTOBAG", strDesc
										objEnvironmentVariables.TestCaseStatus=False
										Reporter.Filter = rfDisableAll
						End If                                     

           End Function

'========================================================================================================================================================
'********************************************************************************************************************************************************
'FUNCTION HEADER
'********************************************************************************************************************************************************
'Name: FnCheckProductLink
'Description: After adding a product in to the shopping bag, will check the product detailes page by clicking on productlink
'Creation Date : 22-July-2010
'Created By: Fayis K
'Application: PAYLESS ECOM
'Output: Returns nothing 
'Input  Nothing

Function FnCheckProductLink (ByRef objsub , ByVal Object_Name, ByVal strInputValue, ByVal strDbValue, ByVal strOptParam, ByRef clsReport, ByRef objEnvironmentVariables ,	ByRef clsScreenShot ,ByVal iRowCnt ,ByVal Screen_shot_path ,ByVal strSheet_Name ,ByVal strLabel , ByVal strExpectedValue , ByVal strTestDataReference, ByVal ModuleName) 	


						Set objLnk = objsub.Link("lnkGeneral") 
						If  strInputValue<>"" Then
								arrValue=Split(TRIM(strInputValue),":")
								If UCASE(TRIM(arrValue(0)))="ENV" Then
									strProdName=Environment.Value( Trim(arrValue(1) ))
									objLnk.SetTOProperty "text",Trim(strProdName)
									If UBOUND(arrValue)>1 Then
											If  UCASE(TRIM(arrValue(2)))="INDEX" Then
													objLnk.SetTOProperty "Index",Trim(arrValue(3))
											End If											
									End If
								Else
										strProdName = strInputValue
								End If
						End If

						'If the prod has a qtty > 1 then the product will appear as a link and clickin on will end up in the prod details page,
						If objLnk.Exist(3) Then 
								objLnk.Highlight
								objLnk.Click
								Browser("brwMain").Sync
	
								Set elmObj=objsub.WebElement("elmGeneral")
								elmObj.SetTOProperty "innertext",  strProdName
								elmObj.SetTOProperty "html tag", "STRONG"
	
								If  elmObj.Exist(3) Then
										'Check if the user had been taken to the product details page, by  verifyig the prod name
									elmObj.Highlight
									strDesc = "CHECKPRODLINK: Product details page for the product " & chr(34) & strProdName & chr(34) &  " is displayed successfully, as expected."
									Reporter.Filter = rfEnableAll
									Reporter.ReportEvent micdone,"Step CHECKPRODLINK ", strDesc
									Reporter.Filter = rfDisableAll 
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2
								Else
									strDesc = strpartdesc &" at the row number "&iRowCnt+1&" ,for the product " & chr(34) & strProdName & chr(34) &  " IS NOT displayed, as expected."
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micFail,"Step CHECKPRODLINK ", strDesc
									objEnvironmentVariables.TestCaseStatus=False 
									Reporter.Filter = rfDisableAll
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables				   	
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
								End If	
						Else
								'If the prod has a qtty <1  then the product will appear as a text and clickin on will not end up in the prod details page,
								strDesc = "CHECKPRODLINK: The product " & chr(34) & strProdName & chr(34) &  " is not displayed as a link because the quantity is less than 1."
								Reporter.Filter = rfEnableAll
								Reporter.ReportEvent micdone,"Step CHECKPRODLINK ", strDesc
								Reporter.Filter = rfDisableAll 
								clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2								
							End if  
							Set objLnk=Nothing
							Set elmObj=Nothing
					End Function
''========================================================================================================================================================================				
'********************************************************************************************************************************************************
'FUNCTION HEADER
'********************************************************************************************************************************************************
'Name: FnCheckProductImage
'Description: After adding a product in to the shopping bag, the function will check if the user is taken to the product detailes page by clicking on product thumbnail, if it's displayed as an image link
'Creation Date : 22-July-2010
'Created By: Fayis K
'Application: PAYLESS ECOM
'Output: Returns nothing 
' Input  Nothing

Function FnCheckProductImage (ByRef objsub , ByVal Object_Name, ByVal strInputValue, ByVal strDbValue, ByVal strOptParam, ByRef clsReport, ByRef objEnvironmentVariables ,	ByRef clsScreenShot ,ByVal iRowCnt ,ByVal Screen_shot_path ,ByVal strSheet_Name ,ByVal strLabel , ByVal strExpectedValue , ByVal strTestDataReference, ByVal ModuleName) 	

						Set objImg = objsub.Image("imgGeneral_Link") 
						If  strInputValue<>"" Then
								arrValue=Split(TRIM(strInputValue),":")
								If UCASE(TRIM(arrValue(0)))="ENV" Then
										strImgName=Environment.Value( Trim(arrValue(1) ))
										objImg.SetTOProperty "alt",Trim(strImgName)
										If UBOUND(arrValue)>1 Then
												If  UCASE(TRIM(arrValue(2)))="INDEX" Then
														objImg.SetTOProperty "Index",Trim(arrValue(3))
												End If											
										End If
								Else
										strImgName = strInputValue
								End If
						End If

						'If the prod has a qtty > 1 then the product will appear as a link and clickin on will end up in the prod details page,
						If objImg.Exist(3) Then
								objImg.Highlight
								objImg.Click
								'Check if the user had been taken to the product details page, by  verifyig the prod name
								Set elmObj=objsub.WebElement("elmGeneral")
								elmObj.SetTOProperty "innertext",  strImgName
								elmObj.SetTOProperty "html tag", "STRONG"
	
								If  elmObj.Exist(3) Then
									elmObj.Highlight
									strDesc = "CHECKPRODIMAGE: Product details page for the product " & chr(34) & strImgName & chr(34) &  " is displayed successfully when clicking on the product image, as expected."
									Reporter.Filter = rfEnableAll
									Reporter.ReportEvent micdone,"Step CHECKPRODIMAGE ", strDesc
									Reporter.Filter = rfDisableAll 
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2
								Else
									strDesc =strpartdesc &" at the row number "&iRowCnt+1&" ,for the product " & chr(34) & strImgName & chr(34) &  " IS NOT displayed, as expected."
									Reporter.Filter = rfEnableAll 
									Reporter.ReportEvent micFail,"Step CHECKPRODIMAGE ", strDesc
									objEnvironmentVariables.TestCaseStatus=False 
									Reporter.Filter = rfDisableAll
									clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables				   	
									clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
								End If	
						Else
								'If the prod has a qtty <1  then the product will appear as an non-link image and clickin on will not end up in the prod details page,
								strDesc = "CHECKPRODIMAGE: The product " & chr(34) & strImgName & chr(34) &  " is not displayed as an Image Link because the quantity is less than 1. So cannot click on it."
								Reporter.Filter = rfEnableAll
								Reporter.ReportEvent micdone,"Step CHECKPRODIMAGE ", strDesc
								Reporter.Filter = rfDisableAll 
								clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2						
						End if  
							Set objLnk=Nothing
							Set objImg=Nothing

					End Function
'============================================================================================================================================================
'********************************************************************************************************************************************************
'FUNCTION HEADER
'********************************************************************************************************************************************************
'Name: FnVerifyMediaSlotInRegConfPage
'Description: Checks for the media slots under the registration confirmation page
'Creation Date : 3-Aug-2010
'Created By: Ramgopal Narayanan
'Application: PAYLESS ECOM
'Output: Returns nothing 
' Input  Nothing

Function FnVerifyMediaSlotInRegConfPage(ByRef objsub , ByVal Object_Name, ByVal strInputValue, ByVal strDbValue, ByVal strOptParam, ByRef clsReport, ByRef objEnvironmentVariables ,	ByRef clsScreenShot ,ByVal iRowCnt ,ByVal Screen_shot_path ,ByVal strSheet_Name ,ByVal strLabel , ByVal strExpectedValue , ByVal strTestDataReference, ByVal ModuleName) 	

			Set obj=Browser("brwMain").Page("pgeAccountRegistration")
			Set imgObj=obj.Image("imgMediaSlot")
			blnMedia1=False
			blnMedia2=False
			strMediaSlotValue1=""
			
			'1. Check if the two media slots are available under the conf reg page
			'Check for media slot 1
			imgObj.SetTOProperty "index","0"
			strMediaSlotValue1=imgObj.GetROProperty("alt")
			If  imgObj.Exist(2) Then
					imgObj.Highlight
					strDesc = "VERIFYREGCONFPGMEDIASLOT: The media slot 1 " & chr(34) & strMediaSlotValue1 & chr(34) & " is displayed as expected."
					Reporter.Filter = rfEnableAll
					Reporter.ReportEvent micdone,"Step VERIFYREGCONFPGMEDIASLOT ", strDesc
					Reporter.Filter = rfDisableAll 
					clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2
					blnMedia1=True
					'
					'Check if, the media slots1 are functional and clickiing on them leads the user to the appropriate page
					imgObj.Click
					Browser("brwMain").Sync
					If obj.WebElement("elmCategoryTitle").Exist(2) Then
						strCategoryValue=obj.WebElement("elmCategoryTitle").GetROProperty("innertext")
						arrTemp=Split(strCategoryValue," ")
						If UBOUND(arrTemp)>0 Then
							strCategoryValue1=TRIM(arrTemp(0))
						Else
							strCategoryValue1=TRIM(strCategoryValue)
						End If
				
						If INSTR(strMediaSlotValue1,strCategoryValue1)>0 Then
							obj.WebElement("elmCategoryTitle").Highlight
							strDesc = "VERIFYREGPAGEMEDIASLOT: Clicking on media slot 1" & strMediaSlotValue1 &", the user is directed to the correct category page of " & strCategoryValue & "."
							Reporter.Filter = rfEnableAll
							Reporter.ReportEvent micdone,"Step VERIFYREGPAGEMEDIASLOT ", strDesc
							Reporter.Filter = rfDisableAll 
							clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2
						Else
							strDesc =strpartdesc &" at the row number "&iRowCnt+1&" ,clicking on media slot 1" & strMediaSlotValue1 &", the user is not directed to the correct category page. Actual category displayed is " &  strCategoryValue & "."
							Reporter.Filter = rfEnableAll 
							Reporter.ReportEvent micFail,"Step VERIFYREGCONFPGMEDIASLOT ", strDesc
							objEnvironmentVariables.TestCaseStatus=False 
							Reporter.Filter = rfDisableAll
							clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables				   	
							clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
						End If
					Else
						strDesc =strpartdesc &" at the row number "&iRowCnt+1&" ,the category title for the media slot " & strMediaSlotValue1 & " does not exist, so cannot proceed with the verification."
						Reporter.Filter = rfEnableAll 
						Reporter.ReportEvent micFail,"Step VERIFYREGCONFPGMEDIASLOT ", strDesc
						objEnvironmentVariables.TestCaseStatus=False 
						Reporter.Filter = rfDisableAll
						clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables				   	
						clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
					End If
					Browser("brwMain").Back
					Wait 2
					Browser("brwMain").Sync
			Else
					strDesc =strpartdesc &" at the row number "&iRowCnt+1&" ,the media slot 1 is not displayed as expected,"
					Reporter.Filter = rfEnableAll 
					Reporter.ReportEvent micFail,"Step VERIFYREGCONFPGMEDIASLOT ", strDesc
					objEnvironmentVariables.TestCaseStatus=False 
					Reporter.Filter = rfDisableAll
					clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables				   	
					clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
			End If
			
			'2. Check for the 2nd media slot
			strMediaSlotValue2=""
			imgObj.SetTOProperty "index","1"
			strMediaSlotValue2=imgObj.GetROProperty("alt")
			If  imgObj.Exist(2) Then
					imgObj.Highlight
					strDesc = "VERIFYREGPAGEMEDIASLOT: The media slot 2 " & chr(34) & strMediaSlotValue2 & chr(34) & " is displayed as expected."
					Reporter.Filter = rfEnableAll
					Reporter.ReportEvent micdone,"Step VERIFYREGPAGEMEDIASLOT ", strDesc
					Reporter.Filter = rfDisableAll 
					clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2
					blnMedia2=True
			
					'Check if, the media slots1 are functional and clickiing on them leads the user to the appropriate page
					imgObj.SetTOProperty "index","1"
					imgObj.Click
					Browser("brwMain").Sync
					If obj.WebElement("elmCategoryTitle").Exist(2) Then
						strCategoryValue=obj.WebElement("elmCategoryTitle").GetROProperty("innertext")
						arrTemp=Split(strCategoryValue," ")
						If UBOUND(arrTemp)>0 Then
							strCategoryValue2=TRIM(arrTemp(0))
						Else
							strCategoryValue2=TRIM(strCategoryValue)
						End If
				
						If INSTR(strMediaSlotValue2,strCategoryValue2)>0 Then
							obj.WebElement("elmCategoryTitle").Highlight
							strDesc = "VERIFYREGPAGEMEDIASLOT: Clicking on media slot 2" & strMediaSlotValue2 &", the user is directed to the correct category page of " & strCategoryValue & "."
							Reporter.Filter = rfEnableAll
							Reporter.ReportEvent micdone,"Step VERIFYREGPAGEMEDIASLOT ", strDesc
							Reporter.Filter = rfDisableAll 
							clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 2
						Else
							strDesc =strpartdesc &" at the row number "&iRowCnt+1&" ,clicking on media slot 1" & strMediaSlotValue2 &", the user is not directed to the correct category page. Actual category displayed is " &  strCategoryValue & "."
							Reporter.Filter = rfEnableAll 
							Reporter.ReportEvent micFail,"Step VERIFYREGCONFPGMEDIASLOT ", strDesc
							objEnvironmentVariables.TestCaseStatus=False 
							Reporter.Filter = rfDisableAll
							clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables				   	
							clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
						End If
					Else
						strDesc =strpartdesc &" at the row number "&iRowCnt+1&" ,the category title for the media slot " & strMediaSlotValue2 & " does not exist, so cannot proceed with the verification."
						Reporter.Filter = rfEnableAll 
						Reporter.ReportEvent micFail,"Step VERIFYREGCONFPGMEDIASLOT ", strDesc
						objEnvironmentVariables.TestCaseStatus=False 
						Reporter.Filter = rfDisableAll
						clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables				   	
						clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
					End If
					Browser("brwMain").Back
					Wait 2
					Browser("brwMain").Sync
			
			Else
					strDesc =strpartdesc &" at the row number "&iRowCnt+1&" ,the media slot 1 is not displayed as expected,"
					Reporter.Filter = rfEnableAll 
					Reporter.ReportEvent micFail,"Step VERIFYREGCONFPGMEDIASLOT ", strDesc
					objEnvironmentVariables.TestCaseStatus=False 
					Reporter.Filter = rfDisableAll
					clsScreenShot.Snap_Shots objsub ,  Screen_shot_path,strSheet_Name&"_"&iRowCnt+1&strLabel,objEnvironmentVariables				   	
					clsReport.WriteHTMLResultLog objEnvironmentVariables, strDesc, 0
			End If
			Set obj=Nothing
			Set imgObj=Nothing
	End Function
'===========================================================================================================================================================
End Class
