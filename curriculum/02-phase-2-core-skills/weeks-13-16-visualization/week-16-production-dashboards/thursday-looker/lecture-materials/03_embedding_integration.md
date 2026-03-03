# Embedding and Integration

## Week 16 - Thursday Session - Part 3

### Duration: 15 minutes

---

## What Is Dashboard Embedding?

**Dashboard embedding** means placing your Looker Studio dashboard inside a webpage, so visitors to that page see the dashboard without navigating to Looker Studio directly. The dashboard renders inside an HTML `<iframe>` — a container element that displays external content within your webpage.

For a data analyst building a professional portfolio, embedding transforms your Looker Studio dashboard from a private Google-hosted report into a publicly showcased portfolio piece — visible to recruiters, hiring managers, and clients without them needing a Google account.

### The Three Embedding Scenarios

| Scenario | Access Level | Use Case |
|----------|-------------|---------|
| **Public embed** | Anyone can view (no login required) | Portfolio websites, public-facing business reports |
| **Restricted embed** | Requires Google account sign-in | Internal company intranet, authenticated client portals |
| **Google Sites embed** | Native integration, no code required | Team wikis, project pages, internal knowledge bases |

---

## Getting the Embed Code

### Step 1: Enable Embedding for Your Report

Before you can embed, the report must be configured for embedding:

1. Open your Looker Studio report
2. Click **File** → **Embed report**
3. Toggle **"Enable embedding"** to ON
4. Click **"Copy embed code"**

[Screenshot: Looker Studio File menu showing "Embed report" option]

### Step 2: Understanding the Generated Embed Code

The embed code looks like this:

```html
<iframe
  width="600"
  height="450"
  src="https://lookerstudio.google.com/embed/reporting/YOUR-REPORT-ID/page/YOUR-PAGE-ID"
  frameborder="0"
  style="border:0"
  allowfullscreen
  sandbox="allow-storage-access-by-user-activation allow-scripts allow-same-origin allow-popups allow-popups-to-escape-sandbox">
</iframe>
```

**Understanding each attribute:**

| Attribute | Purpose | Recommended Value |
|-----------|---------|------------------|
| `width` | Iframe width in pixels | "100%" for responsive |
| `height` | Iframe height in pixels | "600" to "900" for full dashboards |
| `src` | The embedded report URL | Auto-generated — do not modify |
| `frameborder` | Border around iframe | "0" (remove border) |
| `style="border:0"` | CSS border removal | Keep as is |
| `allowfullscreen` | Allows fullscreen mode | Keep — lets users expand the view |
| `sandbox` | Security permissions | Keep the default sandbox attributes |

---

## Customizing the Embed for Your Portfolio

### Making the Embed Responsive (Mobile-Friendly)

The default embed uses a fixed pixel width. For portfolio websites where visitors may view on phone or tablet, use percentage width:

```html
<div style="position: relative; width: 100%; height: 0; padding-bottom: 62.5%;">
  <iframe
    style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;"
    src="https://lookerstudio.google.com/embed/reporting/YOUR-REPORT-ID/page/YOUR-PAGE-ID"
    frameborder="0"
    allowfullscreen
    sandbox="allow-storage-access-by-user-activation allow-scripts allow-same-origin allow-popups allow-popups-to-escape-sandbox">
  </iframe>
</div>
```

**How this works:**
- The outer `<div>` creates a container with a 62.5% padding-bottom (this creates a 16:10 aspect ratio)
- The `<iframe>` is positioned absolutely within the container
- On any screen width, the iframe scales proportionally

### Choosing the Right Page to Embed

For a portfolio, embed your executive summary page — the most polished, visually impactful page:

```html
src="https://lookerstudio.google.com/embed/reporting/REPORT-ID/page/PAGE-ID-OF-EXECUTIVE-SUMMARY"
```

To get the specific page ID:
1. Navigate to the page you want to embed in Looker Studio
2. The URL changes to show the page ID after `/page/`
3. Copy that segment into your embed URL

### Adding a Caption and Link Below the Embed

Always provide context around your embedded dashboard:

```html
<div style="max-width: 900px; margin: 0 auto;">
  <iframe
    width="100%"
    height="600"
    src="https://lookerstudio.google.com/embed/reporting/YOUR-REPORT-ID"
    frameborder="0"
    allowfullscreen
    sandbox="allow-storage-access-by-user-activation allow-scripts allow-same-origin allow-popups allow-popups-to-escape-sandbox">
  </iframe>

  <p style="font-size: 14px; color: #555; margin-top: 8px;">
    <strong>Olist E-Commerce Executive Dashboard</strong> — Built with Google Looker Studio,
    PostgreSQL (Supabase), and the Brazilian Olist marketplace dataset (99,441 orders, 2016-2018).
    Metrics include CLV segmentation, delivery performance analysis, and MoM revenue growth.
    <a href="https://lookerstudio.google.com/reporting/YOUR-REPORT-ID" target="_blank">
      View full interactive dashboard →
    </a>
  </p>
</div>
```

