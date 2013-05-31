// init wysiwyg editor
bkLib.onDomLoaded(function() { 
  new nicEditor({buttonList : ['fontFamily','fontSize','bold','italic','underline','center','right','left','justify','link','unlink','forecolor']}).panelInstance('pages_content');
});

$(document).ready( function () {

  $('#page_title').on('change', function() {
    var slug = $(this).val().replace(/[^a-zA-Z0-9-]/g, '-').toLowerCase().replace(/--+/g, '-');
    $('#page_slug').val(slug);
  });

});