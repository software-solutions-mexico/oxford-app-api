module V1
  class KidsController < ApplicationController
    before_action :authorize_request
    before_action :permission, only: :create
    before_action :comprobe_admin, only: :index

    def index
      render json: Kid.all.order(name: :asc)
    end

    def create
      @kid = Kid.new(kid_params)

      if @kid.save
        render json: @kid
      else
        render json: @kid.errors, status: :unprocessable_entity
      end
    end

    def import_data_from_excel
      workbook = Roo::Excel.new(params[:file].path, file_warning: :ignore)
      workbook.default_sheet = workbook.sheets[0]
      headers = Hash.new
      workbook.row(1).each_with_index {|header,i|
        headers[header] = i
      }

      @kids_created = 0
      @kids_not_created = 0
      ((workbook.first_row + 1)..workbook.last_row).each do |row|
        family_key = workbook.row(row)[headers['clafamilia']].to_i.to_s
        student_id = workbook.row(row)[headers['matricula']].to_s.strip
        full_name = workbook.row(row)[headers['Alumno']].strip
        father_last_name = workbook.row(row)[headers['appaterno']].strip
        mother_last_name = workbook.row(row)[headers['apmaterno']].strip
        name = workbook.row(row)[headers['nombre']].strip
        campus = workbook.row(row)[headers['Campus']].strip
        grade = workbook.row(row)[headers['Grado']].to_s.strip
        group = workbook.row(row)[headers['Grupo']].to_s.strip

        if Kid.where(student_id: student_id, family_key: family_key).any?
          @kids_not_created += 1
        else
          kid = Kid.new(family_key: family_key, student_id: student_id, full_name: full_name,
          father_last_name: father_last_name, mother_last_name: mother_last_name, name: name,
                  campus: campus, grade: grade, group: group)
          if kid.save
            @kids_created += 1
          else
            @kids_not_created += 1
          end
        end

      end

      render :create_from_excel
    end

    def show
      @kid = Kid.find(params[:id])
      if @kid && show_kid?
        render json: @kid
      else
        head(:unauthorized)
      end
    end

    def show_by_family_key
      @kids = Kid.where(family_key: params[:family_key])
      if @kids && show_kid?
        render json: @kids.order(name: :asc)
      else
        head(:unauthorized)
      end
    end

    def update
      @kid = Kid.find(params[:id])
      if current_user.is_admin?
        if @kid.update(kid_params)
          render json: @kid
        else
          render json: @kid.errors, status: :unprocessable_entity
        end
      else
        errors.add('User', 'not authorized')
        head :unauthorized
      end
    end

    private

    def kid_params
      params.require(:kid).permit(:full_name, :name, :father_last_name, :mother_last_name, :grade, :group, :family_key, :campus, :student_id)
    end

    def permission
      head :unauthorized if current_user&.role != 'ADMIN'
    end

    def show_kid?
      current_user.is_admin? || current_user.kids.where(id: @kids).any?
    end
  end
end