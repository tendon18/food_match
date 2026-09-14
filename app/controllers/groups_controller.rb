class GroupsController < ApplicationController
  def index
    @groups = current_user.groups
  end

  def new
    @group = Group.new
  end

  def create
    @group = current_user.created_groups.build(group_params)

    if @group.save
      @group.group_members.create!(
        user: current_user,
        role: "organizer"
      )

      redirect_to group_conditions_area_path(@group)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @group = Group.find(params[:id])
  end

  def invitation
    @group = Group.find(params[:group_id])
  end

  private

  def group_params
    params.require(:group).permit(:name)
  end
end
