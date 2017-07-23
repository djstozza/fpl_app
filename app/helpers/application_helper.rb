module ApplicationHelper
  def session_link
    if current_user
      link_to('Log out', destroy_user_session_path, :method => :delete)
    else
      link_to('Log in', new_user_session_path)
    end
  end

  def sign_up_link
    link_to('Sign up', new_user_registration_path) unless current_user
  end
end
