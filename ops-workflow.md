# PakStyle BD – Operations Workflow

---

## End-to-End Order Flow

```
[1] Buyer browses Pakistani brand website via PakStyle BD portal
            ↓
[2] Buyer selects products (size, color, quantity)
            ↓
[3] Platform auto-calculates landed price and displays to buyer (in BDT)
            ↓
[4] Buyer confirms order and pays (bKash or BD bank transfer)
            ↓
[5] Platform automatically places order on brand website
    using platform's registered account (Karachi address)
            ↓
[6] Brand ships order to logistics partner's Karachi warehouse
            ↓
[7] Logistics partner receives, logs, and consolidates incoming orders
            ↓
[8] Consolidated shipment sent Karachi → Dhaka (BDT 1,600/kg)
            ↓
[9] Logistics partner manages BD customs clearance
            ↓
[10] Last-mile delivery to buyer's doorstep in Bangladesh
            ↓
[11] Delivery confirmed → order closed
```

---

## Platform Accounts on Brand Websites

The platform maintains registered customer accounts on all listed Pakistani brand websites. These accounts are:

- Registered with a Karachi delivery address (logistics partner's warehouse)
- Used for all buyer orders — buyers never need their own accounts on brand sites
- Managed centrally by the platform operator
- One account per brand (or multiple if needed for order volume)

**Account registration is a pre-launch task.** Before going live with each brand, the account must be created, verified, and tested with a real order.

---

## Automated Order Placement (Core Tech Feature)

When a buyer confirms and pays, the platform must automatically:

1. Open the corresponding brand website using stored session/credentials
2. Navigate to each product URL from the buyer's selection
3. Select the correct size, color, and quantity
4. Add to cart
5. Apply delivery address (logistics partner's Karachi warehouse)
6. Complete checkout using stored payment credentials

**Automation approach options:**

| Approach | Complexity | Reliability |
|----------|-----------|-------------|
| Browser automation (Playwright/Puppeteer) | Medium | Good for most sites |
| Brand API (if available) | Low | Best, but rarely available |
| Semi-auto: pre-fill cart, human confirms | Low | Reliable fallback |

**Phase 1–2:** Semi-automatic — system pre-fills the cart on brand website; operator does a final review and confirms checkout.
**Phase 3+:** Fully automated where brand sites allow it.

---

## Logistics Partner SOP

| Step | Details | Timeline |
|------|---------|----------|
| Order placed on brand site | Brand ships to logistics partner's Karachi warehouse | 2–5 days |
| Received at warehouse | Logged, photographed, quality checked | Same day as receipt |
| Consolidation | Bundled with other BD-bound orders | Daily or every 2 days |
| Shipped Karachi → Dhaka | Air freight @ BDT 1,600/kg (actual weight) | 3–5 business days |
| Customs clearance BD | Handled by logistics partner | 1–2 business days |
| Last-mile delivery | Doorstep delivery across Bangladesh | 1–2 business days |
| **Total: order placed → delivered** | | **~10–14 business days** |

---

## Payment Flow

| Step | Details |
|------|---------|
| Buyer pays | bKash or bank transfer to BD partner account |
| Payment confirmed | Platform verifies receipt before placing brand order |
| Advance payment only | 100% upfront — no COD |
| Refunds | Only for platform errors (wrong item ordered, item unavailable) |

**BD payment receiving:** Through agreed partner's bKash merchant or bank account. Funds reconciled periodically.

---

## Daily Ops Checklist

**Morning**
- [ ] Check new paid orders — verify payment received
- [ ] Trigger or confirm automated order placement on brand sites
- [ ] Check for any automation failures → handle manually

**Midday**
- [ ] Update order statuses in admin panel
- [ ] Send WhatsApp updates for any orders with news (shipped, delayed, etc.)
- [ ] Follow up with logistics partner on in-transit orders

**Evening**
- [ ] Review consolidation status at Karachi warehouse
- [ ] Confirm tracking numbers for dispatched BD shipments
- [ ] Update customer tracking portal

---

## Exception Handling

| Scenario | Action |
|----------|--------|
| Item out of stock on brand site | Notify buyer within 4 hours; offer substitute or full refund |
| Automation fails on brand site | Place order manually; flag site for automation fix |
| Brand website changes (blocks automation) | Switch to semi-auto for that brand; rebuild automation |
| Item damaged at warehouse | Photograph, contact buyer, issue refund or reship |
| Customs hold | Logistics partner manages; update buyer on delay |
| Buyer unreachable for delivery | Hold 48 hrs, 3 delivery attempts, then return to warehouse |

---

## No-Returns Policy

Cross-border returns are not operationally feasible.

**Policy:**
- All sales final
- Size guide mandatory before ordering
- Buyer must review product page before confirming

**Exceptions (at operator's discretion):**
- Wrong item ordered due to platform error → full refund or reship
- Significantly damaged item received → partial or full refund

---

## Tools & Systems

| Tool | Purpose |
|------|---------|
| Admin panel (platform) | Order management, status updates, tracking |
| Playwright / Puppeteer | Browser automation for order placement on brand sites |
| WhatsApp Business | Buyer communication and updates |
| bKash / BD bank account | Payment collection |
| Logistics partner portal | Shipment tracking, weight confirmation |
| Google Sheets (Phase 1) | Manual order log during pilot |
