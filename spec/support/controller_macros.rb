module ControllerMacros
  def login
    before(:each) do
      unless user.nil?
        allow(controller).to receive(:current_spree_user).and_return(user)
      end
    end
  end

  def logout
    before(:each) do
      unless user.nil?
        allow(controller).to receive(:current_spree_user).and_return(nil)
      end
    end
  end
end
