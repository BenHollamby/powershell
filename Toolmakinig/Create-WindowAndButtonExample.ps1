$form = New-Object System.Windows.Window

$form.Title ="What up WPF"
$form.Height = 200
$form.Width = 300

$button = New-Object System.Windows.Controls.Button
$button.Content = "OK"
$button.Width = 65
$button.HorizontalAlignment = "Center"
$button.VerticalAlignment = "Center"

$button.Add_click({
    $msg = "Hello, World and $env:Username!"
    Write-Host $msg -ForegroundColor Green
})

$form.AddChild($button)


($form.ShowDialog())