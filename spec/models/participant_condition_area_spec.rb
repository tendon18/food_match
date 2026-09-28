require 'rails_helper'

RSpec.describe ParticipantConditionArea, type: :model do
  describe "関連付け" do
    it "participant_conditionに属する" do
      association = described_class.reflect_on_association(:participant_condition)

      expect(association.macro).to eq(:belongs_to)
      expect(association.class_name).to eq("ParticipantCondition")
    end

    it "group_areaに属する" do
      association = described_class.reflect_on_association(:group_area)

      expect(association.macro).to eq(:belongs_to)
      expect(association.class_name).to eq("GroupArea")
    end
  end
end
