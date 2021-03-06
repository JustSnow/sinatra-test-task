$(document).ready(function(){
  $(document).on('click', 'a', function(e) {
    e.preventDefault();
    link = $(this)

    $.ajax({
      type: 'GET',
      url: link.attr('href'),
      success: function(data) {
        window.history.pushState('', link.data('title'), link.attr('href'));
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
      success: function(data, textStatus, jqXHR) {
        if (form.attr('method').toLowerCase() == 'get') {
          href = 'http://' + window.location.host + '/?' + form.serialize()
          window.history.pushState('', form.data('title'), href);
        }

        $('#main_content').html(data);
      },
      error: function(data) {
        alert(form.data('error-message'));
      }
    });
  });
});
