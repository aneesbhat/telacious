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

function Get-PolicyContent {
    param([string]$title, [string]$content_blocks)
    
    return @"

    <!-- Policy Banner -->
    <section class="page-banner" style="position:relative; background:linear-gradient(135deg, var(--primary-dark) 0%, var(--dark) 100%); padding:6rem 2rem 5rem; text-align:center; color:white; overflow:hidden;">
       
       <!-- Decorative background circles -->
       <div style="position:absolute; top:-20%; left:-10%; width:400px; height:400px; background:radial-gradient(circle, rgba(14,165,233,0.15) 0%, transparent 70%); border-radius:50%;"></div>
       <div style="position:absolute; bottom:-20%; right:-10%; width:300px; height:300px; background:radial-gradient(circle, rgba(16,185,129,0.15) 0%, transparent 70%); border-radius:50%;"></div>

       <div style="position:relative; z-index:2; animation: fadeInDown 0.8s cubic-bezier(0.165, 0.84, 0.44, 1) forwards;">
           <h1 style="font-family:'Cormorant Garamond', serif; font-size:4rem; margin-bottom:1rem; color:var(--accent-light); text-shadow: 0 4px 15px rgba(0,0,0,0.3); letter-spacing: 1px;">$title</h1>
           <p style="font-size:1.1rem; max-width:600px; margin:0 auto; opacity:0.85; font-weight:300;">Last updated: April 2026. Please read this policy carefully to understand our practices regarding your bookings and travel arrangements.</p>
       </div>
    </section>

    <!-- Policy Content Document -->
    <section class="section-padding" style="background:#f8fafc; display:flex; justify-content:center;">
      <div style="background:white; max-width:900px; width:100%; border-radius:var(--radius-lg); padding:3.5rem 4rem; box-shadow:0 20px 40px -10px rgba(0,0,0,0.06); border:1px solid rgba(0,0,0,0.04); position:relative; margin-top:-2rem; z-index:5; animation: slideUpFade 0.8s cubic-bezier(0.165, 0.84, 0.44, 1) 0.2s forwards; opacity:0; transform:translateY(30px);">
         
         <div class="policy-body" style="color:var(--dark); font-size:1.05rem; line-height:1.75;">
            $content_blocks
         </div>

         <div style="margin-top:4rem; padding-top:2rem; border-top:1px solid #f1f5f9; text-align:center;">
             <p style="color:var(--text-muted); font-size:0.95rem; margin-bottom:1.5rem;">Have questions about our $title?</p>
             <a href="contact.html" class="btn--book" style="display:inline-flex; background:var(--dark);"><i class="fa-solid fa-headset"></i> Contact Support</a>
         </div>
      </div>
    </section>
  </main>

  <style>
    @keyframes fadeInDown {
      from { opacity:0; transform:translateY(-20px); }
      to { opacity:1; transform:translateY(0); }
    }
    @keyframes slideUpFade {
      from { opacity:0; transform:translateY(30px); }
      to { opacity:1; transform:translateY(0); }
    }
    .policy-body h2 {
       font-family: 'Italiana', serif;
       font-size: 2.2rem;
       color: var(--primary-dark);
       margin-top: 2.5rem;
       margin-bottom: 1.2rem;
       position: relative;
       padding-bottom: 0.5rem;
    }
    .policy-body h2::after {
       content:'';
       position:absolute;
       left:0;
       bottom:0;
       width: 40px;
       height: 3px;
       background: var(--accent);
       border-radius: 2px;
    }
    .policy-body h2:first-child {
       margin-top: 0;
    }
    .policy-body h3 {
       font-size: 1.25rem;
       color: var(--dark);
       margin-top: 2rem;
       margin-bottom: 0.8rem;
    }
    .policy-body p {
       margin-bottom: 1.2rem;
       color: #475569;
    }
    .policy-body ul {
       list-style: none;
       margin-bottom: 1.5rem;
       padding-left: 0.5rem;
    }
    .policy-body li {
       margin-bottom: 0.6rem;
       position: relative;
       padding-left: 1.8rem;
       color: #475569;
    }
    .policy-body li::before {
       content: '\f105';
       font-family: 'Font Awesome 6 Free';
       position: absolute;
       left: 0;
       top: 1px;
       font-weight: 900;
       color: var(--accent);
       font-size: 0.9rem;
    }
    @media(max-width: 650px) {
       .section-padding > div {
           padding: 2rem 1.5rem !important;
       }
       .page-banner {
           padding: 4rem 1rem 3rem !important;
       }
    }
  </style>
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

$privacyBlocks = @"
  <h2>1. Introduction</h2>
  <p>Welcome to <strong>Telacious Tour & Travels</strong>. We deeply value your trust and are thoroughly committed to ensuring the ongoing privacy and security of your personal data. This Privacy Policy details precisely what information we collect, how it is intelligently and securely used, and the exhaustive measures we take to protect it.</p>
  
  <h2>2. Information We Collect</h2>
  <p>We may securely collect, establish, and utilize the following types of personal information to provide you with tailored and safe travel experiences:</p>
  <ul>
    <li><strong>Personal Details:</strong> Names, contact numbers, email addresses, and residential addresses.</li>
    <li><strong>Travel Specifics:</strong> Itinerary preferences, dietary requirements, and essential medical disclosures necessary for high-altitude treks or intensive activities.</li>
    <li><strong>Transaction Data:</strong> Payment histories seamlessly processed via bank-level AES-256 encrypted external gateways. (Note: We do not store core card details internally).</li>
    <li><strong>Digital Analytics:</strong> Browser history, IP addresses, and cookie tracking to improve our website experience over time.</li>
  </ul>

  <h2>3. Application of Collected Data</h2>
  <p>We deploy your data explicitly for these operational purposes:</p>
  <ul>
    <li>Fulfilling direct transport, hotel, and experiential reservations with partners.</li>
    <li>Delivering responsive updates, payment confirmations, and sudden itinerary adjustments via email or message.</li>
    <li>Complying actively with regional legal obligations (e.g., hotel registry norms, border control guidelines).</li>
  </ul>

  <h2>4. Data Minimization & Retention</h2>
  <p>Your data is only retained for as long as it legitimately remains required for operational, legal, and tax purposes. All physical notes or temporary digital files unneeded are frequently purged permanently utilizing top-grade secure deletion methods.</p>

  <h2>5. Your Rights</h2>
  <p>You reserve the ultimate right to request the disclosure, alteration, or complete erasure of your personal data stored with us at any time by contacting our support desk directly.</p>
"@

$termsBlocks = @"
  <h2>1. Acceptance of Terms</h2>
  <p>By engaging, browsing, and explicitly securing a booking directly via the Telacious Tour & Travels website, you unambiguously agree to align unconditionally to these foundational Terms & Conditions.</p>

  <h2>2. Booking Procedures</h2>
  <ul>
    <li>A firm <strong>50% advance deposit</strong> remains mandatory at all times to lock in hotels and flight integrations safely prior to final confirmations.</li>
    <li>The final remainder must be paid explicitly in full prior to arriving at your assigned destination.</li>
    <li>Itineraries remain subject to live availability metrics up until the deposit physically clears with our agents.</li>
  </ul>

  <h2>3. Exclusions & Disclaimers</h2>
  <p>We act solely as an intermediary interface between clients and fundamental ground service operators (hotels, rental cabs, railways, independent guides).</p>
  <ul>
    <li>We explicitly assume zero liability for third-party delays, baggage loss, sudden service deficiencies, or vehicular defaults out of our strict supervisory control.</li>
    <li>Inherent medical risks related directly to extreme travel activities (i.e. Ladakh elevated altitude sickness) belong solely to the active traveler. Please consult your physician accordingly.</li>
  </ul>

  <h2>4. Right of Modification</h2>
  <p>We reserve the unconditional right to dynamically alter trip itineraries rapidly on instances of sudden force majeure, natural geographical disasters, public strikes, or impromptu curfews inside destination states, without owing compensable damages.</p>

  <h2>5. Governing Law</h2>
  <p>Any profound and unsolvable disputes shall strictly be governed by the judicial laws of Srinagar, Kashmir, and fall completely within the absolute jurisdiction of localized regional courts.</p>
"@

$refundBlocks = @"
  <h2>1. Overview of Refund Standards</h2>
  <p>At Telacious Tour & Travels, we firmly strive to be universally transparent regarding all operational logistics, including when travel plans change unexpectedly.</p>

  <h2>2. Eligibility Parameters</h2>
  <p>To accurately understand if your specific booking is eligible for partial or full refunding, it is mandatory to match your status immediately to our established <strong>Cancellation Policy Timeline</strong>.</p>
  
  <h2>3. Non-Refundable Expenditures</h2>
  <p>It is crucial to recognize that certain third-party external integrations will not supply refunds regardless of circumstance:</p>
  <ul>
    <li>Irrevocable airline, railway, and exclusive transport tickets.</li>
    <li>Peak-season, early-bird, or "Promotional / Bestseller" hotel packages labeled inherently non-refundable.</li>
    <li>Standard overarching operational and administration processing fees generally scaling from 10% strictly upfront.</li>
  </ul>

  <h2>4. Disbursal Timelines</h2>
  <p>Eligible refunds require <strong>7 to 14 active business days</strong> to properly cycle physically back into the primary bank or card account originally used at the time of checkout. Immediate cash refunds are expressly disallowed under all conditions.</p>
"@

$cancellationBlocks = @"
  <h2>1. Cancellation Framework</h2>
  <p>We absolutely understand that unpredictable hurdles occasionally disrupt exciting journeys. We enforce the following structured timeline to balance operational realities equally.</p>

  <h2>2. Graded Disruption Matrix</h2>
  <ul>
    <li><strong>30 Days or More Prior:</strong> Total deduction of approximately 10% for pure baseline administrative costs.</li>
    <li><strong>15 - 29 Days Prior:</strong> A 25% deduction penalty applied explicitly against the holistic finalized fare.</li>
    <li><strong>7 - 14 Days Prior:</strong> A 50% deduction penalty applied explicitly against the robust finalized fare.</li>
    <li><strong>Less Than 7 Days Prior / No-Shows:</strong> 100% penalty rate entirely enforced. Strictly no refunds will be permitted.</li>
  </ul>

  <h2>3. Agency Driven Cancellations</h2>
  <p>In the vastly rare occurrence that Telacious Tour & Travels is inherently forced to abruptly cancel an established trip itinerary out of internal logistical constraints, clients remain fully entitled to a totally unreserved <strong>100% refund</strong>, or they may comfortably postpone their itinerary dates freely.</p>

  <h2>4. Submitting a Notice</h2>
  <p>Verbal telephone statements do not suffice for legal cancellations. The lead traveler universally registered on the master file must deploy a structured written request to <strong>info@telacioustour.com</strong> securely. The exact timestamp of this email will unilaterally decide the applied cancellation bracket grade.</p>
"@

$pages = @(
    @("Privacy Policy", $privacyBlocks, "privacy-policy.html"),
    @("Terms and Conditions", $termsBlocks, "terms-conditions.html"),
    @("Refund Policy", $refundBlocks, "refund-policy.html"),
    @("Cancellation Policy", $cancellationBlocks, "cancellation-policy.html")
)

foreach ($page in $pages) {
    $t = $page[0]
    $b = $page[1]
    $f = $page[2]
    
    $bodyContent = Get-PolicyContent -title $t -content_blocks $b
    $full = $header + $bodyContent + "`n" + $popup + "`n" + $footer
    $full = $full -replace '</body>', $scriptToInject
    Set-Content -Path (Join-Path $basePath $f) -Value $full -Encoding UTF8
    Write-Host "Created $f"
}

# Update the HTML links globally
$filesToUpdate = @("index.html", "about.html", "contact.html", "kashmir.html", "ladakh.html", "katra.html")
foreach ($f in $filesToUpdate) {
    $path = "d:\Telacious Tour & Travles\$f"
    if (Test-Path $path) {
        $c = Get-Content -Raw -Encoding UTF8 $path
        # Avoid double updating if already updated but it doesn't hurt.
        $c = $c.Replace('<a href="#"><i class="fa-solid fa-shield"></i> Privacy Policy</a>', '<a href="privacy-policy.html"><i class="fa-solid fa-shield"></i> Privacy Policy</a>')
        $c = $c.Replace('<a href="#"><i class="fa-solid fa-file-contract"></i> Terms and Conditions</a>', '<a href="terms-conditions.html"><i class="fa-solid fa-file-contract"></i> Terms and Conditions</a>')
        $c = $c.Replace('<a href="#"><i class="fa-solid fa-calendar-xmark"></i> Cancellation Policy</a>', '<a href="cancellation-policy.html"><i class="fa-solid fa-calendar-xmark"></i> Cancellation Policy</a>')
        $c = $c.Replace('<a href="#"><i class="fa-solid fa-money-bill-transfer"></i> Refund Policy</a>', '<a href="refund-policy.html"><i class="fa-solid fa-money-bill-transfer"></i> Refund Policy</a>')
        Set-Content -Path $path -Value $c -Encoding UTF8
        Write-Host "Updated links in $f"
    }
}
