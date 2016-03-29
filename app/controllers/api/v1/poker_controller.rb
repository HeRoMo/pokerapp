class Api::V1::PokerController < ApplicationController
  protect_from_forgery with: :null_session

  def judge
    params_cards = params[:cards]
    raise 'no card' if params_cards.blank?

    @cards = []
    all_cards =[]
    params_cards.each do |card|
      card_set = Card.new(card)
      @cards << card_set
      all_cards+= card_set.cards
    end
    # 与えられたカード全てで重複がないことを確認する
    raise 'card duplicated' if all_cards.size - all_cards.uniq.size > 0
    # bestな役を求める
    @best_hand = @cards.max{|a,b| a.strength<=>b.strength}.hand
  rescue RuntimeError=>e
    render json:{error:e.message}, status:400
  end
end
