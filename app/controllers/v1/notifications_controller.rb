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
      errors << 'Titulo obligatorio' if title.blank?
      errors << 'Descripcion obligatoria' if description.blank?

      if publication_date.blank? || publication_date < Time.now.to_date
        errors << 'Fecha vacio o anterior a hoy'
      end

      core_notification = Notification.new(title: title, description: description, publication_date: publication_date)

      return render json: { errors: errors }, status: :unauthorized if errors.any?
      
      users = []

      if role == 'ADMIN'
        users = User.where(role: 'ADMIN')
        users = users.by_admin_campus(campuses) if campuses.present?
      elsif role == 'PARENT'
        kids = Kid.all
        kids = kids.by_campuses(campuses) if campuses.present?
        kids = kids.by_grades(grades) if grades.present?
        kids = kids.by_groups(groups) if groups.present?
        kids = kids.by_family_keys(family_keys) if family_keys.present?
        kids = kids.by_student_names(student_names) if student_names.present?
        kids&.each do |kid|
          kid.users.each { |user| users << user }
        end
      else
        users = User.all
        users = users.by_admin_campus(campuses) if campuses.present?
        kids = Kid.all
        kids = kids.by_campuses(campuses) if campuses.present?
        kids = kids.by_grades(grades) if grades.present?
        kids = kids.by_groups(groups) if groups.present?
        kids = kids.by_family_keys(family_keys) if family_keys.present?
        kids = kids.by_student_names(student_names) if student_names.present?
        kids&.each do |kid|
          kid.users.each { |user| users << user }
        end
      end

      # Create notifications on db
      @notifications_created = 0
      users&.each do |user|
        notification = user.notifications.new(category: category, title: title, description: description, campus: user.kids&.first&.campus,
                                      event_id: event_id, publication_date: publication_date, role: user.role,
                                      grade: grades.join(','), group: groups.join(','), family_key: user.family_key)
        @notifications_created += 1 if notification.save! && user.save!(validate: false)
      end

      if @notifications_created.positive?
        begin
          notify(users, core_notification)
        rescue

        end
        render :create
      else
        render json: { errors: 'Users not found for notification delivery'}, status: :partial_content
      end
    end

    def show_by_user_id
      @notifications = Notification.where(user_id: params[:user_id])
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
      notifications = Notification.where(user_id: params[:user_id])
      @seen_notifications = notifications.where(seen: true)&.count || 0
      @not_seen_notifications = (notifications&.count || 0) - @seen_notifications
      render 'counters'
    end

    def notifications_group
      @notifications = Notification.all
      @notifications = @notifications.by_role(params['roles']) if params['roles'].present?
      @notifications = @notifications.by_categories(params['categories']) if params['categories'].present?
      @notifications = @notifications.by_title(params['title']) if params['title'].present?
      @notifications = @notifications.by_description(params['description']) if params['description'].present?
      @notifications = @notifications.by_publication_date(params['publication_date']) if params['publication_date'].present?
      @notifications = @notifications.by_campuses(params['campuses']) if params['campuses'].present?
      @notifications = @notifications.by_grades(params['grades']) if params['grades'].present?
      @notifications = @notifications.by_groups(params['groups']) if params['groups'].present?
      @notifications = @notifications.by_family_keys(params['family_keys']) if params['family_keys'].present?
      events = @notifications.distinct.pluck(:event_id)
      @totals = []
      @assists = []
      @views = []
      @not_views = []
      events.each do |event|
        group = Notification.all.where(event_id: event)
        total = group.count
        @totals << total
        assist = group.where(assist: true).count
        @assists << assist
        views = group.where(seen: true).count
        @views << views
        @not_views << total-views
      end
      render 'stats'
    end

    def notify(users, notification)
      devices_ids = []
      users.each do |user|
        devices_ids << user.devices&.pluck(:id)
      end

      devices = Device.where(id: devices_ids)

      if devices.count.positive?
        #get all devices registered in our db and loop through each of them
        devices.each do |device|
          n = Rpush::Gcm::Notification.new
          # use the pushme_droid app we previously registered in our initializer file to send the notification
          n.app = Rpush::Gcm::App.find_by_name("oxford-app-api")
          n.registration_ids = [device.token]

          # parameter for the notification
          n.notification = {
              body: notification.description,
              title: notification.title,
              sound: 'default'
          }
          #save notification entry in the db
          n.save!
        end

        # send all notifications stored in db
        Rpush.push
      end
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