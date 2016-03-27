require 'rails_helper'

describe Card, type: :model do
  describe '#initilaize' do
    context 'with valid card pattern' do
      subject{ Card.new(card)}
      context 'upper case' do
        let(:card){'C7 C6 C5 C4 C3'}
        it { is_expected.to be_a Card }
      end
      context 'lower case' do
        let(:card){'s7 s6 s5 s4 s3'}
        it { is_expected.to be_a Card }
      end
      context 'with white space' do
        let(:card){' s7 s6 s5 s4 s3 '}
        it { is_expected.to be_a Card }
      end
    end
    context 'with invalid card pattern' do
      context 'less card' do
        let(:cards){'C6 C5 C4 C3'}
        it { expect{Card.new(cards)}.to raise_error 'bad cards'}
      end
      context 'too match card' do
        let(:cards){'C6 C5 C4 C3 C2 C1'}
        it { expect{Card.new(cards)}.to raise_error 'bad cards'}
      end
      context 'bad card C0' do
        let(:cards){'C6 C5 C4 C3 C0'}
        it { expect{Card.new(cards)}.to raise_error 'bad cards'}
      end
      context 'bad card C14' do
        let(:cards){'H6 S5 C4 C3 C14'}
        it { expect{Card.new(cards)}.to raise_error 'bad cards'}
      end
      context 'bad suit' do
        let(:cards){'H6 A5 C4 C3 C1'}
        it { expect{Card.new(cards)}.to raise_error 'bad cards'}
      end
      context 'include same card' do
        let(:cards){'H6 S5 C4 C1 C1'}
        it { expect{Card.new(cards)}.to raise_error 'same card is included'}
      end
      context 'card is nil' do
        let(:cards){nil}
        it { expect{Card.new(cards)}.to raise_error 'bad cards'}
      end
    end
  end

  describe '#hand' do
    context 'STRAIGHT_FLUSH' do
      it { expect(Card.new('C7 C6 C5 C4 C3').hand).to be Card::Hands::STRAIGHT_FLUSH}
      it { expect(Card.new('H1 H13 H12 H11 H10').hand).to be Card::Hands::STRAIGHT_FLUSH}
    end
    context 'FOUR_OF_A_KIND' do
      it { expect(Card.new('C10 D10 H10 S10 D5').hand).to be Card::Hands::FOUR_OF_A_KIND}
      it { expect(Card.new(' D6 H6 S6 C6 S13').hand).to be Card::Hands::FOUR_OF_A_KIND}
    end
    context 'FULL_HOUSE' do
      it { expect(Card.new('S10 H10 D10 S4 D4').hand).to be Card::Hands::FULL_HOUSE }
      it { expect(Card.new('H9 C9 S9 H1 C1').hand).to be Card::Hands::FULL_HOUSE }
    end
    context 'FOUR_OF_A_KIND' do
      it { expect(Card.new('H1 H12 H10 H5 H3').hand).to be Card::Hands::FLUSH }
      it { expect(Card.new('S13 S12 S11 S9 S6').hand).to be Card::Hands::FLUSH }
    end
    context 'STRAIGHT' do
      it { expect(Card.new('S8 S7 H6 H5 S4').hand).to be Card::Hands::STRAIGHT}
      it { expect(Card.new('D6 S5 D4 H3 C2').hand).to be Card::Hands::STRAIGHT}
    end
    context 'THREE_OF_A_KIND' do
      it { expect(Card.new('S12 C12 D12 S5 C3').hand).to be Card::Hands::THREE_OF_A_KIND}
      it { expect(Card.new('C5 H5 D5 D12 C10').hand).to be Card::Hands::THREE_OF_A_KIND}
    end
    context 'TWO_PAIR' do
      it { expect(Card.new('H13 D13 C2 D2 H11').hand).to be Card::Hands::TWO_PAIR}
      it { expect(Card.new('D11 S11 S10 C10 S9').hand).to be Card::Hands::TWO_PAIR}
    end
    context 'ONE_PAIR' do
      it { expect(Card.new('C10 S10 S6 H4 H2').hand).to be Card::Hands::ONE_PAIR}
      it { expect(Card.new('H9 C9 H1 D12 D10').hand).to be Card::Hands::ONE_PAIR}
    end
    context 'HIGH_CARD' do
      it { expect(Card.new('D1 D10 S9 C5 C4').hand).to be Card::Hands::HIGH_CARD}
      it { expect(Card.new('C13 D12 C11 H8 H7').hand).to be Card::Hands::HIGH_CARD}
    end
  end

end
