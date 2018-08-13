# class UnauthorizedFailureApp
# Used in `config/initializers/devise.rb` to remove redirect 
# from authentication failure behavior.
class UnauthorizedFailureApp < Devise::FailureApp
  def respond
    http_auth
  end
end
