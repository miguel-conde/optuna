# Module 6 — Designing Search Spaces

**Goal:** Learn how to design **effective parameter search spaces**, which is one of the most critical aspects of successful optimization.

In practice, the **quality of the search space often matters more than the optimization algorithm itself**. Even a powerful optimizer like **TPE** will perform poorly if the search space is badly designed.

This module explains how to structure parameter spaces effectively.

---

# 1. Continuous vs Discrete Spaces

Parameters can be divided into **continuous** and **discrete** types.

## Continuous Parameters

These represent real-valued ranges.

Example:

[
x \in [-10, 10]
]

Optuna API:

```python
x = trial.suggest_float("x", -10, 10)
```

Typical examples:

| Parameter      | Example      |
| -------------- | ------------ |
| learning rate  | 0.0001 – 0.1 |
| regularization | 1e-6 – 1     |
| dropout        | 0 – 0.5      |

Continuous parameters often represent **physical or algorithmic quantities**.

---

## Discrete Parameters

Discrete parameters take **integer values**.

Example:

[
depth \in {1,2,3,...,10}
]

Optuna API:

```python
depth = trial.suggest_int("depth", 1, 10)
```

Examples:

| Parameter           | Example |
| ------------------- | ------- |
| tree depth          | 3–10    |
| number of layers    | 1–5     |
| number of neighbors | 3–50    |

---

## Categorical Parameters

Categorical parameters represent **choices**.

Optuna API:

```python
model = trial.suggest_categorical(
    "model",
    ["xgboost", "random_forest", "svm"]
)
```

Examples:

| Parameter  | Options        |
| ---------- | -------------- |
| optimizer  | adam / sgd     |
| activation | relu / tanh    |
| model type | rf / svm / xgb |

---

# 2. Log Distributions

Some parameters span **multiple orders of magnitude**.

Example: learning rate

[
[10^{-5}, 10^{-1}]
]

Sampling uniformly would oversample large values.

Instead we sample in **log-space**.

Optuna API:

```python
lr = trial.suggest_float(
    "lr",
    1e-5,
    1e-1,
    log=True
)
```

This produces values like:

```text
1e-5
2e-5
8e-5
1e-4
...
```

Typical parameters requiring log scaling:

| Parameter      | Range       |
| -------------- | ----------- |
| learning rate  | 1e-5 – 1e-1 |
| regularization | 1e-6 – 10   |
| kernel width   | 1e-3 – 10   |

---

# 3. Conditional Parameters

Sometimes parameters **only exist when other parameters take certain values**.

Example:

If model = **Random Forest**, then optimize:

* number of trees
* tree depth

If model = **SVM**, then optimize:

* kernel
* C parameter

Optuna supports this naturally through **define-by-run**.

Example:

```python
def objective(trial):

    model = trial.suggest_categorical(
        "model",
        ["rf", "svm"]
    )

    if model == "rf":
        n_trees = trial.suggest_int("n_trees", 50, 200)
        depth = trial.suggest_int("depth", 3, 10)

    else:
        C = trial.suggest_float("C", 1e-3, 10, log=True)
        kernel = trial.suggest_categorical(
            "kernel",
            ["linear", "rbf"]
        )
```

This creates **conditional branches in the search space**.

This structure is called **tree-structured search space**, which TPE handles very well.

---

# 4. Dynamic Search Spaces

Optuna allows **search spaces to change dynamically during optimization**.

Example:

Search range may depend on another parameter.

```python
n_layers = trial.suggest_int("n_layers", 1, 5)

for i in range(n_layers):

    units = trial.suggest_int(
        f"units_layer_{i}",
        32,
        256
    )
```

Here:

* the number of parameters depends on `n_layers`
* each trial may have different dimensionality

This flexibility is extremely useful for:

* neural architecture search
* algorithm configuration
* dynamic pipelines

---

# 5. Hierarchical Search Spaces

Hierarchical spaces represent **multi-level configuration structures**.

Example: model selection + hyperparameters.

