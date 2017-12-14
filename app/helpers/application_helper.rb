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

  def http_error(code)
  @error =
    case code.to_i
    when 404
      {
        title: 'Page not found',
        body: 'The page you are looking for does not exist. ' \
              'It may have been moved, or removed altogether. ' \
              'Perhaps you can return back to the site’s homepage and ' \
              'see if you can find what you are looking for.'
      }
    when 422
      {
        title: 'The change you wanted was rejected',
        body: "Maybe you tried to change something you didn't " \
              "have access to."
      }
    else
      {
        title: 'Internal server error',
        body: "Oops... looks like there was a problem with one " \
              "of our servers."
      }
    end
  end
end
