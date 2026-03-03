# Exercise 1: Sharing and Permissions Configuration

## Week 16 - Thursday - Exercise 1

### Estimated Time: 25 minutes

---

## Objective

Configure appropriate sharing and permissions for your Olist executive dashboard to serve three different stakeholder groups. You will implement controlled access for executives, set up instructor access for grading, configure scheduled email delivery, and prepare the dashboard for portfolio embedding.

---

## Prerequisites

Before starting, ensure you have:
- ✅ Completed Wednesday exercises (Performance Audit + Data Quality Validation)
- ✅ Your optimized dashboard is published and accessible in Looker Studio
- ✅ Completed Thursday Lectures 1 and 2 (Sharing Permissions + Scheduled Delivery)
- ✅ You have a Google account (required for all Looker Studio operations)

---

## Business Context

**Your Role:** Senior BI Analyst completing the production deployment of the Olist executive dashboard.

**Stakeholder Map for This Exercise:**

| Stakeholder | Role | Access Need | Technical Level |
|-------------|------|------------|-----------------|
| Course Instructor | Dashboard evaluator | Can view all pages, cannot edit | Non-technical viewer |
| Future Employer / Recruiter | Portfolio reviewer | Can view executive summary, cannot edit | Non-technical viewer |
| Data Analyst Teammate | May need to maintain dashboard | Can view AND edit | Technical |
| Executive Team (simulated) | Weekly review recipients | Receive PDF by email, no login needed | Non-technical viewer |

Your task is to configure access appropriately for each stakeholder group.

---

## Instructions

### Part 1: Verify Your Dashboard Is Ready to Share

Before configuring access, confirm the dashboard is share-ready:

#### Task 1.1: Check Data Source Credentials

1. Open your dashboard in Looker Studio
2. Navigate to **Resource** → **Manage added data sources**
3. For each data source, click the lock icon (credentials)
4. Confirm it is set to **"Owner's credentials"** (not "Viewer's credentials")
5. If not, change to Owner's credentials and save

**Why this matters:** Viewers do not have Supabase database accounts. Owner's credentials allow the dashboard to query the database on everyone's behalf.

**Record:**
```
Data Source 1 credentials: Owner's / Viewer's (circle one)
Data Source 2 credentials (if applicable): Owner's / Viewer's (circle one)
Action taken: _____________________________________________
```

#### Task 1.2: Verify All Charts Load Correctly

1. Exit Edit mode (click "View")
2. Click through all pages of your dashboard
3. Confirm all charts show data (no "No data" or "Loading..." messages)
4. If any charts fail to load, resolve before sharing

**Record:**
```
Number of pages checked: _____
All charts loading: Yes / No
Issues found and resolved: ___________________________________
```

---

### Part 2: Configure Access for Each Stakeholder Group

#### Task 2.1: Set Up Instructor Access (Specific User)

Share the dashboard directly with your instructor's Google account so they can evaluate your work.

