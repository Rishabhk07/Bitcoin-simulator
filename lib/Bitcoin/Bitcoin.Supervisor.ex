defmodule Bitcoin.Superviser do
  use Supervisor
  def main(args) do
    start_link(args)
  end
  def start_link(options) do
    Supervisor.start_link(__MODULE__, :ok, [debug: [:trace]])
  end

  def init(:ok) do
    children = [
      Supervisor.child_spec({Miner,name: Miner1}, id: :Miner1),
      Supervisor.child_spec({Miner,name: Miner2}, id: :Miner2),
      Supervisor.child_spec({Miner,name: Miner3}, id: :Miner3),
      Supervisor.child_spec({Miner,name: Miner4}, id: :Miner4)
    ]
#    children = [
#      Supervisor.child_spec({Miner,name: Miner1}, id: :Miner1)

#    ]

    Supervisor.init(children, strategy: :one_for_all)
#    Bitcoin.main()
  end
end