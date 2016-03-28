json.result @cards.each do |card|
  json.card card.to_s
  json.hand t("hands.#{card.hand.to_s}")
  #json.best card.best? if card.best?
end