Imports System.IO
Imports System.Text.RegularExpressions
Imports _15_Visual_Basic.Program

Module Program
    Class Point
        Public Property X As Integer
        Public Property Y As Integer

        Public Overrides Function Equals(obj As Object) As Boolean
            Dim otherMyObject As Point = DirectCast(obj, Point)
            Return X = otherMyObject.X AndAlso Y = otherMyObject.Y
        End Function

        Public Overrides Function GetHashCode() As Integer
            Return X Xor Y
        End Function
    End Class

    Class Sensor
        Inherits Point
        Public Property Range As New HashSet(Of Point)
    End Class

    Sub Main()
        ' Test
        'Dim row = 10
        ' Part one
        Dim row = 2000000

        Dim minRadius = Integer.MaxValue

        Dim sensorsBeacons = New Dictionary(Of Sensor, Point)

        For Each line As String In File.ReadLines("input.txt")
            Dim numbersAsString = Regex.Replace(line, "[^-\d]+", "x")
            Dim numbers = numbersAsString.Split("x", StringSplitOptions.RemoveEmptyEntries)

            Dim sensor As New Sensor
            With sensor
                .X = Integer.Parse(numbers(0))
                .Y = Integer.Parse(numbers(1))
            End With

            Dim beacon As New Point
            With beacon
                .X = Integer.Parse(numbers(2))
                .Y = Integer.Parse(numbers(3))
            End With

            Dim radius = Math.Abs(sensor.X - beacon.X) + Math.Abs(sensor.Y - beacon.Y)
            If radius < minRadius Then
                minRadius = radius
            End If
            For x = sensor.X - radius To sensor.X + radius
                If Math.Abs(sensor.X - x) + Math.Abs(sensor.Y - row) <= radius Then
                    Dim range As New Point
                    With range
                        .X = x
                        .Y = row
                    End With
                    If beacon IsNot range Then
                        sensor.Range.Add(range)
                    End If
                End If
            Next

            sensorsBeacons.Add(sensor, beacon)
        Next

        Dim result As New HashSet(Of Point)

        For Each sb In sensorsBeacons
            Dim sensor = sb.Key
            For Each r In sensor.Range
                If r.Y = row AndAlso Not sensorsBeacons.ContainsValue(r) Then
                    result.Add(r)
                End If
            Next
        Next

        Console.WriteLine(result.Count)
        Console.WriteLine(minRadius)

        ' Part two

        ' Test
        Dim max = 20
        ' Part two
        'Dim max = 4000000      

        Dim matrix(max, max) As Boolean
        matrix(0, 0) = 1
    End Sub
End Module
