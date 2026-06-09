# PakStyle BD – Technical Specification

---

## Model Summary

A cross-border purchasing portal. The platform:
- Lists Pakistani brand websites (no product hosting)
- Shows buyers a calculated BDT landed price based on product selection
- Automatically places orders on brand websites using platform-held accounts
- Logistics partner handles Karachi warehouse → Dhaka shipping → last-mile BD delivery

---

## Tech Stack

| Layer | Technology | Rationale |
|-------|-----------|-----------|
| Frontend | Next.js (React) | SEO-friendly, fast, handles dynamic pricing calc |
| Backend | Supabase (BaaS) | DB, auth, API — no custom server needed initially |
| Database | PostgreSQL (via Supabase) | Orders, customers, brand accounts, rate settings |
| Order Automation | Playwright (Node.js) | Browser automation for placing orders on brand sites |
| Payments | bKash Merchant API | Primary BD payment method |
| Hosting | Vercel (frontend) + Supabase | Free/low-cost for MVP |
| Admin Panel | Next.js admin route (auth-protected) | Internal order and rate management |
| Notifications | WhatsApp Business API or manual | Order status updates to buyers |

---

## Core Features

### 1. Brands Directory Page
- List of Pakistani brand cards: name, logo, short description
- Each card has a **"Shop on [Brand] →"** button linking to brand's own website
- No product data stored on platform
- Admin updates brand list manually

### 2. Product Selection & Price Display

This is the core UX flow:

```
Buyer is on brand's website (e.g., gulahmed.com)
    ↓
Buyer finds a product and copies the product URL
    ↓
Buyer pastes URL into PakStyle BD "Add Item" field
    ↓
Platform fetches product page → extracts PKR price and category
    ↓
Platform calculates and displays BDT landed price:
    Product BDT = PKR × internal rate
    Logistics  = est. weight × 1,600
    Commission = Product BDT × 10%
    Fee        = BDT 100
    Total      = sum of above
    ↓
Buyer adds size, color, quantity → adds to order
    ↓
Buyer can add more items (all consolidated in one shipment)
    ↓
Buyer confirms and pays
```

### 3. Landed Price Calculator (Auto, Not Manual)

Triggered automatically when buyer adds a product URL. No manual quoting.

Inputs:
- PKR price (scraped from product URL)
- Product category (detected or selected by buyer)
- Quantity

Formula:
```
product_bdt   = pkr_price × platform_rate
logistics     = estimated_weight_kg × 1600
commission    = product_bdt × 0.10
transaction   = 100
total_bdt     = product_bdt + logistics + commission + transaction
```

Platform rate is stored in admin settings — not exposed to buyer.

### 4. Order Request & Checkout

- Buyer reviews full order with itemized BDT prices
- Enters delivery address in Bangladesh
- WhatsApp number for updates
- Proceeds to payment (bKash / bank transfer)
- On payment confirmation → order goes to admin panel with status `paid`

### 5. Automated Order Placement on Brand Websites

**This is the most critical technical component.**

When an order is confirmed and paid:

1. Backend triggers an automation job (Playwright script)
2. Script opens the brand's website using stored platform credentials
3. For each item in the order:
   - Navigates to product URL
   - Selects size, color, quantity as specified by buyer
   - Adds to cart
4. Applies logistics partner's Karachi warehouse as delivery address
5. Completes checkout using stored payment method

**Brand accounts managed by platform:**

| Brand | Account Status | Automation Status |
|-------|---------------|------------------|
| Gul Ahmed | To be created | To be built |
| Khaadi | To be created | To be built |
| Sana Safinaz | To be created | To be built |
| Sapphire | To be created | To be built |
| Alkaram | To be created | To be built |
| ... | ... | ... |

Each account uses a Pakistan phone number and the logistics partner's Karachi address.

**Automation phases:**

| Phase | Mode | Description |
|-------|------|-------------|
| Phase 1–2 | Semi-auto | System pre-fills cart on brand site; operator manually confirms and checks out |
| Phase 3 | Fully auto | System places and pays for order automatically on confirmed payment |

**Semi-auto flow (Phase 2):**
```
Buyer pays → admin gets notification with pre-filled cart link
    → Admin opens link, verifies cart, confirms checkout
    → Order placed in < 5 minutes of receiving notification
```

### 6. Admin Panel

