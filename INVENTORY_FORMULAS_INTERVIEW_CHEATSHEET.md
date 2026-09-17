# 🎯 Stocl Inventory Optimization & Formulas: Complete Interview Cheat Sheet
**Designed for Fast Revision & Bulletproof Answers in Your Technical Interview**

---

## ⚡ 1. 30-Second Elevator Pitch (Memorize This)
> *"Our system integrates a **Machine Learning Demand Forecasting model** with classical **stochastic inventory theory**. The ML model predicts expected daily demand ($d$) factoring in seasonality, promotions, and store trends. We then apply statistical formulas to calculate **Safety Stock ($SS$)** to buffer against demand uncertainty at a 95% service level ($Z=1.65$), set the **Reorder Point ($ROP$)** to signal when to buy, and compute a **Target Stock Level ($S = 2 \times dL + SS$)** to generate the exact **Recommended Order Quantity ($ROQ$)** without falling into the immediate-reorder trap."*

---

## 📊 2. Master Table of All Formulas

| # | Metric | Formula | Python Code Variable | Purpose / Meaning |
|---|---|---|---|---|
| **1** | **Daily Demand ($d$)** | $\hat{y}_{\text{ML}}$ | `daily_demand` | Expected consumption rate per day from ML model. |
| **2** | **Lead Time Demand ($LTD$)** | $d \times L$ | `lead_time_demand = d * L` | Units consumed while waiting $L$ days for delivery. |
| **3** | **Demand Std Dev ($\sigma_d$)** | $\sqrt{\frac{1}{N-1}\sum(d_i - \bar{d})^2}$ or $0.25 \times d$ | `daily_demand_std` | Daily demand volatility (standard deviation). |
| **4** | **Safety Stock ($SS$)** | $Z \times \sqrt{L} \times \sigma_d$ | `safety_stock` | Buffer stock for demand spikes during lead time. |
| **5** | **Reorder Point ($ROP$)** | $(d \times L) + SS$ | `reorder_point` | Threshold trigger: If $\text{Stock} \le ROP$, order now! |
| **6** | **Days of Supply ($DoS$)** | $\frac{\text{Current Inventory}}{d}$ | `days_of_supply` | How many days until current stock hits 0. |
| **7** | **Target Stock Level ($S$)** | $2 \times (d \times L) + SS$ | `target_inventory_level` | Optimal post-replenishment ceiling stock. |
| **8** | **Reorder Quantity ($ROQ$)** | $\max(0, \lceil S - \text{Current Inventory} \rceil)$ | `recommended_order` | Exact batch size to order when $\text{Stock} \le ROP$. |

---

## 🔍 3. The Core Formulas Explained in Plain English

### Formula 1: Safety Stock ($SS$)
$$\mathbf{SS = Z \times \sqrt{L} \times \sigma_d}$$
- **$Z$ (Service Level Factor):** Default is **$1.65$**, corresponding to a **95% cycle service level** (from standard normal distribution $\Phi(1.65) = 0.95$). If you want 99%, $Z = 2.33$.
- **$L$ (Lead Time in Days):** Supplier shipping time (default = **7 days**).
- **$\sqrt{L}$ (Square Root of Lead Time):** **Crucial Interview Point!** Daily demands are independent random variables. Variances add linearly ($\text{Var}_{\text{total}} = L \cdot \sigma_d^2$). Because standard deviation is the square root of variance, the uncertainty over $L$ days scales as $\mathbf{\sqrt{L} \times \sigma_d}$, **NOT** $L \times \sigma_d$!
- **$\sigma_d$ (Standard Deviation of Daily Demand):** Empirically computed from historical data, or conservatively estimated as $0.25 \times d$ (25% coefficient of variation).

---

### Formula 2: Reorder Point ($ROP$)
$$\mathbf{ROP = (d \times L) + SS}$$
- Tells the warehouse **WHEN** to place a purchase order.
- **Physical Meaning:** Over the $L$ days the truck takes to arrive, customers will buy $d \times L$ units. If demand surges unexpectedly, the safety stock $SS$ protects against stocking out before the truck arrives.
- **Trigger Rule:** If $\text{Effective Inventory} \le ROP$, place an order immediately!

