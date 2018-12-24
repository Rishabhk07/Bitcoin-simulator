defmodule Bitcoin do
  use GenServer
  def new(args) do
    GenServer.start_link(__MODULE__,[],name: "Parent" |> String.to_atom())
    Blockchain.start()
#    Miner.start(node_name(1))
#    Enum.each(1..5, fn x ->

#    end)
    invoke_miner(1)
    invoke_wallets(1)
#    start_miner(1)
    wallet_transactions(1)


#    Enum.each(1..5, fn x ->
#      Miner.mine_next(node_name(x))
#    end)
#    Miner.mine_next(node_name(1))

    Process.sleep(5000)
    Blockchain.print_block_chain()
  end
  def start_parent do
    GenServer.start_link(__MODULE__,[],name: "Parent" |> String.to_atom())
    Blockchain.start()
    Transaction.start()
  end
  def start_miners_wallets do
    invoke_miner(1)
    invoke_wallets(1)
  end
  def wallet_transation_once do
    GenServer.cast("Parent" |> String.to_atom(),{:wallet_transactions,wallet_node_name(1)})
  end

  def start_link(args) do
    GenServer.start_link(__MODULE__,[],name: "Parent" |> String.to_atom())
    Blockchain.start()
    Transaction.start()
    #    Miner.start(node_name(1))
    #    Enum.each(1..5, fn x ->

    #    end)
    invoke_miner(1)
    invoke_wallets(1)
    #    start_miner(1)
    #    wallet_transactions(1)


    #    Enum.each(1..5, fn x ->
    #      Miner.mine_next(node_name(x))
    #    end)
    #    Miner.mine_next(node_name(1))

  end
  def wallet_transactions(num) when num <= 5 do
    GenServer.cast("Parent" |> String.to_atom(),{:wallet_transactions,wallet_node_name(num)})
    wallet_transactions(1+num)
  end
  def wallet_transactions(num) do
  end
  def invoke_wallets(num) when num <= 100 do
    GenServer.call("Parent" |> String.to_atom(),{:invoke_wallet,wallet_node_name(num)})
    invoke_wallets(1+num)
  end
  def invoke_wallets(num) do
    IO.puts "5 wallets invoked, each will make 1 transaction"
  end

  def invoke_miner(num) when num <= 100 do
    GenServer.call("Parent" |> String.to_atom(),{:invoke_miner,node_name(num)})
    invoke_miner(1+num)
  end
  def invoke_miner(num) do
    IO.puts "5 miners started"
  end
  def start_miner(num) when num <= 5 do
#    IO.inspect num
    GenServer.cast("Parent" |> String.to_atom(),{:start_mining,node_name(num)})
    start_miner(1+num)
  end
  def start_miner(num) do

  end
  def main(args) do
    #  IO.inspect "Mining started with Proof work difficulty 4"
    chain = Blockchain.main();
    #    chain = Blockchain.insert(chain,"From : Rishabh, To: Richa, Amount: 10")
    #    chain = Blockchain.insert(chain,"From : Richa, To: Pathak, Amount: 10")
#    transaction = []
#    transaction = transaction ++ [Transaction.new("Rishabh", "Richa", 10)]
#    transaction = transaction ++ [Transaction.new("Richa", "Pathak", 8)]
#    transaction = transaction ++ [Transaction.new("Pathak", "Kakkar", 6)]
#    transaction = transaction ++ [Transaction.new("Kakkar", "Anip", 4)]
#    transaction = transaction ++ [Transaction.new("Anip", "Baniya", 2)]
#    IO.inspect transaction
    #    list = ["Rishabh", "Richa", "Arnav Gupta", "Khanna", "Sikri", "Harshit", "Alin", "Dobra"]
    #    Enum.random(0..length(list))
    #    transactions = Enum.reduce(1..10, fn x ->
    #
    #    end)

    allMiners = Enum.reduce(
      1..10,[],
      fn x, acc ->
        acc ++ [node_name(x)]
      end
    )
#    IO.inspect allMiners
    GenServer.start_link(__MODULE__, [],name: "parent" |> String.to_atom())
#    Enum.each(
#      1..10,
#      fn x ->
#        Miner.mine_transaction(node_name(x), transaction)
#      end
#    )
        Enum.each(allMiners, fn x ->
#          Miner.mine_transaction2(node_name(x),transaction)
#          IO.inspect x
          GenServer.cast("parent" |> String.to_atom(), {:start_miner, x, chain})
        end)
    Process.sleep(10000)
    #    IO.inspect chain
  end
#  def main do
#    transaction = []
#    transaction = transaction ++ [Transaction.new("Rishabh", "Richa", 10)]
#    transaction = transaction ++ [Transaction.new("Richa", "Pathak", 8)]
#    transaction = transaction ++ [Transaction.new("Pathak", "Kakkar", 6)]
#    transaction = transaction ++ [Transaction.new("Kakkar", "Anip", 4)]
#    transaction = transaction ++ [Transaction.new("Anip", "Baniya", 2)]
#    IO.inspect transaction
#    Enum.each(
#      1..1,
#      fn x ->
#        Miner.mine_transaction(node_name(x), transaction)
#      end
#    )
#  end
  def node_name(nodenum), do: "Miner" <> Integer.to_string(nodenum) |> String.to_atom()
  def wallet_node_name(nodenum), do: "Wallet" <> Integer.to_string(nodenum) |> String.to_atom()
  ########################################################################################
#  def init(args) do
#    transaction = []
#    transaction = transaction ++ [Transaction.new("Rishabh", "Richa", 10)]
#    transaction = transaction ++ [Transaction.new("Richa", "Pathak", 8)]
#    transaction = transaction ++ [Transaction.new("Pathak", "Kakkar", 6)]
#    transaction = transaction ++ [Transaction.new("Kakkar", "Anip", 4)]
#    transaction = transaction ++ [Transaction.new("Anip", "Baniya", 2)]
#    IO.inspect transaction
#    IO.inspect "Full node transarted"
#    {:ok, %{:transaction => transaction, :blockchain => []}}
#  end
#  def handle_cast({:new_transaction, new_transaction_block}, transaction_and_blockchain) do
#
#    {:noreply, transaction_and_blockchain}
#  end
#  def handle_cast({:start_miner, miner, chain}, transaction_and_blockchain) do
#    Miner.start_link(miner,chain)
#    {:noreply, transaction_and_blockchain}
#  end
#  def handle_cast({:start_mining,nodenum}, transaction_and_blockchain) do
#    Miner.mine_transaction(node_name(nodenum), transaction_and_blockchain.transaction)
#    {:noreply, transaction_and_blockchain}
#  end
#  def handle_cast({:request_transaction, miner}, transaction_and_blockchain) do
#    {:noreply, transaction_and_blockchain}
#  end
  def handle_cast({:wallet_transactions,name},state) do
    Wallet.new_transaction(name)
    {:noreply,state}
  end
  def handle_call({:invoke_wallet,name},from_,state) do
    Wallet.start(name)
    {:reply,state,state}
  end
  def handle_call({:invoke_miner,name},from_,state) do
          Miner.start(name)
          {:reply,state,state}
  end
  def handle_cast({:start_mining, name}, state) do
          Miner.mine_next(name)
          {:noreply,state}
  end
end
