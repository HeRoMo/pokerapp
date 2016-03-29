require 'rails_helper'

RSpec.describe Api::V1::PokerController, type: :controller do

  describe "POST #judge" do
    context 'returns http success' do
      it "one card set" do
        post :judge, {cards:["H1 H13 H12 H11 H10"]}
        expect(response).to have_http_status(:success)
      end
      it "three card sets" do
        post :judge, {cards:["C1 H13 S12 S11 H10", "H9 C9 S9 H2 C2", "C13 D12 C11 H8 H7"]}
        expect(response).to have_http_status(:success)
        expect(assigns(:cards).size).to be 3
        expect(assigns(:best_hand)).to be :FULL_HOUSE
      end
      it "multiple best hand" do
        post :judge, {cards:["H1 H13 H12 H11 H10", "D1 D13 D12 D11 D10", "C13 S12 C11 H8 H7"]}
        expect(response).to have_http_status(:success)
        expect(assigns(:cards).size).to be 3
        expect(assigns(:best_hand)).to be :STRAIGHT_FLUSH
      end
    end
    context 'returns http bad request' do
      it "no card set" do
        post :judge, {cards:[]}
        response
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)["error"]).to eq 'no card'
      end
      it "number of cards is not enough" do
        post :judge, {cards:["H1 H13 H12 H11 H10", "H9 C9 H2 C2", "C13 D12 C11 H8 H7"]}
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)["error"]).to eq 'bad cards'
      end
      it "number of cards is too match" do
        post :judge, {cards:["H1 H13 H12 H11 H10", "H9 C9 H2 C2 H1 D7", "C13 D12 C11 H8 H7"]}
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)["error"]).to eq 'bad cards'
      end
      it "duplicate card" do
        post :judge, {cards:["H1 H13 H12 H11 H10", "H9 C9 H2 C2 H12", "C13 D12 C11 H8 H7"]}
        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)["error"]).to eq 'card duplicated'
      end
    end

  end

end
