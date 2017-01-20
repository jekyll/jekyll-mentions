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
gems:
  - jekyll-mentions
```

In any page or post, use @mentions as you would normally, e.g.

```markdown
Hey @benbalter, what do you think of this?
```

**Note**: Jekyll Mentions simply turns the @mentions into links, it does not notify the mentioned user.

## Configuration

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
gems:
  - jekyll-mentions

jekyll-mentions:
  base_url: https://twitter.com
```  

Et voilà! Your mentions will now use that base URL instead of the default of `https://github.com`.