---

### Formula 3: Target Stock & Recommended Order Quantity ($ROQ$)
$$\mathbf{S = 2 \times (d \times L) + SS}$$
$$\mathbf{ROQ = S - \text{Current Inventory} = 2 \times (d \times L) + SS - I_{\text{current}}}$$

#### ⭐ WHY THE FACTOR OF 2? (The #1 Interview Question!)
The interviewer **will ask**: *"Why multiply lead-time demand by 2? Why not just 1?"*

**Your Exact Answer:**
> *"The factor of 2 covers **TWO distinct operational horizons**:*
> 1. **Horizon 1 ($1 \times dL$) — Transit Pipeline Demand:** Covers customer sales during the $L$ days while you are waiting for the shipment to arrive.
> 2. **Horizon 2 ($1 \times dL$) — Cycle Stock for the Next Review Period:** When the shipment finally arrives, you must have enough stock on store shelves to last another $L$ days before the next replenishment cycle.
> 
> *If we only ordered $1 \times dL + SS - \text{Stock}$, on-hand inventory would drop to Safety Stock during transit, and upon arrival the new stock would immediately be at or below $ROP$ again on Day 1! This causes the **'Immediate Reorder Trap'** (infinite back-to-back emergency reordering). Using $2 \times dL$ ensures a stable $(s, S)$ periodic replenishment cycle."*

---

## 🚦 4. Stockout Risk Classification Matrix

The engine evaluates risk in `InventoryService.evaluate_stockout_risk()`:

| Risk Level | Condition | Operational Action | Reorder? |
|---|---|---|:---:|
| **CRITICAL** | $\text{Stock} \le 0.5 \times SS$ **OR** $\text{DoS} \le 0.5 \times L$ | `URGENT_REORDER` | **YES** |
| **HIGH** | $\text{Stock} \le SS$ **OR** $\text{DoS} \le L$ | `REORDER` | **YES** |
| **MEDIUM** | $SS < \text{Stock} \le ROP$ | `REORDER` | **YES** |
| **LOW (MONITOR)** | $ROP < \text{Stock} \le 3 \times dL$ | `MONITOR` | **NO** |
| **LOW (HOLD)** | $\text{DoS} > 3 \times L$ (Overstock) | `HOLD` (Avoid storage cost) | **NO** |

---

## 🔢 5. Walkthrough with Real Numbers (Practice Doing This on Whiteboard)

Suppose the interviewer asks: *"Show me an example calculation for SKU P0001."*

### Given Values:
- Forecasted Daily Demand ($d$) = **$100$ units/day**
- Supplier Lead Time ($L$) = **$7$ days**
- Service Level ($Z$) = **$1.65$** (95%)
- Daily Demand Std Dev ($\sigma_d$) = **$25$ units**
- Current Inventory on Hand ($I$) = **$250$ units**

### Step-by-Step Calculation:
1. **Lead Time Demand ($LTD$):**
   $$LTD = d \times L = 100 \times 7 = \mathbf{700 \text{ units}}$$
2. **Safety Stock ($SS$):**
   $$SS = Z \times \sqrt{L} \times \sigma_d = 1.65 \times \sqrt{7} \times 25 = 1.65 \times 2.646 \times 25 \approx \mathbf{109 \text{ units}}$$
3. **Reorder Point ($ROP$):**
   $$ROP = LTD + SS = 700 + 109 = \mathbf{809 \text{ units}}$$
4. **Days of Supply ($DoS$):**
   $$DoS = \frac{I}{d} = \frac{250}{100} = \mathbf{2.5 \text{ days}}$$
5. **Evaluate Risk:**
   - Current stock ($250$) is well below $ROP$ ($809$).
   - $DoS = 2.5 \text{ days} < L (7 \text{ days})$.
   - **Risk Level = HIGH**, Action = **REORDER**.
