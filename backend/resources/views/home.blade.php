@extends('layouts.app')

@section('title', "The Potato Project — A Field Guide to the World's Favourite Tuber")
@section('description', 'An interactive guide to the potato: explore a 3D tuber, browse varieties, nutrition, recipes, history and a complete growing guide.')

@push('head')
  <script type="importmap">
  {
    "imports": {
      "three": "{{ asset('js/vendor/three/three.module.js') }}",
      "three/addons/": "{{ asset('js/vendor/three/addons') }}/"
    }
  }
  </script>
@endpush

@section('content')
  <!-- ============ HERO with 3D model ============ -->
  <section class="hero">
    <div class="container hero-grid">
      <div class="hero-copy">
        <span class="eyebrow">Solanum tuberosum</span>
        <h1>Meet the <span>potato</span> — humble, ancient, endlessly useful.</h1>
        <p class="lead">Spin, zoom and explore a true-to-life tuber in 3D. Then dig into varieties, nutrition, recipes and a step-by-step growing guide for the crop that feeds the world.</p>
        <div class="hero-cta">
          <a class="btn btn--primary" href="{{ route('varieties') }}">Explore varieties</a>
          <a class="btn btn--dark" href="{{ route('recipes') }}">Browse recipes</a>
        </div>
        <div class="hero-stats">
          <div class="stat"><strong>4,000+</strong><span>Native varieties</span></div>
          <div class="stat"><strong>#4</strong><span>Global food crop</span></div>
          <div class="stat"><strong>8,000</strong><span>Years cultivated</span></div>
        </div>
      </div>

      <div class="viewer-wrap">
        <div class="viewer" id="potato-viewer">
          <div class="viewer-hint">Drag to rotate &middot; scroll to zoom</div>
          <div class="viewer-loading" id="viewer-loading">
            <div><div class="viewer-spinner"></div>Loading the potato&hellip;</div>
          </div>
          <div class="viewer-toolbar">
            <button id="btn-rotate" title="Toggle auto-rotate" aria-label="Toggle auto-rotate">&#10227;</button>
            <button id="btn-zoom-in" title="Zoom in" aria-label="Zoom in">+</button>
            <button id="btn-zoom-out" title="Zoom out" aria-label="Zoom out">&minus;</button>
            <button id="btn-reset" title="Reset view" aria-label="Reset view">&#8634;</button>
          </div>
        </div>
        <div class="viewer-tooltip" id="viewer-tooltip"></div>
      </div>
    </div>
  </section>

  <!-- ============ Why potatoes ============ -->
  <section class="section">
    <div class="container">
      <div class="center" data-reveal>
        <span class="eyebrow">Why it matters</span>
        <h2>One crop, a thousand jobs</h2>
        <p class="lead mx-auto" style="text-align:center">From Andean terraces to industrial fields, the potato delivers more calories per acre, faster, than almost any staple on Earth.</p>
      </div>
      <div class="grid grid--4 mt-2">
        <div class="feature" data-reveal>
          <div class="feature-ico"><img src="{{ asset('assets/img/logo.gif') }}" alt="" /></div>
          <h3>Nutrient-dense</h3>
          <p>More potassium than a banana, plus vitamin C, B6 and resistant starch.</p>
        </div>
        <div class="feature" data-reveal>
          <div class="feature-ico"><img src="{{ asset('assets/img/logo.gif') }}" alt="" /></div>
          <h3>Productive</h3>
          <p>Yields more food per hectare, in less time, than wheat, rice or maize.</p>
        </div>
        <div class="feature" data-reveal>
          <div class="feature-ico"><img src="{{ asset('assets/img/logo.gif') }}" alt="" /></div>
          <h3>Adaptable</h3>
          <p>Grown in over 150 countries, from sea level to 4,000 m in the Andes.</p>
        </div>
        <div class="feature" data-reveal>
          <div class="feature-ico"><img src="{{ asset('assets/img/logo.gif') }}" alt="" /></div>
          <h3>Versatile</h3>
          <p>Boil, bake, mash, roast or fry — one tuber, endless dinners.</p>
        </div>
      </div>
    </div>
  </section>

  <!-- ============ Varieties preview ============ -->
  <section class="section section--tint">
    <div class="container">
      <div class="split">
        <div data-reveal>
          <span class="eyebrow">A rainbow underground</span>
          <h2>Not all potatoes are created equal</h2>
          <p>Starchy or waxy, gold or violet, marble-sized or fist-sized — each variety has a job in the kitchen. Pick the right one and a good dish becomes a great one.</p>
          <div class="pill-row">
            <span class="pill">Starchy &middot; bakers &amp; fries</span>
            <span class="pill">Waxy &middot; salads &amp; boiling</span>
            <span class="pill">All-purpose</span>
          </div>
          <a class="btn btn--dark" href="{{ route('varieties') }}">See all varieties</a>
        </div>
        <div class="grid grid--2" data-reveal>
          @foreach ($featuredVarieties as $variety)
          <div class="card">
            <div class="card-img"><img src="{{ asset($variety->image) }}" alt="{{ $variety->image_alt }}" /></div>
            <div class="card-body"><span class="tag {{ $variety->tag_class }}">{{ $variety->type }}</span><h3>{{ $variety->name }}</h3><p>{{ Str::limit($variety->description, 75) }}</p></div>
          </div>
          @endforeach
        </div>
      </div>
    </div>
  </section>

  <!-- ============ Recipes preview ============ -->
  <section class="section">
    <div class="container">
      <div class="center" data-reveal>
        <span class="eyebrow">From the kitchen</span>
        <h2>Five ways to a better potato</h2>
      </div>
      <div class="grid grid--3 mt-2" data-reveal>
        @foreach ($featuredRecipes as $recipe)
        <a class="card" href="{{ route('recipes') }}#{{ $recipe->slug }}">
          <div class="card-img"><img src="{{ asset($recipe->image) }}" alt="{{ $recipe->image_alt }}" /></div>
          <div class="card-body"><span class="tag {{ $recipe->tag_class }}">{{ $recipe->tag_label }}</span><h3>{{ $recipe->title }}</h3><p>{{ $recipe->summary }}</p></div>
        </a>
        @endforeach
      </div>
      <div class="center mt-2"><a class="btn btn--primary" href="{{ route('recipes') }}">All recipes</a></div>
    </div>
  </section>

  <!-- ============ Nutrition band ============ -->
  <section class="section section--soil">
    <div class="container split">
      <div data-reveal>
        <span class="eyebrow">Good for you</span>
        <h2>A surprisingly complete food</h2>
        <p>A medium potato, skin on, delivers steady energy, more potassium than a banana, nearly half your daily vitamin C, and only about 110 calories. The skin alone carries most of its fibre.</p>
        <a class="btn btn--ghost" href="{{ route('nutrition') }}">See the full breakdown</a>
      </div>
      <div data-reveal>
        <div class="nutri-panel" style="margin-left:auto">
          <h3 style="color:var(--soil-800)">Per medium potato (173&nbsp;g)</h3>
          <div class="nutri-row major thick" style="color:var(--ink)"><span>Calories</span><span>110</span></div>
          <div class="nutri-row" style="color:var(--ink)"><span>Carbohydrate</span><span>26 g</span></div>
          <div class="nutri-row" style="color:var(--ink)"><span>Fibre</span><span>2 g</span></div>
          <div class="nutri-row" style="color:var(--ink)"><span>Protein</span><span>3 g</span></div>
          <div class="nutri-row" style="color:var(--ink)"><span>Potassium</span><span>620 mg</span></div>
          <div class="nutri-row" style="color:var(--ink)"><span>Vitamin C</span><span>45% DV</span></div>
          <div class="nutri-row major" style="color:var(--ink);border:none"><span>Fat</span><span>0 g</span></div>
        </div>
      </div>
    </div>
  </section>

  <!-- ============ CTA ============ -->
  <section class="section section--tint">
    <div class="container cta-band" data-reveal>
      <span class="eyebrow">Grow your own</span>
      <h2>From one seed potato to a full harvest</h2>
      <p class="lead mx-auto" style="text-align:center">No garden needed — a bucket on a balcony will do. Our guide walks you from chitting to digging in seven simple steps.</p>
      <a class="btn btn--primary" href="{{ route('growing') }}">Start the growing guide</a>
    </div>
  </section>
@endsection

@push('scripts')
  <script type="module" src="{{ asset('js/potato3d.js') }}"></script>
@endpush
