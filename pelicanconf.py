#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals

AUTHOR = u'Leigh Appel'
SITENAME = u'Leigh Appel'
SITEURL = 'http://www.leighappel.com'

TIMEZONE = 'Australia/Brisbane'

DEFAULT_LANG = u'en'

# Feed generation is usually not desired when developing
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None

STATIC_PATHS = ['javascript', 'code', 'images']


DEFAULT_CATEGORY=('Articles')

# Blogroll
LINKS = (('Hacker News', 'http://news.ycombinator.com'),
            ('Hack and Heckle', 'http://hackandheckle.com'),)

# Social widget
SOCIAL = (('GitHub', 'https://github.com/abarax'),
          ('Pinboard', 'http://pinboard.in/u:abarax'),
          ('Twitter', 'https://twitter.com/abarax'),)

DEFAULT_PAGINATION = 10

# Uncomment following line if you want document-relative URLs when developing
#RELATIVE_URLS = True

DISQUS_SITENAME = "leighappelblog"
GOOGLE_ANALYTICS = "UA-39498444-1"
