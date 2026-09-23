class RestaurantsController < ApplicationController
  def new
    @group = Group.find(params[:group_id])
    @group_member = @group.group_members.find(params[:group_member_id])

    @restaurant = Restaurant.new

    @group_genres = @group.group_genres
    @group_areas = @group.group_areas
  end

  def create
    @group = Group.find(params[:group_id])

    group_member = @group.group_members.find(params[:group_member_id])

    restaurant = Restaurant.create!(
      group: @group,
      added_by: group_member,
      name: params[:restaurant][:name],
      budget: params[:budget],
      group_genre_id: params[:group_genre_id],
      group_area_id: params[:group_area_id],
      features: params[:restaurant][:features],
      url: params[:restaurant][:url],
      memo: params[:restaurant][:memo]
    )

    redirect_to restaurant_complete_path(
      @group,
      restaurant,
      group_member_id: group_member.id
    )
  end

  def index
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

    @budget_scores = {}

    @restaurants.each do |restaurant|
      @budget_scores[restaurant.id] =
        restaurant.budget_score(@group.group_members)
    end
  end

  def complete
    @group = Group.find(params[:group_id])
    @restaurant = @group.restaurants.find(params[:id])
  end

  def show
    @group = Group.find(params[:group_id])
    @group_member = @group.group_members.find(params[:group_member_id])
    @restaurant = @group.restaurants.find_by(id: params[:id])

    unless @restaurant
      redirect_to group_restaurants_index_path(
        @group,
        group_member_id: @group_member.id
      ) and return
    end
  end

  def edit
    @group = Group.find(params[:group_id])
    @group_member = @group.group_members.find(params[:group_member_id])
    @restaurant = @group.restaurants.find(params[:id])

    unless @restaurant.added_by == @group_member
      redirect_to restaurant_path(
        @group,
        @restaurant,
        group_member_id: @group_member.id
      ) and return
    end

    @group_genres = @group.group_genres
    @group_areas = @group.group_areas
  end

  def update
    @group = Group.find(params[:group_id])
    @group_member = @group.group_members.find(params[:group_member_id])
    @restaurant = @group.restaurants.find(params[:id])

    unless @restaurant.added_by == @group_member
      redirect_to restaurant_path(
        @group,
        @restaurant,
        group_member_id: @group_member.id
      ) and return
    end

    @restaurant.update!(
      name: params[:name],
      budget: params[:budget],
      group_genre_id: params[:group_genre_id],
      group_area_id: params[:group_area_id],
      features: params[:features],
      url: params[:url],
      memo: params[:memo]
    )

    redirect_to restaurant_path(
      @group,
      @restaurant,
      group_member_id: @group_member.id
    )
  end

  def destroy
    @group = Group.find(params[:group_id])
    @group_member = @group.group_members.find(params[:group_member_id])
    @restaurant = @group.restaurants.find(params[:id])

    unless @restaurant.added_by == @group_member
      redirect_to restaurant_path(
        @group,
        @restaurant,
        group_member_id: @group_member.id
      ) and return
    end

    @restaurant.destroy!

    redirect_to group_restaurants_index_path(
      @group,
      group_member_id: @group_member.id
    )
  end
end
