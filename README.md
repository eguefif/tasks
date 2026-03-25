# Taskr — an Elixir learning project (Generated with Claude)

> A minimal CLI task manager built step by step to learn the core of the Elixir language and the OTP framework.

---

## What is this?

Taskr is a small command-line task manager you build yourself. You can add tasks, list them by priority, mark them as done, and get periodic reminders — all powered by Elixir processes running under a supervision tree.

The project is intentionally simple. The goal is not to ship a product, it is to touch every major concept of Elixir in a realistic, connected context. Each step has a single responsibility and a concrete checkpoint so you always know when you are done.

By the end you will have built:

- A struct-based data model with validation
- A stateful GenServer acting as an in-memory store
- A supervision tree that restarts crashed processes automatically
- A runnable CLI binary built with `mix escript.build`

No database, no web framework, no external dependencies. Just Elixir.

---

## Prerequisites

- Elixir 1.15+ and Erlang/OTP 26+
- Basic familiarity with functional programming concepts
- `iex` and `mix` available in your terminal

---

## Project structure

```
taskr/
├── lib/
│   ├── taskr/
│   │   ├── helpers.ex       # Step 3 — first module
│   │   ├── task.ex          # Step 8 — struct + validation
│   │   ├── task_store.ex    # Step 10 — GenServer state
│   │   ├── supervisor.ex    # Step 11 — supervision tree
│   │   └── cli.ex           # Step 12 — escript entry point
│   └── taskr.ex             # Application module
├── test/
│   └── taskr_test.exs
└── mix.exs
```

---

## Phase 1 — Syntax and data types

### Step 1 — Play with basic types in iex

**Goal:** Open `iex` and experiment with every primitive type: integers, floats, strings (double-quoted), charlists (single-quoted), atoms, booleans, and nil. Try arithmetic, string concatenation with `<>`, and check types with `is_atom/1`, `is_binary/1` and friends. Notice that atoms are not strings.

**Checkpoint:** You can explain the difference between a string, a charlist, and an atom without looking it up.

**Concepts:** `integer`, `float`, `string`, `atom`, `:ok / :error`, `boolean`, `nil`, `<>`, `is_atom/1`

---

### Step 2 — Explore the core data structures

**Goal:** Create and manipulate each main collection type in `iex`. Pattern match on a tuple to extract values. Use list functions like `hd/1`, `tl/1`, and `++`. Create a map with `%{}` and access keys with dot notation and `Map.get/2`. Understand when you would use a keyword list over a map.

**Checkpoint:** You can pattern match `{:ok, value} = {:ok, 42}` and explain why maps are unordered while keyword lists preserve order.

**Concepts:** `tuple`, `list`, `map`, `keyword list`, `hd/tl`, `++`, `Map.get`, pattern matching

---

### Step 3 — Write your first module and functions

**Goal:** Create `lib/taskr/helpers.ex` with a module. Write a public function that takes a string and returns it uppercased with a prefix, and a private helper it calls internally. Call both from `iex` with the full module name. Understand arity notation (`name/n`).

**Checkpoint:** `Taskr.Helpers.greet("Alice")` works in `iex`. Calling the private function directly raises an `UndefinedFunctionError`.

**Concepts:** `defmodule`, `def`, `defp`, arity, `@moduledoc`, `iex` recompile

---

## Phase 2 — Pattern matching and control flow

### Step 4 — Master pattern matching

**Goal:** Practice pattern matching beyond simple assignment: destructure a nested map, match on the head and tail of a list, match on a specific key inside a map, and use the pin operator `^` to assert a value rather than rebind it. Try a match that fails and read the `MatchError`.

**Checkpoint:** You can write `%{name: name, role: :admin} = user` and extract `name` in one line, and you understand why `^x = 5` is different from `x = 5`.

**Concepts:** `=` operator, destructuring, `^` pin operator, `MatchError`, `_` wildcard, nested matching

---

### Step 5 — Control flow: case, cond, and if

**Goal:** Write a function that takes a task priority and returns a string label using `case`. Then rewrite it with `cond` to see the difference. Use `if`/`unless` for a simple boolean check. Notice that in Elixir, `if` is an expression that returns a value, not a statement.

**Checkpoint:** You can articulate when to use `case` vs `cond`: `case` matches on a specific value's shape, `cond` evaluates independent boolean conditions.

**Concepts:** `case`, `cond`, `if / unless`, pattern matching in `case`, expressions vs statements

---

### Step 6 — Multi-clause functions and guards

**Goal:** Rewrite your priority function from the previous step using multiple function clauses instead of `case`. Add a guard with `when` to validate the input. Write a function that handles `:ok`/`:error` tuples using clauses. Feel how the runtime picks the right clause top to bottom.

**Checkpoint:** You have a 3-clause function where each clause matches a different atom, and a guard that raises `FunctionClauseError` on invalid input.

**Concepts:** multi-clause functions, guards, `when`, `FunctionClauseError`, function head matching

---

## Phase 3 — Functional programming

### Step 7 — The pipe operator and Enum

