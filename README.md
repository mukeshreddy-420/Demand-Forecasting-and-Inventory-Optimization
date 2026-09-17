# OptiRetail AI — Demand Forecasting & Inventory Optimization Agent
## M8: Frontend + DevOps + QA Platform Documentation

This repository houses the complete, enterprise-grade web application for the **Demand Forecasting and Inventory Optimization Agent**. Built specifically to serve retail inventory managers, replenishment planners, and executive stakeholders with clear, high-contrast, actionable intelligence.

---

## 1. Role & Architectural Boundaries (M8 Responsibility)

As **M8 (Frontend + DevOps + QA)**, the scope is strictly focused on presentation, user experience, telemetry visualization, conversational AI interfacing, deployment orchestration, and verification:

- **M1**: Project Lead + Integration
- **M2**: Data Engineer
- **M3**: EDA + Feature Engineer
- **M4**: Forecasting ML Engineer *(Models NOT executed on frontend)*
- **M5**: Inventory Optimization Engineer *(Optimization math NOT executed on frontend)*
- **M6**: GenAI / Agent Engineer *(LLM agent served via backend)*
- **M7**: Backend + FastAPI Engineer *(Endpoints target for frontend)*
- **M8**: **Frontend + DevOps + QA (This Project)**

> **Architectural Guardrail**: The frontend contains **zero** machine learning algorithms or inventory optimization formulas. It communicates through a switchable service layer (src/services/api.js) that renders results supplied by the backend. During development, a dedicated mock layer (src/mock/mockData.js, src/services/mockApi.js) simulates the exact FastAPI contract.

---

## 2. Authoritative Dataset & Reference Conformity

All telemetry, dropdowns, and schemas strictly mirror the project's authoritative reference dataset (sales_data 7.csv):
- **Stores**: Exactly S001, S002, S003, S004, S005
- **Products**: Exactly P0001 through P0020 (*Note: P1024 does not exist in the dataset and is strictly excluded*)
- **Merchandise Categories**: Electronics, Clothing, Groceries, Toys, Furniture
- **Geographic Territories**: North, South, East, West
- **Standardized Features**: Date, Store ID, Product ID, Category, Region, Inventory Level, Units Sold, Units Ordered, Price, Discount, Weather Condition, Promotion, Competitor Pricing, Seasonality, Epidemic, Demand

---

## 3. Sidebar Modules & Application Pages

The application provides 11 persistent analytical views accessible via the responsive sidebar:

| Icon | Page | Description |
|---|---|---|
| 🏠 | **Dashboard** | Executive overview with 4 KPI cards (Forecast, Stock, Risk, Reorder), 14-day trajectory chart, stock vs demand comparison, risk donut, and priority replenishment queue. |
| 📊 | **Demand Forecast** | Multi-horizon predictive demand modeler (7, 14, 30 days) with confidence intervals and day-by-day forecast schedule. |
| 📦 | **Inventory Pulse** | Real-time stock monitor tracking Healthy, Low, and Critical SKU buffers and network inventory valuations. |
| 🚨 | **Risk Radar** | Stockout vulnerability radar categorizing items into High, Medium, and Low risk tiers with probability scores. |
| 🔄 | **Reorder Recommendations** | Actionable replenishment queue with "Reorder Now", "Monitor", and "No Reorder Needed" statuses, lead times, and PO approvals. |
| 📈 | **Inventory Optimization** | Tradeoff modeling between carrying costs, stockout penalties, and service level targets (95% optimal minima). |
| 🏬 | **Store & Region Analysis** | Network performance across Stores S001–S005, regional territory demand, and category volume breakdowns. |
| 📋 | **Product Details** | Granular 360° SKU intelligence with weather sensitivity, promotions, competitor pricing, and historical demand trends. |
| 🤖 | **AI Inventory Assistant** | Conversational chat interface for natural-language queries regarding stockout risks, replenishment needs, and demand drivers. Prepares integration with POST /chat. |
| 🔔 | **Alerts** | Operational notification center for critical stockout warnings, demand surges, and acknowledgment tracking. |
| 📤 | **Reports / Export** | Executive reporting suite offering one-click CSV downloads for forecasts, stock balances, risk audits, and PO schedules. |

**Additional Core Workflows:**
- **Enterprise Authentication (/login)**: Sign-in screen with Remember Me, Forgot Password, and session Logout.
- **Dataset Upload & Validation**: In-app CSV upload modal verifying conformity against all 16 required columns without touching the original CSV.

---

## 4. Technology Stack

- **Framework**: React 19 + Vite 8
- **Routing**: React Router DOM 7
- **Styling**: Tailwind CSS v4 (Enterprise dark slate analytics theme)
- **Icons**: Lucide React
- **Data Visualization**: Recharts (Composed charts, bar charts, donuts, confidence bands)
- **Testing & QA**: Vitest + Testing Library
- **DevOps**: Docker, Docker Compose, Nginx Alpine

---

## 5. Getting Started & Local Development

### Prerequisites
- Node.js v18+ (tested on Node v20/v24)
- npm v9+

### 1. Install Dependencies
`ash
cd frontend
npm install
`

### 2. Start Development Server
`ash
npm run dev
`
The application will launch on http://localhost:5173.

### 3. Run Automated QA Tests
`ash
npm test
`
Executes the Vitest suite verifying dataset compliance, endpoint contracts, and UI logic.

### 4. Build for Production
`ash
npm run build
`
Creates an optimized, minified production bundle in dist/.

---

## 6. Deployment & DevOps Setup

### Docker Deployment
Build and run the containerized application using the multi-stage Dockerfile and Nginx:
`ash
# Build Docker image
docker build -t optiretail-frontend .

# Run container on port 80
docker run -p 80:80 optiretail-frontend
`

### Docker Compose
Launch with a single command:
`ash
docker compose up -d
`
Access the application at http://localhost:3000.

### CI/CD Pipeline
A preconfigured GitHub Actions workflow (.github/workflows/ci.yml) automatically lints, tests, and builds the frontend on every push or pull request to main or develop.

---

## 7. M8 to M7 Backend Integration Guide

> [!NOTE]
> **Handoff Notice for M7 (Backend + FastAPI Engineer)**:
> This frontend currently uses mock data for development and features an isolated API service layer (src/services/api.js). 
> **You do NOT need to modify any UI components to connect the live backend.**

### How to Connect FastAPI Backend:
1. Open .env (or set the environment variable):
   `env
   VITE_API_BASE_URL=http://localhost:8000
   `
2. Restart the Vite dev server (
pm run dev).
3. The frontend will automatically route requests to the live backend.

### Expected Backend Endpoints:
- GET /products: Returns list of SKUs (P0001–P0020)
- GET /products/{id}: Returns single product details
- GET /stores: Returns store list (S001–S005)
- GET /forecast?storeId={}&productId={}&horizon={}: Returns time series and summary metrics
- GET /inventory: Returns stock counts, valuation, and status breakdown
- GET /risk?storeId={}: Returns high/medium/low risk classifications
- GET /reorder: Returns prioritized replenishment recommendations
- GET /inventory-optimization: Returns carrying vs stockout cost curve data
- GET /store-region: Returns multi-store and regional metrics
- GET /alerts: Returns operational notification feed
- POST /alerts/{id}/acknowledge: Acknowledges an alert
- POST /chat: Receives { message: string }, returns { response: string, sender: string }
- POST /upload: Handles CSV file multipart upload

If your FastAPI endpoints use slightly different path signatures or query parameter names, adjust only src/services/api.js. The UI will remain unaffected.