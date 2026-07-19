<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>@yield('title', "The Potato Project — A Field Guide to the World's Favourite Tuber")</title>
  <meta name="description" content="@yield('description', 'An interactive guide to the potato: varieties, nutrition, recipes, history and a complete growing guide.')" />
  <link rel="icon" type="image/gif" href="{{ asset('assets/img/logo.gif') }}" />
  <link rel="stylesheet" href="{{ asset('css/styles.css') }}" />
  @stack('head')
</head>
<body>

  <header class="site-header">
    <div class="container nav">
      <a class="brand" href="{{ route('home') }}">
        <img src="{{ asset('assets/img/logo.gif') }}" alt="" />
        The Potato Project
      </a>
      <button class="nav-toggle" aria-label="Menu" aria-expanded="false">&#9776;</button>
      <ul class="nav-links">
        <li><a href="{{ route('home') }}" @class(['active' => request()->routeIs('home')])>Home</a></li>
        <li><a href="{{ route('varieties') }}" @class(['active' => request()->routeIs('varieties')])>Varieties</a></li>
        <li><a href="{{ route('nutrition') }}" @class(['active' => request()->routeIs('nutrition')])>Nutrition</a></li>
        <li><a href="{{ route('recipes') }}" @class(['active' => request()->routeIs('recipes')])>Recipes</a></li>
        <li><a href="{{ route('history') }}" @class(['active' => request()->routeIs('history')])>History</a></li>
        <li><a href="{{ route('growing') }}" @class(['active' => request()->routeIs('growing')])>Growing</a></li>
      </ul>
    </div>
  </header>

  @yield('content')

  <footer class="site-footer">
    <div class="container">
      <div class="footer-grid">
        <div>
          <div class="footer-brand"><img src="{{ asset('assets/img/logo.gif') }}" alt="" /> The Potato Project</div>
          <p>An open, illustrated field guide to <em>Solanum tuberosum</em> — the tuber that quietly feeds the planet.</p>
        </div>
        <div>
          <h4>Explore</h4>
          <a href="{{ route('varieties') }}">Varieties</a>
          <a href="{{ route('nutrition') }}">Nutrition</a>
          <a href="{{ route('recipes') }}">Recipes</a>
        </div>
        <div>
          <h4>Learn</h4>
          <a href="{{ route('history') }}">History</a>
          <a href="{{ route('growing') }}">Growing guide</a>
          <a href="{{ route('home') }}">3D model</a>
        </div>
        <div>
          <h4>About</h4>
          <p style="font-size:.9rem">@yield('footer-about', 'Photography courtesy of Wikimedia Commons contributors. Built as an educational showcase.')</p>
        </div>
      </div>
      <div class="footer-bottom">
        <span>&copy; <span id="year">{{ date('Y') }}</span> The Potato Project</span>
        <span>Made with curiosity and starch.</span>
      </div>
    </div>
  </footer>

  <script src="{{ asset('js/main.js') }}"></script>
  @stack('scripts')
</body>
</html>
