Spree::AppConfiguration.class_eval do
  preference :gc_default_expiration_days, :integer, default: 90
end
