# coding: utf-8

import os
from settings import ZDS_APP, INSTALLED_APPS

DEBUG = True
USE_L10N = True

SECRET_KEY = '${SECRET_KEY}'

THUMBNAIL_OPTIMIZE_COMMAND = {
    'png': '/usr/bin/optipng {filename}',
    'gif': '/usr/bin/optipng {filename}',
    'jpeg': '/usr/bin/jpegoptim {filename}'
}

ZDS_APP['member']['anonymous_account'] = 'anonyme'
ZDS_APP['member']['external_account'] = 'Auteur externe'
ZDS_APP['member']['bot_account'] = 'Clem'

ZDS_APP['site']['googleAnalyticsID'] = '${GA_ID}'
ZDS_APP['site']['googleTagManagerID'] = '${GTM_ID}'

ZDS_APP['forum']['beta_forum_id'] = 23
TOP_TAG_MAX = 5

ZDS_APP['site']['url'] = '${SITE_URL}'

# ZDS_APP['content']['build_pdf_when_published'] = False

INSTALLED_APPS += ('raven.contrib.django.raven_compat',)

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': '${DB_NAME}',
        'USER': '${DB_USER}',
        'PASSWORD': '${DB_PASS}',
        'HOST': 'localhost',
        'PORT': '',
        'CONN_MAX_AGE': 600,
    }
}

SDZ_TUTO_DIR = '/home/zds/tutos_sdzv3/Sources_md'

ALLOWED_HOSTS = ['*']

PANDOC_LOC = '/usr/bin/'

EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
EMAIL_USE_TLS = False
EMAIL_HOST = 'smtp.zestedesavoir.com'
EMAIL_PORT = 25
EMAIL_HOST_USER = 'site@zestedesavoir.com'
EMAIL_HOST_PASSWORD = '${EMAIL_PASS}'

CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
        'LOCATION': '127.0.0.1:11211',
    }
}
SESSION_ENGINE = 'django.contrib.sessions.backends.cached_db'
PANDOC_LOG = '/var/log/zestedesavoir/pandoc-${VERSION}.log'
PANDOC_LOG_STATE = True

LOGGING = {
   'version': 1,
   'disable_existing_loggers': True,
   'formatters': {
       'verbose': {
           'format': '[%(levelname)s] -- %(asctime)s -- %(module)s : %(message)s'
       },
       'simple': {
           'format': '[%(levelname)s] %(message)s'
       },
   },
   'handlers': {
       'django_log':{
           'level': 'WARNING',
           'class': 'logging.FileHandler',
           'filename': '/var/log/zestedesavoir/django-${VERSION}.log',
           'formatter': 'verbose'
       },
       'generator_log':{
           'level': 'WARNING',
           'class': 'logging.FileHandler',
           'filename': '/var/log/zestedesavoir/generator-${VERSION}.log',
           'formatter': 'verbose'
       },
       'mail_admins': {
           'level': 'ERROR',
           'class': 'django.utils.log.AdminEmailHandler',
       }
   },
   'loggers': {
       'django': {
           'handlers': ['django_log'],
           'propagate': True,
           'level': 'WARNING',
       },
       'django.request': {
           'handlers': ['mail_admins', 'django_log'],
           'level': 'ERROR',
           'propagate': False,
       },
       'generator': {
           'handlers': ['generator_log'],
           'level': 'WARNING',
       }
   }
}

RAVEN_CONFIG = {
    'dsn': '${RAVEN_DSN}',
}

SOCIAL_AUTH_PIPELINE = (
    'social.pipeline.social_auth.social_details',
    'social.pipeline.social_auth.social_uid',
    'social.pipeline.social_auth.auth_allowed',
    'social.pipeline.social_auth.social_user',
    'social.pipeline.user.get_username',
    'social.pipeline.social_auth.associate_by_email',
    'social.pipeline.user.create_user',
    'zds.member.models.save_profile',
    'social.pipeline.social_auth.associate_user',
    'social.pipeline.social_auth.load_extra_data',
    'social.pipeline.user.user_details'
)


SOCIAL_AUTH_FACEBOOK_KEY = '${FB_KEY}'
SOCIAL_AUTH_FACEBOOK_SECRET = '${FB_SECRET}'

SOCIAL_AUTH_TWITTER_KEY = '${TWITTER_KEY}'
SOCIAL_AUTH_TWITTER_SECRET = '${TWITTER_SECRET}'

SOCIAL_AUTH_GOOGLE_OAUTH2_KEY = '${GOOGLE_KEY}'
SOCIAL_AUTH_GOOGLE_OAUTH2_SECRET = '${GOOGLE_SECRET}'

SOCIAL_AUTH_SANITIZE_REDIRECTS = False

STATICFILES_STORAGE = 'django.contrib.staticfiles.storage.CachedStaticFilesStorage'

SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTOCOL', 'https')
