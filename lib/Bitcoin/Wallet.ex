defmodule Wallet do
  use GenServer
  def start(name) do
    GenServer.start_link(__MODULE__, name, name: name )
  end
  def get_public_key(name) do
    GenServer.call(name, :get_public_details)
  end
  def new_transaction(name)  do
    GenServer.call(name, :new_transaction)
  end
  def new_test_transaction(name,to_address)  do
    GenServer.call(name, {:new_test_transaction,to_address})
  end
  ############################################################################## SERVER SIDE ######################################
  def get_random(num) do
#    IO.inspect "NUM IS #{num}"
    random = Enum.random(1..5)
#    IO.inspect random
    random = if(random == String.to_integer(num)) do
      get_random(num)
      else
      random
    end
    random
  end
  def init(args) do
#    IO.inspect "wallet invoked #{args}"
    {private_key, public_key} = :crypto.generate_key(:ecdh, :secp256k1)
    {:ok, %{:public_key=> public_key |> Base.encode16, :private_key=> private_key |> Base.encode16, :name => args}}
  end
  def handle_call(:new_transaction,  from_, state) do
    IO.puts "New Transaction from #{state.name}"
    to_address = get_public_key("Wallet#{get_random(String.slice(to_string(state.name),-1..-1))}" |> String.to_atom())
    amount = Enum.random(1..1000)
    transaction = Transaction.new(to_string(state.public_key), to_string(to_address), amount)
    Transaction.add_transaction(transaction)
    {:reply,transaction,state}
  end
  def handle_call({:new_test_transaction,to_address},  from_, state) do
#    IO.puts "New Transaction from #{state.name}"
    to_address = get_public_key(to_address)
    amount = 100
    transaction = Transaction.new(to_string(state.public_key), to_string(to_address), amount)
    Transaction.add_transaction(transaction)
    {:reply,transaction,state}
  end
  def handle_call(:get_public_details, from_,  state) do
    {:reply, state.public_key, state}
  end
end