---

## Embedding in Google Sites

Google Sites is the simplest embedding option — no code required.

### What Is Google Sites?

Google Sites is a free website builder from Google. It integrates natively with Looker Studio — you can embed a report in seconds without writing any HTML.

### Step-by-Step: Embed in Google Sites

1. Open your Google Sites page (sites.google.com → Create new site)
2. Click **Insert** in the right panel
3. Select **"Embed"**
4. Paste your Looker Studio report URL (not the embed code — just the regular URL)
5. Click **Insert**
6. Resize the embedded block by dragging corners
7. Click **Publish** to make the site live

[Screenshot: Google Sites editor with the "Embed" option in the Insert panel and a Looker Studio report embedded in the page]

**Why use Google Sites:**
- No coding required
- Free hosting
- Native Google account integration
- Embedded reports maintain full interactivity (filters, date pickers work)
- Published Google Sites URLs are shareable with anyone

**Portfolio use case:** Create a Google Sites page with:
- Your name and title
- Project description (2-3 paragraphs about the Olist analysis)
- Embedded Looker Studio dashboard
- SQL/Python project links
- Contact information

---

## Embedding in External Websites

If you have an existing portfolio website (GitHub Pages, personal domain, etc.), embed your dashboard using the HTML iframe code.

### GitHub Pages Example

If your portfolio is hosted on GitHub Pages (`yourname.github.io`):

1. Edit your `index.html` or the relevant portfolio page
2. Paste the embed code in the appropriate section:

```html
<!-- In your portfolio HTML file -->
<section id="dashboard-project">
  <h2>Olist E-Commerce Analytics Dashboard</h2>
  <p>End-to-end business intelligence dashboard analyzing 99,441 orders
     from the Brazilian Olist marketplace. Key metrics: CLV segmentation,
     delivery performance, MoM revenue trends, and marketing funnel analysis.</p>

  <div style="margin: 20px 0;">
    <iframe
      width="100%"
      height="600"
      src="https://lookerstudio.google.com/embed/reporting/YOUR-REPORT-ID"
      frameborder="0"
      allowfullscreen
      sandbox="allow-storage-access-by-user-activation allow-scripts allow-same-origin allow-popups allow-popups-to-escape-sandbox">
    </iframe>
  </div>

  <p>
    Tools: Google Looker Studio | PostgreSQL | Supabase | Python
    <br>
    Dataset: Olist Brazilian E-Commerce (Kaggle)
    <a href="https://lookerstudio.google.com/reporting/YOUR-REPORT-ID"
       target="_blank">Full dashboard →</a>
  </p>
</section>
```

### Access Requirements for Public Embeds

For the embed to work for visitors who are not logged into Google:

1. Your report must have **"Public on the web"** sharing configured
   - Share → Manage access → General access → "Public on the web"
   - OR: "Anyone with the link can view" also works for most users

