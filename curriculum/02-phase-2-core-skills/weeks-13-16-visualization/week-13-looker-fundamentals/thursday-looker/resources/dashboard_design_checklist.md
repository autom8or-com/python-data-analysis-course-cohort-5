# Dashboard Design Quality Checklist

**Week 13 - Looker Studio Fundamentals**
**Purpose:** Pre-launch quality assurance for professional dashboards

---

## How to Use This Checklist

Before sharing your dashboard with stakeholders, go through each section and check off items. A professional dashboard should have 90%+ items checked.

**Quality Levels:**
- **Production-Ready:** 90-100% checked
- **Needs Polish:** 75-89% checked
- **Needs Major Revision:** Below 75%

---

## SECTION 1: CONTENT & ACCURACY

### Data Correctness
- [ ] All metrics calculate correctly (verified against SQL queries)
- [ ] Filters apply to correct charts
- [ ] Date ranges are accurate
- [ ] No duplicate data or double-counting
- [ ] Aggregations use correct functions (SUM, AVG, COUNT)
- [ ] Calculated fields formula verified
- [ ] Sample size adequate (not showing trends with 3 data points)
- [ ] Data freshness acceptable (shows current/recent data)

### Business Relevance
- [ ] Dashboard answers specific business questions
- [ ] Metrics align with stakeholder priorities
- [ ] Level of detail appropriate for audience
- [ ] Timeframes relevant to business decisions
- [ ] Geographic scope correct (Nigeria-focused)

**Score: ___/13**

---

## SECTION 2: LAYOUT & STRUCTURE

### Information Hierarchy
- [ ] Most important metrics "above the fold" (visible without scrolling)
- [ ] KPI scorecards at top
- [ ] Logical flow (F-pattern or Z-pattern)
- [ ] Related charts grouped together
- [ ] Clear section divisions

