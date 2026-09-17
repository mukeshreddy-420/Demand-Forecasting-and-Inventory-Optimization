# 🚀 M7: Backend + API Engineer — Master Interview Preparation & Code Walkthrough

This document is your **complete, line-by-line, architectural, and conceptual interview preparation guide** for the role of **M7: Backend + API Engineer** in the Stocl Demand Forecasting & Inventory Optimization project.

---

## 📋 Table of Contents
1. [Executive Summary: Your Role as M7](#1-executive-summary-your-role-as-m7)
2. [📁 Master Directory Guide: What Every Folder & File Does](#2--master-directory-guide-what-every-folder--file-does)
   - [2.1 Folder: `app/` (Core FastAPI Application)](#21-folder-app-core-fastapi-application)
   - [2.2 Folder: `app/api/` (API Route Controllers)](#22-folder-appapi-api-route-controllers)
   - [2.3 Folder: `app/core/` (Global Settings & Security)](#23-folder-appcore-global-settings--security)
   - [2.4 Folder: `app/database/` (Connection & CRUD Layer)](#24-folder-appdatabase-connection--crud-layer)
   - [2.5 Folder: `app/models/` (SQLAlchemy Entities & Pydantic Schemas)](#25-folder-appmodels-sqlalchemy-entities--pydantic-schemas)
   - [2.6 Folder: `app/services/` (Business Logic & ML Engines)](#26-folder-appservices-business-logic--ml-engines)
   - [2.7 Folder: `ml_models/` (Trained Machine Learning Artifacts)](#27-folder-ml_models-trained-machine-learning-artifacts)
   - [2.8 Folder: `Gen AI/` (Local Autonomous AI Engine)](#28-folder-gen-ai-local-autonomous-ai-engine)
   - [2.9 Folder: `tests/` (Pytest Automated Test Suite)](#29-folder-tests-pytest-automated-test-suite)
   - [2.10 Root Configuration & Deployment Files](#210-root-configuration--deployment-files)
3. [High-Level System Architecture & M7 Position](#3-high-level-system-architecture--m7-position)
4. [Technology Stack & Architectural Justifications](#4-technology-stack--architectural-justifications)
5. [Exhaustive Code & Logic Deep Dive](#5-exhaustive-code--logic-deep-dive)
6. [Cross-Team Integration Matrix (How M7 Works with M1–M8)](#6-cross-team-integration-matrix-how-m7-works-with-m1m8)
7. [Top 25 Technical Interview Questions & High-Impact Answers](#7-top-25-technical-interview-questions--high-impact-answers)
8. [Quick Cheat Sheet: 2-Minute Elevator Pitch](#8-quick-cheat-sheet-2-minute-elevator-pitch)

---

# 1. Executive Summary: Your Role as M7

### 🎯 What is M7's Mission?
As the **Backend + API Engineer (M7)**, you are the **central nervous system** of the entire enterprise product:
1. **API Gateway & Routing**: Built high-throughput, low-latency REST endpoints using **FastAPI** with automatic OpenAPI documentation.
2. **Cloud Database Architecture**: Connected and orchestrated **Supabase PostgreSQL** cloud database with relational tables, foreign key constraints, composite indexing, and connection pooling.
3. **ML Model Serving**: Preloaded and served the **M4 ExtraTrees ML Demand Forecasting Model** with serialized joblib artifacts and 26-feature vector pipeline.
4. **Business & Mathematical Logic**: Implemented **M5 Inventory Math** (Safety Stock, Reorder Point, Days of Supply, Reorder Quantity) and **M6 GenAI Agent** endpoints.
5. **Frontend Integration**: Handled CORS, JSON schemas, query filters, pagination, and multi-horizon time-series aggregation for the **M8 React/Vite dashboard**.
6. **Reliability & QA**: Architected a 58-test Pytest suite with isolated in-memory SQLite fixtures and mocking.

---

# 2. 📁 Master Directory Guide: What Every Folder & File Does

Use this section whenever the interviewer asks: *"What does this folder do?"* or *"What does this specific file do?"*

```text
backend/
├── app/                                  # 1. Core FastAPI Application Source Code
│   ├── api/                              # 2. REST API Route Controllers & Endpoints
│   │   ├── products.py                   # Catalog & store endpoints (GET/POST /products, /stores)
│   │   ├── forecast.py                   # ML demand forecasting endpoints (GET/POST /forecast)
│   │   ├── inventory.py                  # Inventory checks, high-risk items, summary metrics
│   │   ├── recommendation.py             # Purchase order replenishment recommendation cards
│   │   ├── agent.py                      # GenAI chat copilot endpoint (POST /agent/chat)
│   │   └── dashboard.py                  # Dedicated endpoints for frontend dashboard views
│   ├── core/                             # 3. Global App Settings & Security Middleware
│   │   ├── config.py                     # Reads .env, defines DATABASE_URL, PORT, BASE_DIR
│   │   └── security.py                   # API Key authentication & chat rate limiting
│   ├── database/                         # 4. Database Connection & CRUD Data Access Layer
│   │   ├── connection.py                 # SQLAlchemy engine, QueuePool, sessionmaker, get_db
│   │   └── crud.py                       # Reusable SQL/ORM query functions for all entities
│   ├── models/                           # 5. Data Models & Entity Schemas
│   │   ├── database_models.py            # SQLAlchemy relational database tables (PostgreSQL)
│   │   └── schemas.py                    # Pydantic V2 input validation & response schemas
│   ├── services/                         # 6. Business Logic, Math & Inference Services
│   │   ├── forecast_service.py           # 26-Feature vector engineering & ML model inference
│   │   ├── inventory_service.py          # Math formulas: Safety Stock, ROP, Days of Supply
│   │   ├── recommendation_service.py     # End-to-end decision engine combining ML + Math
│   │   └── agent_service.py              # Multilingual intent detection & GenAI integration
│   └── main.py                           # Application entrypoint, lifespan manager, CORS
│
├── ml_models/                            # 7. Trained Machine Learning Model Artifacts
│   ├── demand_forecasting_model.pkl      # Lightweight pre-trained ML demand regressor (968 KB)
│   ├── demand_forecasting_model (1).pkl  # High-accuracy ExtraTrees demand regressor (850 MB) [PRIMARY]
│   └── model_features.pkl                # Serialized list of 26 expected feature column names (5.3 KB)
│
├── Gen AI/                               # 8. Local Autonomous GenAI Agent Sub-Engine
│   ├── app/                              # Intent classification, tools, grounding, backend client
│   │   ├── agent.py                      # Autonomous agent reasoning loop & language prompt handling
│   │   ├── backend_client.py             # Internal client querying Supabase & ML backend
│   │   ├── config.py                     # GenAI runtime settings & timeouts
│   │   ├── grounding.py                  # Anti-hallucination fact verification engine
│   │   └── tools.py                      # Executable tools (query_inventory, predict_demand)
│   ├── tests/                            # Unit tests for GenAI engine
│   └── requirements.txt                  # GenAI dependencies (requests, etc.)
│
├── tests/                                # 9. Automated Pytest Test Suite (58 passed, 1 skipped)
│   ├── conftest.py                       # In-memory SQLite database fixtures & TestClient setup
│   ├── test_products.py                  # Product catalog API tests (13 tests)
│   ├── test_forecast.py                  # ML demand forecasting endpoint tests (4 tests)
│   ├── test_inventory.py                 # Inventory evaluation & optimization tests (11 tests)
│   ├── test_recommendation.py            # Purchase order recommendation tests (3 tests)
│   ├── test_agent.py                     # GenAI chat endpoint & intent parsing tests (10 tests)
│   ├── test_dashboard_integration.py     # Frontend dashboard integration tests (8 tests)
│   ├── test_crud.py                      # Database CRUD queries tests (5 tests)
│   ├── test_formula_calculations.py      # Mathematical inventory formulas tests (4 tests)
│   └── test_health.py                    # Health check probe test (1 test)
│
├── requirements.txt                      # Python dependencies (FastAPI, SQLAlchemy, psycopg2, scikit-learn)
├── .env                                  # Active environment config (Supabase URL, GENAI_PATH)
├── .env.example                          # Template for environment variable setup
├── Dockerfile                            # Production container build specification
├── docker-compose.yml                    # Multi-container orchestration (FastAPI + Nginx)
├── nginx.conf                            # Nginx reverse proxy config (Port 80 → Port 8000)
├── start.sh                              # Production Gunicorn / Uvicorn startup script
├── stocl-backend.service                 # Linux systemd service definition file
├── deploy_aws.sh                         # Automated AWS EC2 deployment script
└── pytest.ini                            # Pytest configuration (testpaths = tests)
```

---

## 2.1 Folder: `app/` (Core FastAPI Application)
- **What this folder does**: Contains all backend application code. Follows the **Clean Architecture / Controller-Service-Repository pattern**.
- **Key File: `app/main.py`**:
  - **Lifespan Manager (`lifespan`)**: Pre-loads the ML model and verifies database tables before HTTP traffic starts.
  - **CORS Configuration**: Allows the React frontend (`http://localhost:5173`) to call the API without cross-origin errors.
  - **Router Registration**: Mounts all modular API routers (`products`, `forecast`, `inventory`, `recommendation`, `agent`, `dashboard`).
  - **Health Probe (`GET /health`)**: Executes `SELECT 1` on PostgreSQL to report connection health for load balancers.

---

## 2.2 Folder: `app/api/` (API Route Controllers)
- **What this folder does**: Implements the REST API endpoints. Every file in this folder receives incoming HTTP requests, validates them using Pydantic schemas, calls the appropriate service layer, and returns JSON responses.
- **File: `app/api/products.py`**:
  - `GET /products`: Returns paginated products (`skip`, `limit`).
  - `GET /products/{product_id}`: Returns single product details.
  - `POST /products`: Registers a new product in the catalog (protected by API Key).
  - `GET /stores`: Returns retail store branches (`S001`–`S005`).
- **File: `app/api/forecast.py`**:
  - `POST /forecast`: Single-point demand prediction using the ML model.
  - `GET /forecast`: Multi-horizon schedule endpoint for frontend charts (historical actuals + forward ML curve + confidence bounds).
- **File: `app/api/inventory.py`**:
  - `POST /inventory/check`: Evaluates current stock of a single SKU against ML demand.
  - `GET /inventory/high-risk`: Lists all products where stockout risk is CRITICAL or HIGH.
  - `GET /inventory/summary`: Fast aggregate risk counters.
  - `GET /inventory/details`: Relational join of products, stores, and stock with status filters.
  - `GET /inventory/stats`: Network-wide inventory KPIs.
  - `POST /inventory/adjust`: Modifies stock levels or logs incoming PO units (protected by API Key).
- **File: `app/api/recommendation.py`**:
  - `POST /recommendation`: Generates end-to-end purchasing recommendations combining ML forecast + SS + ROP.
- **File: `app/api/agent.py`**:
  - `POST /agent/chat`: Natural language interface for the autonomous AI copilot with IP rate limiting.
- **File: `app/api/dashboard.py`**:
  - Provides tailored views for the React dashboard: `GET /risk`, `GET /reorder`, `GET /inventory/pulse`, `GET /store-region`, `GET /inventory-optimization`, `GET /alerts`, and `POST /chat` alias.

---

## 2.3 Folder: `app/core/` (Global Settings & Security)
- **What this folder does**: Manages application-wide configurations, environment variables, and security policies.
- **File: `app/core/config.py`**:
  - Uses Pydantic's `BaseSettings` to parse `.env`.
  - Defines `APP_NAME`, `DATABASE_URL`, `PORT`, `DEBUG`, and `GENAI_PATH`.
- **File: `app/core/security.py`**:
  - `verify_api_key`: Checks for valid `X-API-Key` header on sensitive write operations.
  - `rate_limit_chat`: Implements a sliding-window rate limiter (20 requests/minute) on the AI Assistant endpoint.

---

## 2.4 Folder: `app/database/` (Connection & CRUD Layer)
- **What this folder does**: Connects to the Supabase PostgreSQL database and manages all database queries.
- **File: `app/database/connection.py`**:
  - Initializes SQLAlchemy `create_engine` with connection pooling (`pool_size=10`, `max_overflow=20`, `pool_recycle=300`).
  - Defines `get_db()` dependency generator using `try...finally: db.close()` to guarantee zero connection leaks.
- **File: `app/database/crud.py`**:
  - Contains reusable database queries: `get_products`, `get_product_by_id`, `get_inventory`, `get_detailed_inventory`, `get_inventory_stats`, `get_recent_sales`, `log_forecast`, `log_recommendation`.

---

## 2.5 Folder: `app/models/` (SQLAlchemy Entities & Pydantic Schemas)
- **What this folder does**: Separates database storage representations from API data contracts.
- **File: `app/models/database_models.py`**:
  - SQLAlchemy ORM models mapped to PostgreSQL tables:
    - `Product` $\rightarrow$ `products` table
    - `Store` $\rightarrow$ `stores` table
    - `Inventory` $\rightarrow$ `inventory` table (foreign keys to stores and products, cascade on delete)
    - `Sales` $\rightarrow$ `sales` table (historical transactions)
    - `ForecastLog` $\rightarrow$ `forecast_logs` table
    - `RecommendationLog` $\rightarrow$ `recommendation_logs` table
- **File: `app/models/schemas.py`**:
  - Pydantic V2 schemas for request validation and response serialization (`ForecastRequest`, `ForecastResponse`, `InventoryCheckRequest`, `AgentChatRequest`, `AgentChatResponse`).

---

## 2.6 Folder: `app/services/` (Business Logic & ML Engines)
- **What this folder does**: The core business logic layer. Completely decoupled from HTTP frameworks.
- **File: `app/services/forecast_service.py`**:
  - Loads serialized ML model (`demand_forecasting_model.pkl`).
  - Constructs the exact 26-feature vector from request parameters.
  - Runs model inference and returns predicted demand units.
- **File: `app/services/inventory_service.py`**:
  - Implements the mathematical inventory equations: Safety Stock ($SS$), Reorder Point ($ROP$), Days of Supply ($DoS$), and Recommended Order Quantity ($ROQ$).
- **File: `app/services/recommendation_service.py`**:
  - Evaluates whether `current_inventory < reorder_point` and generates actionable recommendations.
- **File: `app/services/agent_service.py`**:
  - Detects query language (English, Telugu, Hindi) using Unicode regex.
  - Extracts entities (SKU, Store, Seasonality, Promotion) and queries live data through the GenAI engine.

---

## 2.7 Folder: `ml_models/` (Trained Machine Learning Artifacts)
- **What this folder does**: Stores the pre-trained machine learning model artifacts produced by the M4 Machine Learning Engineer.
- **Files**:
  - `demand_forecasting_model (1).pkl`: High-accuracy ExtraTrees Regressor (850 MB) used for production demand inference.
  - `model_features.pkl`: Serialized list of the 26 feature column names to guarantee exact feature alignment during inference.

---

## 2.8 Folder: `Gen AI/` (Local Autonomous AI Engine)
- **What this folder does**: Standalone local autonomous agent sub-engine built by the M6 Engineer. Requires **zero external cloud LLM API keys**.
- **Key Modules**:
  - `app/agent.py`: Intent classification (`risk_list`, `reorder_decision`, `forecast`) and multi-turn context management.
  - `app/tools.py`: Tool definitions enabling the agent to query database stocks and ML demand predictions.
  - `app/grounding.py`: Anti-hallucination verification engine that validates every number against live database facts.

---

## 2.9 Folder: `tests/` (Pytest Automated Test Suite)
- **What this folder does**: Provides automated verification of all endpoints, CRUD queries, mathematical formulas, and ML predictions.
- **`conftest.py`**: Configures an in-memory SQLite database (`sqlite:///:memory:`) with dependency injection overrides so the 58 tests execute in **<12 seconds** without modifying the live database.
- **Test files**:
  - `test_products.py` (13 tests): Catalog queries, pagination, and SKU lookups.
  - `test_inventory.py` (11 tests): Stock adjustments, high-risk filtering, optimization.
  - `test_agent.py` (10 tests): Chat responses, entity extraction, and multilingual support.
  - `test_dashboard_integration.py` (8 tests): Frontend dashboard routes (`/risk`, `/reorder`, `/forecast`, `/chat`).
  - `test_crud.py` (5 tests): Database ORM queries.
  - `test_forecast.py` (4 tests): ML inference and feature vector validation.
  - `test_formula_calculations.py` (4 tests): Mathematical formula correctness.
  - `test_health.py` (1 test): System health probe.

---

## 2.10 Root Configuration & Deployment Files
- **`requirements.txt`**: List of pinned Python packages (`fastapi`, `uvicorn`, `sqlalchemy`, `psycopg2-binary`, `scikit-learn`, `joblib`, `pydantic`).
- **`.env`**: Active environment credentials (Supabase cloud connection string, port, debug mode).
- **`Dockerfile`**: Multi-stage Docker container build definition.
- **`docker-compose.yml`**: Orchestrates FastAPI backend and Nginx reverse proxy.
- **`nginx.conf`**: Configures Nginx reverse proxy routing port 80 to FastAPI on port 8000.
- **`start.sh`**: Production server launcher script using Uvicorn with auto-restart.

---

# 3. High-Level System Architecture & M7 Position

```text
       M8: Frontend Dashboard (React + Vite)
                         │
                         ▼ HTTP / REST (JSON)  [Port 8000]
 ╔═══════════════════════════════════════════════════════════════╗
 ║                   M7: FASTAPI BACKEND CORE                    ║
 ║                                                               ║
 ║  [ Lifespan Pre-loader ]  [ CORS Middleware ]  [ Rate Limiter]║
 ║  [ Pydantic Schemas V2 ]  [ SQLAlchemy ORM  ]  [ Swagger UI  ]║
 ╚═════════════╤══════════════════╤══════════════════╤═══════════╝
               │                  │                  │
    ┌──────────▼─────────┐ ┌──────▼──────┐ ┌─────────▼────────┐
    │  M4: ML Regressor  │ │  M5: Math   │ │  M6: GenAI Agent │
    │  ExtraTrees Model  │ │  SS, ROP,   │ │  Local Autonomous│
    │  (joblib .pkl)     │ │  ROQ, DoS   │ │  Engine          │
    └────────────────────┘ └─────────────┘ └──────────────────┘
               │                  │                  │
 ╔═════════════╧══════════════════╧══════════════════╧═══════════╗
 ║             SUPABASE CLOUD POSTGRESQL DATABASE                ║
 ║  Tables: products, stores, inventory, sales, forecast_logs    ║
 ╚═══════════════════════════════════════════════════════════════╝
```

---

# 4. Technology Stack & Architectural Justifications

| Technology | Purpose | Why Chosen Over Alternatives? |
| :--- | :--- | :--- |
| **FastAPI** | REST API Framework | Built on Starlette and Pydantic. Automatic OpenAPI docs at `/docs`, runtime type enforcement, native async, and 3x faster than Flask. |
| **Pydantic V2** | Schema Validation | Rust-powered core validation. Automatically validates input data, coerces types, generates Swagger schemas, and catches bad payloads with HTTP 422. |
| **SQLAlchemy 2.0** | Object-Relational Mapper | Enterprise-grade ORM with connection pooling (`QueuePool`), transaction management, and parameterized queries preventing SQL injection. |
| **psycopg2-binary** | PostgreSQL Driver | Standard C-based PostgreSQL adapter optimized for cloud databases (Supabase, AWS RDS). |
| **Joblib / Scikit-Learn** | ML Model Serialization | Efficiently serializes tree structures; allows pre-loading the 850MB ExtraTrees model once into RAM. |
| **Pytest + TestClient** | Automated Testing | Isolated execution with in-memory SQLite fixtures; simulates HTTP calls without network socket latency. |

---

# 5. Exhaustive Code & Logic Deep Dive

Here is the exact code breakdown of what each critical file and function does line-by-line:

---

### 5.1 `app/main.py` — Application Entrypoint & Lifespan
```python
@asynccontextmanager
async def lifespan(app: FastAPI):
    # 1. Start-up: Preload 850MB ExtraTrees ML model into memory once
    ForecastService.load_model()
    # 2. Verify and inspect PostgreSQL tables
    # 3. Hand control over to the ASGI web server
    yield
    # 4. Shutdown: Clean up background resources if needed
```
- **What this code does**:
  - `lifespan`: Modern FastAPI replacement for `@app.on_event("startup")`.
  - `ForecastService.load_model()`: Preloads the 850MB joblib ExtraTrees model into RAM. If loaded per-request, latency would be 3–4 seconds. Preloaded, inference is **<15ms**.
  - `CORSMiddleware`: Sets `allow_origins=["*"]`, enabling the Vite/React frontend on port 5173 to communicate with FastAPI on port 8000 without browser CORS security blocks.
  - `app.include_router(...)`: Mounts modular routers with prefixes (`/products`, `/forecast`, `/inventory`, `/recommendation`, `/agent`, `/`).

---

### 5.2 `app/database/connection.py` — Engine & Connection Pool
```python
engine = create_engine(
    settings.DATABASE_URL,
    poolclass=QueuePool,
    pool_size=10,
    max_overflow=20,
    pool_recycle=300,
    pool_pre_ping=True
)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
```
- **What this code does**:
  - `QueuePool`: Maintains an active pool of up to 30 database connections (10 base + 20 overflow) to Supabase PostgreSQL.
  - `pool_pre_ping=True`: Pings the database before handing out a connection; if Supabase dropped the TCP socket, it auto-reconnects.
  - `get_db()`: Dependency generator used in route signatures (`db: Session = Depends(get_db)`). The `finally: db.close()` guarantees connections return to the pool immediately, **preventing connection leaks**.

---

### 5.3 `app/api/dashboard.py` — Dashboard Controller for Frontend
```python
@router.get("/inventory/pulse")
def get_inventory_pulse(store_id: Optional[str] = None, db: Session = Depends(get_db)):
    # Aggregates network stock from PostgreSQL
    items = crud.get_detailed_inventory(db, store_id=store_id)
    # Computes aggregate units, categories, healthy vs low stock
    ...
```
- **What this code does**:
  - `GET /risk`: Queries inventory, computes Days of Supply ($DoS$), flags `CRITICAL` ($DoS \le 3$) and `HIGH` ($DoS \le 7$) stockout risks, and formats them for the frontend Risk Radar.
  - `GET /reorder`: Identifies SKUs where `current_stock <= reorder_point`, calculates Recommended Order Quantity ($ROQ$), and outputs the Reorder Recommendations queue.
  - `GET /inventory/pulse`: Computes high-level KPI cards (Total Stock, Active SKUs, Store count, Stockout Count).
  - `GET /store-region`: Groups stores by geographic region (`North`, `South`, `Central`) with aggregate stock levels.

---

### 5.4 `app/api/forecast.py` — Demand Prediction & Time-Series Engine
```python
@router.post("/forecast", response_model=ForecastResponse)
def generate_forecast(req: ForecastRequest, db: Session = Depends(get_db)):
    pred = ForecastService.predict_demand(...)
    crud.log_forecast(db, ...)
    return pred

@router.get("/forecast")
def get_forecast_schedule(storeId: str, productId: str, horizon: int = 14, db: Session = Depends(get_db)):
    # 1. Fetch recent sales actuals from PostgreSQL
    # 2. Get daily base demand prediction d from ML model
    # 3. Project 14 to 30 days forward with confidence bands (upper/lower)
```
- **What this code does**:
  - `POST /forecast`: Executes single-point ML prediction for specific price/promotion scenarios.
  - `GET /forecast`: Powers the interactive charts in `DemandForecast.jsx`. Streams historical actual sales joined with a multi-day forward predictive trajectory including upper ($1.15 \times d$) and lower ($0.85 \times d$) confidence intervals.

---

### 5.5 `app/services/forecast_service.py` — 26-Feature ML Pipeline
```python
class ForecastService:
    _model = None
    _features = None  # Loaded from model_features.pkl

    @classmethod
    def predict_demand(cls, data: dict) -> float:
        # 1. Initialize dictionary with all 26 feature keys defaulted to 0.0
        row = {f: 0.0 for f in cls._features}
        # 2. Map categorical encodings (Weather, Season, Category)
        # 3. Populate covariates (Inventory, Price, Discount, Lead Time)
        # 4. Construct strictly aligned 1-row Pandas DataFrame
        df = pd.DataFrame([row])[cls._features]
        # 5. Run inference
        return float(cls._model.predict(df)[0])
```
- **What this code does**:
  - Reads `model_features.pkl` to strictly enforce column names and order matching M4's model training.
  - Maps string categories (`Rainy` $\rightarrow 3$, `Electronics` $\rightarrow 1$) to label encodings.
  - Converts single input requests into valid scikit-learn DataFrame features and invokes `.predict()`.

---

### 5.6 `app/services/inventory_service.py` — Industrial Inventory Math
```python
def calculate_safety_stock(daily_demand: float, lead_time_days: int, demand_std_dev: float = None, service_level_z: float = 1.65) -> float:
    # SS = Z * sigma_d * sqrt(L)
    if demand_std_dev is None:
        demand_std_dev = daily_demand * 0.25
    return service_level_z * demand_std_dev * math.sqrt(lead_time_days)

def calculate_reorder_point(daily_demand: float, lead_time_days: int, safety_stock: float) -> float:
    # ROP = (d * L) + SS
    return (daily_demand * lead_time_days) + safety_stock

def calculate_days_of_supply(current_inventory: int, daily_demand: float) -> float:
    # DoS = Current Inventory / d
    return current_inventory / max(daily_demand, 0.001)

def calculate_reorder_quantity(current_inventory: int, reorder_point: float, daily_demand: float, lead_time_days: int, safety_stock: float) -> int:
    # Target Max Cycle Stock = 2 * (d * L) + SS
    target_stock = (2 * daily_demand * lead_time_days) + safety_stock
    return max(0, int(math.ceil(target_stock - current_inventory)))
```
- **What this code does**:
  - Implements the 4 deterministic supply chain formulas agreed with M5:
    1. **Safety Stock ($SS$)**: Volatility protection buffer using $Z=1.65$ (95% customer satisfaction).
    2. **Reorder Point ($ROP$)**: Minimum threshold that triggers procurement.
    3. **Days of Supply ($DoS$)**: Remaining runway before a stockout.
    4. **Recommended Order Quantity ($ROQ$)**: Batch purchase size to return to safe stock levels.

---

### 5.7 `app/services/agent_service.py` & `Gen AI/` — Autonomous Chat Copilot
```python
def detect_language(text: str) -> str:
    # Unicode range checks: Telugu (\u0c00-\u0c7f), Hindi (\u0900-\u097f)
    ...

def process_agent_chat(message: str, db: Session) -> AgentChatResponse:
    # 1. Classify intent: risk_list | reorder_decision | forecast | general
    # 2. Extract entities: SKU, Store, Horizon
    # 3. Execute tool against PostgreSQL or ML model
    # 4. Formulate grounded, anti-hallucination response
```
- **What this code does**:
  - Classifies conversational intent without paying for third-party OpenAI/Gemini tokens.
  - Directly queries PostgreSQL and `ForecastService` to produce verifiable, grounded telemetry.
  - Supports English, Hindi, and Telugu multilingual queries.

---

### 5.8 `app/core/security.py` — API Protection & Rate Limiting
```python
def verify_api_key(x_api_key: str = Header(...)):
    if x_api_key != settings.API_KEY:
        raise HTTPException(status_code=403, detail="Invalid or missing API Key")

def rate_limit_chat(request: Request):
    # Sliding-window algorithm: max 20 requests per minute per IP address
```
- **What this code does**:
  - Protects destructive administrative endpoints (`POST /products`, `POST /inventory/adjust`).
  - Guards the AI chat assistant from spam and DoS attacks using IP-keyed request timestamp windows.

---


# 6. Cross-Team Integration Matrix (How M7 Works with M1–M8)

| Team Member | What You Received from Them | What You Delivered to Them |
| :--- | :--- | :--- |
| **M1: Project Lead** | System architecture & roadmap | Modular REST structure, Dockerfile, and production deployment scripts. |
| **M2: Data Engineer** | Cleaned dataset schemas & Supabase table specs | Created SQLAlchemy ORM models matching M2's data dictionary; seeded relational tables. |
| **M3: Feature Engineer** | 26 engineered feature definitions | Encapsulated feature scaling and label encoding inside `ForecastService` to construct the 26-feature vector. |
| **M4: Forecasting ML** | Serialized model artifact (`.pkl`) | Built `ForecastService.load_model()`, preloaded model into memory, and served sub-20ms inference endpoints. |
| **M5: Inventory Optimization** | Mathematical formulas (SS, ROP, DoS, ROQ) | Built `InventoryService` implementing industrial math algorithms and logging audit recommendations to PostgreSQL. |
| **M6: GenAI Agent** | Autonomous Agent reasoning engine | Exposed `POST /agent/chat`, implemented multi-lingual entity extraction, rate limiting, and grounded context injection. |
| **M8: Frontend & DevOps** | UI data requirements from React pages | Built tailored REST endpoints (`/forecast`, `/inventory/pulse`, `/risk`, `/reorder`), configured CORS, and verified end-to-end telemetry. |

---

# 7. Top 25 Technical Interview Questions & High-Impact Answers

### Q1: What happens under the hood when a user opens the dashboard and requests a demand forecast?
> **Answer**: The frontend sends an HTTP `GET /forecast?storeId=S001&productId=P0001&horizon=14`. FastAPI's ASGI router directs this to `get_forecast_schedule` in `app/api/forecast.py`. The endpoint queries historical sales actuals from the Supabase PostgreSQL `sales` table using SQLAlchemy. Next, it calls `ForecastService.predict_demand`, which formats the input vector and runs `model.predict()` using the preloaded ExtraTrees ML model in memory. It applies our inventory math to calculate Safety Stock and Reorder Point, formats the multi-step forward time-series array with upper and lower confidence bounds, and returns a JSON response in **under 25 milliseconds**.

### Q2: Why did you preload the ML model during lifespan startup instead of inside the endpoint function?
> **Answer**: An ExtraTrees regressor serialized via joblib is hundreds of megabytes. If we loaded the `.pkl` file from disk inside the route handler, every API call would incur disk I/O, deserialization overhead, and a 3- to 4-second latency penalty. Preloading it once during the FastAPI `lifespan` startup keeps the model resident in RAM, making inference near-instantaneous (~5-15ms) across all worker threads.

### Q3: How do you prevent database connection starvation under heavy user concurrency?
> **Answer**: We configured SQLAlchemy's `create_engine` with `QueuePool`, setting `pool_size=10` and `max_overflow=20`. This ensures a maximum of 30 connections to Supabase. In our endpoints, we use the dependency injection pattern `db: Session = Depends(get_db)`. Because `get_db()` uses Python's `try...finally: db.close()`, connections are guaranteed to return to the pool immediately after the response is rendered, completely preventing connection leaks.

### Q4: How does your backend handle Cross-Origin Resource Sharing (CORS)?
> **Answer**: In `app/main.py`, we added Starlette's `CORSMiddleware`. We configured `allow_origins=["*"]`, `allow_credentials=True`, `allow_methods=["*"]`, and `allow_headers=["*"]`. When the browser makes a pre-flight `OPTIONS` request from port 5173 to port 8000, FastAPI responds with HTTP 200 and the appropriate `Access-Control-Allow-Origin` headers, allowing the React frontend to communicate with the backend securely.

### Q5: How do you ensure the ML model receives the exact features it was trained on?
> **Answer**: We serialized the exact list of 26 feature column names in `model_features.pkl`. In `ForecastService.predict_demand`, we initialize a dictionary containing all 26 feature keys defaulted to `0.0`. We populate the available covariates (price, discount, promotion, inventory) and map categorical labels using dictionaries (`CATEGORY_ENC_MAP`, `WEATHER_ENC_MAP`, `SEASON_ENC_MAP`). Finally, we construct a Pandas DataFrame filtered and re-indexed strictly by `cls._features`. This guarantees zero column drift or ordering errors.

### Q6: What is the mathematical difference between Safety Stock and Reorder Point?
> **Answer**: 
> - **Safety Stock ($SS$)** is the buffer inventory held to protect against demand volatility and lead-time delays: $SS = Z \times \sigma_d \times \sqrt{L}$, where $Z=1.65$ represents a 95% service level.
> - **Reorder Point ($ROP$)** is the inventory level that triggers a replenishment order: $ROP = (d \times L) + SS$. It accounts for expected demand during lead time plus the safety stock buffer.

### Q7: How does your GenAI Agent avoid generating hallucinations?
> **Answer**: The agent in `app/services/agent_service.py` is grounded using a strict verification pipeline. It parses the intent and entity parameters (e.g. SKU `P0001` at store `S001`), executes live deterministic tools (`get_inventory_status`, `get_forecast`) directly against PostgreSQL and the ML engine, and populates the response using the live tool outputs. If a product does not exist, it raises a structured `ProductNotFoundError` rather than guessing.

### Q8: Why did you use Pydantic V2 instead of standard Python dictionaries?
> **Answer**: Pydantic V2 offers compile-time-like type enforcement and schema validation implemented in Rust. It automatically parses query parameters and JSON bodies, converts string dates to Python `datetime.date` objects, enforces constraints (e.g. `ge=0`, `le=1`), and automatically generates OpenAPI/Swagger schemas. If invalid data is supplied, it immediately halts execution with a detailed HTTP 422 error, protecting our database and ML model from bad input.

### Q9: What happens if the Supabase PostgreSQL database temporarily goes offline?
> **Answer**: Our `/health` probe executes `SELECT 1` inside a `try...except` block. If the database is unreachable, it catches the exception and returns an HTTP 503 Service Unavailable with `{"status": "unhealthy", "database": "disconnected"}`. In the frontend `api.js`, all live calls are wrapped in `try...catch` blocks that seamlessly fall back to `mockApi.js`, ensuring the executive dashboard never crashes.

### Q10: How do you test the backend without corrupting the live production database?
> **Answer**: In `tests/conftest.py`, we created an in-memory SQLite database using `sqlite:///:memory:` with `StaticPool`. We override the `get_db` dependency using FastAPI's `app.dependency_overrides[get_db] = override_get_db`. All 58 unit and integration tests run against isolated in-memory tables seeded with test fixtures, ensuring rapid execution (under 12 seconds) without network dependencies.

### Q11: How do you handle pagination in the product catalog?
> **Answer**: In `app/api/products.py`, we implement offset-based pagination via query parameters: `skip: int = 0` and `limit: int = 100`. In SQLAlchemy, this translates directly to `.offset(skip).limit(limit).all()`, preventing out-of-memory errors when the product catalog scales to tens of thousands of SKUs.

### Q12: How is the multi-horizon forecast generated for the 14-day and 30-day frontend charts?
> **Answer**: The endpoint `GET /forecast` takes `horizon: int = 14`. It fetches recent historical sales from PostgreSQL `sales` table, obtains the daily demand rate $d$ from the ML model, and generates future dates $t_0 + 1 \dots t_0 + H$. For each day, it calculates projected demand with natural seasonality modulation, computes decreasing stock trajectory, and adds upper and lower confidence intervals ($1.15 \times d$ and $0.85 \times d$), packaging them into the `timeSeries` array.

### Q13: How is rate limiting implemented on the AI chat endpoint?
> **Answer**: In `app/core/security.py`, we built `rate_limit_chat` using a sliding-window algorithm. It tracks client IP addresses and request timestamps in memory. If a client exceeds 20 requests within 60 seconds, it raises an `HTTPException(status_code=429, detail="Too Many Requests")`, protecting our server from bot abuse and denial-of-service attacks.

### Q14: What is the difference between synchronous (`def`) and asynchronous (`async def`) routes in FastAPI?
> **Answer**: When an endpoint is declared with `def`, FastAPI automatically offloads its execution to an external threadpool (`anyio.to_thread.run_sync`), preventing blocking operations (such as synchronous SQLAlchemy queries or CPU-bound ML model inference) from stalling the main event loop. If an endpoint is declared with `async def`, it runs directly on the event loop and must only use non-blocking `await` calls.

### Q15: How do you secure administrative endpoints like creating products or adjusting inventory?
> **Answer**: Write operations (`POST /products`, `POST /stores`, `POST /inventory/adjust`) are protected by FastAPI's dependency `dependencies=[Depends(verify_api_key)]`. It checks the request headers for `X-API-Key`. If the key is missing or does not match `settings.API_KEY`, it raises an `HTTPException(403 Forbidden)`.

---

# 8. Quick Cheat Sheet: 2-Minute Elevator Pitch

Memorize this pitch to introduce your role with authority:

> *"Hi, I'm the **Backend and API Engineer (M7)** for this project. My responsibility was architecting the high-performance core engine that connects our cloud database, machine learning models, and autonomous AI agent to the frontend dashboard.*
> 
> *I built the backend using **FastAPI** and **SQLAlchemy 2.0**, backed by a cloud **Supabase PostgreSQL** database with connection pooling and relational indexing. I engineered the ML inference pipeline that preloads our **ExtraTrees demand regressor** into memory and transforms live inputs into 26-feature vectors, delivering predictions in under 15 milliseconds.*
> 
> *I also implemented the supply chain math algorithms for **Safety Stock, Reorder Point, and Days of Supply**, and integrated our **local GenAI autonomous agent** with anti-hallucination grounding and multilingual support. Finally, I built 58 automated tests in Pytest and configured CORS and reverse proxying so our React frontend operates with live data and zero console errors."*

---
*Good luck with your interview! You have built a robust, enterprise-grade backend and you know every single folder, file, and line of code.*
