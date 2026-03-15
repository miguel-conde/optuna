# Module 3 — The TPE Algorithm (Core of Optuna)

**Goal:** Understand the algorithm Optuna actually uses to perform optimization:
**TPE — Tree-structured Parzen Estimator**.

Unlike classical Bayesian Optimization based on **Gaussian Processes**, TPE uses **density estimation**. This allows it to scale better to high-dimensional and structured search spaces.

---

# 1. Density Estimation Approach

Traditional Bayesian optimization models:

[
p(y|x)
]

meaning:

> What is the distribution of the objective value given parameters (x)?

TPE flips the problem.

Instead it models:

[
p(x|y)
]

meaning:

> What parameter values tend to produce good objective values?

This reformulation allows the algorithm to use **density estimation** instead of regression.

The core idea:

1. Evaluate some trials
2. Separate **good results** and **bad results**
3. Estimate probability densities for each group
4. Sample new parameters likely to belong to the **good region**

---

# 2. Splitting Observations into Good vs Bad Regions

Assume we already evaluated (n) points:

[
(x_1,y_1), (x_2,y_2), ..., (x_n,y_n)
]

Define a threshold (y^*) such that:

* the **best γ fraction** of trials are considered **good**
* the rest are considered **bad**

Typically:

[
\gamma \approx 0.1\text{–}0.25
]

Then we define two datasets:

Good observations:

[
y < y^*
]

Bad observations:

[
y \ge y^*
]

From these we estimate two probability densities.

---

# 3. Two Density Models

TPE builds two models:

[
l(x) = p(x | y < y^*)
]

[
g(x) = p(x | y \ge y^*)
]

Interpretation:

| Density | Meaning                                          |
| ------- | ------------------------------------------------ |
| (l(x))  | parameters that tend to produce **good results** |
| (g(x))  | parameters associated with **bad results**       |

The goal becomes:

> Sample parameters that look like **good trials**, but not like **bad trials**.

---

# 4. Likelihood Ratio Optimization

The next evaluation point is chosen by maximizing:

[
\frac{l(x)}{g(x)}
]

Interpretation:

Good candidate points have:

* high probability under **good density**
* low probability under **bad density**

This ratio acts similarly to an **acquisition function**.

But instead of using a GP model, it uses **density ratios**.

---

# 5. Parzen Density Estimators

How do we estimate (l(x)) and (g(x))?

Using **Kernel Density Estimation (KDE)**.

Given samples:

[
x_1,x_2,...,x_n
]

The KDE estimate is:

[
p(x)=\frac{1}{n}\sum_{i=1}^{n}K(x-x_i)
]

Where (K) is a kernel function (often Gaussian).

Interpretation:

Each observation contributes a **smooth bump** in the probability distribution.

This produces a continuous density estimate.

---

# 6. Exploration vs Exploitation in TPE

TPE balances exploration and exploitation through:

### 1. Density ratio

[
\frac{l(x)}{g(x)}
]

High values indicate promising regions.

---

### 2. Random sampling

TPE samples multiple candidates and evaluates their ratios.

This keeps exploration alive.

---

### 3. Quantile threshold

The parameter γ controls exploration.

Typical value:

[
\gamma = 0.15
]

Lower γ:

* stronger exploitation

Higher γ:

* more exploration

---

# 7. The TPE Algorithm (Full Procedure)

Simplified algorithm:

```text
1. Sample N random points
2. Evaluate objective function
3. Split trials into good and bad sets
4. Estimate densities l(x) and g(x)
5. Sample candidate parameters from l(x)
6. Compute l(x) / g(x)
7. Select best candidate
8. Evaluate objective
9. Update densities
10. Repeat
```

Important detail:

TPE **samples many candidates**, then chooses the best according to the likelihood ratio.

---

# 8. Why TPE Works Well in Practice

TPE has several advantages compared to GP-based optimization.

### Handles High Dimensions

Gaussian Processes struggle when:

[
d > 20
]

TPE works well with **dozens of parameters**.

---

### Handles Categorical Variables

TPE can easily model:

* discrete variables
* categorical variables
* conditional search spaces

Example:

```python
optimizer = trial.suggest_categorical(
    "optimizer",
    ["adam","sgd","rmsprop"]
)
```

---

### Works with Tree-Structured Search Spaces

Example:

```
model = trial.suggest_categorical("model", ["xgboost","svm"])

if model == "xgboost":
    depth = trial.suggest_int("depth",3,10)
```

This creates a **tree-structured parameter space**, which is hard for Gaussian processes.

---

### Efficient in Practice

TPE has complexity roughly:

[
O(n)
]

per iteration.

Much more scalable than:

[
O(n^3)
]

for Gaussian processes.

---

# 9. Why Optuna Uses TPE

Optuna’s design goals:

* high scalability
* flexible search spaces
* strong performance in ML hyperparameter tuning

TPE satisfies all three.

This is why **Optuna uses TPE as its default sampler**.

Other samplers exist (we will study them later):

* RandomSampler
* CMA-ES
* NSGA-II (multi-objective)

---

# Practical Exercise — Implement a Simplified TPE

This simplified version captures the core idea.

### Step 1 — Define the objective

```python
import numpy as np

def objective(x):
    return (x-2)**2 + np.sin(3*x)
```

---

### Step 2 — Initial random sampling

```python
X = np.random.uniform(-5,5,20)
Y = objective(X)
```

---

### Step 3 — Split good vs bad trials

```python
gamma = 0.2
threshold = np.quantile(Y, gamma)

good = X[Y < threshold]
bad = X[Y >= threshold]
```

---

### Step 4 — Density estimation

```python
from scipy.stats import gaussian_kde

l_density = gaussian_kde(good)
g_density = gaussian_kde(bad)
```

---

### Step 5 — Sample candidates

```python
candidates = np.random.uniform(-5,5,100)
ratio = l_density(candidates) / g_density(candidates)

x_next = candidates[np.argmax(ratio)]
```

---

### Step 6 — Evaluate new point

```python
y_next = objective(x_next)
```

Append and repeat.

This simplified version reproduces the **core mechanism behind TPE**.

---

# Key Takeaways

TPE reformulates Bayesian optimization using **density estimation**.

Instead of modeling:

[
p(y|x)
]

it models:

[
p(x|y)
]

This allows:

* better scalability
* handling categorical variables
* flexible search spaces

The algorithm selects new candidates by maximizing:

[
\frac{l(x)}{g(x)}
]

which favors parameters similar to **good trials** but different from **bad ones**.

---

# Before Moving to Module 4

Next module:

# Module 4 — Optuna Architecture

We will study the internal components:

* **Study**
* **Trial**
* **Objective functions**
* **Samplers**
* **Pruners**
* **Storage backends**

This is where theory meets **actual Optuna usage**.

Before continuing, quick check:

1️⃣ Is the **density-ratio idea behind TPE** clear?
2️⃣ Would you like a **visual explanation of how KDE builds the densities (l(x)) and (g(x))** before we move on?
