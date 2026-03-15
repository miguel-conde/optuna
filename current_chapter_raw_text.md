# Module 4 — Optuna Architecture

**Goal:** Understand how Optuna is structured internally and how its components interact during an optimization process.

At its core, Optuna implements a **general optimization engine** that coordinates:

* the optimization problem
* the search strategy
* experiment tracking
* pruning strategies
* storage and parallelization

Understanding this architecture is critical for using Optuna **correctly and efficiently**.

---

# 1. Core Architecture Overview

An Optuna optimization consists of several interacting components:

```
Study
 ├── Trials
 │     ├── Parameters
 │     ├── Objective value
 │     └── Intermediate results
 │
 ├── Sampler (suggest parameters)
 ├── Pruner (stop bad trials early)
 └── Storage (persist experiments)
```

The **Study** is the central object managing the optimization process.

---

# 2. Study

A **Study** represents a complete optimization experiment.

It manages:

* all trials
* the sampler
* the pruner
* the storage backend
* the optimization direction

Example:

```python
import optuna

study = optuna.create_study(direction="minimize")
```

Key responsibilities of a Study:

* schedule trials
* collect results
* determine the best trial
* coordinate samplers and pruners

You can think of a Study as:

> the **experiment manager**.

---

## Important Study Methods

Run optimization:

```python
study.optimize(objective, n_trials=100)
```

Access best result:

```python
study.best_params
study.best_value
study.best_trial
```

List trials:

```python
study.trials
```

---

# 3. Trial

A **Trial** represents **one evaluation of the objective function**.

Each trial contains:

* parameter values
* objective value
* intermediate results
* state (completed, pruned, failed)

During optimization:

```
Trial 1 → parameters → objective → result
Trial 2 → parameters → objective → result
Trial 3 → parameters → objective → result
```

Trials are created and managed automatically by the Study.

---

## Trial Lifecycle

```
CREATED
  ↓
RUNNING
  ↓
COMPLETE / PRUNED / FAILED
```

Possible states:

| State    | Meaning                |
| -------- | ---------------------- |
| COMPLETE | finished successfully  |
| PRUNED   | stopped early          |
| FAILED   | error during execution |

---

# 4. Objective Function

The **objective function** defines the problem being optimized.

It receives a **Trial object** and returns a value.

Example:

```python
def objective(trial):

    x = trial.suggest_float("x", -10, 10)

    return (x - 2)**2
```

Inside the objective function we:

1. define the search space
2. compute the objective value
3. return the result

The returned value becomes the **trial value**.

---

# 5. Search Space

The **search space** defines the parameters to be optimized.

Optuna uses a **define-by-run** approach.

Instead of defining the space beforehand, we define it **during execution**.

Example:

```python
x = trial.suggest_float("x", -5, 5)
```

Other parameter types:

```python
trial.suggest_int("depth", 3, 10)

trial.suggest_categorical("optimizer", ["adam", "sgd"])

trial.suggest_float("lr", 1e-5, 1e-1, log=True)
```

Advantages of define-by-run:

* dynamic search spaces
* conditional parameters
* flexible modeling

Example:

```python
model = trial.suggest_categorical("model", ["svm","rf"])

if model == "rf":
    depth = trial.suggest_int("depth", 3, 10)
```

This creates a **tree-structured search space**, which is exactly what **TPE handles well**.

---

# 6. Samplers

The **Sampler** determines **how parameters are chosen**.

Samplers implement the optimization algorithm.

Examples:

| Sampler       | Method                |
| ------------- | --------------------- |
| TPESampler    | Bayesian optimization |
| RandomSampler | random search         |
| CmaEsSampler  | evolutionary strategy |
| GridSampler   | exhaustive search     |

Example:

```python
study = optuna.create_study(
    sampler=optuna.samplers.TPESampler()
)
```

Default sampler:

**TPE**.

Samplers operate using information from **previous trials**.

