$(function () {
  // $('#comment_comment').click(function () {
  //   alert("Wow!");
  //   // $(this).parent('form').submit();
  // });  
  $('#comment_comment').bind("enterKey",function(e){
    // $(this).parent('form').submit();
  });
  $('#comment_comment').keyup(function(e){
    if(e.keyCode == 13)
    {
      $(this).trigger("enterKey");
    }
  });
});
