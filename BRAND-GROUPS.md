# PakStyle BD — Brand Auto-Fetch Groups & Solutions

**Goal:** every brand auto-fetches **Category · PKR Price · In-stock Sizes** for a buyer in Bangladesh.
(Qty is always the buyer's manual choice — no website can supply it.)

**Survey basis:** all 94 brand domains probed from a Pakistani IP (Karachi) on 2026-06-12 — the same
vantage point the VPS relay will have. Checked: Shopify product API (`/products.json`, `/products/{handle}.js`),
session currency (`/cart.js`), product-page structured data (`priceCurrency`), and redirect/twin domains.

**Status legend:** ✅ done · 🔧 needs build · ⏳ needs VPS · ✋ manual fallback

---

## Summary

| Group | What it is | Brands | Auto today? | Auto after VPS? |
|---|---|---:|---|---|
| **1** | Shopify, native PKR | 73 | ✅ from PK only | ✅ guaranteed for BD |
| **2** | Twin sites (intl + PK store) | 7 | ⚠️ only if PK URL pasted | ✅ via twin-map + relay |
| **3** | No PKR price exists online (USD/INR only) | 3 | ❌ | ❌ (manual USD) |
| **4** | Non-Shopify, no product API | 13 | ❌ | partial (Khaadi/Sapphire scrape) |
| **5** | Dead / wrong directory links | 3 | — | — (cleanup) |

> Note: Khaadi & Sapphire are counted in **both** Group 2 (twin sites) and Group 4 (non-Shopify),
> because they are twin-store *and* have no Shopify API. They are the priority special-cases.

---

## GROUP 1 — ✅ Full auto (Shopify, native PKR) — 73 brands

Category, PKR price, in-stock sizes all auto-fill **today** from a Pakistani IP. From **Bangladesh**, some
geo-switch to USD; the `cart.js` currency check (shipped) detects it per-product and the **relay** silently
refetches the PKR version. This is the group the VPS makes bulletproof.

**Probable solution:** VPS relay (already wired). No per-brand work — just confirm each from a BD IP after VPS is live.

Afrozeh, Agha Noor, Alizeh, Alkaram, Almirah, Amir Adnan, Armas, Asim Jofa, Bachaa Party, Barae Khanom*,
Bareeze*, Beechtree, Bin Ilyas, Bin Saeed, Bonanza Satrangi, Breakout, Cambridge, Charcoal, Charizma,
ChenOne, Chinyere, Crimson, Cross Stitch, Diners, Edenrobe, Elan, ETHNC, Faiza Saqlain, Farasha, Furor,
Generation, Gulaal, Gul Ahmed, Hopscotch, Hussain Rehar, Ismail Farid, J. Junaid Jamshed, Jazmin, Kayseria,
Khas Stores, Kross Kulture, Lakhany, Limelight, Maria B, Minnie Minors, Monark, Motifz, MTJ, Mushq,
Nishat Linen, Nureh, Outfitters, Ramsha, Rang Ja, Rang Rasiya, Republic Menswear, Republic Womenswear,
Royal Tag, Saad Bin Shahzad, Sana Safinaz, Shahnameh, Sha Posh, Silayi Pret, Sobia Nazir, Tawakkal Fabrics,
Tena Durrani, Threads & Motifs, Uniworth, WearEgo, Zaha, Zara Shahjahan, Zarif, Zellbury

> *Barae Khanom & Bareeze: in Group 1 **only via the correct PK domain** — see Group 5 directory fixes.

---

## GROUP 2 — 👯 Twin websites: separate international + Pakistani stores — 7 brands

Two real stores per brand. **Risk:** buyer pastes the *international* URL → gets USD price, or a product
that isn't carried on the PK store at all.

| Brand | International site | Pakistani site | PK store currency | Notes |
|---|---|---|---|---|
| ETHNC | ethnc.com (USD) | pk.ethnc.com | ✅ PKR (Shopify) | clean twin-map case |
| Generation | generation.pk (USD!) | generation.com.pk | ✅ PKR (Shopify) | .pk is the *intl* one — counter-intuitive |
| Bareeze | bareeze.com (custom/no API) | bareezepk.com | ✅ PKR (Shopify) | |
| Maria B | mariab.com (bot-walled) | mariab.pk | ✅ PKR (Shopify) | |
| Baroque | baroque.com (domain for sale) | baroque.com.pk | ❌ USD even to PK | PK store still prices USD |
| **Khaadi** | khaadi.com (USD) | pk.khaadi.com | — (Salesforce, no API) | also Group 4 |
| **Sapphire** | geo-redirect | pk.sapphireonline.pk | — (Salesforce, no API) | also Group 4 |

**Probable solution:** **Twin-map in the form** — when an international URL is pasted, take the product handle
and refetch from the PK twin domain. Found → PKR price + PK stock. 404 → red warning "not available on the
Pakistani store." Works **without VPS** for the Shopify twins (ETHNC, Generation, Bareeze, Maria B). Baroque
needs manual USD (no PKR exists). Khaadi/Sapphire need the Group-4 scraper.

---

## GROUP 3 — 💵 No PKR price exists anywhere online — 3 brands

Confirmed USD checkout; any on-screen "PKR" is a client-side converter app, **not** the real price.

| Brand | Site | Evidence |
|---|---|---|
| Salitex | salitex.com | `Shopify.currency {active:USD}`, no PKR on page, PK-localized session stays USD |
| Sania Maskatiya | saniamaskatiya.com | base USD; PK session returns $104.00; visible PKR is app-converted |
| Zainab Chottani | zainabchottani.com | base USD; PK session returns $77.00; checkout charges USD |

**Probable solution:** No automated PKR possible. Manual USD entry (form handles loudly), **or** source the
same article via a PK multi-brand retailer (e.g. LAAM) when available. Candidate for removal if low demand.

---

## GROUP 4 — ✋ Non-Shopify, no product API — 13 brands

No `/products.json`. Auto-fetch impossible by the normal path; the red "stock could NOT be verified" warning
shows correctly today.

| Brand | Platform | Priority |
|---|---|---|
| **Khaadi** | Salesforce Commerce Cloud | HIGH — flagship |
| **Sapphire** | Salesforce Commerce Cloud | HIGH — flagship |
| Image | Magento | low |
| Naushemian | Magento | low |
| Thredz | Magento | low |
| Cougar | custom (Next.js) | low |
| Deepak Perwani | custom | low |
| Erum Khan | bot-blocked (retest from VPS) | low |
| Ittehad | custom | low |
| LAAM (multi-brand) | custom/Shopify-hybrid | MED — big catalog |
| Mohsin Naveed Ranjha | custom | low |
| Nomi Ansari | bot-blocked (retest from VPS) | low |
| Savoir | unreachable (retest from VPS) | low |
| Warda | bot-blocked (retest from VPS) | low |

**Probable solution:** **Relay HTML-scrape from the PK IP** — fetch the product page server-side and parse the
embedded JSON-LD (`priceCurrency`/`price`/`offers`) that these sites emit for Google Shopping. Per-brand
parser work; do **Khaadi + Sapphire first** (must come from a PK IP → needs VPS). Bot-blocked ones may simply
work once requested from the VPS with a real browser UA — retest before writing parsers.

---

## GROUP 5 — 💀 Dead / wrong directory links — 3 fixes

| Brand | Current directory URL | Problem | Fix |
|---|---|---|---|
| Barae Khanom | embellishedkurtas.com | **Indian INR store** | repoint → **baraekhanom.pk** (✅ Shopify PKR) → moves to Group 1 |
| Baroque | baroque.com | domain parked / for sale | repoint → **baroque.com.pk** (but USD — Group 2/3) |
| Farah Talib Aziz | farahtalibaziz.com | parked lander; .com.pk also down | find current domain or remove |
| Suffuse | suffuse.com | "Coming Soon" / offline | remove or revisit later |

**Probable solution:** edit `BRANDS`/`BRAND_MAP` in `order-form.html`. Quick win, no VPS needed.

---

## Build backlog (per group)

- [ ] **G5** Fix directory URLs (Barae Khanom, Baroque, FTA, Suffuse) — *form only, do now*
- [ ] **G2** Twin-map: intl→PK handle refetch + "not in PK store" warning — *form only*
- [ ] **VPS** Provision CloudVPS.pk, verify PK geolocation, deploy relay + HTTPS — *blocks G1-BD & G4*
- [ ] **G1** After VPS: confirm each brand from a Dhaka IP; relay handles USD-switchers
- [ ] **G4** Khaadi + Sapphire JSON-LD scraper on relay (PK IP); retest bot-blocked brands
- [ ] **G3** Decide: keep with manual-USD, or remove Salitex / Sania Maskatiya / Zainab Chottani

_Last surveyed: 2026-06-12 from Karachi PK IP. Re-run survey from Dhaka after VPS to validate Group 1 USD-switchers._
