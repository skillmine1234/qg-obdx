require "qg/obdx/engine"

module Qg
  module Obdx
    NAME = 'Bill Management 2.0'
    GROUP = 'Obdx'
    MENU_ITEMS = [:obdx_bm_rule, :obdx_bm_biller, :obdx_bm_bill_payment, :obdx_bm_app, :obdx_bm_bill_payments_summary]
    MODELS = ['ObdxBmRule','ObdxBmBiller','ObdxBmBillPayment','ObdxBmApp','ObdxBmUnapprovedRecord','ObdxBmBillPaymentsSummary']
    TEST_MENU_ITEMS = []
    COMMON_MENU_ITEMS = [:reports]
    OBDX_OPERATIONS = ["present"]
  end
end