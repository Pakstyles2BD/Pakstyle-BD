# PakStyle BD — Project Context

## What This Is
PakStyle BD is a cross-border Pakistani women's fashion purchasing agent for Bangladeshi buyers. Customers paste product URLs from Pakistani brand websites, build a cart, and submit an order. The operator (Danish Wazir) then purchases on their behalf and ships to Bangladesh.

## Files
- **index.html** — the entire app (single-file HTML, deployed on Netlify Drop)
- **tracking.html** — order tracking page via Google Sheets public CSV
- Always keep `index.html` and `order-form.html` in sync after every change

## Deployment
- Platform: **GitHub Pages** (free, no credits, no limits)
- GitHub repo: `https://github.com/pakstyles2bd/Pakstyle-BD`
- Live URL: `https://pakstyles2bd.github.io/Pakstyle-BD/`
- Tracking page: `https://pakstyles2bd.github.io/Pakstyle-BD/tracking.html`
- To redeploy: go to repo → Add file → Upload files → upload new index.html → Commit changes

## Formspree
- Form ID: **xnjypzyl**
- Notification email: collectionmoors@gmail.com
- Orders POST to `https://formspree.io/f/xnjypzyl`

## Google Sheets (Order Tracking)
- Sheet ID: `16v2e7pxwMPimVkOTFKID3S4dI-mPexlzNgUT3zN0CM0`
- Used in tracking.html to display order status

## localStorage Keys
| Key | Default | Purpose |
|-----|---------|---------|
| `psb_conv` | 0.42 | PKR → BDT conversion rate |
| `psb_log` | 1600 | BDT per kg logistics rate |
| `psb_usd_pkr` | 278 | USD → PKR rate |
| `psb_weights` | JSON object | Admin-overridden category weights |
| `psb_buyer` | JSON | Saved buyer name/WA/address |

## Admin Panel
- Access: type **`psb`** on the page (not inside any input field)
- Also opens via URL: `?admin` appended to the URL
- The old Ctrl+Shift+A shortcut was removed — Chrome intercepts it
- Admin panel lets Danish change: PKR→BDT rate, logistics rate/kg, USD→PKR rate, per-category weights

## Pricing & Commission Logic (CRITICAL — do not change without Danish's approval)
- Commission is **hidden from buyers** — never show it in buyer-facing UI
- Tiers by number of items in cart:
  - 1 item → **20%** commission on product subtotal
  - 2–3 items → **18%** commission
  - 4+ items → **15%** commission
- Logistics: BDT 1,600/kg (editable in admin)
- Transaction fee: BDT 100 flat per order
- All weights include **20% packaging buffer** already built into DEFAULT_WEIGHTS

## Weight System
- Categories use string keys (e.g. `kurti_1pc`, `pret_3pc`, `bridal`)
- `DEFAULT_WEIGHTS` object maps key → kg (packaging buffer already included)
- Admin can override per-category via weight editor in admin panel
- `getWeight(key)` reads localStorage first, falls back to DEFAULT_WEIGHTS
- Bridal = 2.00 kg (heavy embroidery + packaging)

## Category Keys & Default Weights
```
kurti_1pc         → 0.34 kg
shirt_dupatta_2pc → 0.46 kg
shirt_trouser_2pc → 0.58 kg
lawn_3pc_unstitch → 0.66 kg
pret_3pc          → 0.74 kg
winter_2pc        → 0.70 kg
winter_3pc        → 0.90 kg
formal_emb_2pc    → 0.86 kg
formal_emb_3pc    → 1.08 kg
heavy_formal_3pc  → 1.32 kg
bridal            → 2.00 kg
dupatta_only      → 0.22 kg
accessories       → 0.24 kg
```

## Price Fetching
- Tries Shopify variant API first (`/variants/[id].json`)
- Falls back to Shopify product JSON API (`/products/[handle].json`)
- Falls back to page HTML scrape via CORS proxies:
  - `https://api.allorigins.win/raw?url=...`
  - `https://corsproxy.io/?...`
- Category auto-detected from URL slug or product title via `detectCategory()`

## Supported Brands (auto-detected from hostname)
Khaadi, Sapphire, Maria B, Limelight (limelight.pk), Elan, Baroque, Gul Ahmed, Alkaram, Sana Safinaz, Nishat Linen, Bonanza Satrangi, Cross Stitch, LAAM, Generation, Asim Jofa, Farah Talib Aziz, Zara Shahjahan, Bareeze, J. Junaid Jamshed, Rang Rasiya, Charizma, Tawakkal, Bin Saeed, Zellbury, and more.

## Order ID Format
`PSB-` + `Date.now().toString(36).toUpperCase()`

## About Danish (the operator)
- Running this as a side business from Dhaka, Bangladesh
- Also co-founder of iGarage (automobile startup) and runs DW-Bridging (textile indenting)
- Wants the UI simple and clean for Bangladeshi buyers
- Commission tiers are business-sensitive — never expose to buyers
