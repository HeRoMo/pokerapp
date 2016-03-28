require 'rails_helper'

RSpec.describe Api::V1::PokerController, type: :controller do

  describe "POST #judge" do
    context 'returns http success' do
      it "one card set" do
        post :judge, {cards:["H1 H13 H12 H11 H10"]}
        expect(response).to have_http_status(:success)
      end
      it "three card sets" do
        post :judge, {cards:["H1 H13 H12 H11 H10", "H9 C9 S9 H2 C2", "C13 D12 C11 H8 H7"]}
        expect(response).to have_http_status(:success)
        expect(assigns(:cards).size).to be 3
      end
    end
    context 'bad request' do
      it "returns http bad request" do
        post :judge, {cards:["H1 H13 H12 H11 H10", "H9 C9 H2 C2", "C13 D12 C11 H8 H7"]}
        expect(response).to have_http_status(:bad_request)
      end
    end

  end

end
