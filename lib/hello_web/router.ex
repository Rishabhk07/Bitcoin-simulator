defmodule HelloWeb.Router do
  use HelloWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HelloWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/simulator", HelloController, :index
    resources "/users", UserController
    resources "/post", PostController, only: [:index, :show]
    get "/charts", ChartsController, :index
    get "/simulate", SimulateController, :index
    get "/get_blockchain", SimulateController, :get_blockchain
    get "/mine_block", MineController, :index
    get "/get_miner_keys", MineController, :get_keys
    get "/get_wallet_keys", MineController, :get_wallet_keys
    get "/wallet_from_miners", MineController, :get_coin_from_miner
    get "/simulator100", SimulatorController, :index
    get "/blockchain_valid", MineController, :blockchain
  end

  scope "/admin", HelloWeb.Admin, as: :admin do
    pipe_through :browser

    resources "/images", ImageController
    resources "/reviews", ReviewController
    resources "/users", UserController
  end

  # Other scopes may use custom stacks.
  # scope "/api", HelloWeb do
  #   pipe_through :api
  # end
end
