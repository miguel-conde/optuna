# Module 2 — Bayesian Optimization Fundamentals

**Goal:** Understand the theory behind modern hyperparameter optimization and why algorithms like **Optuna’s TPE** work.

Bayesian Optimization (BO) is designed for problems where:

* evaluations are **expensive**
* gradients are **not available**
* the function is **unknown**

Instead of directly optimizing the objective function (f(x)), BO builds a **probabilistic model of the function** and uses it to decide **where to evaluate next**.

---

# 1. Surrogate Models

The key idea of Bayesian Optimization is replacing the true function with an **approximate probabilistic model**.

Let:

[
f(x)
]

be the true objective function.

We construct a **surrogate model**:

[
\hat{f}(x)
]

This surrogate approximates the behavior of the true function using previously observed data.

Training data:

[
D = {(x_1, y_1), (x_2, y_2), ..., (x_n, y_n)}
]

where

[
y_i = f(x_i)
]

The surrogate model estimates:

* **expected value of the function**
* **uncertainty of the estimate**

So for every (x), we obtain:

[
p(f(x)\mid D)
]

Meaning: a **probability distribution of possible values**.

This uncertainty estimate is what allows BO to balance **exploration and exploitation**.

---

# 2. Gaussian Processes (Conceptual Overview)

The most classical surrogate model in Bayesian Optimization is the **Gaussian Process (GP)**.

A Gaussian Process defines a distribution over functions.

Instead of modeling parameters, it models the **entire function space**.

Formally:

