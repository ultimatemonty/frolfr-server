require 'rails_helper'

describe RoundRegistration do
  let(:course) { FactoryBot.create(:course) }
  let(:users) { FactoryBot.create_list(:user, user_count) }
  subject(:round_registration) { described_class.new(course:, users:) }

  before do
    1.upto(hole_count) do |number|
      FactoryBot.create(:hole, course:, number:)
    end
  end

  let(:user_count) { 2 }
  let(:hole_count) { 3 }

  context 'a two player, three hole course' do
    describe '#create_round' do
      it 'creates six turns' do
        turn_count = user_count * hole_count

        expect do
          subject.create_round
        end.to change(Turn, :count).by(turn_count)
      end

      it 'creates two scorecards' do
        expect do
          subject.create_round
        end.to change(Scorecard, :count).by(user_count)
      end

      it 'creates one round' do
        expect do
          subject.create_round
        end.to change(Round, :count).by(1)
      end

      context 'the course has not been played' do
        it 'uses a default par of 3 for any turn' do
          subject.create_round
          expect(Turn.all.sample.par).to eq 3
        end
      end

      context 'the course has been played' do
        before do
          subject.create_round
          first_hole = course.holes.find_by(number: 1)

          Turn.where(hole: first_hole).update_all(par: 4)
        end

        it "uses the previous turn's par" do
          round = subject.create_round
          first_hole = round.holes.find_by(number: 1)

          first_hole.turns.each do |turn|
            expect(turn.par).to eq 4
          end
        end
      end
    end
  end
end
