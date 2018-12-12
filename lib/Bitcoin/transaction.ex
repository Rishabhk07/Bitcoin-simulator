defmodule Transaction do
  use GenServer
  @derive Jason.Encoder
  defstruct [:fromAddress, :toAddress, :amount]

  def new(fromAddress, toAddress, amount) do
    %Transaction{
      fromAddress: fromAddress,
      toAddress: toAddress,
      amount: amount
    }
  end

  def zero do
    %Transaction{
      fromAddress: nil,
      toAddress: nil,
      amount: "ZERO_BLOCK"
    }
  end
  def start do
    GenServer.start_link(__MODULE__, [], name: "Transactions" |> String.to_atom() )
  end
  def get_transactions do
    GenServer.call("Transactions" |> String.to_atom(), :get_transaction)
  end
  def remove_transaction(this_transaction) do
    GenServer.cast("Transactions" |> String.to_atom(),{:remove_transaction,this_transaction})
  end
  def add_transaction(transaction) do
    GenServer.call("Transactions" |> String.to_atom(), {:new_transaction,transaction})
    Miner.mine_next("Miner#{Enum.random(1..5)}" |> String.to_atom)
  end
  def add_transaction_cast(transaction) do
    GenServer.cast("Transactions" |> String.to_atom(), {:new_transaction,transaction})
  end
  ############################################################################## SERVER SIDE ######################################
  def init(args) do
    transaction = []
#    transaction = transaction ++ [Transaction.new("Rishabh", "Richa", 10)]
#    transaction = transaction ++ [Transaction.new("Richa", "Pathak", 8)]
#    transaction = transaction ++ [Transaction.new("Pathak", "Kakkar", 6)]
#    transaction = transaction ++ [Transaction.new("Kakkar", "Anip", 4)]
#    transaction = transaction ++ [Transaction.new("Anip", "Baniya", 2)]
    IO.inspect transaction
    {:ok, transaction}
  end

  def handle_call({:new_transaction, new_transaction},from_, transactions ) do
    transactions = [new_transaction | transactions]
    IO.puts "New Transaction added, Transactions are : "
    IO.inspect transactions
    {:reply, transactions,transactions}
  end

  def handle_cast({:new_transaction, new_transaction}, transactions ) do
    transactions = [new_transaction | transactions]
    IO.puts "New Transaction added, Transactions are : "
    IO.inspect transactions
    {:noreply, transactions}
  end

  def handle_cast({:remove_transaction,this_transaction}, transactions ) do
    transactions = transactions -- [this_transaction]
#    IO.inspect transactions
#    if(length(transactions) == 0) do
#      Blockchain.print_block_chain()
#    end
    {:noreply, transactions}
  end
  def handle_call(:get_transaction, from_, transactions) do
#    IO.inspect transactions
    {:reply, transactions, transactions}
  end
end