# 📦 Demand Forecasting & Inventory Optimization

An AI-powered **Demand Forecasting and Inventory Optimization platform** that helps businesses predict future product demand, optimize stock levels, reduce overstocking and stockouts, and generate actionable inventory recommendations.

The system combines **Machine Learning, FastAPI, React, PostgreSQL/Supabase, and Generative AI** to provide data-driven inventory decisions through an interactive dashboard.

---

## 🚀 Key Features

### 📈 Demand Forecasting

* Predicts future product demand using Machine Learning.
* Uses historical sales and inventory-related features.
* Built using an **ExtraTrees Regressor** model.
* Provides product-level demand predictions.

### 📦 Inventory Optimization

* Calculates recommended inventory levels based on predicted demand.
* Helps reduce excess inventory and stockout risks.
* Supports inventory planning and replenishment decisions.
* Uses inventory management concepts such as **Economic Order Quantity (EOQ)**.

### 🤖 AI-Powered Recommendations

* Generates actionable recommendations based on forecast and inventory data.
* Helps identify products that may require replenishment.
* Provides natural-language explanations using Generative AI.

### 📊 Interactive Dashboard

* Displays demand forecasts and inventory insights.
* Provides product-level information.
* Visualizes important inventory metrics.
* Allows users to interact with the forecasting system through a modern web interface.

### 🔐 Backend Validation

* Uses **Pydantic** for request and response validation.
* Ensures API data follows the expected structure.
* Provides reliable communication between frontend and backend.

---

# 🏗️ System Architecture

```text
                    ┌─────────────────────┐
                    │     React Frontend  │
                    │     Dashboard UI    │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │    FastAPI Backend  │
                    │     REST APIs       │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │  Pydantic Validation│
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │    Service Layer    │
                    │  Business Logic     │
                    └──────┬─────┬────────┘
                           │     │
              ┌────────────┘     └─────────────┐
              ▼                                ▼
    ┌──────────────────┐              ┌─────────────────┐
    │ PostgreSQL /     │              │ Machine Learning│
    │ Supabase         │              │ ExtraTrees      │
    └──────────────────┘              └────────┬────────┘
                                               │
                                               ▼
                                      ┌─────────────────┐
                                      │ Demand Forecast │
                                      └────────┬────────┘
                                               │
                                               ▼
                                      ┌─────────────────┐
                                      │ Inventory Logic │
                                      │ / EOQ / Reorder │
                                      └────────┬────────┘
                                               │
                                               ▼
                                      ┌─────────────────┐
                                      │      GenAI      │
                                      │ Recommendations │
                                      └────────┬────────┘
                                               │
                                               ▼
                                      ┌─────────────────┐
                                      │   JSON Response │
                                      └────────┬────────┘
                                               │
                                               ▼
                                      ┌─────────────────┐
                                      │ React Dashboard │
                                      └─────────────────┘
```

---

# 🛠️ Technology Stack

## Frontend

* **React.js**
* JavaScript
* HTML5
* CSS3
* REST API integration
* Dashboard visualizations

## Backend

* **Python**
* **FastAPI**
* Pydantic
* REST APIs
* Uvicorn

## Machine Learning

* **Scikit-learn**
* ExtraTrees Regressor
* Pandas
* NumPy

## Database

* **PostgreSQL**
* **Supabase**

## AI

* Generative AI
* AI-powered inventory recommendations
* Natural-language insights

## Deployment

* **AWS EC2** – Backend
* **Amazon S3** – Frontend hosting
* REST-based frontend/backend communication

---

# 🧠 Machine Learning Pipeline

The forecasting pipeline follows these steps:

```text
Historical Sales Data
        ↓
Data Preprocessing
        ↓
Feature Engineering
        ↓
Train/Test Split
        ↓
ExtraTrees Regressor
        ↓
Demand Prediction
        ↓
Inventory Optimization
        ↓
AI Recommendations
```

### Model

The project uses an **ExtraTrees Regressor** for demand forecasting.

ExtraTrees builds multiple randomized decision trees and combines their predictions to produce the final regression output.

The model is suitable for capturing nonlinear relationships between demand and influencing factors.

---

# 📊 Inventory Optimization

The system uses forecasted demand along with inventory parameters to support replenishment decisions.

### Economic Order Quantity (EOQ)

EOQ can be calculated using:

```text
EOQ = √((2 × D × S) / H)
```

Where:

* `D` = Annual demand
* `S` = Ordering cost per order
* `H` = Holding cost per unit per year

The resulting quantity can be used as a reference for determining an efficient order size.

### Reorder Planning

The system can combine:

* Forecasted demand
* Current inventory
* Lead time
* Safety stock
* Reorder point
* EOQ

to generate inventory recommendations.

---

# 🔌 API Architecture

The backend exposes REST APIs through FastAPI.

Example flow:

```text
React
  ↓
HTTP Request
  ↓
FastAPI Endpoint
  ↓
Pydantic Validation
  ↓
Service Layer
  ↓
Database / ML / Inventory Logic
  ↓
GenAI
  ↓
JSON Response
  ↓
React
```

