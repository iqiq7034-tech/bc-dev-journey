# Shopify ↔ Business Central Integration

A custom Business Central extension built in AL Language that creates
a live integration between Shopify and Microsoft Dynamics 365 Business Central.
Shopify orders are automatically pulled into BC as Sales Orders.

---

## What This Project Does

When a customer places an order on Shopify:

1. Business Central exposes secure custom API endpoints
2. Shopify order is pulled into BC by the sync codeunit
3. Customer is matched against BC customer database by email
4. Item is matched against BC items by SKU
5. Sales Order is created in BC automatically with all lines
6. Duplicate prevention ensures same order is never created twice
7. Job Queue can run the sync automatically every night at 2am

---

## Tech Stack

| Technology                        | Purpose                     |
| --------------------------------- | --------------------------- |
| AL Language                       | BC extension development    |
| Business Central 23 (on-premises) | ERP system                  |
| Shopify Partner Development Store | E-commerce platform         |
| ngrok                             | Expose local BC to internet |
| Postman                           | API testing and debugging   |
| VS Code + AL Extension            | Development environment     |

---

## Project Structure

```
ShopifyBC/
│
├── API/
│   ├── APISalesOrder.Page.al       → exposes Sales Orders as API endpoint
│   ├── APICustomer.Page.al         → exposes Customers as API endpoint
│   └── APIItem.Page.al             → exposes Items as API endpoint
│
├── Permissions/
│   └── ShopifyPermission.PermissionSet.al  → security layer for Shopify user
│
├── ShopifyIntegration.Codeunit.al  → core sync logic
├── ShopifyRunPage.Page.al          → manual trigger page in BC
└── README.md
```

---

## Architecture

```
┌─────────────────────┐         ┌────────────────────────────┐
│    SHOPIFY STORE     │         │    BUSINESS CENTRAL         │
│                     │         │                            │
│  Customer places    │         │  APISalesOrder.Page.al      │
│  order              │         │  APICustomer.Page.al        │
│                     │         │  APIItem.Page.al            │
│  Shopify Admin API  │◄────────│                            │
│  /orders.json       │         │  ShopifyIntegration         │
│                     │         │  Codeunit                   │
└─────────────────────┘         │                            │
         ▲                      │  Sales Orders created       │
         │                      │  automatically              │
      ngrok                     │                            │
   tunnel layer                 │  Job Queue                  │
   (free tier)                  │  nightly 2am               │
         │                      └────────────────────────────┘
         ▼
  localhost:7048
  BC OData port
```

---

## API Endpoints

Base URL:

```
http://localhost:7048/BC230/api/shopifybc/shopify/v1.0/companies({companyId})/
```

| Method | Endpoint                                 | Description                      |
| ------ | ---------------------------------------- | -------------------------------- |
| GET    | /shopifyCustomers                        | Get all BC customers             |
| GET    | /shopifyCustomers?$filter=email eq '...' | Find customer by email           |
| GET    | /shopifyItems                            | Get all BC items with live stock |
| GET    | /shopifyItems?$filter=number eq '...'    | Find item by number              |
| GET    | /shopifySalesOrders                      | Get all synced orders            |
| POST   | /shopifySalesOrders                      | Create new Sales Order           |

---

## Authentication

This project uses Windows Authentication for local BC.

For API testing in Postman:

```
Auth Type: NTLM Authentication
Username:  HP
Domain:    DESKTOP-3B7QT8D
Password:  (blank — Windows Auth)
```

> Note: Cloud BC would use OAuth 2.0 with Azure AD.
> Local BC uses Windows Auth automatically in browser
> but requires NTLM in external tools like Postman.
> This is the key difference nobody warns you about.

---

## How to Set Up Locally

### Prerequisites

```
- Business Central 23 (on-premises, local install)
- VS Code with AL Language extension
- ngrok free account
- Postman
- Shopify Partner account (free)
```

### Step 1 — Clone the repository

```bash
git clone https://github.com/yourusername/ALProject2.git
cd ALProject2/Month2/ShopifyBC
```

### Step 2 — Configure launch.json

```json
{
  "type": "al",
  "request": "launch",
  "name": "Your Own Server",
  "server": "http://localhost",
  "serverInstance": "BC230",
  "port": 7048,
  "authentication": "Windows",
  "schemaUpdateMode": "ForceSync"
}
```

### Step 3 — Update Shopify credentials in codeunit

