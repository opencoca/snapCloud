local config = require('lapis.config')

config({'development', 'staging', 'production', 'test'}, {
    postgres = {
        host = os.getenv('DATABASE_HOST') or '127.0.0.1',
        port = os.getenv('DATABASE_PORT') or '5432',
        user = os.getenv('DATABASE_USERNAME') or 'cloud',
        password = os.getenv('DATABASE_PASSWORD') or 'password',
        database = os.getenv('DATABASE_NAME') or 'snapcloud'
    },
    session_name = 'snapsession',

    -- Exception monitoring: leave empty to avoid forwarding errors.
    sentry_dsn = os.getenv('SENTRY_DSN'),
    -- Used to tag exceptions with the current commit or tag.
    -- Example: export RELEASE_SHA=$(git rev-parse --short HEAD)
    release_sha = os.getenv('RELEASE_SHA'),

    -- Change to the relative (or absolute) path of your disk storage
    -- directory.  Note that the user running Lapis needs to have
    -- read & write permissions to that path.
    store_path = os.getenv('PROJECT_STORAGE_PATH') or 'store',

    -- for sending email
    mail_user = os.getenv('MAIL_SMTP_USER') or 'cloud',
    mail_password = os.getenv('MAIL_SMTP_PASSWORD') or 'cloudemail',
    mail_server = os.getenv('MAIL_SMTP_SERVER') or '127.0.0.1',
    mail_from_name = "Codezy Snap!Cloud",
    mail_from = "noreply@codezy.org",
    mail_footer = "<br/><br/><p><small>Please do not reply to this email. This message was automatically generated by the Codezy Snap!Cloud. To contact an actual human being, please write to <a href='mailto:contact@codezy.org'>contact@codezy.org</a></small></p>",

    discourse_sso_secret = os.getenv('DISCOURSE_SSO_SECRET'),
    worker_connections = os.getenv('WORKER_CONNECTIONS') or 1024,

    stat_arguments = os.getenv('STAT_ARGS') or '-c %Y',

    hostname = os.getenv('HOSTNAME') or 'localhost',
    secondary_hostname = os.getenv('SECONDARY_HOSTNAME') or 'localhost',
    maintenance_mode = os.getenv('MAINTENANCE_MODE') or 'false',

    measure_performance = true,
    logging = {
        queries = true,
        requests = true,
        server = true,
    }
})

config({'development', 'test'}, {
    use_daemon = 'off',
    site_name = 'dev | Snap Cloud',
    port = os.getenv('PORT') or 8080,
    mail_smtp_port = os.getenv('MAIL_SMTP_PORT') or 1025,
    dns_resolver = '8.8.8.8',
    code_cache = 'off',
    num_workers = 1,
    log_directive = 'stderr debug',
    secret = os.getenv('SESSION_SECRET_BASE') or 'this is a secret',

    -- development needs no special SSL or cert config.
    primary_nginx_config = 'locations.conf',
    -- empty string when no additional configs are included.
    secondary_nginx_config = ''
})

config({'test'}, {
    postgres = {
        database = 'snapcloud_test'
    },
    store_path = 'store/test',
})

config({'production', 'staging'}, {
    use_daemon = 'on',
    port = os.getenv('PORT') or 80,
    mail_smtp_port = 587,
    dns_resolver = '67.207.67.2 ipv6=off',

    secret = os.getenv('SESSION_SECRET_BASE'),
    code_cache = 'on',

    log_directive = 'logs/error.log warn',
})

config('production', {
    site_name = 'Snap Cloud',
    num_workers = 8,
    primary_nginx_config = 'http-only.conf',
    secondary_nginx_config = 'include nginx.conf.d/ssl-production.conf;',

    logging = {
        queries = false,
        requests = true,
        server = true,
    }
})

config('staging', {
    site_name = 'staging | Snap Cloud',
    -- the staging server is a low-cpu server.
    num_workers = 2,
    primary_nginx_config = 'http-only.conf',
    secondary_nginx_config = 'include nginx.conf.d/ssl-staging.conf;'
})
