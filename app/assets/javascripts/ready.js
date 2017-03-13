$(function() {
  $('.initialjs-avatar').initial();

  $(document).ajaxStart(function() { Pace.restart(); });
});
