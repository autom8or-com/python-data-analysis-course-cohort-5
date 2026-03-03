# Sharing and Permissions in Google Looker Studio

## Week 16 - Thursday Session - Part 1

### Duration: 15 minutes

---

## What Is Access Control in Looker Studio?

**Access control** determines who can view, edit, or own your Looker Studio reports and the underlying data sources that power them. In a professional environment, sharing a dashboard incorrectly can expose confidential business data to the wrong people — or lock the right people out when they need it most.

Unlike a spreadsheet you email to colleagues, a Looker Studio dashboard has two layers of access to manage:

1. **The report itself** — who can see and interact with the dashboard
2. **The data source** — who can access and modify the underlying database connection

Both layers must be configured correctly for your dashboard to work as intended in production.

### Connection to Prior Learning

In Weeks 13-15 you built dashboards primarily for your own use. Today you complete the production cycle by making them accessible to the right stakeholders, with the right level of control. This mirrors the real-world handover process every BI analyst goes through when deploying a dashboard to business users.

---

## Permission Levels Explained

Looker Studio has three permission levels for reports, each with distinct capabilities.

### Viewer

**What they can do:**
- View all dashboard pages
- Apply temporary filter changes (filters reset when they leave)
- Use interactive controls (date pickers, dropdown filters)
- Export visible data from charts to CSV or Google Sheets
- View embedded dashboards on external websites

**What they cannot do:**
- Modify chart configurations
- Add or remove charts
- Change the data source
- Edit calculated fields
- Modify sharing settings

**Who gets Viewer access:** External stakeholders, executives who review but do not build, clients, and any audience who needs read-only access.

---

### Editor

**What they can do:** Everything a Viewer can, plus:
- Add, modify, or delete charts and pages
- Create and edit calculated fields
- Add filters and controls
- Change chart types and styling
- Add data sources and blend data
- Modify page layout and canvas size
- Copy or move charts between pages

**What they cannot do:**
- Delete the report
- Change ownership
- Manage sharing settings (unless also owner)

**Who gets Editor access:** Your data analytics teammates, a dashboard co-developer, or a technically capable stakeholder who needs to create their own views.

---

### Owner

**What they can do:** Everything an Editor can, plus:
- Delete the report permanently
- Transfer ownership to another user
- Manage all sharing settings
- Revoke access from any user
- Set report-level credentials

**Who is the Owner:** Typically the dashboard's creator. In a team setting, designate one primary owner per dashboard.

---

## Sharing Methods

### Method 1: Share with Specific Users

Share directly with named Google accounts — the most controlled and secure method.

**How to share:**
1. Open your report
2. Click the **Share** button (top right)
3. Click **"Manage access"**
4. In the "People" field, type the recipient's Google email address
5. Set permission level: **Viewer** or **Editor**
6. Add a message (optional)
7. Click **Send**

[Screenshot: Looker Studio share dialog with email input field and permission dropdown]

**Best practice:** Always start with Viewer access. Upgrade to Editor only if requested and needed.

---

### Method 2: Link Sharing

Generate a shareable link that works for anyone who has it — no need to enter individual email addresses.

**How to configure:**
1. Click **Share** → **Manage access**
2. Under "General access", click the dropdown (currently "Restricted")
3. Select one of:
   - **Restricted:** Only people you specifically add can access
   - **Anyone with the link (Viewer):** Any Google account holder who has the link can view
   - **Anyone with the link (Editor):** Any Google account holder can edit (use with caution)
4. Copy the link and share via email, Slack, or any other channel

[Screenshot: Looker Studio "General access" dropdown showing Restricted vs Link sharing options]

**When to use link sharing:**
- Sharing with a large group where individual email management is impractical
- Publishing a dashboard for a class or team where everyone has a Google account
- Sharing a portfolio dashboard with potential employers

**Warning:** Anyone who receives the link can forward it to others. Use "Restricted" sharing for sensitive business data.

---

### Method 3: Publish to Web (Public Access)

Make your dashboard publicly accessible — no Google account required.

**How to configure:**
1. Click **Share** → **Manage access**
2. Under "General access", select **"Public on the web"**
3. Choose **"Anyone can view"**
4. The report is now accessible to anyone with the URL, including non-Google users

**When to use:**
- Portfolio dashboards you want to share with anyone
- Public-facing business reports
- Educational examples with no sensitive data

**Never use for:** Dashboards containing personally identifiable information, confidential revenue data, or any data subject to privacy regulations.

---

## Data Source Credentials and Viewer Access

A critical and often-missed configuration: the data source can be set to use **owner credentials** or **viewer credentials**.

### Owner Credentials (recommended for most cases)

The dashboard queries the database using the owner's Supabase credentials. All viewers see the same data, regardless of whether they have database access themselves.

**Use when:** You want to control data access at the dashboard level. Viewers should not need their own database accounts.

**How to set:**
1. Edit data source → Resource menu → "Manage added data sources"
2. Click the data credentials (lock icon)
3. Select **"Owner's credentials"**

### Viewer Credentials

Each viewer must have their own database credentials. The dashboard queries the database using whoever is viewing it.

**Use when:** Different viewers should see different data (for example, regional managers who should only see their region).

**Note:** For the Olist student project, use Owner's credentials. Viewers do not have Supabase access and should not need it.

---

## Access Request Workflow

When someone tries to access a report they do not have permission for, Looker Studio shows a "Request Access" button. The owner receives an email notification and can approve or deny.

