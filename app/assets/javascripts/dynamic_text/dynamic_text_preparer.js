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

    // Update all other divs tagged with the same dynamic-tag as the current text being edited. (So if you have two elements on one page that display the same property of a resource, both will be updated in real time when you edit the text of one.)
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
