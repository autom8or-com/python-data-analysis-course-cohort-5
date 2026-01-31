# Collaboration & Version Control - Managing Dashboard Projects

**Week 14 - Thursday Session | Part 4 (15 minutes)**
**Business Context:** Professional dashboard management with team collaboration, version control, and stakeholder sharing

---

## Learning Objectives

By the end of this section, you will be able to:
- Share dashboards with appropriate permissions (view, edit, comment)
- Set up scheduled email delivery for automated reporting
- Create shareable links with access controls
- Use version history to track changes and revert if needed
- Collaborate with teammates on dashboard development
- Embed dashboards in websites and presentations
- Manage dashboard lifecycle (development → staging → production)
- Document dashboards for handoff and maintenance

---

## Why Collaboration & Version Control Matter

### The Solo Dashboard Problem

**Scenario:** You build a dashboard alone, no collaboration

**Problems That Arise:**
1. **Lost Work:** Accidental deletion, no backup
2. **Conflicting Edits:** Two people edit simultaneously, changes overwrite
3. **No Audit Trail:** "Who changed the revenue formula?" (nobody knows)
4. **Access Issues:** Stakeholders can't view dashboard (wrong permissions)
5. **No Handoff:** You go on leave, nobody can maintain dashboard

**Nigerian Business Example:**
- Analyst builds sales dashboard
- Analyst gets promoted, leaves team
- New analyst can't access or understand dashboard
- Dashboard abandoned, insights lost

**Solution:** Proper collaboration and version control

---

## Dashboard Sharing Methods

### Method 1: Direct User Sharing (Individual Access)

**Best For:** Small teams, specific individuals need access

**How It Works:**
1. Click **Share** button (top-right corner)
2. Enter email addresses
3. Choose permission level
4. Click **Send**

**Permission Levels:**

| Permission | Can View | Can Edit | Can Share | Use Case |
|------------|----------|----------|-----------|----------|
| **Viewer** | ✓ | ✗ | ✗ | Executives, stakeholders (read-only) |
| **Commenter** | ✓ | ✗ (add comments) | ✗ | Reviewers providing feedback |
| **Editor** | ✓ | ✓ | ✗ | Team members building dashboard |
| **Owner** | ✓ | ✓ | ✓ | Dashboard creator, can transfer ownership |

**Nigerian Business Sharing Example:**

