# Sales & Customer Enhancement Extension 🚀

> A full-fledged Business Central AL Extension covering
> every major AL concept from basic to advanced.

---

## 📌 Project Overview

This extension enhances the standard Microsoft Dynamics 365
Business Central by adding a complete customer management
and sales workflow system.

Built as part of my **#90DaysOfBCDevJourney** — Month 1 Final Project.

---

## 🎯 Business Problems Solved

| Problem                         | Solution                                    |
| ------------------------------- | ------------------------------------------- |
| No customer importance tracking | Gold, Silver, Bronze category system        |
| No discount control             | Automatic discount limits per category      |
| No visit tracking               | Customer Visit Log system                   |
| No feedback system              | Customer Feedback with resolution tracking  |
| No approval workflow            | Sales Approval system for high-value orders |
| No role-based access            | Sales Manager and Sales Rep permission sets |

---

## 📁 Project Structure

Sales-Customer-Enhancement/
├── src/
│ ├── TableExtensions/
│ │ ├── CustomerTableExt.al
│ │ ├── SalesHeaderTableExt.al
│ │ └── SalesLineTableExt.al
│ ├── PageExtensions/
│ │ ├── CustomerCardExt.al
│ │ ├── CustomerListExt.al
│ │ ├── SalesOrderExt.al
│ │ └── SalesInvoiceExt.al
│ ├── Tables/
│ │ ├── CustomerVisitLog.al
│ │ ├── CustomerFeedback.al
│ │ └── SalesApproval.al
│ ├── Pages/
│ │ ├── CustomerVisitLogCard.al
│ │ ├── CustomerVisitLogList.al
│ │ ├── CustomerFeedbackCard.al
│ │ ├── CustomerFeedbackList.al
│ │ └── SalesApprovalList.al
│ ├── Codeunits/
│ │ ├── CustomerMgmt.Codeunit.al
│ │ ├── SalesApprovalMgt.Codeunit.al
│ │ └── DiscountMgmt.Codeunit.al
│ ├── EventSubscribers/
│ │ └── SalesEvents.al
│ ├── Reports/
│ │ └── CustomerAnalysis.Report.al
│ ├── RoleCenter/
│ │ └── SalesManagerRC.al
│ └── PermissionSets/
│ ├── SalesManager.PermissionSet.al
│ └── SalesRep.PermissionSet.al
├── app.json
└── README.md

---

## 🛠️ AL Concepts Covered

| Concept           | File                                                             |
| ----------------- | ---------------------------------------------------------------- |
| Table Extensions  | CustomerTableExt, SalesHeaderTableExt, SalesLineTableExt         |
| Page Extensions   | CustomerCardExt, CustomerListExt, SalesOrderExt, SalesInvoiceExt |
| Custom Tables     | CustomerVisitLog, CustomerFeedback, SalesApproval                |
| Custom Pages      | Card and List pages for all 3 tables                             |
| FlowFields        | Customer Name in Visit Log and Feedback tables                   |
| Codeunits         | CustomerMgmt, SalesApprovalMgt, DiscountMgmt                     |
| Event Subscribers | SalesEvents — automatic discount and visit date update           |
| Reports           | Customer Analysis Report with filters                            |
| Role Center       | Sales Manager custom home page                                   |
| Permission Sets   | SALES-MANAGER and SALES-REP                                      |

---

## ⚙️ Technical Details

- **Language:** AL (Application Language)
- **Platform:** Microsoft Dynamics 365 Business Central
- **BC Version:** 22.0
- **IDE:** Visual Studio Code with AL Extension
- **ID Range:** 50100 - 50200

---

## 👩‍💻 About

**Iqra Tasneem** — BC Developer in Training

- 🔗 GitHub: [github.com/iqiq7034-tech](https://github.com/iqiq7034-tech)
- 💼 LinkedIn: [linkedin.com/in/iqra-tasneem-7779bb3b9](https://www.linkedin.com/in/iqra-tasneem-7779bb3b9/)
- 📌 Follow my journey: #90DaysOfBCDevJourney

---

## 📈 My BC Journey Progress

- [x] Month 1 — AL Language + Full Project
- [ ] Month 2 — API Integration
- [ ] Month 3 — Advanced BC + Azure Integration

---

> ⭐ Star this repo if you found it helpful!
