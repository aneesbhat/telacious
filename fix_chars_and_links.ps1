$files = @("kashmir.html", "ladakh.html", "katra.html", "index.html", "about.html", "contact.html")
foreach ($file in $files) {
    $path = "d:\Telacious Tour & Travles\$file"
    if (Test-Path $path) {
        $content = Get-Content -Raw -Encoding UTF8 $path
        
        $content = $content -replace "â‚¹", "₹"
        $content = $content -replace "â€”", "—"
        $content = $content -replace "â€™", "'"
        $content = $content -replace "â€“", "–"
        $content = $content -replace "â€œ", "`""
        $content = $content -replace "â€", "`""
        
        $content = $content.Replace('<a href="#"><i class="fa-solid fa-shield"></i> Privacy Policy</a>', '<a href="privacy-policy.html"><i class="fa-solid fa-shield"></i> Privacy Policy</a>')
        $content = $content.Replace('<a href="#"><i class="fa-solid fa-file-contract"></i> Terms and Conditions</a>', '<a href="terms-conditions.html"><i class="fa-solid fa-file-contract"></i> Terms and Conditions</a>')
        $content = $content.Replace('<a href="#"><i class="fa-solid fa-calendar-xmark"></i> Cancellation Policy</a>', '<a href="cancellation-policy.html"><i class="fa-solid fa-calendar-xmark"></i> Cancellation Policy</a>')
        $content = $content.Replace('<a href="#"><i class="fa-solid fa-money-bill-transfer"></i> Refund Policy</a>', '<a href="refund-policy.html"><i class="fa-solid fa-money-bill-transfer"></i> Refund Policy</a>')
        
        Set-Content -Path $path -Value $content -Encoding UTF8
    }
}