2. Verify the embed URL uses the `/embed/` path (this is automatically added by Looker Studio's embed code generator)

3. Test in an incognito window (no Google account logged in) to confirm public access works

---

## Restricted Embedding for Internal Use

For internal company portals where viewers have Google Workspace accounts:

1. Keep report sharing set to **"Restricted"** (only specific people)
2. Use the standard embed code
3. Viewers will be prompted to sign in with their Google Workspace account before seeing the dashboard

**Use case:** An internal business intelligence portal on the company intranet where all employees have company Google accounts.

---

## Connection to Prior Learning

### Week 13 (Publishing Your First Report)

In Week 13 you learned to publish and share a basic Looker Studio report. Today you take that one step further — embedding the published report in external websites for professional portfolio presentation.

### Weeks 13-15 (Building the Dashboard)

Every technique from the past four weeks — data connections, interactive controls, calculated fields, data storytelling — is what makes the embedded dashboard impressive. Embedding is the final delivery mechanism.

---

## Portfolio Impact: Why Embedding Matters

### What a Recruiter or Hiring Manager Sees

**Without embedding:**
"Here is a link to my Looker Studio dashboard."
- Requires the recruiter to click, sign in (maybe), wait for it to load
- May not work if they do not have a Google account
- Easy to skip or ignore

**With portfolio embedding:**
- Recruiter visits your website, sees the dashboard immediately
- No barriers — loads in the page, no login required
- They can interact with it (apply filters, change dates)
- Dashboard is always "on" — works months after you submitted the application

**Professional impact:** An embedded, interactive dashboard in your portfolio is evidence of real-world production skills — not just a screenshot in a PDF.

---

## Common Issues and Solutions

| Issue | Symptom | Solution |
|-------|---------|---------|
| Blank iframe on portfolio website | Empty white box where dashboard should appear | Check that sharing is set to "Public on web" — Restricted sharing blocks public embeds |
| "Sign in required" for public embed | Visitors prompted to sign in | Report sharing must be set to public; also verify the src URL includes `/embed/` |
| Dashboard too small in embed | Charts too tiny to read | Increase `height` attribute to 750 or 900; use responsive CSS wrapper |
| Filters do not work in embed | Date picker or dropdown unresponsive | Remove overly restrictive sandbox attributes — keep the full sandbox string from Looker's generator |
| Google Sites embed shows "Preview unavailable" | Error in Sites editor | Use the report URL, not the embed iframe code — Google Sites generates its own embed |

---

## Key Takeaways

### What You Learned
1. ✅ Embedding places your dashboard inside an HTML `<iframe>` on any webpage
2. ✅ Use percentage width and relative positioning for responsive (mobile-friendly) embeds
3. ✅ Google Sites provides native, no-code embedding for the simplest portfolio setup
4. ✅ Public embeds require report sharing to be set to "Public on the web" or "Anyone with the link"
5. ✅ An embedded, interactive dashboard is a stronger portfolio piece than a screenshot
6. ✅ Always test your embed in an incognito window to verify public access works

### What's Next
In the final lecture, you will build the documentation that makes your dashboard maintainable — and receive the Final Project brief with all requirements for your presentation next week.

### Skills Building Progression

```
Week 16 Part 1: Sharing & Permissions ✓
Week 16 Part 2: Scheduled Delivery & Exports ✓
Week 16 Part 3: Embedding & Integration (Now)
         ↓
Week 16 Part 4: Maintenance & Documentation (Final)
```

---

## Quick Reference Card

### Embed Code Template

```html
<!-- Standard embed -->
<iframe
  width="100%"
  height="600"
  src="https://lookerstudio.google.com/embed/reporting/REPORT-ID/page/PAGE-ID"
  frameborder="0"
  style="border:0"
  allowfullscreen
  sandbox="allow-storage-access-by-user-activation allow-scripts
           allow-same-origin allow-popups allow-popups-to-escape-sandbox">
</iframe>

<!-- Responsive embed wrapper -->
<div style="position:relative; width:100%; height:0; padding-bottom:62.5%;">
  <iframe
    style="position:absolute; top:0; left:0; width:100%; height:100%;"
    src="https://lookerstudio.google.com/embed/reporting/REPORT-ID"
    frameborder="0"
    allowfullscreen
    sandbox="allow-storage-access-by-user-activation allow-scripts
             allow-same-origin allow-popups allow-popups-to-escape-sandbox">
  </iframe>
</div>
```

### Embed Checklist Before Publishing

```
☐ Report sharing set to "Public on web" or "Anyone with link"
☐ Embed enabled: File → Embed report → Enable embedding
☐ Tested in incognito browser (no Google login)
☐ Responsive wrapper added (percentage width)
☐ Caption with project description added below embed
☐ Link to full interactive dashboard included
```

---

## Questions to Test Your Understanding

1. What HTML element is used to embed a Looker Studio dashboard in a webpage?
2. You publish your portfolio website with the embedded dashboard. A friend without a Google account opens it and sees a blank white box. What is the most likely cause?
3. What is the advantage of using `width="100%"` instead of `width="600"` in your embed code?
4. You want to embed your dashboard in a Google Sites portfolio page. Do you paste the iframe embed code or the regular report URL?
5. A recruiter says your embedded dashboard is loading but looks very small and cramped on their laptop. What setting would you change to improve this?

**Answers at the end of lecture notes**

---

## Answers to Questions

1. **HTML element:** `<iframe>` (inline frame). The iframe creates a container that loads and displays an external URL — in this case, the Looker Studio embed URL — within your page.
2. **Blank white box cause:** The report sharing is most likely set to "Restricted" (only specific people). Your friend, without a Google account, cannot authenticate. Change sharing to "Public on the web" (anyone can view, no login required) and refresh the portfolio page.
3. **Percentage vs fixed width:** `width="100%"` means the iframe fills the full width of its parent container. On a wide desktop, it is large. On a narrow phone screen, it scales down proportionally. `width="600"` is always exactly 600 pixels — which overflows on phones and leaves empty space on wide monitors. Responsive embeds with percentage width look professional across all devices.
4. **Google Sites embed:** Paste the regular report URL (e.g., `https://lookerstudio.google.com/reporting/abc123`). Google Sites generates its own internal embed — it does not need or accept the raw iframe code. Pasting the iframe code would display the code as text, not as an embedded dashboard.
5. **Dashboard too small:** Increase the `height` attribute in the iframe. If currently `height="450"`, try `height="750"` or `height="900"`. Also verify the responsive wrapper is in place — if using fixed pixel width, the dashboard may be constrained. As a last resort, direct the recruiter to the full dashboard URL with a "View full dashboard" link.

---

**Next Lecture:** 04_maintenance_documentation.md
