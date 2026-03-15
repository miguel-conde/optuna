# Module 7 — Samplers (Optimization Engines)

**Goal:** Understand the algorithms that actually **choose parameter values** during optimization.

In Optuna, the **Sampler** is the component responsible for generating new candidate parameters for each trial.

Conceptually:

```
Sampler → proposes parameters
Trial → evaluates objective
Sampler → updates model
```

Different samplers implement different **optimization strategies**.

---

# 1. What a Sampler Does

Each trial follows this process:

```
1 sampler proposes parameters
2 objective function evaluates them
3 result is stored
4 sampler learns from results
```

Example interaction:

```
Trial 1 → sampler proposes random parameters
Trial 2 → sampler proposes new parameters
Trial 10 → sampler focuses near good regions
```

The sampler decides **how exploration and exploitation are balanced**.

---

# 2. TPE Sampler (Default)

Optuna’s default optimizer is **TPE (Tree-structured Parzen Estimator)**.

It is a **Bayesian optimization method based on density estimation**.

Instead of modeling:

[
p(y|x)
]

TPE models:

[
p(x|y)
]

Key idea:

```
good trials → build density l(x)
bad trials → build density g(x)
maximize l(x)/g(x)
```

---

## Characteristics

| Property            | Behavior              |
| ------------------- | --------------------- |
| Type                | Bayesian optimization |
| Exploration         | adaptive              |
| Scalability         | good                  |
| Categorical support | excellent             |
| High dimensionality | good                  |

---

## When to Use TPE

Use TPE for:

* ML hyperparameter tuning
* mixed parameter spaces
* categorical parameters
* conditional spaces

Typical example:

```
model selection
learning rate tuning
architecture search
```

TPE is the **general-purpose optimizer** in Optuna.

---

# 3. Random Sampler

The **RandomSampler** performs pure random search.

Parameters are sampled independently from the search space.

Example:

```python
sampler = optuna.samplers.RandomSampler()

study = optuna.create_study(
    sampler=sampler
)
```

---

## Characteristics

| Property     | Behavior      |
| ------------ | ------------- |
| Type         | random search |
| Exploration  | maximum       |
| Exploitation | none          |
| Complexity   | minimal       |

---

## When to Use Random Sampling

Useful for:

* baseline comparisons
* early exploration
* debugging optimization pipelines
* small parameter spaces

Random search is surprisingly effective in **very high-dimensional spaces**.

However, it does **not learn from previous trials**.

---

# 4. CMA-ES Sampler

CMA-ES stands for:

**Covariance Matrix Adaptation Evolution Strategy**

It is an **evolutionary optimization algorithm**.

Instead of modeling densities, it maintains a **multivariate Gaussian distribution** over parameters.

Parameters are updated based on:

* mean vector
* covariance matrix

The covariance matrix learns **parameter correlations**.

---

## CMA-ES Update Concept

Each generation:

```
sample population
evaluate objective
select best individuals
update distribution
```

This adapts the **shape of the search distribution**.

---

## Characteristics

| Property             | Behavior              |
| -------------------- | --------------------- |
| Type                 | evolutionary strategy |
| Exploration          | adaptive              |
| Handles correlations | very well             |
| Continuous spaces    | excellent             |

---

## When to Use CMA-ES

CMA-ES works well for:

* continuous parameters
* medium-dimensional spaces
* expensive objective functions
* smooth landscapes

Example:

```
physics simulation calibration
numerical optimization
continuous ML hyperparameters
```

Limitations:

* does **not handle categorical variables well**
* slower initialization phase

---

# 5. Grid Sampler

GridSampler performs **exhaustive search** over a predefined grid.

Example:

```python
search_space = {
    "x": [-2, 0, 2],
    "y": [-1, 1]
}

sampler = optuna.samplers.GridSampler(search_space)
```

This evaluates **all combinations**.

---

## Characteristics

| Property    | Behavior          |
| ----------- | ----------------- |
| Type        | exhaustive search |
| Exploration | deterministic     |
| Learning    | none              |

---

## When to Use Grid Sampling

Useful when:

* search space is very small
* reproducibility is critical
* benchmarking algorithms

Grid search becomes impractical when the number of parameters increases.

