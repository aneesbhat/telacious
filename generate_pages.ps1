$basePath = "d:\Telacious Tour & Travles"
$indexPath = Join-Path $basePath "index.html"
$content = Get-Content -Raw -Encoding UTF8 $indexPath

$headerRegex = '(?s)^.*?<main[^>]*>'
$footerRegex = '(?s)<footer[^>]*>.*$'
$popupRegex  = '(?s)<div class="popup-overlay"[^>]*>.*?(?=<footer)'

$headerMatch = [regex]::Match($content, $headerRegex)
if ($headerMatch.Success) { $header = $headerMatch.Value } else { Write-Host "No header"; exit 1 }

$footerMatch = [regex]::Match($content, $footerRegex)
if ($footerMatch.Success) { $footer = $footerMatch.Value } else { Write-Host "No footer"; exit 1 }

$popupMatch = [regex]::Match($content, $popupRegex)
if ($popupMatch.Success) { $popup = $popupMatch.Value } else { Write-Host "No popup"; exit 1 }

$header = $header -replace 'href="packages\.html#kashmir"','href="kashmir.html"'
$header = $header -replace 'href="packages\.html#katra"','href="katra.html"'
$header = $header -replace 'href="packages\.html#ladakh"','href="ladakh.html"'

function Get-PageContent {
    param([string]$title, [string]$ptype)
    
    $boxes_html = ""
    # We need exactly 5.
    $prices = @(18500, 24000, 11500, 31000, 15000)
    $badges = @("Bestseller", "Trending", "Budget", "Luxury", "Standard")
    
    for ($i=1; $i -le 5; $i++) {
        $p = $prices[$i-1]
        $pStr = "{0:N0}" -f $p
        $badge = $badges[$i-1]
        
        $boxes_html += @"
      <article class="package-card" data-price="$p">
        <div class="package-thumb">
          <span class="package-badge">$badge</span>
          <img src="images/$($ptype)_placeholder_$i.jpg" alt="$title Package $i" onerror="this.src='images/logo.png'">
          <div class="package-rating">
            <div class="stars">
              <i class="fa-solid fa-star"></i>
              <i class="fa-solid fa-star"></i>
              <i class="fa-solid fa-star"></i>
              <i class="fa-solid fa-star"></i>
              <i class="fa-solid fa-star"></i>
            </div>
            <span class="review-count">$($i*120 + 50) reviews</span>
          </div>
        </div>
        <div class="package-content">
          <h3>$title Discovery $i</h3>
          <div class="package-meta">
            <span><i class="fa-solid fa-clock"></i> $($i+2) Days / $($i+1) Nights</span>
            <span><i class="fa-solid fa-location-dot"></i> Top Attractions</span>
          </div>
          <div class="package-inclusions">
            <div class="inclusion-icon" title="Breakfast/Dinner"><i class="fa-solid fa-utensils"></i></div>
            <div class="inclusion-icon" title="Premium Stay"><i class="fa-solid fa-hotel"></i></div>
            <div class="inclusion-icon" title="Private Transfers"><i class="fa-solid fa-car"></i></div>
            <div class="inclusion-icon" title="Sightseeing Guide"><i class="fa-solid fa-camera"></i></div>
          </div>
          <div class="package-footer" style="padding-top:1.5rem; justify-content:space-between; flex-wrap:wrap; gap:1rem;">
            <div class="package-price">
              <span class="price-label">Starts from</span>
              <span class="price-value">₹$pStr</span>
              <span class="pax-count">per person</span>
            </div>
            <div style="display:flex; gap:0.5rem; flex-wrap:wrap; align-items:center;">
               <a href="tel:+919876543210" class="btn--book" style="background:var(--primary);"><i class="fa-solid fa-phone"></i> Call Now</a>
               <a href="#" class="btn--book" onclick="openPopup(0); return false;">Book Now <i class="fa-solid fa-arrow-right"></i></a>
            </div>
          </div>
        </div>
      </article>
"@
    }

    # Added top banner image section
    return @"
    <!-- Banner -->
    <section class="page-banner" style="position:relative; background:url('images/$($ptype)_banner.jpg') no-repeat center center/cover; padding:8rem 2rem 6rem; text-align:center; color:white;">
       <div style="position:absolute; inset:0; background:rgba(13, 27, 42, 0.7);"></div>
       <div style="position:relative; z-index:2;">
           <h1 style="font-family:'Cormorant Garamond', serif; font-size:4.5rem; margin-bottom:1rem; color:var(--accent-light); text-shadow: 0 4px 15px rgba(0,0,0,0.5);">$title Packages</h1>
           <p style="font-size:1.3rem; max-width:700px; margin:0 auto; opacity:0.95; text-shadow: 0 2px 8px rgba(0,0,0,0.5);">Explore the breathtaking beauty of $title securely with our premium itineraries and expert-guided journeys designed specifically for your perfect escape.</p>
       </div>
    </section>

    <!-- Filter and Grid -->
    <section class="section-padding" style="background:var(--light);">
      <div style="max-width:1200px; margin:0 auto 2.5rem; display:flex; flex-wrap:wrap; align-items:center; gap:1rem; background:var(--white); padding:1rem 2rem; border-radius:var(--radius-md); box-shadow:0 8px 30px rgba(0,0,0,0.03);">
        <label for="priceFilter" style="font-weight:700; color:var(--dark); font-size:1.1rem;"><i class="fa-solid fa-filter" style="color:var(--accent); margin-right:0.5rem;"></i> Filter by Price:</label>
        <select id="priceFilter" onchange="filterPackages()" style="padding:0.75rem 1.5rem; border-radius:var(--radius-sm); border:2px solid #e5e7eb; font-family:'Inter',sans-serif; background:var(--light); font-weight:600; color:var(--primary-dark); cursor:pointer; outline:none; transition:border-color var(--transition);">
           <option value="all">- All Tour Packages -</option>
           <option value="15000">Budget (Below Rs. 15,000)</option>
           <option value="20000">Standard (Below Rs. 20,000)</option>
           <option value="25000">Premium (Below Rs. 25,000)</option>
           <option value="35000">Luxury (Below Rs. 35,000)</option>
        </select>
      </div>

      <div class="packages-grid" id="packagesGrid">
        $boxes_html
      </div>
      <div id="noResults" style="display:none; text-align:center; padding:5rem 2rem; color:var(--text-muted);">
         <i class="fa-solid fa-magnifying-glass-location" style="font-size:4rem; color:var(--primary-light); margin-bottom:1rem; opacity:0.5;"></i>
         <h3 style="font-size:1.5rem; color:var(--dark); margin-bottom:0.5rem;">No Packages Found</h3>
         <p style="font-size:1.1rem;">Try adjusting your price filter to see more options.</p>
      </div>
    </section>
  </main>

  <script>
    function filterPackages() {
      const filterValue = document.getElementById('priceFilter').value;
      const cards = document.querySelectorAll('.package-card');
      let visibleCount = 0;

      cards.forEach(card => {
        const price = parseInt(card.getAttribute('data-price'));
        let show = false;
        
        if (filterValue === 'all') {
          show = true;
        } else {
          const maxPrice = parseInt(filterValue);
          if (price <= maxPrice) show = true;
        }

        if (show) {
          card.style.display = 'block';
          // Subtle animation
          card.style.animation = 'fadeInUp 0.5s ease forwards';
          visibleCount++;
        } else {
          card.style.display = 'none';
        }
      });

      document.getElementById('noResults').style.display = visibleCount === 0 ? 'block' : 'none';
    }

    // Add keyframe dynamically
    const styleSheet = document.createElement("style");
    styleSheet.innerText = `
      @keyframes fadeInUp {
        from { opacity: 0; transform: translateY(20px); }
        to { opacity: 1; transform: translateY(0); }
      }
    `;
    document.head.appendChild(styleSheet);
  </script>
"@
}

$scriptToInject = @"
<script>
  function openPopup(delay = 0) {
    const bookingPopup = document.getElementById('bookingPopup');
    if(bookingPopup) {
      if (delay > 0) {
          setTimeout(() => {
              bookingPopup.classList.add('show');
              document.body.style.overflow = 'hidden';
          }, delay);
      } else {
          bookingPopup.classList.add('show');
          document.body.style.overflow = 'hidden';
      }
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

$pages = @(
    @("Kashmir", "kashmir", "kashmir.html"),
    @("Ladakh", "ladakh", "ladakh.html"),
    @("Vaishno Devi", "katra", "katra.html")
)

foreach ($page in $pages) {
    $t = $page[0]
    $p = $page[1]
    $f = $page[2]
    
    $bodyContent = Get-PageContent -title $t -ptype $p
    $full = $header + $bodyContent + "`n" + $popup + "`n" + $footer
    $full = $full -replace '</body>', $scriptToInject
    Set-Content -Path (Join-Path $basePath $f) -Value $full -Encoding UTF8
    Write-Host "Created $f"
}
