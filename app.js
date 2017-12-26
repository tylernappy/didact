'use strict';

const handlebars = require('koa-handlebars');
const markdown = require('helper-markdown');
const staticfiles = require('koa-static');
const session = require('koa-session');
const bodyParser = require('koa-bodyparser');

const routes = require('./routes');

module.exports = function(port, statsdConfig) {
    const Koa = require('koa');
  const app = new Koa({
    port,
    statsdPrefix: `${process.env.NODE_ENV}`,
    statsdHost: statsdConfig.host,
    statsdPort: statsdConfig.port
  });

  const koaRouter = require('koa-router');
   const router = koaRouter();

  app.use(staticfiles('./static', {maxage: 60 * 60 * 24}));

  app.use(bodyParser());

  require('./auth');
  const passport = require('koa-passport');
  app.use(passport.initialize());
  app.use(passport.session());

  app.use(handlebars({
    defaultLayout: 'base',
    cache: process.env.NODE_ENV === 'production',
    helpers: {
      'markdown': markdown({ html: true }),
      'ifeq': function(a, b, opts) {
        if (a === b) {
          return opts.fn(this);
        } else {
          return opts.inverse(this);
        }
      }
    }
  }));

  app.use(routes().routes());

  //
  // Authentication
  app.use(router.get('/', function(ctx) {
      ctx.type = 'html'
      ctx.body = fs.createReadStream('views/login.html')
    }))

    app.use(route.post('/custom', function(ctx) {
      return passport.authenticate('local', function(err, user, info, status) {
        if (user === false) {
          ctx.body = { success: false }
          ctx.throw(401)
        } else {
          ctx.body = { success: true }
          return ctx.login(user)
        }
      })(ctx)
    }))

    // POST /login
    app.use(router.post('/login',
      passport.authenticate('local', {
        successRedirect: '/app',
        failureRedirect: '/'
      })
    ))

    app.use(router.get('/logout', function(ctx) {
      ctx.logout()
      ctx.redirect('/')
    }))

    app.use(router.get('/auth/facebook',
      passport.authenticate('facebook')
    ))

    app.use(router.get('/auth/facebook/callback',
      passport.authenticate('facebook', {
        successRedirect: '/app',
        failureRedirect: '/'
      })
    ))

    app.use(router.get('/auth/twitter',
      passport.authenticate('twitter')
    ))

    app.use(router.get('/auth/twitter/callback',
      passport.authenticate('twitter', {
        successRedirect: '/app',
        failureRedirect: '/'
      })
    ))

    app.use(router.get('/auth/google',
      passport.authenticate('google')
    ))

    app.use(router.get('/auth/google/callback',
      passport.authenticate('google', {
        successRedirect: '/app',
        failureRedirect: '/'
      })
    ))

    // Require authentication for now
    app.use(function(ctx, next) {
      if (ctx.isAuthenticated()) {
        return next()
      } else {
        ctx.redirect('/')
      }
    })

    app.use(router.get('/app', function(ctx) {
      ctx.type = 'html'
      ctx.body = fs.createReadStream('views/app.html')
    }))
  //
  //

  return app;
};
