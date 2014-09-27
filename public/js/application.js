$(document).ready(function(){
  $(document).on('click', 'a', function(e) {
    e.preventDefault();
    link = $(this)

    $.ajax({
      type: 'GET',
      url: link.attr('href'),
      success: function(data) {
        $('#main_content').html(data);
      }
    });
  });

  $(document).on('submit', 'form', function(e) {
    e.preventDefault();
    form = $(this)

    $.ajax({
      type: form.attr('method'),
      data: form.serialize(),
      url: form.attr('action'),
      success: function(data) {
        $('#main_content').html(data);
      }
    });
  });
});
