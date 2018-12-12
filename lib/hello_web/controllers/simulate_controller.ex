defmodule HelloWeb.SimulateController do
  use HelloWeb, :controller
  def index(conn, _params) do
#    Bitcoin.new([])
    Bitcoin.wallet_transation_once()
#    render(conn, "index.html", blockchain: Blockchain.print_block_chain_test())
      json(conn,Blockchain.print_block_chain_test())
  end

  def get_blockchain(conn, _params ) do
    json(conn,Blockchain.print_block_chain_test())
  end
end