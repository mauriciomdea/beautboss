class Api::V1::AuthenticationsController < ApplicationController

  def create

    if user = User.authenticate(params[:email], params[:password])
      @token = Token.get_token(user)
      render json: {token: @token}, status: :created, root: false
    else
      head :not_found
    end

  end

  def create_from_facebook
    params.each do |key,value|
      puts "Param #{key}: #{value}"
    end
    puts "referer: #{request.referrer}"
    user = FbGraph2::User.me("CAAUzZAJppt5EBAHEKR0y0lxSBNnAtAqNGq3l9eHJOKQp4RGDZC8BbQvA3XZAhVqLfHymyerAqskZCphg12Y7tOpNqYES917Wr6mZBWRYPchb9BZBfh891k3xCD8tGDOOwmdQgiF5h3iLdApzPJE2Fa115zABifwkLSY9C0VAxhDiWowSBCJIK5MhCj5azyJ8wFwLAKZA6QsZCgZDZD").fetch
    # user = FbGraph2::User.new('user_id').authenticate("CAAUzZAJppt5EBAHEKR0y0lxSBNnAtAqNGq3l9eHJOKQp4RGDZC8BbQvA3XZAhVqLfHymyerAqskZCphg12Y7tOpNqYES917Wr6mZBWRYPchb9BZBfh891k3xCD8tGDOOwmdQgiF5h3iLdApzPJE2Fa115zABifwkLSY9C0VAxhDiWowSBCJIK5MhCj5azyJ8wFwLAKZA6QsZCgZDZD")
    user.fetch
    puts user.to_yaml
  end

  def destroy

    if Token.destroy_token(params[:id])
      head :no_content
    else
      head :not_found
    end

  end

end