1. Click **Share** (top right of your dashboard)
2. Click **"Manage access"**
3. In the "People" field, type: **[your instructor's email address]**
4. Set permission: **Viewer**
5. Add a message:
   ```
   Hi [Instructor name],

   My Week 16 Final Project dashboard is now ready for review.
   I have configured it with optimized data sources, CLV segmentation,
   delivery performance analysis, and MoM revenue tracking.

   Please let me know if you need any clarification on the data quality
   findings documented in the last page.

   Best regards,
   [Your name]
   ```
6. Click **Send**

**Record:**
```
Instructor access configured: Yes / No
Instructor email added: ____________________________________
Permission level: Viewer
Message sent: Yes / No
```

#### Task 2.2: Set Up Portfolio / Recruiter Access (Link Sharing)

For anyone who visits your portfolio (recruiters, employers, classmates):

1. Click **Share** → **"Manage access"**
2. Under "General access", click the dropdown
3. Select: **"Anyone with the link can view"**
4. Copy the shareable link
5. Save this link — you will need it for your portfolio

**Record:**
```
Link sharing configured: Yes / No
Shareable link copied: Yes / No
Shareable link: ____________________________________________
(Save this — you will use it in Exercise 2)
```

#### Task 2.3: Set Up Analyst Teammate Access (Editor)

For someone who would maintain the dashboard after you:

**Note:** For this exercise, add your own second email address (if you have one) or a classmate who agrees to be your "analyst teammate." This demonstrates the Editor permission level.

1. Click **Share** → **"Manage access"**
2. Add the teammate's email
3. Set permission: **Editor**
4. Add a message:
   ```
   You have Editor access to this dashboard.
   Please review the documentation page before making any changes.
   Key note: always use payment_value (not price+freight) for revenue metrics.
   ```
5. Click **Send**

**Record:**
```
Analyst teammate access configured: Yes / No
Teammate email: _____________________________________________
Permission level: Editor
Documentation note included in message: Yes / No
```

#### Task 2.4: Verify the Access Levels

Open a new browser tab in **incognito mode** (Ctrl+Shift+N or Cmd+Shift+N):

1. Paste your shareable link from Task 2.2
2. Confirm you can view the dashboard without signing in
   - If prompted to sign in: go back and verify the link is set to "Anyone with the link"
   - If dashboard loads directly: link sharing is correctly configured

**Record:**
```
Incognito test result: Dashboard loads / Prompted to sign in (circle one)
Link sharing working correctly: Yes / No
```

---

### Part 3: Set Up Scheduled Email Delivery

Configure automated email delivery to simulate the executive reporting workflow.

#### Task 3.1: Create Weekly Executive Email Schedule

1. Open your dashboard (must be in View mode)
2. Click **Share** → **"Schedule email delivery"**
3. Configure:

**Recipients:** Your own email address (simulating executive delivery)
```
Recipients: [your own email]
```

**Subject:**
```
Olist Executive Dashboard — Weekly Performance Summary
```

**Message body:**
```
Your weekly Olist performance dashboard is ready.

This week's headline:
- Revenue: Check MoM trend for August 2018 (-4.13% vs July)
- Delivery: 92% of orders arrived On Time vs estimated date
- Top category: cama_mesa_banho (Bed & Bath) — $1.7M revenue

View the full interactive dashboard using the link above,
or see the attached PDF for an offline-friendly summary.

Questions? Contact: [Your name] | [Your email]
```

**Frequency:** Weekly
**Day:** Monday
**Time:** 7:00 AM
**Format:** PDF (simulating executive preference for offline review)
**Pages:** Page 1 only (Executive Summary)

4. Click **"Save"**
5. Click **"Send now"** to send yourself a test copy immediately

**Record:**
```
Scheduled delivery configured: Yes / No
Recipients: _________________________________________________
Frequency: Weekly | Day: Monday | Time: 7:00 AM
Format: PDF | Pages: Page 1 only
Test email sent ("Send now"): Yes / No
Test email received in inbox: Yes / No
```

#### Task 3.2: Review the Test Email

After clicking "Send now":

1. Check your email inbox (allow 1-5 minutes for delivery)
2. Open the email and verify:
   - Subject line is correct
   - Your message body appears
   - Either a PDF attachment or a link to the dashboard is included
   - The email looks professional (you would be comfortable sending this to an actual executive)

**Record:**
```
Email received: Yes / No
Subject correct: Yes / No
PDF attached or link included: Yes / No
Email looks professional: Yes / No
What would you change about the email format?
_______________________________________________________________
```

#### Task 3.3: Create a Second Schedule for Analyst Access (Optional)

For completeness, create a second schedule for the analyst team with different settings:

**Recipients:** Your email (simulating analyst)
**Subject:** "Olist Dashboard — All Metrics (Weekly)"
**Frequency:** Weekly | Day: Friday | Time: 4:00 PM
**Format:** Link to dashboard (analysts need full interactivity)
**Pages:** All pages

This demonstrates that different audiences receive different formats on different schedules.

**Record:**
```
Second schedule created: Yes / No
Format difference from executive schedule: _______________________
```

---

### Part 4: Export a PDF Snapshot

In addition to scheduled delivery, practice manual PDF export for ad-hoc sharing.

#### Task 4.1: Export Full Dashboard as PDF

1. Open your dashboard in View mode
2. Click **File** → **Download** → **PDF**
3. Configure:
   - Pages: All pages
   - Quality: High resolution
4. Click **Download**
5. Open the downloaded PDF and verify:
   - All pages are included
   - Charts are readable (not blurry or cut off)
   - Text is legible at standard zoom

**Record:**
```
PDF downloaded: Yes / No
All pages included: Yes / No
Charts readable in PDF: Yes / No
Any pages that look poor in PDF: ___________________________________
```

#### Task 4.2: Export Executive Summary Page Only

1. File → Download → PDF
2. Configure: Pages → "Selected pages" → Select Page 1 only
3. Download

This is the format you would send to executives who want a single-page summary.

**Record:**
```
Executive summary PDF: 1 page / Multiple pages
File size: approximately _____ MB
```

---

### Part 5: Export Individual Chart Data

Demonstrate that individual chart data can be extracted for further analysis.

#### Task 5.1: Export Revenue Table Data to CSV

1. Navigate to a page with a data table (monthly revenue by state, or similar)
2. Hover over the table chart
3. Click the three-dot menu (top right of the chart)
4. Select **"Export"** → **"CSV"**
5. Open the CSV in Excel or a text editor
6. Verify the data matches what the table shows in the dashboard

**Record:**
```
CSV export successful: Yes / No
Data matches dashboard table: Yes / No
Number of rows exported: _____
```

---

## Submission Checklist

```
PERMISSIONS
☐ Data source credentials set to "Owner's credentials"
☐ All charts load in View mode (verified)
☐ Instructor access configured as Viewer with message
☐ Link sharing configured: "Anyone with the link can view"
☐ Shareable link saved and recorded
☐ Analyst teammate access configured as Editor
☐ Incognito test passed (dashboard loads without login)

SCHEDULED DELIVERY
☐ Weekly executive email schedule created
   - Recipients: own email
   - Frequency: Weekly Monday 7 AM
   - Format: PDF
   - Pages: Page 1 only
☐ Test email sent ("Send now")
☐ Test email received and reviewed
☐ Email content looks professional

EXPORTS
☐ Full dashboard PDF downloaded (all pages, high resolution)
☐ Executive summary PDF downloaded (Page 1 only)
☐ CSV data exported from at least one chart
☐ CSV data verified against dashboard display
```

---

## Troubleshooting

### Issue 1: Test email not arriving in inbox

**Solution:**
- Check your spam/junk folder
- Allow up to 10 minutes after clicking "Send now"
- Verify the email address in the Recipients field is correct
- Try a different email address (sometimes Gmail blocks automated Looker Studio emails initially)

### Issue 2: Incognito access requires sign-in despite "Anyone with link" setting

**Solution:**
- Double-check: Share → Manage access → General access must be "Anyone with the link can view" (not just "Restricted + link")
- Clear the link from memory — the old link may have been copied before the permission change
- Copy a fresh link from the "Manage access" dialog after changing the setting

### Issue 3: PDF is missing charts or shows blank spaces

**Solution:**
- The PDF renders what is visible on the canvas — if a chart is positioned off-canvas or partially clipped, it will appear blank in PDF
- In Edit mode, verify all charts are fully within the canvas boundaries (no charts hanging off the edge)
- Try "High resolution" quality setting instead of standard

### Issue 4: CSV export shows more rows than expected

**Explanation:** The CSV export includes the full underlying dataset for the chart, not just the visible rows. If the table shows top 10 rows but the underlying data has 27 states, the CSV will contain all 27 rows. This is expected behavior and is actually useful for deeper analysis.

---

## Expected Outcomes

After completing this exercise, your dashboard should be configured as follows:

```
SHARING CONFIGURATION
┌────────────────────────────────────────────────────┐
│ Share Settings                                     │
├────────────────────────────────────────────────────┤
│ Owner: [Your name/email] — Full control            │
│                                                    │
│ Editor: [Analyst teammate email]                   │
│   → Can modify charts and calculated fields        │
│                                                    │
│ Viewer: [Instructor email]                         │
│   → View only, cannot edit                         │
│                                                    │
│ General Access: Anyone with link → Viewer          │
│   → Portfolio-ready, no login required             │
└────────────────────────────────────────────────────┘

SCHEDULED DELIVERY
┌────────────────────────────────────────────────────┐
│ Schedule 1: Executive Summary (PDF)                │
│   Frequency: Weekly Monday 7:00 AM                 │
│   Recipients: [your email]                         │
│   Pages: Page 1 only                               │
│   Status: Active                                   │
└────────────────────────────────────────────────────┘
```

---

## How to Know You Succeeded

✅ **Permissions test:** Three access configurations are in place (Viewer, Editor, Link sharing)

✅ **Credentials test:** Data source uses Owner's credentials — viewers see data without needing Supabase access

✅ **Delivery test:** You received a test email with PDF attachment showing your executive summary page

✅ **Public access test:** Dashboard opens in incognito mode without requiring a Google sign-in

✅ **Export test:** CSV download contains the correct data matching what the chart displays

---

## Reflection Questions

1. **Why is the "Owner's credentials" setting important for a dashboard shared with non-technical executives?**

2. **You have configured both a shareable link AND direct user access for your instructor. What is the practical difference between these two access methods?**

3. **The scheduled email sends a PDF of Page 1 only. What is the business rationale for this choice rather than sending all pages?**

4. **A new analyst joins the team and asks: "Can I just use the shareable link to access the dashboard?" They want to be able to edit charts. Can they? What would you need to do?**

5. **You are presenting at a client meeting and the internet goes down. Which of the assets you created in this exercise saves your presentation?**

---

## Next Steps

Once completed:
1. **Save your shareable link** — you will need it for Exercise 2 and your Final Project submission
2. **Check your email** for the test delivery (verify it looks professional)
3. **Proceed to Exercise 2** — Production Deployment (embedding + documentation)

---

## Additional Challenge (Optional)

### Challenge 1: Configure Access Request Workflow

1. Open a new incognito window
2. Navigate to your dashboard's URL (the edit URL, not the shareable link)
3. Click "Request access"
4. Note the process a stakeholder goes through
5. Check your inbox for the access request notification
6. Approve the request with Viewer access from your email

Document the steps a stakeholder takes when they encounter a "restricted" dashboard.

### Challenge 2: Test Different Email Formats

Send yourself three versions of the scheduled email:
1. "Link to report" format — see how an interactive link email looks
2. "PDF attachment" format — see how the PDF email looks
3. Compare: which is more professional for executives? Which is more useful for analysts?

Write a 3-sentence recommendation on when to use each format.

---

**Instructor Note:** The incognito test (Task 2.4) is crucial and often overlooked by students. Many students configure "Anyone with the link can view" but then share the report URL (not the shareable link). The report URL requires authentication even with link sharing enabled — only the specific shareable link URL from the "Manage access" dialog bypasses authentication. Run this test as a class to reinforce the distinction.
