module ObdxBmAppsHelper
  
  def find_bm_apps(params)
    bm_apps = (params[:approval_status].present? and params[:approval_status] == 'U') ? ObdxBmApp.unscoped : ObdxBmApp
    bm_apps = bm_apps.where("LOWER(app_id) LIKE ?", "%#{params[:app_id].downcase}%") if params[:app_id].present?
    bm_apps = bm_apps.where("LOWER(channel_id) LIKE ?", "%#{params[:channel_id].downcase}%") if params[:channel_id].present?
    bm_apps
  end
end
