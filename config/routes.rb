Rails.application.routes.draw do
  
  resources :obdx_bm_unapproved_records
  resources :obdx_bm_rules
  resources :obdx_bm_billers
  resources :obdx_bm_bill_payments
  resources :obdx_bm_aggregator_payments
  resources :obdx_bm_apps
  
  resources :obdx_reports do 
    collection do 
      get 'html_report'
      get 'csv_reports'
    end
  end

  resources :obdx_bm_bill_payments_summaries, only: [:index]
  
  get '/obdx_bm_biller/:id/audit_logs' => 'obdx_bm_billers#audit_logs'
  get '/obdx_bm_rule/:id/audit_logs' => 'obdx_bm_rules#audit_logs'
  get '/obdx_bm_aggregator_payment/:id/audit_logs' => 'obdx_bm_aggregator_payments#audit_logs'
  get '/obdx_bm_app/:id/audit_logs' => 'obdx_bm_apps#audit_logs'
  put '/obdx_bm_biller/:id/approve' => "obdx_bm_billers#approve"
  put '/obdx_bm_rule/:id/approve' => "obdx_bm_rules#approve"
  put '/obdx_bm_aggregator_payment/:id/approve' => "obdx_bm_aggregator_payments#approve"
  put '/obdx_bm_app/:id/approve' => "obdx_bm_apps#approve"
  get '/obdx_bm_bill_payments/:id/audit_logs/:step_name' => 'obdx_bm_bill_payments#audit_logs'
  #get '/bm_aggregator_payment/hit_api/:id' => 'bm_aggregator_payments#hit_api', as: :hit_api

  get "payment_schedules/index"
  get "payment_schedules/auto"
  get "payment_schedules/schedule"

end
