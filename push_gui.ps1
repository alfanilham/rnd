Add-Type -AssemblyName System.Windows.Forms

# Create form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Boxphone Uploader"
$form.Size = New-Object System.Drawing.Size(400,200)
$form.StartPosition = "CenterScreen"

# Label
$label = New-Object System.Windows.Forms.Label
$label.Text = "Pilih file yang akan diupload:"
$label.AutoSize = $true
$label.Location = New-Object System.Drawing.Point(10,20)
$form.Controls.Add($label)

# TextBox
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Size = New-Object System.Drawing.Size(250,20)
$textBox.Location = New-Object System.Drawing.Point(10,50)
$form.Controls.Add($textBox)

# Browse Button
$browseButton = New-Object System.Windows.Forms.Button
$browseButton.Text = "Pilih file"
$browseButton.Location = New-Object System.Drawing.Point(270,47)
$browseButton.Add_Click({
    $fileDialog = New-Object System.Windows.Forms.OpenFileDialog
    if ($fileDialog.ShowDialog() -eq "OK") {
        $textBox.Text = $fileDialog.FileName
    }
})
$form.Controls.Add($browseButton)

# Upload Button
$uploadButton = New-Object System.Windows.Forms.Button
$uploadButton.Text = "Upload ke Devices"
$uploadButton.Location = New-Object System.Drawing.Point(10,90)
$uploadButton.Add_Click({
    $file = $textBox.Text
    if (-Not (Test-Path $file)) {
        [System.Windows.Forms.MessageBox]::Show("File tidak ada!","Error","OK","Error")
        return
    }

    $fileName = [System.IO.Path]::GetFileName($file)
    $devices = adb devices | Select-String "device$" | ForEach-Object {
        ($_ -split "`t")[0]
    }

    foreach ($device in $devices) {
        Write-Host "Pushing $fileName to $device..."
        adb -s $device push "$file" "/sdcard/Download/" | Out-Null
        adb -s $device shell am broadcast -a android.intent.action.MEDIA_SCANNER_SCAN_FILE -d "file:///sdcard/Download/$fileName" | Out-Null
    }

    [System.Windows.Forms.MessageBox]::Show("Upload complete.","Done","OK","Information")
})
$form.Controls.Add($uploadButton)

# Show form
$form.Topmost = $true
$form.Add_Shown({ $form.Activate() })
[void]$form.ShowDialog()
