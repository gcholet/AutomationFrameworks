Dim gstrDBConnState, gstrDBConnProperty, garrResults()

Sub ConnectToDatabase()
	'Connecting to the Database
	''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'CRAFT_ConnectDatabase(strConName,strDSNName,strServerName,strDataBaseName,strUserID,strPassword)
	arrDBConnItems = CRAFT_ConnectDatabase("Sample DB Connection","TestDSN","Server1","DB1","test","demo")
	gstrDBConnState = arrDBConnItems(0)
	gstrDBConnProperty = arrDBConnItems(1)
End Sub

Sub ExecuteQuery()
	strQuery = CRAFT_GetData("DB_Data","Query")

	'Executing SQL Query
	''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	'CRAFT_ExecuteSQLQuery(DBConnectionState,DBConnectionProperty,Query)
	arrResults = CRAFT_ExecuteSQLQuery(gstrDBConnState,gstrDBConnProperty,strQuery)
	
	'Copying Query Results to Global Array
	For intarrIndx = 0 To UBound(arrResults)
		ReDim Preserve garrResults(intarrIndx)
		garrResults(intarrIndx) = arrResults(intarrIndx)
	Next
End Sub

Sub DisplayQueryResults()
	Print "Following are the Query Results...." & VBCRLF

	For intarrIndx = 0 To UBound(garrResults)
		Print garrResults(intarrIndx) & VBCRLF
	Next
End Sub