**As an owner, when you receive an access request:**
1. Open the email notification from Google
2. Review who is requesting access and why
3. Click "Share" in the notification email, or open the report → Share → Manage access
4. Find the pending request
5. Set the appropriate permission level
6. Click "Share"

**For your Final Project:** Your instructor will request Viewer access to your dashboard. Ensure you have configured link sharing so the instructor can access it without needing individual approval.

---

## Best Practices for Stakeholder Access Management

### The Minimum Necessary Access Principle

Always grant the least permissive access level that allows the stakeholder to do their job:

```
Stakeholder type → Appropriate access
Executive reviewing KPIs → Viewer
Marketing manager wanting to explore → Viewer
Data analyst co-building → Editor
Dashboard maintainer after handover → Editor or Owner
```

### Organizing Access for Presentations

For your Week 16 Final Project presentation:

1. **Before class:** Set your report to "Anyone with the link can view"
2. **Share the link** in the class chat when presenting
3. **After class:** Return to "Restricted" if you want to limit access

### Revoking Access

When a project ends or a stakeholder no longer needs access:
1. Share → Manage access
2. Find the person's entry
3. Click the permission dropdown next to their name
4. Select **"Remove access"**

---

## Quick Reference: Permission Levels

| Capability | Viewer | Editor | Owner |
|-----------|--------|--------|-------|
| View dashboard | ✅ | ✅ | ✅ |
| Apply temporary filters | ✅ | ✅ | ✅ |
| Export chart data to CSV | ✅ | ✅ | ✅ |
| Edit charts and styling | ❌ | ✅ | ✅ |
| Add / remove data sources | ❌ | ✅ | ✅ |
| Create calculated fields | ❌ | ✅ | ✅ |
| Manage sharing settings | ❌ | ❌ | ✅ |
| Delete the report | ❌ | ❌ | ✅ |
| Transfer ownership | ❌ | ❌ | ✅ |

---

## Common Issues and Solutions

| Issue | Symptom | Solution |
|-------|---------|---------|
| "Request access" error for viewer | Viewer cannot open report | Check "General access" is not set to "Restricted" — change to "Anyone with link" |
| Data not loading for viewer | Charts show "Loading" but never render | Data source is using Viewer credentials but viewer has no Supabase account — switch to Owner credentials |
| Editor accidentally deletes chart | Chart removed from dashboard | Use Ctrl+Z to undo, or check version history (File → Version history) |
| Owner left the organization | No one can manage sharing | Google Workspace admin can transfer ownership; for personal accounts, add a second owner proactively |

---

## Key Takeaways

### What You Learned
1. ✅ Three permission levels: Viewer (read-only), Editor (modify), Owner (full control)
2. ✅ Data source credentials are separate from report permissions — configure Owner's credentials for shared dashboards
3. ✅ Link sharing is appropriate for large groups; direct sharing is more controlled
4. ✅ Minimum necessary access principle: always start with Viewer, upgrade only when needed
5. ✅ For your Final Project: set "Anyone with link can view" before submitting the dashboard URL

### What's Next
In the next session, you set up scheduled email delivery — so stakeholders receive your dashboard automatically, on a schedule, without needing to remember to check.

### Skills Building Progression

```
Week 16 Part 1: Sharing & Permissions (Now)
         ↓
Week 16 Part 2: Scheduled Delivery & Exports
         ↓
Week 16 Part 3: Embedding & Integration
         ↓
Week 16 Part 4: Maintenance & Documentation (Final)
```

---

## Questions to Test Your Understanding

1. A colleague needs to add a new page to your dashboard. What permission level do they need?
2. You share a dashboard link with a client. The client forwards the link to five colleagues. Can those five colleagues view the dashboard without you doing anything? What permission setting determines this?
3. Why would you configure a data source to use "Owner's credentials" rather than "Viewer's credentials"?
4. An executive says they can view the dashboard but cannot apply a date filter. What is most likely wrong?
5. You are about to hand a dashboard over to a new team member. What permission level should they have? What should you verify before completing the handover?

**Answers at the end of lecture notes**

---

## Answers to Questions

1. **Editor permission:** Adding a page requires chart and layout editing capability, which is an Editor-level action.
2. **Link sharing determines this:** If the link is set to "Anyone with the link can view," the five forwarded colleagues can access it without any action from you. If it is "Restricted," they would see a "Request access" screen. This is why link sharing must be used carefully with confidential data.
3. **Owner's credentials rationale:** Viewers may not have Supabase database accounts. If Viewer credentials are used, the dashboard queries the database as the viewer — who has no access — resulting in empty charts. Owner's credentials allow the dashboard to query the database on behalf of all viewers using the owner's authenticated connection.
4. **Filter issue:** Date filters in Looker Studio work for both Viewers and Editors. If the executive cannot apply a filter, the most likely causes are: (a) the date filter control is not on the page, (b) the control is there but the executive is not interacting with it correctly (it requires clicking "Apply" for some filter types), or (c) the control only affects one chart, not all charts — check the filter's scope settings.
5. **Handover:** The new team member likely needs Editor access to maintain and update the dashboard. Before completing handover: (1) verify they can open and see all pages, (2) confirm they can edit charts (test with a non-destructive change), (3) share the documentation and maintenance guide with them, (4) consider making them a co-owner if you are leaving the organization.

---

**Next Lecture:** 02_scheduled_delivery_exports.md
