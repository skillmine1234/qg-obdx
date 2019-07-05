$(document).ready(function(){

  $("#bm_biller_num_params").on("change",function(){
    var num_params =  $(this).val();
    if (num_params == 0){
      for (var i=1; i<=5; i++) {
        $('#bm_biller_param' + i + '_name').val('');
        $('#bm_biller_param' + i + '_name').prop('disabled',true);
        $('#bm_biller_param' + i + '_pattern').val('');
        $('#bm_biller_param' + i + '_pattern').prop('disabled',true);
        $('#bm_biller_param' + i + '_tooltip').val('');
        $('#bm_biller_param' + i + '_tooltip').prop('disabled',true);
      }
    }
    else if (num_params == 1) {
      $('#bm_biller_param1_name').prop('disabled',false);
      $('#bm_biller_param1_pattern').prop('disabled',false);
      $('#bm_biller_param1_tooltip').prop('disabled',false);
      
      for (var i=2; i<=5; i++) {
        $('#bm_biller_param' + i + '_name').val('');
        $('#bm_biller_param' + i + '_name').prop('disabled',true);
        $('#bm_biller_param' + i + '_pattern').val('');
        $('#bm_biller_param' + i + '_pattern').prop('disabled',true);
        $('#bm_biller_param' + i + '_tooltip').val('');
        $('#bm_biller_param' + i + '_tooltip').prop('disabled',true);
      } 
    }
    else if (num_params == 2) {
      for (var i=1; i<=2; i++) {
        $('#bm_biller_param' + i + '_name').prop('disabled',false);
        $('#bm_biller_param' + i + '_pattern').prop('disabled',false);
        $('#bm_biller_param' + i + '_tooltip').prop('disabled',false);
      }
      for (var i=3; i<=5; i++) {
        $('#bm_biller_param' + i + '_name').val('');
        $('#bm_biller_param' + i + '_name').prop('disabled',true);
        $('#bm_biller_param' + i + '_pattern').val('');
        $('#bm_biller_param' + i + '_pattern').prop('disabled',true);
        $('#bm_biller_param' + i + '_tooltip').val('');
        $('#bm_biller_param' + i + '_tooltip').prop('disabled',true);
      } 
    }
    else if (num_params == 3) {
      for (var i=1; i<=3; i++) {
        $('#bm_biller_param' + i + '_name').prop('disabled',false);
        $('#bm_biller_param' + i + '_pattern').prop('disabled',false);
        $('#bm_biller_param' + i + '_tooltip').prop('disabled',false);
      }
      for (var i=4; i<=5; i++) {
        $('#bm_biller_param' + i + '_name').val('');
        $('#bm_biller_param' + i + '_name').prop('disabled',true);
        $('#bm_biller_param' + i + '_pattern').val('');
        $('#bm_biller_param' + i + '_pattern').prop('disabled',true);
        $('#bm_biller_param' + i + '_tooltip').val('');
        $('#bm_biller_param' + i + '_tooltip').prop('disabled',true);
      }      
    }
    else if (num_params == 4) {
      for (var i=1; i<=4; i++) {
        $('#bm_biller_param' + i + '_name').prop('disabled',false);
        $('#bm_biller_param' + i + '_pattern').prop('disabled',false);
        $('#bm_biller_param' + i + '_tooltip').prop('disabled',false);
      }
      $('#bm_biller_param5_name').val('');
      $('#bm_biller_param5_name').prop('disabled',true);
      $('#bm_biller_param5_pattern').val('');
      $('#bm_biller_param5_pattern').prop('disabled',true);
      $('#bm_biller_param5_tooltip').val('');
      $('#bm_biller_param5_tooltip').prop('disabled',true);
    }
    else if (num_params == 5) {
      for (var i=1; i<=5; i++) {
        $('#bm_biller_param' + i + '_name').prop('disabled',false);
        $('#bm_biller_param' + i + '_pattern').prop('disabled',false);
        $('#bm_biller_param' + i + '_tooltip').prop('disabled',false);
      }
    }
  });
  
  if ($('#bm_biller_num_params').val() == 0){
    for (var i=1; i<=5; i++) {
      $('#bm_biller_param' + i + '_name').val('');
      $('#bm_biller_param' + i + '_name').prop('disabled',true);
      $('#bm_biller_param' + i + '_pattern').val('');
      $('#bm_biller_param' + i + '_pattern').prop('disabled',true);
      $('#bm_biller_param' + i + '_tooltip').val('');
      $('#bm_biller_param' + i + '_tooltip').prop('disabled',true);
    }
  }
  else if ($('#bm_biller_num_params').val() == 1) {
    $('#bm_biller_param1_name').prop('disabled',false);
    $('#bm_biller_param1_pattern').prop('disabled',false);
    $('#bm_biller_param1_tooltip').prop('disabled',false);
    
    for (var i=2; i<=5; i++) {
      $('#bm_biller_param' + i + '_name').val('');
      $('#bm_biller_param' + i + '_name').prop('disabled',true);
      $('#bm_biller_param' + i + '_pattern').val('');
      $('#bm_biller_param' + i + '_pattern').prop('disabled',true);
      $('#bm_biller_param' + i + '_tooltip').val('');
      $('#bm_biller_param' + i + '_tooltip').prop('disabled',true);
    } 
  }
  else if ($('#bm_biller_num_params').val() == 2) {
    for (var i=1; i<=2; i++) {
      $('#bm_biller_param' + i + '_name').prop('disabled',false);
      $('#bm_biller_param' + i + '_pattern').prop('disabled',false);
      $('#bm_biller_param' + i + '_tooltip').prop('disabled',false);
    }
    for (var i=3; i<=5; i++) {
      $('#bm_biller_param' + i + '_name').val('');
      $('#bm_biller_param' + i + '_name').prop('disabled',true);
      $('#bm_biller_param' + i + '_pattern').val('');
      $('#bm_biller_param' + i + '_pattern').prop('disabled',true);
      $('#bm_biller_param' + i + '_tooltip').val('');
      $('#bm_biller_param' + i + '_tooltip').prop('disabled',true);
    } 
  }
  else if ($('#bm_biller_num_params').val() == 3) {
    for (var i=1; i<=3; i++) {
      $('#bm_biller_param' + i + '_name').prop('disabled',false);
      $('#bm_biller_param' + i + '_pattern').prop('disabled',false);
      $('#bm_biller_param' + i + '_tooltip').prop('disabled',false);
    }
    for (var i=4; i<=5; i++) {
      $('#bm_biller_param' + i + '_name').val('');
      $('#bm_biller_param' + i + '_name').prop('disabled',true);
      $('#bm_biller_param' + i + '_pattern').val('');
      $('#bm_biller_param' + i + '_pattern').prop('disabled',true);
      $('#bm_biller_param' + i + '_tooltip').val('');
      $('#bm_biller_param' + i + '_tooltip').prop('disabled',true);
    }      
  }
  else if ($('#bm_biller_num_params').val() == 4) {
    for (var i=1; i<=4; i++) {
      $('#bm_biller_param' + i + '_name').prop('disabled',false);
      $('#bm_biller_param' + i + '_pattern').prop('disabled',false);
      $('#bm_biller_param' + i + '_tooltip').prop('disabled',false);
    }
    $('#bm_biller_param5_name').val('');
    $('#bm_biller_param5_name').prop('disabled',true);
    $('#bm_biller_param5_pattern').val('');
    $('#bm_biller_param5_pattern').prop('disabled',true);
    $('#bm_biller_param5_tooltip').val('');
    $('#bm_biller_param5_tooltip').prop('disabled',true);
  }
  else if ($('#bm_biller_num_params').val() == 5) {
    for (var i=1; i<=5; i++) {
      $('#bm_biller_param' + i + '_name').prop('disabled',false);
      $('#bm_biller_param' + i + '_pattern').prop('disabled',false);
      $('#bm_biller_param' + i + '_tooltip').prop('disabled',false);
    }
  }
  
});