# 🏥 US Insurance Analytics Dataset

A relational insurance dataset built for practicing **MySQL** and **Power BI**.

---

## 📁 Files
| File | Rows | Description |
|---|---|---|
| `customers.csv` | 200 | Policyholder details |
| `policies.csv` | 250 | Insurance policies |
| `claims.csv` | 150 | Claims made against policies |
| `risk_profile.csv` | 200 | Customer health & risk data |
| `insurance_db.sql` | — | MySQL database file |

---

## 🔗 Table Relationships
```
customers ──► policies ──► claims
customers ──► risk_profile
```

---

## 🛠️ Tools Used
- **MySQL** — querying and data transformation
- **Power BI** — dashboard and KPI visualisation

---

## 📌 Notes
- Data are not real, meant to silmulate a real-life insurance dataset
- USA-based — all 50 states + Washington D.C.
