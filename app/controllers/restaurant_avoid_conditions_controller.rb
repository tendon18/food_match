class RestaurantAvoidConditionsController < ApplicationController
  before_action :set_group_and_member
  before_action :set_restaurant
  before_action :require_restaurant_owner

  def new
    @group_avoid_conditions = @group.group_avoid_conditions
  end

  def edit
    @group_avoid_conditions = @group.group_avoid_conditions
    @restaurant_avoid_conditions = @restaurant.restaurant_avoid_conditions
  end

  def update
    params[:conditions]&.each do |group_avoid_condition_id, status|
      restaurant_avoid_condition = @restaurant.restaurant_avoid_conditions.find_by(
        group_avoid_condition_id: group_avoid_condition_id
      )

      if restaurant_avoid_condition
        restaurant_avoid_condition.update!(status: status)
      end
    end

    redirect_to restaurant_path(
      @group,
      @restaurant,
      group_member_id: @group_member.id
    )
  end

  def create
    params[:conditions]&.each do |group_avoid_condition_id, status|
      @restaurant.restaurant_avoid_conditions.create!(
        group_avoid_condition_id: group_avoid_condition_id,
        status: status
      )
    end

    redirect_to restaurant_path(
      @group,
      @restaurant,
      group_member_id: @group_member.id
    )
  end

  private

  def set_group_and_member
    @group = Group.find(params[:group_id])
    @group_member = @group.group_members.find(params[:group_member_id])
  end

  def set_restaurant
    @restaurant = @group.restaurants.find(params[:restaurant_id])
  end

  def require_restaurant_owner
    unless @restaurant.added_by == @group_member
      redirect_to group_restaurants_index_path(
        @group,
        group_member_id: @group_member.id
      ) and return
    end
  end
end