---

# 6. NSGA-II Sampler (Multi-objective Optimization)

NSGA-II is used for **multi-objective optimization**.

Instead of optimizing one objective:

[
f(x)
]

we optimize multiple:

[
f_1(x), f_2(x)
]

Example:

* maximize accuracy
* minimize model size

---

## Pareto Optimality

In multi-objective optimization we search for the **Pareto frontier**.

A solution is Pareto optimal if:

* no objective can improve
* without worsening another

Example:

```
Model A → high accuracy, large size
Model B → lower accuracy, smaller size
```

Both may belong to the **Pareto frontier**.

---

## Characteristics

| Property    | Behavior                     |
| ----------- | ---------------------------- |
| Type        | evolutionary multi-objective |
| Output      | Pareto set                   |
| Exploration | population-based             |

---

## Example

```python
study = optuna.create_study(
    directions=["minimize","maximize"],
    sampler=optuna.samplers.NSGAIISampler()
)
```

This allows optimization of multiple objectives simultaneously.

---

# 7. Exploration Behavior of Samplers

Different samplers explore the search space differently.

| Sampler | Exploration Strategy           |
| ------- | ------------------------------ |
| Random  | uniform sampling               |
| TPE     | probabilistic density modeling |
| CMA-ES  | adaptive Gaussian search       |
| Grid    | deterministic enumeration      |
| NSGA-II | evolutionary population        |

Exploration strategies influence:

* convergence speed
* robustness
* sample efficiency

---

# 8. Samplers in High-Dimensional Spaces

High-dimensional optimization is difficult because:

[
Volume \propto k^d
]

As dimension increases:

* search space explodes
* exploration becomes harder

Performance comparison:

| Sampler | High-dim performance |
| ------- | -------------------- |
| Random  | moderate             |
| TPE     | good                 |
| CMA-ES  | moderate             |
| Grid    | poor                 |

TPE often performs best in:

```
20–100 parameters
mixed parameter types
```

This explains why it is the **default sampler in Optuna**.

---

# 9. Selecting the Right Sampler

General guidelines:

| Situation                     | Recommended Sampler |
| ----------------------------- | ------------------- |
| general hyperparameter tuning | TPE                 |
| baseline comparison           | Random              |
| continuous optimization       | CMA-ES              |
| small search space            | Grid                |
| multi-objective problems      | NSGA-II             |

In practice:

> **Start with TPE unless you have a strong reason not to.**

---

# Practical Exercise — Comparing Samplers

Let’s compare **Random Search vs TPE**.

Objective function:

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

    return (x - 3)**2 + np.sin(5*x)


# TPE sampler
study_tpe = optuna.create_study(
    sampler=optuna.samplers.TPESampler(),
    direction="minimize"
)

study_tpe.optimize(objective, n_trials=100)


# Random sampler
study_random = optuna.create_study(
    sampler=optuna.samplers.RandomSampler(),
    direction="minimize"
)

study_random.optimize(objective, n_trials=100)


print("TPE best:", study_tpe.best_value)
print("Random best:", study_random.best_value)
```

---

### What to Observe

Typically:

* early trials behave similarly
* TPE converges faster
* random search continues exploring

This illustrates **adaptive optimization**.

---

# Key Takeaways

Samplers determine **how parameters are chosen**.

| Sampler | Best For                      |
| ------- | ----------------------------- |
| TPE     | general hyperparameter tuning |
| Random  | baseline or exploration       |
| CMA-ES  | continuous optimization       |
| Grid    | small discrete spaces         |
| NSGA-II | multi-objective optimization  |

TPE is the default because it:

* balances exploration/exploitation
* scales well to high dimensions
* handles categorical parameters

---

# Next Module

Next we move to:

# Module 8 — Pruning (Early Stopping)

One of Optuna’s most powerful features.

We will learn:

* how to stop bad trials early
* how pruning saves huge amounts of compute
* pruning algorithms:

  * Median pruning
  * Successive Halving
  * Hyperband

This is **critical when optimizing expensive models like deep learning**.

---

Before continuing, quick check:

Would you like me to also include a **real-world benchmark showing TPE vs Random vs CMA-ES convergence behavior** in the next module?
