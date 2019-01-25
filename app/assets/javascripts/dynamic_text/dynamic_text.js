const DynamicText = {
  // Insert Plain Text rather than HTML when pasting into editable text
  insertPlainTextAtCursor(text) {
    var sel, range, html;
    if (window.getSelection) {
      sel = window.getSelection();
      if (sel.getRangeAt && sel.rangeCount) {
        range = sel.getRangeAt(0);
        range.deleteContents();
        range.insertNode(document.createTextNode(text));
      }
    } else if (document.selection && document.selection.createRange) {
      document.selection.createRange().text = text;
    }
  },

  // Copy clipboard data from event and paste into editable text.
  setEventClipboardData(e) {
    const clipboardData = e.clipboardData || e.originalEvent.clipboardData
    if (clipboardData && clipboardData.getData) {
      const text = clipboardData.getData("text/plain")
      document.execCommand("insertHTML", false, text)
      return true
    } else {
      return false
    }
  },

  // Copy clipboard data from window and paste into editable text.
  setWindowClipboardData(e) {
    const clipboardData = window.clipboardData
    if (clipboardData && clipboardData.getData) {
      const text = clipboardData.getData("Text")
      this.insertPlainTextAtCursor(text);
      return true
    } else {
      return false
    }
  },

  // Copy clipboard data from event OR window and paste into editable text.
  handleContentEditablePaste(e) {
    e.preventDefault();
    this.setEventClipboardData(e) || this.setWindowClipboardData()
  },

  // Store all ajax response functions
  ajaxResponses: {
    default: (data) => {}
  },

  // Set default response for ajax requests
  handleDefaultAjaxResponse(func) {
    this.ajaxResponses['default'] = func;
  },

  // Set response for specific js key
  handleAjaxResponseFor(jsKey, func) {
    this.ajaxResponses[jsKey] = func;
  },

  // Build ajax request for patch resource function.
  sendPatchRequest(url, resourceType, attribute, updatedValue, jsKey) {
    const CSRF_TOKEN =
      document.querySelector('meta[name="csrf-token"]')
              .getAttribute('content');

    var xhr = new XMLHttpRequest();
    var successCallback;
    var data = {};

    xhr.open('PATCH', url);

    xhr.setRequestHeader('Accept', 'application/json; charset=utf-8')
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.setRequestHeader('X-CSRF-Token', CSRF_TOKEN);

    xhr.onload = () => {
      if (xhr.status === 200) {
        successCallback =
          this.ajaxResponses[jsKey] || this.ajaxResponses['default']
        successCallback(JSON.parse(xhr.responseText), resourceType)
      }
    };

    data[resourceType] = {}
    data[resourceType][attribute] = updatedValue

    xhr.send(JSON.stringify(data));
  },

  // Update a specific attribute of a resource.
  patchResource(e) {
    const editableText = e.currentTarget;
    const editableTextContainer = editableText.parentNode;
    const action = editableTextContainer.querySelector("[name='_action']");

    const url = action.getAttribute('url');
    const resourceType = action.getAttribute('resource-type');
    const attribute = action.getAttribute('attribute');
    const jsKey = action.getAttribute('js-key');
    const updatedValue = editableText.innerText;

    this.sendPatchRequest(url, resourceType, attribute, updatedValue, jsKey)
  }
}
