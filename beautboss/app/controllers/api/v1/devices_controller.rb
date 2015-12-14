class Api::V1::DevicesController < Api::V1::ApiController
  before_action :authenticate_user

  def create
    verify_user
    device = Device.new(
      user: @current_user,
    )
    device.platform = device_params[:type]
    sns = Aws::SNS::Client.new
    endpoint = sns.create_platform_endpoint(
      platform_application_arn: device.arn, 
      token: device_params[:token])
    device.endpoint = endpoint[:endpoint_arn]
    if device.save
      # test endpoint
      device.push_notification("Device successfully registered!")
      render json: DeviceSerializer.new(device).as_json(root: false), location: "/api/v1/users/#{@current_user.id}/devices", status: 201
    else
      render json: { errors: device.errors.full_messages }, status: 422
    end
  rescue => e 
    logger.error "Api::V1::DevicesController::create: #{e.class.name}: #{e.message}"
    render json: { errors: e.message }, status: 422
  end

  def destroy
    verify_user
    devices = Device.where(platform: device_params[:type], user: @current_user)
    puts devices.to_yaml
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
