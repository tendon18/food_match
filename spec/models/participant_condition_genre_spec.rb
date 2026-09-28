require 'rails_helper'

RSpec.describe ParticipantConditionGenre, type: :model do
  describe "関連付け" do
    it "participant_conditionに属する" do
      association = described_class.reflect_on_association(:participant_condition)

      expect(association.macro).to eq(:belongs_to)
      expect(association.class_name).to eq("ParticipantCondition")
    end

    it "group_genreに属する" do
      association = described_class.reflect_on_association(:group_genre)

      expect(association.macro).to eq(:belongs_to)
      expect(association.class_name).to eq("GroupGenre")
    end
  end
end
