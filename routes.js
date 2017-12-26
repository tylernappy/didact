'use strict';

const koaRouter = require('koa-router');

module.exports = function() {
  const router = koaRouter();

  // Middleware for identifying partner-specific subpaths
  router.use(function *(next) {
    if (/\/publishers\//.test(this.request.path)) {
      this.request.isPublisherSubpath = true;
    } else if (/\/merchants\//.test(this.request.path)) {
      this.request.isMerchantSubpath = true;
    }

    yield next;
  });

  router.get('/', function *() {
    yield this.render('index', {
      title: 'Didact'
    });
  });

  router.get('/publishers', function *() {
    yield this.render('publishers', {
      title: 'Publishers',
      os: 'ios'
    });
  });

  router.get('/merchants', function *() {
    yield this.render('merchants', {
      title: 'Merchants',
      os: 'ios'
    });
  });

  // TODO handle root path
  router.get(/^\/guides(?:\/|$)/, function *() {
    const path = this.request.url.replace(/^\/guides\//, '');
    const guide = yield TemplateCache.get(path);

    if (guide === null) {
      this.status = 404;

      yield this.render('error', {
        status: this.status
      });

      return;
    }

    const alts = guide.alternates.map(alt => {
      return {
        href: this.request.url.replace(`/${guide.os}/`, `/${alt}/`),
        label: formatPlatform(alt)
      };
    });

    yield this.render('guide', {
      partnerType: this.request.isPublisherSubpath ? 'publishers' : 'merchants',
      os: guide.os,
      title: guide.title,
      content: guide.content,
      alternates: alts,
      guide: guide.guide
    });
  });

  // Error handling not for guides (MUST BE LAST ROUTE)
  router.get(/\/[^]*/, function *() {
    yield this.render('error', {
      status: this.status
    });
  });

  return router;
};
