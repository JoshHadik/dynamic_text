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

  // Set response for specific ajax key
  handleAjaxResponseFor(ajaxKey, func) {
    this.ajaxResponses[ajaxKey] = func;
  },

  // Build ajax request for patch resource function.
  sendPatchRequest(url, resourceType, attribute, updatedValue, ajaxKey) {
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
          this.ajaxResponses[ajaxKey] || this.ajaxResponses['default']
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
    const ajaxKey = action.getAttribute('ajax-key');
    const updatedValue = editableText.innerText;

    this.sendPatchRequest(url, resourceType, attribute, updatedValue, ajaxKey)
  }
}

const prepareDynamicText = () => {
  document.querySelectorAll('.editable-text').forEach((editableText) => {
    // Exit editable text editor mode (focus) on enter instead of adding a new line.
    editableText.addEventListener('keydown', (e) => {
      if (e.keyCode === 13) {
        e.preventDefault();
        e.currentTarget.blur();
      }
    });

    // Properly paste text into editable text
    editableText.addEventListener('paste', (e) => {
      e.preventDefault();
      DynamicText.handleContentEditablePaste(e)
    });

    // Disable dragging and dropping text/images into editable text.
    ["dragover", "drop"].forEach((evt) => {
      editableText.addEventListener(evt, (e) => {
        e.preventDefault();
        return false;
      });
    });

    // Store original value when focusing in on specific editable text (used to determine if text was changed and patch request should be sent on focusout.)
    editableText.addEventListener('focus', (e) => {
      const target = e.currentTarget;
      target.setAttribute('data-original-value', target.innerText);
    });

    // Send patch request for resource if content was changed.
    editableText.addEventListener('focusout', (e) => {
      const target = e.currentTarget

      // Empty all content of text if editable text is empty (otherwise certain browsers fill in a default <br> or <p> value.)
      if (!target.innerText.trim().length) {
        target.innerText = null;
      }

      // Send patch request if text was changed.
      if (target.getAttribute('data-original-value') != target.innerText) {
        DynamicText.patchResource(e);
      }

      target.removeAttribute('data-original-value')
    });

    // Update all other divs tagged with the same dynamic-tag as the current text being edited. (So if you have two elements on one page that display the same title property of a resource, both will be updated in real time when you edit the text of one.)
    editableText.addEventListener('input', (e) => {
      const target = e.currentTarget;
      const newValue = target.innerText;
      const dynamicTag = target.getAttribute('data-dynamic-tag');

      document.querySelectorAll(`[data-dynamic-tag='${dynamicTag}']`)
        .forEach((dynamicTextElement) => {
          if(dynamicTextElement !== target) {
            dynamicTextElement.innerText = newValue;
          }
        });
    });
  })
}

const events = ["turbolinks:load", "page:change"];

events.forEach((evt) => {
  document.addEventListener(evt, prepareDynamicText)
});
