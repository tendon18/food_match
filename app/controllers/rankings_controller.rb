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

    @reasons = []

    @group.group_members.each do |group_member|
      participant_condition = group_member.participant_condition

      next unless participant_condition

      if @restaurant.budget <= participant_condition.budget
        @reasons << "#{group_member.nickname}：予算内"
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
  end
end
