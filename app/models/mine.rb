class Mine < ApplicationRecord
  belongs_to :board

  class << self
    def gen_block_hash(board_id, block_x, block_y)
      Digest::MD5.hexdigest("#{board_id}-#{block_x}-#{block_y}")
    end
  end
end
