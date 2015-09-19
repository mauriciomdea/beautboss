class Api::V1::AuthenticationsController < ApplicationController

  def create

    if @user = User.authenticate(params[:email], params[:password])
      @token = Token.get_token(@user)
      render json: { user: UserSerializer.new(@user).as_json(root: false), token: @token }, status: :created
    else
      head :not_found
    end

  end

  def create_from_facebook
    profile = FbGraph2::User.me(params[:access_token]).fetch
    profile.fetch
    @user = User.where(email: profile.email).assign_or_new(
              facebook: profile.id,
              email: profile.email, 
              name: "#{profile.first_name} #{profile.last_name}",
              bio: profile.bio,
              avatar: profile.picture.url,
              website: profile.website,
              location: profile.location.name)
    if @user.save
      @token = Token.get_token(@user)
      render json: { user: UserSerializer.new(@user).as_json(root: false), token: @token }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  rescue FbGraph2::Exception  => err
    render json: {error: err.message}, status: :unprocessable_entity
  end

  def password_reset 
    if user = User.find_by_email(params[:email])
      token = Token.get_token(user, 2) # gets a token that expires after 2 days
      UserMailer.password_reset(user, token).deliver_now # sends token to user's email
      render json: {message: "Token sent to #{user.email}!"}, status: :ok
    else
      head :not_found
    end
  rescue Exception => err
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
