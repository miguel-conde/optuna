Excellent — switching to **English**.
Since you asked for the **final and complete course syllabus**, I will present the full structure of the course before we start teaching the modules.

The course is designed for an **advanced practitioner** who already knows ML, Python, and classical hyperparameter search, but wants to **master Optuna as a general optimization framework**.

---

# Mini-Course: Optimization with Optuna

*A Practical and Theoretical Guide to Modern Black-Box Optimization*

## Course Level

Advanced

## Prerequisites

* Python programming
* Basic machine learning experience
* Familiarity with optimization concepts (grid search / random search)
* Basic probability and statistics

## Course Philosophy

This course teaches **Optuna not just as a hyperparameter tuning tool**, but as a **general black-box optimization framework** that can be used for:

* ML hyperparameter tuning
* mathematical function optimization
* simulation calibration
* engineering optimization
* experiment design

We will combine:

* theory (Bayesian optimization, TPE)
* implementation
* real-world workflows
* performance engineering

---

# Complete Course Syllabus

## Module 1 — Foundations of Modern Optimization

Goal: Understand the problem Optuna solves.

Topics:

* Formal definition of optimization
* Black-box optimization
* Curse of dimensionality
* Grid Search vs Random Search
* Sample efficiency
* Exploration vs exploitation
* When gradient-based methods fail
* Why Bayesian optimization works

Practical exercise:

* Implement random search for a toy function.

---

# Module 2 — Bayesian Optimization Fundamentals

Goal: Understand the theory behind modern hyperparameter optimization.

Topics:

* Surrogate models
* Gaussian Processes (conceptual overview)
* Acquisition functions
* Expected Improvement
* Upper Confidence Bound
* Probability of Improvement
* Limitations of GP optimization

Transition to TPE (Tree-structured Parzen Estimator).

Practical exercise:

* Visualizing acquisition functions.

---

# Module 3 — The TPE Algorithm (Core of Optuna)

Goal: Understand the algorithm Optuna actually uses.

Topics:

* Density estimation approach
* Splitting observations into good vs bad regions
* Modeling

[
p(x|y)
]

instead of

[
p(y|x)
]

* Likelihood ratio optimization
* Exploration vs exploitation in TPE
* Advantages over Gaussian Processes
* Scalability to high dimensions

Practical exercise:

* Implement a simplified TPE.

---

# Module 4 — Optuna Architecture

Goal: Understand how Optuna is structured internally.

Core concepts:

* Study
* Trial
* Objective function
* Search space
* Samplers
* Pruners
* Storage backends

Internal optimization loop.

Optuna execution lifecycle.

Practical exercise:

* Inspecting trial objects.

---

# Module 5 — Basic Optuna Usage

Goal: Use Optuna for standard optimization tasks.

Topics:

* Installation and setup
* Creating a study
* Defining objective functions
* Parameter suggestion API

Main APIs:

* `suggest_float`
* `suggest_int`
* `suggest_categorical`
* log-scaled parameters

Retrieving results:

* best trial
* best parameters
* best value

Practical exercise:

* Optimize a mathematical function.

---

# Module 6 — Designing Search Spaces

Goal: Design effective parameter spaces.

Topics:

* Continuous vs discrete spaces
* Log distributions
* Conditional parameters
* Dynamic search spaces
* Hierarchical spaces

Examples:

* neural network architecture search
* algorithm configuration

Practical exercise:

* Conditional hyperparameter optimization.

---

# Module 7 — Samplers (Optimization Engines)

Goal: Understand different optimization strategies in Optuna.

Samplers:

* TPE Sampler
* Random Sampler
* CMA-ES
* Grid Sampler
* NSGA-II (multi-objective)

Topics:

* when to use each sampler
* exploration behavior
* high-dimensional search

Practical exercise:

* comparing samplers.

---

# Module 8 — Pruning (Early Stopping)

Goal: Reduce wasted computation.

Topics:

* intermediate results
* early stopping strategies
* Median pruning
* Successive Halving
* Hyperband
* asynchronous pruning

Integration with training loops.

Practical exercise:

* pruning deep learning training.

---

# Module 9 — Advanced Optimization Techniques

Topics:

* dynamic parameter spaces
* multi-objective optimization
* Pareto fronts
* constrained optimization
* custom samplers
* custom pruners

Practical exercise:

* multi-objective optimization with NSGA-II.

---

# Module 10 — Optuna Visualization and Diagnostics

Goal: analyze optimization behavior.

Tools:

* optimization history
* parameter importance
* slice plots
* parallel coordinate plots
* contour plots

Diagnostics:

* detecting bad search spaces
* detecting parameter interactions

Practical exercise:

* diagnosing failed optimizations.

---

# Module 11 — Distributed and Scalable Optimization

Topics:

* parallel trials
* distributed workers
* RDB storage (PostgreSQL / SQLite)
* fault tolerance
* large-scale experiments

Practical exercise:

* distributed optimization example.

---

# Module 12 — Optuna for Machine Learning

Applications:

* scikit-learn pipelines
* XGBoost
* LightGBM
* PyTorch
* TensorFlow

Topics:

* nested cross-validation
* robust evaluation
* avoiding leakage
* reproducibility

Practical exercise:

* full ML hyperparameter optimization.

---

# Module 13 — Optuna for General Optimization

Using Optuna outside ML.

Examples:

* mathematical function optimization
* simulation parameter tuning
* physics simulations
* algorithm configuration
* reinforcement learning tuning

Practical exercise:

* optimize a complex non-convex function.

---

# Module 14 — Production Workflows

Topics:

* experiment tracking
* reproducibility
* study persistence
* experiment management
* integration with ML pipelines

Tools:

* Optuna dashboard
* experiment logging

---

# Module 15 — Final Project

Goal: Build a **complete optimization workflow**.

Project options:

### Option A — ML Pipeline Optimization

Optimize a full ML pipeline:

* preprocessing
* model choice
* hyperparameters

---

### Option B — Complex Function Optimization

Optimize a highly non-convex function such as:

* Rastrigin
* Ackley
* Rosenbrock

Compare:

* random search
* TPE
* CMA-ES

---

### Option C — Simulation Optimization

Tune parameters of a simulated system.

Example:

* Monte Carlo simulation
* financial model
* control system

---

# Learning Outcomes

By the end of the course you will:

* Understand **Bayesian optimization**
* Understand **TPE mathematically**
* Master **Optuna’s architecture**
* Design **effective search spaces**
* Use **advanced samplers and pruning**
* Run **large-scale distributed optimization**
* Apply Optuna to **general optimization problems**

---

✅ If this syllabus looks good, we will start **Module 1: Foundations of Modern Optimization**.

Before we begin, one quick question:

Would you also like me to include a **section on the mathematics behind density estimation in TPE (KDE, Parzen windows)**?
That would make the course **even deeper mathematically**, which might fit your advanced level.
