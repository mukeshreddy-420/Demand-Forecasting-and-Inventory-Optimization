# 🔌 Complete Guide to All Backend Connections, Integrations & Architecture

This comprehensive specification details **every single file, connection, database link, ML pipeline, GenAI integration, mathematical formula, protocol, environment variable, and data flow** in the Stocl Backend system.

> **Updated:** All external LLM (Groq) dependencies removed. The AI Agent exclusively uses the local **`backend/Gen AI/`** engine.

---

## 📑 Table of Contents
1. [1. Executive Architectural Overview](#1-executive-architectural-overview)
2. [2. Complete Exhaustive File & Directory Map](#2-complete-exhaustive-file--directory-map)
3. [3. Connection 1: FastAPI Core ↔ Supabase PostgreSQL Cloud DB](#3-connection-1-fastapi-core--supabase-postgresql-cloud-db)
4. [4. Connection 2: FastAPI Core ↔ ML Demand Forecasting Engine](#4-connection-2-fastapi-core--ml-demand-forecasting-engine)
5. [5. Connection 3: FastAPI Core ↔ Local GenAI Autonomous Agent Engine](#5-connection-3-fastapi-core--local-genai-autonomous-agent-engine)
6. [6. Connection 4: GenAI Autonomous Engine ↔ Tools & Backend Client](#6-connection-4-genai-autonomous-engine--tools--backend-client)
7. [7. Connection 5: Inventory Math Engine ↔ Recommendation Service](#7-connection-5-inventory-math-engine--recommendation-service)
8. [8. Connection 6: Client Dashboard / External Apps ↔ FastAPI Endpoints](#8-connection-6-client-dashboard--external-apps--fastapi-endpoints)
9. [9. Environment Configuration & Deployment Specifications](#9-environment-configuration--deployment-specifications)
10. [10. End-to-End Data Flow Execution Traces](#10-end-to-end-data-flow-execution-traces)

---

# 1. Executive Architectural Overview

```
                                  +---------------------------------------+
                                  |     Frontend Dashboard / Clients      |
                                  |   (Vite / Next.js / Mobile / Curl)    |
                                  +-------------------+-------------------+
                                                      |
                                                      | HTTP / REST API (JSON)
                                                      v
+---------------------------------------------------------------------------------------------------+
|  FastAPI Application Entrypoint (app/main.py)                                                    |
|  - CORS Middleware  - Swagger UI (/docs)  - Lifespan Pre-loader  - Health Monitor (/health)        |
+--------+------------------+-------------------+--------------------+-------------------+----------+
         |                  |                   |                    |                   |
         v                  v                   v                    v                   v
+------------------+ +---------------+ +-----------------+ +-------------------+ +-------------------+
|  app/api/        | |  app/api/     | |  app/api/       | |  app/api/         | |  app/api/         |
|  products.py     | |  forecast.py  | |  inventory.py   | |  recommendation.py| |  agent.py         |
+--------+---------+ +------+--------+ +--------+--------+ +---------+---------+ +---------+---------+
         |                  |                   |                    |                   |
         v                  v                   v                    v                   v
+------------------+ +---------------+ +-----------------+ +-------------------+ +-------------------+
| CRUD Database    | | Forecast      | | Inventory       | | Recommendation    | | GenAI Agent       |
| Service (crud.py)| | Service       | | Service         | | Service           | | Service           |
+--------+---------+ +------+--------+ +--------+--------+ +---------+---------+ +---------+---------+
         |                  |                   |                    |                   |
         |                  | 26-Feature        | Math Formulas      | Combines ML +     | Intent +
         |                  | Engineering       | SS, ROP, DoS       | Inventory Engine  | Multi-lingual
         |                  v                   |                    |                   v
         |          +---------------+           |                    |     +-------------------------+
         |          |  ml_models/   |           |                    |     | backend/Gen AI/ (LOCAL)  |
         |          |  ML Regressor |           |                    |     | agent.py, tools.py,      |
         |          +---------------+           |                    |     | backend_client.py,       |
         |                                      |                    |     | grounding.py, config.py  |
         +--------------------------------------+--------------------+     +------------+------------+
                                                |                                        |
                                                v                                        |
                                 +------------------------------+                        |
                                 |   Supabase PostgreSQL Cloud  |<-----------------------+
                                 |   Database (db.supabase.co)  |
                                 +------------------------------+
```

> ⚡ **No external cloud LLM APIs are used.** All AI reasoning is handled locally by `backend/Gen AI/`.

---

# 2. Complete Exhaustive File & Directory Map

Every single file in the `backend/` directory with its exact purpose, location, and role:

```text
backend/
├── app/                                  # FastAPI Core Application Source Code
│   ├── api/                              # REST API Route Controllers
│   │   ├── agent.py                      # POST /agent/chat - Natural language GenAI Agent controller
│   │   ├── forecast.py                   # POST /forecast - ML demand prediction controller
│   │   ├── inventory.py                  # POST /inventory/check - Safety Stock & ROP controller
│   │   ├── products.py                   # GET/POST /products, /stores, /inventory - Catalog controller
│   │   └── recommendation.py             # POST /recommendation - Automated replenishment order controller
│   ├── core/                             # Application Global Settings
│   │   └── config.py                     # Reads .env, defines BASE_DIR, DATABASE_URL, GENAI_DIR
│   ├── database/                         # Database Connection & CRUD Layer
│   │   ├── connection.py                 # SQLAlchemy engine bound directly to Supabase PostgreSQL
│   │   └── crud.py                       # ORM query functions (get_product, get_inventory, log_forecast, etc.)
│   ├── genai/                            # Embedded copy of GenAI agent module (symlinked to Gen AI/)
│   ├── models/                           # Data Schemas & Database Entities
│   │   ├── database_models.py            # SQLAlchemy ORM models (Product, Store, Inventory, ForecastLog)
│   │   └── schemas.py                    # Pydantic validation schemas for API inputs & outputs
│   ├── services/                         # Business Logic & Service Engines
│   │   ├── agent_service.py              # Multi-lingual reasoning & local GenAI engine integration
│   │   ├── forecast_service.py           # 26-Feature vector engineering & ML model inference
│   │   ├── inventory_service.py          # Math formulas: SS, ROP, DoS, Stockout Risk
│   │   └── recommendation_service.py     # Combines ML forecast + SS/ROP into purchase order decisions
│   └── main.py                           # FastAPI app entrypoint, lifespan preloader, CORS, health check
│
├── Gen AI/                               # LOCAL Autonomous GenAI Agent Sub-Engine (NO external API)
│   ├── app/                              # Agent logic, tools, client, grounding, config
│   │   ├── agent.py                      # Intent classification & multi-turn reasoning loop
│   │   ├── backend_client.py             # Internal HTTP client querying Supabase & ML backend
│   │   ├── config.py                     # GenAI runtime config (base_url, timeout, GENAI_DIR path)
│   │   ├── grounding.py                  # Anti-hallucination fact verification engine
│   │   ├── tools.py                      # Executable tools (query_inventory, predict_demand, etc.)
│   │   └── __init__.py                   # Package initialization & public API
│   ├── tests/                            # Unit tests for GenAI engine
│   ├── requirements.txt                  # GenAI engine dependencies (requests, etc.)
│   └── README.md                         # GenAI sub-engine documentation
│
├── ml_models/                            # Trained Machine Learning Model Artifacts
│   ├── demand_forecasting_model.pkl      # Lightweight pre-trained ML demand regressor (968 KB)
│   ├── demand_forecasting_model (1).pkl  # High-accuracy Random Forest demand regressor (850 MB) [PRIMARY]
│   └── model_features.pkl                # Serialized list of 26 expected feature column names (5.3 KB)
│
├── tests/                                # Complete Pytest Backend Test Suite (50 passed, 1 skipped)
│   ├── conftest.py                       # Test fixtures, mock database sessions & FastAPI TestClient
│   ├── test_agent.py                     # GenAI chat endpoint & intent parsing (10 tests)
│   ├── test_crud.py                      # Database CRUD queries (5 tests)
│   ├── test_forecast.py                  # ML demand forecasting endpoint (4 tests)
│   ├── test_formula_calculations.py      # Mathematical inventory formulas (4 tests, 1 skipped)
│   ├── test_health.py                    # /health endpoint (1 test)
│   ├── test_inventory.py                 # Inventory evaluation endpoints (11 tests)
│   ├── test_products.py                  # Product catalog API endpoints (13 tests)
│   └── test_recommendation.py            # Automated purchase order recommendations (3 tests)
│
├── docs/                                 # Complete Technical Specifications & Manuals
│   ├── BACKEND_INTEGRATIONS_AND_CONNECTIONS_COMPLETE_GUIDE.md  # THIS FILE
│   ├── BACKEND_DEPLOYMENT_INTEGRATION_HANDOFF.md               # Deployment & handoff spec
│   ├── API_DOCUMENTATION.md                                    # Full endpoint JSON API docs
│   ├── API_EXPLANATION.md                                      # API request parameters explained
│   ├── AWS_DEPLOYMENT_GUIDE.md                                 # AWS EC2, Nginx & SSL guide
│   ├── HOW_TO_PUSH_TO_AWS_STEP_BY_STEP.md                     # Step-by-step AWS deployment
│   ├── INVENTORY_ENGINEER_GUIDE.md                             # Inventory formulas & engineering
│   ├── FORMULAS_EXPLANATION_AND_JUSTIFICATION.md               # Mathematical formula justifications
│   └── PROJECT_END_TO_END_ARCHITECTURE_AND_WORKFLOW.md         # End-to-end system workflow
│
├── requirements.txt                      # Python dependencies (FastAPI, SQLAlchemy, psycopg2, scikit-learn, etc.)
├── .env                                  # Active environment config (Supabase URL, GENAI_PATH)
├── .env.example                          # Template for environment variable setup
├── Dockerfile                            # Docker container build specification
├── docker-compose.yml                    # Multi-container orchestration (FastAPI + Nginx)
├── nginx.conf                            # Nginx reverse proxy config (Port 80 → Port 8000)
├── start.sh                              # Production Gunicorn / Uvicorn startup script
├── stocl-backend.service                 # Linux systemd service definition file
├── deploy_aws.sh                         # Automated AWS EC2 bash deployment script
├── pytest.ini                            # Pytest config (testpaths = tests)
└── README.md                             # Standalone backend quickstart & sharing guide
```

---

# 3. Connection 1: FastAPI Core ↔ Supabase PostgreSQL Cloud DB

### 🎯 WHY this connection exists
The application requires persistent cloud storage for master product catalogs, store metadata, on-hand inventory levels, and historical demand forecast audit logs.

### 📍 WHERE it is implemented
- **Config**: [`app/core/config.py`](file:///c:/Users/MOHIT/Desktop/conizent/backend/app/core/config.py)
- **Engine & Pool**: [`app/database/connection.py`](file:///c:/Users/MOHIT/Desktop/conizent/backend/app/database/connection.py)
- **ORM Table Definitions**: [`app/models/database_models.py`](file:///c:/Users/MOHIT/Desktop/conizent/backend/app/models/database_models.py)
- **Query Operations**: [`app/database/crud.py`](file:///c:/Users/MOHIT/Desktop/conizent/backend/app/database/crud.py)

### ⚙️ HOW it works (Technical Details)

**1. Connection String** — defined in `backend/.env`:
```env
DATABASE_URL=postgresql://postgres:<YOUR_DATABASE_PASSWORD>@<YOUR_SUPABASE_HOST>:5432/postgres
```

**2. Engine Creation** — in `connection.py`:
```python
# Database Engine Initialization (Supabase PostgreSQL)
engine = create_engine(
    settings.DATABASE_URL,
    pool_pre_ping=True,   # Auto-tests TCP socket before each query — prevents stale connection errors
    echo=False
)
```

**3. Session Factory** — thread-safe, one session per request:
```python
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
```

**4. Per-Request Session Lifecycle** — via FastAPI dependency injection:
```python
def get_db() -> Generator[Session, None, None]:
    db = SessionLocal()
    try:
        yield db          # Active for exactly the duration of one HTTP request
    finally:
        db.close()        # Guaranteed cleanup even on exception
```

**5. Database Tables** (ORM models auto-verified on startup):
| Table | Columns |
| :--- | :--- |
| `products` | `product_id`, `name`, `category`, `price`, `lead_time_days` |
| `stores` | `store_id`, `name`, `region` |
| `inventory` | `store_id`, `product_id`, `inventory_level`, `units_sold`, `units_ordered` |
| `forecast_logs` | `store_id`, `product_id`, `target_date`, `predicted_demand`, `input_features` |

**6. CRUD Query Operations** (in `crud.py`):
- `get_product_by_id(db, product_id)` → Single product lookup
- `get_all_products(db)` → Full product catalog
- `get_store_by_id(db, store_id)` → Store metadata
- `get_inventory(db, store_id, product_id)` → Live stock level for one SKU
- `get_detailed_inventory(db, status, limit)` → Filtered inventory with status labels
- `get_inventory_stats(db)` → Portfolio summary (total units, value, critical/low/healthy counts)
- `log_forecast(db, store_id, product_id, target_date, predicted_demand, input_features)` → Audit log write

---

# 4. Connection 2: FastAPI Core ↔ ML Demand Forecasting Engine

### 🎯 WHY this connection exists
To predict future daily unit demand using machine learning — factoring in price, competitor pricing, promotions, discounts, weather, seasonality, and historical demand lag features — instead of static or manual estimates.

### 📍 WHERE it is implemented
- **Primary Model**: `ml_models/demand_forecasting_model (1).pkl` (850 MB Random Forest Regressor)
- **Feature Definitions**: `ml_models/model_features.pkl` (5.3 KB serialized list of 26 column names)
- **Inference Service**: [`app/services/forecast_service.py`](file:///c:/Users/MOHIT/Desktop/conizent/backend/app/services/forecast_service.py)
- **API Endpoint**: [`app/api/forecast.py`](file:///c:/Users/MOHIT/Desktop/conizent/backend/app/api/forecast.py)

### ⚙️ HOW it works (Technical Details)

**1. Model Preloading on Startup** — `lifespan` in `main.py` calls:
```python
ForecastService.load_model()
```
Joblib deserializes the 850MB model binary into server RAM once. All subsequent inference calls reuse the in-memory model at `<5ms` per prediction.

**2. 26-Feature Matrix Engineering** — `ForecastService.prepare_feature_vector()`:

| Feature Group | Feature Names |
| :--- | :--- |
| **Encoded Entities** | `Store_Enc`, `Product_Enc`, `Category_Enc`, `Weather_Enc`, `Season_Enc` |
| **Price & Promotions** | `Price`, `Competitor Pricing`, `Discount`, `Promotion`, `Effective_Price_Promotion`, `Price_Diff_Competitor` |
| **Temporal** | `Year`, `Month`, `Day`, `DayOfWeek`, `IsWeekend` |
| **Epidemic Flag** | `Epidemic` |
| **Demand Lags** | `Demand_Lag_1`, `Demand_Lag_7`, `Demand_Lag_14` |
| **Rolling Averages** | `Rolling_Mean_7`, `Rolling_Mean_14` |
| **Lag Units** | `Units_Sold_Lag_1`, `Units_Ordered_Lag_1`, `Inventory_Level_Lag_1` |

**3. Inference Execution**:
```python
raw_prediction = model.predict(X_df)[0]
predicted_demand = float(max(0.0, round(float(raw_prediction), 2)))  # Demand cannot be negative
```

**4. Audit Log** — prediction automatically saved to Supabase `forecast_logs` table:
```python
crud.log_forecast(db=db, store_id=..., product_id=..., target_date=...,
                  predicted_demand=..., input_features=req.model_dump())
```

**5. Encoding Maps** (hardcoded in `ForecastService`):

| Map | Values |
| :--- | :--- |
| `CATEGORY_ENC_MAP` | Clothing=0, Electronics=1, Furniture=2, Groceries=3, Toys=4 |
| `WEATHER_ENC_MAP` | Cloudy=0, Rainy=1, Snowy=2, Sunny=3 |
| `SEASON_ENC_MAP` | Autumn=0, Spring=1, Summer=2, Winter=3 |
| `STORE_REGION_MAP` | S001=North, S002=South, S003=East, S004=West, S005=North |

---

# 5. Connection 3: FastAPI Core ↔ Local GenAI Autonomous Agent Engine

### 🎯 WHY this connection exists
To power a natural language conversational AI copilot capable of understanding inventory questions, explaining stockout risks, and producing multilingual replenishment decisions — **entirely locally**, using no external cloud LLM API.

### 📍 WHERE it is implemented
- **API Router**: [`app/api/agent.py`](file:///c:/Users/MOHIT/Desktop/conizent/backend/app/api/agent.py)
- **Agent Service (Bridge)**: [`app/services/agent_service.py`](file:///c:/Users/MOHIT/Desktop/conizent/backend/app/services/agent_service.py)
- **Local GenAI Engine Root**: [`backend/Gen AI/app/`](file:///c:/Users/MOHIT/Desktop/conizent/backend/Gen%20AI/app/)

### ⚙️ HOW it works (Technical Details)

**1. GENAI_PATH Dynamic Resolution** — in `agent_service.py`:
```python
GENAI_PATH = Path(os.environ.get("GENAI_PATH", str(BASE_DIR / "Gen AI")))
if GENAI_PATH.exists() and str(GENAI_PATH) not in sys.path:
    sys.path.insert(0, str(GENAI_PATH))
```
The `Gen AI/` folder is added to Python's module search path at runtime. No hardcoded machine-specific paths.

**2. Import Chain** — with graceful fallback:
```python
try:
    from app.genai.agent import Agent, AgentResult, ConversationContext
    from app.genai.tools import AgentTools
    from app.genai.backend_client import BackendClient
except Exception:
    from app.agent import Agent, AgentResult, ConversationContext
    from app.tools import AgentTools
    from app.backend_client import BackendClient
```

**3. Agent Initialization** — pure local, no API key required:
```python
client = BackendClient.from_config(db=db)
tools = AgentTools(client=client)
agent = Agent(tools=tools)   # No llm_api_key, no llm_base_url, no external model
```

**4. config.py — GENAI_DIR** (new entry replacing Groq settings):
```python
# Gen AI Local Engine Path
GENAI_DIR: Path = BASE_DIR / "Gen AI"
```

**5. Multi-lingual Detection** (`AgentService.detect_language()`):
- **Telugu**: Unicode range `[\u0C00-\u0C7F]` + romanized keywords (`entha`, `undhi`, `రాయితీ`)
- **Hindi**: Unicode range `[\u0900-\u097F]` + romanized keywords (`kitna`, `batao`, `छूट`)
- **English**: Default fallback

**6. Entity Extraction** (`AgentService.extract_entities()`):
- Store ID: regex `S00[1-5]`
- Product ID: regex `P00[0-2][0-9]`
- Weather condition: keyword pattern (Snowy, Rainy, Cloudy, Sunny)
- Discount: `(\d+)\s*%` percentage pattern
- Promotion: keyword (`promo`, `sale`, `campaign`, `ऑफर`)
- Epidemic: keyword (`epidemic`, `pandemic`, `महामारी`)

**7. Deterministic Fallback** — if the local agent encounters an error, `AgentService._generate_fallback_response()` builds a fully data-driven answer from live Supabase context without any model call at all.

---

# 6. Connection 4: GenAI Autonomous Engine ↔ Tools & Backend Client

### 🎯 WHY this connection exists
To eliminate AI hallucinations by forcing the local reasoning engine to call deterministic database tools and mathematical functions instead of inventing inventory numbers.

### 📍 WHERE it is implemented
| File | Role |
| :--- | :--- |
| [`Gen AI/app/agent.py`](file:///c:/Users/MOHIT/Desktop/conizent/backend/Gen%20AI/app/agent.py) | Intent classification, multi-turn context, deterministic reply builder |
| [`Gen AI/app/tools.py`](file:///c:/Users/MOHIT/Desktop/conizent/backend/Gen%20AI/app/tools.py) | Executable tool definitions callable by the agent |
| [`Gen AI/app/backend_client.py`](file:///c:/Users/MOHIT/Desktop/conizent/backend/Gen%20AI/app/backend_client.py) | HTTP calls to FastAPI backend (which reads Supabase & runs ML) |
| [`Gen AI/app/grounding.py`](file:///c:/Users/MOHIT/Desktop/conizent/backend/Gen%20AI/app/grounding.py) | Anti-hallucination: verifies that agent output matches real data |
| [`Gen AI/app/config.py`](file:///c:/Users/MOHIT/Desktop/conizent/backend/Gen%20AI/app/config.py) | Runtime config (base_url, timeout, endpoint paths, field schemas) |

### ⚙️ HOW it works (Technical Details)

**1. Intent Classification** — 14 deterministic regex patterns, ordered by priority:
- `explain_quantity` → Why was this order quantity recommended?
- `reorder_list` → Which products need reordering?
- `reorder_quantity` → How many units to reorder?
- `reorder_decision` → Should I reorder?
- `explain_risk` → Why is this product high risk?
- `risk_list` → Which products are at risk?
- `priority` → Most critical products?
- `summary` → Network overview?
- `reorder_point` → What is the ROP?
- `safety_stock` → What is the SS?
- `stockout_risk` → What is the stockout risk level?
- `inventory_status` → Current inventory status?
- `current_inventory` → How many units in stock?
- `forecast` → What is the demand forecast?

**2. Tool-to-Intent Mapping** (`_select_tools()`):
```
forecast          → [get_forecast]
current_inventory → [get_inventory_status]
stockout_risk     → [get_stockout_risk]
risk_list         → [get_high_risk_products]
summary           → [get_inventory_summary, get_high_risk_products]
reorder_quantity  → [get_reorder_recommendation]
```

**3. Executable Tools in `AgentTools`**:
- `get_forecast(product_id, store_id, horizon_days)` → calls `BackendClient` → `POST /forecast`
- `get_inventory_status(product_id, store_id)` → calls `POST /inventory/check`
- `get_stockout_risk(product_id, store_id)` → calls `POST /inventory/risk`
- `get_reorder_recommendation(product_id, store_id)` → calls `POST /recommendation`
- `get_high_risk_products()` → calls `GET /inventory/high-risk`
- `get_inventory_summary()` → calls `GET /inventory/summary`

**4. Multi-turn Memory** (`ConversationContext`):
Preserves `product_id`, `store_id`, `horizon_days`, `last_intent`, `last_question`, and `language` across conversation turns.

---

# 7. Connection 5: Inventory Math Engine ↔ Recommendation Service

### 🎯 WHY this connection exists
To translate raw ML demand forecasts into precise mathematical inventory control decisions, protecting stores from stockouts while avoiding capital wastage from overstocking.

### 📍 WHERE it is implemented
- **Inventory Service**: [`app/services/inventory_service.py`](file:///c:/Users/MOHIT/Desktop/conizent/backend/app/services/inventory_service.py)
- **Recommendation Service**: [`app/services/recommendation_service.py`](file:///c:/Users/MOHIT/Desktop/conizent/backend/app/services/recommendation_service.py)

### ⚙️ HOW it works — Exact Mathematical Formulas

**1. Safety Stock ($SS$)**:
$$SS = Z \times \sigma_d \times \sqrt{L}$$

| Parameter | Value | Description |
| :--- | :--- | :--- |
| $Z$ | `1.65` | 95% service level z-score (configurable via `service_level`) |
| $\sigma_d$ | Computed from demand history | Standard deviation of daily demand |
| $L$ | `lead_time_days` (default: 7) | Replenishment lead time in days |

**2. Reorder Point ($ROP$)**:
$$ROP = (d \times L) + SS$$
- $d$ = ML-predicted daily demand (from `ForecastService`)

**3. Days of Supply ($DoS$)**:
$$DoS = \frac{\text{Current Inventory}}{d}$$

**4. Recommended Order Quantity ($ROQ$)**:
$$ROQ = \max(0,\ ROP + SS - \text{Current Inventory})$$

**5. Action Decision Matrix**:

| Condition | Action Tag | Meaning |
| :--- | :--- | :--- |
| `Current Stock < SS` | `REORDER_CRITICAL` | Stockout imminent — order immediately |
| `Current Stock < ROP` | `REORDER_WARNING` | Below reorder threshold — order soon |
| `ROP ≤ Stock ≤ ROP + SS×2` | `OPTIMAL` | Healthy inventory level |
| `Stock > ROP + SS×2` | `OVERSTOCKED` | Capital tied up — pause replenishment |

---

# 8. Connection 6: Client Dashboard / External Apps ↔ FastAPI Endpoints

### 🎯 WHY this connection exists
Allows frontend web dashboards, mobile apps, or enterprise ERP webhooks to access real-time forecasts, run inventory checks, trigger AI conversations, and receive purchase order recommendations.

### 📍 WHERE it is implemented
- **CORS**: [`app/main.py`](file:///c:/Users/MOHIT/Desktop/conizent/backend/app/main.py)
- **Frontend API Client**: `frontend/js/app.js`
- **Nginx Reverse Proxy**: [`nginx.conf`](file:///c:/Users/MOHIT/Desktop/conizent/backend/nginx.conf)

### ⚙️ HOW it works

**1. CORS Middleware** — permits any origin:
```python
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

**2. Dynamic Base URL** — `frontend/js/app.js`:
```javascript
const API_BASE = window.location.origin;
// Automatically resolves to:
// http://localhost:8000         (local dev)
// http://<EC2_IP>               (AWS production)
// https://api.yourdomain.com    (custom domain)
```

**3. API Endpoints Consumed by Frontend**:

| Endpoint | Method | Purpose |
| :--- | :--- | :--- |
| `/health` | `GET` | Server & DB status check |
| `/products` | `GET` | Load all products into dropdowns |
| `/stores` | `GET` | Load all stores |
| `/inventory` | `GET` | Full inventory table |
| `/forecast` | `POST` | ML demand prediction for chart |
| `/inventory/check` | `POST` | Safety Stock, ROP, DoS gauges |
| `/recommendation` | `POST` | Purchase order recommendation cards |
| `/agent/chat` | `POST` | AI chat copilot (local GenAI engine) |

**4. Nginx Reverse Proxy** (production):
```nginx
# nginx.conf: Port 80 → FastAPI on Port 8000
location / {
    proxy_pass http://127.0.0.1:8000;
}
```

---

# 9. Environment Configuration & Deployment Specifications

### 🔑 Active Environment Variables (`backend/.env`)

| Variable | Current Value | Description |
| :--- | :--- | :--- |
| `APP_NAME` | `"Demand Forecasting & Inventory Optimization API"` | Application display name |
| `APP_ENV` | `development` | Runtime environment mode |
| `DEBUG` | `True` | Verbose debug logging |
| `PORT` | `8000` | Uvicorn/Gunicorn server port |
| `DATABASE_URL` | `postgresql://postgres:<password>@<your-db-host>:5432/postgres` | Supabase / PostgreSQL cloud connection string |
| `GENAI_PATH` | `./Gen AI` | Relative path to local GenAI engine root |

> **Note:** There are NO external LLM API keys (`GROQ_API_KEY`, etc.) anywhere in the configuration. The system is 100% self-contained.

### 📦 Python Dependencies (`requirements.txt`)
- `fastapi` — ASGI web framework
- `uvicorn[standard]` — ASGI server
- `sqlalchemy` — ORM + connection pooling
- `psycopg2-binary` — PostgreSQL driver for Supabase
- `pydantic` / `pydantic-settings` — Input validation & settings
- `python-dotenv` — `.env` file loading
- `scikit-learn` — ML model predictions
- `joblib` — Model serialization/deserialization
- `pandas` / `numpy` — Feature matrix construction
- `requests` — HTTP client used by GenAI backend_client

---

# 10. End-to-End Data Flow Execution Traces

### 🔹 Scenario A: ML Demand Forecast Request

```
1. Client → POST /forecast { store_id: "S001", product_id: "P0001", forecast_date: "2026-09-15",
                              price: 72.72, competitor_pricing: 85.73, discount: 5.0,
                              promotion: 1, weather_condition: "Snowy", seasonality: "Winter" }

2. FastAPI Router (app/api/forecast.py)
   └── Obtains Supabase session via get_db()
   └── Calls ForecastService.predict_demand(req, db)

3. ForecastService
   ├── Loads RAM-cached ML model (demand_forecasting_model (1).pkl)
   ├── Queries Supabase for product category, store region, current inventory
   ├── Builds 26-feature Pandas DataFrame
   │   ├── Store_Enc = 0.0 (S001)
   │   ├── Product_Enc = 0.0 (P0001)
   │   ├── Category_Enc = 1.0 (Electronics)
   │   ├── Weather_Enc = 2.0 (Snowy)
   │   ├── Season_Enc = 3.0 (Winter)
   │   ├── Price = 72.72, Competitor Pricing = 85.73, Discount = 5.0
   │   ├── Effective_Price_Promotion = 72.72 × (1 - 0.05) = 69.08
   │   ├── Price_Diff_Competitor = 85.73 - 72.72 = 13.01
   │   ├── Year/Month/Day/DayOfWeek/IsWeekend derived from 2026-09-15
   │   └── Demand_Lag_1/7/14, Rolling_Mean_7/14 from Supabase inventory record
   ├── Executes model.predict(X_df)[0] → raw_prediction = 142.85
   ├── Clamps to max(0.0, 142.85) → predicted_demand = 142.85
   └── Logs to Supabase forecast_logs table via crud.log_forecast()

4. FastAPI → 200 OK
   { "store_id": "S001", "product_id": "P0001",
     "forecast_date": "2026-09-15", "predicted_demand": 142.85 }
```

---

### 🔹 Scenario B: AI Agent Chat Request

```
1. Client → POST /agent/chat { message: "Should I reorder P0001 at store S001?", language: "en" }

2. FastAPI Router (app/api/agent.py)
   └── Calls AgentService.chat(req, db)

3. AgentService
   ├── Loads GENAI_PATH = BASE_DIR / "Gen AI" (dynamic, portable)
   ├── Creates BackendClient(db=db)
   ├── Creates AgentTools(client=client)
   └── Creates Agent(tools=tools) — purely local, no external API

4. Agent.chat("Should I reorder P0001 at store S001?")
   ├── detect_language() → "en"
   ├── classify_intent() → "reorder_decision"
   ├── extract_entities() → { product_id: "P0001", store_id: "S001" }
   ├── _select_tools("reorder_decision") → ["get_reorder_recommendation"]
   │
   ├── Executes tool: get_reorder_recommendation(product_id="P0001", store_id="S001")
   │   └── BackendClient → POST /recommendation → RecommendationService
   │       ├── ForecastService.predict_demand() → predicted_demand = 142.85
   │       ├── InventoryService.calculate() →
   │       │   SS = 1.65 × σ × √7 = 115.5 units
   │       │   ROP = (142.85 × 7) + 115.5 = 1115.5 units
   │       │   DoS = 120 / 142.85 = 0.84 days
   │       │   ROQ = max(0, 1115.5 + 115.5 - 120) = 1111 units
   │       └── Action = REORDER_CRITICAL (stock < ROP)
   │
   ├── grounding.py verifies result against live Supabase data
   └── _deterministic_reply() formats structured English answer

5. FastAPI → 200 OK
   { "reply": "⚡ REORDER CRITICAL for P0001 at Store S001.\n
               Forecasted Demand: 142.85 units/day\n
               Current Stock: 120 units (DoS: 0.84 days)\n
               Reorder Point: 1115.5 units | Safety Stock: 115.5 units\n
               Recommended Order Quantity: 1111 units",
     "model": "Stocl GenAI Autonomous Engine",
     "language": "en" }
```

---

### 🔹 Scenario C: Purchase Order Recommendation

```
1. Client → POST /recommendation { store_id: "S001", product_id: "P0001", lead_time_days: 7 }

2. FastAPI Router (app/api/recommendation.py) → RecommendationService.generate_recommendation()

3. RecommendationService
   ├── Calls ForecastService.predict_demand() → 142.85 units/day
   ├── Queries Supabase via crud.get_inventory() → current_stock = 120 units
   ├── Calls InventoryService.calculate_inventory_metrics()
   │   ├── SS = 1.65 × σ × √7 = 115.5
   │   ├── ROP = (142.85 × 7) + 115.5 = 1115.5
   │   ├── DoS = 120 / 142.85 = 0.84 days
   │   └── ROQ = max(0, 1115.5 + 115.5 - 120) = 1111 units
   └── Determines action: REORDER_CRITICAL (120 < 115.5 SS threshold)

4. FastAPI → 200 OK with full recommendation payload
```
