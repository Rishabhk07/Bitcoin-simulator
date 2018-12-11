defmodule Block do

  use GenServer
  @derive Jason.Encoder
  defstruct [:data, :timestamp, :prev_hash, :hash, :nonce]

  def new(data, prev_hash) do
    %Block{
      data: data,
      timestamp: NaiveDateTime.utc_now,
      prev_hash: prev_hash,
      nonce: 0
    }
  end

  def zero do
    %Block{
      data: Transaction.zero(),
      prev_hash: "ZERO_HASH",
      timestamp: NaiveDateTime.utc_now,
      nonce: 0
    }
  end


  def valid?(%Block{} = block) do
    Crypto.get_block_hash(block) == block.hash
  end

  def valid?(%Block{} = block, %Block{} = prev_block) do
    (block.prev_hash == prev_block.hash) && valid?(block)
  end


#  def mine_pending_transactions(pid, miningRewardAddress, threshold) do
#    {:ok, block_pid} = Block.start_link()
#    Block.mine_block(block_pid, threshold)
#    latest_block_pid = get_latest_block(pid)
#    latest_block_hash = Block.get_hash(latest_block_pid)
#    Block.update_previous_hash(block_pid, latest_block_hash)
#    add_block(pid, block_pid)
#    Block.update_transactions(block_pid, get_pending_transactions(pid))
#    Block.recalculate_hash(threshold, block_pid)
#    update_pending_transcations(pid, [])
#    {:ok, txn_id} = Transaction.start_link("miningReward", miningRewardAddress, get_mining_reward(pid))
#    add_transaction(pid, txn_id)
#    block_pid
#  end
end

