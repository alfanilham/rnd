Add-Type -AssemblyName System.Windows.Forms

$form = New-Object System.Windows.Forms.Form
$form.Text = "Boxphone Uploader v0.1"
$form.Size = New-Object System.Drawing.Size(420,220)
$form.StartPosition = "CenterScreen"

$label = New-Object System.Windows.Forms.Label
$label.Text = "Pilih file yang akan diupload:"
$label.AutoSize = $true
$label.Location = New-Object System.Drawing.Point(10,20)
$form.Controls.Add($label)

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Size = New-Object System.Drawing.Size(280,35)
$textBox.Location = New-Object System.Drawing.Point(10,50)
$form.Controls.Add($textBox)

$browseButton = New-Object System.Windows.Forms.Button
$browseButton.Text = "Pilih File"
$browseButton.Size = New-Object System.Drawing.Size(90,30)
$browseButton.Location = New-Object System.Drawing.Point(300,47)
$browseButton.Add_Click({
    $fileDialog = New-Object System.Windows.Forms.OpenFileDialog
    if ($fileDialog.ShowDialog() -eq "OK") {
        $textBox.Text = $fileDialog.FileName
    }
})
$form.Controls.Add($browseButton)

$uploadButton = New-Object System.Windows.Forms.Button
$uploadButton.Text = "⬆ Upload"
$uploadButton.Size = New-Object System.Drawing.Size(180,30)
$uploadButton.Location = New-Object System.Drawing.Point(10,100)
$uploadButton.Add_Click({
    $file = $textBox.Text
    if (-Not (Test-Path $file)) {
        [System.Windows.Forms.MessageBox]::Show("File not found!","Error","OK","Error")
        return
    }

    $fileName = [System.IO.Path]::GetFileName($file)
    $devices = adb devices | Select-String "device$" | ForEach-Object {
        ($_ -split "`t")[0]
    }

    foreach ($device in $devices) {
        adb -s $device push "$file" "/sdcard/Download/" | Out-Null
        adb -s $device shell am broadcast -a android.intent.action.MEDIA_SCANNER_SCAN_FILE -d "file:///sdcard/Download/$fileName" | Out-Null
    }

    [System.Windows.Forms.MessageBox]::Show("Upload complete.","Done","OK","Information")
})
$form.Controls.Add($uploadButton)

$footer = New-Object System.Windows.Forms.Label
$footer.Text = "Created by Analyst Team"
$footer.AutoSize = $true
$footer.ForeColor = 'Gray'
$footer.Location = New-Object System.Drawing.Point(250, 160)
$form.Controls.Add($footer)

$form.Topmost = $true
$form.Add_Shown({ $form.Activate() })
[void]$form.ShowDialog()
