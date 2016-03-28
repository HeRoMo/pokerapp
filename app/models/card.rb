
# ポーカーの手札を表すクラス
class Card

  # ポーカーの役と強さ
  module Hands
    STRAIGHT_FLUSH=:STRAIGHT_FLUSH
    FOUR_OF_A_KIND=:FOUR_OF_A_KIND
    FULL_HOUSE=:FULL_HOUSE
    FLUSH=:FLUSH
    STRAIGHT=:STRAIGHT
    THREE_OF_A_KIND=:THREE_OF_A_KIND
    TWO_PAIR=:TWO_PAIR
    ONE_PAIR=:ONE_PAIR
    HIGH_CARD=:HIGH_CARD

    # 役の強さ
    Strength={
      STRAIGHT_FLUSH:80,
      FOUR_OF_A_KIND:70,
      FULL_HOUSE:60,
      FLUSH:50,
      STRAIGHT:40,
      THREE_OF_A_KIND:30,
      TWO_PAIR:20,
      ONE_PAIR:10,
      HIGH_CARD:0
    }.freeze
  end

  # 手札の文字列表現フォーマット
  VALID_CARDS_PATTERN= /\A(S|H|D|C)([1-9]{1}|1[0-3]{1}) (S|H|D|C)([1-9]{1}|1[0-3]{1}) (S|H|D|C)([1-9]{1}|1[0-3]{1}) (S|H|D|C)([1-9]{1}|1[0-3]{1}) (S|H|D|C)([1-9]{1}|1[0-3]{1})\Z/i


  # 手札を初期化する
  # @param cards [String] 手札の文字列。文字列のフォーマットは VALID_CARDS_PATTERN の通り
  # @raise ['bad cards'] cards が不正なフォーマット
  # @raise ['same card is included'] cards に同一のカードが含まれる
  def initialize(cards)
    # cards のバリデーション
    cards.strip! unless cards.nil?
    raise 'bad cards' unless VALID_CARDS_PATTERN=~cards
    @cards_str = cards.upcase
    # cards のパース
    @cards = cards.split(' ').uniq
    raise 'same card is included' unless @cards.size == 5
    @nums = {}
    @suit = []
    @cards.each do |card|
      num = card[1,2].to_i
      @nums[num]||=0
      @nums[num]+=1
      @suit<<card[0]
    end
    @suit.uniq!.sort!
    @num_pattern = @nums.values.sort
  end

  # 役を取得する
  # @return [sym] Card::Hands のいずれか
  def hand
    @hand ||= judge_hand
  end

  # 手札の文字列表現を返す
  # @retrun [String] 手札の文字列表現
  def to_s
    @cards_str
  end

  # カードの強さ
  # 現実装では 役の強さのみ
  def strength
    Hands::Strength[hand]
  end

  private
  # 役の判定
  # @return [sym] 役を表すシンボル
  def judge_hand
    # ペア系の役チェック
    case @num_pattern
      when [1,4]
        return Hands::FOUR_OF_A_KIND
      when [2,3]
        return Hands::FULL_HOUSE
      when [1,1,3]
        return Hands::THREE_OF_A_KIND
      when [1,2,2]
        return Hands::TWO_PAIR
      when [1,1,1,2]
        return Hands::ONE_PAIR
      else #[1,1,1,1,1]
        return judge_straight_type #ストレート系の判定
    end
  end

  # ストレート系の役判定
  # @return [sym] 役を表すシンボル
  def judge_straight_type
    numbers = @nums.keys.sort
    # ロイヤルな数字パターンの処理
    if numbers == [1,10,11,12,13]
      if @suit.size == 1
        return Hands::STRAIGHT_FLUSH
      else
        return Hands::STRAIGHT
      end
    end

    # ロイヤル以外の処理
    if (numbers.max - numbers.min) == 4 #ストレートの判定
      if @suit.size == 1
        return Hands::STRAIGHT_FLUSH
      else
        return Hands::STRAIGHT
      end
    else # フラッシュの判定
      if @suit.size == 1
        return Hands::FLUSH
      else
        return Hands::HIGH_CARD
      end
    end
  end
end
