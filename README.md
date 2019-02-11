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

```ruby
<%= editable_text_for(@article, :title) %>
```

### 2 - Render Dynamic Content that Updates In Real Time with Editable Content

You might not want all of the text for a specific attribute of a specific resource to be editable. For example, you might want to display the title for a blog post in both an 'h1' tag above the body of the post, as well as the navigation bar on the top of the screen.

In this case, you might want the text to be editable when pressed on in the main article section of the page, but not in the header. However, you probably still want the text in the header to change in real time if a user edits the title from within the article section.

You can use the following method to identify content that isn't editable but updates in real time when changes are made to the attribute of the resource somewhere else on the page.

```ruby
<%= dynamic_text_for(@article, :title) %>
```

### Why Does It Do It?

Long ago, in the Wild West of software, the key ingredient for a successful app was functionality. Every idea was unique back then, and the potential of apps and websites was virtually untapped.

Nowadays, almost everything has been done. In order to gain an edge on competitors, one of the best thing you can do is to look for ways to provide a better user experience.

I believe the days of pure CRUD apps in consumer facing applications are numbered, users no longer want to navigate through completely separate pages for specific actions on specific resources. Users want pages that provide information and actions for many different resources at once in an intuitive and easy-to-navigate manner (think 'dashboard' pages).

This gem is built as a way to merge the 'edit' page and the 'show' page for a given resource, so users can update content in real time just by clicking on the text that displays that information.

For example, you could use this gem to merge the display text and edit field for the title of a blog post, so the H1 tag on the show page merges with the <input type='text'> tag in the edit form, removing the necessity for a separate edit page to update that information.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
