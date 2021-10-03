
#-------------------------------------------------------------#
#----Initial Declarations-------------------------------------#
#-------------------------------------------------------------#

Add-Type -AssemblyName PresentationCore, PresentationFramework

$Xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" Width="800" Height="400">
<Grid Margin="15,0,113,51">
<Button Content="New User" HorizontalAlignment="Left" VerticalAlignment="Top" Width="171" Margin="150,93,0,0" Height="52"/>
<Button Content="New Contact" HorizontalAlignment="Left" VerticalAlignment="Top" Width="171" Margin="362,93,0,0" Height="52"/>
<Button Content="Edit User" HorizontalAlignment="Left" VerticalAlignment="Top" Width="171" Margin="363,155,0,0" Height="52"/>
<Button Content="List User" HorizontalAlignment="Left" VerticalAlignment="Top" Width="171" Margin="149,155,0,0" Height="52"/>
<Button Content="Disable User" HorizontalAlignment="Left" VerticalAlignment="Top" Width="171" Margin="148,217,0,0" Height="52"/>
<Button Content="Delete User" HorizontalAlignment="Left" VerticalAlignment="Top" Width="171" Margin="363,217,0,0" Height="52"/>
<TextBlock HorizontalAlignment="Left" VerticalAlignment="Top" TextWrapping="Wrap" Text="Monarch Selection" Margin="258,27,0,0" Width="171" Height="50" FontFamily="Calibri" FontSize="20"/>
<Image HorizontalAlignment="Left" Height="100" VerticalAlignment="Top" Width="100" Margin="15.671875,13.984375,0,0"/>
</Grid>
</Window>
"@

#-------------------------------------------------------------#
#----Control Event Handlers-----------------------------------#
#-------------------------------------------------------------#


#Write your code here
#endregion

#-------------------------------------------------------------#
#----Script Execution-----------------------------------------#
#-------------------------------------------------------------#

$Window = [Windows.Markup.XamlReader]::Parse($Xaml)

[xml]$xml = $Xaml

$xml.SelectNodes("//*[@Name]") | ForEach-Object { Set-Variable -Name $_.Name -Value $Window.FindName($_.Name) }



$Window.ShowDialog()


