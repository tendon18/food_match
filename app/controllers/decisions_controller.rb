class DecisionsController < ApplicationController
  def show
    @group = Group.find(params[:group_id])
    @group_member = @group.group_members.find(params[:group_member_id])
    @restaurant = @group.restaurants.find(params[:restaurant_id])
  end

  def update
  end

  def complete
  end
end
