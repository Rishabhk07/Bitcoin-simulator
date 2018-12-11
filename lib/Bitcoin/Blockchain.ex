defmodule Blockchain do
  use GenServer
  def main do
    [Crypto.put_hash(Block.zero)]
  end

  def insert(blockchain, data) when is_list(blockchain) do
    IO.inspect "Mining next block with difficulty 4"
    %Block{hash: prev} = hd(blockchain)
    block =
      data
      |> Block.new(prev)
      |> Crypto.put_hash
    IO.inspect block
    [block | blockchain]
  end

  def valid?(blockchain) when is_list(blockchain) do
    IO.inspect "TEST STARTED"
    zero = Enum.reduce_while(
      blockchain,
      nil,
      fn prev, current ->
        cond do
          current == nil ->
            {:cont, prev}

          Block.valid?(current, prev) ->
            {:cont, prev}

          true ->
            {:halt, false}
        end
      end
    )
    if zero, do: Block.valid?(zero), else: false
  end

  ############################
  def start do
    GenServer.start_link(__MODULE__, [], name: "Blockchain" |> String.to_atom())
  end
  def get_blockchain do
    GenServer.call("Blockchain" |> String.to_atom(),:get_blockchain)
  end
  def add_block(block) do
    GenServer.cast("Blockchain" |> String.to_atom(), {:update_blockchain,block})
  end
  def print_block_chain do
    GenServer.cast("Blockchain" |> String.to_atom(), :print_blockchain)
  end
  def print_block_chain_test do
    GenServer.call("Blockchain" |> String.to_atom(), :print_blockchain)
  end
  ############################################################################## SERVER SIDE ######################################
  def init(args) do
    zeroHash = Crypto.put_hash(Block.zero)
    {:ok, %{:blockchain=>[zeroHash], :hash_chain => [zeroHash.hash]}}
  end
  def handle_cast({:update_blockchain, block}, blockchain_hash) do
#    blockchain = blockchain_hash.blockchain
#    IO.inspect block
#    IO.inspect block.data

    {:ok,hash_chain}= Map.fetch(blockchain_hash, :hash_chain)
#    IO.inspect hash_chain
#    IO.inspect blockchain_hash.blockchain
    blockchain_hash = if(!(Crypto.get_hash(block.data)  in hash_chain)) do
      blockchain_hash = Map.put(blockchain_hash,:blockchain,[block | blockchain_hash.blockchain])
#      IO.inspect blockchain_hash.blockchain
      blockchain_hash = Map.put(blockchain_hash, :hash_chain,[Crypto.get_hash(block.data) | hash_chain])
      Transaction.remove_transaction(block.data)
      blockchain_hash
      else
        IO.inspect "Already in block chain !! Some one else mined this transaction "
        blockchain_hash
    end


#    IO.inspect blockchain_hash.blockchain
    {:noreply, blockchain_hash}
  end
  def handle_call(:get_blockchain, from_, blockchain_hash) do
    {:reply,blockchain_hash.blockchain,blockchain_hash}
  end
  def handle_cast(:print_blockchain, blockchain_hash) do
    IO.inspect blockchain_hash.blockchain
    {:noreply, blockchain_hash}
  end
  def handle_call(:print_blockchain,from_, blockchain_hash) do
#    IO.inspect blockchain_hash.blockchain
    {:reply, blockchain_hash.blockchain, blockchain_hash}
  end
end