# Scheduled Delivery and Export Options

## Week 16 - Thursday Session - Part 2

### Duration: 15 minutes

---

## What Is Scheduled Delivery?

**Scheduled delivery** is a Looker Studio feature that automatically sends your dashboard to a list of recipients on a defined schedule — daily, weekly, or monthly — without anyone needing to remember to open the dashboard or share it manually.

For a BI analyst, scheduled delivery transforms a dashboard from a passive tool (one that people visit when they remember) into an active communication tool (one that proactively delivers insights to stakeholders' inboxes on schedule).

### Why This Matters for Professional BI Work

**Without scheduled delivery:**
- Stakeholders must remember to check the dashboard
- Important trends get missed between check-ins
- You receive ad-hoc requests: "Can you send me this week's numbers?"
- Data-driven decisions are delayed because people do not have data

**With scheduled delivery:**
- Stakeholders receive insights in their inbox every Monday morning before the team meeting
- Trends and anomalies are surfaced automatically
- Your dashboard becomes embedded in the weekly business rhythm
- You are positioned as a proactive data partner, not a reactive request handler

---

## Setting Up Scheduled Email Delivery

### Step-by-Step Configuration

1. Open your published Looker Studio report (must be in View mode, not Edit mode)
2. Click **Share** button (top right)
3. Click **"Schedule email delivery"**

[Screenshot: Looker Studio Share menu with "Schedule email delivery" option highlighted]

4. In the delivery configuration panel, set:

**Recipients:**
- Type email addresses separated by commas
- You can use Google Groups for team distributions
- Recipients do not need Looker Studio accounts (they receive a PDF attachment or a link)

**Subject:**
- Default: report name + date
- Custom: "Olist Executive Dashboard — Weekly Update"
- Best practice: include the date dynamically if possible, or add the cadence ("Weekly")

**Message:**
- Optional body text that appears before the dashboard link
- Example: "This week's Olist performance summary is attached. Key metrics: Revenue, AOV, and delivery performance. Questions? Contact: [your name]."

**Frequency:**
- Daily, Weekly, or Monthly

**Day (for Weekly):**
- Monday is typical for business reviews (data is ready at start of week)
- Friday is appropriate for end-of-week summaries

**Time:**
- Best practice: early morning (6:00-8:00 AM) so stakeholders receive the report before their morning meeting
- Account for recipient time zones if your audience is distributed

**Format:**
- **Link to report:** Recipients receive a URL that opens the live interactive dashboard. Best for stakeholders who want to explore interactively.
- **PDF attachment:** Recipients receive a static snapshot of the dashboard. Best for executives who prefer printable formats, or stakeholders without Google accounts.
- Choosing both (one email with link + PDF) is possible in advanced configurations

**Pages:**
- "All pages" — sends every page of your multi-page report
- "Selected pages only" — choose which pages to include. Best for executive summaries where you want to send only Page 1 (executive summary) without the detailed data explorer pages

5. Click **"Save"** to create the schedule

6. Click **"Send now"** to test the delivery before the first scheduled send

[Screenshot: Looker Studio scheduled delivery configuration panel showing all options]

---

## Email Delivery Best Practices

### Timing Recommendations

| Audience | Best Day | Best Time | Why |
|----------|----------|-----------|-----|
| Executive weekly review | Monday | 7:00 AM | Ready before Monday morning team meeting |
| Operations daily check | Every day | 6:30 AM | Before shift starts |
| Finance monthly report | 1st of month | 8:00 AM | Available for month-end review meetings |
| Marketing weekly review | Friday | 4:00 PM | End-of-week summary before weekend |

### Format Recommendations

| Stakeholder Type | Recommended Format |
|-----------------|-------------------|
| C-suite executives | PDF attachment (printable, no interaction required) |
| Operations managers | Link to report (need to filter by region/team) |
| Technical analysts | Link to report (need full interactivity) |
| External clients | PDF (they may not have Google accounts) |

### What to Include in the Email Body

Write a 2-3 sentence summary that gives the key insight even before the recipient opens the dashboard:

```
Subject: Olist Weekly Dashboard — Week of Mar 3, 2026

Message:
Revenue this week: $985K (↓4.13% vs last week).
Key issue: Delivery delays remain at 75%+ in Southeast region,
correlating with review score decline (3.8★ vs 4.2★ target).
This week's recommended action: Logistics partner audit (see Page 2).

View interactive dashboard: [auto-inserted link]
```

This summary means stakeholders get value from the email even without opening the dashboard.

---

## PDF Export and Printing Options

Beyond scheduled delivery, Looker Studio provides manual export options for one-time sharing.

### Downloading as PDF

1. Open your report in View mode
2. Click **File** → **Download** → **PDF**
3. Configure:
   - **Pages:** All pages, or specific pages
   - **Layout:** Use report layout (respects your canvas size)
   - **Quality:** Standard or High resolution

[Screenshot: Looker Studio File menu with Download → PDF options]

**When to use PDF download:**
- One-time exports for a specific meeting
- Sending a snapshot before presenting (a backup in case internet fails during presentation)
- Archiving a monthly or quarterly snapshot of performance
- Sharing with recipients who do not have Google accounts

### Printing Directly

1. File → Print
2. Looker Studio opens a print preview in the browser
3. Select: all pages or specific pages
4. Configure print settings (paper size, orientation)

**Best practice for printing:** Use landscape orientation for most dashboards. Dashboards are wider than tall. Portrait often cuts off charts.

### Exporting Chart Data

Individual chart data can be exported without exporting the whole dashboard:

1. Hover over any chart
2. Click the three-dot menu (top right of chart)
3. Select **"Export"**
4. Choose format: **CSV** or **Google Sheets**

[Screenshot: Chart hover state showing three-dot menu with Export option]

**When useful:** A stakeholder wants the raw data behind a specific chart (for example, the top 10 customers table) to paste into their own report.

---

## Managing Multiple Schedules

As you build multiple dashboards, you will have multiple delivery schedules to manage. Stay organized:

### Finding All Your Schedules

1. Open the report
2. Share → "Schedule email delivery"
3. Any existing schedules appear at the top
4. Click a schedule to edit or delete it

### Editing or Pausing a Schedule

- Click the schedule name → Edit any setting → Save
- To pause temporarily: edit the schedule → set frequency to "None" → Save
- To delete permanently: click the trash icon next to the schedule

### Coordinating Schedules Across Dashboards

For the Olist project, a professional setup would be:

```
Executive Dashboard (weekly, Monday 7 AM, PDF, Page 1 only)
    → Recipients: Executive team, instructor

Operations Dashboard (daily, 6:30 AM, Link)
    → Recipients: Operations team

Marketing Dashboard (weekly, Monday 7 AM, Link, All pages)
    → Recipients: Marketing team
```

---

## Connection to Final Project Requirements

The Final Project requires "Configured sharing with appropriate permission levels" and "Scheduled email report" as part of the Sharing & Documentation criterion (10% of grade).

**Minimum required for full marks:**
1. Dashboard accessible via shareable link (Viewer access)
2. At least one scheduled email delivery configured (can be sent to yourself for demonstration)
3. Evidence of PDF export capability (submit PDF with your project)

**Above and beyond:**
- Multiple delivery schedules for different audiences
- Customized email body with summary insight
- Separate schedules for executive summary (PDF) vs analyst access (link)

---

## Common Issues and Solutions

| Issue | Symptom | Solution |
|-------|---------|---------|
| "Schedule" option is grayed out | Cannot click schedule button | Report must be published/shared — you cannot schedule from a draft |
| Recipients not receiving emails | Emails scheduled but not delivered | Check spam folders; verify email addresses are Google accounts or valid addresses |
| PDF looks different from dashboard | Fonts or charts cut off in PDF | Resize canvas to fit A4 or letter dimensions before exporting |
| Schedule sends at wrong time | Delivery arrives too late or early | Check time zone setting in schedule — Looker Studio uses the owner's Google account timezone |
| Too many recipients bounce | Delivery failure to some addresses | Break large recipient lists into multiple schedules; use Google Groups for distribution lists |

---

## Key Takeaways

### What You Learned
1. ✅ Scheduled delivery sends dashboards automatically to stakeholders on a defined schedule
2. ✅ Link delivery is best for interactive stakeholders; PDF is best for executives or those without Google accounts
3. ✅ Schedule early morning deliveries so reports arrive before morning meetings
4. ✅ Include a 2-3 sentence summary in the email body — value delivered even without clicking
5. ✅ Individual chart data can be exported to CSV or Google Sheets via the three-dot chart menu
6. ✅ Final Project requires at least one scheduled email delivery and PDF export capability

### What's Next
In the next session, you learn how to embed your dashboard in external websites — the capability that turns your Looker Studio report into a portfolio piece visible to employers.

### Skills Building Progression

```
Week 16 Part 1: Sharing & Permissions ✓
Week 16 Part 2: Scheduled Delivery & Exports (Now)
         ↓
Week 16 Part 3: Embedding & Integration
         ↓
Week 16 Part 4: Maintenance & Documentation
```

---

## Quick Reference Card

### Scheduled Delivery Configuration

```
Share → Schedule email delivery
├─ Recipients: comma-separated emails
├─ Subject: "Dashboard Name — Week of [date]"
├─ Message: 2-3 sentence summary with key insight
├─ Frequency: Weekly / Daily / Monthly
├─ Day/Time: Monday 7:00 AM (executive review)
├─ Format: PDF (exec) or Link (operations)
└─ Pages: Page 1 only (exec) or All (analyst)
```

### Export Quick Steps

```
PDF: File → Download → PDF → Select pages
Print: File → Print → Landscape orientation
Chart data: Hover chart → Three dots → Export → CSV/Sheets
```

---

## Questions to Test Your Understanding

1. Your CFO says they prefer to review reports offline during their commute. What delivery format should you choose, and why?
2. You have 50 marketing team members who all need the weekly dashboard. What is the most efficient way to configure recipients?
3. You configure scheduled delivery for Monday at 7:00 AM but the CFO is in New York (EST) and you are in Lagos (WAT). What time zone should you use in the schedule setting?
4. A stakeholder emails to say they received the dashboard email but it showed last week's numbers, not this week's. What is the most likely cause?
5. For your Final Project, you need to demonstrate scheduled delivery. You do not have a real stakeholder audience. How can you demonstrate this feature?

**Answers at the end of lecture notes**

---

## Answers to Questions

1. **CFO format choice:** PDF attachment. The CFO wants to review offline — a link requires internet and a browser. A PDF can be downloaded in advance and read on a plane or subway. Use "High resolution" setting for professional presentation quality.
2. **50 marketing recipients:** Create a Google Group (a distribution list like marketing-team@yourdomain.com) and add all 50 members to the group. Then add the group email address as the single recipient in Looker Studio. When you need to add or remove team members, you manage the Google Group — not the Looker Studio schedule.
3. **Time zone:** Set the schedule to 7:00 AM EST (UTC-5). Since Looker Studio uses the owner's Google account timezone, if your account is set to WAT (UTC+1), you would set the schedule for 1:00 PM WAT — which converts to 7:00 AM EST for the CFO.
4. **Stale data in email:** The most likely cause is that the scheduled email delivery ran before the data extract refresh completed. The schedule sequence should be: (1) Extract refresh runs (e.g., Sunday 6 AM), (2) Scheduled email delivery runs 2 hours later (Sunday 8 AM). If both are set to the same time, the email may send with the previous extract's data.
5. **Self-demonstration:** Configure the schedule to send to your own email address (the one registered with your Google account). On the day of your presentation, forward the received email to your instructor or display it on screen to demonstrate the feature. Alternatively, use "Send now" to send yourself a copy during the presentation itself.

---

**Next Lecture:** 03_embedding_integration.md
