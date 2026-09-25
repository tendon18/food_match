class RankingsController < ApplicationController
  def show
    @group = Group.find(params[:group_id])
    @group_member = @group.group_members.find(params[:group_member_id])

    @restaurants = @group.restaurants.reject do |restaurant|
      @group.group_members.any? do |group_member|
        participant_condition = group_member.participant_condition

        next false unless participant_condition

        participant_condition.participant_condition_avoids.any? do |participant_avoid|
          restaurant.restaurant_avoid_conditions.any? do |restaurant_avoid|
            participant_avoid.group_avoid_condition_id == restaurant_avoid.group_avoid_condition_id &&
              restaurant_avoid.status == "applicable"
          end
        end
      end
    end

    @total_scores = {}

    @restaurants.each do |restaurant|
      @total_scores[restaurant.id] =
        restaurant.total_score(@group.group_members)
    end

    @restaurants = @restaurants.sort_by do |restaurant|
      -@total_scores[restaurant.id]
    end
  end

  def score
    @group = Group.find(params[:group_id])
    @group_member = @group.group_members.find(params[:group_member_id])
    @restaurant = @group.restaurants.find(params[:restaurant_id])
    @total_score = @restaurant.total_score(@group.group_members)

    budget_members = @group.group_members.select do |group_member|
      group_member.participant_condition
    end

    within_budget_count = budget_members.count do |group_member|
      @restaurant.budget <= group_member.participant_condition.budget
    end

    @budget_reason =
      "#{budget_members.count}人中#{within_budget_count}人が予算以内"

    genre_match_count = @group.group_members.count do |group_member|
      participant_condition = group_member.participant_condition

      participant_condition &&
        participant_condition.group_genres.include?(@restaurant.group_genre)
      end

    @genre_reason =
      "#{genre_match_count}人が希望ジャンルと一致"

    area_match_count = @group.group_members.count do |group_member|
      participant_condition = group_member.participant_condition

      participant_condition &&
        participant_condition.group_areas.include?(@restaurant.group_area)
    end

    @area_reason =
      "希望エリア「#{@restaurant.group_area.area}」と一致"

    @reasons = []

    @group.group_members.each do |group_member|
      participant_condition = group_member.participant_condition

      next unless participant_condition

      if @restaurant.budget <= participant_condition.budget
        @reasons << "#{group_member.nickname}：予算内"
      else
        over_budget = @restaurant.budget - participant_condition.budget
        @reasons << "#{group_member.nickname}：予算を#{over_budget}円超過"
      end

      if participant_condition.group_genres.include?(@restaurant.group_genre)
        @reasons << "#{group_member.nickname}：ジャンルが一致"
      end

      if participant_condition.group_areas.include?(@restaurant.group_area)
        @reasons << "#{group_member.nickname}：エリアが一致"
      end

      if participant_condition.participant_condition_avoids.all? do |participant_avoid|
        restaurant_avoid = @restaurant.restaurant_avoid_conditions.find do |restaurant_avoid|
          restaurant_avoid.group_avoid_condition_id ==
            participant_avoid.group_avoid_condition_id
        end

        restaurant_avoid.nil? || restaurant_avoid.status == "not_applicable"
      end
        @reasons << "#{group_member.nickname}：NG条件に該当しない"
      end
    end

    @member_scores = {}

    @group.group_members.each do |group_member|
      @member_scores[group_member.id] =
        @restaurant.budget_score_for(group_member) +
        @restaurant.genre_score_for(group_member) +
        @restaurant.area_score_for(group_member)
    end
  end
end
