module ControllerMacros
  def login_client
    before do
      @request.env['devise.mapping'] = Devise.mappings[:client]
      client = FactoryBot.create(:client)
      client.confirm! # or set a confirmed_at inside the factory. Only necessary if you are using the "confirmable" module
      sign_in client
    end
  end

  def login_contractor
    before do
      @request.env['devise.mapping'] = Devise.mappings[:contractor]
      contractor = FactoryBot.create(:contractor)
      contractor.confirm! # or set a confirmed_at inside the factory. Only necessary if you are using the "confirmable" module
      sign_in contractor
    end
  end
end
