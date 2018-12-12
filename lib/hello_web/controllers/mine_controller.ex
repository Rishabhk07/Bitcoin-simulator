defmodule HelloWeb.MineController do
  use HelloWeb, :controller
  def index(conn, _params) do

    #    render(conn, "index.html")

      json(conn,Miner.mine_next(Bitcoin.node_name(Enum.random(1..5))))
  end

  def get_keys(conn, _params) do
    value = Enum.reduce(1..5, [],fn x, acc ->
      acc ++ [Miner.get_public_key(Bitcoin.node_name(x))]
    end)
    json(conn,value)
  end

  def get_wallet_keys(conn, _params) do
    value = Enum.reduce(1..5, [],fn x, acc ->
      acc ++ [Wallet.get_public_key(Bitcoin.wallet_node_name(x))]
    end)
    json(conn,value)
  end

  def get_coin_from_miner(conn, params) do
    IO.inspect params
#    {amount, miner, wallet} = _params
    IO.inspect Map.get(params,"amount") |> String.to_integer()

    json(conn,Wallet.new_transaction_from_miner(Map.get(params,"wallet") |> String.to_atom(),Map.get(params,"miner") |> String.to_atom(),Map.get(params,"amount") |> String.to_integer()))
  end
end