class Api::V1::PokerController < ApplicationController
  protect_from_forgery with: :null_session

  def judge
    params_cards = params[:cards]
    @cards = []
    params_cards.each do |card|
      @cards << Card.new(card)
    end
    # TODO best を求める
  rescue RuntimeError=>e
    render json:{error:e}, status:400
  end
end
