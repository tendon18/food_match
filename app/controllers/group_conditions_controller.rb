class GroupConditionsController < ApplicationController
  before_action :set_group
  before_action :require_organizer

  TOKYO_AREAS = [
    "新宿",
    "渋谷",
    "池袋",
    "吉祥寺",
    "中野",
    "東京駅",
    "上野",
    "恵比寿"
  ].freeze

  GENRES = [
    "和食",
    "洋食",
    "中華",
    "イタリアン",
    "フレンチ",
    "焼肉",
    "居酒屋",
    "カフェ"
  ].freeze

  # Step 1
  def area
    @areas = TOKYO_AREAS
  end

  # Step 1 保存
  def save_area
    @group.group_areas.destroy_all

    params[:areas].each do |area|
      next if area.blank?

      @group.group_areas.create!(area: area)
    end

    redirect_to group_conditions_genre_path(@group)
  end

  # Step 2
  def genre
    @genres = GENRES
  end

  # Step 2 保存
  def save_genre
    @group.group_genres.destroy_all

    params[:genres].each do |genre|
      next if genre.blank?

      @group.group_genres.create!(genre: genre)
    end

    redirect_to group_conditions_budget_path(@group)
  end

  # Step 3
  def budget
  end

  # Step 3 保存
  def save_budget
    @group.update!(budget: params[:budget])

    redirect_to group_conditions_ng_path(@group)
  end

  # Step 4
  def ng
  end

  # Step 4 保存
  def save_ng
    @group.group_ng_conditions.destroy_all

    params[:conditions]&.each do |condition|
      @group.group_ng_conditions.create!(
        condition: condition,
        status: "avoid"
      )
    end

    redirect_to group_path(@group)
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def require_organizer
    return if @group.creator == current_user

    redirect_to group_path(@group), alert: "幹事のみ設定を変更できます"
  end
end
