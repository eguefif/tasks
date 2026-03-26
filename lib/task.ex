defmodule Tasks.Task do
  @enforce_keys [:priority, :name]
  defstruct priority: 3, name: "", due: true, done: false

  def complete(task) when task.done == false do
    %{task | done: true} 
  end

  def new(priority, name) do
    %Tasks.Task{priority: priority, name: name}
  end

end
