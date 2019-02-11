# Do It Yourself

## What's The Plan?

Ok. The Basic Plan:

1. Make a Rails helper method that generates the HTML needed to allow for editable text.
2. Use JavaScript Event Handlers to create an AJAX Patch request when a user edits the text for an attribute.

That's basically it.

## HTML requirements

We're gonna be using the Content Editable HTML property to create editable elements:

```html
<span contenteditable>This text is editable on the DOM.</span>
```

Unfortunately, contenteditable has a few less than ideal behaviors by default. The first is that when you paste text into it, it keeps all of the original HTML elements instead of just the plain text, which can lead to situations like this:

Luckilly, we can get around this in javascript:

```javascript

// Insert Plain Text rather than HTML when pasting into editable text
function insertPlainTextAtCursor(text) {
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
}

// Copy clipboard data from event and paste into editable text.
function setEventClipboardData(e) {
  const clipboardData = e.clipboardData || e.originalEvent.clipboardData
  if (clipboardData && clipboardData.getData) {
    const text = clipboardData.getData("text/plain")
    document.execCommand("insertHTML", false, text)
    return true
  } else {
    return false
  }
}

// Copy clipboard data from window and paste into editable text.
function setWindowClipboardData(e) {
  const clipboardData = window.clipboardData
  if (clipboardData && clipboardData.getData) {
    const text = clipboardData.getData("Text")
    this.insertPlainTextAtCursor(text);
    return true
  } else {
    return false
  }
}

// Copy clipboard data from event OR window and paste into editable text.
function handleContentEditablePaste(e) {
  e.preventDefault();
  this.setEventClipboardData(e) || this.setWindowClipboardData()
}

function ready () {
  document.querySelectorAll('.editable-text').forEach((editableText) => {
    // Properly paste text into editable text
    editableText.addEventListener('paste', (e) => {
      e.preventDefault();
      DynamicText.handleContentEditablePaste(e)
    });
  });
}

document.addEventListener("turbolinks:load", ready)
document.addEventListener("page:change", ready)

```

This solves the problem when pasting text directly into the contenteditable span, however, you can also drag and drop text into the contenteditable span, and the javascript above doesn't handle that case. Rather than updating the logic above to handle drag and drop, we're just gonna disable the functionality completely by adding the following to the ready function from above:

```javascript

function ready () {
  // Old text...

  ["dragover", "drop"].forEach((evt) => {
    editableText.addEventListener(evt, (e) => {
      e.preventDefault();
      return false;
    });
  });
}

```

Great... Now that that's out of the way, let's move onto the real stuff:

## The HTML PLAN:

Basic HTML

We're gonna use Rails helpers and partials to actually generate the html code, but before we get into that lets take a look at how the end result for an editable text field would look:

```html
<span class="editable-text-container">
  <span class="editable-text" contentEditable>
    Oh The Places You'll Go!
  </span>
  <input type="hidden" name="_action" id="_action" value="patch" resource-type="article" attribute="title" url="/articles/6">
</span>
```

1. resource-type - The type of resource being edited
2. attribute - The specific field for the given resource that should be updated.
3. url - The Route for the given resource (in this case the articles resource with an ID of 6)


1. Make Content Editable View Partial:

```html
<span class='editable-text-container'>
  <span class='editable-text' contentEditable><%= value %></span>
  <input id='_action'
         type='hidden'
         name='_action'
         value='patch'
         resource-type='<%= resource_type %>'
         attribute='<%= attribute %>'
         url='<%= url %>'
  >
</span>
```

2. Helper Method

```ruby
def editable_text_for(resource, attribute)
  render partial: "partials/editable_text.html.erb", locals: {
    value: resource.send(attribute),
    resource_type: resource_type(resource),
    attribute: attribute,
    url: convential_url_for(resource)
  }
end

private

def convential_url_for(resource)
  "/#{resource_type(resource).pluralize}/#{resource.id}"
end

def resource_type(resource)
  resource.class.name.downcase
end
```

3. Javascript

```javascript
function sendPatchRequest(url, resourceType, attribute, updatedValue, jsKey) {
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
}

// Update a specific attribute of a resource.
function patchResource(e) {
  const editableText = e.currentTarget;
  const editableTextContainer = editableText.parentNode;
  const action = editableTextContainer.querySelector("[name='_action']");

  const url = action.getAttribute('url');
  const resourceType = action.getAttribute('resource-type');
  const attribute = action.getAttribute('attribute');
  const updatedValue = editableText.innerText;

  this.sendPatchRequest(url, resourceType, attribute, updatedValue)
}
```

```javascript
function ready () {
  document.querySelectorAll('.editable-text').forEach((editableText) => {
    // Send patch request when editable text field is exited.
    editableText.addEventListener('focusout', (e) => {
      const target = e.currentTarget
      DynamicText.patchResource(target);
    });
  });
}
```

```css
```