Open `ShopifyIntegration.Codeunit.al` and update:

```al
local procedure GetShopifyOrdersUrl(): Text
begin
    exit('https://YOUR-STORE.myshopify.com/admin/api/2024-01/orders.json?status=any&limit=50');
end;

local procedure GetShopifyToken(): Text
begin
    exit('shpat_YOUR_TOKEN_HERE');
end;
```

### Step 4 — Update default customer number

Find this line and replace with a real BC customer number:

```al
exit('10000'); // your real BC customer number
```

### Step 5 — Publish to BC

```
Press Ctrl + Shift + P
Type: AL: Publish
Press Enter
```

### Step 6 — Assign Permission Set

```
BC → Users → Your User
→ Add Permission Set: SHOPIFY INTEGRATION
```

### Step 7 — Start ngrok

```bash
cd C:\Users\hp\Downloads\ngrok-v3-stable-windows-amd64
ngrok http 7048
```

### Step 8 — Run the sync manually

```
BC Search → Run Shopify Sync
Actions → Run Shopify Sync Now
```

### Step 9 — Check BC Sales Orders

```
BC → Sales Orders
New order should appear with Shopify Order ID
in the External Document No. field
```

---

## Key Design Decisions

### Why External Document No. for Shopify Order ID?

BC has a built-in field called External Document No. on Sales Header.
Instead of creating a custom field, we reuse this existing field
to store the Shopify Order ID. This avoids table changes and
keeps the extension lightweight.

### Why GTIN field for Shopify Product ID?

BC items have a GTIN field normally used for barcodes.
We reuse it to store the Shopify Product ID mapping.
Same principle — no custom fields needed.

### Why Windows Auth instead of OAuth?

This project runs on local on-premises BC which uses
Windows Authentication by default. OAuth 2.0 with Azure AD
is only available on cloud BC (SaaS). The NTLM approach
in Postman is the correct solution for local environments.

### Why duplicate check before insert?

Without checking External Document No. first, running the sync
twice would create duplicate Sales Orders. The check ensures
idempotency — running sync 10 times gives the same result
as running it once.

---

## What I Learned Building This

This project taught me how real ERP integrations work in practice.
The biggest challenge was discovering that local BC authentication
works completely differently from cloud BC. No tutorial covers this
because most tutorials assume cloud deployment.

Using Windows Auth with NTLM in Postman instead of Basic Auth
with Web Service Access Key was the key breakthrough. Once that
clicked, everything else flowed naturally.

The ngrok tunnel was a simple but powerful solution for making
local BC reachable from Shopify without any cloud deployment.
For a portfolio project and learning environment this approach
is perfectly valid and demonstrates the same integration concepts
that would apply in production.

---

## Future Improvements

```
→ Add proper Error Log table in BC for failed syncs
→ Handle customer creation automatically if not found
→ Add webhook support for real-time sync instead of polling
→ Move to OAuth 2.0 when deploying to cloud BC
→ Add inventory reservation before order confirmation
→ Build a BC dashboard page to monitor sync status
→ Handle Shopify order updates and cancellations
→ Add unit tests with AL test codeunits
```

---

## Project Timeline

| Day    | Milestone                                           |
| ------ | --------------------------------------------------- |
| Day 52 | Project planning and architecture design            |
| Day 53 | Project announcement on LinkedIn                    |
| Day 54 | BC API layer complete (3 API pages + PermissionSet) |
| Day 55 | Authentication solved — NTLM vs OAuth discovery     |
| Day 56 | Shopify connected — first order synced to BC        |
| Day 57 | Job Queue automation + duplicate prevention         |
| Day 58 | GitHub push + README + project complete             |

---

## Part of My BC Developer Journey

This project is the final project of Month 2 in my
3-month Business Central developer learning plan.

| Month   | Focus                                              | Status      |
| ------- | -------------------------------------------------- | ----------- |
| Month 1 | BC Fundamentals, AL basics, Tables, Pages, APIs    | Complete    |
| Month 2 | APIs, Authentication, Integration, Shopify Project | Complete    |
| Month 3 | Power Automate, Azure Functions, Advanced AL       | In Progress |

---

## Author

**Iqra Tasneem**
Business Central Developer | AL Language | ERP Integration

- LinkedIn: linkedin.com/in/iqratasneem
- GitHub: github.com/yourusername

---

_Built with AL Language on Microsoft Dynamics 365 Business Central 23_
