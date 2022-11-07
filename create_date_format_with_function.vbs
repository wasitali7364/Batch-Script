Function myDateFormat(myDate)
    d = TwoDigits(Day(myDate))
    m = TwoDigits(Month(myDate))    
    y = Year(myDate)
    myDateFormat= m & "-" & d & "-" & y
End Function

Function TwoDigits(num)
    If(Len(num)=1) Then
        TwoDigits="0"&num
    Else
        TwoDigits=num
    End If
End Function

msgbox("Apple Workbook - " & myDateFormat(now))