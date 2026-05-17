# 🔔 BC Webhook System + API Health Dashboard

> **Day 47–48 of #90DaysOfBCDevJourney — Month 2: API Integration**
>
> A complete, production-ready webhook receiver and API health monitoring system built in Microsoft Dynamics 365 Business Central using AL language.

---

## 📋 Table of Contents

- [Overview](#overview)
- [What This Project Demonstrates](#what-this-project-demonstrates)
- [Architecture](#architecture)
- [Object Reference](#object-reference)
- [Getting Started](#getting-started)
- [How to Test](#how-to-test)
- [Understanding the 401 Response](#understanding-the-401-response)
- [Job Queue Setup](#job-queue-setup)
- [Known Limitations & Future Improvements](#known-limitations--future-improvements)
- [Learning Journey Context](#learning-journey-context)
- [Author](#author)

---

## Overview

This project implements two connected systems in Business Central:

1. **Webhook Receiver** — an API page that acts as an endpoint, receiving real-time POST notifications from external systems (Shopify, Azure, GitHub, etc.), parsing the JSON payload, and routing events to the correct handler.

2. **API Health Dashboard** — a monitoring page that shows the status of your webhook log and the liveness of your BC API endpoint, with automatic ping history stored over time.

Together they form a real-world integration pattern: external systems push changes → BC receives and processes them → a dashboard surfaces the health of the entire pipeline.

---

## What This Project Demonstrates

| Concept                                     | Where It Appears                                                 |
| ------------------------------------------- | ---------------------------------------------------------------- |
| API Page as a webhook endpoint              | `page 50106 Webhook Receiver`                                    |
| JSON parsing with guard clauses             | `codeunit 50104 Webhook Manager` → `ProcessIncomingNotification` |
| Event-driven routing (`case` on changeType) | `Webhook Manager` → `HandleCreatedEvent` etc.                    |
| HTTP client calls from AL                   | `RegisterBCSubscription`, `GetSubscriptions`, `RunHealthCheck`   |
| API Setup table pattern (Day 17)            | `RunHealthCheck` reads URL from setup                            |
| StyleExpr for visual alerting               | `page 50110 API Health Dashboard` → Unprocessed field            |
| Job Queue integration                       | `codeunit 50110 API Health Checker`                              |
| Simulation for local testing                | `SimulateIncomingWebhook`                                        |
| DelayedInsert on API page                   | `page 50106 Webhook Receiver`                                    |

---

## Architecture

```
External System (Shopify / Azure / GitHub)
        │
        │  HTTP POST  (JSON payload)
        ▼
┌─────────────────────────┐
│  page 50106             │
│  Webhook Receiver       │  ← BC API endpoint
│  (API Page)             │     /api/v2.0/cronus/webhooks/webhookNotifications
└────────────┬────────────┘
             │ OnInsertRecord trigger
             ▼
┌─────────────────────────┐
│  codeunit 50104         │
│  Webhook Manager        │  ← parses JSON, routes event
│                         │
│  ProcessIncomingNotif.  │
│  HandleCreatedEvent     │
│  HandleUpdatedEvent     │
│  HandleDeletedEvent     │
│  RegisterBCSubscription │
│  SimulateIncomingWebhook│
│  GetSubscriptions       │
└────────────┬────────────┘
             │ inserts / modifies
             ▼
┌─────────────────────────┐
│  table 50105            │
│  Webhook Log            │  ← every notification stored here
└────────────┬────────────┘
             │ read by
             ▼
┌─────────────────────────┐      ┌──────────────────────────┐
│  page 50110             │      │  codeunit 50107          │
│  API Health Dashboard   │ ◄────│  API Health Checker      │
│                         │      │                          │
│  Webhook Status section │      │  RunHealthCheck (→ Job Q)│
│  API Ping Status section│      │  GetLastWebhookInfo      │
│  Ping Now action        │      │  GetLastHealthStatus     │
└────────────┬────────────┘      └──────────────┬───────────┘
             │                                  │ inserts
             ▼                                  ▼
┌─────────────────────────┐      ┌──────────────────────────┐
│  page 50107             │      │  table 50107            │
│  Webhook Log List       │      │  API Health Log          │
└─────────────────────────┘      └──────────────────────────┘
                                           ▲
                                           │ read by
                                 ┌─────────┴──────────┐
                                 │  page 50109        │
                                 │  API Health Log    │
                                 │  List              │
                                 └────────────────────┘
```

---

## Object Reference

### Tables

| ID      | Name             | Purpose                                                                                                     |
| ------- | ---------------- | ----------------------------------------------------------------------------------------------------------- |
| `50105` | `Webhook Log`    | Stores every incoming webhook notification — payload, event type, resource, processed status, error message |
| `50110` | `API Health Log` | Stores the result of every API ping — HTTP status code, response time in ms, healthy flag, error            |

### Codeunits

| ID      | Name                 | Purpose                                                                                           |
| ------- | -------------------- | ------------------------------------------------------------------------------------------------- |
| `50104` | `Webhook Manager`    | Core webhook logic: JSON parsing, event routing, subscription registration, simulation            |
| `50110` | `API Health Checker` | Health monitoring logic: pings the API, logs results, summarises webhook status for the dashboard |

### Pages

| ID      | Name                   | Type | Purpose                                                             |
| ------- | ---------------------- | ---- | ------------------------------------------------------------------- |
| `50106` | `Webhook Receiver`     | API  | The actual HTTP endpoint — external systems POST here               |
| `50107` | `Webhook Log List`     | List | View all received webhooks, mark as processed, simulate, clear      |
| `50110` | `API Health Dashboard` | Card | Live summary of webhook backlog + API ping status                   |
| `50111` | `API Health Log List`  | List | Full history of every API ping with status codes and response times |

---

## Getting Started

### Prerequisites

- Microsoft Dynamics 365 Business Central (on-premises or SaaS)
- VS Code with the **AL Language** extension
- A BC development environment/sandbox

### Installation

1. Clone this repository:

   ```bash
   git clone https://github.com/YOUR_USERNAME/bc-webhook-health-dashboard.git
   cd bc-webhook-health-dashboard
   ```

2. Open the folder in VS Code.

3. Update `app.json` with your publisher name, app ID, and BC version range if needed.

4. Press `F5` to publish to your BC sandbox, or run:

   ```
   Ctrl + Shift + P → AL: Publish
   ```

5. In BC, search for **API Health Dashboard** to open the main page.

---

## How to Test

### Step 1 — Simulate a Webhook (no external system needed)

1. Search for **Webhook Notifications Log** in BC.
2. Click **Simulate Webhook** in the action bar.
3. A fake JSON payload is inserted and processed automatically.
4. You will see a new entry in the log with `EventType = created` and `Source = Simulation`.

The simulated payload looks like this:

```json
{
  "value": [
    {
      "subscriptionId": "test-sub-001",
      "clientState": "secret123",
      "changeType": "created",
      "resource": "api/v2.0/customers(abc-123)",
      "resourceData": {}
    }
  ]
}
```

### Step 2 — Run a Health Check

1. Open **API Health Dashboard**.
2. Click **Ping API Now**.
3. The dashboard refreshes — check the API Ping Status section.
4. Open **Open Health Log** to see the full history.

### Step 3 — Check the Unprocessed Alert

1. Simulate two or three webhooks without clicking **Mark as Processed**.
2. Open the **API Health Dashboard**.
3. The **Unprocessed** counter turns orange (StyleExpr fires when value > 0).

### Step 4 — Register a Real Subscription (optional)

Call `RegisterBCSubscription` from the Webhook Manager codeunit, passing:

- `ExternalUrl` — the URL where BC should receive notifications (must be publicly accessible HTTPS)
- `ClientSecret` — a shared secret string for validation

```al
// Example call from another codeunit or page action:
WebhookMgr.RegisterBCSubscription(
    'https://your-public-url.com/api/v2.0/cronus/webhooks/webhookNotifications',
    'your-secret-string'
);
```

---

## Understanding the 401 Response

When you run **Ping API Now**, the health log shows HTTP **401** with the Healthy toggle off.

**This is expected and correct.**

| Status             | Meaning                             | Is the server alive? |
| ------------------ | ----------------------------------- | -------------------- |
| `0` or timeout     | Could not reach the server          | ❌ No                |
| `401 Unauthorized` | Server answered — auth required     | ✅ Yes               |
| `200 OK`           | Server answered — and authenticated | ✅ Yes               |

The health checker pings without OAuth credentials on purpose. The goal is to verify the endpoint is **reachable**, not fully authenticated. A 401 response proves the server is alive and responding.

The `IsHealthy` flag currently uses `Response.IsSuccessStatusCode()` which only returns `true` for HTTP 200–299. A future improvement (see below) will separate **reachable** from **authenticated**.

---

## Job Queue Setup

To have BC ping your API automatically every hour:

1. Search **Job Queue Entries** in BC.
2. Click **New**.
3. Fill in:

   | Field                       | Value                       |
   | --------------------------- | --------------------------- |
   | Object Type to Run          | `Codeunit`                  |
   | Object ID to Run            | `50110`                     |
   | Description                 | `API Health Check - Hourly` |
   | Run on Mondays–Fridays      | ✅                          |
   | Starting Time               | `08:00:00`                  |
   | Ending Time                 | `18:00:00`                  |
   | No. of Minutes between Runs | `60`                        |

4. Set the status to **Ready**.

The Job Queue will now call `RunHealthCheck` automatically — no manual pinging needed.

---

## Known Limitations & Future Improvements

### Current Limitations

| Issue                           | Detail                                                                                                                    |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------- |
| `Payload` field is `Text[2048]` | Large webhook payloads will be truncated. Real production systems need a BLOB field.                                      |
| `IsHealthy` only checks 200–299 | Does not distinguish "reachable but needs auth" (401) from "broken" (0/timeout).                                          |
| `Message()` in handlers         | `HandleCreatedEvent` etc. use `Message()` — not suitable for background/Job Queue execution. Replace with logging.        |
| Localhost URL hardcoded         | `RegisterBCSubscription` and `GetSubscriptions` use `http://localhost:7048/BC230/`. Should read from the API Setup table. |
| No webhook signature validation | `clientState` is stored but not verified against a known secret on every incoming request.                                |

### Planned Improvements (Week 4+)

- [ ] Replace `Message()` with proper error logging codeunit
- [ ] Separate `IsReachable` (any HTTP response) from `IsAuthenticated` (200–299) in the health checker
- [ ] Read endpoint URL from API Setup table instead of hardcoding
- [ ] Validate `clientState` on every incoming webhook for security
- [ ] Extend `Payload` to BLOB for large payloads
- [ ] Add retry logic for failed webhook processing

---

## Learning Journey Context

This project was built on **Day 47-48** of the #90DaysOfBCDevJourney.

```
Month 1  ──  AL Language Fundamentals (complete)
Month 2  ──  API Integration (current)
  Week 1 ── REST APIs & HttpClient
  Week 2 ── External API consumption
  Week 3 ── OAuth + Webhooks + Job Queue  ← this project
  Week 4 ── Error Handling & Logging
Month 3  ──  Power BI + Power Automate (coming)
```

**Topics demonstrated in this project:**

- Day 44 — OAuth 2.0 concept (401 response = auth required)
- Day 45 — HttpClient in AL
- Day 46 — API Setup table pattern
- Day 47 — Webhooks: receiving + subscribing
- Day 48 — Job Queue for automated API calls

---

## Author

**[Iqra Tasneem]**
Microsoft Dynamics 365 Business Central Developer
#90DaysOfBCDevJourney — Month 2

🔗 LinkedIn: [https://www.linkedin.com/in/iqra-tasneem-7779bb3b9/]
🐙 GitHub: [https://github.com/iqiq7034-tech/bc-dev-journey]

---

> _"Alhamdulillah."_
>
> — #90DaysOfBCDevJourney, Day 48
