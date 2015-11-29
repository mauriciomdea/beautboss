class Api::V1::DevicesController < Api::V1::ApiController
  before_action :authenticate_user

  def create
    verify_user
    device = Device.new(
      user: @current_user,
      device_token: device_params[:token]
    )
    device.device_type = device_params[:type]
    if device.save
      render json: DeviceSerializer.new(device).as_json(root: false), location: "/api/v1/users/#{@current_user.id}/devices", status: 201
    else
      render json: { errors: device.errors.full_messages }, status: 422
    end
  end

  def destroy
    verify_user
    devices = Device.where(device_type: device_params[:type], user: @current_user)
    devices.destroy_all
    head :no_content
  rescue ActiveRecord::RecordNotFound
    _not_found
  end

  private

    def device_params
      params.permit(:type, :token)
    end

end
