# Jekyll Mentions

@mentionable support for your Jekyll site

[![Gem Version](https://badge.fury.io/rb/jekyll-mentions.svg)](http://badge.fury.io/rb/jekyll-mentions)
[![Build Status](https://travis-ci.org/jekyll/jekyll-mentions.svg?branch=master)](https://travis-ci.org/jekyll/jekyll-mentions)

## Usage

Add the following to your site's `Gemfile`

```
gem 'jekyll-mentions'
```

And add the following to your site's `_config.yml`

```yml
plugins:
  - jekyll-mentions
```

Note: if `jekyll --version` is less than `3.5` use:

```yml
gems:
  - jekyll-mentions
```

In any page or post, use @mentions as you would normally, e.g.

```markdown
Hey @benbalter, what do you think of this?
```

**Note**: Jekyll Mentions simply turns the @mentions into links, it does not notify the mentioned user.

## Configuration

### Within the `_config.yml`

Have your own social network? No problem. We allow you to configure the base URL of all the mentions.

To change it, add the following to your Jekyll configuration:

```yaml
jekyll-mentions:
  base_url: https://twitter.com
```

If you're lazy like me, you can use this shorthand:

```yaml
jekyll-mentions: https://twitter.com
```

An example of Twitter mentions using jekyll-mentions:

```yaml
plugins:
  - jekyll-mentions

jekyll-mentions:
  base_url: https://twitter.com
```

Et voilà! Your mentions will now use that base URL instead of the default of `https://github.com`.

### Within a page's front matter

Now do you want to override the base URL for just a single page/post? No problem. Just set the base URL for that specific page in the front matter:

```yaml
jekyll-mentions:
  base_url: https://facebook.com
```

You also can use this shorthand:

```yaml
jekyll-mentions: https://facebook.com
```

Now, every single mentions in the site will use the base URL defined in the `_config.yml`, _except_ in the file where you set the base URL to be something different.

If you wish to change the base URL for a single mention, but not every mentions in that file, then you'll have to link to the URL the old-fashioned way:

```markdown
[@benbalter](https://instagram.com/benbalter)
```

Now, let's say you have a single file where you _don't_ want your mentions to become mentionable, AKA you want that to stay plain text. You can do that by specifying `false` in the front matter of that file:

```yaml
jekyll-mentions: false
```

Now that page/post's mentions will not link to the profiles.
