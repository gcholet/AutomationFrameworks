Dim App 'As Application
Set App = CreateObject("QuickTest.Application")
'App.Launch
'App.Visible = True
'App.Test.Settings.Launchers("Java").Active = True
'App.Test.Settings.Launchers("Java").CommandLine = ""
'App.Test.Settings.Launchers("Java").WorkingDirectory = ""
'App.Test.Settings.Launchers("Web").Active = False
'App.Test.Settings.Launchers("Web").Browser = "IE"
'App.Test.Settings.Launchers("Web").Address = "http://newtours.mercury.com "
'App.Test.Settings.Launchers("Web").CloseOnExit = True
App.Test.Settings.Launchers("Windows Applications").Active = False
App.Test.Settings.Launchers("Windows Applications").Applications.RemoveAll
App.Test.Settings.Launchers("Windows Applications").RecordOnQTDescendants = True
App.Test.Settings.Launchers("Windows Applications").RecordOnExplorerDescendants = False
App.Test.Settings.Launchers("Windows Applications").RecordOnSpecifiedApplications = True
App.Test.Settings.Run.IterationMode = "rngAll"
App.Test.Settings.Run.StartIteration = 1
App.Test.Settings.Run.EndIteration = 1
App.Test.Settings.Run.ObjectSyncTimeOut = 5000
App.Test.Settings.Run.DisableSmartIdentification = False
App.Test.Settings.Run.OnError = "Dialog"
App.Test.Settings.Resources.DataTablePath = "<Default>"