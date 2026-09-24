class Restaurant < ApplicationRecord
  belongs_to :group
  belongs_to :added_by, class_name: "GroupMember"
  belongs_to :group_genre
  belongs_to :group_area
  has_many :restaurant_avoid_conditions

  def budget_score_for(group_member)
    participant_condition = group_member.participant_condition

    return 0 unless participant_condition

    if budget <= participant_condition.budget
      2
    else
      -((budget - participant_condition.budget) / 500)
    end
  end

  def budget_score(group_members)
    group_members.sum do |group_member|
      participant_condition = group_member.participant_condition

      next 0 unless participant_condition

      if budget <= participant_condition.budget
        2
      else
        -((budget - participant_condition.budget) / 500)
      end
    end
  end

  def genre_score_for(group_member)
    participant_condition = group_member.participant_condition

    return 0 unless participant_condition

    if participant_condition.group_genres.include?(group_genre)
      2
    else
      0
    end
  end

  def genre_score(group_members)
    group_members.sum do |group_member|
      participant_condition = group_member.participant_condition

      next 0 unless participant_condition

      if participant_condition.group_genres.include?(group_genre)
        2
      else
        0
      end
    end
  end

  def area_score(group_members)
    group_members.sum do |group_member|
      participant_condition = group_member.participant_condition

      next 0 unless participant_condition

      if participant_condition.group_areas.include?(group_area)
        2
      else
        0
      end
    end
  end

  def area_score_for(group_member)
    participant_condition = group_member.participant_condition

    return 0 unless participant_condition

    if participant_condition.group_areas.include?(group_area)
      2
    else
      0
    end
  end

  def total_score(group_members)
    budget_score(group_members) +
      genre_score(group_members) +
      area_score(group_members)
  end
end
