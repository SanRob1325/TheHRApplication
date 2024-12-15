require 'rails_helper'

RSpec.describe 'Employees API',type: :request do
  it 'returns all employees' do
    get '/employees'
    expect(response).to have_http_status(:success)
  end

end