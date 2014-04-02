describe Spree::AppConfiguration do
  it "should set preference gift_card_default_expiration_date_in_days"  do
    Spree::Config.gc_default_expiration_days.should eq(90)
  end
end
