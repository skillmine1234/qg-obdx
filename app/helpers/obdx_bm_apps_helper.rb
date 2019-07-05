module ObdxBmAppsHelper
  
  def find_bm_apps(params)
    bm_apps = (params[:approval_status].present? and params[:approval_status] == 'U') ? ObdxBmApp.unscoped : ObdxBmApp
    bm_apps = bm_apps.where("app_id=?",params[:app_id]) if params[:app_id].present?
    bm_apps = bm_apps.where("channel_id=?",params[:channel_id]) if params[:channel_id].present?
    bm_apps
  end
end
