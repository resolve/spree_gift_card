module Spree::GiftCard::Code
  def self.generate gc
    gc.code = Digest::SHA1.hexdigest([Time.now, Kernel.rand].join)
  end
end