6. **Calculate Order Quantity ($ROQ$):**
   - Target $S = 2 \times LTD + SS = 2 \times 700 + 109 = \mathbf{1509 \text{ units}}$
   - $ROQ = S - I = 1509 - 250 = \mathbf{1259 \text{ units}}$

---

## 💻 6. Backend Code Mapping (Where It Lives in FastAPI)

| Class & Method | File | Key Logic |
|---|---|---|
| `InventoryService.calculate_safety_stock()` | `app/services/inventory_service.py` | Implements $Z \times \sqrt{L} \times \sigma_d$. Defaults to $0.25 \times d$ if std not passed. |
| `InventoryService.calculate_reorder_point()` | `app/services/inventory_service.py` | Implements $(d \times L) + SS$. |
| `InventoryService.optimize_inventory()` | `app/services/inventory_service.py` | Computes $S = 2dL + SS$ and $ROQ = \max(0, \lceil S - I \rceil)$. |
| `InventoryService.evaluate_stockout_risk()` | `app/services/inventory_service.py` | Checks CRITICAL, HIGH, MEDIUM, LOW thresholds and assigns actions. |
| `InventoryService.check_inventory()` | `app/services/inventory_service.py` | Orchestrates ML forecast + DB inventory + Safety Stock + ROP + ROQ into a single response. |
| `RecommendationService.generate_recommendation()` | `app/services/recommendation_service.py` | End-to-end pipeline: Forecast $\to$ Optimize $\to$ Risk $\to$ AI Explanation text $\to$ DB Logging. |

---

## 🗣️ 7. Top 5 Killer Interview Questions & Answers

### Q1: "Why do we use Machine Learning for demand instead of simple Moving Average or Holt-Winters?"
**Answer:**
> *"Classical statistical methods like Moving Average or ARIMA only look at past sales values univariate-style. Our ML model (ExtraTreesRegressor) incorporates **53 external features**: price, discount rates, marketing promotions, competitor pricing, weather conditions, seasonality flags, and local store demographics. This allows us to predict demand shocks and elasticity that classical timeseries methods miss."*

### Q2: "Why is the square root applied to Lead Time ($\sqrt{L}$) in Safety Stock?"
**Answer:**
> *"Because under probability theory (Central Limit Theorem), when you sum $L$ independent random daily demands $D_1 + D_2 + \dots + D_L$, their **variances** add: $\text{Var}(D_L) = \sum_{i=1}^L \text{Var}(D_i) = L \cdot \sigma_d^2$. The standard deviation is the square root of the variance: $\sigma_L = \sqrt{L \cdot \sigma_d^2} = \sqrt{L} \cdot \sigma_d$. If we used $L \cdot \sigma_d$, we would overestimate uncertainty by assuming daily demands are 100% perfectly correlated."*

### Q3: "What inventory review policy does this system implement?"
**Answer:**
> *"It implements a hybrid **Continuous Review $(s, S)$ policy** (also known as Min-Max policy). The Reorder Point $ROP$ acts as the minimum threshold ($s$). Whenever inventory drops below $s$, we trigger an order to bring inventory up to the target maximum level $S = 2dL + SS$."*

### Q4: "How does the system prevent over-ordering if an order is already placed but hasn't arrived?"
**Answer:**
> *"We evaluate **Effective Inventory** ($I_{\text{effective}} = \text{On-Hand Stock} + \text{Units on Order}$). If an order is already in transit from the supplier, `units_on_order` increases effective inventory above $ROP$, preventing duplicate purchase orders from being placed."*

### Q5: "What happens if supplier lead time is also uncertain?"
**Answer:**
> *"If lead time $L$ also has variance $\sigma_L^2$, we use the combined variance formula:*
> $$SS = Z \times \sqrt{L \cdot \sigma_d^2 + d^2 \cdot \sigma_L^2}$$
> *This accounts for both customer demand volatility and supplier shipping delays."*