### Example Health Check

```http
GET /health
```

Example response:

```json
{
  "status": "healthy"
}
```

---

# 📁 Project Structure

```text
demand-forecasting-inventory/
│
├── frontend/
│   ├── src/
│   ├── public/
│   ├── package.json
│   └── ...
│
├── backend/
│   ├── app/
│   │   ├── main.py
│   │   ├── routes/
│   │   ├── services/
│   │   ├── models/
│   │   └── schemas/
│   │
│   ├── ml/
│   │   ├── model/
│   │   ├── preprocessing/
│   │   └── forecasting/
│   │
│   ├── requirements.txt
│   └── ...
│
├── data/
│   └── ...
│
├── README.md
└── .gitignore
```

> The exact folder structure may vary depending on the implementation.

---

# ⚙️ Installation & Setup

## 1. Clone the Repository

```bash
git clone https://github.com/<your-username>/demand-forecasting-inventory.git

cd demand-forecasting-inventory
```

---

## 2. Backend Setup

Navigate to the backend:

```bash
cd backend
```

Create a virtual environment:

```bash
python -m venv venv
```

Activate it on Windows:

```bash
venv\Scripts\activate
```

Activate it on Linux/macOS:

```bash
source venv/bin/activate
```

Install dependencies:

```bash
pip install -r requirements.txt
```

---

## 3. Configure Environment Variables

Create a `.env` file inside the backend directory.

Example:

```env
DATABASE_URL=your_database_url
SUPABASE_URL=your_supabase_url
SUPABASE_KEY=your_supabase_key
GENAI_API_KEY=your_genai_api_key
```

**Do not commit `.env` files or API keys to GitHub.**

---

## 4. Start the Backend

```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

Backend will be available at:

```text
http://localhost:8000
```

FastAPI documentation:

```text
http://localhost:8000/docs
```

---

# 💻 Frontend Setup

Open another terminal:

```bash
cd frontend
```

Install dependencies:

```bash
npm install
```

Start the development server:

```bash
npm run dev
```

The frontend will be available through the URL displayed by the development server.

---

# 🔄 Example Prediction Flow

A typical prediction request follows this process:

```text
User selects product
        ↓
React sends request
        ↓
FastAPI receives request
        ↓
Pydantic validates input
        ↓
Service layer processes request
        ↓
ML model predicts demand
        ↓
Inventory logic calculates requirements
        ↓
GenAI generates explanation/recommendation
        ↓
Backend returns JSON
        ↓
React displays result
```

---

# 📌 Example Use Case

Consider a retail product with historical sales data.

The system can:

1. Analyze historical demand.
2. Predict future demand.
3. Check current inventory.
4. Calculate inventory requirements.
5. Consider replenishment parameters.
6. Generate an actionable recommendation.
7. Display the result on the dashboard.

Example:

```text
Predicted Demand
       ↓
Current Stock
       ↓
Safety Stock
       ↓
Reorder Point
       ↓
EOQ
       ↓
Inventory Recommendation
```

---

# ☁️ Deployment

The application can be deployed using a cloud-based architecture.

```text
                 Internet
                    │
                    ▼
          ┌──────────────────┐
          │  Amazon S3       │
          │ React Frontend   │
          └────────┬─────────┘
                   │
                   │ REST API
                   ▼
          ┌──────────────────┐
          │   AWS EC2        │
          │ FastAPI Backend  │
          └────────┬─────────┘
                   │
             ┌─────┴─────┐
             ▼           ▼
       PostgreSQL       ML Model
        / Supabase
```

The frontend and backend communicate through REST APIs.

---

# 🔒 Security

The project follows basic security practices including:

* Environment variables for sensitive credentials.
* `.gitignore` for secret files.
* Pydantic request validation.
* API-based separation between frontend and backend.
* No API keys stored directly in source code.

---

# 📈 Future Improvements

* Add time-series models such as **XGBoost, LightGBM, Prophet, or LSTM**.
* Implement automated model retraining.
* Add real-time inventory synchronization.
* Introduce supplier and lead-time optimization.
* Add advanced safety-stock calculations.
* Add multi-product forecasting.
* Add role-based authentication.
* Add automated alerts for low-stock products.
* Improve forecasting with external factors such as promotions and seasonality.
* Add model monitoring and performance tracking.

---

# 🎯 Project Goals

The primary goals of this project are to:

* Improve demand prediction accuracy.
* Reduce inventory holding costs.
* Reduce stockout situations.
* Support data-driven replenishment.
* Automate inventory decision-making.
* Provide understandable AI-powered recommendations.

---

# 👨‍💻 Authors

**Mukesh Reddy**

Built as an AI/ML and full-stack project focused on **Demand Forecasting, Inventory Optimization, Machine Learning, and Generative AI**.

---

# ⭐ Contributing

Contributions are welcome.

```bash
git checkout -b feature/new-feature
git add .
git commit -m "Add new feature"
git push origin feature/new-feature
```

Then open a Pull Request.

---

# 📄 License

This project is intended for educational, demonstration, and development purposes.