**Lagos Retail Company:**
- **CEO:** Viewer (sees dashboard, can't change)
- **Sales Managers:** Viewer (monitor their team performance)
- **Data Analysts:** Editor (build and maintain dashboards)
- **Marketing Team Lead:** Commenter (can suggest improvements)
- **BI Team Lead:** Owner (manages access, can delete)

**Step-by-Step:**
```
1. Click [Share]
2. Add email: ceo@lagosfashion.com.ng → Role: Viewer
3. Add email: sales@lagosfashion.com.ng → Role: Viewer
4. Add email: analyst@lagosfashion.com.ng → Role: Editor
5. Message: "Q1 Sales Dashboard ready for review"
6. Click [Send]
```

---

### Method 2: Link Sharing (Anyone with Link)

**Best For:** Wider distribution, external partners, public dashboards

**How It Works:**
1. Click **Share** → **Get link**
2. Choose link access level
3. Copy link, share via email/Slack/WhatsApp

**Link Access Options:**

| Setting | Who Can Access | Use Case |
|---------|---------------|----------|
| **Restricted** | Only named users | Default (most secure) |
| **Anyone in organization** | All company employees | Internal company dashboards |
| **Anyone with link** | Anyone who has URL | Public reports, client-facing |

**Security Considerations:**

**✓ Safe for "Anyone with Link":**
- Public marketing metrics (website traffic)
- Aggregate performance (no customer details)
- Industry benchmarks

**✗ Never use "Anyone with Link" for:**
- Customer personal data (names, phone numbers, addresses)
- Financial details (revenue by customer, profit margins)
- Employee data (salaries, performance reviews)
- Competitive intelligence

**Nigerian Business Example:**

**Acceptable Public Dashboard:**
```
Lagos E-Commerce - Public Metrics Dashboard
- Total orders this month: 12,543
- Average delivery time: 3.2 days
- Customer satisfaction: 4.3/5 stars
- Top category: Electronics (35%)

Link access: "Anyone with link" (safe, no sensitive data)
```

**Never Make Public:**
```
Lagos E-Commerce - Internal Dashboard
- Revenue by customer (shows names and spend)
- Profit margin by product (competitive data)
- Customer email addresses and phone numbers

Link access: "Restricted" only (sensitive data)
```

---

### Method 3: Scheduled Email Delivery (Automated Reporting)

**Best For:** Regular reports (daily, weekly, monthly) sent to stakeholders

**How It Works:**
- Dashboard automatically sent as PDF/link on schedule
- No manual intervention needed
- Recipients don't need Looker Studio account

**Set Up Scheduled Email:**
1. Click **Share** → **Schedule email delivery**
2. Configure schedule:
   - **Frequency:** Daily, Weekly, Monthly, Quarterly
   - **Time:** 6:00 AM, 9:00 AM, etc.
   - **Day:** Monday, First day of month, etc.
3. Add recipients
4. Choose format: **Link** (interactive) or **PDF** (static snapshot)
5. Add message
6. Click **Save**

**Nigerian Business Scheduling Examples:**

**Daily Sales Report:**
- **To:** CEO, Sales Director
- **Schedule:** Every day at 6:00 AM WAT
- **Format:** PDF (snapshot of yesterday's performance)
- **Use Case:** Morning review before 9 AM meeting

**Weekly Performance Review:**
- **To:** Operations team, Regional managers
- **Schedule:** Every Monday at 8:00 AM WAT
- **Format:** Link (interactive, can drill down)
- **Use Case:** Monday team meeting agenda

**Monthly Financial Report:**
- **To:** CFO, Finance team, Board members
- **Schedule:** First day of month at 9:00 AM WAT
- **Format:** PDF (official record)
- **Use Case:** Month-end board presentation

**Quarterly Executive Summary:**
- **To:** Board of Directors, Investors
- **Schedule:** First Monday of quarter at 10:00 AM WAT
- **Format:** PDF with custom message
- **Use Case:** Quarterly board meeting

---

### Method 4: Embed in Website or App

**Best For:** Public-facing dashboards, internal portals, client dashboards

**How It Works:**
- Dashboard embedded as iframe in webpage
- Appears as part of website (not separate window)
- Can restrict to specific domains

**Get Embed Code:**
1. Click **Share** → **Embed**
2. Copy iframe code
3. Paste into website HTML

**Example Embed Code:**
```html
<iframe
  width="100%"
  height="600"
  src="https://lookerstudio.google.com/embed/reporting/abc123"
  frameborder="0"
  style="border:0"
  allowfullscreen>
</iframe>
```

**Nigerian Business Use Cases:**

**Example 1: E-Commerce Company Public Dashboard**
- Company website: www.lagosfashion.com.ng/insights
- Embedded dashboard shows:
  - Total customers served
  - Average delivery time
  - Customer satisfaction rating
- Access: Public (anyone visiting website)

**Example 2: Client Portal**
- Agency dashboard: www.digitalagency.ng/client/clientname
- Each client sees their own campaign performance
- Access: Restricted to client login

**Example 3: Internal Employee Portal**
- Company intranet: intranet.company.ng/hr-dashboard
- Embedded HR analytics (headcount, attrition, satisfaction)
- Access: Company employees only

---

## Version History (Change Tracking)

### Why Version History Matters

**Real-World Scenarios:**

**Scenario 1: Accidental Deletion**
- Junior analyst deletes important chart
- No version history = chart gone forever
- With version history = restore previous version

**Scenario 2: Formula Error**
- Someone changes revenue formula incorrectly
- Dashboard shows wrong numbers for 2 weeks
- Version history shows: "Formula changed Jan 15 by user@company.com"
- Revert to correct version

**Scenario 3: Experiment Gone Wrong**
- Try new dashboard layout, users hate it
- Version history = restore old layout in 30 seconds

**Scenario 4: Audit Trail**
- CFO asks: "Why did revenue numbers change?"
- Version history shows: "Data source updated Jan 20"
- Clear explanation with audit trail

---

### Viewing Version History

**Access Version History:**
1. **File** → **Version history**
2. See list of all changes (date, time, user)
3. Click any version to preview
4. **Restore** to revert to that version

**Version History Information:**
```
┌─────────────────────────────────────────────────┐
│ Version History: Sales Dashboard                │
├─────────────────────────────────────────────────┤
│ Jan 31, 2026 10:30 AM - analyst@company.com.ng │
│ "Updated revenue chart date range"             │
│                                                 │
│ Jan 30, 2026 3:45 PM - manager@company.com.ng  │
│ "Added customer satisfaction scorecard"        │
│                                                 │
│ Jan 29, 2026 9:15 AM - analyst@company.com.ng  │
│ "Fixed state filter issue"                     │
│                                                 │
│ Jan 28, 2026 2:00 PM - analyst@company.com.ng  │
│ "Initial dashboard creation"                   │
└─────────────────────────────────────────────────┘
```

---

### Making Named Versions (Snapshots)

**Problem:** Auto-saved versions have generic names

**Solution:** Create named versions for important milestones

**Create Named Version:**
1. **File** → **Version history** → **Name current version**
2. Enter descriptive name
3. Click **Save**

**Naming Convention Examples:**

**Good Names (Descriptive):**
- ✓ "v1.0 - Initial Launch - Jan 2026"
- ✓ "v2.0 - Added Customer Segmentation"
- ✓ "Pre-Q2-Launch Backup"
- ✓ "Approved by CFO - March 2026"

**Bad Names (Vague):**
- ✗ "Version 1"
- ✗ "Final"
- ✗ "Dashboard backup"
- ✗ "Test"

**Nigerian Business Example:**
```
Sales Dashboard - Version History
├─ v1.0 - Pilot Launch (Aug 2025)
├─ v1.1 - Added Lagos Region Filter (Sep 2025)
├─ v1.2 - Performance Optimization (Oct 2025)
├─ v2.0 - Multi-Page Redesign (Nov 2025)
├─ v2.1 - Mobile-Friendly Layout (Dec 2025)
└─ v3.0 - Integrated Customer Data (Jan 2026) ← Current
```

---

## Team Collaboration Best Practices

### Practice 1: Role-Based Access

**Principle:** Give minimum permissions needed

| Role | Permission | Reason |
|------|------------|--------|
| Executives | Viewer | Need to see insights, not edit |
| Business Users | Viewer | Consume data, don't build |
| Feedback Reviewers | Commenter | Suggest improvements |
| Analysts (Junior) | Editor | Build and maintain |
| Analysts (Senior) | Owner | Full control, manage access |

**Common Mistake:** Giving everyone Editor access
- Someone accidentally deletes chart
- Conflicting edits overwrite each other
- No clear owner/responsibility

---

### Practice 2: Development → Staging → Production

**Professional Dashboard Lifecycle:**

**Development (Draft Copy):**
- **Access:** Editors only
- **Purpose:** Experiment, build, test
- **Status:** "DRAFT" in title
- **Example:** "[DRAFT] Sales Dashboard - Testing"

**Staging (Review Copy):**
- **Access:** Editors + Commenters
- **Purpose:** Stakeholder review, feedback
- **Status:** "STAGING" in title
- **Example:** "[STAGING] Sales Dashboard - Please Review"

**Production (Live Dashboard):**
- **Access:** Viewers (wide distribution)
- **Purpose:** Official dashboard for decisions
- **Status:** No prefix, clean title
- **Example:** "Sales Dashboard - Q1 2026"

**Workflow:**
```
1. Build in DRAFT
   ↓
2. Move to STAGING (get feedback)
   ↓
3. Make a copy → PRODUCTION (publish)
   ↓
4. Future changes: Edit DRAFT → Re-publish to PRODUCTION
```

---

### Practice 3: Communication During Edits

**Problem:** Two people editing simultaneously

**What Happens:**
- Analyst A: Changes chart 1
- Analyst B: Changes chart 2 (at same time)
- Last person to save wins
- Other person's changes lost

**Solution:** Communication and ownership

**Team Protocol:**
1. **Slack/Email Before Editing:** "Working on Sales Dashboard 10-11 AM"
2. **Assign Chart Ownership:** "Analyst A owns revenue charts, Analyst B owns customer charts"
3. **Use Comments:** "@analyst Can you review this chart?" (don't edit directly)
4. **Create Personal Copies:** Test changes in copy, then apply to main dashboard

---

### Practice 4: Documentation and Handoff

**Dashboard Documentation Template:**

```markdown
# Sales Dashboard - Documentation

## Purpose
Monitor daily sales performance for Lagos region

## Owner
Primary: Adebayo Okafor (adebayo@company.com.ng)
Backup: Chinwe Nwosu (chinwe@company.com.ng)

## Data Sources
- Database: sales_db (BigQuery)
- Refresh: Every 1 hour (cached)
- Data Range: Last 365 days

## Key Metrics
1. Revenue: SUM(order_value) WHERE status = 'completed'
2. Orders: COUNT(DISTINCT order_id)
3. AOV: Revenue / Orders

## Filters
- Date Range: Defaults to Last 30 days
- State: All Nigerian states + "All"
- Category: Product categories + "All"

## Known Issues
- Data delayed 30 minutes (ETL process)
- December 25-26: No data (warehouse closed)

## Change Log
- Jan 31, 2026: Added customer segmentation page
- Jan 15, 2026: Optimized query performance
- Jan 1, 2026: Initial launch

## Stakeholders
- CEO: Views daily at 9 AM
- Sales Team: Uses for weekly review
- Operations: Monitors fulfillment
```

**Store Documentation:**
- Google Doc linked in dashboard footer
- Looker Studio built-in description (File → Report settings → Description)
- Shared folder with all dashboard docs

---

## Commenting and Feedback

### Using Comments Feature

**Add Comment:**
1. Select chart or dashboard area
2. Click **Comment** icon (speech bubble)
3. Type comment
4. **@mention** user to notify them
5. Click **Comment**

**Comment Example:**
```
@adebayo Can you update this chart to show last 90 days instead of 30?
The trend is more meaningful over a longer period.

Also, can we change the color to green (our brand color)?

Thanks!
- Chinwe
```

**Respond to Comment:**
1. Click comment thread
2. Type reply
3. Mark **Resolved** when addressed

**Nigerian Business Workflow:**
```
Monday: Analyst shares [STAGING] dashboard with manager
Tuesday: Manager adds 5 comments with suggestions
Wednesday: Analyst addresses comments, marks resolved
Thursday: Manager reviews, approves
Friday: Analyst publishes to [PRODUCTION]
```

---

## Access Management at Scale

### Managing Large Teams

**Challenge:** 50+ people need dashboard access

**Solution 1: Google Groups**
- Create group: sales-team@company.com.ng
- Add all 50 people to group
- Share dashboard with group (one entry, not 50)
- Add/remove people from group (don't re-share dashboard)

**Solution 2: Domain-Wide Sharing**
- Share with "Anyone at company.com.ng"
- All employees auto-get access
- Good for company-wide dashboards

**Example Nigerian Company Structure:**
```
Google Groups:
├─ executives@company.com.ng (Viewer)
├─ sales-team@company.com.ng (Viewer)
├─ operations-team@company.com.ng (Viewer)
├─ analysts@company.com.ng (Editor)
└─ bi-team@company.com.ng (Owner)

Dashboard Sharing:
Share with: executives@company.com.ng
Share with: sales-team@company.com.ng
Share with: analysts@company.com.ng

Result: 150 people have access via 3 group entries
```

---

## Security and Compliance

### Data Security Best Practices

**1. Row-Level Security (Filter by User)**

**Scenario:** Regional managers should only see their region

**Implementation:**
1. Data source includes user_email column
2. Dashboard filter: WHERE region_manager_email = CURRENT_USER()
3. Lagos manager sees only Lagos data
4. Abuja manager sees only Abuja data

**2. Sensitive Data Protection**

**Never include in dashboards:**
- Customer phone numbers (aggregate counts only)
- Email addresses (unless absolutely necessary)
- Home addresses
- Payment card details (never!)
- Passwords (obviously never)

**Aggregate sensitive data:**
- ✗ Show: "Customer Adebayo Okafor spent NGN 150,000"
- ✓ Show: "Top 10% customers spend NGN 150K+ on average"

**3. Access Auditing**

**Quarterly Access Review:**
1. File → Manage access
2. Review all users with access
3. Remove people who left company
4. Downgrade permissions (Editor → Viewer if no longer building)

---

## Exporting and Archiving

### Export Options

**1. PDF Export (Static Snapshot)**
- **Use:** Official records, presentations, printing
- **How:** File → Download → PDF
- **Settings:** Page size (A4, Letter), Orientation (Portrait, Landscape)

**2. CSV Export (Raw Data)**
- **Use:** Further analysis in Excel/Python
- **How:** Click chart → **More options (⋮)** → Export → CSV
- **Limitation:** One chart at a time (not entire dashboard)

**3. Google Sheets Export**
- **Use:** Share data with non-Looker users
- **How:** Create connected sheet, auto-updates
- **Settings:** Refresh frequency

**Nigerian Business Example:**

**Monthly Board Report:**
1. Generate PDF on last day of month
2. Save to Google Drive: "Board Reports/2026/January/Sales Dashboard.pdf"
3. Email to board members
4. Archive for compliance (7 years retention)

---

## Key Takeaways

1. **Permissions matter** - Give minimum access needed (Viewer for most users)
2. **Schedule reports** - Automated emails save time, ensure delivery
3. **Version history is your backup** - Mistakes can be undone
4. **Document your dashboards** - Future you (and teammates) will thank you
5. **Use staging → production workflow** - Test before publishing
6. **Communicate during edits** - Prevent conflicting changes
7. **Security first** - Protect sensitive data, audit access regularly
8. **Comments for feedback** - Better than email chains

---

## Hands-On Preview

**In the exercise, you'll:**
1. Share dashboard with 3 permission levels (Viewer, Commenter, Editor)
2. Set up scheduled email (weekly report every Monday 8 AM)
3. Create a named version ("v1.0 - Initial Launch")
4. Add a comment with @mention
5. Test embedded dashboard in simple HTML page
6. Review version history and restore a previous version

**Scenario:**
You've built a sales dashboard and need to:
- Share with CEO (Viewer)
- Share with Marketing Manager (Commenter for feedback)
- Share with fellow analyst (Editor for collaboration)
- Set up automated Monday morning email

---

## Additional Resources

- **Google Workspace Admin:** Managing organization-wide access
- **Row-Level Security:** Advanced filtering by user
- **API Access:** Programmatic dashboard management
- **Looker Studio Embedding:** Advanced iframe customization
- **Compliance Guide:** Nigerian data protection regulations (NDPR)

---

**Next Steps:** You now have the complete toolkit for professional dashboard design and deployment!

**Complete Week 14 Thursday Skills:**
1. ✓ Page Layout Principles (visual hierarchy, reading patterns)
2. ✓ Multi-Page Navigation (tabs, menus, cross-page filters)
3. ✓ Performance Optimization (caching, query optimization, load time)
4. ✓ Collaboration & Version Control (sharing, scheduling, version history)

**Ready for:** Building client-ready, professional dashboards for Nigerian businesses!

---

**Related Concepts:**
- Week 13: Chart fundamentals (you now know how to share those charts)
- Week 14 Wednesday: Interactivity (collaboration on interactive dashboards)
- Week 15: Advanced features (building on professional foundation)
