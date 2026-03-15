# Module 5 — Basic Optuna Usage

**Goal:** Learn how to use Optuna to solve real optimization problems.

In this module we move from **theory and architecture** to **practical usage**.
You will learn how to:

* create optimization studies
* define objective functions
* define parameter search spaces
* run optimization
* inspect results

---

# 1. Installation and Setup

Optuna is easy to install via **pip**.

```bash
pip install optuna
```

Verify the installation:

```python
import optuna
print(optuna.__version__)
```

Optional packages (useful later):

```bash
pip install optuna-dashboard
pip install plotly
```

These enable:

* visualization tools
* experiment dashboards

---

# 2. Creating a Study

The **Study** object manages the entire optimization process.

Basic example:

```python
import optuna

study = optuna.create_study(direction="minimize")
```

Key parameter:

| Parameter   | Meaning                      |
| ----------- | ---------------------------- |
| `direction` | `"minimize"` or `"maximize"` |

Examples:

Minimize loss:

```python
study = optuna.create_study(direction="minimize")
```

Maximize accuracy:

```python
study = optuna.create_study(direction="maximize")
```

---

# 3. Defining the Objective Function

The **objective function** defines the problem.

It receives a **Trial object** and returns a numeric value.

Example:

```python
def objective(trial):

    x = trial.suggest_float("x", -10, 10)

    return (x - 2)**2
```

Inside the function:

1. parameters are suggested
2. the model or function is evaluated
3. a scalar value is returned

Optuna minimizes or maximizes this value.

---

# 4. Running the Optimization

Once the study and objective function are defined:

```python
study.optimize(objective, n_trials=100)
```

Parameters:

| Parameter   | Meaning               |
| ----------- | --------------------- |
| `objective` | function to optimize  |
| `n_trials`  | number of evaluations |

Each trial corresponds to **one evaluation of the objective function**.

Example optimization flow:

```
Trial 1 → parameters → objective value
Trial 2 → parameters → objective value
Trial 3 → parameters → objective value
...
```

The sampler learns from previous trials.

---

# 5. Parameter Suggestion API

Parameters are defined inside the objective using **suggestion functions**.

This is the **define-by-run** paradigm.

---

## `suggest_float`

Continuous parameter.

```python
x = trial.suggest_float("x", -10, 10)
```

Uniform sampling between bounds.

---

## Log-scaled floats

Used for parameters spanning several orders of magnitude.

Example: learning rates.

```python
lr = trial.suggest_float("lr", 1e-5, 1e-1, log=True)
```

This samples values like:

```
1e-5
3e-5
1e-4
5e-4
...
```

instead of uniform spacing.

---

## `suggest_int`

Integer parameters.

```python
depth = trial.suggest_int("depth", 2, 10)
```

Example use cases:

* tree depth
* number of layers
* number of neighbors

---

## `suggest_categorical`

Discrete choices.

```python
optimizer = trial.suggest_categorical(
    "optimizer",
    ["adam", "sgd", "rmsprop"]
)
```

Common uses:

* model type
* optimizer
* activation functions

---

# 6. Example with Multiple Parameters

Example objective function with several parameters.

```python
def objective(trial):

    x = trial.suggest_float("x", -10, 10)
    y = trial.suggest_float("y", -10, 10)

    return (x - 2)**2 + (y + 3)**2
```

This searches a **2D parameter space**.

---

# 7. Retrieving Optimization Results

After optimization, Optuna stores all results.

---

## Best Value

```python
study.best_value
```

The best objective value found.

---

## Best Parameters

```python
study.best_params
```

Example output:

```
{'x': 1.98, 'y': -2.97}
```

---

## Best Trial

```python
study.best_trial
```

Contains full information:

* parameters
* objective value
* trial metadata

Example:

```python
best = study.best_trial

print(best.params)
print(best.value)
```

---

# 8. Inspecting All Trials

To analyze optimization behavior:

```python
for trial in study.trials:
    print(trial.number, trial.value, trial.params)
```

Useful for:

* debugging
* visualization
* experiment tracking

---

# 9. Complete Minimal Example

```python
import optuna

def objective(trial):

    x = trial.suggest_float("x", -10, 10)

    return (x - 2)**2

study = optuna.create_study(direction="minimize")

study.optimize(objective, n_trials=50)

print("Best value:", study.best_value)
print("Best parameters:", study.best_params)
```

This is the **simplest Optuna optimization workflow**.

---

# Practical Exercise — Optimize a Mathematical Function

Let's optimize a non-trivial function:

[
f(x) = (x-3)^2 + \sin(5x)
]

---

### Implementation

```python
import optuna
import numpy as np

def objective(trial):

    x = trial.suggest_float("x", -5, 5)

    y = (x - 3)**2 + np.sin(5*x)

    return y

study = optuna.create_study(direction="minimize")

study.optimize(objective, n_trials=100)

print("Best x:", study.best_params)
print("Best value:", study.best_value)
```

---

### What to Observe

During optimization:

* early trials explore broadly
* later trials focus near good regions
* the sampler learns promising areas

This demonstrates **adaptive optimization**.

---

# Key Takeaways

Basic Optuna usage consists of five steps:

1️⃣ Install Optuna
2️⃣ Create a study
3️⃣ Define the objective function
4️⃣ Use `trial.suggest_*` to define parameters
5️⃣ Run optimization with `study.optimize()`

Core APIs:

| Function              | Purpose               |
| --------------------- | --------------------- |
| `suggest_float`       | continuous parameters |
| `suggest_int`         | integer parameters    |
| `suggest_categorical` | discrete choices      |

Results are accessed via:

* `study.best_value`
* `study.best_params`
* `study.best_trial`

---

# Next Module

Next we move to:

# Module 6 — Designing Search Spaces

This is one of the **most important skills in optimization**.

We will cover:

* continuous vs discrete spaces
* log distributions
* conditional parameters
* hierarchical search spaces
* dynamic parameter definitions

Designing a **good search space** often matters more than the optimizer itself.

---

Before moving on:

Would you like me to also show **how to visualize the optimization history in Optuna** before the next module?