---

# 7. Pruners

Pruners implement **early stopping**.

They terminate trials that are unlikely to produce good results.

This is crucial when evaluations are expensive.

Example use cases:

* deep learning training
* boosting models
* iterative simulations

Pruners rely on **intermediate results**.

Example training loop:

```python
for epoch in range(100):

    loss = train_model()

    trial.report(loss, epoch)

    if trial.should_prune():
        raise optuna.TrialPruned()
```

Popular pruners:

| Pruner                  | Strategy                      |
| ----------------------- | ----------------------------- |
| MedianPruner            | stop trials worse than median |
| SuccessiveHalvingPruner | resource allocation           |
| HyperbandPruner         | multi-bracket strategy        |

We will study pruning in depth later.

---

# 8. Storage Backends

Optuna supports persistent experiment storage.

This enables:

* experiment tracking
* parallel optimization
* fault tolerance

Available storage options:

### In-memory (default)

```python
study = optuna.create_study()
```

Not persistent.

---

### SQLite

```python
study = optuna.create_study(
    storage="sqlite:///example.db"
)
```

Trials are saved to a database.

---

### PostgreSQL / MySQL

Used for **distributed optimization**.

Example:

```python
storage="postgresql://user:pass@host/db"
```

This allows multiple workers to run trials simultaneously.

---

# 9. Internal Optimization Loop

Optuna executes the following loop:

```
while trials_remaining:

    sampler → propose parameters

    trial → run objective

    record result

    pruner → check early stopping

    update sampler
```

Detailed flow:

```
Study starts
   ↓
Sampler suggests parameters
   ↓
Trial object created
   ↓
Objective function executed
   ↓
Intermediate results reported
   ↓
Pruner may stop trial
   ↓
Result stored
   ↓
Sampler updates model
```

This loop repeats until:

* `n_trials` reached
* timeout reached
* manual stop

---

# 10. Optuna Execution Lifecycle

Full lifecycle of an experiment:

```
1 create study
2 start optimization
3 run trials
4 sampler updates strategy
5 pruner removes weak trials
6 results stored
7 best parameters returned
```

Minimal working example:

```python
import optuna

def objective(trial):

    x = trial.suggest_float("x", -5, 5)

    return (x-2)**2

study = optuna.create_study(direction="minimize")

study.optimize(objective, n_trials=50)

print(study.best_params)
```

This code executes the **entire architecture**.

---

# Practical Exercise — Inspecting Trial Objects

Let’s inspect the data stored inside trials.

Example:

```python
for t in study.trials:
    print("Trial:", t.number)
    print("Params:", t.params)
    print("Value:", t.value)
    print("State:", t.state)
    print()
```

You can also inspect a specific trial:

```python
trial = study.trials[0]

trial.params
trial.value
trial.distributions
trial.datetime_start
trial.datetime_complete
```

This information is essential for:

* debugging experiments
* analyzing optimization behavior
* building dashboards

---

# Key Takeaways

Optuna’s architecture consists of several core components:

| Component    | Role                                |
| ------------ | ----------------------------------- |
| Study        | manages the optimization experiment |
| Trial        | single evaluation of the objective  |
| Objective    | defines the optimization problem    |
| Search space | defines parameters                  |
| Sampler      | proposes parameters                 |
| Pruner       | stops bad trials early              |
| Storage      | saves experiment data               |

The optimization process follows an **iterative feedback loop** between:

* sampler
* objective evaluation
* pruner
* storage

---

# Next Module

Next we move to:

# Module 5 — Basic Optuna Usage

We will cover:

* creating studies
* defining search spaces
* retrieving results
* first real optimization workflows

This is where we start building **real Optuna optimization pipelines**.

---

Before continuing, one quick check:

1️⃣ Is the **architecture and component interaction** clear?

2️⃣ Would you like me to also show **how Optuna internally stores parameter distributions** before moving to the next module?
