const delegateToEditableText = (eventType, callback) => {
  document.addEventListener(eventType, (event) => {
    if (event.target.classList.contains('editable-text')) {
      callback(event);
    }
  });
}

const prepareDynamicText = () => {
  // Exit editable text editor mode (focus) on enter instead of adding a new line.
  delegateToEditableText('keydown', (event) => {
    if (event.keyCode === 13) {
      event.preventDefault();
      event.target.blur();
    }
  });

  // Properly paste text into editable text
  delegateToEditableText('paste', (event) => {
    event.preventDefault();
    DynamicText.handleContentEditablePaste(event)
  });

  // Disable dragging and dropping text/images into editable text.
  ["dragover", "drop"].forEach((evt) => {
    delegateToEditableText(evt, (event) => {
      event.preventDefault();
      return false;
    });
  });

  // Store original value when focusing in on specific editable text (used to determine if text was changed and patch request should be sent on focusout.)
  delegateToEditableText('focus', (event) => {
    const target = event.target;
    target.setAttribute('data-original-value', target.innerText);
  });

  // Send patch request for resource if content was changed.
  delegateToEditableText('focusout', (event) => {
    const target = event.target;

    // Empty all content of text if editable text is empty (otherwise certain browsers fill in a default <br> or <p> value.)
    if (!target.innerText.trim().length) {
      target.innerText = null;
    }

    // TODO: Change patchResource to accept the target
    // Send patch request if text was changed.
    if (target.getAttribute('data-original-value') != target.innerText) {
      DynamicText.patchResource(target);
    }

    target.removeAttribute('data-original-value')
  });

  // Update all other divs tagged with the same dynamic-tag as the current text being edited. (So if you have two elements on one page that display the same property of a resource, both will be updated in real time when you edit the text of one.)
  delegateToEditableText('input', (event) => {
    const target = event.currentTarget;
    const newValue = target.innerText;
    const dynamicTag = target.getAttribute('data-dynamic-tag');

    document.querySelectorAll(`[data-dynamic-tag='${dynamicTag}']`)
      .forEach((dynamicTextElement) => {
        if(dynamicTextElement !== target) {
          dynamicTextElement.innerText = newValue;
        }
      });
  });
}
