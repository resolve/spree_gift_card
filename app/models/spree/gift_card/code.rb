module Spree::GiftCard::Code
  def self.generate gc
    Digest::SHA1.hexdigest([Time.now, Kernel.rand].join)
  end
end
