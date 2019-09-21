require 'date'

module V1
  class NotificationsController < ApplicationController
    before_action :authorize_request
    before_action :comprobe_admin, only: :create

    def index
      render json: Notification.all.order(publication_date: :asc)
    end

    def create
      category = notification_params['category']
      title = notification_params['title']
      description = notification_params['description']
      date = notification_params['publication_date']
      publication_date = DateTime.strptime(date, '%d/%m/%Y')
      role = notification_params['role']
      campuses = notification_params['campuses']&.reject(&:blank?)
      grades = notification_params['grades']&.reject(&:blank?)
      groups = notification_params['groups']&.reject(&:blank?)
      family_keys = notification_params['family_keys']&.reject(&:blank?)
      student_names = notification_params['student_names']&.reject(&:blank?)
      event_id = (Notification.last&.event_id&.to_i) || 0
      event_id += 1

      errors = []
      errors << 'Categoria obligatoria' if category.blank?
      errors << 'Categoria obligatoria' if title.blank?
      errors << 'Categoria obligatoria' if description.blank?

      if publication_date.blank? || publication_date < DateTime.now
        errors << 'Fecha vacio o anterior a hoy'
      end

      return render json: { errors: errors }, status: :unauthorized if errors.any?

      kids = Kid.all
      kids = kids.by_campuses(campuses) if campuses.present?
      kids = kids.by_grades(grades) if grades.present?
      kids = kids.by_groups(groups) if groups.present?
      kids = kids.by_family_keys(family_keys) if family_keys.present?
      kids = kids.by_student_names(student_names) if student_names.present?
      users = []
      kids&.each do |kid|
        kid.users.each { |user| users << user }
      end

      @notifications_created = 0
      users&.each do |user|
        notification = Notification.new(category: category, title: title, description: description, campus: user.kids.first.campus,
                                      event_id: event_id, publication_date: publication_date, role: user.role,
                                      grade: grades.join(','), group: groups.join(','), family_key: user.family_key)
        user.notifications << notification
        @notifications_created += 1 if notification.save!
      end

      if @notifications_created.positive?
        render :create
      else
        render json: { errors: Notification&.errors.full_messages }, status: :unauthorized
      end
    end

    def show_by_user_id
      @notifications = User.find(params[user_id])&.notifications
      if @notifications
        render json: @notifications.order(id: :asc)
      else
        head(:unauthorized)
      end
    end

    def update_notification
      @notification = Notification.find(params[:notification_id])
      if @notification.update(notification_params)
        render json: @notification
      else
        head(:unauthorized)
      end
    end

    def notification_counter_by_user_id
      notifications = User.find(params[:user_id])&.notifications
      @seen_notifications = notifications.where(seen: true)&.count || 0
      @not_seen_notifications = (notifications&.count || 0) - @seen_notifications
      render 'counters'
    end

    private

    def notification_params
      params.require(:notification).permit(:category, :title, :description, :publication_date,
                                           :role,:status, :assist, :event_id, :seen,
                                           :campuses => [], :grades => [], :groups => [],
                                            :family_keys => [], :student_names => [])
    end
  end
end