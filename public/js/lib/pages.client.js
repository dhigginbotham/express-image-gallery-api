  // init wysiwyg editor
  bkLib.onDomLoaded(function() { 
    new nicEditor({buttonList : ['fontFamily','fontSize','bold','italic','underline','center','right','left','justify','link','unlink','forecolor']}).panelInstance('pages_content');
  });
