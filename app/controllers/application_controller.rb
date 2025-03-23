class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  include SessionsHelper
  include UsersHelper

  # Устанавливаем локаль перед каждым запросом
  before_action :set_locale

  def toggle_locale
    new_locale = I18n.locale == :ru ? :en : :ru
    referer_url = request.referer || root_path(locale: new_locale)
    new_url = referer_url.sub(/\/(ru|en)/, "/#{new_locale}")
    redirect_to new_url
  end

  private

  def set_locale
    # Пропускаем API-контроллеры
    return if request.path.start_with?('/api')

    if params[:locale].blank?
      redirect_to url_for(locale: I18n.default_locale)
    else
      I18n.locale = params[:locale]
    end
  end

  # Автоматически добавляем текущую локаль во все URL
  def default_url_options
    { locale: I18n.locale }
  end
end