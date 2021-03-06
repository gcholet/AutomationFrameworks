Class Database_Module

	Public Connect_DB, DB_Record


	Function Connect_Database (strControlPath,strProjectName)
		Set Connect_DB = CreateObject("ADODB.Connection")		
		Connect_DB.connectionstring = "PROVIDER=MSDASQL;DRIVER={Microsoft Excel Driver (*.xls)};DBQ=" & strControlPath & "Business_Scripts\TestCase_Scripts\"& strProjectName & "\Test_Data\" & strProjectName & "_TestData.xls;ReadOnly=False"
		Connect_DB.Open		
	End Function


	Function Fetch_Value ( Query , Column_Name )
		
		set DB_Record=Connect_DB.Execute ( Query )
				
		If DB_Record.EOF then		
			Fetch_Value=""					
		ElseIf Column_Name ="" Then 			
			set Fetch_Value=DB_Record
		ElseIf IsNUll(DB_Record.fields(Column_Name).Value) then
			Fetch_Value=""
		Else
			Fetch_Value=DB_Record.fields(Column_Name).Value
		End If
	
	End Function



	Function Update_Value (Query)								
		On Error Resume Next			
		Connect_DB.Execute (Query)					
		If Err.Number <> 0 then
			Update_Value = False                            
		Else
			Update_Value = True                  
		End If
	End Function


	Function Close_Database	
		Set DB_Record=Nothing
		Set Connect_DB=Nothing
	End Function	


	Function Value_From_DataBase(  strInputValue , strOpt_param )

		 	''Issue in 8441 
		   'str_ServerName =  Replace( Environment("LocalHostName") , "RGS1", "RGS0") ''Refering POS database  "e.g. RGS1008449"           		   				

			str_ServerName =  Environment("LocalHostName") ''Refering POS database  "e.g. RGS1008449"  
			str_DatabaseName ="GlobalStore"			
			Query = strInputValue 
	
			Set mConnection = CreateObject("ADODB.Connection")
			mConnection.Open "Provider=SQLOLEDB.1 ; Data Source="& str_ServerName &";  Initial Catalog=" & str_DatabaseName ,  "sa" , ""
			
			Set mRecordset = CreateObject("ADODB.Recordset")
			mRecordset =  mConnection.Execute( Query )			
			newvalue =  mRecordset(0) 			
			Set mConnection = Nothing
			Set mRecordset = Nothing
			Value_From_DataBase = newvalue  ''return the first value             
	End Function


		Function Value_From_BODataBase(  strInputValue , strOpt_param )
			str_ServerName =  Environment("LocalHostName") ''Refering POS database  "e.g. RGS1008449"      
			str_DatabaseName ="GlobalStore"			
			Query = "select str_id  from Register"

			' For POS
			Set mConnection = CreateObject("ADODB.Connection")
			mConnection.Open "Provider=SQLOLEDB.1 ; Data Source="& str_ServerName &";  Initial Catalog=" & str_DatabaseName ,  "sa" , ""
			Set mRecordset = CreateObject("ADODB.Recordset")
			mRecordset =  mConnection.Execute( Query )			
			newvalue =  mRecordset(0) 			
			Set mConnection = Nothing
			Set mRecordset = Nothing

			' For BO
			Query1 = strInputValue
			str_BOServerName = "RGS000"&newvalue
			
			Set BOConnection = CreateObject("ADODB.Connection")
			BOConnection.Open "Provider=SQLOLEDB.1 ; Data Source="& str_BOServerName &";  Initial Catalog=" & str_DatabaseName ,  "sa" , ""
			
			Set BORecordset = CreateObject("ADODB.Recordset")
			BORecordset =  BOConnection.Execute( Query1 )			
			BOnewvalue =  BORecordset(0) 			
			Set BOConnection = Nothing
			Set BORecordset = Nothing
			Value_From_BODataBase = BOnewvalue  ''return the first value 			
	End Function



	Function Update_Value_In_BODataBase(strInputValue)

	   	    On Error Resume Next
	
			str_ServerName =  Environment("LocalHostName") ''Refering POS database  "e.g. RGS1008449"      
			str_DatabaseName ="GlobalStore"			
			Query = "select str_id  from Register"

			' For POS
			Set mConnection = CreateObject("ADODB.Connection")
			mConnection.Open "Provider=SQLOLEDB.1 ; Data Source="& str_ServerName &";  Initial Catalog=" & str_DatabaseName ,  "sa" , ""
			Set mRecordset = CreateObject("ADODB.Recordset")
			mRecordset =  mConnection.Execute( Query )			
			newvalue =  mRecordset(0) 			
			Set mConnection = Nothing
			Set mRecordset = Nothing

			' For BO
			Query1 = strInputValue
            Set BOConnection = CreateObject("ADODB.Connection")
			str_BOServerName = "RGS000"&newvalue
			BOConnection.Open "Provider=SQLOLEDB.1 ; Data Source="& str_BOServerName &";  Initial Catalog=" & str_DatabaseName ,  "sa" , ""			
			BOConnection.Execute( Query1 )			
			
    		If Err.Number <> 0 then
				Update_Value_In_BODataBase = FALSE
			else
				 Update_Value_In_BODataBase = TRUE                        
             End If
			Set BOConnection = Nothing
	End Function

End Class
