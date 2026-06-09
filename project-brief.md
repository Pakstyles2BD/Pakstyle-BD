# PakStyle BD – Project Brief

**Tagline:** Pakistani Fashion, Delivered to Your Door in Bangladesh

---

## Core Concept

A **cross-border purchasing portal** that gives Bangladeshi buyers direct access to Pakistani women's wear brands. The platform holds accounts on all major brand websites in Pakistan. Buyers browse and select products; the platform automatically places orders on the brand websites using those accounts. The logistics partner receives all items at their Karachi warehouse, consolidates, and ships to Dhaka with full last-mile delivery.

---

## Problem We're Solving

Bangladeshi women want Pakistani lawn and fashion brands but face three friction points:

1. No direct shipping from Pakistani brands to Bangladesh
2. Currency complexity (PKR vs BDT)
3. No trusted intermediary to purchase, consolidate, and deliver

PakStyle BD eliminates all three.

---

## How It Works

### For the Buyer (Bangladesh)

```
Step 1 — Browse
  Visit PakStyleBD portal
  Browse Pakistani brand websites listed on the portal
  Select products (size, color, quantity)

Step 2 — See Price
  Platform automatically calculates full landed price:
    → PKR to BDT conversion (platform rate, not shown to buyer)
    → Estimated logistics cost (based on product category weight × 1600 BDT/kg)
    → 10% platform commission
    → BDT 100 per transaction fee
  Buyer sees the final BDT price — no manual quoting needed

Step 3 — Order & Pay
  Buyer confirms order
  Pays via bKash or Bangladesh bank transfer

Step 4 — Receive
  Platform automatically places order on brand website using platform's account
  Item ships to logistics partner's Karachi warehouse
  Logistics partner consolidates and ships Karachi → Dhaka
  Last-mile delivery to buyer's doorstep in Bangladesh
```

### For the Platform (Operations Side)

```
1. Platform maintains user accounts on all brand websites (registered in Karachi)
2. When buyer confirms + pays → system auto-adds products to brand website cart
   and places the order using platform's stored credentials
3. Brand delivers to logistics partner's Karachi warehouse address
4. Logistics partner consolidates all incoming orders
5. Ships consolidated parcel to Dhaka (1600 BDT/kg)
6. Manages last-mile delivery across Bangladesh
```

---

## Key Architecture Decisions

| Decision | Detail |
|----------|--------|
| No product catalog | Platform links to brand websites directly; no product uploads or hosting |
| Platform accounts on brand sites | One account per brand, registered to Karachi address; used for all buyer orders |
| Automated order placement | Buyer's selection is automatically transferred to brand website cart and ordered |
| Logistics partner handles everything post-order | Warehouse receipt, consolidation, Karachi→Dhaka shipping, last-mile BD delivery |
| Payments | bKash or Bangladesh bank account of trusted partner (already arranged) |
| Pricing | All-in BDT price shown to buyer — conversion rate is internal and hidden |

---

## Pricing Structure (Shown to Buyers)

All four components calculated automatically by the platform:

| Component | How Calculated |
|-----------|---------------|
| Product price in BDT | PKR price × platform conversion rate (rate hidden from buyer) |
| Logistics cost | Estimated weight (kg) × BDT 1,600/kg |
| Platform commission | 10% of product price in BDT |
| Transaction fee | BDT 100 flat per order |

The buyer sees one total BDT figure. Breakdown is shown but the PKR→BDT rate is not disclosed.

---

## Revenue Model

| Stream | Mechanism |
|--------|-----------|
| Conversion spread | Platform rate > market rate; buyer sees BDT price only |
| 10% commission | Applied on product price in BDT |
| BDT 100 transaction fee | Flat per order |
| Logistics margin | If any spread between actual logistics rate and charged rate |

---

## Logistics Partner Role

| Function | Details |
|----------|---------|
| Receiving address | Karachi warehouse — all brand orders ship here |
| Consolidation | Aggregates multiple items/orders into outbound shipments |
| Shipping | Karachi → Dhaka, rate: BDT 1,600/kg |
| Last-mile delivery | Full doorstep delivery across Bangladesh |
| Billing | Per kg, billed on actual consolidated weight |

---

## Payment Setup

- **bKash** — primary digital payment for Bangladeshi buyers
- **Bangladesh bank account** — through trusted local partner (already arranged)
- Full advance payment required before order is placed
- No COD (cross-border model makes COD unviable)

---

## Phase Roadmap

| Phase | Timeline | Focus |
|-------|----------|-------|
| Phase 1 – Manual Pilot | Month 1–2 | Manual order placement, WhatsApp + Google Form, prove model with 10–20 buyers |
| Phase 2 – Portal Launch | Month 2–4 | Website live: brand links, price calculator, order form, basic admin panel |
| Phase 3 – Automation | Month 4–8 | Auto order placement on brand websites via stored accounts; buyer cart → brand cart |
| Phase 4 – Scale | Month 8–12 | More brands, faster logistics cycles, referral/loyalty program |

---

## Key Risks & Mitigations

| Risk | Mitigation |
|------|-----------|
| Brand website automation blocked (CAPTCHA/bot detection) | Semi-auto fallback: pre-fill cart for manual confirm; use browser automation carefully |
| Brand ToS on bulk purchasing | Register accounts as regular customers; keep order sizes natural |
| Bangladesh customs | Buffer in pricing; logistics partner manages clearance |
| Currency fluctuation | Platform rate updated weekly; locked at time of order |
| No returns | Clear policy upfront; size guides; buyer reviews product page before ordering |
| Payment disputes | All transactions documented with screenshots; WhatsApp confirmation chain |
