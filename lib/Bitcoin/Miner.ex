defmodule Miner do
  use GenServer
  def start_link(options)  do
    IO.inspect "started"
    GenServer.start_link(__MODULE__, :ok, [debug: [:trace]])
  end
  def start_link(nodename, chain) do
    IO.inspect "started"
    GenServer.start_link(__MODULE__, %{:nodename => nodename, :blockchain => chain}, name: nodename)
  end
  def mine_transaction(nodename, transaction) when is_list(transaction) do
    GenServer.call(nodename, {:mine_transaction, transaction, self()})
  end
  #  def mine_transaction2(nodename, transaction) when is_list(transaction) do
  #    GenServer.call(nodename, {:mine_transaction_, transaction})
  #  end
  ###########################################################################


#  def handle_call({:mine_transaction, transactions, parent}, blockchain_new) do
#    next_transaction = hd(transactions)
#    {:ok, blockchain} = Map.fetch(blockchain_new, :blockchain)
#    {:ok, nodename} = Map.fetch(blockchain_new, :nodename)
#    %Block{hash: prev} = hd(blockchain)
#    IO.inspect "New block started mining on Node #{nodename}"
#    block =
#      next_transaction
#      |> Block.new(prev)
#      |> Crypto.put_hash
#    IO.inspect block
#    blockchain = [block | blockchain_new.blockchain]
#    blockchain_new = %{blockchain_new | blockchain: blockchain}
#    {:reply, blockchain_new, blockchain_new}
#  end
#
#  def handle_call({:mine_transaction_, transactions}, from_, blockchain_new) do
#    blockchain = ["YO" | blockchain_new.blockchain]
#    {:reply, blockchain_new, blockchain_new}
#  end
  ###########new

  def start(name) do
    GenServer.start_link(
      __MODULE__,
      name,
      name: name
    )
  end
  def mine_next(name) do
#    IO.inspect name
    value = GenServer.call(
      name,
      :mine_transaction
    )
    if(value == 1) do
#      Process.sleep(1000)
      mine_next(name)
    end
  end
  ############################################################################## SERVER SIDE ######################################
  def init(args) do
#    IO.inspect "started node #{args}"
    {:ok, args }
  end
  def handle_call(:mine_transaction, from_, state) do
#    IO.inspect state
    transactions = Transaction.get_transactions()
    blockchain = Blockchain.get_blockchain();
    if(length(transactions) != 0) do
      next_transaction = hd(transactions)
      %Block{hash: prev} = hd(blockchain)
      IO.puts "New block started mining  on #{state}"
      block =
        next_transaction
        |> Block.new(prev)
        |> Crypto.put_hash
      #    IO.inspect block
      Blockchain.add_block(block)
      {:reply, 1, state}
      else
      IO.puts "All transaction are done for now #{state}"
      {:reply, 0, state}
    end
  end
end