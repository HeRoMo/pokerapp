require 'rails_helper'
require 'json_expressions/rspec'

describe "Poker API", type: :request do
  describe 'post /api/v1/poker/judge' do
    subject {
      post '/api/v1/poker/judge', {cards:cards}
      response
    }
    context 'single card set' do
      shared_examples_for 'single card set' do
        let(:result){
          {result:[{card:cards[0],hand:hand,best:true}]}
        }
        it {
          expect(subject.status).to eq 200
          expect(subject.body).to match_json_expression(result)
        }
      end
      context 'straight flush' do
        let(:cards){['H1 H10 H11 H12 H13']}
        let(:hand){'ストレート・フラッシュ'}
        it_behaves_like 'single card set'
      end
      context 'four of a kind' do
        let(:cards){['S10 H10 C10 D10 H13']}
        let(:hand){'フォー・オブ・ア・カインド'}
        it_behaves_like 'single card set'
      end
      context 'full house' do
        let(:cards){['S10 H10 C10 D13 H13']}
        let(:hand){'フルハウス'}
        it_behaves_like 'single card set'
      end
      context 'flush' do
        let(:cards){['H5 H10 H6 H12 H4']}
        let(:hand){'フラッシュ'}
        it_behaves_like 'single card set'
      end
      context 'straight' do
        let(:cards){['D5 H6 S7 C8 H9']}
        let(:hand){'ストレート'}
        it_behaves_like 'single card set'
      end
      context 'two pair' do
        let(:cards){['D5 H5 S8 C8 H9']}
        let(:hand){'ツーペア'}
        it_behaves_like 'single card set'
      end
      context 'one pair' do
        let(:cards){['D5 H5 S10 C8 H9']}
        let(:hand){'ワンペア'}
        it_behaves_like 'single card set'
      end
      context 'high card' do
        let(:cards){['D1 H5 S3 C8 H9']}
        let(:hand){'ハイカード'}
        it_behaves_like 'single card set'
      end
    end
    context 'multiple card sets' do
      shared_examples_for 'multiple card sets' do
        it {
          expect(subject.status).to eq 200
          expect(subject.body).to match_json_expression({result:result})
        }
      end
      context 'one best' do
        let(:cards){['D1 H5 S3 C8 H9','S10 H10 C10 D10 H13','S5 S1 S6 S12 S4']}
        let(:result){[
            {card:cards[0], hand:'ハイカード'},
            {card:cards[1], hand:'フォー・オブ・ア・カインド',best:true},
            {card:cards[2], hand:'フラッシュ'}
        ]}
        it_behaves_like 'multiple card sets'
      end
      context 'two best' do
        let(:cards){['S8 H8 C8 D8 C11','S10 H10 C10 D10 H13','S5 S1 S6 S12 S4']}
        let(:result){[
            {card:cards[0], hand:'フォー・オブ・ア・カインド',best:true},
            {card:cards[1], hand:'フォー・オブ・ア・カインド',best:true},
            {card:cards[2], hand:'フラッシュ'}
        ]}
        it_behaves_like 'multiple card sets'
      end
    end
    context 'bad resuest' do
      shared_examples_for 'bad request' do
        it {
          expect(subject.status).to eq 400
          expect(subject.body).to match_json_expression({error:message})
        }
      end
      context 'no card' do
        let(:cards){[]}
        let(:message){'no card'}
        it_behaves_like 'bad request'
      end
      context 'duplicate in one card sets' do
        let(:cards){['D1 H5 S3 C8 d1','S10 H10 C10 D10 H13','H3 H1 H6 H12 H4']}
        let(:message){'same card is included'}
        it_behaves_like 'bad request'
      end
      context 'duplicate between card sets' do
        let(:cards){['D1 H5 S3 C8 H9','S10 H10 C10 D10 H13','H5 H10 H6 H12 H4']}
        let(:message){'card duplicated'}
        it_behaves_like 'bad request'
      end
      context 'too small card set / too much card set' do
        let(:cards){['D1 H5 S3 C8 H9','S10 H10 C10 D10','S5 S1 S6 S12 S4 H13']}
        let(:message){'bad cards'}
        it_behaves_like 'bad request'
      end
    end
  end
end
