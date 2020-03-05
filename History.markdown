## 1.6.0 / 2020-03-05

### Minor Enhancements

  * Allow configuring base URL in page front matter (#72)
  * Incorporate document data only if it has override (#73)

### Development Fixes

  * ci: test against Jekyll 4.0
  * style: target Ruby 2.4
  * ignore vendor/bundle

### Bug Fixes

  * Support handling body tag across multiple lines (#70)

## 1.5.1 / 2019-03-23

### Bug Fixes

  * Re-introduce Ruby 2.3 support and test with Jekyll 3.7 and beyond (#69)

## 1.5.0 / 2019-03-22

### Development Fixes

  * Allow Jekyll v4 (still alpha)
  * Drop support for Ruby 2.3
  * chore(deps): rubocop-jekyll 0.3 (#65)
  * Reintroduce style checks (#67)

## 1.4.1 / 2018-08-08

### Bug Fixes

  * Do not match the body tag eagerly (#64)

## 1.4.0 / 2018-05-02

### Minor Enhancements

  * Drop support for Ruby 2.2.x (#61)
  * Relax version constraint on ActiveSupport (#60)
  * Bump Rubocop to 0.55 (#61)
  * Drop dependency on ActiveSupport (#63)
  * Parse only content necessary to mentionify doc (#59)

## 1.3.0 / 2018-03-14

### Development Fixes

  * Add rubocop to script/cibuild (#44)
  * Rubocop: autocorrect (#49)
  * Define path with __dir__ (#46)
  * Test against latest Rubies (#53)
  * Use a version constant (#54)
  * Use default Rake tasks and scripts (#55)

### Documentation

  * Use `plugins` key by default (#50)

### Minor Enhancements

  * Allow underscores in usernames (#57)
  * Mentionify only relevant docs or pages (#56)

## 1.2.0 / 2016-08-29

### Development Fixes

  * Inherit Jekyll's rubocop config for consistency (#38)

### Minor Enhancements

  * Add support for building the base URL from ENV on Enterprise (#40)

## 1.1.3 / 2016-06-28

  * Allow uppercase chars in username (#33)

## 1.1.2 / 2016-03-19

  * Don't strip html, body, and head tags (#29)

## 1.1.1 / 2016-03-09

  * Handle subclassing of Jekyll::Page (#28)

## 1.1.0 / 2016-03-08

  * jekyll-mentions as a hook: better guarding against accidents (#27)

## 1.0.1 / 2016-02-16

  * Don't double-mention in Jekyll > 3.0.0 (#25)

## 1.0.0 / 2015-10-30

  * Jekyll 3.x support (#22)
  * HTML Pipeline 2.2 (#22)

## 0.2.1 / 2014-12-18

  * Fix for undefined variable error (#20)

## 0.2.0 / 2014-12-01

  * Mentionify collection documents. (#19)

## 0.1.3 / 2014-07-30

  * Allow mention from a different base url than https://github.com (#14)

## 0.1.2 / 2014-07-10

  * URLs ending in '/' also indicate and HTML page. (#13)

## 0.1.1 / 2014-06-23

  * Only mentionify the page if it's an HTML page (#11)

## 0.1.0 / 2014-05-06

  * Support for Jekyll 2.0 (#8)