### Spacing & Alignment
- [ ] Consistent spacing between charts (16-24px minimum)
- [ ] Charts aligned to grid (use Looker's grid feature)
- [ ] Margins around dashboard edges (20-30px)
- [ ] White space between sections (32-48px)
- [ ] No overlapping elements
- [ ] Equal-width scorecards in KPI row

### Organization
- [ ] Maximum 6-8 charts on single page (not overcrowded)
- [ ] Filters at top or in sidebar (not buried)
- [ ] Related visualizations adjacent
- [ ] Logical reading order (top-to-bottom, left-to-right)

**Score: ___/16**

---

## SECTION 3: VISUAL DESIGN

### Color Scheme
- [ ] Consistent color palette (2-3 primary colors max)
- [ ] Brand colors used (if applicable)
- [ ] Colors have meaning (green = good, red = bad)
- [ ] Sufficient contrast (text readable on background)
- [ ] Color-blind friendly (doesn't rely on color alone)
- [ ] No unnecessary rainbows (data series colors meaningful)

### Typography
- [ ] Maximum 2 font families used
- [ ] Font sizes hierarchical (Dashboard title > Section header > Chart title > Labels)
- [ ] All text readable (minimum 10px)
- [ ] Consistent fonts across all charts
- [ ] Nigerian formatting (NGN currency, proper dates)

### Chart Styling
- [ ] Chart types appropriate for data (see Chart Selection Guide)
- [ ] No chartjunk (3D effects, drop shadows, excessive decoration)
- [ ] Gridlines subtle (light gray, not bold black)
- [ ] Data-ink ratio high (more data, less decoration)
- [ ] Consistent chart styling (same font, colors across dashboard)

**Score: ___/16**

---

## SECTION 4: LABELS & TEXT

### Chart Titles
- [ ] Every chart has clear, descriptive title
- [ ] Titles use active voice ("Monthly Revenue Trend" not just "Revenue")
- [ ] Titles answer "What am I looking at?"
- [ ] Font size appropriate (16-20px for chart titles)

### Axis Labels
- [ ] X-axis labeled (with units if applicable)
- [ ] Y-axis labeled (with units: NGN Millions, Percentage, etc.)
- [ ] Axis labels not overlapping
- [ ] Number formats correct on axes

### Data Labels
- [ ] Key values labeled (especially on scorecards)
- [ ] Currency shows NGN (not $ or unlabeled)
- [ ] Dates formatted clearly (Nov 13, 2025 not 2025-11-13)
- [ ] Percentages show % symbol
- [ ] Compact numbers where appropriate (45.3M not 45,300,000)

### Dashboard Header/Footer
- [ ] Dashboard has clear title
- [ ] Purpose or audience noted (optional but recommended)
- [ ] Last updated timestamp (auto-generated)
- [ ] Data source credited
- [ ] Contact info for questions (email or Slack)

**Score: ___/18**

---

## SECTION 5: INTERACTIVITY

### Filters & Controls
- [ ] Date range filter present (if time-based data)
- [ ] Filters clearly labeled
- [ ] Default filter values set (not blank)
- [ ] Filters apply to correct charts
- [ ] Filter changes update charts immediately

### User Experience
- [ ] Charts load within 3-5 seconds
- [ ] Hover tooltips show additional detail
- [ ] Drill-down enabled where appropriate
- [ ] No broken links or errors
- [ ] Interactive elements obvious (buttons look clickable)

**Score: ___/10**

---

## SECTION 6: MOBILE RESPONSIVENESS

### Mobile Layout
- [ ] Tested in mobile view (View → Mobile Layout)
- [ ] Charts stack properly on narrow screens
- [ ] Text remains readable (no 6px fonts)
- [ ] Touch targets large enough (44×44px minimum)
- [ ] Scrolling works smoothly
- [ ] No horizontal scrolling required
- [ ] Most important charts visible first on mobile
- [ ] Filter controls usable on mobile

### Optimization
- [ ] Heavy images optimized or removed for mobile
- [ ] Table columns reduced for mobile (3-4 max)
- [ ] Charts simplified if needed for mobile
- [ ] Tested on actual mobile device (not just desktop preview)

**Score: ___/12**

---

## SECTION 7: ACCESSIBILITY

### Color Accessibility
- [ ] Sufficient contrast (4.5:1 for text, 3:1 for large text)
- [ ] Color-blind simulation tested (Coblis or similar tool)
- [ ] Meaning not conveyed by color alone (use labels + color)
- [ ] Patterns or icons supplement color coding

### Screen Reader Compatibility
- [ ] Alt text provided for images (if used)
- [ ] Logical tab order for keyboard navigation
- [ ] Chart titles descriptive (screen reader will read them)

### Readability
- [ ] No light gray text on white background
- [ ] Font sizes large enough (10px minimum, 12px+ preferred)
- [ ] Dyslexia-friendly fonts (Roboto, Open Sans, not decorative)

**Score: ___/10**

---

## SECTION 8: NIGERIAN BUSINESS CONTEXT

### Localization
- [ ] Currency always shows NGN (never $, EUR, etc.)
- [ ] Date format clear (MMM DD, YYYY or DD/MM/YYYY with clarity)
- [ ] Nigerian states/cities spelled correctly
- [ ] Time zone: Africa/Lagos (WAT = UTC+1)
- [ ] Number separators: comma for thousands, period for decimal

### Cultural Appropriateness
- [ ] Language appropriate for Nigerian business audience
- [ ] Examples relevant to local context
- [ ] No culturally insensitive imagery
- [ ] Business hours/seasons appropriate (Nigerian calendar)

### Practical Considerations
- [ ] Optimized for common Nigerian internet speeds
- [ ] Works on typical Nigerian mobile devices
- [ ] Data costs considered (minimized for mobile users)

**Score: ___/11**

---

## SECTION 9: PERFORMANCE

### Load Time
- [ ] Dashboard loads in under 5 seconds
- [ ] Individual charts load within 3 seconds
- [ ] No timeout errors
- [ ] Filter changes apply quickly (under 2 seconds)

### Data Source Optimization
- [ ] Using data extract (snapshot) if live data slow
- [ ] Caching enabled where appropriate
- [ ] Date ranges reasonable (not querying 10 years unnecessarily)
- [ ] Aggregations pre-computed where possible
- [ ] Row limits set on tables

**Score: ___/9**

---

## SECTION 10: FINAL QUALITY CHECKS

### Pre-Launch Testing
- [ ] Tested by someone other than creator
- [ ] Tested on Chrome, Safari, Edge (top 3 browsers)
- [ ] Tested on mobile device (not just desktop)
- [ ] All links work (no 404 errors)
- [ ] Sharing permissions set correctly
- [ ] Scheduled refresh working (if applicable)

### Documentation
- [ ] Brief user guide created (how to use dashboard)
- [ ] Metric definitions documented (how KPIs calculated)
- [ ] FAQ prepared (common questions answered)
- [ ] Change log maintained (for dashboard updates)

### Stakeholder Validation
- [ ] Reviewed by at least one stakeholder
- [ ] Feedback incorporated
- [ ] Business logic validated by domain expert
- [ ] Meets stated requirements

**Score: ___/13**

---

## OVERALL DASHBOARD QUALITY SCORE

**Total Checks Completed:** ___/128

**Quality Rating:**
- **115-128 (90%+):** Production-Ready - Ship it!
- **102-114 (80-89%):** Needs Polish - Minor improvements
- **90-101 (70-79%):** Needs Revision - Significant gaps
- **Below 90 (<70%):** Major Rework Required

---

## Priority Fixes (If Below 90%)

If your score is low, focus on these high-impact areas first:

### Critical (Must Fix Before Sharing)
1. **Data Accuracy** - Verify all calculations correct
2. **Nigerian Currency** - All NGN formatted properly
3. **Mobile View** - Must work on mobile devices
4. **Chart Titles** - Every chart needs clear title
5. **Load Performance** - Must load in under 10 seconds

### High Priority (Fix This Week)
6. **Color Contrast** - Ensure readability
7. **Spacing** - Add white space between elements
8. **Filter Functionality** - Date range control working
9. **Axis Labels** - All axes labeled with units
10. **Mobile Responsiveness** - Charts stack properly

### Medium Priority (Polish)
11. **Consistent Styling** - Same fonts, colors throughout
12. **Documentation** - Add footer with data source
13. **Interactivity** - Hover tooltips enabled
14. **Accessibility** - Color-blind friendly
15. **Brand Colors** - Apply company colors

---

## Common Dashboard Mistakes - Quick Scan

**Critical Mistakes (Never Do These):**
- [ ] Currency NOT showing as NGN
- [ ] Charts with no titles
- [ ] Doesn't work on mobile
- [ ] Wrong data (calculations incorrect)
- [ ] Charts overlapping or misaligned

**Major Mistakes (Fix Immediately):**
- [ ] Too many charts (>10 on one page)
- [ ] Pie chart with 12 slices
- [ ] Light gray text unreadable
- [ ] No white space (cramped)
- [ ] Y-axis doesn't start at zero (misleading)

**Minor Mistakes (Fix When Polishing):**
- [ ] Inconsistent fonts
- [ ] Missing axis labels
- [ ] Default blue colors (not branded)
- [ ] No footer with source/date
- [ ] Charts not aligned to grid

---

## Dashboard Types - Specific Checklists

### Executive Dashboard (For CEO/COO)
- [ ] Maximum 6-8 visualizations
- [ ] Top 4 KPIs as scorecards
- [ ] One main trend chart
- [ ] 2-3 breakdown charts
- [ ] Minimal text (data speaks for itself)
- [ ] Updated daily (automated)

### Operational Dashboard (For Managers)
- [ ] 8-10 visualizations
- [ ] Real-time or near-real-time data
- [ ] Alerts for exceptions
- [ ] Drill-down enabled
- [ ] Action-oriented (supports decisions)
- [ ] Updated hourly or daily

### Analytical Dashboard (For Analysts)
- [ ] 10-15 visualizations
- [ ] Multiple filters for exploration
- [ ] Detailed tables included
- [ ] Statistical charts (scatter, distributions)
- [ ] Export functionality
- [ ] Flexible date ranges

---

## Weekly Dashboard Review Checklist

**Run this check every Friday before presenting Monday:**

1. **Data Freshness:** [ ] Data updated successfully this week
2. **Broken Elements:** [ ] No errors or missing charts
3. **Performance:** [ ] Loads in under 5 seconds
4. **Accuracy Spot Check:** [ ] Sample 3 metrics, verify against source
5. **Stakeholder Feedback:** [ ] Any issues reported this week addressed

---

## Pre-Presentation Checklist (1 Hour Before)

**The "30-Minute Before Demo" Final Check:**

- [ ] Dashboard loads successfully (test NOW)
- [ ] Data is current (last updated timestamp recent)
- [ ] All charts display (no "no data" errors)
- [ ] Filters work (test date range change)
- [ ] Internet connection stable
- [ ] Backup plan ready (screenshots if live demo fails)
- [ ] Story prepared (what insights to highlight)
- [ ] Practice run completed (5-minute walkthrough)

---

## Nigerian Context Final Checks

**Before sharing with Nigerian stakeholders:**

- [ ] All currency values show NGN (spot check 5 random charts)
- [ ] Geographic data uses Nigerian locations (Lagos, not London)
- [ ] Dates clear (no ambiguous DD/MM vs MM/DD)
- [ ] Business hours appropriate (WAT timezone)
- [ ] Language professional (Nigerian English, not overly American)
- [ ] Examples relevant (Eid, Christmas, Independence Day references)
- [ ] Mobile-optimized (60%+ of Nigerian users on mobile)

---

## Continuous Improvement Log

**After receiving feedback, track improvements:**

| Date | Feedback Received | Action Taken | Result |
|------|-------------------|--------------|--------|
| Nov 13 | "Can't see on phone" | Made mobile-responsive | Stakeholder confirmed fixed |
| Nov 15 | "What's AOV?" | Added metric definitions | Reduced questions by 50% |
| Nov 20 | "Too many charts" | Reduced from 12 to 7 | "Much clearer!" feedback |

---

**Save this checklist! Use it for every dashboard you create.**

**Pro Tip:** Do a quick 5-minute check daily, full checklist weekly, comprehensive review monthly.

---

## Printable Quick Checklist (Desk Reference)

```
┌──────────────────────────────────────────┐
│  DASHBOARD QUALITY - QUICK CHECK         │
├──────────────────────────────────────────┤
│  □ Data accurate                         │
│  □ NGN currency everywhere               │
│  □ Mobile-responsive                     │
│  □ All charts titled                     │
│  □ Filters working                       │
│  □ Loads under 5 seconds                 │
│  □ No overlapping elements               │
│  □ Professional colors/fonts             │
│  □ Tested by someone else                │
│  □ Stakeholder approved                  │
└──────────────────────────────────────────┘
```

---

**Next Steps:**
1. Print this checklist
2. Check your current dashboard
3. Fix critical issues first
4. Iterate weekly for continuous improvement
