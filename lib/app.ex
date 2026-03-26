defmodule Tasks.App do
  use Application

  def start(_type, _args) do
    IO.puts("Task to do:")
    tasks = [
    Tasks.Task.new(1, "going on the moon") |> Tasks.Task.complete(),
    Tasks.Task.new(3, "Create a rocket") |> Tasks.Task.complete(),
    Tasks.Task.new(2, "Going back from the moom"),
    Tasks.Task.new(3, "Take a selfy"),
    Tasks.Task.new(1, "Build a lab on the moon") |> Tasks.Task.complete(),
    Tasks.Task.new(2, "Pick up some rocks"),
    Tasks.Task.new(1, "Tidy up the rocket") |> Tasks.Task.complete(),
    Tasks.Task.new(3, "Look at earth"),
    ]
    |> Enum.filter(fn task -> task.done != true end)
    |> Enum.sort(fn task1, task2 -> task1.priority < task2.priority end)
    |> Enum.map(&("   -> " <> &1.name))
    |> Enum.reduce(&(&2 <> "\n"<> &1))
    IO.puts(tasks)
    {:ok, self()}
  end
end