| Function | Description |
|----------|-------------|
| Order list | All orders with status, buyer info, items, amounts |
| Order detail | Product URLs, sizes, quantities, buyer address, payment confirmation |
| Order status update | Paid → Ordered → In Transit → Shipped BD → Delivered |
| Automation trigger | Button to trigger order placement job for a specific order |
| Brand accounts | Store and manage credentials for each brand website |
| Conversion rate | Set current PKR→BDT platform rate (updated weekly) |
| Export | CSV export for records |

### 7. Customer Order Tracking
- Buyer enters order ID (given at payment confirmation)
- Sees status timeline and latest update note
- No login required — order ID is the access key

---

## Database Schema

```sql
-- Orders
orders (
  id UUID PRIMARY KEY,
  buyer_name TEXT,
  whatsapp_number TEXT,
  delivery_address TEXT,
  status TEXT,  -- pending_payment | paid | ordered | in_transit | shipped_bd | delivered
  total_bdt DECIMAL,
  exchange_rate_used DECIMAL,
  tracking_note TEXT,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
)

-- Order Items
order_items (
  id UUID PRIMARY KEY,
  order_id UUID REFERENCES orders(id),
  product_url TEXT,
  brand_name TEXT,
  pkr_price DECIMAL,
  bdt_price DECIMAL,
  size TEXT,
  color TEXT,
  quantity INTEGER,
  est_weight_kg DECIMAL,
  logistics_cost_bdt DECIMAL
)

-- Brand Accounts (credentials for automation)
brand_accounts (
  id UUID PRIMARY KEY,
  brand_name TEXT,
  website_url TEXT,
  login_email TEXT,
  login_password_encrypted TEXT,  -- encrypted at rest
  delivery_address TEXT,  -- logistics partner Karachi address
  payment_method TEXT,
  automation_status TEXT,  -- active | semi-auto | manual | blocked
  notes TEXT
)

-- Brands Directory (public-facing)
brands (
  id UUID PRIMARY KEY,
  name TEXT,
  website_url TEXT,
  logo_url TEXT,
  description TEXT,
  active BOOLEAN
)

-- Exchange Rates
exchange_rates (
  id UUID PRIMARY KEY,
  pkr_to_bdt_rate DECIMAL,
  effective_from DATE,
  created_at TIMESTAMP
)
```

---

## Price Scraping

When a buyer submits a product URL, the platform needs to extract the PKR price. Approach:

| Method | Notes |
|--------|-------|
| Server-side fetch + HTML parse | Works for most brand sites; fast |
| Puppeteer headless render | For JS-rendered prices |
| Manual fallback | If scraping fails, buyer enters PKR price manually |

This is a per-brand implementation task. Each brand's product page HTML structure differs.

---

## Security Considerations

- Brand account credentials stored encrypted in DB (never in plaintext)
- Admin panel behind auth (Supabase Auth or NextAuth)
- Order IDs use UUIDs (not sequential — can't enumerate orders)
- Automation runs server-side only (never exposes credentials to browser)
- Payment confirmation verified server-side before triggering automation

---

## What Was Deliberately Excluded

| Excluded | Reason |
|----------|--------|
| Product catalog / uploads | Brand websites host their own products |
| Cart & checkout on platform | Ordering happens on brand sites via automation |
| Inventory management | No stock held by platform |
| Manual price quoting | Pricing is fully automated by formula |

---

## Build Phases

### Phase 1 – Pilot (No Build)
- Google Form for order requests
- WhatsApp for communication and payment
- Manual order placement on brand sites
- Google Sheet for tracking

### Phase 2 – Portal (4–6 weeks)
- Static site with brand links
- URL-based price calculator (paste product link → get BDT price)
- Order form with backend (Supabase)
- Admin panel (order list + status updates + rate settings)
- Customer tracking page

### Phase 3 – Automation (6–10 weeks additional)
- Playwright automation per brand
- Semi-auto → full-auto rollout brand by brand
- bKash API integration for payment confirmation
- Price scraping per brand

### Estimated Timeline to Phase 2 MVP

| Milestone | Duration |
|-----------|----------|
| Supabase setup, schema, auth | 3–4 days |
| Brand directory + static pages | 3–4 days |
| Price calculator (URL input → BDT output) | 1 week |
| Order form + backend | 1 week |
| Admin panel | 1 week |
| Customer tracking page | 2–3 days |
| Testing & QA | 1 week |
| **Total Phase 2** | **5–7 weeks** |
