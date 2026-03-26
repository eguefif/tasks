defmodule Tasks.App do
  use Application

  def start(_type, _args) do
    {:ok, _} = Tasks.Task.start_link(name: :task_store)
    id = Tasks.Task.add_task(:task_store, 1, "Going to the moon")
    Tasks.Task.complete(:task_store, id)

    Tasks.Task.add_task(:task_store, 3, "Come back")
    Tasks.Task.add_task(:task_store, 2, "build a rocket")

    IO.puts("Tasks: ")
    Tasks.Task.all(:task_store)
    |> Enum.map(fn task -> "   -> " <> task.name <> " (" <> to_string(task.done) <> ")" end)
    |> Enum.reduce(fn task, acc -> acc <> "\n" <> task end)
    |> IO.puts

    {:ok, self()}
  end
end
