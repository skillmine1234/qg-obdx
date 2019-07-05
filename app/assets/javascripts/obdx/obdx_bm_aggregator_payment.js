$(document).ready(function(){

	$(".fault-link").on("click", function () {
	  $('#faultText').modal();
	});
	
  var clip1 = new ZeroClipboard($("#d_clip_button1"));
  var clip2 = new ZeroClipboard($("#d_clip_button2"));
  
  $('#bm_aggregator_payment_cod_acct_no').prop('readOnly',true);
  $('#bm_aggregator_payment_neft_sender_ifsc').prop('readOnly',true);
  $('#bm_aggregator_payment_bene_acct_no').prop('readOnly',true);
  $('#bm_aggregator_payment_bene_acct_ifsc').prop('readOnly',true);
  $('#bm_aggregator_payment_customer_id').prop('readOnly',true);
  $('#bm_aggregator_payment_service_id').prop('readOnly',true);
	
});