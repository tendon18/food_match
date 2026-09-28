require "rails_helper"

RSpec.describe ParticipantCondition, type: :model do
  describe "関連付け" do
    it "GroupMemberに属する" do
      association = described_class.reflect_on_association(:group_member)

      expect(association.macro).to eq(:belongs_to)
      expect(association.class_name).to eq("GroupMember")
    end

    it "ParticipantConditionGenreを複数持つ" do
      association = described_class.reflect_on_association(:participant_condition_genres)

      expect(association.macro).to eq(:has_many)
      expect(association.class_name).to eq("ParticipantConditionGenre")
    end

    it "GroupGenreを複数持つ" do
      association = described_class.reflect_on_association(:group_genres)

      expect(association.macro).to eq(:has_many)
      expect(association.options[:through]).to eq(:participant_condition_genres)
    end

    it "ParticipantConditionAreaを複数持つ" do
      association = described_class.reflect_on_association(:participant_condition_areas)

      expect(association.macro).to eq(:has_many)
      expect(association.class_name).to eq("ParticipantConditionArea")
    end

    it "GroupAreaを複数持つ" do
      association = described_class.reflect_on_association(:group_areas)

      expect(association.macro).to eq(:has_many)
      expect(association.options[:through]).to eq(:participant_condition_areas)
    end

    it "ParticipantConditionAvoidを複数持つ" do
      association = described_class.reflect_on_association(:participant_condition_avoids)

      expect(association.macro).to eq(:has_many)
      expect(association.class_name).to eq("ParticipantConditionAvoid")
    end

    it "GroupAvoidConditionを複数持つ" do
      association = described_class.reflect_on_association(:group_avoid_conditions)

      expect(association.macro).to eq(:has_many)
      expect(association.options[:through]).to eq(:participant_condition_avoids)
    end
  end
end
