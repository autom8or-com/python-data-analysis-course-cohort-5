# Sharing and Permissions Reference Guide

## Week 16 - Thursday Session Resource

**Last Updated:** March 2026 | Cohort 5

---

## Overview

This reference guide documents all sharing, permissions, and delivery configurations available in Google Looker Studio. Use it during Thursday exercises and when preparing your Final Project for instructor submission and portfolio deployment. All UI paths are current as of early 2026.

---

## Table of Contents

1. [Permission Levels Quick Reference](#permission-levels-quick-reference)
2. [Sharing Methods Comparison](#sharing-methods-comparison)
3. [Data Source Credentials](#data-source-credentials)
4. [Scheduled Email Delivery Configuration](#scheduled-email-delivery-configuration)
5. [Export Options Reference](#export-options-reference)
6. [Embedding Configuration](#embedding-configuration)
7. [Stakeholder Access Matrix](#stakeholder-access-matrix)
8. [Common Configurations for This Course](#common-configurations-for-this-course)
9. [Troubleshooting Quick Reference](#troubleshooting-quick-reference)
10. [Access Request Workflow](#access-request-workflow)

---

## Permission Levels Quick Reference

### The Three Permission Levels

| Capability | Viewer | Editor | Owner |
|------------|--------|--------|-------|
| View all pages and charts | Yes | Yes | Yes |
| Apply filters and controls (interactive) | Yes | Yes | Yes |
| Download PDF or CSV exports | Yes | Yes | Yes |
| Add/edit/delete charts | No | Yes | Yes |
| Add/edit/delete calculated fields | No | Yes | Yes |
| Add/edit/delete data sources | No | Yes | Yes |
| Add/edit/delete pages | No | Yes | Yes |
| Share the report with others | No | No | Yes |
| Delete the report | No | No | Yes |
| Transfer ownership | No | No | Yes |
| Change sharing settings | No | No | Yes |
| Manage scheduled email deliveries | No | No | Yes |

### When to Use Each Level

| Level | Use When |
|-------|---------|
| Viewer | Instructor access, client access, executive review, portfolio visitors |
| Editor | Analyst teammates who need to maintain or update the dashboard |
| Owner | Yourself — you created the dashboard |

**Rule:** Always default to Viewer. Only grant Editor when the person genuinely needs to modify the dashboard. The fewer Editors, the less risk of accidental chart or data source changes.

---

## Sharing Methods Comparison

### Method 1: Direct User Access (Recommended for Known Users)

**Path:** Share button → Manage access → Add email → Set permission level → Send

| Attribute | Detail |
|-----------|--------|
| Who | Specific Google accounts by email address |
| Requires Google account | Yes |
| Access control | Precise — individual level |
| Revoke access | Yes — remove from the access list |
| Best for | Instructor, known teammates, internal stakeholders |
| Notification | Optional email notification when access is granted |

**How to grant:**
1. Click **Share** (top right)
2. Click **Manage access**
3. In "People" field, type the email address
4. Select permission: Viewer or Editor
5. (Optional) Add a message
6. Click **Send**

### Method 2: Link Sharing (Recommended for Portfolio)

**Path:** Share → Manage access → General access dropdown → "Anyone with the link can view"

| Attribute | Detail |
|-----------|--------|
| Who | Anyone who has the link URL |
| Requires Google account | No |
| Access control | Anyone with the URL — no individual tracking |
| Revoke access | Change link to "Restricted" — old link stops working |
| Best for | Portfolio, recruiters, public presentations |
| Notification | No automatic notification to viewers |

**Important distinction:** There are two URLs for every Looker Studio report:
- **Edit URL:** `https://lookerstudio.google.com/reporting/[ID]/edit` — requires authentication even with link sharing enabled
- **Shareable link:** Generated from the "Manage access" dialog — this is what bypasses authentication for "Anyone with the link" setting

Always share the Shareable link URL from the dialog, not the URL from your browser address bar.

### Method 3: Publish to Web (Not Recommended for This Course)

**Path:** File → Publish to web

| Attribute | Detail |
|-----------|--------|
| Who | Truly anyone — no URL knowledge required |
| Requires Google account | No |
| Indexed by search engines | Potentially yes |
| Access control | None — fully public |
| Best for | Public-facing dashboards with no sensitive data |
| Warning | Once published, the dashboard may be discoverable publicly |

**Not recommended for Final Project:** The Olist dataset is a research dataset, but best practice is to use link sharing (Method 2) rather than full web publication.

---

## Data Source Credentials

### Owner's Credentials vs Viewer's Credentials

This is the most important configuration for a shared dashboard.

| Setting | What It Means | When to Use |
|---------|--------------|-------------|
| Owner's credentials | Dashboard uses YOUR Google/database credentials to fetch data | When sharing with viewers who don't have Supabase accounts |
| Viewer's credentials | Dashboard uses each VIEWER's credentials to fetch data | When sharing internally with colleagues who all have database access |

### Setting for the Olist Dashboard

Always use **Owner's credentials** because:
- Your instructor does not have a Supabase account
- Recruiters and portfolio visitors do not have a Supabase account
- The data is historical (not sensitive) — using owner credentials is safe

**How to set:**
1. Resource → Manage added data sources
2. Click the lock icon (credentials) next to each data source
3. Select "Owner's credentials"
4. Click "Update"

**Effect:** When a Viewer loads your dashboard, Looker Studio uses your credentials to query Supabase, then displays the results. The Viewer sees data but cannot access Supabase directly.

---

## Scheduled Email Delivery Configuration

### Configuration Parameters

| Parameter | Options | Recommendation |
|-----------|---------|----------------|
| Recipients | Email addresses (comma-separated) | Separate by audience (exec vs analyst) |
| Subject line | Free text | Include date/period for clarity |
| Message body | Free text | Include headline insights |
| Frequency | Once, Daily, Weekly, Monthly | Weekly for executive dashboards |
| Day (Weekly) | Monday–Sunday | Monday (executives start week with data) |
| Time | Hour of day | 7:00 AM (ready before morning standup) |
| Time zone | User's time zone or report time zone | WAT (West Africa Time) for this cohort |
| Report format | PDF attachment or Link to report | PDF for executives; Link for analysts |
| Pages | All pages or selected pages | Page 1 only for executives |

### Recommended Schedule Configurations

**Executive Weekly Summary:**
```
Frequency: Weekly
Day: Monday
Time: 7:00 AM WAT
Format: PDF attachment
Pages: Page 1 only (Executive Summary)
Subject: "Olist Weekly Dashboard — [Week of DATE]"
```

**Analyst Complete Report:**
```
Frequency: Weekly
Day: Friday
Time: 4:00 PM WAT
Format: Link to report (analysts need interactivity)
Pages: All pages
Subject: "Olist Dashboard — All Metrics [Week of DATE]"
```

### Email Format: PDF vs Link

| Format | What recipient receives | Best for |
|--------|------------------------|---------|
| PDF attachment | Static snapshot of selected pages | Executives, clients, offline review |
| Link to report | URL to the live interactive dashboard | Analysts, internal teams with Google accounts |

**PDF considerations:**
- PDF renders charts as static images (no interactivity)
- File size depends on dashboard complexity (typically 1-5 MB)
- High resolution setting recommended for print quality
- Works without internet access after download

**Link considerations:**
- Recipient must have Google account and Viewer access
- Dashboard is fully interactive (filters, drill-downs work)
- Always shows the most current data (or most recent Extract refresh)

### Managing Multiple Schedules

You can create multiple delivery schedules for the same dashboard:
- Share → Schedule email delivery → click the "+" icon to add a new schedule
- Each schedule can have different recipients, formats, pages, and timing
- View all active schedules under Share → Schedule email delivery → list view

---

## Export Options Reference

### Dashboard-Level Exports

| Export Type | Path | Output | Notes |
|-------------|------|--------|-------|
| PDF (all pages) | File → Download → PDF | .pdf file | All charts as static images |
| PDF (selected pages) | File → Download → PDF → Choose pages | .pdf file | Select which pages to include |
| Link sharing | Share → Manage access → Copy link | URL | Shareable link for portfolio |

### Chart-Level Exports

| Export Type | Path | Output | Notes |
|-------------|------|--------|-------|
| CSV (table data) | Hover chart → 3-dot menu → Export → CSV | .csv file | Full underlying dataset, not just visible rows |
| Google Sheets | Hover chart → 3-dot menu → Export → Google Sheets | Opens in Sheets | Creates a live Sheets connection |

**Note on CSV exports:** The CSV includes the full underlying dataset for the chart, not just the visible rows. If a table shows "Top 10" but the data has 27 states, the CSV contains all 27 rows. This is expected behavior and useful for deeper analysis.

### PDF Quality Settings

| Setting | Recommended For |
|---------|----------------|
| Standard quality | Internal team review, draft review |
| High resolution | Executive delivery, print, portfolio |

Always use High resolution for any PDF that will be viewed by stakeholders outside the class.

---

## Embedding Configuration

### Enabling Embed Code

**Path:** File → Embed report

Embedding must be explicitly enabled. By default, embedding is disabled for security.

1. File → Embed report
2. Toggle "Enable embedding" to On
3. The iframe code appears below
4. Copy the iframe HTML

### Embed Code Parameters

```html
<iframe
  width="600"
  height="450"
  src="https://lookerstudio.google.com/embed/reporting/[REPORT-ID]/page/[PAGE-ID]"
  frameborder="0"
  style="border:0"
  allowfullscreen
  sandbox="allow-storage-access-by-user-activation allow-scripts allow-same-origin
           allow-popups allow-popups-to-escape-sandbox">
</iframe>
```

| Attribute | What to Change | Options |
|-----------|----------------|---------|
| `width` | Match your container width | 600, 800, 1200, or "100%" |
| `height` | Match your dashboard height | 450, 600, 800 |
| `/page/[PAGE-ID]` | Which page to show | Remove for page 1; add `/page/[ID]` for specific pages |
| `frameborder` | Border around iframe | "0" = no border (recommended) |
| `allowfullscreen` | Allow full-screen button | Keep for user experience |

### Responsive Embed Wrapper

For portfolio websites where you want the dashboard to scale with the browser window:

```html
<div style="position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden;">
  <iframe
    src="https://lookerstudio.google.com/embed/reporting/[REPORT-ID]/page/[PAGE-ID]"
    style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;"
    frameborder="0"
    allowfullscreen
    sandbox="allow-storage-access-by-user-activation allow-scripts allow-same-origin
             allow-popups allow-popups-to-escape-sandbox">
  </iframe>
</div>
```

The `padding-bottom: 56.25%` creates a 16:9 aspect ratio. Change to `75%` for 4:3.

### Finding the Page ID

To embed a specific page (not page 1):
1. Open your dashboard in View mode
2. Navigate to the page you want
3. Look at the browser URL: `...reporting/[REPORT-ID]/page/[PAGE-ID]`
4. Copy the `[PAGE-ID]` portion (format: `p[alphanumeric]`)
5. Replace in the iframe src URL

### Google Sites Integration

Google Sites handles embedding differently — do not paste iframe code:
1. Edit your Google Site
2. Click Insert → Embed
3. Paste the Looker Studio report URL (the edit URL or shareable link)
4. Google Sites automatically converts it to an embed
5. Resize using the blue handles
6. Publish the site → test in a new browser tab

### Access Requirements for Embeds

| Dashboard Access | Who Can See Embed |
|-----------------|------------------|
| Restricted | Only users explicitly granted access |
| Anyone with the link | Anyone who views the embedding page |
| Published to web | Anyone |

For a portfolio embed to work without viewers signing into Google, the dashboard must be set to "Anyone with the link can view."

---

## Stakeholder Access Matrix

Configure access differently for each audience:

| Stakeholder | Access Method | Permission Level | Format | Credentials |
|-------------|---------------|-----------------|--------|-------------|
| Course Instructor | Direct user (email) | Viewer | Interactive | Owner's |
| Classmate Reviewer | Link sharing | Viewer | Interactive | Owner's |
| Analyst Teammate | Direct user (email) | Editor | Interactive | Owner's |
| Executive (simulated) | Scheduled email | N/A (receives PDF) | PDF attachment | Owner's |
| Portfolio Visitor | Link sharing + embed | Viewer | Interactive embed | Owner's |
| Future Employer | Link sharing | Viewer | Interactive | Owner's |

---

## Common Configurations for This Course

### Final Project Instructor Submission

```
Access Type: Direct user access
Instructor email: [as provided by instructor]
Permission: Viewer
Message: Include week, project name, key metrics covered
Credentials: Owner's
```

### Portfolio / LinkedIn Profile

```
Access Type: Link sharing
Setting: Anyone with the link can view
Permission: Viewer (implicit)
Add to: LinkedIn profile, personal website, GitHub profile README
Credentials: Owner's
Test: Verify in incognito browser window before sharing publicly
```

### Dashboard Embed (Google Sites or Portfolio Site)

```
Enable embedding: File → Embed report → Enable embedding: On
Wrapper: Use responsive CSS wrapper for mobile-friendly display
Access required: Dashboard must be "Anyone with the link" for public viewing
Caption: Include dashboard name, dataset source, and period
```

---

## Troubleshooting Quick Reference

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| Viewer sees "Request access" | Dashboard is "Restricted" — no link sharing | Share → Manage access → General access → "Anyone with the link can view" |
| Dashboard does not load in incognito | Shared the edit URL, not the shareable link | Copy link from "Manage access" dialog specifically |
| Viewer sees "No data" in charts | Viewer's credentials selected (viewer has no DB access) | Resource → Data sources → lock icon → Owner's credentials |
| Test email arrives without PDF attachment | Format was set to "Link" not "PDF attachment" | Edit schedule → Change format to "PDF attachment" |
| Email goes to spam | First delivery often treated as spam | Ask recipient to check spam; add noreply@looker-studio.com to safe senders |
| PDF shows blank chart areas | Chart is positioned partially off the canvas | Edit mode → move chart fully onto canvas area |
| Embed shows "Sign in to Google" | Dashboard is restricted | Enable "Anyone with the link can view" |
| Google Sites embed not updating | Site cached the old version | Hard refresh the Sites page (Ctrl+Shift+R) |
| Cannot create scheduled delivery | Must be in View mode, not Edit mode | Click "View" then Share → Schedule email delivery |
| "Send now" button missing | Already sent a recent test | Wait a few minutes then retry; Looker throttles test sends |

---

## Access Request Workflow

When a user encounters a restricted dashboard without access:

### From the Viewer's Perspective
1. User navigates to the dashboard URL
2. Sees "You need permission to access this report"
3. Clicks "Request access"
4. Types an optional message
5. Submits request

### From the Owner's Perspective
1. Receives an email notification: "[Name] has requested access to [Dashboard name]"
2. Clicks "Review access request" in the email
3. Opens Looker Studio access management panel
4. Selects permission level (Viewer or Editor)
5. Clicks "Approve"
6. Requestor receives email confirmation and can now access the dashboard

### When to Use Access Request Workflow
- When a dashboard should be accessible to known users but not the general public
- When you want to log who has requested access (vs anonymous link sharing)
- Internal company dashboards where all viewers have Google accounts

### When NOT to Use Access Request Workflow
- Portfolio dashboards for public viewing (use link sharing instead)
- Executive dashboards where recipients do not have Google accounts
- Any dashboard with large, unknown audiences

---

**Reference Version:** Week 16 Production Dashboards | March 2026
**Applicable to:** Google Looker Studio (current UI as of early 2026)
