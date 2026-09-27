class GroupsController < ApplicationController
  before_action :require_login, only: [:index, :new, :create]
  
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
        role: "organizer",
        nickname: params[:nickname]
      )

      redirect_to group_conditions_area_path(@group)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @group = Group.find(params[:id])

    group_member_id = session[:group_member_ids]&.dig(@group.id.to_s)

    if group_member_id
      @group_member = @group.group_members.find(group_member_id)
    else
      @group_member = @group.group_members.find_by!(role: "organizer")
    end

    @group_members = @group.group_members
  end

  def join
    @group = Group.find_by!(invite_token: params[:invite_token])

    group_member_id = session[:group_member_ids]&.dig(@group.id.to_s)

    if group_member_id
      redirect_to group_path(
        @group,
        group_member_id: group_member_id
      )
    end
  end

  def join_create
    @group = Group.find_by!(invite_token: params[:invite_token])

    group_member = @group.group_members.create!(
      nickname: params[:nickname]
    )

    session[:group_member_ids] ||= {}
    session[:group_member_ids][@group.id.to_s] = group_member.id

    redirect_to new_participant_condition_path(@group, group_member)
  rescue ActiveRecord::RecordNotUnique
    flash.now[:alert] = "※このニックネームはすでに参加しています"
    render :join, status: :unprocessable_entity
  end

  def invitation
    @group = Group.find(params[:group_id])
    @group_member = @group.group_members.find_by!(role: "organizer")
  end

  private

  def group_params
    params.require(:group).permit(:name)
  end
end
