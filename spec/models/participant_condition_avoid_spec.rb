require 'rails_helper'

RSpec.describe ParticipantConditionAvoid, type: :model do
  describe "重複登録" do
    it "同じ参加者条件とNG条件の組み合わせを2回登録できない" do
      group_member = create(:group_member)

      participant_condition = ParticipantCondition.create!(
        group_member: group_member,
        budget: 3000
      )

      group_avoid_condition = GroupAvoidCondition.create!(
        group: group_member.group,
        condition: "辛い料理"
      )

      ParticipantConditionAvoid.create!(
        participant_condition: participant_condition,
        group_avoid_condition: group_avoid_condition
      )

      expect {
        ParticipantConditionAvoid.create!(
          participant_condition: participant_condition,
          group_avoid_condition: group_avoid_condition
        )
      }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end

  describe "関連付け" do
    it "participant_conditionに属する" do
      association = described_class.reflect_on_association(:participant_condition)

      expect(association.macro).to eq(:belongs_to)
      expect(association.class_name).to eq("ParticipantCondition")
    end

    it "group_avoid_conditionに属する" do
      association = described_class.reflect_on_association(:group_avoid_condition)

      expect(association.macro).to eq(:belongs_to)
      expect(association.class_name).to eq("GroupAvoidCondition")
    end
  end
end
