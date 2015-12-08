class Api::V1::AuthenticationsController < Api::V1::ApiController

  def create

    if @user = User.find_by(email: params[:email])
      if @user.try(:authenticate, params[:password])
        @token = Token.get_token(@user)
        render json: { user: UserSerializer.new(@user).as_json(root: false), token: @token }, status: :created
      else
        _not_authorized
      end
    else
      _not_found
    end

  end

  def create_from_facebook
    profile = FbGraph2::User.me(params[:access_token]).fetch
    # puts profile.fetch
    @user = User.from_facebook(profile.fetch)
    if @user.save
      @token = Token.get_token(@user)
      render json: { user: UserSerializer.new(@user).as_json(root: false), token: @token }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  rescue FbGraph2::Exception  => err
    render json: {error: err.message}, status: :unprocessable_entity
  end

  def password_reset 
    if user = User.find_by_email(params[:email])
      tmp = TemporaryPassword.create(user: user)
      mail = UserMailer.password_reset(user, tmp.password)
      mail.deliver_now # sends token to user's email
      render json: { message: "Token sent to #{user.email}!" }, status: :ok
    else
      head :not_found
    end
  rescue Exception => err
    puts err.to_s
    render json: {error: err.message}, status: :unprocessable_entity
  end

  def destroy

    if Token.destroy_token(params[:id])
      head :no_content
    else
      head :not_found
    end

  end

end