**Goal:** Create a list of 10 fake tasks as plain maps (no struct yet). Write a pipeline using `|>` that filters out done tasks, sorts by priority, and formats each one as a string. Use `Enum.map`, `Enum.filter`, `Enum.sort_by`, and `Enum.reduce`. Rewrite one step using the `&` capture shorthand.

**Checkpoint:** You have a single pipeline from raw list to formatted output with no intermediate variables, and you understand why `& &1.priority` is equivalent to `fn t -> t.priority end`.

**Concepts:** `|>` pipe, `Enum.map`, `Enum.filter`, `Enum.reduce`, `Enum.sort_by`, anonymous functions, `&` capture, `Enum.each`

---

### Step 8 — Define the Task struct

**Goal:** Create the `Taskr.Task` module with a struct: `id`, `title`, `priority`, `due`, and `done`. Add `@enforce_keys` for required fields. Write a `new/2` constructor with a guard on priority. Write a `complete/1` function that uses the map update syntax `%{task | done: true}` to return a modified copy.

**Checkpoint:** Creating a task without a title raises an `ArgumentError`. Calling `complete/1` returns a new struct with `done: true` without mutating the original.

**Concepts:** `defstruct`, `@enforce_keys`, struct update syntax, immutability, guards on constructors

---

### Step 9 — Modules as a toolbelt: String, Map, List

**Goal:** Spend time in `iex` with the three most useful standard library modules. With `String`: `split`, `trim`, `contains?`, `downcase`, and interpolation. With `Map`: `keys`, `values`, `put`, `delete`, `merge`, and `update`. With `List`: `flatten`, `uniq`, `zip`, and `first`. Write a small function that uses at least one from each.

**Checkpoint:** You can parse a raw input string into a structured map in a single pipeline using `String` and `Map` functions.

**Concepts:** `String.split`, `String.trim`, `Map.put`, `Map.merge`, `Map.update`, `List.first`, string interpolation `#{}`

---

## Phase 4 — OTP

### Step 10 — Store tasks with a GenServer

**Goal:** Build a `TaskStore` GenServer that holds a list of `Task` structs as its state. Implement three public API functions: `add/1` (cast — fire and forget), `all/0` (call — returns the list), and `complete/1` (cast — marks a task done by id using the pin operator).

**Checkpoint:** In `iex` you can start the GenServer, add two tasks, complete one, and call `all/0` to see the updated list.

**Concepts:** `GenServer`, `use GenServer`, `handle_call`, `handle_cast`, cast vs call, named process, `init/1`

---

### Step 11 — Supervise your processes

**Goal:** Create a `Supervisor` module that starts `TaskStore` as a child and wire it into your `Application` so it launches on startup. Crash `TaskStore` deliberately with `Process.exit/2` and watch the supervisor restart it automatically.

**Checkpoint:** After crashing `TaskStore` it restarts within a second and `all/0` returns an empty list again.

**Concepts:** `Supervisor`, `use Supervisor`, `child_spec`, `:one_for_one`, restart strategies, `Application`, `Process.exit`

---

### Step 12 — Build the CLI entry point

**Goal:** Write a `CLI` module with a `main/1` function for escript. Use multi-clause functions to dispatch commands: `add`, `list`, `done`, and `help`. Print tasks with `IO.puts`. Configure `mix.exs` for escript and build the binary with `mix escript.build`.

**Checkpoint:** You can run `./taskr add "Buy milk" high`, then `./taskr list` and see the task printed with its priority.

**Concepts:** `escript`, `IO.puts`, `System.argv`, `mix escript.build`, multi-clause dispatch

---

## Concepts covered

| Concept | Where |
|---|---|
| Primitive types, atoms, strings | Step 1 |
| Tuples, lists, maps, keyword lists | Step 2 |
| `defmodule`, `def`, `defp`, arity | Step 3 |
| Pattern matching, pin operator | Step 4 |
| `case`, `cond`, `if` | Step 5 |
| Multi-clause functions, guards | Step 6 |
| Pipe operator, `Enum` | Step 7 |
| `defstruct`, `@enforce_keys`, immutability | Step 8 |
| `String`, `Map`, `List` stdlib | Step 9 |
| `GenServer`, call vs cast | Step 10 |
| OTP supervision tree | Step 11 |
| `escript`, CLI dispatch | Step 12 |

---

## Bonus challenges

Once all twelve steps are done, push further:

- **Protocol** — implement a custom `Printable` protocol for `Taskr.Task` and use it in the CLI
- **Agent** — rewrite `TaskStore` using `Agent` first to feel the tradeoff, then move back to `GenServer`
- **Stream** — replace `Enum.filter` with `Stream.filter` for lazy evaluation and measure the difference
- **Task** — add fire-and-forget notifications using `Task.start` when a task is added
- **ETS** — swap the in-memory list in `TaskStore` for an ETS table so data survives process restarts
- **ExUnit** — write tests for `Task.new/2`, the priority guard, and the sorting logic
- **Scheduler** — add a `GenServer` that uses `Process.send_after` to print periodic reminders