[
f(x) \sim \mathcal{GP}(m(x), k(x,x'))
]

Where:

* (m(x)) → mean function
* (k(x,x')) → covariance kernel

Interpretation:

* the mean represents the **expected function value**
* the kernel defines **similarity between inputs**

Common kernels:

* RBF kernel
* Matern kernel
* Rational quadratic

Intuition:

Points close together in input space should have **similar outputs**.

---

### Prediction with a GP

For a candidate point (x), the GP predicts:

* mean:

[
\mu(x)
]

* variance:

[
\sigma^2(x)
]

Meaning we estimate:

[
f(x) \sim \mathcal{N}(\mu(x), \sigma^2(x))
]

So each candidate point has:

* **expected value**
* **uncertainty**

These two quantities drive the **acquisition function**.

---

# 3. Acquisition Functions

The surrogate model approximates the function.

But how do we decide **where to sample next**?

That decision is made using an **acquisition function**.

The acquisition function determines the **utility of evaluating a candidate point**.

General rule:

[
x_{next} = \arg\max a(x)
]

where (a(x)) is the acquisition function.

Acquisition functions encode the **exploration–exploitation tradeoff**.

They prefer points that are either:

* predicted to be **good**
* have **high uncertainty**

---

# 4. Probability of Improvement (PI)

The simplest acquisition function.

Goal:

Evaluate points likely to improve the best observed value.

Let:

* (f^*) = best observed value
* (f(x)) = predicted distribution

Probability of improvement:

[
PI(x) = P(f(x) < f^*)
]

(for minimization problems)

Interpretation:

Pick points with high probability of beating the current best.

Problem:

PI tends to **over-exploit** promising regions.

---

# 5. Expected Improvement (EI)

Expected Improvement solves the main weakness of PI.

Instead of just asking:

> “What is the probability of improvement?”

we ask:

> “How large might the improvement be?”

Expected improvement:

[
EI(x) = E[\max(f^* - f(x),0)]
]

Meaning:

Expected gain over the current best.

EI balances:

* **low predicted mean**
* **high uncertainty**

This makes it one of the most widely used acquisition functions.

---

# 6. Upper Confidence Bound (UCB)

Another widely used acquisition strategy.

Upper confidence bound:

[
UCB(x) = \mu(x) + \kappa \sigma(x)
]

For maximization.

For minimization:

[
LCB(x) = \mu(x) - \kappa \sigma(x)
]

Where:

* ( \mu(x) ) → predicted mean
* ( \sigma(x) ) → uncertainty
* ( \kappa ) → exploration parameter

Large ( \kappa ):

* more exploration

Small ( \kappa ):

* more exploitation

This provides a **direct exploration control parameter**.

---

# 7. Bayesian Optimization Loop

The full optimization procedure is:

```
1. Sample initial random points
2. Fit surrogate model (e.g., Gaussian Process)
3. Compute acquisition function
4. Select next point maximizing acquisition
5. Evaluate objective function
6. Update surrogate model
7. Repeat
```

This allows the algorithm to **focus evaluations in promising areas**.

---

# 8. Limitations of Gaussian Process Optimization

Although GP-based Bayesian optimization is powerful, it has several limitations.

### 1. Computational Complexity

Training a Gaussian Process requires:

[
O(n^3)
]

where (n) is the number of observations.

This limits scalability beyond a few thousand evaluations.

---

### 2. High Dimensionality

Gaussian Processes perform poorly when:

[
d > 20
]

Many ML problems involve **dozens of hyperparameters**.

---

### 3. Handling Categorical Variables

GP kernels are designed for **continuous spaces**.

Categorical parameters are awkward to represent.

Example:

```
optimizer = ["adam", "sgd", "rmsprop"]
```

GP models struggle with this type of structure.

---

# 9. Transition to TPE (Tree-structured Parzen Estimator)

Optuna does **not** use Gaussian Processes.

Instead it uses **TPE**, which reformulates the optimization problem.

Instead of modeling:

[
p(y|x)
]

TPE models:

[
p(x|y)
]

The algorithm splits observations into:

* **good points**
* **bad points**

Then it builds density estimators for both.

Optimization becomes:

[
\arg\max \frac{l(x)}{g(x)}
]

where:

* (l(x)) → density of good observations
* (g(x)) → density of bad observations

Advantages:

* scales better
* handles categorical variables
* works well in high dimensions
* easy to implement

This is why **Optuna uses TPE as its default sampler**.

We will study the full TPE algorithm in **Module 3**.

---

# Practical Exercise — Visualizing Acquisition Functions

Let’s visualize **exploration vs exploitation**.

We simulate a surrogate model prediction.

```python
import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import norm

x = np.linspace(-2, 6, 200)

mu = np.sin(x) + 0.5
sigma = 0.3 + 0.2*np.cos(x)

f_best = -0.2

z = (f_best - mu) / sigma
EI = (f_best - mu) * norm.cdf(z) + sigma * norm.pdf(z)

plt.figure(figsize=(8,5))
plt.plot(x, mu, label="Predicted mean")
plt.fill_between(x, mu-sigma, mu+sigma, alpha=0.2, label="Uncertainty")
plt.plot(x, EI, label="Expected Improvement")
plt.legend()
plt.title("Acquisition Function Visualization")
plt.show()
```

What to observe:

* uncertainty drives exploration
* low predicted mean drives exploitation
* EI balances both

---

# Key Takeaways

Bayesian Optimization works by combining three components:

1️⃣ **Surrogate model**

Approximates the unknown function.

2️⃣ **Uncertainty estimation**

Allows exploration.

3️⃣ **Acquisition function**

Selects the next evaluation point.

However, classical GP-based BO has limitations.

Modern frameworks like **Optuna** use **TPE**, which is more scalable and flexible.

---

# Before Moving to Module 3

Next module:

**Module 3 — The TPE Algorithm (Core of Optuna)**

We will cover:

* the mathematics of **Parzen estimators**
* how Optuna splits good vs bad trials
* the **likelihood ratio optimization**
* how TPE replaces acquisition functions.

Before continuing, quick check:

1️⃣ Is the intuition behind **surrogate models and acquisition functions** clear?
2️⃣ Would you like a **step-by-step numerical example of Expected Improvement** before moving to TPE?
