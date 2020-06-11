class SessionsController < ApplicationController
  before_action :set_session, only: [:show, :edit, :update, :destroy]

  before_action :check_auth, only: [:my_sessions, :all_sessions]
  before_action :decode_token, only: [:my_sessions, :all_sessions]
  before_action :check_admin, only: [:all_sessions]

  #before_action :check_auth, except: [:index]
  #before_action :decode_token, except: [:index, :show]
  #before_action :admin, only: [:all_sessions, :create, :edit, :update, :destroy]

  def show 
    render json: @session
  end

  def index 
    @sessions = Session.where(formation_id: params[:formation_id])
    render json: @sessions
  end

  def all_sessions
    render json: @sessions = Session.all
  end

  def my_sessions
    id = @decoded_token[0]['sub']
    type = @decoded_token[0]['scp']
    @sessions = Session.get_my_sessions(id, type)
    puts @sessions
    render json: @sessions
  end

  def create
    @session = Session.new(session_params)
      if @session.save
        render json: @session, status: :created, location: @session
      else
        render json: @session.errors, status: :unprocessable_entity
      end
  end

  def edit
    render json: @session
  end

  def update
      if @session.update(session_params)
        render json: @session, status: :updated, location: @session
      else
        render json: @session.errors, status: :unprocessable_entity
      end
  end

  def destroy
    @session.destroy
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_session
      @session = Session.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def formation_params
      params.require(:session).permit(:max_student, :date)
    end


end
