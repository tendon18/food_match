class RestaurantAvoidConditionsController < ApplicationController
  def new
    @group = Group.find(params[:group_id])
    @group_member = @group.group_members.find(params[:group_member_id])
    @restaurant = @group.restaurants.find(params[:restaurant_id])
    @group_avoid_conditions = @group.group_avoid_conditions
  end

  def create
    @group = Group.find(params[:group_id])
    @group_member = @group.group_members.find(params[:group_member_id])
    @restaurant = @group.restaurants.find(params[:restaurant_id])

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
end
