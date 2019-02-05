# Welcome to Dynamic Text
Create a more seamless integration between displaying information and editing it! With Dynamic Text, you can allow users to easily update elements of a resource in your app just by clicking on the text and changing it, no separate edit page needed!

## Build Status
[![Build Status](https://travis-ci.org/JoshHadik/dynamic_text.svg?branch=master)](https://travis-ci.org/JoshHadik/dynamic_text)

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'dynamic_text'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install dynamic_text
```

## What does it do?

Dynamic Text allows you to do two main things:

### 1 - Render Editable Content Based on a Resource and Attribute

With the dynamic_text gem, you can easily create a hybrid HTML element that acts as both the display text for a specific attribute of a resource, and the text box for updating that attribute.

```html
<div>
  <%= editable_text_for(@article, :title) %>
</div>
```

### 2 - Render Dynamic Content that Updates In Real Time with Editable Content

Sometimes you display the same attribute of a given resource in multiple places on the same screen. For example, the title of an article might be displayed in big text above the content of the article as well as in the header of the page:



In this case, you might want the text to be editable when pressed on in the main article section of the page, but not in the header. However, you probably still want the text in the header to change in real time if a user edits the title of the article:

To make dynamic text that changes in real time, but isn't editable, use dynamic_text_for:

```html
<div>
  <%= dynamic_text_for(@article, :title) %>
</div>
```

### View the Demo


### Why Does It Do It?


### How Can You Use It?

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
