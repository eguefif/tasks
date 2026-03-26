defmodule Tasks.Task do
  use Agent

  @enforce_keys [:priority, :name]
  defstruct priority: 3, name: "", due: true, done: false

  def complete(task) when task.done == false do
    %{task | done: true} 
  end

  def new(priority, name) do
    %Tasks.Task{priority: priority, name: name}
  end

  def start_link(opts) do
    Agent.start_link(fn -> %{:last_id => 0, :tasks => %{}} end, opts)
  end

  def get(task_store, id) do
    Agent.get(task_store, fn data -> Map.get(data.tasks, id) end) 
  end

  def add_task(bucket, priority, task_name) do
    last_id = Agent.get(bucket, fn data -> data.last_id end)
    new_id = last_id + 1
    Agent.update(bucket, fn data -> 
    %{:last_id => new_id, :tasks => Map.put(data.tasks, new_id, new(priority, task_name))} end)

    new_id
  end

  def complete(task_store, id) do
    Agent.update(task_store, fn data ->
      %{data | :tasks => Map.update!(data.tasks, id, fn task -> 
      %{task | done: true}
      end) }
    end)
  end
  
  def all(task_store) do
    tasks = Agent.get(task_store, fn data -> data.tasks end)
    Map.to_list(tasks)
    |> Enum.map(fn task -> elem(task, 1) end)
  end
end