```python
model = trial.suggest_categorical(
    "model",
    ["xgb", "rf", "svm"]
)
```

Then define model-specific parameters.

```python
if model == "xgb":

    max_depth = trial.suggest_int("max_depth", 3, 10)
    eta = trial.suggest_float("eta", 1e-3, 0.3, log=True)

elif model == "rf":

    n_estimators = trial.suggest_int("n_estimators", 50, 300)

elif model == "svm":

    C = trial.suggest_float("C", 1e-3, 10, log=True)
```

Hierarchical spaces are common in:

* AutoML systems
* pipeline optimization
* architecture search

---

# 6. Example — Neural Network Architecture Search

Optuna is often used for **neural architecture search**.

Example:

```python
def objective(trial):

    n_layers = trial.suggest_int("n_layers", 1, 4)

    layers = []

    for i in range(n_layers):

        units = trial.suggest_int(
            f"units_{i}",
            32,
            256
        )

        dropout = trial.suggest_float(
            f"dropout_{i}",
            0.0,
            0.5
        )

        layers.append((units, dropout))
```

Each trial produces a **different network architecture**.

This would be extremely difficult with traditional optimizers.

---

# 7. Example — Algorithm Configuration

Optuna can also optimize **algorithmic parameters**.

Example: tuning a numerical solver.

```python
solver = trial.suggest_categorical(
    "solver",
    ["gradient", "newton"]
)

if solver == "gradient":

    lr = trial.suggest_float("lr", 1e-4, 1e-1, log=True)

else:

    damping = trial.suggest_float("damping", 1e-3, 1)
```

This allows optimization of **entire algorithm configurations**.

---

# 8. Best Practices for Search Space Design

### Use Log Scales for Multiplicative Parameters

Bad:

```python
lr = trial.suggest_float("lr", 0.00001, 0.1)
```

Better:

```python
lr = trial.suggest_float("lr", 1e-5, 1e-1, log=True)
```

---

### Avoid Unreasonably Large Ranges

Bad:

```python
depth = trial.suggest_int("depth", 1, 1000)
```

Better:

```python
depth = trial.suggest_int("depth", 3, 15)
```

Large ranges slow down convergence.

---

### Use Domain Knowledge

Good search spaces reflect:

* theoretical constraints
* empirical knowledge
* practical limits

---

# Practical Exercise — Conditional Hyperparameter Optimization

Let’s implement a small example.

We will choose between **two models** and tune their parameters.

---

### Implementation

```python
import optuna
import numpy as np

def objective(trial):

    model = trial.suggest_categorical(
        "model",
        ["quadratic", "sin"]
    )

    x = trial.suggest_float("x", -5, 5)

    if model == "quadratic":

        y = (x - 2)**2

    else:

        y = np.sin(x) + 1

    return y


study = optuna.create_study(direction="minimize")

study.optimize(objective, n_trials=100)

print("Best parameters:", study.best_params)
print("Best value:", study.best_value)
```

This demonstrates:

* categorical parameter selection
* conditional objective computation
* flexible search spaces

---

# Key Takeaways

Effective search spaces include:

| Feature                | Why it matters                   |
| ---------------------- | -------------------------------- |
| Continuous parameters  | capture real-valued optimization |
| Discrete parameters    | model integer constraints        |
| Log distributions      | handle large magnitude ranges    |
| Conditional parameters | support complex models           |
| Dynamic spaces         | allow flexible architectures     |
| Hierarchical spaces    | enable AutoML workflows          |

Designing the search space properly can improve optimization **more than changing the optimizer itself**.

---

# Next Module

Next we move to:

# Module 7 — Samplers (Optimization Engines)

We will study the algorithms that actually **drive the optimization process**.

Topics include:

* **TPE sampler**
* **Random sampler**
* **CMA-ES**
* **Grid sampler**
* **NSGA-II (multi-objective)**

We will also compare **their strengths and weaknesses**.

---

Before continuing, one quick question:

Would you like me to also include **guidelines for detecting bad search spaces from optimization results** (a very useful real-world skill) in the next module?
