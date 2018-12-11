defmodule Crypto do
  @hash_fields [:data, :timestamp, :prev_hash, :nonce]
  @transaction_fields [:fromAddress, :toAddress, :amount]
  def hash(%{} = block) do

    block
    |> Map.take(@hash_fields)
    |> Poison.encode!
    |> sha256
  end
  def put_hash(%{} = block) do
    {hash, nonce} = hash(block)
    block = %{block | hash: hash}
    %{block | nonce: nonce}
  end
  def get_block_hash(%{} = block) do
    block
    |> Map.take(@hash_fields)
    |> Poison.encode!
    |> get_sha256
  end
  def get_hash (%{} = block) do
    block
    |> Map.take(@transaction_fields)
    |> Poison.encode!
    |> get_sha256()
  end
  def get_sha256(block) do
    :crypto.hash(:sha256, block)
    |> Base.encode16
  end
  defp sha256(binary)  do
    hash = :crypto.hash(:sha256, binary)
           |> Base.encode16
    proofWork(hash, binary, 0)
  end
  def proofWork(hash, binary, nonce) do

    #    IO.inspect hash
    #    IO.inspect nonce
    #    IO.inspect to_string(String.slice(hash, 0..1)) != to_string("0")
    #    IO.inspect String.slice(hash, 0..0)
    if to_string(String.slice(hash, 0..2)) != to_string("000") do
      binary = Poison.decode!(binary)
      {:ok, nonce} = Map.fetch(binary, "nonce")
      #      IO.inspect binary["nonce"]
      binary = Map.put(binary, "nonce", 1 + nonce)

      #      binary.nonce = binary.nonce + 1
      #      binary  = {binary | nonce: nonce+1}
      hash = :crypto.hash(:sha256, Poison.encode!(binary))
             |> Base.encode16
      proofWork(hash, Poison.encode!(binary), 1 + nonce)
    else
      {hash, nonce}
    end
  end
end