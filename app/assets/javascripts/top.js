
$(function(){
  $("#card").on('input', judgeHand)
  function judgeHand(){
    if (this.validity.valid){
      var cards = $(this).val();
      if (cards.length > 0){
        $(this).parent().removeClass("has-error").addClass("has-success")
        sendRequest(cards)
      }
    } else {
      $(this).parent().removeClass("has-success").addClass("has-error")
      $("#hand").hide()
    }
  }

  function sendRequest(cards){
    var data = {
      cards:[cards]
    }
    $.ajax({
      type:"post",
      url:"/api/v1/poker/judge",
      contentType: 'application/json',
      data:JSON.stringify(data),
      dataType: "json",
      success: function(json_data) {   // 200 OK時
        var result = json_data.result[0]
        $("#hand").removeClass("alert-danger").addClass("alert-success")
        $("#hand").html(result.hand).show()
      },
      error: function(req, status) {   // HTTPエラー時
        $("#card").parent().removeClass("has-success").addClass("has-error")
        if (req.status == 400) {
          $("#hand").removeClass("alert-success").addClass("alert-danger")
          $("#hand").html(req.responseJSON.error).show()
        } else {
          alert("Server Error. Pleasy try again later.");
        }
      }
    });
  }

});
