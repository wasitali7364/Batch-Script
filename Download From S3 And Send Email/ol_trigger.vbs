Dim folderName
Dim csv_file_path
Dim pay_date

'Create an instance of Excel
  Set ExcelApp = CreateObject("Excel.Application")

'Do you want this Excel instance to be visible?
  ExcelApp.Visible = False 'or "True"

'Prevent any App Launch Alerts (ie Update External Links)
  ExcelApp.DisplayAlerts = False

'Create File System Object
  Set objFSO = CreateObject("Scripting.FileSystemObject")
  GetCurrentFolder = objFSO.GetAbsolutePathName(".")
  folderName = GetCurrentFolder & "\Files"

'Use For Each loop to loop through each file in the folder
  For Each objFile In objFSO.GetFolder(folderName).Files
      if instr(objFile.Name,"merged_award") then
        csv_file_path = objFile.Path
        'Open Excel File
          Set wb = ExcelApp.Workbooks.Open(csv_file_path)
        'extract pay_date value
          pay_date = wb.Worksheets(1).Range("I2").value
        'Reset Display Alerts Before Closing
          ExcelApp.DisplayAlerts = True
        'Close Excel File
          wb.Close
      end if
  Next

'End instance of Excel
  ExcelApp.Application.Quit

'Create an instance of Outlook
  Set objOutlook = CreateObject("Outlook.Application")
  Set objMail = objOutlook.CreateItem(0)

'Create Email Content
  objMail.To = "wasit.ali@c2fo.com"
  objMail.Subject = "TEST-subject - Pay Date: " & pay_date
  objMail.Body = "Some Email body....."

  For Each objFile In objFSO.GetFolder(folderName).Files
    objMail.Attachments.Add(objFile.Path)
  Next

  objMail.Send

'End instance of Outlook
' objOutlook.Application.Quit


'set instances to Nothing
  Set objMail = Nothing
  Set objOutlook = Nothing
  Set objFSO = Nothing
'set instance of Excel to Nothing
  Set ExcelApp = Nothing


'Leaves an onscreen message!
' MsgBox "Your Automated Task successfully ran at " & TimeValue(Now), vbInformation