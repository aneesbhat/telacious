import re
import os

base_path = r"d:\Telacious Tour & Travles"
about_path = os.path.join(base_path, "about.html")

with open(about_path, 'r', encoding='utf-8') as f:
    html = f.read()

# Extract header (up to <main>)
header_match = re.search(r"([\s\S]*?)<main", html)
header = header_match.group(1) if header_match else ""

# Extract footer and below
footer_match = re.search(r"(<footer[\s\S]*)", html)
footer = footer_match.group(1) if footer_match else ""

# Also extract popup since it might be between main and footer
popup_match = re.search(r"(<div class=\"popup-overlay\"[\s\S]*?</div>\s*</div>\s*</div>)", html)
popup = popup_match.group(1) if popup_match else ""

print("Header length:", len(header))
print("Footer length:", len(footer))
print("Popup length:", len(popup))

# Let's replace the nav links in the header
header = header.replace('href="packages.html#kashmir"', 'href="kashmir.html"')
header = header.replace('href="packages.html#katra"', 'href="katra.html"')
header = header.replace('href="packages.html#ladakh"', 'href="ladakh.html"')

# Function to generate content for a specific place
def get_content(title, package_type):
    # Depending on the package we produce different boxes
    boxes_html = ""
    prices = [12000, 24000, 8500, 31000, 15000, 9500]
    
    for i in range(1, 7):
        p = prices[i-1]
        boxes_html += f"""
      <article class="package-card" data-price="{p}">
        <div class="package-thumb">
          <span class="package-badge">Package {i}</span>
          <img src="images/{package_type.lower()}_placeholder_{i}.jpg" alt="{title} Package {i}" onerror="this.src=\'images/logo.png\'">
          <div class="package-rating">
            <div class="stars">
              <i class="fa-solid fa-star"></i>
              <i class="fa-solid fa-star"></i>
              <i class="fa-solid fa-star"></i>
              <i class="fa-solid fa-star"></i>
              <i class="fa-solid fa-star"></i>
            </div>
          </div>
        </div>
        <div class="package-content">
          <h3>{title} Discovery {i}</h3>
          <div class="package-meta">
            <span><i class="fa-solid fa-clock"></i> {i+2} Days / {i+1} Nights</span>
          </div>
          <div class="package-footer">
            <div class="package-price">
              <span class="price-label">Price</span>
              <span class="price-value">₹{p:,}</span>
            </div>
            <div style="display:flex; gap:0.5rem;">
               <a href="tel:+919876543210" class="btn--book" style="background:var(--primary);"><i class="fa-solid fa-phone"></i> Call Now</a>
               <a href="#" class="btn--book"><i class="fa-solid fa-arrow-right"></i> Book Now</a>
            </div>
          </div>
        </div>
      </article>
        """

    content = f"""
  <main>
    <!-- Banner -->
    <section class="page-banner" style="position:relative; background:#0d1b2a; padding:6rem 2rem; text-align:center; color:white;">
       <h1 style="font-family:'Cormorant Garamond', serif; font-size:4rem; margin-bottom:1rem; color:var(--accent-light);">{title} Packages</h1>
       <p style="font-size:1.2rem; max-width:600px; margin:0 auto; opacity:0.9;">Explore the breathtaking beauty of {title} with our exclusive, handcrafted travel packages designed just for you.</p>
    </section>

    <!-- Filter and Grid -->
    <section class="section-padding" style="background:var(--light);">
      <div style="max-width:1200px; margin:0 auto 2rem;">
        <label for="priceFilter" style="font-weight:600; margin-right:1rem; color:var(--dark);">Filter by Price:</label>
        <select id="priceFilter" onchange="filterPackages()" style="padding:0.75rem 1rem; border-radius:var(--radius-sm); border:1px solid #ccc; font-family:'Inter',sans-serif;">
           <option value="all">All Packages</option>
           <option value="10000">Below ₹10,000</option>
           <option value="20000">Below ₹20,000</option>
           <option value="25000">Below ₹25,000</option>
           <option value="35000">Below ₹35,000</option>
           <option value="above25000">Above ₹25,000</option>
        </select>
      </div>

      <div class="packages-grid" id="packagesGrid">
        {boxes_html}
      </div>
      <div id="noResults" style="display:none; text-align:center; padding:3rem; color:var(--text-muted); font-size:1.2rem;">
         No packages found in this price range.
      </div>
    </section>
  </main>

  <script>
    function filterPackages() {{
      const filterValue = document.getElementById('priceFilter').value;
      const cards = document.querySelectorAll('.package-card');
      let visibleCount = 0;

      cards.forEach(card => {{
        const price = parseInt(card.getAttribute('data-price'));
        let show = false;
        
        if (filterValue === 'all') {{
          show = true;
        }} else if (filterValue === 'above25000') {{
          if (price > 25000) show = true;
        }} else {{
          const maxPrice = parseInt(filterValue);
          if (price <= maxPrice) show = true;
        }}

        if (show) {{
          card.style.display = 'block';
          visibleCount++;
        }} else {{
          card.style.display = 'none';
        }}
      }});

      document.getElementById('noResults').style.display = visibleCount === 0 ? 'block' : 'none';
    }}
  </script>
"""
    return content

for page_info in [("Kashmir", "kashmir", "kashmir.html"), ("Ladakh", "ladakh", "ladakh.html"), ("Vaishno Devi", "katra", "katra.html")]:
    title, ptype, filename = page_info
    full_html = header + get_content(title, ptype) + "\n" + popup + "\n" + footer
    with open(os.path.join(base_path, filename), 'w', encoding='utf-8') as f:
        f.write(full_html)
    print(f"Created {filename}")

# Note: also we need to update index.html, about.html, contact.html to replace their nav links.
for f_name in ['index.html', 'about.html', 'contact.html']:
    f_path = os.path.join(base_path, f_name)
    with open(f_path, 'r', encoding='utf-8') as f:
       content = f.read()
    
    new_content = content.replace('href="packages.html#kashmir"', 'href="kashmir.html"')
    new_content = new_content.replace('href="packages.html#katra"', 'href="katra.html"')
    new_content = new_content.replace('href="packages.html#ladakh"', 'href="ladakh.html"')

    if new_content != content:
       with open(f_path, 'w', encoding='utf-8') as f:
          f.write(new_content)
       print(f"Updated {f_name}")

