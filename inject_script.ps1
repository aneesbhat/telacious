$files = @("kashmir.html", "katra.html", "ladakh.html")
$scriptToInject = @"
<script>
  function openPopup() {
    const bookingPopup = document.getElementById('bookingPopup');
    if(bookingPopup) {
      bookingPopup.classList.add('show');
      document.body.style.overflow = 'hidden';
    }
  }
  function closePopup() {
    const bookingPopup = document.getElementById('bookingPopup');
    if(bookingPopup) {
      bookingPopup.classList.remove('show');
      document.body.style.overflow = '';
    }
  }
  document.addEventListener('DOMContentLoaded', () => {
    const popupClose = document.getElementById('popupClose');
    if(popupClose) popupClose.addEventListener('click', closePopup);
    const bookingPopup = document.getElementById('bookingPopup');
    if(bookingPopup) {
      bookingPopup.addEventListener('click', (e) => {
        if(e.target === bookingPopup) closePopup();
      });
    }
  });
</script>
</body>
"@

foreach ($f in $files) {
    $path = "d:\Telacious Tour & Travles\$f"
    $c = Get-Content -Raw $path
    $c = $c -replace '</body>', $scriptToInject
    Set-Content -Path $path -Value $c -Encoding UTF8
    Write-Host "Injected script to $f"
}
