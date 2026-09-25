# Full Program Page Overrides

> **PROJECT:** COPIQ Admin
> **Generated:** 2026-09-16 22:54:54
> **Page Type:** Dashboard / Data View

> ⚠️ **IMPORTANT:** Rules in this file **override** the Master file (`design-system/MASTER.md`).
> Only deviations from the Master are documented here. For all other rules, refer to the Master.

---

## Page-Specific Rules

### Layout Overrides

- **Max Width:** 1200px (standard)
- **Layout:** Full-width sections, centered content
- **Sections:** 1. Full-screen interactive element, 2. Guided product tour, 3. Key benefits revealed, 4. CTA after completion

### Spacing Overrides

- No overrides — use Master spacing

### Typography Overrides

- No overrides — use Master typography

### Color Overrides

- **Strategy:** Immersive experience colors. Dark background for focus. Highlight interactive elements.

### Component Overrides

- Avoid: Show loading spinner for 10s+
- Avoid: Leave UI frozen with no feedback
- Avoid: Icon buttons without labels

---

## Page-Specific Components

- No unique components for this page

---

## Recommendations

- Effects: Haptic feedback (vibration), voice guidance, focus indicators (4px+ ring), motion options, alt content, semantic
- AI Interaction: Stream text response token by token
- Animation: Use skeleton screens or spinners
- Accessibility: Add aria-label for icon-only buttons
- CTA Placement: After interaction complete + Skip option for impatient users
