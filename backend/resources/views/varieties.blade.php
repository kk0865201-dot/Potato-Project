@extends('layouts.app')

@section('title', 'Potato Varieties — The Potato Project')
@section('description', 'Starchy, waxy and all-purpose potatoes compared: Russet, Yukon Gold, red, fingerling, purple Vitelotte and Maris Piper, with the best uses for each.')
@section('footer-about', 'Photography courtesy of Wikimedia Commons contributors.')

@section('content')
  <section class="page-hero">
    <div class="container">
      <span class="eyebrow">The catalogue</span>
      <h1>A potato for every plate</h1>
      <p class="lead">There are thousands of varieties, but most fall into three camps. Knowing which is which is the single biggest upgrade you can make to your cooking.</p>
    </div>
  </section>

  <!-- starch types -->
  <section class="section">
    <div class="container">
      <div class="grid grid--3">
        <div class="feature" data-reveal>
          <h3 style="color:var(--skin-600)">Starchy / Floury</h3>
          <p>High starch, low moisture. They turn light and fluffy, soaking up butter and oil. Best for baking, mashing and frying. They fall apart if boiled too long.</p>
        </div>
        <div class="feature" data-reveal>
          <h3 style="color:var(--sprout-600)">Waxy</h3>
          <p>Low starch, high moisture. They hold their shape after cooking, staying firm and glossy. Ideal for salads, gratins, boiling and roasting whole.</p>
        </div>
        <div class="feature" data-reveal>
          <h3 style="color:var(--gold-500)">All-purpose</h3>
          <p>A middle ground that does a bit of everything competently. The safe choice when a recipe just says "potatoes".</p>
        </div>
      </div>
    </div>
  </section>

  <!-- variety cards -->
  <section class="section section--tint">
    <div class="container">
      <div class="center" data-reveal><span class="eyebrow">{{ $varieties->count() }} to know</span><h2>Meet the line-up</h2></div>
      <div class="grid grid--3 mt-2">
        @foreach ($varieties as $variety)
        <article class="card" data-reveal>
          <div class="card-img"><img src="{{ asset($variety->image) }}" alt="{{ $variety->image_alt }}" /></div>
          <div class="card-body">
            <span class="tag {{ $variety->tag_class }}">{{ $variety->type }}</span>
            <h3>{{ $variety->name }}</h3>
            <p>{{ $variety->description }}</p>
            <p><strong>Best for:</strong> {{ $variety->best_for }}.</p>
          </div>
        </article>
        @endforeach
      </div>
    </div>
  </section>

  <!-- pick guide -->
  <section class="section">
    <div class="container split">
      <div data-reveal>
        <span class="eyebrow">Quick rule of thumb</span>
        <h2>How to choose in five seconds</h2>
        <p>If you want it to <strong>hold together</strong> — a salad, a gratin, boiled new potatoes — reach for waxy. If you want it <strong>light and fluffy</strong> — mash, bakers, chips — reach for starchy. When in doubt, an all-purpose like Yukon Gold rarely lets you down.</p>
        <div class="pill-row">
          <span class="pill">Float test: starchy potatoes sink</span>
          <span class="pill">Greener skin = store darker</span>
          <span class="pill">Firm, no give = fresh</span>
        </div>
        <a class="btn btn--dark" href="{{ route('recipes') }}">Put them to work</a>
      </div>
      <div data-reveal><img src="{{ asset('assets/photos/harvest.jpg') }}" alt="Freshly harvested potatoes" style="border-radius:var(--radius);box-shadow:var(--shadow-md)" /></div>
    </div>
  </section>
@endsection
