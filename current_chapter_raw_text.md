# Module 8 — Pruning (Early Stopping)

**Goal:** Learn how Optuna reduces wasted computation by **stopping unpromising trials early**.

In many optimization tasks (especially ML), evaluating a configuration requires **iterative computation**:

* neural network training
* gradient boosting
* simulation loops
* reinforcement learning

If a trial performs poorly early on, there is little reason to **continue training it fully**.

Optuna solves this using **pruning**.

---

# 1. Why Pruning Matters

Consider tuning a neural network:

| Epoch | Validation Loss |
| ----- | --------------- |
| 1     | 0.92            |
| 2     | 0.91            |
| 3     | 0.90            |

Another trial:

| Epoch | Validation Loss |
| ----- | --------------- |
| 1     | 1.40            |
| 2     | 1.35            |
| 3     | 1.31            |

The second configuration is clearly worse.

Without pruning:

* both models train **100 epochs**

With pruning:

* the bad trial is stopped early.

This saves:

* time
* compute
* GPU resources

Pruning is often the **biggest speedup** in hyperparameter optimization.

---

# 2. Intermediate Results

For pruning to work, the algorithm needs **progress updates** during training.

Optuna uses:

```python
trial.report(value, step)
```

Where:

* `value` → current metric (loss, accuracy, etc.)
* `step` → iteration number

Example:

```python
trial.report(validation_loss, epoch)
```

The pruner analyzes these intermediate results.

---

# 3. Pruning Decision

After reporting a value, we ask Optuna:

```python
trial.should_prune()
```

If the trial is performing poorly:

```python
raise optuna.TrialPruned()
```

Example training loop:

```python
for epoch in range(100):

    loss = train_one_epoch()

    trial.report(loss, epoch)

    if trial.should_prune():
        raise optuna.TrialPruned()
```

This stops the trial immediately.

---

# 4. Median Pruning

The **MedianPruner** is the simplest pruning strategy.

Idea:

Compare a trial's performance with the **median of previous trials**.

If the trial performs worse than the median at the same step, prune it.

Example:

| Trial | Epoch 5 Loss |
| ----- | ------------ |
| 1     | 0.70         |
| 2     | 0.65         |
| 3     | 0.75         |

Median:

[
0.70
]

If a new trial has:

[
loss = 0.90
]

It will likely be pruned.

---

## Advantages

* simple
* robust
* effective for many tasks

---

# 5. Successive Halving

Successive Halving is a **resource allocation algorithm**.

Basic idea:

1. Start many trials with small resources
2. Evaluate performance
3. Keep only the best fraction
4. Allocate more resources to survivors

Example:

| Stage | Trials | Epochs |
| ----- | ------ | ------ |
| 1     | 100    | 5      |
| 2     | 25     | 20     |
| 3     | 6      | 100    |

Most trials die early.

Only promising ones receive **full training**.

---

# 6. Hyperband

Hyperband improves successive halving by **running multiple halving schedules**.

Different schedules explore different trade-offs:

* many cheap trials
* fewer but longer trials

This makes Hyperband **more robust across problems**.

Conceptually:

```id="sazb98"
multiple successive-halving brackets
each bracket explores different resource allocations
best trials survive longer
```

Hyperband is one of the **most widely used pruning strategies**.

---

# 7. Asynchronous Pruning

In distributed optimization, trials run **in parallel**.

Waiting for synchronization would waste time.

Optuna supports **asynchronous pruning**.

Meaning:

* each trial is evaluated independently
* pruning decisions are made immediately

Advantages:

* better resource utilization
* efficient parallel execution

---

# 8. Pruners in Optuna

Optuna includes several pruners.

| Pruner                  | Strategy                   |
| ----------------------- | -------------------------- |
| MedianPruner            | median-based pruning       |
| SuccessiveHalvingPruner | multi-stage elimination    |
| HyperbandPruner         | multiple halving schedules |
| ThresholdPruner         | absolute thresholds        |
| NopPruner               | disables pruning           |

Example usage:

```python
pruner = optuna.pruners.MedianPruner()

study = optuna.create_study(
    direction="minimize",
    pruner=pruner
)
```

---

# 9. Integration with Training Loops

Pruning is particularly useful for **iterative algorithms**.

Example: neural network training.

```python
for epoch in range(50):

    train(model)

    val_loss = evaluate(model)

    trial.report(val_loss, epoch)

    if trial.should_prune():
        raise optuna.TrialPruned()
```

Important points:

* `report()` sends intermediate metrics
* `should_prune()` checks pruning condition
* `TrialPruned` stops the trial

---

# 10. Example — PyTorch Training with Pruning

Example structure:

```python
def objective(trial):

    lr = trial.suggest_float("lr", 1e-5, 1e-2, log=True)

    model = build_model()

    optimizer = torch.optim.Adam(model.parameters(), lr=lr)

    for epoch in range(20):

        train_epoch(model)

        val_loss = validate(model)

        trial.report(val_loss, epoch)

        if trial.should_prune():
            raise optuna.TrialPruned()

    return val_loss
```

This prevents wasting time on **bad hyperparameter configurations**.

---

# Practical Exercise — Pruning Deep Learning Training

Below is a simplified training loop with pruning.

```python
import optuna
import numpy as np


def objective(trial):

    lr = trial.suggest_float("lr", 1e-5, 1e-1, log=True)

    loss = 1.0

    for epoch in range(20):

        loss *= np.random.uniform(0.8, 1.1)

        trial.report(loss, epoch)

        if trial.should_prune():
            raise optuna.TrialPruned()

    return loss


study = optuna.create_study(
    direction="minimize",
    pruner=optuna.pruners.MedianPruner()
)

study.optimize(objective, n_trials=50)
```

Observe:

* many trials stop early
* only promising trials finish

This significantly **reduces computation time**.

---

# Key Takeaways

Pruning is a key Optuna feature that:

* stops bad trials early
* reduces computation cost
* accelerates optimization

Important components:

| Function               | Purpose                   |
| ---------------------- | ------------------------- |
| `trial.report()`       | send intermediate results |
| `trial.should_prune()` | check pruning condition   |
| `TrialPruned`          | terminate trial           |

Common pruning strategies:

| Pruner             | Best Use               |
| ------------------ | ---------------------- |
| Median             | simple, robust         |
| Successive Halving | resource allocation    |
| Hyperband          | adaptive multi-bracket |

Pruning is especially powerful in:

* deep learning
* boosting models
* iterative simulations

---

# Next Module

Next we move to:

# Module 9 — Advanced Optimization Techniques

Topics include:

* dynamic parameter spaces
* multi-objective optimization
* Pareto front analysis
* constrained optimization
* custom samplers and pruners

These techniques allow Optuna to handle **complex real-world optimization problems**.

---

Before continuing, a quick question:

Would you like the next module to also include a **visual explanation of Pareto fronts for multi-objective optimization**?
