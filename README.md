# Jekyll Mentions

@mentionable support for your Jekyll site

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
